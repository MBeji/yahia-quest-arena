# Poste de travail Windows — pièges vérifiés

> Playbook opérationnel (étude 25 D-7). Ces pièges ont tous été rencontrés **en vrai** sur ce
> projet ; ils ne se déduisent d'aucun fichier du repo. Un agent (ou un humain) qui les ignore
> perd du temps ou, pire, croit un faux signal. Le poste principal de Mohamed est **Windows 11**
> avec Git Bash (MSYS) ; la CI, elle, tourne sous Ubuntu — d'où les écarts ci-dessous.

## Git Bash convertit les chemins (MSYS pathconv)

Une révision git contenant `:` suivi d'un chemin est réécrite par MSYS avant d'atteindre git :

```bash
git show HEAD:.claude/settings.json      # ✗ chemin mutilé
MSYS_NO_PATHCONV=1 git show HEAD:.claude/settings.json   # ✓
```

Même précaution pour `git ls-tree <rev>:<dir>`. Symptôme : « fatal: path does not exist » sur un
fichier qui existe pourtant.

## `jq` n'est pas installé

`... | jq '.x'` renvoie du **vide silencieux** — pas une erreur. Un moniteur qui parse avec `jq`
produit donc de **faux signaux** (« aucune PR », « aucun check ») au lieu d'échouer bruyamment.

- Utiliser `gh ... --jq` (jq intégré à `gh`, lui présent) ou `node -e`.
- Corollaire : toute alarme d'un script de surveillance se **re-vérifie** avant d'agir.

## Pas de `/tmp`

`/tmp/fichier` échoue (`D:\tmp\...`). Utiliser `"$TEMP"` ou le répertoire de scratch de la session.

## `execFile("npm", …)` ne lance rien (ENOENT)

Ici npm est `npm.cmd`, que `child_process.execFile`/`spawn` **ne résout pas** — et Node refuse
depuis CVE-2024-27980 de lancer un `.cmd` sans shell. Un script Node qui appelle npm (ou tout
binaire livré en `.cmd`/`.bat` : `npx`, `tsc`, `prettier`…) lève donc `ENOENT` **sur ce poste et
pas en CI**, où l'exécutable existe.

- Passer `shell: process.platform === "win32"` — et alors **valider les arguments**, puisqu'ils
  traversent un shell (cf. `assertSafePackageNames` dans `scripts/deps/apply-patch-minor.mjs`).
- Le vrai piège n'est pas l'échec, c'est le `catch` qui l'absorbe : un `spawn` raté n'a **pas**
  de `status`, contrairement à une commande qui a tourné et rendu un code non nul. Ne tolérer
  que le second, sinon un outil qui n'a jamais démarré se lit « rien à faire » (le cas s'est
  produit sur le lot L4 de l'étude [IA → déterministe](./etude-ia-vs-deterministe.md)).

## Symlinks git

Git for Windows **désactive les symlinks par défaut**. Un `CLAUDE.md` committé en symlink se
matérialise en fichier texte de 9 octets contenant « AGENTS.md » — échec **silencieux**, l'agent
lit un fichier d'instructions vide. C'est la raison de fond du choix d'import `@AGENTS.md`
plutôt que d'un lien (étude 25 D-1) : ne jamais réintroduire de symlink dans le harness.

## Checkout partagé entre sessions parallèles

Les worktrees `.claude/worktrees/*` partagent **le même dépôt** que le checkout principal :
branches, `stash`, `reflog` et `node_modules` (jonction) sont **communs**.

- Un `git stash` ou une branche que tu n'as pas créés appartiennent probablement à une autre
  session : **ne pas supprimer** sans vérifier.
- `git branch -D` échoue si un autre worktree a la branche checked-out — c'est une protection,
  pas un bug.
- Dépendances incohérentes après un changement de branche : `npm install` (jamais `npm ci`, qui
  efface `node_modules` pour tout le monde).
- ⚠️ **`git worktree remove --force` suit les jonctions et détruit leurs CIBLES** — pas le lien,
  le dossier pointé : `node_modules` partagé, corpus monté depuis le dépôt privé. Délier
  (`rmdir` du seul lien, jamais `rm -rf`) **avant** de retirer le worktree, et vérifier les
  cibles après. Un worktree laissé en place ne coûte rien ; une cible détruite coûte une
  réinstallation complète.

## `curl` déclare la prod morte alors qu'elle va bien (révocation TLS, schannel)

Depuis ce poste, `curl https://www.na9ranal3ab.tn` peut échouer en **`HTTP 000`, code de sortie
35** (erreur TLS) alors que **la production est parfaitement saine** — le site répond dans le
navigateur et le monitor externe reste au vert. Constaté 2026-07-27, après quarante minutes
pendant lesquelles la même commande passait : de quoi conclure à une panne et déclencher un
rollback pour rien.

Cause : le `curl` de Windows utilise **schannel**, qui vérifie la révocation du certificat
(CRL/OCSP). Le DNS renvoie **deux IP d'edge** en alternance ; pour l'une des deux, cette
vérification échoue et curl abandonne **avant tout échange HTTP**. D'où un `000` qui ressemble
à une prod morte, une fois sur deux, au tirage DNS.

```bash
curl -s -o /dev/null -w '%{http_code}\n' https://www.na9ranal3ab.tn/                 # → 000, exit 35
curl -s --ssl-no-revoke -o /dev/null -w '%{http_code}\n' https://www.na9ranal3ab.tn/ # → 403 (bot guard : normal)
```

**La forme correcte depuis ce poste** réunit trois options, chacune pour une raison distincte —
les oublier produit trois faux négatifs différents :

```bash
curl -sL --ssl-no-revoke -A 'yahia-quest-arena-rollback-check' https://www.na9ranal3ab.tn/
#     │└──────────────── suit la redirection de l'hôte canonique (sinon on lit un 301/308)
#     └───────────────── (Windows) neutralise la vérification de révocation schannel
#        et -A ────────── le bot guard refuse les User-Agent « curl/ » en 403
```

Ne concerne **que** ce poste : les workflows tournent sur des runners Linux (OpenSSL, pas de
schannel), et le monitor externe n'est pas affecté. ⚠️ **Avant de déclarer la prod morte depuis
une ligne de commande Windows, confirmer dans un navigateur ou sur UptimeRobot** — deux
observateurs indépendants, dont l'un n'est pas sur cette machine.

## Le gate rougit à tort sous contention CPU

Quand plusieurs sessions lancent leur gate en même temps (constaté 2026-07-20 : 45 → 53 processus
node simultanés), `npm run verify` et le hook `pre-push` échouent sur du code qui n'a rien cassé.
Signature :

```
[vitest-pool]: Failed to start forks worker for test files …
Caused by: [vitest-pool-runner]: Timeout waiting for worker to respond
```

… durée doublée (199 s → 440 s), **moins de fichiers découverts** qu'à l'ordinaire (165 au lieu de
167), et — le plus trompeur — des échecs **nommés** dans des fichiers **sans rapport avec le diff**.
Ça ressemble trait pour trait à une régression.

**Trancher avant d'accuser le code** : relancer les fichiers nommés en isolation.

```bash
npx vitest run --maxWorkers=1 <fichiers-en-échec>
```

Vert en isolation = contention, pas régression. (`--poolOptions` n'existe plus en CLI vitest 4.)
Ce test est **obligatoire** avant de conclure à une régression quand on vient de brancher sur un
`main` plus récent : sans lui, « contention » et « vraie régression » sont indiscernables.

**Ne pas tuer les processus node** — le checkout est partagé, ce sont ceux des sessions sœurs. Si
le poste reste chargé, la sortie n'est PAS `--no-verify` : réduire le parallélisme suffit, et ne
demande l'accord de personne (voir « La sortie qui ne dégrade rien » plus bas). `--no-verify`
(DoD §2, accord explicite) ne reste utile que si même un worker unique n'arrive plus à démarrer.

### La même signature a une SECONDE cause : la mémoire libre, sans aucune session sœur

Constaté 2026-08-19 (#791) : signature identique — `Failed to start forks worker`, 30 puis 45
erreurs, **209 fichiers découverts sur 240** — mais **zéro processus node vivant**. Le conseil
ci-dessus (« ne pas les tuer, ce sont ceux des sessions sœurs ») ne s'applique alors pas, et on
cherche une contention qui n'existe pas. La cause était la **RAM libre** : ~2,7 Go, après une
session de builds. Le pool `forks` lance **un processus par worker** ; sous ce seuil ils ne
démarrent plus. Le symptôme s'aggrave au fil de la session (4 erreurs le matin, 45 le soir) parce
que la mémoire, elle, ne se rend pas.

**Discriminer en une mesure** — deux chiffres, pas une hypothèse :

```bash
tasklist //FI "IMAGENAME eq node.exe" //FO CSV | tail -n +2 | wc -l   # sessions sœurs ?
wmic OS get FreePhysicalMemory //value                                 # Ko libres
```

0 processus + mémoire basse ⇒ RAM, pas contention. Et le test qui tranche pour de bon, parce que
le pool `threads` partage **un seul** processus :

```bash
npx vitest run --pool=threads     # vert ici ⇒ ni régression, ni contention : mémoire
```

Ce jour-là : 239 fichiers / 2 699 tests verts en `threads`, quand `forks` n'en démarrait que 209.
Fermer le navigateur du panneau d'aperçu ne rend presque rien (2 764 → 2 726 Mo) : la mémoire est
prise ailleurs, hors de portée de la session. La sortie reste la même qu'au paragraphe précédent —
réduire le parallélisme, section ci-dessous.

### La sortie qui ne dégrade rien : réduire le parallélisme

Les trois causes ci-dessus se soignent **toutes** de la même façon, et sans toucher au gate.
Le hook `pre-push` n'accepte pas de drapeau CLI, mais vitest 4 applique `VITEST_MAX_WORKERS`
**après** la résolution de la config (donc elle prime sur `test.maxWorkers`), et husky hérite de
l'environnement du `git push` :

```bash
VITEST_MAX_WORKERS=2 git push -u origin <branche>
```

Mesuré le 2026-08-24 (#842, diff de deux fichiers de commentaires, ~4 Go libres, 0 session sœur) :

| Workers | Résultat                                                                  |
| ------: | ------------------------------------------------------------------------- |
|      16 | 16 erreurs de pool, 3 fichiers morts, 5 échecs nommés — tous des timeouts |
|       4 | 3 erreurs de pool, 0 échec nommé                                          |
|       2 | **263 fichiers, 3 146 tests, exit 0**                                     |

⚠️ **Réduire n'est pas un compromis, c'est un gain** : 244 s à 2 workers contre 280–374 s à 16, et
`environment` 309 s contre 2 942 s. La contention coûtait plus cher que le parallélisme ne
rapportait — donc ne pas hésiter par crainte de la durée, ni « reboucler » à l'identique en
espérant un run chanceux.

Depuis ce jour, `vitest.config.ts` **plafonne lui-même les workers hors CI** : le cas nominal n'a
plus besoin de la variable, qui reste le levier pour **remonter** sur un poste sain
(`VITEST_MAX_WORKERS=8 npm test`).

**Deux cascades à ne pas prendre pour des régressions.** Un test qui expire laisse son composant
monté : le suivant tombe en `Found multiple elements by: [data-testid=…]`. Un mock laissé à
mi-chemin donne un `expected undefined to be 'parent'`. Les deux sont des **conséquences** du
timeout voisin, dans le même fichier, et disparaissent avec lui — les compter comme des échecs
distincts fait chercher deux bugs qui n'existent pas.

### Quand les DEUX mesures reviennent vides — et ce qui reste pour trancher

Constaté 2026-08-22 : même signature, 15 erreurs — mais **0 processus node ET 5,0 Go libres**
(`FreePhysicalMemory=5250228`), soit le double du seuil de #791. Le discriminateur ci-dessus rend
donc **deux réponses négatives**, et il serait tentant d'en conclure « ni contention ni mémoire,
donc régression ». Ce serait faux : les 15 fichiers rejoués en `--maxWorkers=1` passaient tous
(480 tests, exit 0).

Deux signes restent lisibles quand les deux chiffres ne disent rien :

- **Le compte de fichiers découverts baisse pendant que la suite GROSSIT.** Ce jour-là 237, contre
  240 le matin — alors que `main` venait d'ajouter des tests entre-temps. C'est plus sûr que le
  nombre d'erreurs, qui varie. Comparer au dernier run vert de la même branche, pas à une valeur
  absolue mémorisée.
- **Aucune assertion n'échoue.** 2 447 tests verts, zéro `FAIL` nommé : une panne au démarrage tue
  des **fichiers entiers**, elle ne fait pas tomber une assertion. Si le rapport ne contient pas
  une seule ligne d'échec de test, ce n'est pas le code.

⚠️ **La réciproque est fausse, et c'est le piège suivant.** Une assertion NOMMÉE peut tomber sous
charge sans qu'il y ait la moindre régression : le 2026-08-22, `parametrage-pseudo.test.tsx` a
échoué en 15 193 ms sur un `findBy*` — un **timeout**, pas une inégalité — dans un `pre-push` dont
le diff ne contenait qu'un fichier Markdown. Rejoué seul : 6/6 vert. Le signe à lire n'est donc pas
« une assertion a été nommée » mais **la forme de l'échec** : une durée qui frôle le timeout de
Testing Library accuse la machine, une valeur reçue différente de l'attendue accuse le code.
Dans le doute, la règle ne change pas — rejouer le fichier nommé en `--maxWorkers=1` avant
d'accuser quoi que ce soit.

Le total réel se recompose alors en additionnant les deux runs (2 447 + 480 = 2 927), et le gate
est honnêtement vert — à condition de relancer aussi les étapes que le `&&` de `verify` n'a jamais
atteintes (`leak:check`, `db:check-chain`, `eol:check`), voir la section suivante.

Seul événement distinctif ce jour-là : un `npm install` de **516 paquets** quelques minutes plus
tôt (rattrapage de deux jours de dérive). Corrélation notée, **cause non établie** — l'indexation
antivirus de milliers de fichiers fraîchement écrits est une piste plausible pour un démarrage de
processus qui expire, rien de plus. Si la signature réapparaît après un gros `install`, laisser
retomber le poste quelques minutes avant de rejouer.

## Le gate annoncé vert alors qu'il est rouge (tâche de fond)

Le code de sortie d'une tâche de fond est celui de la **dernière commande de la chaîne**, pas
celui du gate. Cette forme annonce donc `exit code 0` quand `verify` a rendu 1 :

```bash
npm run verify > out.txt 2>&1; echo "EXIT=$?"; tail -25 out.txt   # ← ment
```

C'est `tail` (toujours 0) qui fixe le verdict affiché, et le `EXIT=1` utile part dans le fichier
que personne ne relit. Constaté 2026-08-17 : deux fichiers de test échouaient et `leak:check`,
`db:check-chain`, `eol:check` n'avaient **jamais tourné** — le `&&` qui chaîne les étapes de
`verify` court-circuite au premier rouge — et la session a pourtant déclaré le gate vert.

Même famille que `commande | tail` (table « Vérifier l'état, jamais le signal » du
[prod-rollback-runbook](../prod-rollback-runbook.md)), à une nuance près qui compte : **ici il
n'y a pas de pipe**. La parade « pas de pipe du tout » ne suffit donc pas.

**Mettre le gate en dernière position, rien après** :

```bash
npm run verify > out.txt 2>&1     # le code de sortie de la tâche est le sien
```

… puis lire le fichier pour le détail. Et vérifier que les **sept** étapes ont réellement tourné —
un `&&` court-circuité laisse les dernières muettes, ce qui ressemble à un gate complet :

```bash
grep -E "^> tanstack_start_ts@[0-9.]+ (lint|typecheck|test|leak:check|db:check-chain|eol:check|harness:check)$" out.txt
```

## Des CRLF invisibles dans l'arbre de travail (`npm run eol:fix`)

`.gitattributes` impose `* text=auto eol=lf`. Mais `text=auto` veut aussi dire que git
**normalise à la comparaison** : un fichier réécrit en CRLF sur le disque **après** le checkout
est différent octet à octet, alors que `git status` et `git diff` le déclarent parfaitement
propre. Le piège est invisible et il survit à chaque `pull`.

Ce n'est pas cosmétique — constaté le 2026-07-25, un même CRLF produisait **trois** symptômes
sans rapport apparent :

1. **`npm test` rouge** avec une erreur de parsing rolldown pointant dans `node_modules` : la
   transformation SSR de Vite injecte l'interop CJS **devant le shebang** d'un module CRLF, puis
   n'arrive plus à relire sa propre sortie (`.claude/hooks/precommit-checks.mjs`). `verify` étant
   le hook de pré-push, tout le gate local était rouge — la situation qui pousse au `--no-verify`
   que le DoD §2 interdit.
2. **`harness:check` « drifted »** sur les 5 miroirs `.agents/skills/*/SKILL.md` : la source
   `.claude/skills/` est en CRLF, le miroir en LF, la comparaison est octet à octet.
3. **`git rebase` refuse de démarrer** (« you have unstaged changes ») : après réécriture, git
   garde une entrée de cache stat qu'il ne sait plus confirmer.

**Ce n'est pas Prettier** (`.prettierrc` est en `endOfLine: "lf"`) : les 9 fichiers touchés sont
tous sous `.claude/` plus `CLAUDE.md`, c'est-à-dire ceux qu'écrit l'outillage agent lui-même,
qui écrit aux fins de ligne de la plateforme.

**Le remède** — `npm run eol:fix`. Il renormalise en LF **et** rafraîchit l'index
(`git add --renormalize`), donc l'arbre redevient réellement propre et rien n'est staged : le
contenu normalisé est déjà celui du blob. `npm run eol:check` (dans `verify` et `ci:verify`)
échoue désormais **avant** les tests, avec la liste des fichiers, au lieu de laisser chercher
dans une trace rolldown. Sur Linux/CI c'est un no-op.

### ⚠️ La même trace rolldown a une SECONDE cause : un Node trop vieux

Constaté le 2026-08-26. Symptôme identique au point 1 ci-dessus, au caractère près —
`RolldownError: Parse failure: Invalid Character \`!\``sur`.claude/hooks/precommit-checks.mjs:1`, shebang rejeté derrière l'interop CJS. Mais
`npm run eol:fix`a bien tourné,`eol:check`et`harness:check`sont repassés au vert, et
**l'erreur est restée**. Ce n'était pas un CRLF : le shell servait **Node 22.23.1** alors que`.nvmrc` exige **24**. La même suite passe — 28 tests — dès qu'on repasse sur le Node du socle.

Le Node 24 est déjà installé sur le poste, en `/c/Program Files/nodejs` ; c'est le shim fnm qui
le masque, `fnm list` n'ayant que `v22`. D'où le réflexe, à faire **avant** de conclure quoi que
ce soit sur ce fichier :

```bash
node -v                                        # 22.x ⇒ c'est ça, pas le CRLF
export PATH="/c/Program Files/nodejs:$PATH"    # 24.x, celui du .nvmrc et de la CI
hash -r
```

**Ce qui rend le piège coûteux, c'est qu'il ment dans les deux sens.** Le hook `pre-push`, lui,
n'est **pas** affecté : git le lance avec le PATH système, donc sous Node 24 — un push part
normalement pendant que le shell affiche un gate rouge. On peut donc croire le gate cassé alors
qu'il ne l'est pas, ou croire avoir contourné un vrai rouge alors qu'on ne l'a jamais rencontré.
Dans les deux cas la conclusion « il faut `--no-verify` » est fausse, et le DoD §2 l'interdit.

Ordre de diagnostic, donc : `node -v` d'abord, `eol:fix` ensuite, et seulement après chercher
dans le code. Contrôle négatif utile —
`npx vitest run scripts/harness/__tests__/precommit-checks.test.mjs` seul échoue à l'identique
sur un arbre **propre**, ce qui prouve que ce n'est pas le diff en cours.

Corollaire : ne plus committer le résultat d'un `npm run harness:sync` lancé pour « corriger »
une dérive de miroir sur ce poste — lancer `eol:fix` d'abord ; s'il ne reste plus de dérive,
c'était ce piège. Si un `harness:sync` a déjà réécrit le miroir : `git checkout -- .agents/skills/`.

Depuis le 2026-08-24, `harness:check` fait partie de `verify` — et il y est placé **en dernier,
après `eol:check`**, précisément à cause de ce piège : sur ce poste, un arbre sali par des CRLF
fait dire « drifted from its harness sources » à `harness:check` pendant que `git diff` reste
vide. En le faisant passer après, c'est `eol:check` qui parle le premier, avec le bon diagnostic
et le bon remède. Sur un checkout LF neuf — la CI — l'ordre est sans effet, d'où l'ordre
différent dans `ci:verify` : ce n'est pas une incohérence, c'est le poste qui est particulier.

## `npm run verify` local ≠ CI

`verify` = `lint` + `typecheck` + `test` + `leak:check` + `db:check-chain` + `eol:check` +
`harness:check`. Le job `verify` de `ci.yml` en fait un **surensemble** : il passe par
`test:coverage` (donc les **seuils de couverture**, que `test` seul n'applique pas) et ajoute
`perf:check`, `build:check` (**budgets de bundle**), `smoke:shell` et `audit:deps`.

Conséquence concrète : ajouter des clés i18n passe en local et **casse la CI** sur le budget de
bundle. Avant de pousser un changement qui touche le bundle : `npm run ci:verify`.

⚠️ Même `ci:verify` ne rejoue pas tout : `perf:check` et `smoke:shell` n'en font **pas** partie —
`smoke:shell` est le seul étage qui charge le vrai bundle de prod dans Chromium, donc le seul qui
exécute le code client gardé par `import.meta.env.PROD`. Pour les lancer avant de pousser :
`npm run perf:check && npm run smoke:shell`.

Les gates **contenu** (`content:check`, `content:qa:strict`, `content:audit:strict`) et le registre
de transcription (`programme:check`) ne tournent plus ici depuis l'étude 24 : ils sont partis avec
le corpus dans la Content CI du repo privé. Ne pas les attendre dans cette CI-ci.

Enfin, `main` exige **quatre** checks (ruleset, pas branch protection) : `verify` — le job de
`ci.yml` — plus `Migration order`, `Migration presence` (`migration-gate.yml`) et `CodeQL`
(`codeql.yml`). Ces trois-là vivent **hors** de `ci.yml` : aucun `npm run` ne les reproduit en
local. `Second opinion` (`second-opinion.yml`) tourne aussi sur les PR mais n'est **pas** requis —
c'est une garde dormante, un rouge de sa part ne bloque pas le merge.
