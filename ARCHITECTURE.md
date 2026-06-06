# Architecture — XP Scholars (yahia-quest-arena)

> **Purpose**: Single source of truth for any AI or developer working on this codebase.
> Read this file first before making any change.

---

## 1. What is this project?

A gamified education platform for Tunisian 9th graders preparing their national exam.
Students progress through subjects as "quests", earn XP/coins, unlock badges, and compete
on a leaderboard — all presented with a shonen manga/RPG aesthetic.

**Live stack**: Vite 7 + TanStack Start (SSR) + React 19 + Supabase (Postgres + Auth) + Cloudflare Workers.

---

## 2. Directory structure

```
src/
├── features/           ← Domain modules (one folder per bounded context — 10 total)
│   ├── auth/           ← Login, signup, guest access, session management (incl. use-auth)
│   ├── dashboard/      ← Main dashboard: stats, radar, recent attempts, leaderboard
│   ├── quest/          ← Exercise flow: subject → chapter → exercise → submit
│   ├── dungeon/        ← Boss/dungeon mode: timed floor-by-floor challenge
│   ├── shop/           ← In-game shop: purchase & equip skins, consumables
│   ├── progression/    ← Spaced repetition, daily objectives, weekly quests, difficulty
│   ├── parent-report/  ← Family link + parent progress report
│   ├── subscription/   ← Premium gate (difficulty 3+ / premium modules) + beta access + admin
│   ├── content-report/ ← User-flagged content errors ("Signaler une erreur") + admin triage
│   └── parcours/       ← Gamified journey-map / adventure-path over subjects & chapters
│
│   (Leaderboard has no feature folder — `getLeaderboard` lives in dashboard.server.ts.
│    Onboarding has no feature folder — it is an inline route at
│    routes/_authenticated/onboarding.tsx.)
│
├── shared/             ← Cross-cutting code shared by multiple features
│   ├── lib/            ← Utilities (cn, logger, error-capture, markdown, rate-limit)
│   ├── constants/      ← Global gameplay constants
│   ├── types/          ← Shared TypeScript types
│   ├── content/        ← Subject content schema/loader/sql-builder (content → SQL migrations)
│   └── integrations/   ← Supabase client, auth middleware
│
├── components/         ← Non-feature React components
│   ├── ui/             ← shadcn/Radix UI primitives — imported as `@/components/ui/*`
│   ├── landing/        ← Public landing-page components
│   └── visual/         ← Decorative / visual-effect components
├── hooks/              ← Shared React hooks (use-mobile)  [use-auth lives in features/auth]
├── lib/                ← i18n (`@/lib/i18n`) and other not-yet-relocated shared code
├── routes/             ← TanStack Router file-based routes (THIN wrappers only)
├── assets/             ← Static assets (images, fonts)
├── styles.css          ← Global Tailwind styles
├── router.tsx          ← Router factory
├── routeTree.gen.ts    ← Auto-generated route tree (DO NOT EDIT)
├── server.ts           ← SSR entry with error wrapper
└── start.ts            ← Client entry
```

> **Note**: there is no `src/shared/ui`. UI primitives live in `src/components/ui` and are
> imported as `@/components/ui/*` (the `@/*` alias maps to `./src/*`).

---

## 3. Feature module conventions

Each feature folder follows this structure:

```
features/{name}/
├── index.ts            ← Barrel export (PUBLIC API of this feature)
├── {name}.server.ts    ← Server functions (createServerFn)
├── {name}.types.ts     ← Types specific to this feature (optional)
├── {name}.constants.ts ← Constants specific to this feature (optional)
├── components/         ← React components used only by this feature
│   └── {Component}.tsx
└── __tests__/          ← Tests co-located with the feature
    └── {name}.test.ts
```

### Rules:

1. **Features NEVER import from other features** — use shared/ instead.
2. **Routes are thin** — they import from features and compose UI; no business logic in routes.
3. **Barrel exports define the public API** — only export what other modules need.
4. **Tests co-locate with code** — makes it easy to know what to test when modifying a feature.

---

## 4. Import path conventions

| What you need                | Import from                                |
| ---------------------------- | ------------------------------------------ |
| Feature server function      | `@/features/{name}`                        |
| Feature component            | `@/features/{name}/components/{Component}` |
| UI primitive (Button, Card…) | `@/components/ui/{component}`              |
| Utility (cn, logger…)        | `@/shared/lib/{module}`                    |
| Gameplay constants           | `@/shared/constants/gamification`          |
| Shared types                 | `@/shared/types/{module}`                  |
| Supabase client/middleware   | `@/shared/integrations/supabase/{module}`  |
| i18n                         | `@/lib/i18n`                               |
| Auth hook (`useAuth`)        | `@/features/auth`                          |
| Mobile hook (`useIsMobile`)  | `@/hooks/use-mobile`                       |

---

## 5. Tech stack details

| Layer     | Technology                 | Notes                                        |
| --------- | -------------------------- | -------------------------------------------- |
| Framework | TanStack Start 1.x         | File-based routing, SSR, server functions    |
| UI        | React 19 + Radix/shadcn    | Tailwind CSS 4, motion (Framer Motion)       |
| State     | TanStack Query 5           | Server state; no client global store         |
| Auth      | Supabase Auth              | JWT passed via cookie → server middleware    |
| DB        | Supabase Postgres          | Row-level security, SQL RPCs for complex ops |
| Deploy    | Cloudflare Workers         | Via @cloudflare/vite-plugin                  |
| Tests     | Vitest 4 + Testing Library | Unit + integration; mocked Supabase          |
| Lint      | ESLint 9 + Prettier        | Zero-warning policy                          |

---

## 6. Server function pattern

All data fetching uses TanStack Start `createServerFn`:

```typescript
import { createServerFn } from "@tanstack/react-start";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";

export const myFunction = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;
    // ... query supabase ...
    return data;
  });
```

The middleware injects `supabase` (authenticated client) and `userId` into context.

---

## 7. Testing strategy

- **Unit tests**: Pure functions (constants, utils, question-utils).
- **Integration tests**: Server functions with mocked Supabase client.
- **Component tests**: React components with Testing Library.
- **Coverage thresholds**: **80%** on all metrics (statements, lines, functions, branches),
  enforced globally in `vitest.config.ts`. Coverage is scoped to owned code
  (`features/`, `shared/`, `lib/`, `hooks/`); vendored UI, route wrappers, barrels,
  generated files, and SSR glue are excluded by design.
- **End-to-end**: Playwright specs under `/e2e` (config `playwright.config.ts` at the repo
  root), run via `npm run test:e2e` / `test:e2e:auth`; separate from the Vitest gate. See
  CLAUDE.md "Subsystems & further docs".

Run tests: `npm test` (run it for the current test/file count)
Run with coverage: `npm run test:coverage`

---

## 8. Key data model (Supabase tables)

| Table                      | Purpose                                                |
| -------------------------- | ------------------------------------------------------ |
| profiles                   | Student profile (XP, level, streak, coins, hero_class) |
| subjects                   | Math, Science, etc.                                    |
| chapters                   | Chapters within a subject                              |
| exercises                  | Exercises within a chapter                             |
| questions                  | Multiple-choice questions within an exercise           |
| attempts                   | Student exercise attempt results                       |
| student_badges             | Awarded badges                                         |
| shop_items                 | Purchasable items                                      |
| inventory_items            | Student-owned items                                    |
| daily_objectives           | Daily goals (auto-created)                             |
| weekly_quests              | Weekly challenges                                      |
| spaced_repetition_schedule | SM-2 style review schedule                             |
| dungeon_runs               | Boss mode run state                                    |
| family_links               | Parent-student linking                                 |
| subscriptions              | Premium-gate state (difficulty 3+ / premium modules)   |
| beta_access_requests       | Beta-access requests + admin review                    |
| content_reports            | User-flagged content errors ("Signaler une erreur")    |
| themes                     | Selectable visual themes                               |
| grades                     | Grade levels (e.g. 9th grade)                          |

### Consumables (shop items)

`shop_items` rows have an `item_type` and a JSONB `effect_payload`. `skin` items are
cosmetic (equipped via `is_equipped`). The three **live consumable mechanics** are wired
through SECURITY DEFINER RPCs (consumable migrations under
`supabase/migrations/202606061200…` / `…130000…`) and share one inventory flag:
**`inventory_items.is_active` = "armed"**.

| Mechanic      | `item_type`          | `effect_payload`                  | Seed example                                                        |
| ------------- | -------------------- | --------------------------------- | ------------------------------------------------------------------- |
| Potions       | `potion`             | `xpMultiplier` / `coinMultiplier` | `potion_xp_boost`, `potion_coins`                                   |
| Retry shield  | `shield`             | `retries`                         | `shield_retry`                                                      |
| Streak shield | `shield`             | `streakShield`                    | `bouclier_flamme`                                                   |
| Hints         | `booster` / `potion` | `hints` / `hintBoost`             | `booster_hint` (`{"hints":3}`), `potion_rappel` (`{"hintBoost":1}`) |

**Two-slot arming model** (`activate_inventory_item`): a consumable is "armed" by setting
`is_active = true`. The slot is derived from the `effect_payload`:

- **Next-quest slot** — `xpMultiplier`/`coinMultiplier`/`retries` (multiplier potions +
  retry shield). One armed at a time; arming one clears the other next-quest rows.
- **Passive slot** — `streakShield` (streak shield). Independent of the next-quest slot
  (arming a passive item never disarms a next-quest item, and vice-versa).
- **Hints are not armed** — they are spent on demand during a quest, not pre-armed.

**Mechanics:**

- **Potions** — on the next _eligible_ quest, `submit_exercise_attempt` multiplies the
  earned XP/coins by the armed potion's multiplier, then consumes it (`quantity − 1`, row
  deleted at 0, `is_active` cleared). Surfaced as `potionApplied` in the response.
- **Retry shield** (`retries`) — on a `<60%` fail with the shield armed,
  `submit_exercise_attempt` **suppresses the spaced-repetition penalty** (skips scheduling)
  and consumes the shield (`retryShieldUsed = true`). "Best of two" needs no extra code —
  the existing best-score eligibility gate (`score > previous best`) already keeps the
  higher replay score.
- **Streak shield** (`streakShield`) — passive. In `award_xp`, when the student is active
  after missing **exactly one day** (`last_active_date = today − 2 days`), an armed streak
  shield is consumed to preserve the streak. Gaps of ≥ 2 missed days reset to 1 and do
  **not** consume the shield.
- **Hints** (`hints`/`hintBoost`) — reveal a question's `questions.explanation` on demand
  during a quest (the per-question "Indice" button), decrementing one charge via the
  `consume_hint` RPC. Not armed and not tied to submit. No XP/reward effect. Anti-waste: a
  charge is spent **only** when there is actually a hint to reveal — a question with no
  explanation returns `consumed = false` and costs nothing.

**Anti-waste & anti-cheat invariant:** a consumable is consumed **only when it actually
takes effect** (a potion only on a reward-earning attempt; a retry shield only on an actual
penalised fail; a streak shield only on an exactly-one-day gap). Consumables never grant XP
on their own and never bypass the `tooFast` / `≥ 60%` / `improved` anti-farm gates in
`submit_exercise_attempt` — the potion multiplier applies _after_ those gates have already
passed.

The consumable RPCs (`activate_inventory_item`, `submit_exercise_attempt`, `award_xp`, and
`consume_hint`) are `REVOKE`d from anon. Per §7 (DB ↔ code coordination),
these consumable migrations must be applied to the database **before** the matching code is
deployed.

---

## 9. How to add a new feature

1. Create `src/features/{name}/` with the structure above.
2. Add server functions in `{name}.server.ts`.
3. Add the route in `src/routes/` importing from the feature barrel.
4. Add tests in `features/{name}/__tests__/`.
5. Export public API from `features/{name}/index.ts`.
6. Update this ARCHITECTURE.md if the feature introduces new conventions.

---

## 10. Commands

```bash
npm run dev          # Start dev server (Vite + SSR)
npm run build        # Production build
npm run test         # Run all tests (run it for the current count)
npm run test:watch   # Watch mode
npm run test:e2e     # Playwright E2E (public projects); :auth for authed
npm run lint         # ESLint (zero warnings)
npm run content:build  # Regenerate subject SQL migrations from content/
npm run content:qa     # Content QA checks (:strict in ci:verify)
npm run ci:verify    # Full CI pipeline (lint + typecheck + coverage + build + audit + content:qa:strict)
```

### Adding subject content (not a feature)

Authored content lives under `content/` (one dir per subject). To add or change
subjects/chapters/exercises, **edit `content/` and regenerate** — do not hand-write content
migrations. `src/shared/content/{schema,loader,sql-builder}.ts` validates the tree (zod)
and emits one idempotent Supabase migration per subject (stable v5 UUIDs). Run
`npm run content:build` to write migrations, `npm run content:check` to validate without
writing, and `npm run content:qa` for QA.

---

## 11. Deployment

- **Platform**: Cloudflare Workers (via Vercel adapter fallback for preview).
- **Build**: `vite build` → outputs worker bundle.
- **Config**: `wrangler.jsonc` for Cloudflare, `vercel.json` for Vercel preview.
- **Env vars**: `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY` (set in deploy platform).

---

## 12. Backward compatibility

The feature-based migration is complete. The old `@/lib/gamification.*` re-export shims and
the duplicated `@/lib/*`, `@/integrations/supabase/*`, `@/hooks/use-auth`, and
`@/components/dashboard/*` copies have been removed. Always import from `@/features/{name}`
or `@/shared/`.

Still living outside `shared/` (real code with no `shared`/`feature` home, not shims):
`@/lib/i18n`, `@/hooks/use-mobile`, and `@/components/ui/*` (shadcn primitives). There is no
`src/shared/ui` directory — UI primitives are imported as `@/components/ui/*`. There is no
`src/integrations/` directory either; the Supabase client/middleware live at
`@/shared/integrations/supabase/*`.
