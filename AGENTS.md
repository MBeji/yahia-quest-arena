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
(push to `main` = prod). npm (Node 22). Tests: Vitest 4 + Testing Library (unit), Playwright (e2e).

## Essential commands

```bash
npm run dev          # Vite dev server (SSR)
npm run build        # production build
npm run build:check  # build + bundle-budget check
npm run smoke:shell  # prod-bundle browser smoke: public shell must render crash-free
npm test              # vitest run
npm run lint          # eslint src --max-warnings=0  (zero-warning policy)
npm run typecheck     # tsc --noEmit (strict)
npm run verify         # lint + typecheck + test + leak:check       (fast local gate / pre-push)
npm run ci:verify      # verify + coverage + build:check + audit:deps + harness:check + leak:check
npm run harness:check                    # harness anti-drift gate (pointers, size, hidden Unicode, model ids)
npm run leak:check                       # gate anti-fuite : aucun corpus ni skill pédago au tip (étude 24)
npm run db:inventory-content             # inventaire des migrations de contenu (provenance)
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

Depuis la scission du 2026-07-20, **le corpus pédagogique et l'usine qui le produit vivent
dans le repo privé [`MBeji/yahia-quest-content`](https://github.com/MBeji/yahia-quest-content)**
(sur invitation). Ce repo-ci ne garde que le **moteur**, qui est générique et sans corpus :
`scripts/content/**` (build, qa, audit, suivi, catalogue) et `src/shared/content/**`
(loader, schema, sql-builder, qa-checks). Le moteur reste public **et testé ici** ; c'est lui
que la CI privée checkout.

Sont partis au privé : `content/` (566 chapitres, ~18 700 questions et leurs clés), les
**41 skills pédagogiques** (`content-*`, `prof-*`, `curriculum-architect`), `FableEtudes/` +
METHODE, et les workflows `content-audit.yml` / `video-health.yml`. Ne restent ici que les
**5 skills techniques** (`verify`, `code-review`, `regression-guard`, `upgrade-guard`,
`report-triage`). `STATUS.md` reste public.

Ces 5 skills sont **mirrorés en `.agents/skills/`** (généré par `npm run harness:sync`,
jamais édité à la main) — le chemin neutre que découvrent Codex, Gemini CLI, Cursor, Copilot
et Amp. Éditer la source `.claude/skills/`, relancer le sync ; `harness:check` échoue sur
dérive et vérifie au passage la conformité à la spec Agent Skills (`name` = dossier,
`description` ≤ 1 024 caractères).

**Pour écrire du contenu** : ouvrir la session sur le repo **privé** et y ajouter celui-ci
pour le moteur (`add_repo` / second checkout). La boucle d'auteur ne change pas — éditer
`content/<subject>/NN-<slug>/`, validé par Zod — mais elle se déroule là-bas, et les gates
contenu (`content:check`, `content:qa:strict`, `content:audit:strict`, `programme:check`)
tournent dans la **Content CI privée**, plus dans la CI d'ici.

**Le contenu ne voyage plus en migrations.** Il est compilé en `sql/content/<subject>.sql`
(`content:emit`, nom de fichier stable, régénéré en place) et appliqué par le workflow privé
`apply-content.yml`, qui journalise chaque application dans la table `content_releases`.
Les **17 migrations de contenu écrites à la main** restent ici : `content:emit` ne les
reproduit pas et trois d'entre elles seedent aussi des données hors contenu
(`badges`/`shop_items`, `grades`/`themes`, `parcours`/`profiles`).

⚠️ **Ne re-commite jamais de corpus ici.** `npm run leak:check`
([`scripts/ci/check-content-leak.mjs`](./scripts/ci/check-content-leak.mjs)) fait **échouer**
le gate si `content/**`, `sql/content/**`, un skill `content-*`/`prof-*` ou une migration de
contenu **générée** réapparaît au tip. Il tourne dans `verify`, dans `ci:verify` et en CI.
Détail du flux : [`docs/content-generation-pipeline.md`](./docs/content-generation-pipeline.md).

## Conventions

- Feature-based: `src/features/{name}/` (13 features — auth, dashboard, quest, dungeon, duel,
  shop, progression, parent-report, subscription, content-report, bug-report, notifications,
  parcours). Each has `index.ts` (barrel), `{name}.server.ts`, `__tests__/`.
  **Features never import other features** — share via `src/shared/`. Routes stay thin.
- Import aliases: `@/features/{name}`, `@/shared/lib|constants|types|integrations/...`.
  UI primitives: `@/components/ui/*` (no `@/shared/ui`). i18n: `@/lib/i18n`. Mobile hook:
  `@/hooks/use-mobile`. `useAuth`: `@/features/auth`.
- Every server fn: `createServerFn(...).middleware([requireSupabaseAuth])` + zod
  `.inputValidator`. Sanitize HTML with DOMPurify (`src/shared/lib/markdown.ts`).
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
   readies, or merges by hand. The session that pushed **stays on duty until the merge is
   real**: watch checks, fix reds, confirm the merge, clean up. Savepoint: `[wip]`/`[draft]` in
   the commit subject (or a `wip/`/`draft/`/`rescue/` branch).

Full detail on §7/§8: [`docs/ci-cd-and-branch-protection.md`](./docs/ci-cd-and-branch-protection.md),
[`docs/passation.md`](./docs/passation.md).

## Execution policy

Always allowed: the project's own gates (`npm run {lint,typecheck,test,test:*,verify,ci:verify,
build,build:*,format,audit:deps,harness:check}`), the content pipeline (`npm run content:*`),
read-only `git`/`gh`/`ls` inspection, and read-only `supabase migration list`/`db diff`/`test db`.
**Never**: `supabase db push`/`db reset` against any project (prod migrates only via
`db-migrate-prod.yml`, DoD §7). Anything else falls back to asking.
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

| Doc                                                                            | Role                                                                                                                                                             |
| ------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`ARCHITECTURE.md`](./ARCHITECTURE.md)                                         | Stack, directory structure, data model, deployment — the deep companion to this file                                                                             |
| [`STATUS.md`](./STATUS.md)                                                     | Central topo: phase, dated decisions, real feature/étude status                                                                                                  |
| `FableEtudes/` (repo **privé**)                                                | Epic design studies (architect → executor contracts) — parties au privé avec le corpus (étude 24)                                                                |
| [`docs/content-generation-pipeline.md`](./docs/content-generation-pipeline.md) | Content pipeline spec (French) — le moteur est ici, le corpus est au privé                                                                                       |
| [`e2e/README.md`](./e2e/README.md)                                             | Playwright runbook (dedicated TEST project)                                                                                                                      |
| [`docs/prod-rollback-runbook.md`](./docs/prod-rollback-runbook.md)             | **Incident prod**: geler la chaîne (`MERGE_FREEZE`), rollback Vercel, revert, checkpoints hebdo, l'axe base de données                                           |
| `docs/*.md`                                                                    | Topic specs: CI/CD, dependency cadence, env vars, logging, XSS policy, content voice, release tagging, lycée architecture, interactive question types, passation |
| [`docs/agents/`](./docs/agents/README.md)                                      | **Operational playbooks**: Windows-workstation traps, multi-agent collaboration (branch prefixes, congestion, contended files), content-campaign conduct         |
| `harness/*.json`                                                               | Model roles, execution policy (source of truth for the generated per-tool views)                                                                                 |

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
- **E2E ≠ unit gate.** Playwright hits a dedicated TEST Supabase project, not unit-test mocks;
  not part of `verify`/`ci:verify`; never point it at prod.
- **CI runs a superset of local `verify`**: adds `build:check`, `perf:check` and `smoke:shell`
  (loads the real prod bundle in Chromium — the only tier that executes prod-gated client
  code). A green local gate does not guarantee a green CI. The **content** gates are no longer
  part of it: they run in the private repo's Content CI (étude 24).
- Coverage is scoped to owned code (`features/`, `shared/`, `lib/`, `hooks/`) — vendored UI,
  route glue, and generated files are excluded by design; don't widen `include` to dilute it.
