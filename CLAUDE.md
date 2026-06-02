# CLAUDE.md — yahia-quest-arena (XP Scholars)

> Operational guide for AI/devs. For the full architecture deep-dive, read [`ARCHITECTURE.md`](./ARCHITECTURE.md) first — this file covers commands, conventions, and gotchas not obvious from the code.

## What this is

Gamified education platform for Tunisian 9th graders prepping the national exam.
Students do subject "quests" (QCM exercises), earn XP/coins, unlock badges, level up
hero classes, compete on a leaderboard, and tackle a timed "dungeon" boss mode.
Shonen/RPG manga aesthetic, trilingual (FR/EN/AR with RTL).

**Stack**: Vite 7 · TanStack Start (SSR + file routing + server fns) · React 19 · TanStack Query 5 · Supabase (Postgres + Auth + RLS) · Tailwind 4 / Radix-shadcn · deploy on Cloudflare Workers (Vercel preview fallback). Package manager: **bun** (`bun.lock`), npm scripts work too. Tests: Vitest 4 + Testing Library.

## Essential commands

```bash
npm run dev          # Vite dev server (SSR)
npm run build        # production build
npm run build:check  # build + bundle-budget check
npm test             # vitest run (312 tests / 28 files)
npm run test:watch   # watch mode
npm run test:coverage
npm run lint         # eslint src --max-warnings=0  (zero-warning policy)
npm run typecheck    # tsc --noEmit (strict)
npm run format       # prettier --write .
npm run verify       # lint + typecheck + test       (fast local gate / pre-push)
npm run ci:verify    # verify + coverage + build:check + audit:deps  (full CI gate)
```

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

`profiles` (xp/level/streak/coins/hero_class/role) · `subjects` → `chapters` → `exercises`
→ `questions` (QCM, `options` JSONB) · `attempts` · `exercise_sessions` · `student_badges` /
`shop_items` / `inventory_items` · `daily_objectives` · `weekly_quests` ·
`spaced_repetition_schedule` (SM-2) · `dungeon_runs` · `family_links`.

Server-side logic lives in SQL: `handle_new_user` (auto-profile on signup), `award_xp`
(streak + level curve: 200 XP/level, hero-class tiers), and the `submit_exercise_attempt`
RPC (atomic scoring + rewards + badge unlocks). All tables have RLS; the two privileged
functions are `REVOKE`d from anon/authenticated. Gameplay thresholds are centralized in
`src/shared/constants/gamification.ts` — change rules there, not inline.

## Conventions

- Feature-based: `src/features/{auth,dashboard,quest,dungeon,shop,progression,leaderboard,parent-report,onboarding}/`.
  Each has `index.ts` (public barrel), `{name}.server.ts`, optional `components/`, `__tests__/`.
- **Features never import other features** — share via `src/shared/`. Routes stay thin (no business logic).
- Import aliases: `@/features/{name}`, `@/shared/lib|constants|types|integrations/...`. UI primitives live at `@/components/ui/*`, i18n at `@/lib/i18n`, the mobile hook at `@/hooks/use-mobile`.
- Input validation with **zod** on every server fn (`.inputValidator`). Sanitize HTML with DOMPurify (`src/shared/lib/markdown.ts`).
- Naming: kebab-case files, server fns are verbs (`getSubject`, `submitAttempt`). Structured logging via `@/shared/lib/logger` (redacts secrets) — not raw `console`.

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
  the mobile hook at `@/hooks/use-mobile`, shadcn UI primitives at `@/components/ui/*`,
  and the Lovable integration at `@/integrations/lovable`. ARCHITECTURE.md aspirationally
  lists `@/shared/ui` — that move hasn't happened; use `@/components/ui` in practice.
- `src/routeTree.gen.ts` is auto-generated — never edit by hand.
- `src/shared/integrations/supabase/auth-middleware.ts` is marked "automatically generated";
  edit with care.
- Env vars required at runtime: `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY` (set in deploy
  platform / Lovable Cloud). Missing → middleware throws a descriptive error.
- This is a Lovable-generated project (`.lovable/`, `bunfig.toml`).
- **Coverage is scoped to owned code** (`features/`, `shared/`, `lib/`, `hooks/`) in
  `vitest.config.ts`; vendored shadcn UI (`components/ui`), thin route wrappers,
  barrels, generated files, and SSR entry glue are excluded by design. Thresholds are
  **60%** (actual ≈ 85% stmts / 89% lines). Don't lower them, and don't widen `include`
  to dilute the metric with vendored/glue code.
- Some server fns defensively tolerate missing RPCs (e.g. `get_best_scores_by_exercise`
  falls back to empty) — keep that graceful-degradation pattern.
