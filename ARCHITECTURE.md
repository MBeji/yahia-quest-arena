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
│   ├── leaderboard/    ← XP leaderboard
│   ├── parent-report/  ← Family link + parent progress report
│   └── onboarding/     ← First-time user onboarding flow
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
`@/lib/i18n`, `@/hooks/use-mobile`, `@/components/ui/*` (shadcn primitives — the `@/shared/ui`
location in §4 is aspirational and not yet adopted), and `@/integrations/lovable`.
