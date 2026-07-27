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
le poste reste chargé, le vrai gate est la CI (le ruleset bloque le merge sans `verify`) :
demander l'accord explicite pour `--no-verify` (DoD §2) plutôt que de reboucler des tentatives à
~6 minutes.

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

Corollaire : ne plus committer le résultat d'un `npm run harness:sync` lancé pour « corriger »
une dérive de miroir sur ce poste — lancer `eol:fix` d'abord ; s'il ne reste plus de dérive,
c'était ce piège. Si un `harness:sync` a déjà réécrit le miroir : `git checkout -- .agents/skills/`.

## `npm run verify` local ≠ CI

`verify` = `lint` + `typecheck` + `test` + `leak:check` + `db:check-chain` + `eol:check`. Le job `verify` de
`ci.yml` en fait un **surensemble** : il passe par `test:coverage` (donc les **seuils de
couverture**, que `test` seul n'applique pas) et ajoute `harness:check`, `perf:check`,
`build:check` (**budgets de bundle**), `smoke:shell` et `audit:deps`.

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
