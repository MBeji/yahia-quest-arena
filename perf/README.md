# Performance & load-test harness

Reproducible load tests for **yahia-quest-arena (XP Scholars)**, built to answer
one question: _does the stack hold up at thousands of users with a fully-populated
catalogue?_ The scenarios target the Supabase **PostgREST/RPC** surface directly —
the same RPCs the SSR server functions call — so a red run points at the database
tier (RLS, indexes, RPC cost), not at Vercel cold starts.

The companion findings + roadmap live in [`docs/performance-audit.md`](../docs/performance-audit.md).

> ⚠️ **Never run against production.** These scenarios issue real writes (attempts,
> XP, sessions). Use a **dedicated load-test Supabase project**. Both the k6 config
> and the seed scripts refuse the known prod ref as a safety net.

## Prerequisites

- [k6](https://grafana.com/docs/k6/latest/set-up/install-k6/) (`brew install k6` / `apt install k6`).
- A throwaway Supabase project with all migrations + content applied
  (`supabase db push` + `npm run content:build` → push).
- Node 22 (for the seed scripts).

## 1. Seed scale + identities

```bash
# (a) Simulate a busy platform so the leaderboard / history aggregates have real
#     work to do (audit H1/H3/M4). Run in the SQL editor or via psql.
psql "$LOADTEST_DB_URL" -f scripts/perf/synthetic-scale.sql

# (b) Mint VU access tokens (real auth users that submit attempts during the run).
SUPABASE_URL=https://<loadtest-ref>.supabase.co \
SUPABASE_SERVICE_ROLE_KEY=<service-role> \
SUPABASE_PUBLISHABLE_KEY=<anon> \
LOAD_USER_COUNT=50 \
node scripts/perf/mint-load-tokens.mjs > /tmp/load-tokens.env
```

Grab a few real `exercise`/`subject` ids from the test DB for the write/dungeon
scenarios (e.g. `select id from exercises limit 20;`,
`select id from subjects limit 20;`).

## 2. Configure the run

```bash
export LOAD_SUPABASE_URL=https://<loadtest-ref>.supabase.co
export LOAD_SUPABASE_ANON_KEY=<anon-key>
export LOAD_USER_JWTS=$(grep LOAD_USER_JWTS /tmp/load-tokens.env | cut -d= -f2-)
export LOAD_EXERCISE_IDS=<uuid1>,<uuid2>,...     # for gameplay.js
export LOAD_SUBJECT_IDS=<uuid1>,<uuid2>,...      # for leaderboard.js (subject board)
```

## 3. Run

```bash
# STAGE selects the load profile: smoke | load | stress | soak | spike
STAGE=smoke  k6 run perf/k6/leaderboard.js     # wiring check (1 VU / 30s)
STAGE=load   k6 run perf/k6/leaderboard.js     # steady-state (→200 VUs)
STAGE=stress k6 run perf/k6/gameplay.js        # find the knee (→1000 VUs)
STAGE=soak   k6 run perf/k6/gameplay.js        # leak/bloat (150 VUs / 30m)
STAGE=spike  k6 run perf/k6/dungeon.js         # launch surge (0→800 in 30s)
```

## Scenarios → what they stress (and which audit finding)

| Script           | Hot path                                                                                                              | Audit finding                                                                                               |
| ---------------- | --------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| `leaderboard.js` | `get_global_leaderboard` (RANK() over all profiles), `get_subject_leaderboard` (materialized)                         | **H1** — global board is the #1 read hotspot at user scale                                                  |
| `gameplay.js`    | `start_exercise_session` → `check_rate_limit` → `submit_exercise_attempt`                                             | **C-2** (two-round-trip write), **H3** (per-user COUNT/MAX on the write path), **M1** (profile lock window) |
| `dungeon.js`     | `get_dungeon_access` (unbounded COUNT DISTINCT) → `start_dungeon_run` → `get_dungeon_questions` (`ORDER BY random()`) | **H2** (random() over full catalogue), **M2** (access aggregates)                                           |

## Reading the results

- **Thresholds fail the run** (`perf/k6/lib/stages.js`): per-RPC p95 SLOs +
  `http_req_failed < 1%`. A green smoke but red load/stress = a scale cliff.
- Compare `get_global_leaderboard` p95 across two `synthetic-scale.sql` sizes
  (e.g. 2k vs 20k profiles): super-linear growth confirms **H1** and justifies
  materializing the global board.
- During `soak`, watch `rate_limit_events` row count + dead-tuple bloat on the
  load-test DB (`select count(*) from rate_limit_events;`) — this is the **C-2**
  table-bloat canary.
- Capture `EXPLAIN (ANALYZE, BUFFERS)` on the slow RPCs (`scripts/perf/explain.sql`
  if added) to confirm the planner is using `idx_profiles_role_xp` etc.

## Budget runtime — ce qu'une page fait attendre à un téléphone

Le reste de ce dossier charge la **base**. `perf/runtime/` mesure l'autre bout : ce qu'une
page publique fait télécharger et attendre à un téléphone bridé.

| Fichier                     | Rôle                                                                                                                                                                                 |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `runtime/measure-pages.mjs` | La sonde : TTFB, FCP, LCP (et son élément), octets transférés, requêtes, HTML/JS/CSS/polices — médiane de N chargements à cache froid, profil « slow 4G » + CPU ÷ 4                  |
| `runtime/check-budget.mjs`  | Le gate (`npm run perf:budget`) : sert `dist/` en local (SSR + brotli), mesure `/` et `/programme`, échoue au-delà des plafonds. Hermétique : aucun secret, aucun tiers, pas de base |
| `runtime/budget.mjs`        | Les plafonds, leur mesure d'origine, et la règle (on ne relève pas : on sort du premier rendu)                                                                                       |

```bash
npm run perf:budget                  # construit dist/ (env factice) puis mesure
npm run perf:budget -- --no-build    # dist/ déjà construit

# Mesurer la PRODUCTION (lecture seule, peu de pages, peu de passes — c'est un site réel) :
node perf/runtime/measure-pages.mjs --base https://www.na9ranal3ab.tn \
  --page accueil=/ --page cours=/chapitre/<id> --runs 3 [--detail] [--no-throttle]
```

`PERF_CHROMIUM_PATH=/opt/pw-browsers/chromium` dans un conteneur cloud dont le Chromium ne
correspond pas au Playwright du dépôt. **Lire les temps avec leur trajet** : depuis un
conteneur, la sonde traverse un proxy sortant et un PoP américain — les **poids**, les
**requêtes** et l'**élément LCP** sont fiables partout, les **millisecondes** ne se comparent
qu'entre deux mesures prises du même endroit.

## CI integration

The harness is wired into the automated suites at three levels:

| Where                                           | What runs                                                                                                                                                      | Needs secrets?  |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| **Every PR** (`ci.yml` → `npm run perf:check`)  | `scripts/perf/check-harness.mjs`: every scenario parses + harness constants still mirror the product hot paths (`LEADERBOARD_LIMIT`, submit rate-limit budget) | No              |
| **Every PR** (`ci.yml` → `npm run perf:budget`) | `perf/runtime/check-budget.mjs`: the production bundle in a throttled Chromium, against the runtime budgets (requests, transferred bytes, JS, LCP)             | No              |
| **Nightly** (`nightly.yml` → `perf.yml`)        | `validate` (`k6 inspect` every scenario) + `load` at `STAGE=smoke` against the load-test project; rolled into the nightly tracking issue                       | `load` job only |
| **On demand** (`perf.yml` workflow_dispatch)    | Pick any `STAGE` (smoke→spike) for a real campaign                                                                                                             | `load` job only |

The `load` job **skips gracefully (green)** when the `LOAD_SUPABASE_*` secrets are
absent, so it never blocks contributors. k6's thresholds fail the job on a
regression. The heavier stages (`stress`/`soak`/`spike`) are operator-run before a
launch or a content-scale milestone via the dispatch button, not on every PR.

**Required `load`-job secrets** (a THROWAWAY project — never prod):
`LOAD_SUPABASE_URL`, `LOAD_SUPABASE_ANON_KEY`, `LOAD_SUPABASE_SERVICE_ROLE_KEY`,
and optionally `LOAD_EXERCISE_IDS` / `LOAD_SUBJECT_IDS`.
