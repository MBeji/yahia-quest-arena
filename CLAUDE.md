# CLAUDE.md — yahia-quest-arena (XP Scholars)

> **This file is the single canonical source of truth.** When it disagrees with any
> other doc, CLAUDE.md wins — fix the other doc. [`ARCHITECTURE.md`](./ARCHITECTURE.md)
> is the deeper architecture companion; the per-topic policy files under `docs/` and the
> Copilot pointer at `.github/copilot-instructions.md` defer to these two. This file
> covers commands, conventions, and gotchas not obvious from the code.

## What this is

Gamified learning **academy** — a broad catalogue, not a single course. Students do "quests"
(QCM exercises), earn XP/coins, unlock badges, level up hero classes, compete on a leaderboard,
and tackle a timed "dungeon" boss mode. Shonen/RPG manga aesthetic, trilingual (FR/EN/AR with RTL).

**Catalogue hierarchy** (this is the key mental model — the app is wider than its origins):
`themes` → `grades` → `subjects` → `chapters` → `exercises` → `questions`.

- A **theme** is a top-level track. Seeded themes: `ecole-tn` (Programme scolaire tunisien),
  plus standalone tracks `culture-generale`, `muscle-cerveau`, and
  language tracks `anglais` / `francais` / `arabe`. Only the school theme has grades
  (`themes.has_grades`).
- **Grades** exist _only_ under the school theme: the full Tunisian ladder, 1ère année de base →
  Baccalauréat (13 levels). 6ème, 9ème and Bac are national-exam years
  (`grades.is_concours_national`). The student picks one at onboarding → `profiles.current_grade_id`.
- So **"9ème année" is just one grade**, under one theme. It's currently the most-populated grade
  (most `content/` subjects target `9eme-base`), but treat that as data, not as the app's scope.
  Everything below `subjects` (chapters/exercises + all gameplay: XP, quiz gate, dungeon,
  leaderboard) is theme/grade-agnostic.
- A **parcours** is the student's enrolled track (`profiles.current_parcours_id`), resolved from a
  `(theme, grade)` pair. The two PREMIUM **concours** parcours (9ème, 6ème) are the paid products;
  the rest are FREE **exploration** parcours. Premium missions need a per-parcours **entitlement**
  (see "Premium gate" under Data model); the free preview is the comprehension quiz + difficulty-1.
  The dashboard is scoped to the active parcours; the Explorer (`/themes`) lets a student switch.

**Stack**: Vite 8 · TanStack Start (SSR + file routing + server fns) · React 19 · TanStack Query 5 · Supabase (Postgres + Auth + RLS) · Tailwind 4 / Radix-shadcn · **deploys to Vercel** — push to `main` auto-deploys prod via `scripts/build-vercel.mjs` (`vercel.json`). A Cloudflare Workers config also exists, but Vercel is the live target. Package manager: **npm** (`package-lock.json`; Node 22 / npm 10 in CI). Tests: Vitest 4 + Testing Library (unit) and Playwright (e2e).

## Essential commands

```bash
npm run dev          # Vite dev server (SSR)
npm run build        # production build
npm run build:check  # build + bundle-budget check
npm test             # vitest run — run `npm test` for the current test/file count
npm run test:watch   # watch mode
npm run test:coverage
npm run lint         # eslint src --max-warnings=0  (zero-warning policy)
npm run typecheck    # tsc --noEmit (strict)
npm run format       # prettier --write .
npm run verify       # lint + typecheck + test                          (fast local gate / pre-push)
npm run ci:verify    # verify + coverage + build:check + audit:deps + content:qa:strict  (full gate)
```

**Content pipeline** (authored files → Supabase migrations — see "Content pipeline" below):

```bash
npm run content:check      # validate all content, write nothing
npm run content:build      # compile content/ → idempotent SQL in supabase/migrations/
npm run content:qa         # content quality checks
npm run content:qa:strict  # same, fail on warnings (part of ci:verify)
```

**E2E (Playwright)** — needs a dedicated TEST Supabase project + seeded users; not part of the unit gate:

```bash
npm run test:e2e:install   # one-time: install chromium
npm run test:e2e           # public (chromium + mobile) specs — no backend needed

# Authenticated tier — TEST project only (cp .env.test.example .env.test first):
npm run e2e:doctor         # verify .env.test is complete (secrets masked)
npm run e2e:setup          # provision TEST: db:push + seed users + reset gameplay
npm run test:e2e:auth      # authenticated specs (uses e2e/.auth/*.json storage state)
```

`.env.test` (gitignored) holds the **dedicated TEST** Supabase creds; `playwright.config.ts`
loads it so the spawned dev server targets TEST, and `_env.mjs` + the config refuse the known
prod ref as a safety net. Never point e2e at production — it seeds/resets/mutates data. Full
runbook: [`e2e/README.md`](./e2e/README.md).

**Git hooks (husky):** `pre-commit` runs `lint-staged` (Prettier + ESLint `--fix` on
staged files); `pre-push` runs `npm run verify`. Installed automatically via the
`prepare` script on `npm install`. Never bypass with `--no-verify` without a stated reason.

## Execution flow

- `src/server.ts` — SSR/Worker fetch entry; wraps responses and normalizes h3-swallowed
  catastrophic 500s into a branded error page.
- `src/start.ts` — `createStart`: registers CSRF + error request-middleware and the
  `attachSupabaseAuth` function-middleware globally.
- `src/router.tsx` — router factory (QueryClient in context).
- `src/routes/` — file-based routes (thin). `__root.tsx` → `_authenticated.tsx` (auth guard
  - nav shell) → feature pages. Auth redirect happens in a `useEffect`, not during render.
- Data access: every server fn is `createServerFn(...).middleware([requireSupabaseAuth])`.
  The middleware validates the `Bearer` JWT and injects `{ supabase, userId, claims }` into
  `context`. See `src/shared/integrations/supabase/auth-middleware.ts`.

## Data model (Supabase)

`profiles` (xp/level/streak/coins/hero_class/role/`current_grade_id`/`current_parcours_id`) · `themes` → `grades`
(school theme only) → `subjects` → `chapters` → `exercises` → `questions` (QCM, `options` JSONB)
· `attempts` · `exercise_sessions` · `student_badges` /
`shop_items` / `inventory_items` · `daily_objectives` · `weekly_quests` ·
`spaced_repetition_schedule` (SM-2) · `dungeon_runs` · `parent_student_links` · `parcours`
(sellable tracks — FREE or PREMIUM) · `parcours_entitlements` (per-parcours grants; `source` ∈
{purchase/beta/gift/family}; family pack via `parent_student_links`) · `beta_access_requests` ·
`content_reports` (user-flagged content errors) · `themes` / `grades`. (The old `subscriptions`
columns + RPCs were removed in migration `20260609000000`.)

Server-side logic lives in SQL: `handle_new_user` (auto-profile on signup), `award_xp`
(streak + level curve: 200 XP/level, hero-class tiers), and the `submit_exercise_attempt`
RPC (atomic scoring + rewards + badge unlocks). All tables have RLS; the two privileged
functions are `REVOKE`d from anon/authenticated. Gameplay thresholds are centralized in
`src/shared/constants/gamification.ts` — change rules there, not inline.

**Premium gate (per-parcours).** Access is decided server-side by the single authoritative RPC
`resolve_exercise_access(exercise)`: a FREE parcours is always open; a PREMIUM (concours) parcours
opens a mission only for a holder of a live `parcours_entitlement` — directly, or via an active
linked parent (the **family pack**) — **except the free preview** (the chapter comprehension quiz +
difficulty-1 missions, `FREE_PREVIEW_MAX_DIFFICULTY`). `has_parcours_entitlement(user, parcours)`
encapsulates the check; `set_current_parcours` sets the student's active track at onboarding; admin
provisioning is `admin_grant_parcours` / `admin_revoke_parcours` / `admin_list_parcours_entitlements`.
The Dungeon is a premium perk (any concours entitlement). The legacy global "difficulty ≥ 3 +
subscription" gate is **gone** — no code reads `subscription_*` / `has_active_subscription`.

**Consumables (shop items):** `shop_items.effect_payload` (JSONB) drives three live
mechanics, all keyed off `inventory_items.is_active` = "armed" (skins use `is_equipped`).
Potions (`xpMultiplier`/`coinMultiplier`) and the retry shield (`retries`) share a
**next-quest slot** (one armed at a time); the streak shield (`streakShield`) is a separate
**passive slot**; hints (`hints`/`hintBoost`) are spent on demand, never armed.
`activate_inventory_item` arms; `submit_exercise_attempt` applies/consumes potions
(`potionApplied`) and the retry shield (suppresses the spaced-rep penalty on a `<60%` fail,
`retryShieldUsed`); `award_xp` consumes a streak shield to save a one-missed-day streak;
`consume_hint` reveals `questions.explanation` on demand (decrements one charge). Anti-waste: a
consumable is consumed only when it actually takes effect, and never bypasses the
`tooFast`/`≥60%`/`improved` anti-farm gates. Apply consumable migrations before deploy (§7).
See ARCHITECTURE.md "Consumables (shop items)" for the full model.

## Content pipeline (`content/`)

Pedagogical content (subjects, chapters, courses, summaries, quizzes, exercises) is **not**
hand-written SQL — it lives as versioned files under `content/<subject>/NN-<slug>/`
(`subject.json`, `chapter.json`, `cours.md`, `resume.md`, `quiz.json`, `exercices/*.json`),
validated by Zod (`src/shared/content/schema.ts`), then compiled by
`scripts/content/build.ts` into **idempotent** SQL in `supabase/migrations/`. IDs are
**deterministic UUIDv5** derived from slugs, so rebuilding updates rows in place (no dupes)
and removed admin content is pruned — **parent-authored content is never touched**. Each
`subject.json` declares `themeId` (required) + `gradeSlug` (resolved to a `grades` UUID at
compile time, never hard-coded). `quiz.json` is mandatory; for **school-program** subjects it gates a
chapter's exercises (student must pass ≥ `QUIZ_PASS_THRESHOLD_PCT`), but **non-school themes never
gate on the quiz** (theory is optional there — `quest.startExerciseSession` skips the gate when
`grade_id` is null). Edit content as files → `content:build` →
review the generated SQL → apply to the DB **before** deploying dependent code (DoD §7).
Full spec: [`content/README.md`](./content/README.md) (in French).

**Generating content — use the skills.** Content authoring is industrialized via a suite of
Claude Code skills under [`.claude/skills/`](./.claude/skills/). `content-engine` is the shared core
(schema, quality bar, reward table, RPG style, trilingual model, validate-then-stop workflow) in its
`references/`; thin per-program wrappers defer to it: `content-ecole-tn` (national school program,
**faithful to the official curriculum**), `content-culture-generale` and `content-muscle-cerveau`
(trilingual FR/EN/AR → three sibling subjects), `content-iq-training` (visual IQ/reasoning, SVG
figures), and `content-langue-{anglais,francais,arabe}` (immersion, one per language).
`content-cours` specializes in lesson texts (writes/rewrites `cours.md`/`resume.md` against the
course-quality bar: clarté, compréhension, exhaustivité — every tested notion must be taught —
expérience pédagogique). `content-audit` is the review counterpart: it audits **existing** content
(re-solves every question, checks keys/distractors/notation/calibration, and grades courses/summaries
against the same course-quality bar) and produces a severity-ranked report. Skills produce
**files only** (then run `content:check` + `content:qa:strict`); you review the diff, then build/apply.
**Non-school** programs are trilingual = three sibling subjects (one `contentLanguage` each) under one
theme; **school** content (`ecole-tn`) stays in the subject's **official language of instruction**
(monolingual). Every mission/quiz indicates its difficulty level (⭐ scale) in its title. There is no
per-record translation. **Notation is standard in every language**: Western digits (0–9), LTR
equations, SI units — including Arabic content (Arabic prose around standard math; never
Arabic-Indic digits). Rule: `content-engine/references/math-and-notation.md`.

## Conventions

- Feature-based: `src/features/{auth,dashboard,quest,dungeon,shop,progression,parent-report,subscription,content-report,parcours}/`
  (10 features). Each has `index.ts` (public barrel), `{name}.server.ts`, optional
  `components/`, `__tests__/`. The three newer features:
  - **`subscription/`** — premium gate + admin: per-parcours **entitlements** (a concours parcours
    requires a live entitlement; free preview = comprehension quiz + difficulty-1), provisioned via
    `admin_grant_parcours`; beta-access requests; the out-of-band (phone) paywall component.
  - **`content-report/`** — user-flagged content errors ("Signaler une erreur") + admin triage.
  - **`parcours/`** — gamified journey-map / adventure-path UI: a world map of **subjects**
    (`JourneyMap`/`buildSubjectNodes` at `/parcours`). Every map node routes to the single
    chapter screen `/subject/$subjectId` (which carries the quiz-gate + exercises). The
    earlier per-subject zigzag chapter map (`/parcours/$subjectId`, `SubjectPath`,
    `buildChapterNodes`) was removed — it duplicated `/subject/$subjectId` with a divergent
    unlock logic; there is now **one** chapter screen.

  (Leaderboard has no feature folder — `getLeaderboard` lives in `dashboard.server.ts`.
  Onboarding has no feature folder — it is an inline route at `routes/_authenticated/onboarding.tsx`.)

- **Features never import other features** — share via `src/shared/`. Routes stay thin (no business logic).
- Import aliases: `@/features/{name}`, `@/shared/lib|constants|types|integrations/...`. UI primitives live at `@/components/ui/*`, i18n at `@/lib/i18n`, the mobile hook at `@/hooks/use-mobile`.
- Input validation with **zod** on every server fn (`.inputValidator`). Sanitize HTML with DOMPurify (`src/shared/lib/markdown.ts`).
- Naming: kebab-case files, server fns are verbs (`getSubject`, `submitAttempt`). Structured logging via `@/shared/lib/logger` (redacts secrets) — not raw `console`.

## Subsystems & further docs

- **Subject content → SQL migrations (the right way to add content).** Authored content
  lives under `content/` (one dir per subject). The deterministic generator in
  `src/shared/content/{schema,loader,sql-builder}.ts` validates it (zod schema) and emits an
  idempotent Supabase migration per subject (stable v5 UUIDs, no machine-dependent output).
  Scripts: `npm run content:build` (regenerate migrations into `supabase/migrations/`),
  `npm run content:check` (build in `--check` mode, no writes), `npm run content:qa` /
  `content:qa:strict` (content QA; strict variant runs in `ci:verify`). **Add subjects/
  chapters/exercises by editing `content/` and rebuilding — never hand-write content
  migrations.**
- **End-to-end tests (Playwright).** Specs live in `/e2e`; config is `playwright.config.ts`
  (repo root).
  Scripts: `npm run test:e2e` (public projects: `public-chromium` + `public-mobile`),
  `npm run test:e2e:auth` (`authed-chromium`), `npm run test:e2e:install` (install the
  browser). Authenticated runs are seeded via `scripts/e2e/seed-test-users.mjs`. E2E is
  separate from the Vitest unit/integration gate.
- **Policy docs (`docs/*.md`).** Topic-specific rules referenced from here:
  `docs/environment-variables.md`, `docs/logging-standard.md`, `docs/xss-rendering-policy.md`,
  `docs/release-tagging-policy.md`, `docs/dependency-maintenance.md`. These defer to
  CLAUDE.md / ARCHITECTURE.md for anything that overlaps.

## Working mode — Definition of Done

A change is **done** only when ALL of these hold. This is non-negotiable; it is how
the project stays regression- and debt-free while being improved by AI.

1. **The gate is green.** Run `npm run verify` (lint + typecheck + tests). For
   release-grade work run `npm run ci:verify` (adds coverage + build + audit).
   Never report a task complete on a red gate. (Skill: `/verify`.)
2. **No weakening the gate.** Do not silence problems instead of fixing them:
   no `// @ts-ignore` / `as any` to dodge types, no disabling ESLint rules inline,
   no lowering Vitest coverage thresholds, no `--no-verify`. If an exception is
   truly warranted, get explicit sign-off and document _why_ in the code.
3. **No new tech debt.** No backward-compat shims, no dead code, no duplicated
   modules. Delete what you replace. Respect the feature/shared boundaries
   (features never import features).
4. **Types are real.** `tsc` must pass. The Supabase types in
   `src/shared/integrations/supabase/types.ts` are generated — prefer regenerating
   (`supabase gen types`) over hand-editing; if you must hand-edit (offline), keep it
   minimal and note it.
5. **Tests travel with code.** New/changed behavior ships with co-located tests in
   the feature's `__tests__/`. Coverage must not regress.
6. **Small, reviewable commits.** Branch off `main`; commit/push only when asked.
   Conventional-commit style messages (`feat:`, `fix:`, `test:`, `chore:`…).
7. **DB ↔ code changes are coordinated.** Pushing to `main` **auto-deploys to
   Vercel production**. So when a code change depends on a new Supabase migration
   (new table/column/RPC, or revoked grants), the migration MUST be applied to the
   DB **before** the code is pushed/deployed — otherwise prod runs code against a
   schema that doesn't support it. Order: apply migration → verify → then push code.
   Migrations are not auto-applied by the repo; apply them via the Supabase SQL
   editor or `supabase db push`.

When unsure about scope or a destructive action, ask before proceeding.

## Known gotchas / traps

- **Feature/shared migration is complete.** All backward-compat re-export shims
  (`src/lib/gamification.*`, `dashboard-helpers`, `family-link`, `guest-access`) and the
  duplicated `src/lib/*` utils / `src/integrations/supabase/*` / `src/hooks/use-auth` /
  `src/components/dashboard/*` copies have been removed. Canonical homes:
  server fns + helpers → `@/features/{name}`; utils/logger/supabase/types → `@/shared/*`.
- **Not yet relocated to `shared/` (still real code, not shims):** i18n lives at `@/lib/i18n`,
  the mobile hook at `@/hooks/use-mobile`, and shadcn UI primitives at `@/components/ui/*`.
  There is **no `src/shared/ui`** directory — import UI primitives as `@/components/ui/*`
  (the `@/*` alias maps to `./src/*`). There is no `src/integrations/` directory either; the
  Supabase client/middleware live at `@/shared/integrations/supabase/*`. The `useAuth` hook
  lives at `@/features/auth` (not `@/hooks`).
- `src/routeTree.gen.ts` is auto-generated — never edit by hand.
- `src/shared/integrations/supabase/auth-middleware.ts` is marked "automatically generated";
  edit with care.
- Env vars required at runtime: `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY` (set in the deploy
  platform). Missing → middleware throws a descriptive error.
- The Vite config is **inline** in `vite.config.ts` — the TanStack Start, React, Tailwind,
  Cloudflare and tsconfig-paths plugins are composed by hand (the old
  `@lovable.dev/vite-tanstack-config` meta-plugin was de-vendored and `bun.lock` dropped).
  `manualChunks` there is hand-tuned to the bundle budgets; reshaping vendor groups can
  introduce a circular vendor chunk (prod-crash risk), so change it deliberately and re-run
  `npm run build:check`. The `esbuild` override in `package.json` is a security pin — keep it.
- **Coverage is scoped to owned code** (`features/`, `shared/`, `lib/`, `hooks/`) in
  `vitest.config.ts`; vendored shadcn UI (`components/ui`), thin route wrappers,
  barrels, generated files, and SSR entry glue are excluded by design. Thresholds are
  **80%** on all metrics (actual ≈ 93% stmts / 93% lines / 81% branches). Don't lower them,
  and don't widen `include` to dilute the metric with vendored/glue code.
- Some server fns defensively tolerate missing RPCs (e.g. `get_best_scores_by_exercise`
  falls back to empty) — keep that graceful-degradation pattern.
- **New tables need EXPLICIT grants.** The base migrations carry almost no `GRANT`s, and
  the CI local stack (db-tests.yml) stopped applying Supabase's default table privileges
  (supabase/postgres ≥ 17.6.1.134): a `CREATE TABLE` without its own
  `GRANT SELECT … TO authenticated` works on cloud but breaks the nightly pgTAP suite on a
  fresh DB. The end-state baseline lives in `20260612221000_baseline_table_grants.sql`;
  every new table migration must ship its own grants. The Supabase CLI is **version-pinned**
  in `db-tests.yml` / `e2e-auth.yml` — bump deliberately, with a green run.
- **E2E ≠ unit gate.** Playwright specs (`e2e/`, run via `e2e.yml` / `e2e-auth.yml`) hit a
  **dedicated TEST Supabase project** with seeded users (`scripts/e2e/`), not the unit-test
  mocks. They are not part of `npm run verify`/`ci:verify`; don't point them at prod.
- **CI workflow runs a subset.** `.github/workflows/ci.yml` runs lint + typecheck +
  test:coverage + build:check + audit:deps — it does **not** run `content:qa:strict` (only the
  local `ci:verify` script does). Run `content:qa:strict` yourself when touching `content/`.
- The Copilot guide (`.github/copilot-instructions.md`) still references `@/shared/ui/` for UI
  primitives — that move never happened; use `@/components/ui/*` (same drift noted above).
