# Performance & scalability audit — yahia-quest-arena (XP Scholars)

> **Scope.** A standing performance _chantier_: audit the current architecture for
> performance and load behaviour, stand up reproducible load/perf tests, and
> anticipate a **fully-populated platform** — content at every grade and track,
> **audio + images + (eventually) video**, and **thousands of registered students**.
>
> **Status.** Audit + load-test harness landed. Remediations are tracked as the
> phased roadmap at the end; this doc is the source of truth for the _why_ behind
> each one. Companion harness: [`perf/README.md`](../perf/README.md).
>
> **Date.** 2026-06-30. Re-run the audit when the catalogue or user base grows an
> order of magnitude.

---

## 1. Executive summary

The architecture is **correct and reasonably mature** for its current size: hot
gameplay foreign keys are indexed (`20260606160000_perf_hot_path_indexes.sql`),
writes go through atomic `SECURITY DEFINER` RPCs, the per-subject leaderboard is
already materialized, rate-limiting is DB-backed (so it survives horizontal
scaling), and Sentry error capture is wired. This is **not** a project in trouble.

But it has not yet been built for the scale the product is aiming at. Four
compounding risk clusters will surface as the user base and catalogue grow:

1. **Read hotspots that scan whole tables per request** — the _global_ leaderboard
   recomputes `RANK()` over every student profile on each open (H1); several
   per-user aggregates scan a user's entire lifetime history on the hot path (H3,
   M2, M4).
2. **A per-request tax on every server function** — a fresh Supabase client +
   `getClaims` auth round-trip is created on _every_ call (C-1), and every write
   pays a second DB round-trip for the rate-limit RPC (C-2).
3. **No edge/CDN caching and no SSR prefetching** — the public catalogue + landing
   are fully dynamic through a single-region serverless function (H-3, H-1), and
   every authenticated page fetches client-side in a serial waterfall (C1-fe).
4. **No media architecture at all** — content (text + inline SVG) lives entirely
   in Postgres rows and ships in full on every read; there is **no image/audio/
   video delivery layer**, and the markdown sanitizer actively forbids `img`/
   `audio`/`video`. This is the single largest _gap_ for the stated roadmap.

And underpinning all of it: **no performance observability** (M-1) — only error
capture. The team currently cannot _see_ a p95 regression in production.

**The three highest-ROI moves**, before any launch spike:

| #   | Move                                                                        | Kills      | Effort |
| --- | --------------------------------------------------------------------------- | ---------- | ------ |
| 1   | Cache/local-verify the JWT (hoist the client, stop per-request `getClaims`) | C-1        | S      |
| 2   | Materialize the global leaderboard + add `idx_attempts_user_exercise`       | H1, H4     | S–M    |
| 3   | Edge-cache the public catalogue/landing + add SSR route loaders             | H-3, C1-fe | M      |

Plus stand up **RUM + slow-RPC timing** (M-1) so the rest is measurable, and run
the load harness (`perf/`) against a seeded test project to put numbers on each.

---

## 2. Method & scale assumptions

- **How.** Four parallel read-only audits — DB/RLS/indexes, frontend/SSR bundle &
  data-fetching, content/media-at-scale, and deploy/runtime/infra — cross-checked
  against the migrations and `*.server.ts` source. No code was changed during the
  audit; remediations are sequenced as a roadmap.
- **Target scale.** _Thousands_ of registered students (tens of thousands at exam
  season), a catalogue grown ~10–30× from today (the 13-grade school ladder × all
  subjects, plus the standalone tracks) → order **150k–400k question rows**, and a
  media library of audio (language tracks + Qur'an recitation), images, and later
  video.
- **Today's footprint (baseline).** `content/` = 24 MB on disk; 61 subjects, 408
  chapters, ~1,911 exercise files, **~13,546 questions**; 202 migrations. Lesson
  markdown totals 2.38 MB, exercise JSON 9.0 MB. 439 content files carry inline
  `<svg>` (heaviest IQ/geometry exercises ≈ 15–21 KB each).

---

## 3. Findings by tier

Severity = impact at the **target** scale, not today. `file:line` refs point at
the exact code. CRITICAL/HIGH should be addressed before a launch spike; MEDIUM
within the chantier; LOW are opportunistic.

### 3.1 Database / RLS / indexes

**C1 · `profiles` SELECT RLS runs a per-row `EXISTS` with un-wrapped `auth.uid()`**
`supabase/migrations/20260522153000_family_content_rewards.sql:77-92`.
Bare `auth.uid()` is treated as volatile → re-evaluated **per row**; the policy
also runs a correlated `EXISTS` against `parent_student_links` per candidate row.
This is _why_ the leaderboards had to become `SECURITY DEFINER` RPCs (direct
multi-row `profiles` reads return one row / get slow). The un-wrapped pattern is
pervasive (every policy in that migration, `parcours_entitlements`
`20260608120000_parcours_entity.sql:104-116`, attempts, …).
→ **Fix:** wrap every `auth.uid()` as `(SELECT auth.uid())` (planner evaluates once
via InitPlan); keep the `parent_student_links` indexes covering the `EXISTS`.

**H1 · Global leaderboard ranks _all_ student profiles on every load**
`dashboard.server.ts:295-320` → `get_global_leaderboard`
(`20260630120000_global_leaderboard_rpc.sql:40-66`). `RANK() OVER (ORDER BY xp
DESC)` materializes every student row before the `rank <= p_limit` filter — the
`LIMIT` cannot push into the window. `idx_profiles_role_xp (role, xp DESC)` helps
the sort but not the full materialization. The _subject_ board was materialized
for exactly this reason; the _global_ one never was.
→ **Fix:** materialize the global ranking (refresh on a schedule / on XP change)
or serve top-N from the index + a cheap separate "my rank" count.

**H2 · Dungeon question pick is `ORDER BY random()` over the full join**
`20260601190000_dungeon_server_authoritative.sql:113-125`. Full scan + full sort
of every matching `questions⨝exercises` row to choose 5, on every batch — the
dominant cost of dungeon play once the catalogue is large.
→ **Fix:** sampled selection (`tablesample`, random-offset cursor, or a
pre-shuffled per-run pool).

**H3 · `submit_exercise_attempt` runs unbounded per-user aggregates on the write path**
`20260604220000_harden_scoring_anti_rush.sql`. The most-executed write RPC does a
full `COUNT(*) FROM attempts WHERE user_id` (line ~179) just to detect the _first_
attempt (should be `EXISTS`/`LIMIT 1`), plus a prev-best `MAX(score_pct)` filtered
by `(user_id, exercise_id)` with **no covering index** (H4). All inside the
`FOR UPDATE` transaction → lengthens the profile lock window (M1).
→ **Fix:** `EXISTS` for first-attempt; add the index below.

**H4 · Missing `idx_attempts_user_exercise (user_id, exercise_id, score_pct)`**
Serves the H3 prev-best `MAX`, the quiz-passed `IN` filter
(`quest.server.ts:188-193`), and best-scores. Existing attempts indexes lead with
`user_id` or `subject_id` but none covers `(user_id, exercise_id)`.
→ **Fix:** `CREATE INDEX idx_attempts_user_exercise ON attempts(user_id, exercise_id, score_pct);`

**M1 · Hot-row lock chain on `profiles` via `award_xp`** — per-user (bounded), but
its window is stretched by H3's heavy reads. Shrinking H3 shortens it.
**M2 · `get_dungeon_access` runs two unbounded `COUNT(DISTINCT)` per dungeon load**
(`20260603100000_dungeon_access_gate.sql:49-60`), and again inside
`start_dungeon_run` (called twice). → cache prereq flags / short-circuit.
**M3 · N+1 `has_parcours_entitlement` in `getParcours`** (`dashboard.server.ts:348-365`)
— one RPC per premium parcours; small today (2), an N+1 by construction. → single
set-returning RPC.
**M4 · `getDashboard` pulls a user's _entire_ attempt history to aggregate in JS**
(`dashboard.server.ts:50,85-91`; the code's own TODO at :39). → `GROUP BY subject_id`
RPC/view.
**M5 · `get_student_report` does ~6 sequential per-student scans** — low frequency
(admin/parent), acceptable; consolidate if it gets hot.

**LOW.** L1 serial round-trips in `getSubject`; L3 unbounded (but naturally small)
badge/inventory reads; L4 a partial index on `spaced_repetition_schedule(status)`.

_Index inventory & full detail in the DB audit appendix (this section condenses it)._

### 3.2 Frontend / SSR

**C1-fe · No SSR prefetching — every authenticated page fetches client-side in a
serial waterfall.** Zero route `loader`/`ensureQueryData`/`prefetchQuery` in
`src/routes/`. The chain is `useAuth()` (`_authenticated.tsx:41`) → `useMyRole()`
(:50) → page query (e.g. `dashboard.tsx:152`), and the dashboard alone fires 3+
round-trips. On high-latency mobile this stacks auth-RTT → profile-RTT →
data-RTT before first paint. TanStack Start's SSR-streamed loaders are unused.
→ **Fix:** move primary queries into route loaders via `queryClient.ensureQueryData`.

**C2-fe · Hero image is a 245 KB unoptimized JPG in the JS graph**
`public-landing.tsx:18` imports `hero-warrior.jpg` (245 KB), rendered as raw
`<img>` with no `width`/`height` (CLS), no `loading`/`decoding`, no `srcset`, no
WebP/AVIF — the landing LCP element on mobile.
→ **Fix:** responsive WebP/AVIF with dimensions; part of the media pipeline (H1-media).

**H2-fe · All three i18n catalogs (FR/EN/AR) bundled eagerly** — `i18n` chunk,
2,176 lines, every student downloads 2 unused languages (`provider.tsx:3-5`,
`__root.tsx:17-19`, `vite.config.ts:66-71`). Gzips small but pure waste on the
critical path. → per-locale dynamic `import()`.
**H3-fe · `renderMarkdown` re-parses + re-sanitizes on every render**
(`lesson-reader.tsx:138`, no `useMemo`) — ~15 regex passes + DOMPurify re-run on
any parent re-render (e.g. Cours/Résumé toggle). → `useMemo(…, [body])`.

**MEDIUM.** M1-fe generous bundle budgets for low-end mobile (~900 KB raw JS
pre-dashboard; `vendor-tanstack`/`vendor-icons`/`vendor-radix` have **no budget**
entry → can grow uncaught). M3-fe per-row `motion.div` on 50-row lists. M4-fe
dungeon route bundles all gameplay eagerly (premium minority — code-split it).

**Positives to preserve.** Dashboard secondary content (3D canvas, radar, badges,
banner) is `lazy` + `Suspense`, mobile/reduced-motion gated, deferred 350 ms;
three.js is isolated in `vendor-three`, lazy, desktop-only; lists are server-capped
(50) and the quiz player paginates one question at a time → **no virtualization
gap**; CSP-nonce SSR locale shell avoids RTL FOUC.

### 3.3 Deploy / runtime / infra

**C-1 · Fresh Supabase client + `getClaims` on _every_ server fn**
`auth-middleware.ts:44-57`. The per-request client means supabase-js's JWKS cache
is empty each call → `getClaims` re-bootstraps verification (JWKS fetch, or a
legacy `GET /auth/v1/user` network round-trip) **before any business logic**, on
~all 33 server fns. At thousands of concurrent users this is the dominant latency
and Auth-service load multiplier.
→ **Fix:** hoist a module-scope client (the admin client already does this via a
lazy Proxy in `client.server.ts:31-41`) and/or verify the JWT locally against a
cached JWKS instead of constructing a client + calling `getClaims` per request.

**C-2 · Every write pays a second DB round-trip for the rate-limit RPC**
`rate-limit.ts:45` → `check_rate_limit` does `advisory_xact_lock` + DELETE + COUNT

- INSERT on `rate_limit_events` (`20260601150000_…:86-105`) _before_ the real RPC.
  So `submitAttempt` is two PostgREST round-trips, the first a serialized
  write-amplifying transaction. Correct for horizontal scaling, but a throughput
  ceiling + `rate_limit_events` bloat (cold keys pruned only lazily) under load.
  → **Fix:** local in-memory first-gate, escalate to DB only when needed; background
  prune / partition `rate_limit_events`.

**H-1 · Single always-cold Node serverless function, single region (`arn1`)**
`build-vercel.mjs:103-121,154-156`. One `index.func`, `maxDuration:30`, no
provisioned concurrency, not Edge. Cold starts init the whole SSR tree; non-Nordic
users pay cross-continent RTT for SSR _and_ every server-fn call (region pinned to
co-locate with Supabase — a deliberate trade). `waitUntil` is a no-op
(`:75`) → deferred work may be dropped.
**H-2 · Connection scaling** — no app-held Postgres connections (all PostgREST
HTTP), so no pooler needed, but the load relocates to **PostgREST pool + Auth
service** concurrency, which C-1/C-2 amplify, with no app-side mitigation.
**H-3 · No edge/CDN cache for the public catalogue/landing** — only the sitemap +
hashed assets set cache headers; HTML carries none (per-request CSP nonce blocks
static caching as written), no ISR/SSG/prerender. The pages a marketing/viral
spike hits hardest are re-rendered by the single SSR fn on every anon hit.
→ **Fix:** edge-cache catalogue reads (`s-maxage`+`stale-while-revalidate`) keyed
by content build hash; consider a nonce-free cacheable variant for anon catalogue.

**M-1 · No performance observability — error capture only.**
`logger.ts` + `monitoring.ts` are a dependency-free Sentry _error_ reporter. **No
APM/tracing, no slow-RPC timing, no Web Vitals/RUM.** The team sees 500s but is
blind to p95 growth, slow RPCs, cold-start regressions — exactly what C-1/C-2/H-1
produce. → add RUM (web-vitals beacon) + server-fn timing logs + slow-query log on
the DB.
**M-2/M-3** SSR streamed body drained chunk-by-chunk through the Node adapter with
no-op `waitUntil`; `maxDuration:30` + serialized cross-region round-trips can turn
a DB slowdown into hard timeouts. **L-1** in-memory IP burst limiter is per-instance
(effective cap ×N instances). **L-2** hand-tuned `manualChunks` is a known
prod-crash trap (keep behind `build:check`).

### 3.4 Content & media at scale

**The defining gap: there is no media architecture.** 100% of pedagogical content
is compiled into SQL `INSERT`s and stored as Postgres row columns
(`chapters.lesson_content`/`summary`, `questions.prompt/options(JSONB)/explanation`).
The only binary-media path in the whole app is the _manuel élève_ page scans —
private bucket `manuel-pages`, **signed URLs, 1 h TTL, auth-gated**
(`quest.server.ts:312-379`). There is **no `<audio>`, no `<video>`, no upload
code**, and the markdown sanitizer's allow-list **excludes `img`/`audio`/`video`/
`iframe`** (`markdown.ts:87-105`) — course markdown cannot even reference an image
today.

Consequences at scale:

- **H1-media · Inline SVG ships on every question fetch.** 439 files embed `<svg>`
  inside `questions.options`/`prompt`/`explanation`; a 20-question IQ exercise =
  20–40 KB of raw SVG in the JSON payload, re-sent every replay, un-CDN-able as a
  static asset (`getExercise` selects `options` wholesale, `quest.server.ts:542`).
- **H2-media · `getChapterLesson` over-fetches sibling markdown.** It re-queries
  _all_ sibling chapters selecting full `lesson_content` only to compute a
  `hasLesson` boolean (`quest.server.ts:287,295`) — at 20 chapters × 30 KB that's
  ~600 KB to derive 20 booleans. **Cheap immediate win:** select
  `(lesson_content IS NOT NULL) AS has_lesson`, drop the body.
- **No content edge-caching.** Content is immutable per build but not exploited:
  no `Cache-Control`/`ETag` on any content server fn; client caching is TanStack
  Query `staleTime: 30_000` only. Popular chapters hit Postgres on ~every cold read.

**The media roadmap must be _designed_, not retrofitted** — see §5.

---

## 4. Load & perf testing harness

Stood up under [`perf/`](../perf) (k6) + [`scripts/perf/`](../scripts/perf)
(seeders). It targets the PostgREST/RPC surface directly so a red run isolates the
DB tier. Profiles: `smoke | load | stress | soak | spike` via the `STAGE` env var,
with per-RPC p95 SLOs that fail the run.

| Scenario         | Stresses                                                     | Catches finding |
| ---------------- | ------------------------------------------------------------ | --------------- |
| `leaderboard.js` | `get_global_leaderboard`, `get_subject_leaderboard`          | **H1**          |
| `gameplay.js`    | `start_session` → `check_rate_limit` → `submit_attempt`      | **C-2, H3, M1** |
| `dungeon.js`     | `get_dungeon_access` → `start_run` → `get_dungeon_questions` | **H2, M2**      |

Seed scale with `scripts/perf/synthetic-scale.sql` (e.g. 2k vs 20k profiles) and
compare `get_global_leaderboard` p95 across sizes — super-linear growth is the
empirical proof for H1. Full runbook: [`perf/README.md`](../perf/README.md).

**Recommended first measurement campaign**

1. Baseline `smoke` to validate wiring against the test project.
2. `load` (→200 VUs) on each scenario → record p95 per RPC = today's headroom.
3. Re-seed 10× profiles, re-run `leaderboard load` → quantify H1's slope.
4. `soak` `gameplay` 30 min → watch `rate_limit_events` bloat (C-2).
5. `stress` to the knee → the number that sizes the launch.

---

## 5. Media-at-scale architecture (the missing layer)

The product wants audio (language tracks + recitation), images, and later video.
Generalize the **one good pattern that already exists** (manuel-pages signed URLs)
into a real tier:

- **Storage split.** Free-preview media → **public CDN bucket**, long
  `Cache-Control: public, max-age=31536000, immutable`, content-hashed paths.
  Premium media → **private bucket + short-TTL signed URLs**, gated by
  `resolve_exercise_access`/`has_parcours_entitlement` (reuse `getManuelPageUrls`).
- **Images.** Add `img`/`figure`/`figcaption` to the sanitizer allow-list with a
  **host allow-list** (vetted XSS boundary, `docs/xss-rendering-policy.md`); serve
  responsive `srcset`/`sizes` via an image-transform CDN (Supabase image transform
  or Cloudflare Images/imgix). Convert the hero JPG here (C2-fe).
- **Externalize large inline SVG** (H1-media) to a `content-figures` bucket as
  hashed `.svg` files; store a URL reference, keep only tiny inline SVGs. Removes
  per-fetch payload bloat and makes figures CDN-cacheable.
- **Audio** (highest-priority gap): audio bucket + `<audio preload="none">`, range
  requests, signed URLs for premium. The language tracks + `education-islamique-*`
  recitation content is authored text-only today — this unblocks it.
- **Video** (later): HLS/adaptive bitrate via a streaming provider
  (Mux/Cloudflare Stream). **Do not** put video bytes in Supabase Storage at
  thousands of users — egress cost dominates. Budget _egress_, not storage.
- **Lazy/progressive loading** everywhere (replicate `loading="lazy"` from
  manuel-pages); split exercise fetch so media loads per-question on demand.

---

## 6. Roadmap (phased)

Effort: **S** ≤ ½ day · **M** ~1–3 days · **L** > 3 days. Each item is independently
shippable and respects DoD §7 (additive migrations land before dependent code).

### Phase 0 — Make it measurable (do first, unblocks everything)

- **M-1** RUM (web-vitals beacon) + server-fn timing logs + DB slow-query log. **M**
- Run the load harness baseline campaign (§4) against a seeded test project. **M**
- Add bundle budgets for the unbudgeted vendor chunks (M1-fe). **S**

### Phase 1 — High-ROI, low-risk (pre-launch must-haves)

- **C-1** Hoist the auth client / local JWT verify — kill per-request `getClaims`. **M**
- **H4** Add `idx_attempts_user_exercise`; **H3** swap first-attempt `COUNT(*)`→`EXISTS`. **S**
- **C1** Wrap `auth.uid()` → `(SELECT auth.uid())` across all RLS policies. **M**
- **H2-media** Fix `getChapterLesson` sibling over-fetch (boolean, not body). **S**
- **H3-fe** `useMemo` `renderMarkdown`; **C2-fe** responsive hero image. **S**

### Phase 2 — Scale the hotspots

- **H1** Materialize the global leaderboard (or top-N + cheap my-rank). **M**
- **H2** Replace dungeon `ORDER BY random()` with sampled selection. **M**
- **M4/M2** Move `getDashboard` + `get_dungeon_access` aggregates into GROUP BY
  RPCs / cached counters. **M**
- **C-2** Local-first rate-limit gate + `rate_limit_events` prune/partition. **M**
- **C1-fe** SSR route loaders (`ensureQueryData`) for the auth→profile→data chain. **M**

### Phase 3 — Edge, caching, and the media tier

- **H-3** Edge-cache the public catalogue/landing (cacheable anon variant). **M–L**
- **H2-fe** Per-locale i18n code-split; **M4-fe** code-split the dungeon route. **M**
- **§5** Stand up the media architecture: images (sanitizer + CDN), externalize
  SVG, then **audio**, then video (HLS). **L**

### Phase 4 — Resilience & global reach

- **H-1** Provisioned concurrency / warm-keeping; evaluate multi-region or Edge
  runtime vs the Supabase region pin. **L**
- **L-1** Move IP burst-limiting to the edge (Cloudflare). **M**

---

## 7. Appendix — finding index

| ID                                    | Tier    | Sev  | One-line                                                     |
| ------------------------------------- | ------- | ---- | ------------------------------------------------------------ |
| C1                                    | DB      | CRIT | per-row `EXISTS` + un-wrapped `auth.uid()` in `profiles` RLS |
| C-1                                   | Infra   | CRIT | fresh client + `getClaims` per server fn                     |
| C-2                                   | Infra   | CRIT | rate-limit DB round-trip before every write                  |
| C1-fe                                 | FE      | CRIT | no SSR prefetch — client-side waterfall                      |
| C2-fe                                 | FE      | CRIT | 245 KB unoptimized hero JPG, LCP                             |
| H1                                    | DB      | HIGH | global leaderboard ranks all profiles per call               |
| H2                                    | DB      | HIGH | dungeon `ORDER BY random()` over full join                   |
| H3                                    | DB      | HIGH | unbounded per-user aggregates on write path                  |
| H4                                    | DB      | HIGH | missing `attempts(user_id, exercise_id)` index               |
| H-1                                   | Infra   | HIGH | single cold single-region SSR function                       |
| H-2                                   | Infra   | HIGH | scaling load relocates to PostgREST/Auth                     |
| H-3                                   | Infra   | HIGH | no edge/CDN cache for public catalogue                       |
| H2-fe                                 | FE      | HIGH | all 3 i18n locales bundled eagerly                           |
| H3-fe                                 | FE      | HIGH | `renderMarkdown` re-runs DOMPurify per render                |
| H1-media                              | Content | HIGH | inline SVG ships on every question fetch                     |
| H2-media                              | Content | HIGH | `getChapterLesson` over-fetches sibling markdown             |
| M1–M5 (DB), M-1–M-3 (Infra), M1–M4-fe | mixed   | MED  | see §3                                                       |
| L-\*                                  | mixed   | LOW  | see §3                                                       |

_No application code was modified by the audit. Remediations ship as separate,
reviewable changes per the roadmap._
