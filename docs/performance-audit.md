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
> "?" lines, ran on the 13th) · **§0-bis : suivi parental mesuré sur la prod le
> 2026-08-19** · **§0-ter : passe multi-agents du 2026-10-31 → 2026-11-03 (`main`
> à #1208), 11 lots livrés, 1 constat réfuté, 21 au backlog**. Re-run the audit when the
> catalogue or user base grows an order of magnitude.

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

| ID                  | Evidence today                                                                                                                                                                                                                | Sev  |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- |
| ~~**C1**~~          | ✅ **closed 2026-08-10** — see below; the "71" first reported here was a count over migration _text_, not the live policy set                                                                                                 | CRIT |
| **C1-fe**           | waterfall intact — but the stated remedy is **blocked by the auth architecture**, see below (2026-08-13)                                                                                                                      | CRIT |
| ~~**C2-fe**~~       | ✅ **closed 2026-08-10** — AVIF/WebP `<picture>`, lazy, sized; and it was never the LCP element (see below)                                                                                                                   | CRIT |
| **H2**              | dungeon pick still `ORDER BY random()` — **now measured**, see below (`20260720200000_dungeon_scoped_to_parcours.sql:174`)                                                                                                    | HIGH |
| ~~**H2-fe**~~       | ✅ **clos 2026-10-31** (§0-ter, `ac44de0`) — `i18n-fr` seul importé statiquement, `en`/`ar` par `import()` ; −43 KB gz par élève FR                                                                                           | HIGH |
| **H-1 / H-3 / H-2** | infra unchanged: single `arn1` serverless fn, no edge cache on the public catalogue — **relu 2026-11-03 (§0-ter)** : H-3 🟠 à arbitrer (ssr-04, trois voies), H-1 mesuré (ssr-05 : 50-80 ms mécaniques au plus), H-2 inchangé | HIGH |
| **M-1**             | 🟠 **client RUM + slow server-fn timing landed 2026-08-10** (see below); the DB slow-query log is a Supabase setting                                                                                                          | MED  |

#### The remaining findings, swept 2026-08-13 — no line left unverified

The first pass left seven findings at "?". They are now all read in the code
(**swept 2026-08-13**). One more turned out to be false, which is the **fourth**
of the original audit.

| ID           | Verified today                                                                                                                                                                                                                                                                                                                                    | State                 |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| **C-2**      | `isRateLimited` still calls the `check_rate_limit` RPC **first**, at 8 feature call sites; `isRateLimitedLocal` is only an **error fallback**, not a first-gate — **2026-10-31 (§0-ter)** : les lectures qui suivaient la RPC partent avec elle (`932584d`, db-03) ; la purge `random()` est db-04 ; la porte locale reste (24 sites aujourd'hui) | ⬜ open, réduit       |
| **M2**       | `get_dungeon_access` still runs 2 × `COUNT(DISTINCT)` — **measured 2026-08-13**, see below                                                                                                                                                                                                                                                        | ⬜ open, chiffré      |
| **M5**       | `get_student_report` still multi-scan (`20260708120000_student_report_by_code.sql`) — admin/parent frequency, so it stays acceptable                                                                                                                                                                                                              | ⬜ open, low          |
| **M1** (DB)  | the `FOR UPDATE` chain on `profiles` is still there, but its amplifier (H3's unbounded aggregates) is gone — window much shorter                                                                                                                                                                                                                  | 🟠 mitigated          |
| **M3** (DB)  | N+1 `has_parcours_entitlement` — inert in the free phase; already tracked as **latent** in `docs/dette-technique.md`                                                                                                                                                                                                                              | 💤 latent             |
| **H1-media** | `getExercise` still selects `options` wholesale (`quest.server.ts:744`), so inline SVG still ships per fetch                                                                                                                                                                                                                                      | ⬜ open               |
| **M3-fe**    | réel (50 `motion.div`, `leaderboard.tsx:253`) mais **déjà atténué** trois fois — voir ci-dessous                                                                                                                                                                                                                                                  | 🟠 atténué            |
| **M4-fe**    | **FALSE** — "the dungeon route bundles all gameplay eagerly". The router plugin already splits it: `dungeon-*.js` is its own **15.15 kB** chunk, fetched only when a player navigates there                                                                                                                                                       | ✅ closed             |
| **L1**       | ✅ **closed** — the 3 content queries were already parallel; the remaining serial call (`get_best_scores_by_exercise`) now rides the same `Promise.all`, removing one round-trip per authenticated subject load                                                                                                                                   | ✅ closed             |
| **L4**       | ✅ **mesuré 2026-08-13 : n'en vaut pas la peine** — l'index `(user_id, scheduled_for)` existant suffit, voir ci-dessous                                                                                                                                                                                                                           | ✅ clos (sans action) |
| **L-1**      | `isRateLimitedLocal`'s store is module-scope ⇒ per-instance; the effective cap really is × N instances — relu 2026-11-03, inchangé                                                                                                                                                                                                                | ⬜ open by design     |
| **M-2**      | `waitUntil` est bien un no-op, mais **aucun code de `src/` ne l'appelle** — piège latent, pas défaut actif ; relu 2026-11-03, inchangé                                                                                                                                                                                                            | 🟠 latent             |

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

## 0-bis. Suivi parental — les sources scopées, mesurées le 2026-08-19 (`main` à #776)

> Même règle qu'au §0 : rien ici qui n'ait été mesuré. Tout vient d'`EXPLAIN
(ANALYZE, BUFFERS)` sur la **prod**, le 2026-08-19, sur l'élève le plus chargé
> (163 tentatives, 43 pouls). Contexte de volume : `attempts` = 270 lignes sur
> **8 pages**, `learning_pulses` = 107 lignes sur **2 pages**.

### Le soupçon, et ce qu'il avait de juste

`_scoped_attempts` / `_scoped_pulses` (`20260817120000_parent_report_class_scope.sql`)
sont `SECURITY DEFINER` **et** portent un `SET search_path`. Chacune de ces deux
propriétés suffit à faire refuser l'inlining d'une fonction SQL à retour
ensembliste (`inline_set_returning_function`, prosecdef / proconfig) — le même
mécanisme que #769 avait établi pour `student_parcours_progress`. Conséquence
vérifiée dans les plans : **les prédicats de date restent en `Filter:` au-dessus
du `Function Scan`**, jamais poussés dedans (`Rows Removed by Filter` jusqu'à
141), donc `idx_attempts_user_completed_at` ne travaille pas. Chaque appel rend
tout l'historique de l'élève, puis jette.

L'en-tête de cette migration affirme pourtant l'inverse — « Postgres sait les
inliner, le plan reste celui d'un accès direct aux index ». C'est faux, et c'est
la phrase qui décourage l'inspection : même classe de défaut que **N2**.
Corrigé par `20260819093000_scoped_sources_inlining_truth.sql`, qui pose la
vérité en `COMMENT ON FUNCTION` — là où le prochain lecteur regardera.

### Ce que ça coûte : le diagnostic est juste, l'ordre de grandeur ne l'était pas

`_student_daily_report_json` appelle ces deux fonctions **22 fois** par rapport :
10 dans son corps, plus 6 par appel de `student_activity_totals`, elle-même
appelée deux fois (période courante + période précédente).

Les 10 lectures du corps, rejouées à l'identique dans une seule requête :

| variante                                            | buffers | temps  |
| --------------------------------------------------- | ------- | ------ |
| telles qu'écrites — 10 `Function Scan`              | **731** | 4,9 ms |
| historique matérialisé une fois — 2 `Function Scan` | **686** | 3,0 ms |
| accès direct aux tables (plancher théorique)        | **334** | 3,0 ms |

Et le rapport entier, pour situer :

| appel                                     | buffers   | temps (plan chaud) |
| ----------------------------------------- | --------- | ------------------ |
| 30 jours, périmètre « tout »              | **4 780** | 32 ms              |
| 30 jours, périmètre « sa classe »         | 3 836     | 29 ms              |
| 92 jours, périmètre « tout »              | 9 299     | 48 ms              |
| `student_activity_totals` seule, 30 jours | 1 552     | 8,4 ms             |

→ **La réécriture en CTE partagée achète 45 buffers sur 4 780 : 0,9 %.** Elle ne
vaut pas une migration, et elle est nettement plus invasive qu'il n'y paraît
(voir « la contrainte plpgsql » ci-dessous). **Fermé sans action**, et consigné
ici pour que la piste ne soit pas re-proposée : _elle est écartée exprès, et
voici le nombre._

### Pourquoi si peu : le surcoût est par INSTRUCTION, pas par appel

Le détail des `Function Scan` explique l'écart entre l'intuition et la mesure :

- premier appel de `_scoped_attempts` dans une instruction : **217 buffers** ;
  chaque appel **supplémentaire** : **9**. Côté pouls : **94** puis **3**.
- un appel isolé, seul dans sa requête : **356 buffers**, stable sur deux
  exécutions consécutives — ce n'est donc pas un réchauffement de cache.

Autrement dit la boîte noire coûte une mise en place fixe, payée une fois par
instruction, et presque rien par appel répété — parce qu'un parcours complet de
`attempts` ne fait que 8 pages. **Il n'y a rien qu'un index puisse économiser
aujourd'hui** : c'est la même conclusion que **L4**, pour la même raison.

### Où va vraiment le coût du rapport

La couverture du programme, pas les sources scopées. Dans la requête
« matières » (2 435 buffers sur 30 jours), `student_parcours_progress` en pèse
**1 818 — 75 %**, à `loops=5` ; sur 92 jours, **3 346 à `loops=10`**, soit
~350 buffers par matière travaillée. C'est ce qui fait passer le rapport de
4 780 à 9 299 buffers quand la fenêtre passe de 30 à 92 jours : **le coût suit le
nombre de matières, pas l'historique**.

#769 a mesuré que la réécriture en passe unique n'y devient gagnante qu'au-delà
de ~23 appels. Sur 92 jours on est à 10. **Ne pas y toucher** — la mesure du
2026-08-19 confirme celle du 18.

Un point mérite plus d'attention que les buffers : le **premier** appel du
rapport, plan froid, coûte **262 ms** (330 ms en périmètre « classe ») contre
~30 ms ensuite. `/suivi` s'exécute en rôle `anon`, dont le statement timeout
Supabase est de **3 s** (contre 8 s pour `authenticated`) : le plan froid mange
donc ~9 % du budget, la charge utile en mange 1 %. → Mesuré depuis la page
publique et **fermé sans action**, voir « Le plan froid » plus bas.

### Le seuil de bascule, et le remède — finalement livré par anticipation (#779)

Le gaspillage suit l'historique de l'élève : un appel redondant relit toutes ses
lignes, soit ~N/34 pages (`attempts` : 270 lignes sur 8 pages). Sur les 22
appels, **4 ont réellement besoin de tout l'historique** — `measuredSince`, la
numérotation des tentatives, et `first_pass` qui compte double puisque
`student_activity_totals` est appelée deux fois. Les **18 autres** sont
logiquement bornés à la fenêtre et relisent pourtant tout, soit ~18·N/34 buffers
jetés :

| historique de l'élève | buffers gaspillés | verdict                                  |
| --------------------- | ----------------- | ---------------------------------------- |
| N = 163 (aujourd'hui) | ~90               | négligeable                              |
| N ≈ 2 000             | ~1 060            | un cinquième du rapport actuel           |
| N ≈ 7 000             | ~3 700            | à parité avec la couverture du programme |

**Le remède à appliquer alors n'est pas la CTE** — elle matérialise encore tout
l'historique, deux fois. Ce sont des **bornes de date sur les deux fonctions** :
`p_from` / `p_to` avec sentinelles `-infinity` / `infinity` plutôt que `NULL`,
pour rester sargable. `attempts.completed_at` et `learning_pulses.occurred_at`
sont `NOT NULL`, donc les sentinelles sont strictement équivalentes à l'absence
de prédicat — aucune ligne ne change de camp. Les 18 appels bornés redeviennent
des `Index Cond` ; les 4 autres restent des parcours complets, et c'est inhérent.
Le plancher mesuré pour cette voie était **334 buffers contre 731**, soit −54 %
sur les lectures du corps, quand la CTE ne rend que −6 %. ⚠️ Ce −54 % **n'a pas
été tenu** : voir « Après livraison » ci-dessous, où le lot est mesuré pour de
vrai à −20 %. Le 334 était un plancher inatteignable, et il faut savoir pourquoi.

### Après livraison — ce que le lot a réellement rendu (#779, 2026-08-19)

Le lot est parti (`20260819113000_scoped_sources_date_bounds.sql`). Deux choses
méritent d'être écrites, parce qu'elles corrigent les chiffres ci-dessus.

**1. Le « plancher » de 334 buffers était un mirage.** Il avait été mesuré en
accès DIRECT aux tables, dix lectures fusionnées dans une seule requête : cette
forme supprime non seulement le prédicat mal placé, mais **tout le coût d'appel
de fonction**, que la version paramétrée continue évidemment de payer. Comparer
une fonction bornée à du SQL sans fonction, c'est mesurer autre chose. La leçon
est la même qu'en #769 sous un autre angle : _on ne généralise pas depuis une
variante qu'on n'a pas mesurée dans sa forme livrable._

**2. La ligne de base de 731 s'est périmée en une heure.** Remesurée l'après-midi
sur les mêmes données logiques, l'ancienne forme coûtait **1 329** buffers et non
731 : le planificateur avait basculé le plan interne des sources scopées du
`Seq Scan` vers l'`Index Scan`, les statistiques ayant bougé avec quelques
dizaines de lignes. Sur une table de 8 pages, **aucune ligne de base n'est valable
au-delà de quelques minutes** — un avant/après ne vaut que pris au même instant.

**Le vrai A/B**, même instant, mêmes données, l'ancien comportement reproduit par
les sentinelles (strictement équivalentes, cf. la preuve d'égalité) :

| forme                         | buffers   | temps, 3 exécutions    |
| ----------------------------- | --------- | ---------------------- |
| ancienne (sentinelles)        | 1 329     | 62,2 / 5,5 / 9,7 ms    |
| **nouvelle (bornes passées)** | **1 058** | **4,7 / 5,0 / 4,8 ms** |

→ **−20 % de buffers**, et surtout une latence plus basse **et beaucoup plus
stable** : l'ancienne forme varie d'un facteur 2 d'une exécution à l'autre, la
nouvelle tient dans 0,4 ms. C'est moins que les −54 % annoncés, et c'est réel.

**Égalité vérifiée après application, pas seulement avant.** Les 24 empreintes
`md5` prises avant la migration ont été recalculées après. Le total global
diffère — et c'est légitime : l'élève `10e49c7d` utilisait l'application pendant
la mesure (dernière tentative 5 secondes avant la requête), et la charge utile
porte `level`, `currentStreak`, `lastActiveDate`, `measuredSince` et la couverture
du programme, tous **hors fenêtre**. Restreint aux **trois élèves inactifs depuis
juin/juillet**, dont aucune donnée ne peut avoir bougé : **18 empreintes sur 18
identiques, zéro écart**. C'est la preuve de bout en bout, sur les données de
prod, de part et d'autre d'une migration réellement appliquée.

### Le plan froid — mesuré côté parent, et **fermé sans action**

Les 262 ms du premier appel (330 ms en périmètre « classe ») avaient été signalés
plus haut comme plus inquiétants que les buffers. Ils ont été mesurés là où ça
compte : **depuis la page publique `/suivi` en production**, en relevant la durée
de l'appel `_serverFn` — réseau, SSR Vercel et RPC Supabase compris, c'est-à-dire
ce que le parent attend vraiment.

| appel                          | latence de bout en bout        |
| ------------------------------ | ------------------------------ |
| premier (tout à froid)         | **629 ms**                     |
| les cinq suivants (5 fenêtres) | 375 · 306 · 262 · 244 · 216 ms |

→ **Fermé sans action.** Le pire cas observé est 629 ms de bout en bout, dont le
statement timeout `anon` ne couvre que la part base — au pire ~262 ms, soit **9 %
des 3 s**. Et ce coût est payé une fois par **backend**, pas par requête : le
cache de plans d'une fonction plpgsql vit sur la connexion, que Supavisor réutilise
(runs 2 et 3 de la même session : 32 ms). Le seul levier qui le réduirait
vraiment — fusionner les 16 instructions du corps en une seule — est le
remaniement de ~400 lignes déjà écarté ci-dessous pour un autre motif. On ne paie
pas ça pour 9 % d'un budget qu'on n'approche jamais.

### La contrainte plpgsql qui rend la CTE plus chère qu'elle n'en a l'air

« Matérialiser une fois en tête de la fonction » n'est pas réalisable tel quel :
**une CTE ne vit que le temps d'une instruction SQL**. Les 10 lectures du corps
sont réparties sur **6 instructions** distinctes (`measuredSince`, jours, cours,
exercices, matières, chapitres), et les 12 autres sur les 5 instructions de
`student_activity_totals`. Mutualiser à l'intérieur de chaque instruction ne fait
tomber que 10 → 8. Atteindre les 2 lectures du banc d'essai suppose de **fusionner
les instructions** en un seul `SELECT … INTO` — un remaniement de ~400 lignes
pour 0,9 %. C'est la seconde raison du refus.

### Méthode, pour que ce soit rejouable

Aucun accès direct à la base prod n'existe depuis le poste de dev (pas de
`psql`, `db.<ref>.supabase.co` en IPv6 seul, identifiants confinés au secret
GitHub `PROD_SUPABASE_DB_URL`). Les mesures ci-dessus ont été prises dans
l'**éditeur SQL du dashboard**, en `EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)` —
le format JSON rend un plan en une seule ligne, ce qui évite la troncature de la
grille de résultats. Lecture seule, aucun DDL. Les plans internes d'une fonction
plpgsql n'apparaissent pas : le nœud `Result` de l'appel en agrège en revanche
tous les buffers, ce qui suffit pour un avant/après.

---

## 0-ter. Passe du 2026-10-31 — workflow multi-agents (`main` à #1208)

> Même règle qu'aux §0 et §0-bis : **on n'inscrit ici qu'un constat dont on a relu la
> ligne**, et ce qui a été réfuté compte autant que ce qui a été livré. Tout chiffre
> ci-dessous vient d'une mesure rejouable (sonde jsdom ou Chromium, chaîne SQL rejouée,
> build de référence, `curl` sur la prod) ; les estimations sont nommées comme telles.
> Branche `claude/workflow-dynamique-optimisation-gdcat4`, 11 commits `perf(...)` du
> 2026-10-31 au 2026-11-03 (l'axe SSR, coupé par la limite d'usage au premier run, a été
> rejoué le 2026-11-03 — ses mesures prod portent cette date).

**Méthode, en trois lignes.** _Run 1_ : cinq explorateurs en parallèle, un par axe
(couche données, chargement/bundle, rendu React, base, SSR/infra), chacun en lecture seule
du checkout principal avec son worktree jetable et son build de référence copié hors de
`dist/` — **31 constats** sur quatre axes, plus 5 pour l'axe SSR rejoué au _run 2_.
_Voie A_ : six constats déjà mesurés par l'explorateur, implémentés directement, la prémisse
re-vérifiée par l'implémenteur sur le HEAD courant avant de toucher une ligne. _Voie B_ : six
constats passés chacun par un **sceptique indépendant** (relecture de la ligne, mesure
avant/après dans un worktree, correctif révisé) avant tout code — **un des six a été
réfuté** (ssr-02), et trois autres sont sortis du sceptique avec un impact ou un remède
corrigé (bundle-03, data-03, ssr-01). Base de toutes les mesures « avant » : `c2f213b`
(= `main` au départ de la passe).

### Livré — onze lots, chacun avec sa mesure et son commit

| ID            | Constat (relu)                                                                                                                                                                                                         | Verdict                                                 | Preuve / mesure avant → après                                                                                                                                                                                                                                                                                                                                                                                                                                     | Commit    |
| ------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| **db-01**     | `chapter_progress_ref` (STABLE, joint toutes les tentatives de l'élève) recopiée dans le `FILTER` de l'agrégat de `chapter_star_rungs` — depuis PG 12 une CTE référencée une fois est aplatie                          | ✅ confirmé, voie A                                     | Chaîne rejouée (2 000 élèves, 105 k tentatives, élève engagé à 5 000) : hub matière **1 464 → 40** évaluations (126-150 → 63-73 ms), tableau de bord **5 490 → 150** (382-429 → 161-205 ms), une soumission 38 → 1 (3,5-9,2 → 2,8-6 ms) ; md5 des sorties identiques ; pgTAP `106_crans_reference_une_fois` compte les évaluations par une sonde                                                                                                                  | `82d6347` |
| **data-01**   | `getSubject` lisait `chapters.select("*")` : le markdown complet (`lesson_content`, `summary`) de tous les chapitres partait au hub et à chaque mission (calcul de « Suivant »)                                        | ✅ confirmé, voie A                                     | Corpus privé (96 matières, 848 chapitres) : JSON médian **93,5 → 15,3 KB**, p90 506 → 38 KB, max 1 445 → 122 KB (fiqh), math-6ᵉ 1 095 → 62 KB ; colonnes nommées (`SUBJECT_CHAPTER_COLUMNS`, `SUBJECT_EXERCISE_COLUMNS`), test `quest-get-subject.test.ts` rougit sur un retour à `*`                                                                                                                                                                             | `6d678fc` |
| **rendu-01**  | `RichField`/`OptionContent`/`SvgFigure` rejouaient `extractFigure` + DOMPurify + `splitMathRuns` à chaque tic d'état sans que `raw` change (19 points de montage : lecteur, donjon, examen, plateaux dnd-kit)          | ✅ confirmé, voie A                                     | jsdom, question arabe à 4 options SVG, 6 taps : **30 → 5** `sanitize` (≈ 2,5 ms chacun), 0 au remontage ; cache de module borné (512 entrées, FIFO, clé = chaîne exacte) devant les quatre fonctions — même sanitiseur, c'est sa _sortie_ qui est rejouée (`docs/xss-rendering-policy.md`)                                                                                                                                                                        | `9ef93ad` |
| **bundle-02** | Le compilateur TanStack Start retire `.validator()`/`.handler()` des stubs client mais garde toute instruction de niveau module : trois modules construisaient des schémas zod au chargement → zod entier côté client  | ✅ confirmé, voie A                                     | `dist/client/assets` : chunk `schemas-*.js` **84 007 B (23,7 KB gz) → absent** ; `parent-report.server-*` 3 509 → 1 758 B ; `daily-dashboard-*` 67 914 → 64 378 B ; schémas déplacés dans `*.schemas.ts` importés par les seuls validateurs ; `check-bundle-budget` refuse tout chunk client `schemas-`                                                                                                                                                           | `9d61529` |
| **db-03** (1) | `submitAttempt` : 4 allers-retours en série avant la première RPC (`check_rate_limit` → `question_type` → `exercise_session_reveals` → `exercises.mode`), sans dépendance entre eux ; donjon : 2                       | ✅ confirmé, voie A (partie 1 seule)                    | Latence simulée 5 ms/aller-retour, 20 soumissions : **38,8 → 22,6 ms** (−42 %) ; étapes série avant la RPC 4 → 1, dans tout l'appel 7 → 4 ; mêmes requêtes, précédence des refus conservée (débit d'abord, format ensuite) ; contrôle négatif : les 2 tests de parallélisme rougissent sur la version série                                                                                                                                                       | `932584d` |
| **rendu-02**  | `ExamRunner` : un état `answers` unique re-rendait les N articles de l'épreuve à chaque coche (`onChange`/`optionClassName` inline, aucun `memo`)                                                                      | ✅ confirmé, voie A                                     | jsdom, 20 questions à figures, cache rendu-01 en place : **20 → 1** article rendu par coche, 33,0 → 2,2 ms par tap ; `<ExamQuestionCard>` mémoïsée + props stables, `.exam-question-cv` (second usage du motif `content-visibility` après `.list-row-cv`) ; chunk +211 B, `build:check` vert. Le « 306-422 ms » de l'explorateur était mesuré _avant_ rendu-01, qui absorbait déjà les sanitize                                                                   | `d64ecbc` |
| **data-02**   | `refetchOnWindowFocus`/`refetchOnReconnect` au défaut `true` avec `staleTime` 30 s : chaque retour d'onglet > 30 s relançait toutes les queries montées (9 sur /dashboard, dont une _écriture_ SQL)                    | ✅ confirmé par le sceptique, voie B                    | Sonde Testing Library (vrai `query-core` 5.105, 9 queries, `Date` truquée, `visibilitychange`/`online` dispatchés) : **36 → 9** appels de `queryFn` pour des retours à +20/+31/+62 s et une reconnexion à +93 s ; seuil de _reprise_ 5 min (`query-resume.ts`), `staleTime` et `refetchOnMount` intacts ; classement (5) et salon duel (3) en opt-in `true`, joueur en opt-out                                                                                    | `20df36e` |
| **bundle-04** | **H2-fe** : catalogue trilingue 192 215 B / 66 303 gz importé statiquement par `index` et préchargé sur chaque page, pour une seule langue utile                                                                       | ✅ confirmé par le sceptique, voie B                    | `i18n-fr` 62 403 / 22 938 gz (seul statique, seul préchargé, meta inclus), `i18n-en` 55 502, `i18n-ar` 74 476 derrière `import()` ; par élève sur le chemin critique **FR −129 812 B bruts / −43 331 gz**, AR −55 336 ; Chromium 3G (cookie ar, `/`) : JS 373 → 354 KB, premier texte arabe 4 334 → 4 041 ms médian, chunk ar reçu ≈ 500 ms avant l'effet post-montage. Budgets 64/60/76 KiB                                                                      | `ac44de0` |
| **data-03**   | `getDashboard` : un `Promise.all` puis 8 `await` en série sans dépendance (builder postgrest-js = thenable paresseux, chaque `await` isolé = un aller-retour) ; `get_learning_state` exécuté deux fois                 | ✅ confirmé par le sceptique, voie B                    | Sonde à horloge logique, scénario le plus long : 14 lectures, **10 → 2 vagues** (le sceptique corrige le constat : pas d'« étage C », remédiation et consolidation étaient déjà parallèles) ; doublon client supprimé (server fn `getLearningState` retirée, l'état arrive en prop) ; chunks dashboard 36 769 → 36 679 B, learning-panels 10 066 → 9 975 B ; **db-02** est le même constat, clos                                                                  | `2ed3a51` |
| **bundle-03** | La signature « نقرا نلعب » en `font-arabic` déclenchait via `unicode-range` la face Noto Kufi complète (123 688 B, woff2 incompressible) sur chaque page publique, mobile compris (span du pied de page sans `hidden`) | ✅ confirmé par le sceptique, voie B — volet (a) réfuté | Chromium, `/` et `/programme`, 375/1280, cookie absent/ar : fontes **157 776 → 40 880 B** par page publique (−74 %) ; sous-police variable 35 glyphes / 6 792 B, équivalence HarfBuzz prouvée à wght 400/600/700 ; pin réseau dans `smoke:shell` (requête de la face complète interdite, contrôle négatif joué). Le preload conditionnel `ar` de la face complète (volet a) est **réfuté** : aucun consommateur runtime, 124 KB en haute priorité sur chaque page | `c707461` |
| **ssr-01**    | Tout `public/` (fontes, icônes, favicon, manifest) servi au défaut Vercel `max-age=0, must-revalidate` : un 304 par fichier à chaque chargement complet, FOUT puis échange de police                                   | ✅ confirmé par le sceptique, voie B (impact 4 → 3)     | Prod 2026-11-03 (`curl`) : `max-age=0` sur tout `public/`, `/assets/<hash>` bien `immutable` ; 304 à **0,050 s sur connexion réutilisée** (le « 420-590 ms » du run 1 incluait le TLS d'une connexion neuve — d'où l'impact revu à la baisse). Après : 6 routes dans `scripts/vercel-routes.mjs` (module pur, testé) — `/fonts/*` immutable 1 an, icons/favicon/manifest 1 j + SWR 7 j, `sw.js`/`offline.html`/`robots.txt`/HTML au défaut (voulu pour un SW)     | `2122bb1` |

Gates : chaque lot est passé par prettier, `eslint --max-warnings 0`, `tsc` (app + scripts) et
les suites concernées ; les lots de voie B par la suite complète (jusqu'à 367 fichiers /
4 842 tests), `build:check` (16 budgets, index 448,85 / 456 KiB) et `smoke:shell` ; ssr-01 par
`npm run verify` entier. Aucune migration hormis db-01 (additive, `db:check-chain` + pgTAP).
Aucun budget relevé — bundle-04 en _remplace_ un (188 KiB) par trois plus bas.

### Réfuté — et pourquoi

**ssr-02 — « la fonction Vercel n'a pas `supportsResponseStreaming: true`, donc la plateforme
tamponne le flux SSE du tuteur ».** Ce qui est exact : `.vc-config.json` ne porte pas le
drapeau (aucune occurrence, `git log -S` vide), l'adaptateur relaie bien chunk par chunk
(harnais scratch rejoué sous Node 24 : 4 trames reçues à +24 / +323 / +623 / +923 ms,
`transfer-encoding: chunked`), et rien ne teste l'adaptateur sous Vercel. Ce qui ne tient pas :
le _mécanisme de coût_ (« drapeau absent = invocation tamponnée ») est une **inférence** tirée
d'une ligne de doc qui ne décrit que le cas `true`, contredite par trois sources Vercel
concordantes — le changelog du 2024-07-04 (« streaming enabled by default for all Node.js
Vercel Functions », Hobby depuis le 2024-07-08, Pro depuis le 2024-10-01), le guide Express
(signature `(req, res)`, la forme de notre adaptateur : « stream responses by default on
Node.js »), et le code ouvert de `@vercel/build-utils` (`get-lambda-supports-streaming.ts`,
PR #15795 : `launcherType === 'Nodejs'` ⇒ `supportsStreaming: true` quand le drapeau est
absent ; PR #16274 : les lambdas à drapeau `undefined` sont « silently flipped to true »).
Notre config (launcher `Nodejs`, pas d'`awsLambdaHandler`) est donc déjà streamée ; les
« 3-6 s d'écran vide » n'avaient pas été mesurés (le flux exige un Bearer élève et une clé
IA). Par défaut du sceptique, trois sources contre une inférence : **rien à livrer**. Pour une
certitude plutôt qu'une documentation : DevTools → Network → `POST /api/tutor/stream` →
EventStream, les trames `token` doivent arriver une à une. Si un jour cette mesure montrait
TTFT = TTLT, le correctif durci est consigné dans le verdict (drapeau explicite + catch
`headersSent` + contre-pression `drain`/`close`). L'argument annexe (« la limite 4,5 MB ne
s'applique qu'aux réponses non streamées ») ne tient pas non plus : la page Limits l'énonce
sans exemption.

Corrections de moindre portée, par le sceptique ou l'implémenteur, qui valent d'être
rejouées avant de re-proposer un constat :

- **bundle-03 (a)** — le preload conditionnel `ar` de la face Noto Kufi complète : réfuté,
  voir le tableau.
- **data-03** — « 3 étages » : le graphe réel n'en a que 2 ; db-02 (vue SQL du même constat)
  avait raison sur le nombre, et se clôt avec le lot.
- **ssr-01** — le 420-590 ms par 304 était du TLS de connexion neuve ; 50 ms sur connexion
  ouverte, ≈ 1 RTT PoP (80-250 ms mobile). Réel, modeste, impact 4 → 3.
- **rendu-02** — les 306-422 ms par tap de l'explorateur étaient mesurés avant rendu-01 ; le
  lot ne supprime « que » le travail React restant (33 → 2,2 ms).
- **db-01, deux A/B perdants à ne pas refaire** : `chapter_progress_ref` réécrite en
  `LATERAL MAX` est **10 × plus lente** (MAX via index `(user, completed_at)` + filtre
  `exercise_id`), et une version LATERAL de `get_subject_progress` aussi (1 s). Seul
  `WITH ref AS MATERIALIZED` est prouvé.

### À arbitrer — décisions produit ou d'architecture, pas des patchs

| ID                     | Ce qui est établi                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | Question au propriétaire                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **ssr-04** (= **H-3**) | Le cache CDN des pages publiques est bloqué par **trois** choses précises : nonce CSP par requête, shell dépendant des cookies locale/thème, clé de cache Vercel aveugle aux cookies. Enjeu : visiteur anonyme (SEO, lien partagé) — TTFB mesuré 370-1 050 ms depuis les États-Unis pour 3,7-7,6 KB br, ≈ 150-250 ms estimés à chaud depuis la Tunisie, contre ~50-100 ms pour un HIT au PoP. Les élèves connectés n'y gagneraient rien (leurs données n'arrivent pas dans le HTML, C1-fe) | Trois voies : **(A)** saine — routes publiques en rendu tamponné (le shell se rend en 5-40 ms, sans loader) + CSP par hachage `'sha256-…'` au lieu du nonce, variantes (locale, thème) par route `has: cookie`, `s-maxage=300, stale-while-revalidate=3600` ; **(B)** accepter la réutilisation d'un nonce pendant un `s-maxage` court (60 s) — contredit GAP-022, à inscrire au journal des décisions si retenu ; **(C)** ne rien cacher et traiter la latence par ssr-05. Ne pas glisser (B) dans un patch perf. |
| **bundle-05**          | Le corps SSR est toujours en français : un élève arabophone voit du français mis en page RTL jusqu'à l'hydratation (3-5 s en 3G sur mobile bas de gamme). bundle-04 a préparé le terrain (`loadCatalogue` exposé) ; il reste à attendre le chunk de locale avant `hydrateStart` quand le cookie n'est pas `fr`                                                                                                                                                                             | Changement **visible** (la première peinture change de langue — amélioration, zéro gameplay). On l'assume comme tel, dans son propre lot ?                                                                                                                                                                                                                                                                                                                                                                         |
| **rendu-04**           | `AnimatePresence mode="wait"` impose ~300-430 ms de sortie + entrée par question : ≈ 3-4 s d'attente incompressible par mission de 10, ≈ 2 s par lot de 5 au donjon, sur tous les appareils ; un e2e dépend de l'ordre actuel                                                                                                                                                                                                                                                              | Fondu croisé court (`popLayout`/`sync`, 0,12-0,15 s) ou échange instantané avec entrée seule ? C'est ce que l'élève voit : à trancher, pas à glisser.                                                                                                                                                                                                                                                                                                                                                              |
| **rendu-05**           | `GoldAmbient` : trois halos `blur-3xl` (σ ≈ 64 px) dont deux animés en boucle, fixés derrière chaque écran connecté, quête et donjon compris — coût GPU **estimé** 1-3 ms/frame sur un Mali/Adreno d'entrée de gamme, **non mesuré**                                                                                                                                                                                                                                                       | D'abord une trace Performance sur un Android milieu de gamme avant/après ; si le temps GPU est négligeable, clore avec le chiffre (précédent L4). Sinon : statique sur tactile, ou dégradé sans filtre — nuance décorative à accepter.                                                                                                                                                                                                                                                                             |

H2 (`ORDER BY random()` du donjon) et M2 (`get_dungeon_access`) restent les décisions produit
du §0 : définitions relues, mesures de 2026-08 toujours valables.

### Non instruits cette passe — le backlog de la prochaine, par impact décroissant

Un correctif en une ligne par constat, tel que l'explorateur l'a proposé ; **aucun n'a été
relu par un sceptique** — c'est la première chose à faire avant de l'implémenter.

| ID                                      | Impact | Effort | Constat                                                                                                                                                                                              | Correctif proposé (non relu)                                                                                                                                                                                                                                                    |
| --------------------------------------- | ------ | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **data-05**                             | 4      | M      | Démarrer une quête = `getExercise` (4 sauts en série) _puis_ `startExerciseSession` : 2 allers-retours mobiles successifs (≈ 500-900 ms) avant la première réponse possible                          | Mode « eager » dans `useExerciseSession` (la route connectée lance `mutate` au montage sans attendre `data`, gardes `startedForRef`/`startGate` conservées) ; dans `getExercise`, joindre `chapters(…)` et l'inventaire dans le premier `Promise.all`                           |
| **data-04**                             | 3      | S      | Charge morte dans le payload du tableau de bord : `otherSubjects` jamais lu (≈ 25 KB), 49 lignes de `recent` inutiles, `pendingSpacedReps` jamais lu, `getDailyRing` relit `profile`                 | Retirer `otherSubjects`, `.limit(1)` sur `recent`, retirer la lecture SRS de `getSprint2Dashboard`, dériver l'anneau du jour de `data.profile` ; même objet de retour que data-03 — à enchaîner après `2ed3a51`                                                                 |
| **data-06**                             | 3      | S      | Le catalogue (matière, chapitre, exercice) est caché comme de la donnée vive (staleTime 30 s / gcTime 5 min), clés sans identité de viewer, `["lesson"]` jamais invalidé                             | `staleTime` 15 min / `gcTime` 30 min sur subject/lesson, clé par viewer (`user?.id ?? "anon"`), `invalidateQueries(["lesson"])` à côté de `["subject"]` au succès de `submitAttempt`                                                                                            |
| **data-07** (= **C1-fe**, volet client) | 3      | M      | Aucun loader de route : chunk de route, _puis_ montage, _puis_ query — ≈ 150-400 ms par navigation SPA vers /dashboard, /quest, /matiere                                                             | `ssr: false` + `loader` appelant `ensureQueryData` avec les mêmes `queryOptions()` que le composant, erreur d'auth avalée pour laisser `_authenticated` rediriger ; `defaultPreload: "intent"`. Gain nul au premier chargement (C1-fe reste bloqué par l'auth, §0)              |
| **bundle-01**                           | 3      | M      | `@dnd-kit` (43 KB bruts / 14 KB gz) dans le graphe de démarrage de tout le monde : React est capturé par le groupe `vendor-dndkit`                                                                   | Migrer `manualChunks` vers `codeSplitting.groups` avec `vendor-react` déclaré en premier (priorité 100) — piège mesuré : `includeDependenciesRecursively: false` refusé par l'env SSR tant que `preserveEntrySignatures` est `strict` ; puis _abaisser_ le plafond `index-`     |
| **bundle-06**                           | 3      | M      | Aucun cache inter-déploiements : 380 KB de runtime vivent dans `index`, dont le hash change à chaque commit — ≈ 100 KB gz retéléchargés par élève et par déploiement                                 | Même migration que bundle-01 (`vendor-react`, `vendor-tanstack`) ; SW : dériver `VERSION` du build ou purger les `/assets/*` absents du manifeste à l'activation (≈ 2 Mo d'orphelins par déploiement aujourd'hui)                                                               |
| **bundle-07**                           | 3      | M      | `vendor-supabase` (209 KB) embarque realtime, phoenix, storage, functions, iceberg (≈ 85 KB bruts / 22 KB gz) au démarrage — seul auth-js est nécessaire hors duel                                   | Composer le client sans `createClient` (`GoTrueClient` + `PostgrestClient`), `RealtimeClient` paresseux dans `use-duel-channel.ts` ; sur le chemin d'auth : garde-fous `auth-middleware.jwks-cache.test.ts` + e2e de session                                                    |
| **rendu-03**                            | 3      | S      | `backdrop-blur-xl` (24 px) sur la barre d'onglets fixe, l'en-tête, la carte de question, les cartes du QG — recalculé à chaque frame, et **invisible** sur le thème par défaut (surfaces opaques)    | Étape pixel-identique : `dark:backdrop-blur-xl` sur toute surface opaque en thème `reference` ; étape 2 (nuance à accepter) : `backdrop-blur-md` en `dark`, aucun filtre sur la carte qui glisse. Coût GPU estimé, à tracer                                                     |
| **db-06**                               | 3      | M      | Ouvrir un exercice = 3 server fns et ~15 requêtes, dont un `getSubject` complet (avec `get_subject_progress`, 40-150 ms de SQL) rejoué pour le seul id de « Suivant »                                | Hisser inventaire, quiz du chapitre et vidéos dans le premier `Promise.all` ; pour « Suivant », un server fn léger (catalogue ordonné, sans progression) ou la donnée déjà en cache `["subject", id]`                                                                           |
| **data-08**                             | 2      | S      | `getChapterLesson` (page publique la plus lue) : 3-4 sauts en série là où 2 suffisent                                                                                                                | Étage 1 `Promise.all([chapter, exercisesByChapter, isUnrestrictedViewer])`, étage 2 `[siblings, siblingsWithLesson, attempts si quizGated]` — même résultat, −10-40 ms de TTFB                                                                                                  |
| **bundle-08**                           | 2      | S      | Aucun préchargement de route à l'intention ; `defaultPreloadStaleTime` est une option morte                                                                                                          | `defaultPreload: "intent"` dans `createRouter` ; `"viewport"` pour la barre d'onglets mobile (≈ 118 KB prélevés) est un choix de consommation de données, à arbitrer                                                                                                            |
| **db-04**                               | 2      | S      | `check_rate_limit` purge la table entière dans 1 % des écritures (`random() < 0.01`) : mesuré 71 ms / 64 097 buffers en Seq Scan avec 60 k lignes périmées, payé par un élève au hasard (p99)        | Migration additive : `cron.schedule('purge-rate-limit-events', '17 * * * *', …)` et ré-émission de `check_rate_limit` sans le bloc `random()` — la RPC redevient déterministe. Partie « purge » de **C-2** ; la porte locale (L-1) reste à part                                 |
| **db-05**                               | 2      | S      | Badges polyglot / math_master : l'agrégat non borné sur tout l'historique (patron H3) est revenu dans `submit_exercise_attempt` via `badges_alive` — 2,2 ms sur 7 ms de soumission à chaud, linéaire | Ré-émission additive avec `IF NOT EXISTS (… student_badges … code = 'polyglot')` autour de chaque bloc (0,02 ms) ; résultat identique, `award_badge_if_new` n'insère déjà rien                                                                                                  |
| **db-07**                               | 2      | S      | `subject_leaderboard_totals` ré-agrégée sur toutes les tentatives toutes les 5 min, activité ou non : 537 ms à 105 k tentatives, linéaire (prod = 270 lignes le 2026-08-19 : constat de cible)       | Wrapper `refresh_subject_leaderboard_if_dirty()` comparant `max(completed_at)` au dernier refresh ; la variante incrémentale par trigger (temps réel) est une décision produit                                                                                                  |
| **ssr-05** (= **H-1**, part mécanique)  | 2      | M      | Démarrage à froid mesuré : ~170 ms d'évaluation de modules + 100-200 ms de première requête, sur un froid total de 0,5-0,8 s ; UptimeRobot (5 min) garde déjà une instance tiède                     | Crons et tuteur en `await import()` (−15-25 ms), `build.minify` SSR avec `keepNames` (−20-30 ms), exclure `vendor-three-*`/`hero-warrior-*`/`styles-*.css` du paquet (−0,5 MB de zip) : **50-80 ms au total, pas plus**. Le reste de H-1 est du non-code (fluid compute / plan) |
| **rendu-06**                            | 1      | S      | Providers racine non mémoïsés + racine re-rendue à chaque navigation : impact **nul aujourd'hui** (mesuré), mais rendu-02 a introduit le premier `memo` du dépôt — le piège est désormais armé       | `useMemo` sur les trois valeurs de contexte, `Route.useRouteContext({ select })` à la racine                                                                                                                                                                                    |
| **rendu-07**                            | 1      | S      | `useAuth()` est un hook par composant : 3 abonnements et 3 parsings de session par écran connecté, N re-rendus par événement auth                                                                    | Un `AuthProvider` sous `QueryClientProvider`, `useAuth` devient un `useContext` à signature identique (14 sites inchangés)                                                                                                                                                      |
| **db-08**                               | 1      | S      | `attempts` porte 9 index B-tree dont 2 strictement redondants (`idx_attempts_user`, `idx_attempts_subject` : 7 % du volume d'index, 2/9 du travail par INSERT)                                       | **Destructif** (DROP INDEX CONCURRENTLY) ⇒ merge séparé (DoD §7), après lecture de `pg_stat_user_indexes.idx_scan` en prod                                                                                                                                                      |

Clos sans lot propre : **db-02** (doublon de data-03, voir le tableau des livrés).

**Reliquats des lots livrés** (ouverts par construction, à ne pas redécouvrir) :
db-03 partie (2) — ré-émettre `submit_exercise_attempt` avec `PERFORM ensure_daily_weekly_goals`
en tête et `'mode'` dans le JSON, puis retirer l'appel TS dans un second merge (4 → 3 étapes
série) ; db-01 — `get_subject_progress` appelle encore `chapter_star_rungs` trois fois par
chapitre ; bundle-02 — le refus `schemas-` est nominal (nom de chunk), un audit des autres
barrels atteignables par le client vaudrait d'être mené ; data-02 — fenêtre 30 s-5 min pour
une donnée modifiée par un _autre_ acteur (parent, admin) — journalisée le 2026-11-03
comme comportement assumé —, et le chunk dashboard à 36,32 / 37,00 kB après la fusion avec
`main` (plafond relevé par l'étude 39 pour la carte du bilan de départ) ; bundle-04 — un module partagé entre `fr` et `en`/`ar` ramènerait `ar`
dans le graphe statique sans rougir le budget (gardé par `catalogues.test.ts` seulement) ;
bundle-03 — `check-overflow.mjs` mesure les SVG arabes en Noto Kufi alors que l'app les rend
en police système ; ssr-01 — confirmer les en-têtes en prod après merge (`curl -sI …/fonts/…`
→ `immutable`) et suivre le CLS des chargements répétés dans le RUM.

### Relu et trouvé sain — ne pas refaire

Condensé des notes d'axe, lignes relues en session le 2026-10-31 (le détail n'a pas survécu
à la session : ce qui suit est ce qu'il faut savoir pour ne pas re-proposer).

- **Couche données.** `useAuth` instancié 3 × par écran mais `getSession()` est une lecture
  localStorage sous `navigator.locks`, zéro réseau sauf jeton à < 90 s ; me-role, me-stats et
  les queries de route partent en parallèle dès que `loading` retombe, aucune cascade. Clés
  dédupliquées (`["dashboard"]` partagée par /dashboard, /parcours, /boutique) ; `checkQuestion`
  = 1 POST par réponse, c'est le retour immédiat (décision produit) ; `useLearningPulse` 1
  RTT/min. Pas de N+1 `for … await` dans les server fns ; le seul `Promise.all(rows.map(rpc))`
  est l'entitlement premium, dormant (M3 latent). H1-media remesuré sur 4 448 exercices :
  payload médian 2,7 KB, p90 6,3 KB, 17,5 % portent du SVG — longue traîne, pas la médiane.
  Écart mineur non classé : `useProfileLocaleSync` POSTe `set_profile_locale` à chaque
  chargement à froid même sans changement.
- **Bundle.** Le HTML SSR émet `modulepreload` pour tout le graphe de démarrage et les chunks
  de la route appariée : pas de cascade au premier écran ; routes auto-découpées (dungeon
  15 KB, panneaux lazy) ; scène 3D gardée `mounted && !isMobile && !reduce` ; `schemas`,
  `bidi`, `quest-labels`, `daily-dashboard` hors démarrage. Composition d'`index` (sourcemap) :
  90 % de runtime (react-dom 171 KB, router 58, sonner 33, query 32, tailwind-merge 27,
  seroval 24), ≈ 60 KB d'applicatif — le « vrai découpage » est bundle-01/06, pas applicatif.
  `vendor-motion` (122 KB) irréductible sans décision produit (importé par 60 chunks dont
  `_public`/`_authenticated`) ; sonner, tailwind-merge, seroval idem. CSS 135 KB / 20 KB gz :
  rien à purger (219 `@supports` = replis color-mix de Tailwind 4). Piège confirmé : retirer
  une règle `manualChunks` fait passer son plafond en « skipped » sans rougir
  (`check-bundle-budget.mjs:218`).
- **Rendu.** Minuteurs (`BossChrono`, `ExamCountdown`) à état local 1 Hz ; pulse, autosave et
  flush d'examen en refs ; seuls polls : matchmaking et duel actif à 3 s (produit). Lecteur :
  H3-fe bien clos, mélange d'options et index mémoïsés, clés stables, aucun `layout`/`layoutId`.
  Tableau de bord sans `Date`/localStorage en boucle de rendu, sections lourdes en `lazy()`.
  Reduced-motion coupe les keyframes infinies, `entrance()` renvoie `initial: false`, confetti
  ne rend rien. Images/CLS : hero `<picture>` lazy dimensionné, poster vidéo en `aspect-video`.
  M3-fe (classement) toujours atténué par `content-visibility` + stagger plafonné.
- **Base.** Chaîne de 222 migrations rejouée (pgTAP 1 575 verts) sur PG16 jetable, synthétique
  à 2 000 élèves / 105 k tentatives — ⚠️ le premier jeu était dégénéré (LATERAL `random()`
  évalué une fois ⇒ toutes les tentatives sur un exercice) et gonflait `get_subject_progress` à
  450 ms ; tout a été re-semé. RLS : C1 bien clos, `($0 = user_id) OR is_admin()` ordonné arme
  bon marché d'abord. `get_user_subject_stats` 2,7 ms, `get_daily_plan` 7,3 ms (L4 confirmé),
  `get_attempt_review` 1,5-2,3 ms, `start_exercise_session` 1,2-1,9 ms, `check_rate_limit` SQL
  0,1-0,3 ms (le coût de C-2 est l'aller-retour, pas la requête), `submit_exercise_attempt`
  7 ms à chaud / 23-32 ms à froid, chaîne `FOR UPDATE` de M1 sans coût mesurable (`award_xp`
  0,44 ms), 3 triggers ligne de `question_attempts` ≈ 0,6 ms/réponse (acceptable, 4
  écrivains ⇒ pas de passage en triggers d'instruction). H2 et M2 : définitions relues
  (`get_dungeon_questions` ré-émise le 2026-09-13 mais même tirage), mesures de 2026-08
  valables. `isRateLimited` a **24** sites d'appel aujourd'hui (l'audit en comptait 8).
- **SSR / infra.** Ordre des gardes de `server.ts` en µs, bot-guard ~66 `includes` + Map IP
  plafonnée à 5 000, `supabaseAdmin`/`supabase` en Proxy paresseux (zéro coût au boot) ;
  `/sitemap.xml` en `s-maxage=3600` (payé par les crawlers) ; `/api/health` `no-store`, sonde
  3 s, UptimeRobot 5 min = maintien tiède gratuit ; `content-encoding: br` sur le HTML SSR
  (/programme 13 KB → 3,7 KB) ; rendu du shell à chaud 5-44 ms selon la route — le coût est
  le réseau et le froid, pas le rendu ; `web-vitals.ts` un événement par vue en `keepalive`,
  `monitoring.ts` no-op sans DSN ; SDK Anthropic importé dynamiquement, `vendor-three` jamais
  évalué côté serveur ; M-2 (`waitUntil`) et L-1 relus, inchangés. Expériences non retenues :
  minification SSR seule (−20-30 ms, intégrée à ssr-05), cache de bytecode V8 (dépend de la
  plateforme). **Hors axe, constaté** (observabilité, pas perf) : `error-capture.ts` s'abonne
  via `globalThis.addEventListener`, `undefined` sous Node — sur Vercel
  `consumeLastCapturedError()` rend toujours `undefined` et la réponse catastrophique
  journalise l'erreur générique.

**Méthode, à retenir pour la prochaine passe.** Trois mécanismes nouveaux valent une règle :
(1) le compilateur TanStack Start ne retire des stubs client que `.validator()`/`.handler()` —
tout schéma zod construit au niveau module embarque zod entier (bundle-02) ; (2) rolldown fusionne
un module partagé entre chunks de locale dans le chunk de la dernière locale, qui revient alors
dans le graphe statique (bundle-04, mesuré avec `meta.ts`) ; (3) depuis PG 12, une CTE
référencée une fois est aplatie, et une fonction STABLE dans le `FILTER` d'un agrégat est
réévaluée par ligne (db-01). Et une règle de passe : **un constat SSR/infra se mesure depuis
le bon PoP** — ce conteneur sort en `iad1` → `arn1`, ses TTFB sont ceux d'un visiteur
américain ; les chiffres « Tunisie » sont des estimations, nommées comme telles.

---

## 0-quater. Ce que l'élève attend — mesure du 2026-11-12 (`main` à #1255)

> Première mesure **en production** des cinq types de page publique depuis que les pages de
> cours, de matière et de niveau sont rendues côté serveur avec leur contenu (#1246, #1251).
> Aucune optimisation n'a précédé ces chiffres. Sonde : `perf/runtime/measure-pages.mjs`
> (Chromium, cache froid, un contexte neuf par chargement, médiane de 3) ; pages :
> `/`, `/niveau/concours-6eme`, `/matiere/math`, un cours et un exercice de cette matière.
> **Production mesurée : `2dd1f8b` (#1255), entre 08:17 et 08:30 UTC.** Depuis ~09:00 UTC ce
> jour-là Vercel refuse tout déploiement (plafond quotidien du plan atteint) : rien de ce qui
> est « livré » plus bas n'est en ligne, et **aucun chiffre « après » n'est pris en
> production dans cette section** — ils sont tous locaux, même méthode avant et après.

**Lire les temps avec leur trajet.** Le conteneur de mesure sort par un proxy et atteint le
PoP `iad1` (États-Unis) ; la fonction tourne à `arn1` (Stockholm). Les **poids**, les
**requêtes** et l'**élément LCP** sont exacts où qu'on soit. Les **millisecondes** portent ce
détour (≈ 100 ms d'aller-retour `iad1`↔`arn1` qu'un élève tunisien, servi par un PoP européen,
ne paie pas en entier) et ne valent que comparées entre elles. Le proxy, de plus, ne
transmet pas les priorités HTTP/2 : les temps de rendu bridés ci-dessous sont un **majorant**
(voir « Ce que la mesure locale corrige »).

### Profil téléphone — 150 ms de RTT, 1,6 Mbit/s, CPU ÷ 4, écran 360×740

| Page     | TTFB (ms) | FCP (ms) |  LCP (ms) | Transféré (Ko) | Requêtes | HTML br / brut (Ko) | JS (Ko) | CSS (Ko) | Polices (Ko) | Élément LCP                                                 |
| -------- | --------: | -------: | --------: | -------------: | -------: | ------------------: | ------: | -------: | -----------: | ----------------------------------------------------------- |
| accueil  |       541 |    2 264 |     2 264 |          434,5 |       37 |          8,8 / 41,5 |   363,2 |     20,7 |         40,5 | `H1`, dans le HTML du serveur                               |
| niveau   |       299 |    1 988 |     1 988 |          612,5 |       40 |          6,8 / 26,8 |   541,7 |     20,7 |         40,7 | `H1`, dans le HTML du serveur                               |
| matière  |       295 |    3 116 | **5 048** |          665,2 |       50 |    **36,0 / 284,8** |   566,9 |     20,8 |         40,5 | `SPAN` de la carte du guide — **posée après l'hydratation** |
| cours    |       452 |    2 624 |     2 624 |          497,7 |       50 |         21,2 / 99,5 |   403,9 |     20,8 |         40,4 | `H1`, dans le HTML du serveur                               |
| exercice |       627 |    2 524 | **4 976** |          487,1 |       58 |          5,3 / 19,5 |   418,0 |     20,7 |         40,5 | `P` du lecteur — **rendu après l'appel client**             |

Le JS « transféré » inclut `gtag.js` (178,7 Ko br, 534 Ko décodés) quand il a fini d'arriver
dans la fenêtre de mesure ; il part après le premier rendu mais dispute le même débit.

### Sans bridage (même trajet) — ce que coûte la page hors débit simulé

| Page     | TTFB (ms) | FCP (ms) | LCP (ms) | Chargement complet (ms) |
| -------- | --------: | -------: | -------: | ----------------------: |
| accueil  |       485 |      836 |      836 |                     883 |
| niveau   |       485 |    1 072 |    1 072 |                   1 091 |
| matière  |       291 |    1 336 |    1 988 |                   1 502 |
| cours    |       381 |      968 |      968 |                   1 043 |
| exercice |       504 |      820 |    1 660 |                     917 |

### Temps serveur — connexion déjà ouverte, 5 passes espacées de 3 s (`curl`, UA navigateur)

`x-vercel-cache: MISS` sur **toutes** les pages, à chaque passe ; `cache-control: public,
max-age=0, must-revalidate`. Chaque visite anonyme exécute la fonction et lit la base.

| Ressource                   | TTFB, 5 passes (ms)         | Médiane | Au-dessus d'un fichier servi par le PoP |
| --------------------------- | --------------------------- | ------: | --------------------------------------: |
| `/favicon.svg` (HIT au PoP) | 50 · 39 · 36 · 34 · 41      |      39 |                                       — |
| accueil                     | 164 · 165 · 167 · 163 · 175 |     165 |                                    +126 |
| exercice                    | 183 · 197 · 190 · 199 · 383 |     197 |                                    +158 |
| niveau                      | 255 · 249 · 234 · 223 · 234 |     234 |                                    +195 |
| cours                       | 276 · 250 · 284 · 256 · 255 |     256 |                                    +217 |
| **matière** (`math`)        | 675 · 708 · 682 · 666 · 708 | **682** |                                **+643** |

Le plancher (+126 ms, accueil : aucune lecture de contenu) est le trajet PoP → `arn1` et un
rendu de shell. Au-dessus du plancher : niveau +69 ms, cours +91 ms, **matière +517 ms**. La
matière rend 285 Ko de HTML (dont le sommaire sérialisé une seconde fois pour l'hydratation)
après quatre vagues de lectures en série (`getSubject` : le lot parallèle, puis
`fetchRecallAvailability`, puis `resolve_subject_parcours`, puis `parcours`).

### Ce que la mesure locale corrige

Le même bundle de production servi en local (`npm run perf:budget`, mêmes 150 ms / 1,6 Mbit/s /
CPU ÷ 4, mais sans proxy : le navigateur ordonne lui-même CSS, polices et scripts) rend
l'accueil en **≈ 1,0 s de LCP** (5 passes : 820-1 032 ms) pour 369,5 Ko transférés. L'écart
avec les 2,0-2,6 s relevés en prod pour un `H1` déjà présent dans le HTML se décompose donc
en TTFB (300-540 ms de poignée de main et de fonction) et en un artefact du proxy de mesure —
**pas** en CSS bloquant ni en polices. Conséquence : inliner le CSS critique (20,7 Ko br, une
seule feuille) rendrait au plus un aller-retour ; ce n'est pas là qu'est le temps, et la
piste est **fermée sans action**. Les polices (40,5 Ko, trois fichiers, deux préchargées,
immuables depuis ssr-01) sont au plancher.

### Constats, par impact — et à qui ils reviennent

| ID         | Constat (mesuré)                                                                                                                                                                                                                                                                                              | Enjeu                                                                                               | Tenu par                                             |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| **rt-01**  | **Matière : LCP 5,0 s** (bridé). L'élément LCP est la carte d'introduction du guide, absente du HTML du serveur et posée après l'hydratation ; elle détrône le titre. Sans JavaScript la même page peint en 1,6-2,0 s                                                                                         | Le plus gros écart du site : 3 s de LCP sur la page d'entrée d'une matière                          | axe SEO (route) + composant guide                    |
| **rt-02**  | **Matière : le sommaire voyage deux fois.** Le HTML le porte (285 Ko, 36,0 br), puis `useQuery` le redemande à l'hydratation (`placeholderData` ne compte pas comme donnée fraîche) : `_serverFn` de **210,2 Ko / 26,8 Ko br**. Idem cours (38,9 / 10,2), niveau (3,5 / 1,5)                                  | +26,8 Ko et un second passage par la fonction (≈ 0,5 s serveur) pour une donnée déjà à l'écran      | axe SEO (`seedOnServer` → `initialData`/hydratation) |
| **rt-03**  | **Exercice : LCP 5,0 s** (bridé). Le HTML (19,5 Ko) ne porte que le shell et le titre ; l'énoncé arrive par un appel client après l'hydratation                                                                                                                                                               | Page la plus nombreuse du sitemap (5 477 URL)                                                       | axe SEO (route `exercice`)                           |
| **rt-04**  | **Temps serveur de la matière : +517 ms** au-dessus du plancher, contre +69 à +91 ms pour niveau et cours. Quatre vagues de lectures en série dans `getSubject`, 285 Ko à rendre et à sérialiser                                                                                                              | TTFB de 682 ms à chaud pour tout visiteur, élève connecté compris (même server fn)                  | ✅ livré, voir « Livré »                             |
| **rt-05**  | **`@dnd-kit` (44 Ko, ≈ 15 Ko br) sur toutes les pages.** Par source map : `vendor-dndkit` contient `react` (7,4 Ko) et un morceau de `react-dom` (3,4 Ko) que le bundler y a hissés ; le chunk d'entrée l'importe donc statiquement, et avec lui tout le glisser-déposer, utile aux seuls plateaux d'exercice | 18,8 Ko br téléchargés et analysés au premier rendu de chaque page                                  | ✅ livré, voir « Livré »                             |
| **rt-06**  | **Socle JS du premier rendu : 305 Ko br** (accueil, local). `index` 136,7 · `vendor-supabase` 55,4 · `vendor-motion` 48,5 · `vendor-radix` 28,7 · `i18n-fr` 23,6 · `vendor-dndkit` 18,8 · `vendor-icons` 10,8. Supabase et motion sont importés statiquement par le chunk d'entrée                            | À 1,6 Mbit/s : 1,5 s de téléchargement avant l'interactivité                                        | à arbitrer — touche l'auth et les animations         |
| **rt-07**  | **`gtag.js` : 178,7 Ko br / 534 Ko décodés**, sur chaque page — plus que le chunk d'entrée                                                                                                                                                                                                                    | Après le premier rendu, mais 0,9 s de débit et du temps de processeur sur un téléphone              | décision produit (mesure d'audience)                 |
| **ssr-04** | **Aucune page publique n'est servie par le CDN** (MISS partout). Enjeu désormais chiffré : 126 à 643 ms de TTFB par visite anonyme, et une lecture de base à chaque fois. **Nouveau bloqueur, absent de l'analyse du 2026-11-03** : un HIT au PoP ne passe plus par `guardRequest` (`bot-guard.ts`)           | Le plus gros gain de TTFB disponible — mais il retire la couche 2 anti-aspiration des pages cachées | **décision du propriétaire**, voir ci-dessous        |

### Livré dans la foulée — chaque gain avec sa mesure, même méthode avant et après

| ID        | Ce qui change                                                                                                                                                                                                                                                                  | Avant → après                                                                                                                                                                                                                                                                                                                     | Méthode                                                                                                                                                           |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **rt-05** | Un groupe `vendor-react` prioritaire (`vite.config.ts`, `codeSplitting`). Un groupe emporte les dépendances de ce qu'il capture : `react`, que personne ne réclamait, partait avec `@dnd-kit`. Une règle de plus dans la fonction ne suffisait pas (essayé : module déjà pris) | Accueil : JS du premier rendu **305,0 → 251,3 Ko br** (−17,6 %), transféré 369,5 → 315,8 Ko, 34 → 33 requêtes. `vendor-dndkit` importé par 69 chunks → **1** ; `vendor-motion` par 93 → **13**, plus par le chunk d'entrée. Entrée 413,80 → 238,2 KB + `vendor-react` 188,68                                                      | `npm run perf:budget`, même commit ; `grep` des imports statiques de `dist/client/assets`                                                                         |
| —         | Moteur de son chargé au premier geste (`src/lib/sound/lazy.ts`) : la synthèse sort de l'entrée, les préférences y restent. Safari exige `resume()` dans le geste : l'écouteur reste posé jusqu'au premier geste où le moteur est déjà là                                       | Entrée 243 967 → 239 717 octets ; chunk `audio` de 4 753 octets, demandé après un geste (vérifié en navigateur sur une page d'exercice). JS du premier rendu 251,3 → 250,3 Ko br                                                                                                                                                  | `ls -l` des chunks ; `perf:budget` ; Chromium sur le bundle de prod                                                                                               |
| **rt-04** | `getSubject` : la disponibilité des Rappels et l'ancre de parcours partent avec les lectures de contenu au lieu de les attendre, puis de s'attendre l'une l'autre                                                                                                              | Rendu serveur de `/matiere/math`, à chaud : **1 070 · 1 132 · 1 126 → 744 · 844 · 637 ms** ; lectures en série 3 → 1. Le rendu React et la sérialisation ne comptent que pour ≈ 20 ms des 285 Ko : tout le temps est dans les lectures — **⚠️ non confirmé en production le 2026-11-13** (TTFB 682 → 728 ms) : voir « Re-mesure » | Bundle de prod en local, catalogue lu en anonyme, `fetch` chronométré (≈ 155 ms de trajet par lecture depuis le conteneur — les rapports valent, pas les valeurs) |

Vérifié en navigateur sur le bundle de production, catalogue réel lu en anonyme : matière,
cours et exercice rendent sans erreur de page avec le nouveau découpage ; matière et cours ne
chargent plus ni `motion` ni `@dnd-kit`, l'exercice les charge (il s'en sert).

**À re-mesurer à la reprise du déploiement**, sans rien changer à la méthode :
`node perf/runtime/measure-pages.mjs --base https://www.na9ranal3ab.tn --page accueil=/ --page niveau=/niveau/concours-6eme --page matiere=/matiere/math --page cours=/chapitre/e602ea95-36fe-5fdd-b6bc-3c71484ff81c --page exercice=/exercice/eb9749ae-771e-5c17-8c92-e4d9d3883622 --runs 3`,
puis les cinq passes `curl` à connexion ouverte du tableau « Temps serveur ». Attendu : JS
transféré −50 Ko br environ sur accueil, niveau, matière et cours ; TTFB de la matière sous
500 ms.

### Ce que les lots ont fait apparaître

| ID        | Constat (mesuré)                                                                                                                                                                                                                                                                                                                                                                                                                                                | Tenu par                                                                                 |
| --------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| **rt-08** | **`get_recall_availability` est désormais le plancher de la page matière** : 613 ms pour `math` contre 316 ms pour la plus lourde des lectures de contenu (115 Ko), soit ≈ 450 ms de base hors trajet. Elle évalue `is_question_recall_eligible(q)` sur chaque question de chaque mission de la matière, à chaque visite, pour une valeur dérivée du contenu                                                                                                    | `supabase/**` — à précalculer à l'application du contenu (compte éligible par mission)   |
| **rt-09** | **Base injoignable = 7 s d'attente avant le premier octet** d'une page publique rendue côté serveur. `postgrest-js` 2.119 rejoue trois fois une panne réseau (1 s, 2 s, 4 s) et `seedOnServer` attend la fin. Vu le jour même où `/programme` est passée au rendu serveur (#1266) : le budget runtime a rougi à 7,8 s de LCP sur cette page, base factice en face                                                                                               | axe SEO (`seedOnServer` : borner l'attente, 1,5 s par exemple, puis rendre le squelette) |
| **rt-10** | `getParcours` (`/programme`) fait trois lectures en série — `parcours`, `grades`, `subjects` — dont aucune ne dépend de la précédente ; `getChapterLesson` lit les missions du chapitre dans une troisième vague alors qu'elles ne dépendent que de `chapterId`. Ce second point n'est **pas** pris : un test du jour pose « une seule lecture autour d'un chapitre absent », et le gain (un aller-retour sur +91 ms) ne vaut pas de défaire un invariant voulu | axe Dette (`dashboard.server.ts`) ; `quest.lesson.server.ts` laissé tel quel             |

### De l'affichage à l'interactivité — ce qui compose l'écart

La session « première visite » relève le même jour, sur un profil comparable (360×780,
CPU ÷ 4, 1,6 Mbit/s) : premier affichage 1,0 à 1,6 s, **interactif 5,2 à 6,4 s**, et un
décalage de mise en page de 0,11-0,12 vers 4 s (en-tête public, relayé à l'axe Accessibilité ;
détail dans `docs/audit-premiere-visite-2026-11-12.md`). Décomposition, mesurée ici sur le
bundle de production en local (accueil, trois passes, après rt-05) :

| Étape                           |     Instant | Ce qui la détermine                                                 |
| ------------------------------- | ----------: | ------------------------------------------------------------------- |
| Premier affichage (FCP)         | 0,76-0,98 s | HTML + feuille de style ; le JS ne le retient pas                   |
| Dernier script reçu             | 2,51-2,86 s | **le débit** : 254 Ko br à 1,6 Mbit/s                               |
| Fin de la dernière tâche longue | 2,76-3,18 s | hydratation : 3 tâches longues, 226-267 ms au total (TBT 76-117 ms) |

L'écart est donc du **téléchargement**, pas du processeur : ≈ 1,7 s de transfert pour ≈ 0,25 s
d'exécution. En production s'y ajoutent ce que la mesure locale n'a pas — `gtag.js`
(178,7 Ko br, soit 0,9 s du même débit, rt-07), le second voyage des données (rt-02) et le
TTFB. Ce qui raccourcit l'attente est donc ce qui retire des octets du premier rendu :
rt-05 (fait, −54 Ko), puis `vendor-supabase` (55,4 Ko br) et `gtag.js`, tous deux à arbitrer
(rt-06, rt-07). Travailler l'hydratation n'y changerait presque rien.

### Re-mesure en production — 2026-11-13, 14:47 UTC (#1262 en ligne)

Le déploiement a repris : la production sert `vendor-react-*.js` (constaté dans le HTML de
`/`), donc #1262. Même sonde, mêmes pages, mêmes profils, même conteneur qu'au 2026-11-12.
**Ce n'est pas un avant/après pur** : `main` est passé de `2dd1f8b` à `acb29a9`, une
cinquantaine de PR des autres axes sont en ligne avec #1262. Les écarts ci-dessous ne sont
attribués à ce lot que là où le mécanisme le désigne sans ambiguïté (quels chunks partent).

**JavaScript du site** (brotli, hors `gtag.js` — dont l'arrivée dans la fenêtre de mesure
varie d'une passe à l'autre et brouillait la colonne « JS » du 2026-11-12), sans bridage,
médiane de 3 :

| Page     | 2026-11-12 | 2026-11-13 |        Écart | `vendor-dndkit` / `vendor-motion` |
| -------- | ---------: | ---------: | -----------: | --------------------------------- |
| accueil  |      363,3 |      305,6 | **−57,7 Ko** | plus téléchargés                  |
| niveau   |      363,0 |      306,6 | **−56,4 Ko** | plus téléchargés                  |
| matière  |      388,4 |      335,6 | **−52,8 Ko** | plus téléchargés                  |
| cours    |      404,1 |      349,9 | **−54,2 Ko** | plus téléchargés                  |
| exercice |      418,0 |      430,4 |     +12,4 Ko | téléchargés (la page s'en sert)   |

**rt-05 est confirmé en production** : −53 à −58 Ko br sur quatre pages sur cinq, l'ordre de
grandeur mesuré en local (−54 Ko). Sur l'exercice, la hausse n'est pas de ce lot : la page
fait désormais un `_serverFn` de 28,2 Ko br (1,4 Ko la veille) et le chunk `audio` y part
**sans geste** — un effet sonore est demandé au montage de la page, `withAudio` le charge
(4,7 Ko) ; sans conséquence audible, mais le différé n'y diffère rien.

**Temps serveur** (`curl`, connexion ouverte, 5 passes espacées de 3 s) :

| Ressource      | 2026-11-12 (médiane) | 2026-11-13, 5 passes (ms)   | Médiane |
| -------------- | -------------------: | --------------------------- | ------: |
| `/favicon.svg` |                   39 | 52 · 45 · 42 · 43 · 38      |      43 |
| accueil        |                  165 | 189 · 169 · 174 · 178 · 175 |     175 |
| exercice       |                  197 | 218 · 209 · 207 · 211 · 236 |     211 |
| niveau         |                  234 | 300 · 236 · 262 · 253 · 260 |     260 |
| cours          |                  256 | 378 · 287 · 313 · 269 · 292 |     292 |
| **matière**    |              **682** | 730 · 730 · 722 · 726 · 738 | **730** |

**rt-04 n'est PAS confirmé en production**, et le gain local annoncé était un artefact de la
mesure. Mis en parallèle, les allers-retours ne coûtaient en local que parce que chaque
lecture y traverse ≈ 155 ms de trajet (conteneur → base). En production la fonction
(`arn1`) est voisine de la base : quatre vagues en série y coûtaient quelques dizaines de
millisecondes, et le temps de la page est celui de la lecture la plus lente —
`get_recall_availability` (rt-08), qui a toujours été là et qui l'est encore. Le code reste
(il ne coûte rien et retire une lecture de `subjects`), mais **son gain mesuré en production
est nul**, et la ligne « Livré » le dit désormais. Leçon de méthode, pour la suite de cet
audit : un parallélisme de lectures se mesure depuis la région de la fonction, ou se mesure
en production — jamais depuis un poste qui ajoute 150 ms à chaque aller-retour.

**Ce qui reste le levier de la page matière : rt-08**, précalculer à l'application du
contenu le compte de questions éligibles au Rappel par mission (`supabase/**`, hors de cet
axe). Ensuite rt-02 (le sommaire re-téléchargé à l'hydratation, 27,1 Ko br, toujours là).

**LCP bridé** (à lire avec l'avertissement de trajet de la section) : matière 5,0 → 3,5 s,
l'élément LCP est désormais le chapeau de la matière, présent dans le HTML du serveur (vérifié par `curl`) — effet de #1281 (« la page matière
commence par ses chapitres », axe première visite) qui résout rt-01, pas de ce lot ; exercice 5,0 → 4,8 s,
toujours posé après l'appel client (rt-03 ouvert).

### ssr-04 — pourquoi ce n'est pas livré, et ce qu'il faut décider

La voie A (CSP par hachage, variantes par cookie) reste la seule permise, et elle tient
techniquement. Mais la mesure a fait apparaître ce que l'analyse du 2026-11-03 n'avait pas
vu : `src/server.ts` appelle `guardRequest` **dans la fonction**. Une page servie par le PoP
n'y entre jamais. Cacher les pages de cours, c'est donc servir leur contenu (62 Ko de leçon
par page) aux robots d'entraînement déclarés et aux aspirateurs en rafale **sans** le refus
403 ni le plafond par IP — c'est-à-dire lever la « couche 2 du plan de protection IP » sur
exactement les pages qu'elle protège. Ce n'est pas un réglage de perf.

Trois issues, à trancher par le propriétaire :

1. **Cacher, et porter le refus des agents déclarés au bord** : la liste `BLOCKED_AI_UA`
   devient des routes `has: header user-agent` → 403 dans `vercel-routes.mjs`, générées
   depuis la même source. Le plafond de rafale par IP, lui, disparaît pour les pages cachées
   (il est en mémoire, par instance, « best-effort » de son propre aveu). Gain : TTFB d'une
   visite anonyme ≈ celui d'un fichier statique (39 ms d'ici, contre 165-682).
2. **Ne cacher que ce qui n'est pas du contenu** : accueil, niveau, `/programme` (sommaires).
   Gain limité au plancher (+126 à +195 ms), aucune leçon exposée hors garde.
3. **Ne rien cacher** et traiter le temps serveur à la source (rt-04 fait, rt-08, rt-02).
   C'est ce que fait cet axe en attendant la décision.

### ssr-04 — tranché le 2026-11-13 : option 2, les sommaires seulement

Décision du propriétaire, journalisée (`docs/journal-decisions.md`, 2026-11-13). Livré :

- **Pages** : `/`, `/programme`, `/programme/lycee/<année>`, `/niveau/<parcours>`. Cours,
  matière et exercice restent rendus à chaque visite, garde anti-aspiration compris.
- **Variantes** : le rendu serveur ne lit que deux cookies, la langue et le thème (relu dans
  le code). Le routage (`scripts/vercel-routes.mjs`) les recopie dans `x-na9ra-locale` et
  `x-na9ra-theme`, la réponse déclare `Vary` sur eux : six variantes au plus, au lieu d'une
  par visiteur (`Vary: Cookie` aurait été inutilisable, les cookies de mesure d'audience
  rendent chaque visiteur unique).
- **Conditions** (`src/shared/lib/public-cache.ts`) : `GET` sans `Authorization`, en-têtes
  du routage égaux aux cookies, réponse 200 en HTML, aucun cookie posé, aucun préchargement
  en échec (marque posée par `seedOnServer`, retirée avant envoi). Sinon : comportement
  d'avant, nonce et `max-age=0`.
- **CSP** : nonce remplacé, sur la seule réponse mise en cache, par les empreintes SHA-256
  des scripts qui portaient le nonce de la requête. Vérifié dans Chromium sur le bundle de
  production : aucune violation hors une injection volontaire, hydratation complète ; témoin
  à empreintes corrompues → les trois scripts du framework refusés, hydratation en échec.
- **Durée** : `Vercel-CDN-Cache-Control: max-age=300, stale-while-revalidate=86400` ; le
  navigateur revalide toujours (`max-age=0`). Un déploiement vide le cache.

**Attendu** (mesure du 2026-11-13, même trajet) : premier octet de l'accueil 175 ms → ≈ 40 ms
sur un HIT, niveau 260 → ≈ 40 ms, pour tout visiteur sans compte comme pour un élève
(l'auth ne passe jamais par le HTML).

**À vérifier dès le déploiement** — non vérifiable avant (plus d'aperçu Vercel pour les
branches d'agents) : que le CDN applique `Vary` aux en-têtes posés par le routage. Méthode :
`curl` deux fois la même page sans cookie (`x-vercel-cache` MISS puis HIT, `html lang="fr"`),
puis avec `Cookie: xp-scholars-locale=ar` (`lang="ar"`, jamais la variante française), puis
avec le thème sombre ; et la page cours, qui doit rester MISS. Une variante qui fuit = retour
arrière immédiat.

### Le garde-fou posé

`npm run perf:budget` (étape de `ci.yml`, après `smoke:shell`) : le bundle de production
servi en local, `/` et `/programme` dans un Chromium bridé, plafonds dans
`perf/runtime/budget.mjs`. Poids et requêtes sont déterministes (trois passes, mêmes
chiffres à l'octet) ; le LCP se lit sur la médiane de cinq chargements contre un plafond au
double du réel. La dette « pas de budget de perf runtime » est soldée
(`docs/dette-technique.md`). Limite écrite dans le budget : sans base, les pages à contenu ne
rendent pas en CI — leurs chiffres sont ceux de cette section, à re-mesurer après chaque lot.

Il a servi le jour de sa pose : rouge sur `/programme` (LCP 7,8 s) dès la fusion de #1266,
ce qui a donné rt-09. Pour que la mesure ne dépende plus de la façon dont une machine échoue
à joindre un hôte inconnu, la base factice répond une erreur HTTP immédiate
(`check-budget.mjs`) : « pas de base » veut dire réponse tout de suite, pas attente.

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
→ **Still open, but the chunk shrank on the OTHER axis (2026-08-26).** The catalog is
no longer monolithic: the parent-only namespaces (`parentReport.*` + `parentDaily.*`)
moved to `src/lib/i18n/parent/`, isolated as the `i18n-parent` chunk and pulled only by
the dynamic imports of `/suivi` and `/parent-report` — **207.65 → 171.17 KB** app-wide,
36.53 KB deferred. The two splits compose (surface × locale): doing H2-fe on top would
divide what is left by three. Measured next-best surface candidate: `ai.*` (~21 KB,
minus the two keys `ForgeEntry` uses on the dashboard). `tutor.*` does **not** qualify —
the dashboard, the quest player and the public chapter reader all mount it, so splitting
it only relocates the bytes. Detail and numbers: `scripts/check-bundle-budget.mjs`.
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
- **C-2** Local-first rate-limit gate + `rate_limit_events` prune/partition. **M** —
  🟠 **réduit 2026-10-31** : les lectures préparatoires de `submitAttempt`/`submitDungeonAnswer`
  partent avec la RPC (`932584d`, §0-ter db-03) ; la purge `random()` est chiffrée (db-04,
  71 ms en Seq Scan, à déplacer sur `pg_cron`) ; la porte locale reste à faire.
- **C1-fe** SSR route loaders (`ensureQueryData`) for the auth→profile→data chain. **M** —
  ⬜ le volet _client_ (loader `ssr: false`, −150-400 ms par navigation SPA) est data-07 au
  backlog §0-ter ; le volet SSR reste bloqué par l'auth (§0).

### Phase 3 — Edge, caching, and the media tier

- **H-3** Edge-cache the public catalogue/landing (cacheable anon variant). **M–L** —
  🟠 **à arbitrer 2026-11-03** (§0-ter ssr-04) : trois bloqueurs nommés (nonce CSP, shell
  cookie-dépendant, clé de cache aveugle aux cookies), trois voies, la seule saine est une CSP
  par hachage avec rendu tamponné — décision d'architecture, pas un patch.
- ✅ **H2-fe done 2026-10-31** (`ac44de0`, §0-ter bundle-04) — `i18n-fr`/`en`/`ar` par
  locale, `fr` seul statique, budgets 64/60/76 KiB ; **M4-fe** was false (§0). **M**
- **§5** Stand up the media architecture: images (sanitizer + CDN), externalize
  SVG, then **audio**, then video (HLS). **L**

### Phase 4 — Resilience & global reach

- **H-1** Provisioned concurrency / warm-keeping; evaluate multi-region or Edge
  runtime vs the Supabase region pin. **L** — **mesuré 2026-11-03** (§0-ter ssr-05) : froid =
  ~170 ms de modules + 100-200 ms de première requête sur 0,5-0,8 s ; les leviers dans le
  dépôt valent 50-80 ms au total, le reste est du non-code (plan / fluid compute).
- **L-1** Move IP burst-limiting to the edge (Cloudflare). **M**

---

## 7. Appendix — finding index

_Status column stamped 2026-08-10 (§0). "?" = not re-verified in that pass._

| ID                                                                                                           | Tier    | Sev  | One-line                                                     | Status                                   |
| ------------------------------------------------------------------------------------------------------------ | ------- | ---- | ------------------------------------------------------------ | ---------------------------------------- |
| C1                                                                                                           | DB      | CRIT | per-row `EXISTS` + un-wrapped `auth.uid()` in `profiles` RLS | ✅ closed                                |
| C-1                                                                                                          | Infra   | CRIT | fresh client + `getClaims` per server fn                     | ❌ retired                               |
| C-2                                                                                                          | Infra   | CRIT | rate-limit DB round-trip before every write                  | 🟠 réduit `932584d` (§0-ter)             |
| C1-fe                                                                                                        | FE      | CRIT | no SSR prefetch — client-side waterfall                      | ⬜ open (volet client = data-07, §0-ter) |
| C2-fe                                                                                                        | FE      | CRIT | 245 KB unoptimized hero JPG, LCP                             | ✅ closed                                |
| H1                                                                                                           | DB      | HIGH | global leaderboard ranks all profiles per call               | ✅ closed                                |
| H2                                                                                                           | DB      | HIGH | dungeon `ORDER BY random()` over full join                   | ⬜ open                                  |
| H3                                                                                                           | DB      | HIGH | unbounded per-user aggregates on write path                  | ✅ closed                                |
| H4                                                                                                           | DB      | HIGH | missing `attempts(user_id, exercise_id)` index               | ✅ closed                                |
| H-1                                                                                                          | Infra   | HIGH | single cold single-region SSR function                       | ⬜ open, mesuré 2026-11-03 (ssr-05)      |
| H-2                                                                                                          | Infra   | HIGH | scaling load relocates to PostgREST/Auth                     | ⬜ open                                  |
| H-3                                                                                                          | Infra   | HIGH | no edge/CDN cache for public catalogue                       | 🟠 à arbitrer (ssr-04, §0-ter)           |
| H2-fe                                                                                                        | FE      | HIGH | all 3 i18n locales bundled eagerly                           | ✅ closed 2026-10-31 (`ac44de0`)         |
| H3-fe                                                                                                        | FE      | HIGH | `renderMarkdown` re-runs DOMPurify per render                | ✅ closed                                |
| H1-media                                                                                                     | Content | HIGH | inline SVG ships on every question fetch                     | ⬜ open                                  |
| H2-media                                                                                                     | Content | HIGH | `getChapterLesson` over-fetches sibling markdown             | ✅ closed                                |
| M1-fe                                                                                                        | FE      | MED  | vendor chunks with no bundle budget                          | ✅ closed                                |
| M4                                                                                                           | DB      | MED  | `getDashboard` aggregates a full attempt history in JS       | ✅ closed                                |
| **N1**                                                                                                       | Tooling | HIGH | `npm ci` fails on Node 22 — lock needs npm ≥ 11              | ✅ closed (#718)                         |
| **N2**                                                                                                       | Quality | MED  | false "generated" header on `auth-middleware.ts`             | ✅ closed                                |
| **N3**                                                                                                       | CI      | MED  | current `main` has no `ci.yml` run                           | ⬜ open                                  |
| M1–M3, M5 (DB), M-2–M-3 (Infra), M2–M3-fe                                                                    | mixed   | MED  | see §3 — all swept 2026-08-10, table in §0                   | ⬜ open                                  |
| L-\*                                                                                                         | mixed   | LOW  | see §3 — L1/L4/L-1 swept 2026-08-10, table in §0             | ⬜ open                                  |
| **db-01, data-01, rendu-01, bundle-02, db-03 (1), rendu-02, data-02, bundle-04, data-03, bundle-03, ssr-01** | mixed   | —    | passe du 2026-10-31, §0-ter — un commit et une mesure chacun | ✅ livrés (11)                           |
| **ssr-02**                                                                                                   | Infra   | —    | `supportsResponseStreaming` absent ⇒ SSE tamponné            | ❌ réfuté (§0-ter)                       |
| **ssr-04, bundle-05, rendu-04, rendu-05**                                                                    | mixed   | —    | décisions produit / architecture, question posée en §0-ter   | 🟠 à arbitrer                            |
| **data-04…08, bundle-01/06/07/08, rendu-03/06/07, db-04…08, ssr-05**                                         | mixed   | —    | backlog §0-ter, non relus par un sceptique                   | ⬜ ouverts                               |
| **db-02**                                                                                                    | DB      | —    | même constat que data-03                                     | ✅ clos (doublon)                        |

_No application code was modified by the audit. Remediations ship as separate,
reviewable changes per the roadmap._
