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
> **Date.** Audited 2026-06-30 · **findings re-verified against the code from
> 2026-08-10 to 2026-08-13** (§0 — the last sweep, which closed the remaining
> "?" lines, ran on the 13th). Re-run the audit when the catalogue or user base
> grows an order of magnitude.

---

## 0. Verified status — 2026-08-10 → 2026-08-13 (`main` à #721)

> **Read this before §3.** The audit below is the 2026-06-30 text, kept for the
> _why_. Six weeks of delivery closed a third of it, and **one CRITICAL finding
> turned out to rest on a false premise**. Every line here was re-read in the
> code between 2026-08-10 and 2026-08-13 — the rule `docs/dette-technique.md`
> already applies to code debt, applied to perf: _on n'inscrit ici qu'un constat
> dont on a re-lu la ligne_.

### Closed since the audit (verified, with the proof)

| ID           | Closed by                                                                                                                |
| ------------ | ------------------------------------------------------------------------------------------------------------------------ |
| **H1**       | `20260630170000_global_leaderboard_materialized.sql` — the global board is materialized like the subject one             |
| **H3**       | first-attempt `COUNT(*)` → `EXISTS`; survives the 3 later redefinitions of `submit_exercise_attempt` (…`27120000`)       |
| **H4**       | `idx_attempts_user_exercise` created in `20260630140000_perf_attempts_index_and_first_attempt_exists.sql`                |
| **H2-media** | `getChapterLesson` selects a `has_lesson` boolean, no longer sibling bodies (`quest.server.ts:435-437`)                  |
| **H3-fe**    | `renderMarkdown` memoized (`lesson-reader.tsx:98`)                                                                       |
| **M4**       | `getDashboard` aggregates moved to the `get_user_subject_stats` RPC (`GROUP BY subject_id`)                              |
| **M1-fe**    | **closed by this pass** — `vendor-radix`/`vendor-icons`/`vendor-three` now have bundle budgets (9 chunks guarded, was 6) |

### C-1 — RETIRED: the premise was wrong

The audit ranked _« hoist the auth client / local JWT verify »_ as the **#1
highest-ROI move**, on the premise that a fresh Supabase client per server
function leaves «supabase-js's JWKS cache empty each call». **That is not true of
the version we ship** (`@supabase/supabase-js` 2.111):

- auth-js keeps the JWKS in a **module-level** map (`GLOBAL_JWKS`), keyed by
  `storageKey`, which supabase-js derives from the project ref
  (`sb-<ref>-auth-token`, `dist/index.mjs:680`). Every per-request client is
  built from the same `SUPABASE_URL` → they all share **one** cache entry,
  TTL 10 min. Creating the client costs no I/O.
- Hoisting is also **unsafe**: the per-request client carries the caller's bearer
  token, so a module-scope instance would leak one user's credentials into
  another's request.

Proven, not asserted: `auth-middleware.jwks-cache.test.ts` mints a real ES256
token and verifies it through **two independently created clients** — the JWKS
endpoint is hit **once**. If a future upgrade moves the cache back onto the
instance, that test goes red and C-1 comes back.

**What actually decides the per-request cost** is the project's JWT signing
algorithm (`getClaims`, `GoTrueClient.js:5342-5352`):

- **asymmetric** (ES256/RS256, `kid` present) → local WebCrypto verify, network
  only on a JWKS miss (≤ 1 per 10 min per instance). Nothing to fix.
- **symmetric** (legacy HS256 secret) → falls back to `getUser(token)`, i.e. **a
  full Auth round-trip on every one of the ~33 server fns** — and no amount of
  client hoisting changes that. The fix would be migrating the project to
  asymmetric signing keys.

→ **Action is a 30-second dashboard check, not code**: read the project's JWT
signing key type in Supabase. Only if it is still symmetric does a CRITICAL
finding exist here — and its remedy is the key migration.

### Still open (re-verified 2026-08-10)

| ID                  | Evidence today                                                                                                                | Sev  |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ---- |
| ~~**C1**~~          | ✅ **closed 2026-08-10** — see below; the "71" first reported here was a count over migration _text_, not the live policy set | CRIT |
| **C1-fe**           | waterfall intact — but the stated remedy is **blocked by the auth architecture**, see below (2026-08-13)                      | CRIT |
| ~~**C2-fe**~~       | ✅ **closed 2026-08-10** — AVIF/WebP `<picture>`, lazy, sized; and it was never the LCP element (see below)                   | CRIT |
| **H2**              | dungeon pick still `ORDER BY random()` — **now measured**, see below (`20260720200000_dungeon_scoped_to_parcours.sql:174`)    | HIGH |
| **H2-fe**           | `provider.tsx` still imports `en`/`fr`/`ar` statically — 123 KB i18n chunk ships all three                                    | HIGH |
| **H-1 / H-3 / H-2** | infra unchanged: single `arn1` serverless fn, no edge cache on the public catalogue                                           | HIGH |
| **M-1**             | 🟠 **client RUM + slow server-fn timing landed 2026-08-10** (see below); the DB slow-query log is a Supabase setting          | MED  |

#### The remaining findings, swept 2026-08-13 — no line left unverified

The first pass left seven findings at "?". They are now all read in the code
(**swept 2026-08-13**). One more turned out to be false, which is the **fourth**
of the original audit.

| ID           | Verified today                                                                                                                                                                                                  | State                 |
| ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| **C-2**      | `isRateLimited` still calls the `check_rate_limit` RPC **first**, at 8 feature call sites; `isRateLimitedLocal` is only an **error fallback**, not a first-gate                                                 | ⬜ open               |
| **M2**       | `get_dungeon_access` still runs 2 × `COUNT(DISTINCT)` — **measured 2026-08-13**, see below                                                                                                                      | ⬜ open, chiffré      |
| **M5**       | `get_student_report` still multi-scan (`20260708120000_student_report_by_code.sql`) — admin/parent frequency, so it stays acceptable                                                                            | ⬜ open, low          |
| **M1** (DB)  | the `FOR UPDATE` chain on `profiles` is still there, but its amplifier (H3's unbounded aggregates) is gone — window much shorter                                                                                | 🟠 mitigated          |
| **M3** (DB)  | N+1 `has_parcours_entitlement` — inert in the free phase; already tracked as **latent** in `docs/dette-technique.md`                                                                                            | 💤 latent             |
| **H1-media** | `getExercise` still selects `options` wholesale (`quest.server.ts:744`), so inline SVG still ships per fetch                                                                                                    | ⬜ open               |
| **M3-fe**    | réel (50 `motion.div`, `leaderboard.tsx:253`) mais **déjà atténué** trois fois — voir ci-dessous                                                                                                                | 🟠 atténué            |
| **M4-fe**    | **FALSE** — "the dungeon route bundles all gameplay eagerly". The router plugin already splits it: `dungeon-*.js` is its own **15.15 kB** chunk, fetched only when a player navigates there                     | ✅ closed             |
| **L1**       | ✅ **closed** — the 3 content queries were already parallel; the remaining serial call (`get_best_scores_by_exercise`) now rides the same `Promise.all`, removing one round-trip per authenticated subject load | ✅ closed             |
| **L4**       | ✅ **mesuré 2026-08-13 : n'en vaut pas la peine** — l'index `(user_id, scheduled_for)` existant suffit, voir ci-dessous                                                                                         | ✅ clos (sans action) |
| **L-1**      | `isRateLimitedLocal`'s store is module-scope ⇒ per-instance; the effective cap really is × N instances                                                                                                          | ⬜ open by design     |
| **M-2**      | `waitUntil` est bien un no-op, mais **aucun code de `src/` ne l'appelle** — piège latent, pas défaut actif                                                                                                      | 🟠 latent             |

_Method note: the first sweep of C-2 looked clean because it grepped for
`checkRateLimit`; the export is `isRateLimited`. A finding is only "closed" when
the symbol that actually exists has been searched for._

### C1 — CLOSED 2026-08-10, and the count was wrong

`20260810120000_rls_initplan_wrap_auth_uid.sql` wraps every bare `auth.uid()` /
`auth.role()` in a `public` RLS policy as `(SELECT …)`, so the planner hoists it
into an **InitPlan** (evaluated once per query) instead of re-evaluating it per
candidate row. Supabase's own documented remedy.

**The reported figure was an artefact of the method.** "71 occurrences across 10
migrations" counted `CREATE POLICY` bodies in migration _files_ — which
double-counts every policy a later migration dropped and recreated. Replaying
the whole chain on a real Postgres and reading `pg_policies` gives the live
state: **64 bare occurrences over 35 policies on 19 tables** (of 65 policies
total). _Lesson for the next pass: for anything whose truth lives in the
database, count in the database, not in the migration text._

How it was made safe — worth reusing:

1. The 35 `ALTER POLICY` statements are **generated from `pg_policies`** after a
   full chain replay, not hand-written: they cannot mistranscribe an expression
   nor resurrect a policy a later migration dropped.
2. `ALTER POLICY` rewrites **in place** — nothing is dropped, so no window
   exists where a table sits unprotected.
3. **Semantic equivalence was proven, not asserted**: the chain was applied to
   two databases differing only by this migration; strip the wrapper from both
   and the deparsed `qual`/`with_check` of all 65 policies are **byte-identical**.
   Bare occurrences 64 → 0.
4. The plan confirms the hoist — `Filter: ((NULLIF(((COALESCE(NULLIF(current_setting(…` per row
   becomes `InitPlan 1 (returns $0)` + `Filter: ($0 = user_id)`.

⚠️ **No performance _number_ is claimed.** The local A/B (200 k rows) moved
10.1 ms → 9.5 ms, which is **not** a meaningful benchmark: the harness stubs
`auth.uid()` as a cheap inlined SQL function, so it understates the real cost,
and the sampled policy is also OR-ed with `is_admin()`. The structural win is
proven; the magnitude needs the §4 load campaign against a seeded project.

**Not touched, deliberately**: `is_admin()` (5 call sites) is hoistable the same
way; `is_parent_of_student(uid, row_column)` is row-dependent and is not.

### H2 — measured 2026-08-10, deliberately NOT fixed yet

The dungeon batch pick was rated HIGH "at the target scale, not today". It is now
a number rather than a guess. Replayed chain on a real Postgres, synthetic corpus,
worst case (`pool_scope = 'all'`, batch of 5):

| corpus            | per batch | plan                                               |
| ----------------- | --------- | -------------------------------------------------- |
| 20 609 questions  | ~13 ms    | Seq Scan on **all** matching rows + top-N heapsort |
| 200 609 questions | ~140 ms   | identical shape — **linear** in corpus size        |

So: tolerable today (~18 700 questions in prod ⇒ ~13 ms), genuinely bad at the
10× catalogue the roadmap targets — and it is paid **per batch**, i.e. repeatedly
inside one dungeon run.

**No index can fix this.** `ORDER BY random()` must materialise a random value for
every matching row by construction; the top-N heapsort already avoids the full
sort, and the scan is the irreducible part.

**Why it is not fixed in this pass:** every real remedy changes _which questions a
player sees_, which is a gameplay decision, not a mechanical optimisation:

- **random-key column + index** (`questions.sample_key`, `WHERE sample_key >= random()
ORDER BY sample_key LIMIT n`) — O(log n) with early termination, but the key is
  static, so the same neighbours are drawn together: the same 5 questions would
  recur as a clump. Also a schema change on a content-owned table.
- **per-run shuffled pool** — draw the eligible pool once per run, batch out of it.
  Preserves uniformity exactly and touches only dungeon tables, but restructures
  the RPC and its "already assigned" logic.
- **sample exercises, then questions** — scans the ~10× smaller `exercises` table,
  but over-weights questions belonging to short exercises.

→ **Next step is a design decision, not a patch.** Trigger point: revisit when the
catalogue passes ~50 k questions, or sooner if a dungeon batch shows up in the
§4 load campaign. Whoever takes it should state the distribution guarantee they
intend to keep before touching the SQL.

### C2-fe — CLOSED 2026-08-10, and it was never the LCP element

The audit called the hero "the landing LCP element on mobile". Reading the markup
says otherwise: it lives in the **last** section of the page (« apprends en
jouant »), inside an `aspect-square` crop at `opacity-70`, with `alt=""` — it is
the 3D canvas's Suspense fallback on desktop and the whole visual on mobile /
reduced motion. It was never above the fold. The waste was real, the diagnosis
was not: **245 KB of decorative, below-the-fold image fetched eagerly**.

Fixed as a `<picture>`: AVIF + WebP at 960/1920 w, `sizes="(min-width: 1024px)
480px, 100vw"` (the box is ~472 px on desktop — `object-cover` does the cropping,
so the browser only needs to cover the square), plus `loading="lazy"`,
`decoding="async"` and intrinsic `width`/`height`.

| variant       | bytes      | vs original |
| ------------- | ---------- | ----------- |
| original JPEG | 245 614    | —           |
| WebP 960      | 63 968     | **−74 %**   |
| **AVIF 960**  | **37 493** | **−85 %**   |
| WebP 1920     | 163 088    | −34 %       |
| AVIF 1920     | 102 663    | −58 %       |

Realistic viewports land on the 960 variants, so a mobile visitor fetches **37 KB
instead of 245 KB** — and only once it scrolls near the bottom. The JPEG stays as
the final `<img>` fallback; virtually no browser will fetch it. Pinned by a test
that fails on a plain `<img src=….jpg>` regression.

### M-1 — mostly CLOSED 2026-08-10 (the code half)

The audit's deepest complaint was that everything above is unfalsifiable: the
team could see 500s but not p95 growth. Two of the three parts now exist.

**Client RUM** (`src/shared/lib/web-vitals.ts`, armed in `__root.tsx`) — LCP,
CLS, INP, FCP, TTFB, each with a good / needs-improvement / poor rating, sent
once per page view as the `web_vitals` product event through the PostHog path
that already exists. Dependency-free for the same reason `monitoring.ts` is:
the index chunk has a hard 450 kB budget. Cost measured: **+1.5 kB** (438.52 →
440.02 kB), where the `web-vitals` package would have been several times that.

Two details that make the numbers trustworthy rather than merely present:

- **CLS is the worst _session window_, not the running sum.** Summing every
  shift over-reports long-lived pages, and a metric that reads worse than
  reality gets ignored — which is the same as not having it.
- **Nothing measured ⇒ nothing sent.** A row of nulls would drag every
  dashboard average around.

**Slow server-fn timing** (`auth-middleware.ts`) — every server fn already
passes through that middleware, so it is the one place that can time all ~33
without touching each. Only calls ≥ 1 s are logged, with the request **path**
(never the query string, which can carry tokens), and the timing survives a
throwing handler.

**Still missing**: the DB slow-query log — a Supabase project setting, not code.
And there is still no _budget_ on LCP (a Lighthouse CI would close that;
`docs/dette-technique.md` tracks it).

⚠️ The beacon only reports where product analytics is enabled — no PostHog key,
no data. Verify a `web_vitals` event actually lands before trusting an empty
dashboard as "no problems".

### M2 — measured 2026-08-13, transformation ready, deliberately not shipped

`get_dungeon_access` computes two `COUNT(DISTINCT)` over the caller's **entire**
attempt history, then compares them to constants (2 subjects, 3 chapters). It is
called on every dungeon load **and twice more inside `start_dungeon_run`**.

Measured on the replica, one user with 5 000 attempts:

| variant                                            | per call    | shape                      |
| -------------------------------------------------- | ----------- | -------------------------- |
| current `COUNT(DISTINCT e.chapter_id)`             | **~4.8 ms** | O(user's lifetime history) |
| `SELECT COUNT(*) FROM (SELECT DISTINCT … LIMIT 3)` | **~1.9 ms** | O(threshold) — stops early |

**The transformation is provably safe for the gate.** Capping at the requirement
leaves the comparison identical: `min(n, 2) < 2 ⟺ n < 2`. Same for chapters.

**But it is NOT purely internal**, which is why it is not in this pass: the counts
are also OUT columns, rendered by `dungeon.tsx` — only when `reason = 'PREREQ'`,
so _usually_ below the threshold and unaffected. The exception: a student with
5 subjects but only 1 chapter is still `PREREQ`, and the panel would go from
« Matières entamées : **5**/2 » to « **2**/2 ». Arguably an improvement (5/2 reads
oddly), but it is a **product decision about a gameplay gate**, not a side effect
to slip into a perf patch. Ship it as its own change, with that as the headline.

### C1-fe — the remedy does not hold as written (2026-08-13)

The audit says: _« move primary queries into route loaders via
`queryClient.ensureQueryData` »_ to kill the auth → profile → data waterfall
before first paint. The router is ready for it — `createRouter` already passes
`context: { queryClient }`. **The auth architecture is not.**

- The browser client persists its session in **localStorage**
  (`client.ts`: `storage: localStorage`, `persistSession: true`).
- `auth-attacher.ts` is a **`.client()`** middleware: it reads `getSession()` in
  the browser and puts `Authorization: Bearer …` on each server-fn call. Its own
  comment says it plainly — without it "the browser never attaches the bearer
  token to serverFn RPCs".
- `_authenticated.tsx` gates with the `useAuth()` hook, not `beforeLoad`.
- No `@supabase/ssr`, no cookie-borne session anywhere.

→ **At SSR the server holds no session.** A route `loader` calling an
authenticated server fn would be rejected as unauthorized. So the recommendation
cannot deliver _SSR_ prefetching; it is not a matter of effort.

What is actually available, and worth separating:

1. **Client-side loaders** (what `ensureQueryData` in a loader would really buy
   here): the fetch starts when a _navigation_ begins instead of after the
   component mounts. A real gain between screens — but it does **not** touch the
   first-paint waterfall the audit describes.
2. **True SSR prefetching** requires moving the session into a **cookie**
   (`@supabase/ssr`-style) so the server can read it. That is an architectural
   change with a security review attached (cookie flags, CSRF, refresh
   rotation), not a perf patch. Price it as such.

**Sixth finding of this audit whose premise or remedy does not survive reading
the code** — after C-1, C1's count, C2-fe, M4-fe, and one note of my own.

### L4 — measured 2026-08-13: **not worth an index**, and that is the answer

The audit suggested a partial index on `spaced_repetition_schedule(status)`. The
real query (`get_daily_plan`) is:

```sql
WHERE s.user_id = (SELECT auth.uid()) AND s.status = 'pending' AND s.scheduled_for <= now()
ORDER BY s.scheduled_for LIMIT 3
```

Measured on the replica, one user with 5 000 schedule rows:

| case                                           | existing index only                | + partial index |
| ---------------------------------------------- | ---------------------------------- | --------------- |
| realistic (100 `pending` among 5 000)          | **0.09 ms**                        | 0.07 ms         |
| pathological (3 `pending`, last in date order) | **1.06 ms** (4 997 rows discarded) | 0.49 ms         |

`idx_spaced_rep_scheduled_for (user_id, scheduled_for)` already does the work:
the query is **per user** and `ORDER BY … LIMIT 3`, so the index supplies the
order and the scan **stops early** — it only skipped 147 entries in the
realistic case. Even the contrived worst case costs ~1 ms.

→ **Closed with no action.** Adding the index would buy ~0.5 ms in a case that
does not occur, at the price of a migration and a write-path cost on every
insert/update of the table. Recorded here so the suggestion is not re-proposed:
_the index is missing on purpose, and here is the number._

### M3-fe et M-2 — re-qualifiés 2026-08-13 : réels, mais pas ce qu'on croyait

Les deux étaient classés « ouverts » sur un **comptage**, pas sur une lecture. Relus :

**M3-fe — un `motion.div` par ligne sur une liste de 50 : vrai, et déjà atténué trois fois.**
`leaderboard.tsx:253` anime bien chaque ligne, et `LEADERBOARD_LIMIT = 50`. Mais le code porte
déjà les trois parades, chacune commentée :

1. **`content-visibility: auto`** (`.list-row-cv` + `contain-intrinsic-size: auto 72px`) — le
   navigateur **ne rend pas** les lignes hors écran. C'est la parade principale pour une longue
   liste, et elle rend l'essentiel du grief caduc : une ligne non rendue n'est pas animée.
2. **Reduced-motion** — `entrance(reduced, …)` renvoie `{ initial: false }` : aucune animation.
3. **Stagger plafonné** — `Math.min(i, 12) * 0.02`, commenté « so a long board doesn't cascade
   for seconds ».

→ Le remède implicite de l'audit (« ne pas animer par ligne ») n'achèterait presque rien
au-dessus de `content-visibility`. **Atténué, pas ouvert.**

**M-2 — le no-op `waitUntil` : personne ne s'en sert.**
`build-vercel.mjs:75` passe bien `waitUntil: () => {}` à `worker.fetch`, donc un travail différé
serait perdu. Sauf qu'**aucun fichier de `src/` n'appelle `waitUntil`** — les autres occurrences
du dépôt sont l'option Playwright de `page.goto`, sans rapport. Le défaut est donc **latent** :
il ne perd rien aujourd'hui, il mordra le jour où quelqu'un différera du travail en croyant que
la plateforme le terminera. À traiter le jour où un besoin apparaît — et à ne pas découvrir ce
jour-là.

### New findings from this pass

| ID     | Finding                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | Sev  |
| ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- |
| **N1** | ✅ **corrigé sur `main` le 2026-08-10 par le revert #718** — diagnostiqué ici le même jour : #716 (Dependabot, undici) avait retiré du lock le `vite-tsconfig-paths/node_modules/typescript@5.9.3` dont `tsconfck` a besoin, et npm 10 mourait en `EUSAGE`. Le revert cite la même erreur ; la cause profonde était un miniflare 5 alpha embarqué par le bump. La question « quelle version de npm sur l'image de build Vercel ? » **tombe donc** : `main` est de nouveau installable partout | HIGH |
| **N2** | `auth-middleware.ts` carried a false _"automatically generated. Do not edit it directly."_ header — nothing generates it and `guard-generated.mjs` does not list it. It sat on the hottest path in the app and deterred exactly the inspection that retired C-1. **Fixed in this pass**                                                                                                                                                                                                       | MED  |
| **N3** | Current `main` (`0ea9135`) has **no `ci.yml` run at all** — the Dependabot squash landed without a post-merge CI pass                                                                                                                                                                                                                                                                                                                                                                         | MED  |

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

> ⚠️ **Superseded on 2026-08-10 — see §0.** Move 1 rests on a premise that does
> not hold (the JWKS cache is already shared; hoisting is useless _and_ unsafe),
> and move 2 shipped. The current top three are in §0 / §6.

| #   | Move                                                                        | Kills      | Effort | 2026-08-10      |
| --- | --------------------------------------------------------------------------- | ---------- | ------ | --------------- |
| 1   | Cache/local-verify the JWT (hoist the client, stop per-request `getClaims`) | C-1        | S      | ❌ retired (§0) |
| 2   | Materialize the global leaderboard + add `idx_attempts_user_exercise`       | H1, H4     | S–M    | ✅ shipped      |
| 3   | Edge-cache the public catalogue/landing + add SSR route loaders             | H-3, C1-fe | M      | ⬜ still open   |

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
- **Footprint at audit time (baseline, 2026-06-30).** The corpus measured 24 MB on
  disk; 61 subjects, 408 chapters, ~1,911 exercise files, **~13,546 questions**; 202
  migrations. Lesson markdown totalled 2.38 MB, exercise JSON 9.0 MB. 439 content
  files carried inline `<svg>` (heaviest IQ/geometry exercises ≈ 15–21 KB each).
  _Note (étude 24, 2026-07-20): the corpus has since moved to the private repo
  `MBeji/yahia-quest-content` and is no longer shipped as Supabase migrations — the
  figures above describe the catalogue, which the runtime still serves identically,
  not this repo's current disk contents._

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

**C2-fe · Hero image is a 245 KB unoptimized JPG in the JS graph** — ✅ **CLOSED
2026-08-10; and "LCP element" was wrong — it is the LAST section of the page.
See §0.** _Original text, kept for the record:_
`public-landing.tsx:18` imports `hero-warrior.jpg` (245 KB), rendered as raw
`<img>` with no `width`/`height` (CLS), no `loading`/`decoding`, no `srcset`, no
~~WebP/AVIF — the landing LCP element on mobile.~~
→ **Fixed:** AVIF/WebP `<picture>` at 960/1920 w, lazy + `decoding="async"` +
intrinsic dimensions. 245 KB → **37 KB** on realistic viewports.

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

**C-1 · Fresh Supabase client + `getClaims` on _every_ server fn** — ❌ **RETIRED
2026-08-10, the premise is false. See §0 for the full account and the test that
pins it.** _Original text, kept for the record:_
`auth-middleware.ts:44-57`. The per-request client means supabase-js's JWKS cache
is empty each call → `getClaims` re-bootstraps verification (JWKS fetch, or a
legacy `GET /auth/v1/user` network round-trip) **before any business logic**, on
~all 33 server fns. At thousands of concurrent users this is the dominant latency
and Auth-service load multiplier.
→ ~~**Fix:** hoist a module-scope client…~~ The JWKS cache is module-global and
keyed by project ref, so per-request clients already share it; hoisting also
leaks the caller's bearer token across requests. The real variable is the JWT
signing algorithm — a project setting, not code (§0).

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

- 🟠 **M-1 mostly done 2026-08-10** — client RUM (LCP/CLS/INP/FCP/TTFB → PostHog,
  +1.5 kB) and slow server-fn timing (≥ 1 s, in the auth middleware) shipped.
  Remaining: the **DB slow-query log** (a Supabase setting) and an LCP _budget_.
- Run the load harness baseline campaign (§4) against a seeded test project. **M**
- ✅ **Done 2026-08-10** — bundle budgets for the unbudgeted vendor chunks
  (M1-fe): `vendor-radix` 88 KB, `vendor-icons` 32 KB, `vendor-three` 900 KB,
  set ~15 % above measured. 9 chunks guarded, was 6. ⚠️ Note the residual hole:
  `check-bundle-budget.mjs` **skips** a budget whose chunk it cannot find, so a
  renamed chunk silently stops being guarded.
- ✅ **Done** — the load harness is wired into the automated suites: `perf:check`
  (harness parses + constants mirror the product) runs in the PR gate (`ci.yml`),
  and `perf.yml` runs `k6 inspect` + a `smoke` load test nightly (`nightly.yml`,
  graceful-skip without the load-test secrets) and on-demand at any `STAGE`.
  Configure `LOAD_SUPABASE_*` secrets against a throwaway project to activate the
  real load run.

### Phase 1 — High-ROI, low-risk (pre-launch must-haves)

_Status stamped 2026-08-10._

- ✅ **Done** — **H4** `idx_attempts_user_exercise`; **H3** first-attempt
  `COUNT(*)`→`EXISTS`; **H2-media** `getChapterLesson` boolean; **H3-fe**
  `useMemo` `renderMarkdown`.
- ❌ **Retired** — **C-1** hoist the auth client (§0: false premise, and unsafe).
- ⬜ **Open, and now the top of the list:**
  - ✅ **C1 done 2026-08-10** — `(SELECT auth.uid())` across all `public` RLS
    policies (`20260810120000_rls_initplan_wrap_auth_uid.sql`); equivalence proven
    by a two-database diff, see §0.
  - ✅ **C2-fe done 2026-08-10** — AVIF/WebP `<picture>`, lazy + sized (245 KB → 37 KB
    on realistic viewports); the audit's "LCP element" framing was wrong, see §0.
  - ✅ **N1 réglé en amont** — le revert #718 a rendu `main` installable de nouveau
    (2026-08-10). Rien à faire de ce côté.
  - **C-1bis** Read the project's JWT signing key type in the Supabase dashboard;
    migrate to asymmetric keys if it is still a symmetric secret. **S** (config)
    — **now observable, 2026-08-18**: `requireSupabaseAuth` used to flatten every
    `getClaims` failure into an unlogged `Unauthorized: Invalid token`, so the
    symmetric path's extra Auth round-trip had no failure signature at all. It now
    logs `Auth verification unavailable` (error level → monitoring) when the Auth
    service is what failed, and `Bearer token rejected` (warn) when the token is.
    A run of the first line in prod logs answers this finding from the outside.

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

_Status column stamped 2026-08-10 (§0). "?" = not re-verified in that pass._

| ID                                        | Tier    | Sev  | One-line                                                     | Status           |
| ----------------------------------------- | ------- | ---- | ------------------------------------------------------------ | ---------------- |
| C1                                        | DB      | CRIT | per-row `EXISTS` + un-wrapped `auth.uid()` in `profiles` RLS | ✅ closed        |
| C-1                                       | Infra   | CRIT | fresh client + `getClaims` per server fn                     | ❌ retired       |
| C-2                                       | Infra   | CRIT | rate-limit DB round-trip before every write                  | ⬜ open          |
| C1-fe                                     | FE      | CRIT | no SSR prefetch — client-side waterfall                      | ⬜ open          |
| C2-fe                                     | FE      | CRIT | 245 KB unoptimized hero JPG, LCP                             | ✅ closed        |
| H1                                        | DB      | HIGH | global leaderboard ranks all profiles per call               | ✅ closed        |
| H2                                        | DB      | HIGH | dungeon `ORDER BY random()` over full join                   | ⬜ open          |
| H3                                        | DB      | HIGH | unbounded per-user aggregates on write path                  | ✅ closed        |
| H4                                        | DB      | HIGH | missing `attempts(user_id, exercise_id)` index               | ✅ closed        |
| H-1                                       | Infra   | HIGH | single cold single-region SSR function                       | ⬜ open          |
| H-2                                       | Infra   | HIGH | scaling load relocates to PostgREST/Auth                     | ⬜ open          |
| H-3                                       | Infra   | HIGH | no edge/CDN cache for public catalogue                       | ⬜ open          |
| H2-fe                                     | FE      | HIGH | all 3 i18n locales bundled eagerly                           | ⬜ open          |
| H3-fe                                     | FE      | HIGH | `renderMarkdown` re-runs DOMPurify per render                | ✅ closed        |
| H1-media                                  | Content | HIGH | inline SVG ships on every question fetch                     | ⬜ open          |
| H2-media                                  | Content | HIGH | `getChapterLesson` over-fetches sibling markdown             | ✅ closed        |
| M1-fe                                     | FE      | MED  | vendor chunks with no bundle budget                          | ✅ closed        |
| M4                                        | DB      | MED  | `getDashboard` aggregates a full attempt history in JS       | ✅ closed        |
| **N1**                                    | Tooling | HIGH | `npm ci` fails on Node 22 — lock needs npm ≥ 11              | ✅ closed (#718) |
| **N2**                                    | Quality | MED  | false "generated" header on `auth-middleware.ts`             | ✅ closed        |
| **N3**                                    | CI      | MED  | current `main` has no `ci.yml` run                           | ⬜ open          |
| M1–M3, M5 (DB), M-2–M-3 (Infra), M2–M3-fe | mixed   | MED  | see §3 — all swept 2026-08-10, table in §0                   | ⬜ open          |
| L-\*                                      | mixed   | LOW  | see §3 — L1/L4/L-1 swept 2026-08-10, table in §0             | ⬜ open          |

_No application code was modified by the audit. Remediations ship as separate,
reviewable changes per the roadmap._
