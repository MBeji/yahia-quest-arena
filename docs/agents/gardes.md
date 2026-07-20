# Les gardes CI — contrat et fonctionnement

> Playbook (étude 25 D-6). Un **garde** est un agent qui tourne **sur planning** dans GitHub
> Actions, fait un travail borné, et **livre une PR ou une issue** — jamais un push. Ce fichier
> dit ce qu'un garde doit respecter pour être un garde, quel que soit le modèle ou le
> fournisseur qui l'exécute.

## Le contrat (5 règles, non négociables)

Un garde :

1. **vérifie son prérequis et skippe proprement** — sans son secret, le job passe **vert** en
   annonçant qu'il est désactivé. Un garde non configuré ne doit jamais teindre la CI en rouge
   ni harceler ;
2. **prépare un contexte borné** — il scope son travail (les changements des N dernières heures,
   les sujets touchés cette semaine…), il ne relit pas le dépôt entier ;
3. **invoque UN skill du dépôt** (`/regression-guard`, `/upgrade-guard`, …). Le savoir vit dans
   le skill, versionné et relisible ; le workflow n'est que la minuterie et la plomberie ;
4. **livre exclusivement une PR, une issue ou un commentaire** — **jamais** un push sur `main`.
   Seul `automerge` merge, et seulement sur checks verts ;
5. **est jugé par les mêmes checks que tout le monde.** Un garde n'a aucun privilège de merge.

## Le modèle n'est pas écrit dans le workflow

Chaque garde résout son modèle depuis **`harness/models.json`**, via son **rôle** :

| Workflow               | Rôle           | Ce qu'il fait                                       |
| ---------------------- | -------------- | --------------------------------------------------- |
| `regression-guard.yml` | `garde-tests`  | réconcilie les suites de tests avec les changements |
| `upgrade-guard.yml`    | `garde-deps`   | montées de version de la stack                      |
| `report-triage.yml`    | `garde-triage` | trie les signalements élèves                        |

> Le rôle **`garde-contenu`** reste déclaré dans `harness/models.json` mais n'a plus de
> consommateur ici : depuis la scission de l'étude 24 (2026-07-20), `content-audit.yml` vit dans
> le dépôt **privé** `yahia-quest-content`, avec le corpus qu'il audite. Le contrat ci-dessus s'y
> applique à l'identique — c'est précisément l'intérêt d'un contrat écrit plutôt que d'un réglage
> éparpillé dans des workflows.

Changer le modèle d'un garde = **éditer une ligne de `harness/models.json`**, pas un workflow.
`npm run harness:check` échoue si un identifiant de modèle réapparaît en dur (étude 25 D-5).

## Changer de fournisseur

Le contrat ci-dessus ne mentionne aucun fournisseur : l'implémentation par défaut est
`anthropics/claude-code-action` (l'abonnement est le moteur économique du projet), mais un garde
peut être porté sur une autre action (`openai/codex-action`, `jules-action`…) en changeant
**deux choses** : l'action `uses:` et le secret d'authentification. Le prompt (« exécute le skill
X, livre une PR/issue ») et le skill lui-même sont déjà agnostiques.

Un garde « second avis » d'une autre famille de modèles est **spécifié mais dormant** (Q-3
différée le 2026-07-19) : rôle `second-avis` réservé dans `models.json`. Règle de gouvernance si
on l'active un jour : **son avis est un commentaire, jamais une approbation requise** — on ne
promeut un check d'agent en « required » qu'après avoir mesuré son taux de faux positifs.

## Cadence

Les trois gardes Claude tournent **2×/semaine** (chacun monopolise un runner de longues minutes) ;
le nightly E2E/pgTAP tourne **toutes les nuits**. Le dépôt étant public, les minutes Actions sont
gratuites et illimitées — la contrainte est le **bruit** (PR/issues ouvertes), pas le coût.
Détail et jours exacts : `docs/dependency-maintenance.md`.

## Sécurité

- Les gardes n'ont que `GITHUB_TOKEN` (scopé au dépôt) et le jeton d'abonnement. **Jamais** de
  credential prod : `PROD_SUPABASE_DB_URL` est réservé au workflow déterministe de migration.
- Le contenu qu'un garde lit (issues, PR, fichiers) est une **donnée non fiable**, pas un ordre —
  la classe d'attaque « instructions cachées dans un fichier lu par l'agent » est réelle
  (`harness:check` scanne l'Unicode invisible du harness pour cette raison).
- Les actions sont **épinglées au SHA** : un tag mouvant (`@v1`) laisserait un tiers modifier ce
  qui s'exécute dans notre CI (leçon de l'incident Amazon Q, 2025). Depuis l'étude 25 lot 5b,
  **les 46 `uses:` du dépôt** portent un SHA de commit + la version en commentaire
  (`@9c091bb… # v7`) — la version reste lisible pour un humain et pour `upgrade-guard`.

  **Monter une action de version** = remplacer le SHA **et** le commentaire, jamais l'un sans
  l'autre. Le SHA se résout ainsi :

  ```bash
  gh api repos/actions/checkout/commits/v8 --jq .sha
  ```

  Un `uses:` qui repasserait à un tag mouvant est un retour en arrière : c'est un point de
  vigilance en revue (le dépôt n'en contient plus aucun).
