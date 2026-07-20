# Architecture — Na9ra Nal3ab (yahia-quest-arena)

> **Purpose**: architecture companion to [`AGENTS.md`](./AGENTS.md) (which wins on any
> conflict — `CLAUDE.md` is a Claude Code pointer to it). Read this file before making
> structural changes. Project state (phase, dated decisions, feature status) lives in
> [`STATUS.md`](./STATUS.md).

---

## 1. What is this project?

A gamified learning **academy** for the Tunisian curriculum — a public platform, **100 % free in
the current phase** (pivot of 2026-06-21 + étude 15 Q-2; see `STATUS.md`): the whole catalogue
(13 school grades with the concours milestones 6ème/9ème/bac, plus culture générale,
brain-training and language tracks) can be browsed **and practiced without an account**.
Signed-in students progress through subjects as "quests", earn XP/coins, unlock badges, duel
each other in real time and compete on a leaderboard — shonen manga/RPG aesthetic, trilingual
(FR/EN/AR with RTL). A per-parcours premium layer exists in the schema but is **dormant** (§8a).

**Live stack**: Vite 8 + TanStack Start (SSR) + React 19 + Supabase (Postgres + Auth) — **deployed on Vercel** (a Cloudflare Workers config survives as a vestige, not the live target).

---

## 2. Directory structure

```
src/
├── features/           ← Domain modules (one folder per bounded context — 13 total)
│   ├── auth/           ← Login, signup, guest access, session management (incl. use-auth)
│   ├── dashboard/      ← Main dashboard: stats, radar, recent attempts, leaderboard
│   ├── quest/          ← Exercise flow: subject → chapter → exercise → submit
│   ├── dungeon/        ← Boss/dungeon mode: timed floor-by-floor challenge
│   ├── duel/           ← Real-time duels + weekly leagues (étude 05)
│   ├── shop/           ← In-game shop: purchase & equip skins, consumables
│   ├── progression/    ← Spaced repetition, daily objectives, weekly quests, difficulty
│   ├── parent-report/  ← Family link + parent progress report (incl. public report by alliance code)
│   ├── subscription/   ← DORMANT premium layer: entitlements + beta access + paywall + admin RPCs
│   ├── content-report/ ← User-flagged content errors ("Signaler une erreur") + admin triage
│   ├── bug-report/     ← User bug reports (global launcher) + admin triage
│   ├── notifications/  ← Web-push subscriptions + service-worker push handlers
│   └── parcours/       ← Gamified journey-map: world map of subjects (/parcours); nodes route to /matiere/$subjectId
│
│   (Leaderboard has no feature folder — `getLeaderboard` lives in dashboard.server.ts.
│    Onboarding has no feature folder — it is an inline route at
│    routes/_authenticated/onboarding.tsx.)
│
├── shared/             ← Cross-cutting code shared by multiple features
│   ├── lib/            ← Utilities (cn, logger, error-capture, markdown, rate-limit)
│   ├── constants/      ← Global gameplay constants
│   ├── types/          ← Shared TypeScript types
│   ├── content/        ← Content ENGINE: schema/loader/sql-builder (corpus files → SQL). Corpus itself is private
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

| Layer     | Technology                 | Notes                                                           |
| --------- | -------------------------- | --------------------------------------------------------------- |
| Framework | TanStack Start 1.x         | File-based routing, SSR, server functions                       |
| UI        | React 19 + Radix/shadcn    | Tailwind CSS 4, motion (Framer Motion)                          |
| State     | TanStack Query 5           | Server state; no client global store                            |
| Auth      | Supabase Auth              | JWT passed via cookie → server middleware                       |
| DB        | Supabase Postgres          | Row-level security, SQL RPCs for complex ops                    |
| Deploy    | Vercel                     | Push to `main` = prod (build-vercel.mjs); migrations auto-apply |
| Tests     | Vitest 4 + Testing Library | Unit + integration; mocked Supabase                             |
| Lint      | ESLint 10 + Prettier       | Zero-warning policy                                             |

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
  [`e2e/README.md`](./e2e/README.md).

Run tests: `npm test` (run it for the current test/file count)
Run with coverage: `npm run test:coverage`

---

## 8. Key data model (Supabase tables)

| Table                                  | Purpose                                                                               |
| -------------------------------------- | ------------------------------------------------------------------------------------- |
| profiles                               | Student profile (XP, level, streak, coins, hero_class, current_parcours_id)           |
| subjects                               | Math, Science, etc.                                                                   |
| chapters                               | Chapters within a subject                                                             |
| exercises                              | Exercises within a chapter                                                            |
| questions                              | Multiple-choice questions within an exercise                                          |
| attempts                               | Student exercise attempt results (`variant` classic/recall — étude 17)                |
| student_badges                         | Awarded badges                                                                        |
| shop_items                             | Purchasable items                                                                     |
| inventory_items                        | Student-owned items                                                                   |
| daily_objectives                       | Daily goals (auto-created)                                                            |
| weekly_quests                          | Weekly challenges                                                                     |
| spaced_repetition_schedule             | SM-2 style review schedule                                                            |
| dungeon_runs                           | Boss mode run state                                                                   |
| exercise_sessions                      | Server-authoritative quest sessions (`variant` classic/recall; direct writes REVOKEd) |
| duel_queue / duels / duel_participants | Real-time duels + weekly leagues (étude 05)                                           |
| parent_student_links                   | Parent-student linking                                                                |
| parcours                               | Tracks — kinds concours/scolaire/libre; **all free in the current phase**             |
| parcours_entitlements                  | Per-parcours grants (purchase/beta/gift/family) — dormant                             |
| parcours_interest                      | Interest votes on `coming_soon` parcours                                              |
| subscriptions (DEPRECATED)             | Removed in migration 20260609000000 → parcours_entitlements                           |
| beta_access_requests                   | Beta-access requests + admin review                                                   |
| content_reports                        | User-flagged content errors ("Signaler une erreur")                                   |
| bug_reports                            | User bug reports + admin triage                                                       |
| question_attempts                      | Append-only per-question telemetry (adaptive engine A0)                               |
| user_misconceptions                    | Per-(user, misconception-tag) aggregate, trigger-maintained                           |
| themes                                 | Top-level content tracks (école-tn, culture-générale…)                                |
| grades                                 | Grade levels (e.g. 9th grade; incl. lycée section nodes)                              |

### 8a. Access model (parcours + entitlements) — premium DORMANT in the free phase

**Current state** (free phase — migration `20260711100000`, 2026-07-11): every parcours has
`is_premium = false`, so the gate below short-circuits to "allowed" for **every** exercise, the
paywall is unreachable, and no user-facing surface may use premium vocabulary (étude 15 D-3).
The machinery is intact and reversible — étude 01 (paiement en ligne, **gelée**) is the
designated re-activation vehicle.

Access is **per-parcours**, not global. A **parcours** is the student's enrolled track
(`profiles.current_parcours_id`), resolved from a `(theme_id, grade_id)` pair. Kinds:

- **concours** — `concours-9eme`, `concours-6eme`, `concours-bac-math` (the historical premium
  milestones), under theme `ecole-tn`.
- **scolaire** — one per school grade (full Tunisian ladder, incl. lycée section nodes).
- **libre** — one per standalone theme (culture-générale, muscle-cerveau, langues…), `grade_id` NULL.

`parcours_entitlements` (`user_id`, `parcours_id`, `source` ∈ {purchase|beta|gift|family},
`expires_at` nullable = perpetual, `revoked_at` soft-delete) holds the grants. The **single
authoritative gate** is the SECURITY DEFINER RPC `resolve_exercise_access(exercise)`:

- Non-premium parcours (all of them today) → always allowed.
- A premium parcours would be allowed iff the caller holds a live entitlement
  (`has_parcours_entitlement`, which also honors an **active linked parent's** grant — the
  _family pack_), **or** the exercise is in the **free preview** (the chapter comprehension quiz +
  difficulty-1 missions, `FREE_PREVIEW_MAX_DIFFICULTY`). A `coming_soon` parcours returns a
  distinct reason.

The Dungeon is **no longer entitlement-gated**: `get_dungeon_access()` keeps only the progression
locks (PREREQ / LEVEL / DAILY_LIMIT) — the `SUBSCRIPTION` reason was removed by the free-phase
migration. Admin provisioning stays live (`/admin/subscriptions`): `admin_grant_parcours` /
`admin_revoke_parcours` / `admin_list_parcours_entitlements`; onboarding sets the active track via
`set_current_parcours`. Migrations: `20260608120000` (entity + RPCs), `…121000` (resolver),
`…122000` (backfill), `…123000` (dungeon gate), `20260609000000` (drops the legacy
`subscription_*` columns + RPCs), `20260617120000` (kind `scolaire` + `parcours_interest`),
`20260711100000` (**free phase**: `is_premium = false` everywhere + dungeon un-gated).

---

### 8b. Active recall (recall variant) — étude 17

A **mastered** QCM mission unlocks a second form: the same questions, **no options shown**, the
student **types** the answer, and the server compares it — normalized — to the correct option
already in the DB. It is a display + scoring **mode** of an existing exercise (no new content, no
new `question_type`), harder and worth **1.5× XP** (`RECALL_XP_MULTIPLIER`).

- **Wire**: the recall run travels as the `?variant=recall` search param on `/quest/$exerciseId`
  (default `classic`); `attempts.variant` / `exercise_sessions.variant` (`'classic'` default,
  CHECK-constrained) record which form was played.
- **Eligibility (R-2)** is computed server-side by the IMMUTABLE `is_question_recall_eligible`
  (real MCQ, ≥3 options, keyed answer 1–60 chars, self-sufficient prompt, no figure). A mission
  needs ≥ `RECALL_MIN_QUESTIONS` (3) eligible questions to expose the variant.
- **Unlock (R-3)**: a classic attempt at `RECALL_UNLOCK_SCORE_PCT` (100%) that is **not rushed**
  (duration ≥ 4 s/question). The hub chip (`get_recall_availability`) is signed-in only (R-9).
- **Scoring (R-4)**: `normalize_recall_text` (a 9-step IMMUTABLE pipeline) is applied to both sides
  for a **deterministic equality** — no fuzzy matcher, no partial credit. Best score is tracked
  **separately per variant** (`get_best_scores_by_exercise` is classic-only; R-5/R-6). A typed
  answer equal to a distractor resolves the same `misconception_tag` as clicking it (R-7).
- **No client oracle (R-1)**: `normalize_recall_text`, `is_question_recall_eligible` and
  `score_recall_answer` are `REVOKE`d from anon/authenticated; `getExercise` serves the recall
  play set **without options** and with `hints = 0`. The char bar (R-12) is static per content
  language, never derived from the answer.
- Migrations: `20260714120000` (columns + index + the 3 functions), `20260714130000` (variant-aware
  RPCs: `start_exercise_session` v2, `submit_exercise_attempt`, `get_attempt_review` v2,
  `get_recall_questions`, `get_recall_availability`). Constants in
  `src/shared/constants/gamification.ts`. Player guide: `docs/guide-rappel-actif.md`.

---

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
npm run content:emit # Compile a corpus into sql/content/*.sql (needs the private corpus)
npm run content:qa   # Content QA checks (run by the private repo's Content CI)
npm run leak:check   # Anti-leak gate: no corpus / pedagogical skill may reappear here
npm run ci:verify    # Full CI pipeline (lint + typecheck + coverage + build + audit + harness + leak)
```

### Adding subject content (not a feature)

**Authored content no longer lives in this repo.** Since étude 24 (2026-07-20) the corpus, the
generation skills and the studies live in the PRIVATE repo `MBeji/yahia-quest-content`; this repo
keeps only the **engine**, which is generic and corpus-free. To add or change
subjects/chapters/exercises, work there — do not hand-write content migrations, and never
re-commit corpus here (`npm run leak:check` fails the build if you do).

The engine is `src/shared/content/{schema,loader,sql-builder}.ts` + `scripts/content/**`: it
validates the tree (zod) and compiles it to stable per-subject SQL (`sql/content/<subject>.sql`,
idempotent, stable v5 UUIDs). The private repo's Content CI checks THIS repo out to get it, so a
schema change here changes what that CI accepts.

Content is **not shipped as Supabase migrations** any more: a database can host only one
migration history, so the private repo's `apply-content.yml` applies the compiled SQL with `psql`
and journals each run into the `content_releases` table. The 17 hand-written content migrations
under `supabase/migrations/` stay public on purpose (`content:emit` cannot reproduce them, and
three also seed non-content data). Full picture:
[`docs/content-generation-pipeline.md`](./docs/content-generation-pipeline.md).

---

## 11. Deployment

- **Platform**: **Vercel** — push to `main` auto-deploys prod (`na9ranal3ab.vercel.app`) and
  auto-applies new `supabase/migrations/**` via `db-migrate-prod.yml` (backup + guard + push,
  with hourly reconciliation).
- **Build**: `scripts/build-vercel.mjs` wraps `vite build` into the Vercel output layout.
- **Config**: `vercel.json` (live target); `wrangler.jsonc` survives as a Cloudflare vestige,
  not the deploy target.
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
