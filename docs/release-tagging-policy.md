# Politique de tags

Deux familles de tags coexistent, avec des rôles distincts — ne pas les confondre.

| Famille        | Exemple               | Coupé par            | Répond à                          |
| -------------- | --------------------- | -------------------- | --------------------------------- |
| **Release**    | `v0.2.0`              | `release.yml`        | « quelle version est-ce ? »       |
| **Checkpoint** | `checkpoint/2026-W30` | `checkpoint-tag.yml` | « où revenir si la prod tombe ? » |

Un tag de release marque une **intention** (on a décidé de sortir cette version). Un checkpoint
marque une **preuve** (ce commit a passé toutes les suites). C'est le second qu'on utilise en
incident.

---

## Checkpoints — les points de retour arrière

**Chaque lundi 06:00 UTC**, `checkpoint-tag.yml` pose un tag annoté `checkpoint/AAAA-Wnn` sur le
commit de `main` le plus récent qui réunit, **sur ce commit exact** :

- `verify` vert (lint + types + tests + couverture + build + budget bundle + smoke shell) ;
- un **nightly vert** — Playwright E2E public et pgTAP au minimum. `e2e-auth` et `perf` sont
  gated par secret : un `skipped` y est toléré et **tracé dans l'annotation**, jamais maquillé.

La sélection remonte les nightlies récents (fenêtre de 8 jours) et retient le premier commit sur
lequel les deux signaux concordent — **jamais le tip du calendrier**, qui ne prouve que `verify`.
Logique dans [`scripts/release/pick-checkpoint.mjs`](../scripts/release/pick-checkpoint.mjs),
pure et testée unitairement.

**Si aucun commit ne qualifie, aucun tag n'est posé** et une issue `checkpoint-missing` dit
pourquoi chaque candidat a été écarté. Un checkpoint qui ment coûte plus cher qu'un checkpoint
manquant.

L'annotation porte ce qu'un opérateur lit en pleine panne : commit, version, **tête de migration
à ce commit**, déploiement Vercel correspondant, détail des preuves, et l'avertissement que
revenir au code ne ramène pas le schéma.

```bash
git fetch --tags
git tag -l 'checkpoint/*' --sort=-creatordate | head -5
git show checkpoint/2026-W30
```

Usage en incident : [`prod-rollback-runbook.md`](./prod-rollback-runbook.md).

---

## Releases — versions SemVer

- Tags `vMAJEUR.MINEUR.CORRECTIF`, coupés **uniquement** depuis `main` avec la CI verte.
- `release.yml` se déclenche quand la version de `package.json` change sur `main` : il crée le
  tag annoté et publie la release GitHub (notes générées). Idempotent — si le tag existe, il
  passe.
- **Bumper la version est donc l'acte de release** : `npm version <patch|minor|major> --no-git-tag-version`,
  puis merger. Rien d'autre à faire à la main.
- Correctif urgent : brancher sur `hotfix/…` (exempté du gel des merges), correction minimale,
  bump de correctif.

---

## Ce qu'un tag ne fait pas

Un tag ne déploie rien : **c'est le push sur `main` qui déploie** (Vercel) et qui applique les
migrations (`db-migrate-prod.yml`). Revenir à un tag est une opération sur le code — le schéma,
lui, ne recule jamais. Ce point gouverne toute la procédure de rollback :
[`prod-rollback-runbook.md`](./prod-rollback-runbook.md) § « L'axe base de données ».
