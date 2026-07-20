# AGENTS.md — yahia-quest-arena (Na9ra Nal3ab)

> **This file is the single canonical source of truth for every contributor — human or AI
> agent, whichever tool.** When it disagrees with any other doc, this file wins — fix the
> other doc. [`ARCHITECTURE.md`](./ARCHITECTURE.md) is the deeper architecture companion;
> `docs/*.md` are topic-specific normative specs; `FableEtudes/` holds epic-level design
> studies; per-tool files (`CLAUDE.md`, `.github/copilot-instructions.md`, `.gemini/settings.json`)
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
npm run verify         # lint + typecheck + test                    (fast local gate / pre-push)
npm run ci:verify      # verify + coverage + build:check + audit:deps + content:qa:strict + content:audit:strict + harness:check
npm run content:check                    # validate all content, write nothing
npm run content:build -- --subject <id>  # regenerate the migration for ONE subject only
npm run harness:check                    # harness anti-drift gate (pointers, size, hidden Unicode, model ids)
```

⚠️ Never run bare `npm run content:build` — it regenerates **all ~60 subjects** with fresh
timestamps. Always scope with `--subject <id>`. E2E needs a dedicated TEST Supabase project —
see [`e2e/README.md`](./e2e/README.md); never point it at prod. Git hooks (husky): `pre-commit`
runs lint-staged, `pre-push` runs `npm run verify` — never bypass with `--no-verify`.

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

## Content pipeline (`content/`)

Pedagogical content (subjects, chapters, courses, quizzes, exercises) is **never** hand-written
SQL — it lives as versioned files under `content/<subject>/NN-<slug>/`, validated by Zod, then
compiled into idempotent Supabase migrations (deterministic UUIDv5 ids — rebuilding updates
rows in place, no dupes). Edit `content/` → `content:build --subject <id>` → review the SQL →
apply to the DB **before** deploying dependent code (DoD §7). Full spec:
[`content/README.md`](./content/README.md) (French).

**Generating content — use the skills.** Authoring is industrialized via
[`.claude/skills/`](./.claude/skills/) (also mirrored at `.agents/skills/` for non-Claude
tools) — start at `content-engine/references/generation-pipeline.md` for the full
skill-selection map: `curriculum-architect` (plans coverage, never authors),
`content-engine` (shared schema/quality-bar/rewards core) with per-program wrappers
(`content-ecole-tn`, `content-culture-generale`, `content-langue-*`, …), `content-cours`
(lesson texts), `content-interactif` (non-QCM formats), `content-audit` (re-solves &
grades existing content), and the `prof-*` professor overlays (one per matière × niveau,
hard/elite d3-4 exercises). Skills produce **files only**, never SQL.

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
file set — see [`FableEtudes/CONTRIBUER.md`](./FableEtudes/CONTRIBUER.md) for the reservation
protocol. The PR is the only coordination point: no side-channel memory, no private state.
Any project-relevant knowledge discovered in a session (a gotcha, a process rule) belongs in
this repo (this file, `STATUS.md`, `docs/agents/`) — not only in a tool's private memory.

## Documentation map

| Doc                                        | Role                                                                                                                                                             |
| ------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`ARCHITECTURE.md`](./ARCHITECTURE.md)     | Stack, directory structure, data model, deployment — the deep companion to this file                                                                             |
| [`STATUS.md`](./STATUS.md)                 | Central topo: phase, dated decisions, real feature/étude status                                                                                                  |
| [`FableEtudes/`](./FableEtudes/README.md)  | Epic design studies (architect → executor contracts)                                                                                                             |
| [`content/README.md`](./content/README.md) | Content pipeline spec (French)                                                                                                                                   |
| [`e2e/README.md`](./e2e/README.md)         | Playwright runbook (dedicated TEST project)                                                                                                                      |
| `docs/*.md`                                | Topic specs: CI/CD, dependency cadence, env vars, logging, XSS policy, content voice, release tagging, lycée architecture, interactive question types, passation |
| [`docs/agents/`](./docs/agents/README.md)  | **Operational playbooks**: Windows-workstation traps, multi-agent collaboration (branch prefixes, congestion, contended files), content-campaign conduct         |
| `harness/*.json`                           | Model roles, execution policy (source of truth for the generated per-tool views)                                                                                 |

## Known gotchas / traps

- `src/routeTree.gen.ts`, `src/shared/integrations/supabase/types.ts`, and content-generated
  migrations (`supabase/migrations/*_generated_*_content.sql`) are **generated — never hand-edit**.
- **New tables need EXPLICIT grants** — `CREATE TABLE` without its own
  `GRANT SELECT … TO authenticated` works on cloud but breaks the nightly pgTAP suite on a
  fresh DB (baseline: `20260612221000_baseline_table_grants.sql`).
- **Migrations must sort after the newest one already on `main`** — a back-dated timestamp
  jams `supabase db push` and silently strands prod behind code. The `Migration order` PR
  check catches this pre-merge.
- **E2E ≠ unit gate.** Playwright hits a dedicated TEST Supabase project, not unit-test mocks;
  not part of `verify`/`ci:verify`; never point it at prod.
- **CI runs a superset of local `verify`**: adds `content:check`/`content:qa:strict`,
  `build:check`, and `smoke:shell` (loads the real prod bundle in Chromium — the only tier
  that executes prod-gated client code). A green local gate does not guarantee a green CI.
- Coverage is scoped to owned code (`features/`, `shared/`, `lib/`, `hooks/`) — vendored UI,
  route glue, and generated files are excluded by design; don't widen `include` to dilute it.
