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
├── features/           ← Domain modules (one folder per bounded context)
│   ├── auth/           ← Login, signup, guest access, session management
│   ├── dashboard/      ← Main dashboard: stats, radar, recent attempts
│   ├── quest/          ← Exercise flow: subject → chapter → exercise → submit
│   ├── dungeon/        ← Boss/dungeon mode: timed floor-by-floor challenge
│   ├── shop/           ← In-game shop: purchase & equip skins
│   ├── progression/    ← Spaced repetition, daily objectives, weekly quests, difficulty
│   └── parent-report/  ← Family link + parent progress report
│
│   (Leaderboard has no feature folder — `getLeaderboard` lives in dashboard.server.ts.
│    Onboarding has no feature folder — it is an inline route at
│    routes/_authenticated/onboarding.tsx.)
│
├── shared/             ← Cross-cutting code shared by multiple features
│   ├── ui/             ← Reusable UI components (shadcn/Radix primitives)
│   ├── lib/            ← Utilities (cn, logger, error-capture, markdown, rate-limit)
│   ├── constants/      ← Global gameplay constants
│   ├── types/          ← Shared TypeScript types
│   └── integrations/   ← Supabase client, auth middleware
│
├── hooks/              ← Shared React hooks (use-auth, use-mobile)
├── routes/             ← TanStack Router file-based routes (THIN wrappers only)
├── assets/             ← Static assets (images, fonts)
├── styles.css          ← Global Tailwind styles
├── router.tsx          ← Router factory
├── routeTree.gen.ts    ← Auto-generated route tree (DO NOT EDIT)
├── server.ts           ← SSR entry with error wrapper
└── start.ts            ← Client entry
```

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
| UI primitive (Button, Card…) | `@/shared/ui/{component}`                  |
| Utility (cn, logger…)        | `@/shared/lib/{module}`                    |
| Gameplay constants           | `@/shared/constants/gamification`          |
| Shared types                 | `@/shared/types/{module}`                  |
| Supabase client/middleware   | `@/shared/integrations/supabase/{module}`  |
| React hook                   | `@/hooks/{hook}`                           |

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
- **Coverage target**: Statements > 60% per feature.

Run tests: `npm test`
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
- **Hints** (`hints`/`hintBoost`) — _in progress; branch not yet merged._ Reveal a
  question's `questions.explanation` on demand during a quest, decrementing a charge via a
  `consume_hint` RPC. No XP/reward effect.

**Anti-waste & anti-cheat invariant:** a consumable is consumed **only when it actually
takes effect** (a potion only on a reward-earning attempt; a retry shield only on an actual
penalised fail; a streak shield only on an exactly-one-day gap). Consumables never grant XP
on their own and never bypass the `tooFast` / `≥ 60%` / `improved` anti-farm gates in
`submit_exercise_attempt` — the potion multiplier applies _after_ those gates have already
passed.

The consumable RPCs (`activate_inventory_item`, `submit_exercise_attempt`, `award_xp`, and
the in-progress `consume_hint`) are `REVOKE`d from anon. Per §7 (DB ↔ code coordination),
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
npm run test         # Run all tests
npm run test:watch   # Watch mode
npm run lint         # ESLint (zero warnings)
npm run ci:verify    # Full CI pipeline (lint + test + build + audit)
```

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
`@/lib/i18n`, `@/hooks/use-mobile`, and `@/components/ui/*` (shadcn primitives — the
`@/shared/ui` location in §4 is aspirational and not yet adopted). There is no
`src/integrations/` directory; the Supabase client/middleware live at
`@/shared/integrations/supabase/*`.
