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

## `npm run verify` local ≠ CI

`verify` = lint + typecheck + tests. La CI ajoute `content:check`, `content:qa:strict`,
`build:check` (**budgets de bundle**), `smoke:shell`, `programme:check`, `harness:check`.
Conséquence concrète : ajouter des clés i18n passe en local et **casse la CI** sur le budget.
Avant de pousser un changement qui touche le bundle ou le contenu : lancer `npm run ci:verify`.
