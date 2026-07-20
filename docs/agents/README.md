# `docs/agents/` — playbooks opérationnels

> Ce que sait une session **expérimentée** de ce dépôt et qui ne se déduit d'aucun autre fichier :
> les pièges du poste, la façon de travailler à plusieurs agents en parallèle, la conduite d'une
> campagne de contenu. Créé par l'**étude 25 (D-7)** pour que ce savoir vive **dans le dépôt** —
> lisible par n'importe quelle tête d'exécution et par n'importe quel humain — au lieu de rester
> dans le cache privé d'un outil ou dans la tête de celui qui l'a appris.

| Playbook                                         | Quand le lire                                                                                       |
| ------------------------------------------------ | --------------------------------------------------------------------------------------------------- |
| [`poste-windows.md`](./poste-windows.md)         | Une commande se comporte bizarrement en local (chemins git, `jq`, `/tmp`, symlinks, `node_modules`) |
| [`collaboration.md`](./collaboration.md)         | Avant de prendre un lot, et dès qu'une PR est en `needs-rebase`, dupliquée ou « bloquée »           |
| [`campagnes-contenu.md`](./campagnes-contenu.md) | Avant de lancer une session de transcription ou de génération de contenu                            |
| [`gardes.md`](./gardes.md)                       | Avant de toucher un workflow de garde CI, ou pour en porter un sur un autre fournisseur             |

**Règle de maintenance** (AGENTS.md § Multi-agent collaboration) : un savoir projet découvert en
session finit **ici, dans `STATUS.md` ou dans l'étude concernée** — pas seulement dans la mémoire
d'un outil. Ces fichiers sont normatifs sur leur sujet ; en cas de conflit, `AGENTS.md` gagne.
