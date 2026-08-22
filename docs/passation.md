# Passation — de la fin de développement à la mise en production

Ce document décrit **le parcours complet d'une demande** dans `yahia-quest-arena`, depuis
le moment où le développement est terminé jusqu'à la production, avec chaque garde-fou
(harness) rencontré en chemin. Il complète [AGENTS.md](../AGENTS.md) (source canonique)
et [ci-cd-and-branch-protection.md](./ci-cd-and-branch-protection.md) (détail des checks
et du ruleset) — en cas de divergence, AGENTS.md gagne.

## Vue d'ensemble

```
Dev local ──► git commit ──► git push (branche)
                │                 │
           [hooks husky]     [auto-pr.yml] ──► PR READY + auto-merge armé + checks
                                  │            (opt-out WIP : [wip]/[draft] → draft)
                    ┌─────────────┴──────────────┐
                    │  Checks requis sur la PR    │
                    │  verify · Migration presence│
                    │  Migration order · CodeQL   │
                    └─────────────┬──────────────┘
                                  │
                                  │  [automerge.yml] garde la tête à jour
                                  │  (retard sur main → update auto + re-checks ;
                                  │   conflit → label needs-rebase)
                                  ▼
                    Squash-merge sur main (ruleset main-protection)
                                  │
              ┌───────────────────┼───────────────────┐
              ▼                   ▼                   ▼
        Déploiement          [db-migrate-prod]    [release.yml]
        Vercel PROD          migrations → DB prod  tag SemVer
                                  │
                    Gardes post-prod (nightly, guards…)
```

**Aucun geste humain** entre « j'ai fini de coder » et « c'est en prod » (décision
2026-07-12) : la PR s'ouvre **ready, auto-merge armé**, et merge seule quand les checks
requis sont verts sur une tête à jour. La session qui a poussé surveille ses checks
jusqu'au merge et corrige tout rouge (AGENTS.md, DoD §8). Pour un savepoint volontaire :
`[wip]` / `[draft]` dans le sujet du commit de tête (ou une branche `wip/`, `draft/`,
`rescue/`) → PR **draft**, à promouvoir plus tard avec `gh pr ready`. Le label
**`no-automerge`** gèle une PR qu'on veut retenir.

## 1. Fin de dev — garde-fous locaux (hooks git)

Avant même que le code quitte la machine (husky, installé par `npm install`) :

- **`pre-commit`** (lint-staged) : Prettier + ESLint `--fix` sur les fichiers stagés —
  aucun commit mal formaté ne peut exister.
- **`pre-push`** : `npm run verify` complet (ESLint zéro-warning + `tsc --noEmit` strict
  - la suite Vitest). Un push avec un gate rouge est refusé localement.
- Jamais de `--no-verify` sans raison explicitement documentée (AGENTS.md, DoD §2).

## 2. Push de la branche — inscription automatique en PR

- **`auto-pr.yml`** : tout push d'une branche non-`main` ouvre automatiquement sa PR
  **ready, auto-merge armé** (titre = sujet du commit de tête, corps = template du
  repo). Sur un push répété, une PR déjà ouverte ready mais non armée est ré-armée
  (self-healing) ; un draft existant n'est **jamais** promu par un push.
- Opt-out WIP (savepoint volontaire) : `[wip]` / `[draft]` / `[no-automerge]` dans le
  sujet du commit de tête, ou un préfixe de branche `wip/`, `draft/`, `rescue/` →
  PR **draft**, rien ne s'arme.

### Le piège du bot non-collaborateur (`GH_AUTOMATION_PAT`)

Une PR ouverte avec le jeton d'Actions par défaut (`GITHUB_TOKEN`) est attribuée à
l'acteur `github-actions[bot]`. Ce bot **n'est pas un collaborateur** du dépôt aux yeux
de GitHub, qui applique alors aux événements `pull_request` de cette PR **le même
mécanisme d'approbation manuelle que pour une PR venant d'un fork externe** : chaque
check requis (`verify`, `Migration presence`/`order`, `CodeQL`, ainsi que le job
`Auto-merge` lui-même) reste bloqué en « en attente d'approbation d'un mainteneur »
tant que personne ne clique « Approve and run » — d'où l'aléatoire observé (parfois un
run de secours passe avant que le run natif bloqué ne soit consulté, parfois non).

**Correctif** : provisionner un secret **`GH_AUTOMATION_PAT`** (PAT _fine-grained_,
scopé à ce seul dépôt, permissions `contents: write` + `pull requests: write` +
`workflows: write`) dans **Settings → Secrets and variables → Actions**. `auto-pr.yml`
et `automerge.yml` l'utilisent alors à la place de `GITHUB_TOKEN` : la PR (et toute mise
à jour de branche) est attribuée à un vrai compte collaborateur, jamais soumis à cette
approbation — déterministe, sans clic. Sans ce secret, les deux workflows retombent sur
`GITHUB_TOKEN` et compensent de leur mieux (re-dispatch en `workflow_dispatch`, non gaté
mais qui fait courir deux runs en parallèle sous le même nom de check — d'où le
comportement non déterministe tant que le secret n'est pas configuré).

## 3. La PR — le gate complet (4 checks requis + previews)

| Check requis         | Workflow             | Ce qu'il prouve                                                                                                                                                                                                                                                            |
| -------------------- | -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `verify`             | `ci.yml`             | lint, typecheck, tests + couverture (seuils 80 %), **gate anti-fuite** (`leak:check` : aucun corpus ni skill pédagogique ne réapparaît ici), `harness:check`, `perf:check`, build + budgets de bundle, **`smoke:shell`** (le vrai bundle prod dans Chromium), `audit:deps` |
| `Migration presence` | `migration-gate.yml` | liste les migrations qui s'auto-appliqueront à la prod au merge (aucune surprise) — informatif, toujours vert                                                                                                                                                              |
| `Migration order`    | `migration-gate.yml` | **bloque** une migration antidatée qui coincerait silencieusement l'auto-apply prod (leçon des incidents #97 → #227 → #229)                                                                                                                                                |
| `CodeQL`             | `codeql.yml`         | analyse statique de sécurité (SAST, suite `security-extended`) de tout le code JS/TS                                                                                                                                                                                       |

En parallèle, non bloquants : la **preview Vercel** (URL de test par PR) et les
annotations Code Scanning. Les suites lentes (**pgTAP**, **E2E Playwright**) ne sont pas
des gates de PR : elles tournent chaque nuit (`nightly.yml`) et à la demande.

## 4. Merge — automatique et verrouillé

- **`automerge.yml`** arme l'**auto-merge natif GitHub** (squash + suppression de
  branche) sur toute PR prête du même repo ; le label `no-automerge` désarme.
- Le merge lui-même est imposé par le **ruleset `main-protection`**
  (`.github/rulesets/main-protection.json`, importé dans Settings → Rules) : PR
  obligatoire, les 4 checks verts **sur une tête à jour** (mode strict), pas de
  force-push ni suppression de `main`, aucun bypass (admins compris).
- Si `main` avance et met une PR armée « en retard », le job **`keep-up-to-date`**
  (dans `automerge.yml`, déclenché à chaque push sur `main`) met sa branche à jour et
  redispatche ses checks — GitHub ne le fait jamais tout seul.

## 5. Merge sur `main` — mise en production sans intervention

Trois automatismes se déclenchent :

1. **Vercel** déploie la production (`scripts/build-vercel.mjs`, `vercel.json`).
2. **`db-migrate-prod.yml`** applique les nouvelles `supabase/migrations/**` à la
   **base de prod** : backup `pg_dump` préalable, garde anti-mauvaise-cible, issue
   `prod-migration-failure` ouverte le jour même en cas d'échec. **Jamais de SQL
   manuel** (AGENTS.md §7). Règle d'or : migration **additive avant** le code qui
   l'utilise ; migration **destructive** dans un merge séparé, **après** que le code
   qui utilisait l'ancienne forme est parti.
3. **`release.yml`** : si la version de `package.json` a changé, tag SemVer annoté +
   release GitHub (voir [release-tagging-policy.md](./release-tagging-policy.md)).

## 6. Après la prod — le filet de sécurité continu

- **`nightly.yml`** (chaque nuit) : E2E Playwright complet (public + authentifié sur le
  projet Supabase **TEST**, jamais la prod) + suite **pgTAP** (RLS, grants, anti-triche
  SQL) sur une DB fraîche ; issue de suivi en cas de rouge.
- **`regression-guard.yml`** (lun + jeu) : réconcilie les tests avec les changements de
  la semaine, remonte les vrais bugs (jamais en affaiblissant un test).
- **`upgrade-guard.yml`** (mar + ven, après une nightly verte) : montées de version —
  lot patch/minor auto-mergé seulement si gate complet + E2E + pgTAP verts, une PR par
  major (voir [dependency-maintenance.md](./dependency-maintenance.md)).
- **`db-backup.yml`** (sauvegardes prod), **CodeQL hebdomadaire**, **Dependabot**
  (alertes de sécurité uniquement).

> 📦 **Le contenu pédagogique ne se passe plus dans ce dépôt.** Depuis l'étude 24 (2026-07-20),
> le corpus, les skills de génération et les études vivent dans le dépôt **privé**
> `MBeji/yahia-quest-content` ; les gates contenu (`content:check`, `content:qa:strict`,
> `content:audit:strict`, `programme:check`) et l'audit planifié `content-audit.yml` y ont
> déménagé, tout comme `video-health.yml`. La Content CI privée fait un **double checkout** —
> son corpus + ce dépôt-ci pour le moteur. Le contenu n'est plus livré en migrations Supabase :
> il est appliqué par `apply-content.yml` (dépôt privé) et journalisé dans `content_releases`.
> Le passage de relais côté contenu se fait donc **là-bas** — voir
> [content-generation-pipeline.md](./content-generation-pipeline.md).

## 7. Clôture de session — ce qu'on laisse derrière soi

Le merge n'est pas la fin de la session : une session finie **proprement** ne laisse ni
demi-état, ni processus vivant, ni savoir enfermé dans la tête d'un agent. Les neuf points
ci-dessous se déroulent **après** que le merge est réel, dans cet ordre. Ils ne remplacent
aucun gate — aucun n'est automatisable, c'est justement pourquoi ils sont écrits.

1. **Le merge est réel, pas seulement affiché.** Le statut `MERGED` d'une PR dont la base était
   une autre branche ment (merge fantôme, 2026-08 : 23 figures perdues sans aucune alerte). Ce
   qui fait foi est le **contenu sur `main`**, jamais la topologie :

   ```bash
   git fetch origin main
   git log --oneline origin/main -1     # le squash est là, suffixé (#NNN)
   git ls-tree origin/main <chemin>     # le fichier livré existe dans l'arbre…
   git show origin/main:<fichier>       # …et il porte bien l'apport
   ```

   ⚠️ **Ni `git merge-base --is-ancestor`, ni `git branch --merged`.** La chaîne merge en
   **squash** (`--auto --squash --delete-branch`) : `main` reçoit un commit **neuf**, le SHA de
   la branche n'est donc ancêtre de rien et le test échoue sur **tous** les merges, y compris
   parfaitement réels — une session qui l'applique se déclare en panne à chacune de ses propres
   livraisons. La branche étant supprimée au merge, la commande peut même sortir en
   `fatal: Not a valid commit name`. Mesuré le 2026-08-22 sur la PR #802 : tête `14dfb0ae`
   squashée en `e6b8ae2d`, contenu bien présent sur `main`, `--is-ancestor` en échec.
   _(Git Bash : préfixer `MSYS_NO_PATHCONV=1` dès que le chemin commence par un point — sans
   lui, `origin/main:.github/…` part en `origin\main;.github\…` et git répond « ambiguous
   argument ».)_

   Le piège d'origine, lui, se prévient **en amont** : une PR basée sur la branche d'une autre
   PR est squashée sur une base morte. Toujours brancher sur `main`, et le vérifier plutôt que
   le supposer : `gh pr view <N> --json baseRefName` doit répondre `main`.

2. **La prod sert vraiment le changement.** Un workflow vert prouve qu'il s'est exécuté,
   pas que la surface a bougé : ouvrir la page publique concernée, ou comparer l'état
   avant/après. Un déploiement vert sur une page inchangée est un faux positif.
3. **L'arbre de travail est propre.** `git status --short` vide. Attention aux fichiers
   **générés** salis en route : `src/routeTree.gen.ts` (réordonné par un simple
   `npm run dev`), les types Supabase, `_INDEX.md` côté corpus — les restaurer, jamais les
   committer.
4. **Aucun secret recopié ne survit.** Tout `.env` copié dans un worktree pour un essai est
   supprimé ; on n'y recopie de toute façon que les clés **publiques**, jamais
   `SUPABASE_SERVICE_ROLE_KEY`.
5. **Aucun processus laissé en vie** : serveur de dev arrêté, tâches de fond terminées et
   leur sortie lue (une tâche tuée en silence a pu échouer **ou** avoir déjà tout mergé).
6. **Les branches.** La branche distante est supprimée au merge ; ramener la locale sur
   `origin/main` plutôt que la laisser pointer un commit pré-squash. Aucune branche
   `wip/`/`rescue/` orpheline oubliée derrière soi.
7. **Le savoir découvert est écrit dans le dépôt** — un piège, une règle de conduite, un
   invariant : AGENTS.md, `STATUS.md` ou `docs/agents/`. La mémoire privée d'un outil ne se
   partage pas (AGENTS.md § Multi-agent collaboration).
8. **Ce qui reste ouvert est dit** : arbitrage à valider, périmètre volontairement non
   couvert, mesure impossible depuis le poste. Dans la réponse finale — et en **issue** si
   ça doit survivre à la session.
9. **Ne jamais supprimer un worktree à l'aveugle.** `git worktree remove --force` suit les
   jonctions Windows et détruit leurs **cibles** (voir
   [agents/poste-windows.md](./agents/poste-windows.md)). Un worktree qu'on laisse en place
   ne coûte rien ; un `node_modules` ou un corpus partagé détruit coûte une réinstallation.

## 8. Quand ça casse — le retour arrière

L'automatisation qui rend la livraison gratuite rend aussi la panne **auto-entretenue** : un
rollback posé sur Vercel ne tient que jusqu'au prochain merge, qui redéploie `main` — toujours
porteur du code fautif. D'où l'ordre **non négociable** : geler la chaîne d'abord, rollbacker
ensuite.

```bash
gh workflow run rollback-prod.yml -f mode=rollback -f reason="<ce qui est cassé>"
```

Le workflow pose `MERGE_FREEZE=1`, désarme les PR déjà armées, repromeut le déploiement de
production précédent, revérifie que la prod répond, puis ouvre une issue **`prod-incident`**
portant la checklist du reste. Trois modes : `rollback`, `freeze-only`, `unfreeze`.

Quatre leviers, à **combiner** — le premier arrête l'hémorragie, le second referme l'invariant :

| Levier                                                         | Délai     | Ce qu'il répare                  |
| -------------------------------------------------------------- | --------- | -------------------------------- |
| **Rollback Vercel** (`rollback-prod.yml`)                      | ~30 s     | le code servi en prod            |
| **Revert git** (branche `revert/…`)                            | 15–25 min | l'invariant `main` == prod       |
| **Checkpoint** `checkpoint/AAAA-Wnn`                           | idem      | ramène à un état **prouvé** vert |
| **Restauration base** ([runbook](./backup-restore-runbook.md)) | ~1 h      | données / schéma                 |

Les checkpoints sont coupés **chaque lundi 06:00 UTC** (`checkpoint-tag.yml`) sur le commit de
`main` le plus récent réunissant `verify` vert **et** une nightly verte (E2E + pgTAP) — jamais
le tip du calendrier, qui ne prouve que `verify`. Aucune semaine verte ⇒ **aucun tag**, plus une
issue `checkpoint-missing` : un point de retour qui ment coûte plus cher qu'un point de retour
manquant.

Procédure complète, arbre de décision et exercice à répéter :
**[prod-rollback-runbook.md](./prod-rollback-runbook.md)**.

### Points de vigilance

1. **Geler avant de rollbacker.** Sans `MERGE_FREEZE=1`, la prochaine PR merge seule et
   redéploie le code fautif — sans que personne n'ait rien fait. C'est le piège n°1 ici.
2. **Reculer le code ne recule pas le schéma.** Les migrations sont _forward-only_ et déjà
   appliquées par `db-migrate-prod.yml` **au merge**. Une migration additive est sûre sous
   l'ancien code (c'est pourquoi la DoD §7 impose cet ordre) ; une **destructive** ne l'est pas
   et exige le dump pré-migration conservé 14 jours en artifact.
3. **Vérifier l'état, jamais le signal.** Un run vert ne prouve pas que le gel est posé :
   `gh variable list` doit montrer `MERGE_FREEZE`. Le 2026-07-20, cinq runs « success »
   d'affilée n'avaient rien posé (403 sur le PAT) — depuis, le pas `Verdict` fait échouer le
   job, mais le réflexe de regarder l'état reste le bon.
4. **`git revert` SANS `-m 1`.** Ce dépôt _squash-merge_ : les commits de `main` sont
   ordinaires, pas des commits de merge. Le `-m 1` échoue et fait perdre dix minutes sous
   stress.
5. **La sonde `/api/health` ne voit pas tout.** Elle est serveur : un crash **client** la
   laisse au vert pendant que l'élève voit une page blanche. Après tout rollback, cliquer
   à la main l'accueil, une matière, un exercice soumis.
6. **Ne pas dégeler avant que le revert soit mergé.** Tant que `main` ≠ prod, `MERGE_FREEZE`
   est la seule chose qui empêche la panne de revenir.
7. **`hotfix/` et `revert/` traversent le gel** — volontairement : le correctif qui clôt
   l'incident doit pouvoir passer, et il passe **le même gate complet** que d'habitude. On gèle
   le flux ordinaire, on n'affaiblit aucun contrôle.

## Prérequis côté réglages GitHub (une seule fois)

La configuration est versionnée dans le repo, mais l'application vit dans GitHub :

1. **Settings → Actions → General → Workflow permissions** : « Allow GitHub Actions to
   create and approve pull requests » activé (sinon `auto-pr.yml` ne peut pas ouvrir
   de PR).
2. **Settings → General → Pull Requests** : « Allow auto-merge » activé.
3. **Settings → Rules** : ruleset `main-protection` importé/à jour ; le ré-importer
   après toute modification de `.github/rulesets/main-protection.json`.
4. **(Fortement recommandé) Settings → Secrets and variables → Actions** : secret
   **`GH_AUTOMATION_PAT`** — un PAT _fine-grained_ d'un compte collaborateur, scopé à ce
   seul dépôt (`contents: write`, `pull requests: write`, `workflows: write`). Sans lui,
   la chaîne fonctionne mais **n'est pas déterministe** : voir « Le piège du bot
   non-collaborateur » plus haut — parfois un clic « Approve and run » reste
   nécessaire.

   Ce PAT doit **aussi** porter **`Variables` : Read and write** (« Manage Actions repository
   variables ») — c'est ce qui permet d'écrire `MERGE_FREEZE`, donc de **geler la chaîne**
   pendant un incident (§8). ⚠️ Ne pas confondre avec **« Agent variables »** (agents Copilot),
   voisine dans la liste et sans aucun rapport : la méprise rend `gh variable set` en
   `HTTP 403: Resource not accessible by personal access token` alors que tout paraît
   configuré. Ni le `GITHUB_TOKEN` par défaut ni aucune portée de workflow ne peuvent écrire
   une variable Actions — ce PAT est le seul chemin.

5. **Surveiller l'expiration du PAT.** Un PAT _fine-grained_ expire (le nôtre : **4 octobre
   2026**). Le jour venu, `auto-pr.yml` et `automerge.yml` retombent silencieusement sur le
   `GITHUB_TOKEN` : les PR redeviennent ouvertes par `github-actions[bot]`, non collaborateur,
   et **tous les checks requis repassent en « Approve and run » manuel**. Le symptôme (des PR
   figées en attente d'approbation) ne désigne pas du tout sa cause — poser un rappel.

_Les réglages 1 à 3 ont été activés le 2026-07-02 ; la chaîne a été validée en
conditions réelles sur la PR #270 (qui l'a elle-même installée). Le réglage 4
(`GH_AUTOMATION_PAT`) a été ajouté le 2026-07-06 après avoir observé, sur plusieurs PR
ouvertes automatiquement, des checks requis bloqués en « en attente d'approbation »._
