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

## `harness:check` rouge en local sur un checkout propre (fins de ligne)

Sur ce poste, `npm run harness:check` peut signaler les **5 miroirs** `.agents/skills/*/SKILL.md`
comme « drifted » alors que rien n'a été modifié — `git status` est propre pour la source **et**
pour le miroir. Cause : `.gitattributes` impose `* text=auto eol=lf`, donc git normalise en LF et
ne voit aucune différence, mais sur le disque la source `.claude/skills/` porte des **CRLF**
(réécrite par Prettier, dont le miroir est exclu depuis #558) tandis que le miroir reste en LF.
`harness:check` compare octet à octet → dérive. La CI (Linux, tout en LF) ne la voit jamais.

**Ne pas « corriger » en committant le résultat de `npm run harness:sync`** : le diff git est vide
(git renormalise), donc on ajoute 5 fichiers fantômes à la PR pour rien. Si un `harness:sync` a
déjà réécrit le miroir : `git checkout -- .agents/skills/`. Vérifier avec
`file .claude/skills/verify/SKILL.md` (`with CRLF line terminators` = c'est ce piège, pas une
vraie dérive).

## `npm run verify` local ≠ CI

`verify` = `lint` + `typecheck` + `test` + `leak:check` + `db:check-chain`. Le job `verify` de
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
