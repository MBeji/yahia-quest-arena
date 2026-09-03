# AGENTS.md — yahia-quest-arena (Na9ra Nal3ab)

> **This file is the single canonical source of truth for every contributor — human or AI
> agent, whichever tool.** When it disagrees with any other doc, this file wins — fix the
> other doc. [`ARCHITECTURE.md`](./ARCHITECTURE.md) is the deeper architecture companion;
> `docs/*.md` are topic-specific normative specs; the epic design studies (`FableEtudes/`)
> moved to the private content repo with the corpus (étude 24); per-tool files (`CLAUDE.md`,
> `.github/copilot-instructions.md`, `.gemini/settings.json`)
> are thin pointers to this one — never duplicate rules there. **Project state** (current
> phase, dated decisions, real feature/étude status) lives in [`STATUS.md`](./STATUS.md) —
> read it before trusting any "is X live?" claim.

## What this is

Gamified learning **academy** — a broad catalogue, not a single course. Students do "quests"
(QCM exercises), earn XP/coins, unlock badges, level up hero classes, compete on a leaderboard,
and tackle a timed "dungeon" boss mode. Shonen/RPG manga aesthetic, trilingual (FR/EN/AR, RTL).

**Catalogue hierarchy**: `themes` → `grades` (school theme only, 13 Tunisian levels) →
`subjects` → `chapters` → `exercises` → `questions`. A **parcours** is the student's enrolled
track (`(theme, grade)` pair) — ~35 total, kinds `concours`/`scolaire`/`libre`.
**Free phase (current)**: since the 2026-06-21 pivot, the app is **100 % free** — every
parcours has `is_premium = false`, no mission is gated. The entitlement/paywall machinery
stays in code but **dormant** (étude 01, gelée, is the re-activation vehicle). No user-facing
surface may say "premium/abonnement/payant" during this phase.

**Stack**: Vite 8 · TanStack Start (SSR + file routing + server fns) · React 19 · TanStack
Query 5 · Supabase (Postgres + Auth + RLS) · Tailwind 4 / Radix-shadcn · deploys to **Vercel**
(push to `main` = prod). npm (**Node 24** — `.nvmrc` + les 10 workflows ; ce fichier a longtemps
annoncé 22, et la Content CI privée l'a suivi). Tests: Vitest 4 + Testing Library, Playwright (e2e).

## Essential commands

```bash
npm run dev          # Vite dev server (SSR)
npm run build        # production build
npm run build:check  # build + bundle-budget check
npm run smoke:shell  # prod-bundle browser smoke: public shell must render crash-free
npm test              # vitest run
npm run lint          # eslint src --max-warnings=0  (zero-warning policy)
npm run typecheck     # tsc --noEmit (strict)
npm run verify         # les 4 gates à ~2 s d'abord (eol/leak/db:check-chain/harness), puis lint + typecheck + test
npm run ci:verify      # verify en surensemble : + perf:check, coverage au lieu de test, build:check, audit:deps en dernier
npm run harness:check                    # anti-drift harness (pointers, size, hidden Unicode, model ids) + YAML strict de .github/**
npm run leak:check                       # gate anti-fuite : aucun corpus ni skill pédago au tip (étude 24)
npm run db:check-chain                   # rejeu statique des migrations : une base VIERGE se reconstruit
npm run eol:check / eol:fix              # CRLF invisibles dans l'arbre (piège Windows, docs/agents/poste-windows.md)
npm run db:inventory-content             # inventaire des migrations de contenu (provenance)
npm run programme:etat                   # état des lieux campagne : fiche × programme × contenu × ouverture prod (rapport, pas un gate)
```

⚠️ Les commandes `content:*` / `programme:*` existent toujours (le **moteur** est ici) mais
n'ont plus de données dans ce repo — elles s'exécutent depuis le repo **privé**, qui checkout
celui-ci pour le moteur. Voir « Content pipeline » ci-dessous. E2E needs a dedicated TEST
Supabase project — see [`e2e/README.md`](./e2e/README.md); never point it at prod. Git hooks
(husky): `pre-commit` runs lint-staged, `pre-push` runs `npm run verify` — never bypass with
`--no-verify`.

## Data model & access

Full model: [`ARCHITECTURE.md`](./ARCHITECTURE.md) §8. Core tables: `profiles`, `themes` →
`grades` → `subjects` → `chapters` → `exercises` → `questions`, `attempts`,
`parcours`/`parcours_entitlements` (dormant premium), `student_badges`/`shop_items`,
`spaced_repetition_schedule` (SM-2), `dungeon_runs`, `duel_*`, `question_attempts` +
`user_misconceptions` (adaptive engine, étude 04), `competencies`/`competency_prereqs`
(knowledge graph, étude 07). Server logic lives in SQL (`handle_new_user`, `award_xp`,
`submit_exercise_attempt`) — the two privileged functions are `REVOKE`d from anon/authenticated.
**Access is decided server-side only** by `resolve_exercise_access` — the answer key
(`correct_option`, `distractor_tags`) is **never** sent to the client, in the free phase or
otherwise. Gameplay thresholds: `src/shared/constants/gamification.ts` (change rules there).

## Content pipeline — le corpus n'est PAS dans ce repo (étude 24)

Depuis la scission du 2026-07-20, **le corpus et l'usine qui le produit vivent dans le repo privé
[`MBeji/yahia-quest-content`](https://github.com/MBeji/yahia-quest-content)** (sur invitation) :
`content/` (659 chapitres, 22 146 questions au 2026-08-10), les 41 skills pédagogiques
(`content-*`, `prof-*`, `curriculum-architect`), `FableEtudes/` + METHODE, les workflows
`content-audit.yml` / `video-health.yml`. Ne reste ici que le **moteur**, générique et sans corpus
(`scripts/content/**`, `src/shared/content/**`), les **5 skills techniques** (`verify`,
`code-review`, `regression-guard`, `upgrade-guard`, `report-triage`) et `STATUS.md`. Le moteur est
public **et testé ici** ; c'est lui que la CI privée checkout.

Ces 5 skills sont **mirrorés en `.agents/skills/`** (`npm run harness:sync`, jamais édité à la
main) — le chemin neutre que découvrent Codex, Gemini CLI, Cursor, Copilot et Amp. Éditer la
source `.claude/skills/`, relancer le sync ; `harness:check` échoue sur dérive et vérifie la
conformité à la spec Agent Skills (`name` = dossier, `description` ≤ 1 024 caractères).

**Pour écrire du contenu** : ouvrir la session sur le repo **privé** et y ajouter celui-ci pour le
moteur (`add_repo` / second checkout). La boucle d'auteur ne change pas — éditer
`content/<subject>/NN-<slug>/`, validé par Zod — mais les gates contenu (`content:check`,
`content:qa:strict`, `content:audit:strict`, `programme:check`) tournent dans la **Content CI
privée**, plus dans celle d'ici.

**Le contenu ne voyage plus en migrations** : il se compile en `sql/content/<subject>.sql`
(`content:emit`, nom stable, régénéré en place) et s'applique par le workflow privé
`apply-content.yml`, qui journalise chaque application dans `content_releases`. Les **17 migrations
de contenu écrites à la main** restent ici — `content:emit` ne les reproduit pas, et trois d'entre
elles seedent aussi des données hors contenu.

**La ROADMAP est au privé, les lots se livrent ici** : aucune PR ne touche les deux dépôts, donc
l'invariant est **vérifié** au lieu d'être promis — `node scripts/ci/check-roadmap-sync.mjs
--roadmap ../corpus/FableEtudes/ROADMAP.md`, appelé par la Content CI, échoue si un lot livré sur
`main` après la PR de référence de la roadmap n'y est **cité nulle part**. Citer suffit (coché,
reporté ou sans objet) : le gate a un avis sur la **connaissance**, jamais sur le statut.

⚠️ **Ne re-commite jamais de corpus ici.** `npm run leak:check`
([`scripts/ci/check-content-leak.mjs`](./scripts/ci/check-content-leak.mjs)) fait **échouer** le
gate si `content/**`, `sql/content/**`, un skill `content-*`/`prof-*` ou une migration de contenu
**générée** réapparaît au tip (dans `verify`, `ci:verify` et la CI). Détail du flux :
[`docs/content-generation-pipeline.md`](./docs/content-generation-pipeline.md).

## Conventions

- Feature-based: `src/features/{name}/` (16 — ai, auth, bug-report, content-report, dashboard,
  dungeon, duel, exam, notifications, parcours, parent-report, progression, quest, shop,
  subscription, tutor ; `harness:check` échoue si cette liste dérive de `src/features/`).
  Each has `index.ts` (barrel), `{name}.server.ts`, `__tests__/`.
  **Features never import other features** — share via `src/shared/`. Routes stay thin.
- Import aliases: `@/features/{name}`, `@/shared/lib|constants|types|integrations/...`.
  UI primitives: `@/components/ui/*` (no `@/shared/ui`). i18n: `@/lib/i18n`. Mobile hook:
  `@/hooks/use-mobile`. `useAuth`: `@/features/auth`.
- Every server fn carries an auth middleware — `requireSupabaseAuth`, ou `optionalSupabaseAuth`
  pour une lecture publique assumée ; c'est ce que la règle `local/require-server-fn-auth` exige.
  Un `.inputValidator` zod dès qu'il y a une entrée (non gaté : sans lui `data` est `undefined`).
  Sanitize HTML with DOMPurify (`src/shared/lib/markdown.ts`).
- Naming: kebab-case files, server fns are verbs. Structured logging via
  `@/shared/lib/logger` (redacts secrets) — never raw `console`.

## Definition of Done

A change is **done** only when ALL of these hold — non-negotiable:

1. **Gate is green.** `npm run verify` (release-grade: `npm run ci:verify`). Never report done
   on a red gate.
2. **No weakening the gate.** No `@ts-ignore`/`as any` to dodge types, no inline ESLint
   disables, no lowered coverage thresholds, no `--no-verify` without explicit sign-off.
3. **No new tech debt.** No compat shims, no dead code. Respect feature/shared boundaries.
4. **Types are real.** `tsc` passes. Supabase types are generated — prefer regenerating.
5. **Tests travel with code.** Co-located in the feature's `__tests__/`. Coverage never regresses.
6. **Small, reviewable commits.** Branch off `main`; conventional-commit messages.
7. **DB ↔ code coordinated — prod migrations auto-apply, never by hand.** Merging to `main`
   auto-applies `supabase/migrations/**` via `db-migrate-prod.yml` (backup + guard + `db push`;
   hourly reconciliation catches anything missed). Never run `supabase db push`/`db reset`
   against prod manually. Additive migrations land before the code that uses them; ship
   **destructive** migrations (DROP/REVOKE) in a separate merge, after the old code path is gone.
8. **A pushed branch is the session's PR to land.** The push opens the PR ready with auto-merge
   armed; it merges alone once required checks are green on an up-to-date head — nobody reads,
   readies, or merges by hand. The session that pushed **stays on duty until the merge is real**:
   watch checks, fix reds, confirm the merge, then **close the session clean** (checklist below).
   Savepoint: prefix the **branch** `wip/`/`draft/`/`rescue/`. Do NOT rely on `[wip]`/`[draft]` in
   the commit subject — it leaks into `main` (twice on 2026-07-20): a single-commit branch squashes
   on the commit subject, and auto-merge freezes the message when it arms, so fixing the PR title afterwards is too late.
   Le titre vient du sujet de `HEAD` : un commit de merge en tête titre le squash — vérifier `git log -1 --pretty=%s` avant de pousser, replier si besoin ([`collaboration.md`](./docs/agents/collaboration.md)).

Full detail on §7/§8: [`docs/ci-cd-and-branch-protection.md`](./docs/ci-cd-and-branch-protection.md), [`docs/passation.md`](./docs/passation.md) — its §7 is the session-close checklist.

## Execution policy

Règle qui gouverne cette section : **zéro intervention technique du propriétaire**
([`docs/agents/zero-intervention.md`](./docs/agents/zero-intervention.md)) — une demande de
permission est une validation manuelle. Always allowed : les gates, le pipeline contenu,
l'inspection en lecture seule, `supabase migration list`/`db diff` ; et depuis le 2026-08-23
(arbitrage explicite) la **boucle de livraison** (`git add/commit/push/checkout`,
`git merge origin/main` — `rebase` et `stash` dehors), le **cycle PR/issue**, la
**configuration des dépôts** (`gh secret set`, `gh variable set`) et l'**outillage**
(`npm install` — jamais `npm ci` — et `node scripts/…`). Plus les workflows déclenchables,
nommés un par un (jamais `gh workflow run:*`) : ceux qui n'agissent qu'ici, plus
`rollback-prod.yml`, `db-backup.yml`, `db-tests.yml`, `e2e-auth.yml` et `apply-content*.yml`
(au privé) — les seuls qui **écrivent** en prod, exception assumée : rien de neuf, le SQL d'un
corpus déjà mergé. Hors liste **par choix** : `tutor-digests.yml` et `report-apply.yml`, qui
atteignent de vrais élèves ou écrivent la prod hors de ce chemin relu.
**Never** : `supabase db push`/`db reset` (DoD §7), le dispatch de `db-migrate-prod.yml` ou
`release.yml`, `node scripts/db/push-prod.mjs` et `gh secret delete` ; le reste demande.
⚠️ Ceci lève les demandes **du dépôt**, pas les refus du classifieur d'auto-mode.
Source of truth: **`harness/policy.json`** (with a reason on every deny) — `npm run harness:sync`
compiles it into each tool's view (today `.claude/settings.json`, never hand-edited) and
`npm run harness:check` fails CI on drift. Tools without a repo-level permission file read this
section as guidance; the hard net stays the husky hooks, the required CI checks, and the absence
of prod credentials locally.

## Multi-agent collaboration

Several AI agents (and humans) may work this repo concurrently. Branch prefix identifies the
author (`claude/…`, `codex/…`, `humain/<pseudo>/…`); one lot/task = one PR touching a distinct
file set — see `FableEtudes/CONTRIBUER.md` **in the private content repo** for the reservation
protocol. The PR is the only coordination point: no side-channel memory, no private state.
Any project-relevant knowledge discovered in a session (a gotcha, a process rule) belongs in
this repo (this file, `STATUS.md`, `docs/agents/`) — not only in a tool's private memory.

## Documentation map

| Doc                                                                            | Role                                                                                                                                                                                                                                                                                                                                         |
| ------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`ARCHITECTURE.md`](./ARCHITECTURE.md)                                         | Stack, directory structure, data model, deployment — the deep companion to this file                                                                                                                                                                                                                                                         |
| [`STATUS.md`](./STATUS.md)                                                     | Central topo: phase, dated decisions, real feature/étude status                                                                                                                                                                                                                                                                              |
| `FableEtudes/` (repo **privé**)                                                | Epic design studies (architect → executor contracts) — parties au privé avec le corpus (étude 24)                                                                                                                                                                                                                                            |
| [`docs/content-generation-pipeline.md`](./docs/content-generation-pipeline.md) | Content pipeline spec (French) — le moteur est ici, le corpus est au privé                                                                                                                                                                                                                                                                   |
| [`e2e/README.md`](./e2e/README.md)                                             | Playwright runbook (dedicated TEST project)                                                                                                                                                                                                                                                                                                  |
| [`docs/prod-rollback-runbook.md`](./docs/prod-rollback-runbook.md)             | **Incident prod**: geler la chaîne (`MERGE_FREEZE`), rollback Vercel, revert, checkpoints hebdo, l'axe base de données                                                                                                                                                                                                                       |
| [`docs/baseline-snapshot-runbook.md`](./docs/baseline-snapshot-runbook.md)     | **Bascule système**: figer les 3 dépôts + l'état vivant (base, déploiement, config) en un point de retour daté `baseline/*`                                                                                                                                                                                                                  |
| [`docs/journal-decisions.md`](./docs/journal-decisions.md)                     | Registre **append-only** des décisions datées — STATUS.md ne garde que celles qui gouvernent encore                                                                                                                                                                                                                                          |
| [`docs/dette-technique.md`](./docs/dette-technique.md)                         | Code debt still genuinely open — chaque item re-lu dans le code avant d'être listé (re-vérifié 2026-08-26)                                                                                                                                                                                                                                   |
| [`docs/performance-audit.md`](./docs/performance-audit.md)                     | Perf findings + phased roadmap; its load harness is [`perf/README.md`](./perf/README.md)                                                                                                                                                                                                                                                     |
| `docs/*.md`                                                                    | Topic specs: CI/CD, dependency cadence, env vars, logging, XSS policy, **surfaces & couleurs** (`design-surfaces.md`), content voice, release tagging, lycée architecture, question types, suivi parental quotidien; player guides (`guide-duels-et-ligues`, `guide-rappel-actif`, `guide-types-questions-natifs`, `guide-utilisateur.html`) |
| [`docs/agents/`](./docs/agents/README.md)                                      | **Operational playbooks**: **zero manual intervention by the owner** (`zero-intervention.md` — the rule, and the walls it names), Windows-workstation traps, multi-agent collaboration, content-campaign conduct                                                                                                                             |
| [`docs/archive/`](./docs/archive/README.md)                                    | Dated one-shot audits, kept for the record — never a backlog. A one-shot lands there the day it is handled or outdated                                                                                                                                                                                                                       |
| `harness/*.json`                                                               | Model roles, execution policy (source of truth for the generated per-tool views)                                                                                                                                                                                                                                                             |

## Known gotchas / traps

- `src/routeTree.gen.ts` and `src/shared/integrations/supabase/types.ts` are
  **generated — never hand-edit**. (Content-generated migrations no longer live here: since
  étude 24 the corpus compiles to `sql/content/*.sql` in the private repo.)
- **New tables need EXPLICIT grants** — `CREATE TABLE` without its own
  `GRANT SELECT … TO authenticated` works on cloud but breaks the nightly pgTAP suite on a
  fresh DB (baseline: `20260612221000_baseline_table_grants.sql`).
- **Migrations must sort after the newest one already on `main`** — a back-dated timestamp
  jams `supabase db push` and silently strands prod behind code. The `Migration order` PR
  check catches this pre-merge.
- **La prod n'est PAS le juge de la reconstructibilité.** Une migration peut passer en prod (où
  ses parents existent de longue date) et rendre impossible la construction d'une base vierge —
  donc pgTAP et tout projet TEST neuf (quatre pannes en cascade après é24 lot 4 : #548, #549,
  #552, #557). `db-tests.yml` tourne sur les PR depuis le 2026-07-20 (chemins filtrés) **mais
  n'est pas requis** : un rouge n'arrête pas l'auto-merge, il faut aller le lire. `db:check-chain`
  rejoue la chaîne statiquement (FK orphelines, ids de fixtures en collision, doublons de
  version) ; un INSERT de contenu dépendant de lignes absentes d'ici se garde par
  `WHERE EXISTS (SELECT 1 FROM public.<parent> p WHERE p.id = v.<fk>)`.
- **Un refus d'auth se déclare dans `auth-refusals.ts`, jamais ailleurs** — message ET conduite
  client. Deux listes tenues à la main ont divergé deux fois (#931 « Failed to load dashboard » ;
  #914/#915 « Valider » grisé sans fin) : `Record<AuthFailure, …>` fait désormais échouer `tsc` sur
  un refus sans sa ligne, et `auth-refusals.test.ts` couvre tout refus futur. Jamais de message en dur.
- **E2E ≠ unit gate.** Playwright hits a dedicated TEST Supabase project, not unit-test mocks;
  not part of `verify`/`ci:verify`; never point it at prod.
- **La CI n'est pas exactement `verify`** : elle ajoute `build:check` et `smoke:shell` (le seul
  étage qui exécute le bundle prod dans Chromium) et n'a **pas** `eol:check` (git normalise à la
  sortie). `npm run ci:verify` en est le miroir local le plus proche ; un gate local vert ne
  garantit pas une CI verte. Les gates **contenu** n'en sont plus : Content CI privée (étude 24).
- **`audit:deps` n'est pas hermétique** (il est dans `ci:verify` et la CI, pas dans `verify`) :
  il interroge le registre au moment du run, donc à lockfile constant le même commit passe le
  matin et échoue l'après-midi, et c'est **toute la file** qui est bloquée, pas la PR visée
  (2026-08-04, `fast-uri`, #712). Réflexe : `git diff origin/main HEAD -- package.json
package-lock.json` (vide ⇒ ce n'est pas toi), puis `npm audit fix --package-lock-only
--omit=dev` en commit séparé.
- **Le titre d'une PR Dependabot peut mentir sur son diff.** #716, « bump undici · indirect »,
  montait une **majeure** et entrait une **alpha** ; son lockfile a cassé `npm ci` **hors d'ici**
  (33 h de Content CI privée rouge) pendant que ce gate restait vert. ✅ **Mécanisé le 2026-09-03**
  (A17) : `check-dependency-pr.mjs` dans `verify` — [`docs/dependency-maintenance.md`](./docs/dependency-maintenance.md).
- Coverage is scoped to owned code (`features/`, `shared/`, `lib/`, `hooks/`) — vendored UI,
  route glue, generated files **et tout `features/**/components/**`** sont exclus par choix
  (rendu, couvert par les tests de route et le build) ; ne pas élargir `include` pour diluer.
