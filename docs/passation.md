# Passation — de la fin de développement à la mise en production

Ce document décrit **le parcours complet d'une demande** dans `yahia-quest-arena`, depuis
le moment où le développement est terminé jusqu'à la production, avec chaque garde-fou
(harness) rencontré en chemin. Il complète [CLAUDE.md](../CLAUDE.md) (source canonique)
et [ci-cd-and-branch-protection.md](./ci-cd-and-branch-protection.md) (détail des checks
et du ruleset) — en cas de divergence, CLAUDE.md gagne.

## Vue d'ensemble

```
Dev local ──► git commit ──► git push (branche)
                │                 │
           [hooks husky]     [auto-pr.yml] ──► PR draft + checks lancés
                                  │
                    ┌─────────────┴──────────────┐
                    │  Checks requis sur la PR    │
                    │  verify · Migration presence│
                    │  Migration order · CodeQL   │
                    └─────────────┬──────────────┘
                                  │
              PR « Ready » ──► [automerge.yml] arme l'auto-merge
                                  │  (retard sur main ? → update auto + re-checks)
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

**Le seul geste humain** entre « j'ai fini de coder » et « c'est en prod » est de marquer
la PR **« Ready for review »** — ou de pousser avec **`[auto-merge]`** dans le sujet du
commit de tête pour supprimer même ce geste. Le label **`no-automerge`** gèle une PR
qu'on veut relire tranquillement.

## 1. Fin de dev — garde-fous locaux (hooks git)

Avant même que le code quitte la machine (husky, installé par `npm install`) :

- **`pre-commit`** (lint-staged) : Prettier + ESLint `--fix` sur les fichiers stagés —
  aucun commit mal formaté ne peut exister.
- **`pre-push`** : `npm run verify` complet (ESLint zéro-warning + `tsc --noEmit` strict
  - la suite Vitest). Un push avec un gate rouge est refusé localement.
- Jamais de `--no-verify` sans raison explicitement documentée (CLAUDE.md, DoD §2).

## 2. Push de la branche — inscription automatique en PR

- **`auto-pr.yml`** : tout push d'une branche non-`main` ouvre automatiquement sa
  **PR draft** (titre = sujet du commit de tête, corps = template du repo).
- Raccourci opt-in : un sujet de commit contenant **`[auto-merge]`** ouvre la PR
  directement « ready » et arme le merge sans autre geste.

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

| Check requis         | Workflow             | Ce qu'il prouve                                                                                                                                                                                                                         |
| -------------------- | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `verify`             | `ci.yml`             | lint, typecheck, tests + couverture (seuils 80 %), `content:check` (contenu ↔ migrations synchrones), `content:qa:strict`, `perf:check`, build + budgets de bundle, **`smoke:shell`** (le vrai bundle prod dans Chromium), `audit:deps` |
| `Migration presence` | `migration-gate.yml` | liste les migrations qui s'auto-appliqueront à la prod au merge (aucune surprise) — informatif, toujours vert                                                                                                                           |
| `Migration order`    | `migration-gate.yml` | **bloque** une migration antidatée qui coincerait silencieusement l'auto-apply prod (leçon des incidents #97 → #227 → #229)                                                                                                             |
| `CodeQL`             | `codeql.yml`         | analyse statique de sécurité (SAST, suite `security-extended`) de tout le code JS/TS                                                                                                                                                    |

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
   manuel** (CLAUDE.md §7). Règle d'or : migration **additive avant** le code qui
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
- **`content-audit.yml`** (mer + sam) : re-résout chaque question du contenu modifié —
  le seul filet contre une _mauvaise réponse_, invisible aux checks déterministes.
- **`db-backup.yml`** (sauvegardes prod), **CodeQL hebdomadaire**, **Dependabot**
  (alertes de sécurité uniquement).

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
   non-collaborateur » plus haut — parfois un clic « Ready for review » ou
   « Approve and run » reste nécessaire.

_Les réglages 1 à 3 ont été activés le 2026-07-02 ; la chaîne a été validée en
conditions réelles sur la PR #270 (qui l'a elle-même installée). Le réglage 4
(`GH_AUTOMATION_PAT`) a été ajouté le 2026-07-06 après avoir observé, sur plusieurs PR
ouvertes automatiquement, des checks requis bloqués en « en attente d'approbation »._
