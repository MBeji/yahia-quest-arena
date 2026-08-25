# `docs/agents/` — playbooks opérationnels

> Ce que sait une session **expérimentée** de ce dépôt et qui ne se déduit d'aucun autre fichier :
> les pièges du poste, la façon de travailler à plusieurs agents en parallèle, la conduite d'une
> campagne de contenu. Créé par l'**étude 25 (D-7)** pour que ce savoir vive **dans le dépôt** —
> lisible par n'importe quelle tête d'exécution et par n'importe quel humain — au lieu de rester
> dans le cache privé d'un outil ou dans la tête de celui qui l'a appris.

| Playbook                                                       | Quand le lire                                                                                                                       |
| -------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| [`zero-intervention.md`](./zero-intervention.md)               | **À lire en premier.** Ce que la session fait elle-même, ce qui remonte au propriétaire, et les murs qu'aucun harness ne lève       |
| [`poste-windows.md`](./poste-windows.md)                       | Une commande se comporte bizarrement en local (chemins git, `jq`, `/tmp`, symlinks, `node_modules`)                                 |
| [`collaboration.md`](./collaboration.md)                       | Avant de prendre un lot, et dès qu'une PR est en `needs-rebase`, dupliquée ou « bloquée »                                           |
| [`campagnes-contenu.md`](./campagnes-contenu.md)               | Avant de lancer une session de transcription ou de génération de contenu                                                            |
| [`gardes.md`](./gardes.md)                                     | Avant de toucher un workflow de garde CI, ou pour en porter un sur un autre fournisseur                                             |
| [`pieges-du-code.md`](./pieges-du-code.md)                     | Le gate local est vert mais la CI rougit, ou une API tierce répond « OK » sans rien faire                                           |
| [`pgtap-en-local.md`](./pgtap-en-local.md)                     | Avant de toucher à `supabase/migrations/**` ou `supabase/tests/**` — la suite complète en 7 s au lieu de 5-8 min de CI              |
| [`etude-ia-vs-deterministe.md`](./etude-ia-vs-deterministe.md) | **Étude close** (6/6 lots, 2026-07-25) : quelles surfaces IA du dépôt ont été remplacées par des scripts déterministes, lot par lot |

**Piège transverse à connaître avant d'écrire une RPC** : `src/shared/integrations/supabase/types.ts`
est **généré depuis une base réelle**, jamais depuis `supabase/migrations/**`. Une fonction créée
par une migration non encore appliquée n'est donc pas typée — `supabase.rpc('<nom>')` fait rougir
`typecheck`, et le fichier est bloqué à l'édition manuelle (`guard-generated.mjs`, à raison). Sans
Docker en local il n'y a **pas de raccourci** : c'est le cas d'usage exact de la DoD §7, en deux
PR (migration, puis code après `supabase gen types`). Parade pour ne pas envoyer du PL/pgSQL non
exécuté en prod entre les deux : le rejouer dans un Postgres WASM jetable **hors dépôt**
(`@electric-sql/pglite`) — détail dans
[`../suivi-parental-quotidien.md`](../suivi-parental-quotidien.md#livrer-en-deux-temps).

**Le ref à passer à `--project-id` est celui de la PROD : `fasrenmmrkqjoobrztbp`** — source de
vérité [`scripts/shared/prod-targets.mjs`](../../scripts/shared/prod-targets.mjs)
(`PROD_SUPABASE_REF`) ; le projet TEST/e2e est `pqegdnwdtbjtplcthxyp`
([`scripts/db/push-prod.mjs`](../../scripts/db/push-prod.mjs)), à ne jamais confondre. Il n'est
en revanche **jamais** à lire dans `supabase/config.toml` : le `project_id` de ce fichier est un
identifiant purement **local** (préfixe des conteneurs `supabase start`), et il a porté jusqu'au
2026-08-17 un ref mort du scaffolding initial qui ne correspondait à aucun projet du compte. Le
CLI répond alors `Unauthorized` — un message qui accuse le jeton alors que c'est le ref qui est
faux : le piège a déjà coûté une session (2026-08-16).

**Règle de maintenance** (AGENTS.md § Multi-agent collaboration) : un savoir projet découvert en
session finit **ici, dans `STATUS.md` ou dans l'étude concernée** — pas seulement dans la mémoire
d'un outil. Ces fichiers sont normatifs sur leur sujet ; en cas de conflit, `AGENTS.md` gagne.
