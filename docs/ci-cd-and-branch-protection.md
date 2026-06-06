# CI/CD & branch protection

This repo auto-deploys: **pushing to `main` deploys to Vercel production.** Therefore
`main` must only ever receive code that passed CI and whose DB migrations are already
applied. The guardrails below enforce that. (Background: CLAUDE.md §7.)

## Required status checks

| Check                | Workflow / job                                                    | What it guarantees                                                                                                                                                                 |
| -------------------- | ----------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `verify`             | `.github/workflows/ci.yml` → job `verify`                         | lint + typecheck + tests&nbsp;+ coverage + build + bundle budget + runtime dep audit all pass                                                                                      |
| `Migration presence` | `.github/workflows/migration-gate.yml` → job `migration-presence` | a PR that adds a `supabase/migrations/*.sql` carries the `migration-applied` label (human ack the migration was applied to prod **before** merge)                                  |
| `pgTAP suite`        | `.github/workflows/db-tests.yml` → job `pgTAP suite`              | the real migrations apply against a Supabase-local Postgres and the DB invariants hold (economy-RPC grants locked down, role-escalation blocked, RLS isolation, scoring/anti-rush) |
| `e2e`                | `.github/workflows/e2e.yml` → job `e2e`                           | the public Playwright journeys (landing + logged-out auth redirects) pass — no backend required, runs on every PR                                                                  |

> **Check names are the values GitHub actually reports** (verified via the checks API), which
> may differ from the lowercase job key — e.g. the job `migration-presence` surfaces as the
> check **`Migration presence`**. The ruleset's `required_status_checks[].context` values must
> match these reported names exactly; they only appear in the settings picker once each
> workflow has run at least once.

> **Authenticated E2E** (`e2e-auth.yml`) is **not** a PR gate: it runs on `main`/manually and
> **skips green** until the four `TEST_SUPABASE_*` / `E2E_USER_PASSWORD` repo secrets are set
> (it targets a dedicated TEST Supabase project, never prod). See "Authenticated E2E" below.
> The Playwright suite (config, `e2e/**`, the `e2e*.yml` workflows, `scripts/e2e/**`) is owned
> by the E2E test track — see `e2e/README.md`.

## Enabling protection on `main`

Branch protection is a repository **setting** (not code), so it must be turned on once in
GitHub. Two equivalent options:

### Option A — import the ruleset (fastest)

GitHub → **Settings → Rules → Rulesets → New ruleset → Import a ruleset** → upload
[`.github/rulesets/main-protection.json`](../.github/rulesets/main-protection.json) → **Create**.

It encodes:

- **Require a pull request** before merging to `main` (no direct pushes).
- **Require status checks**: `verify`, `Migration presence`, `pgTAP suite`, `e2e`, with
  _strict_ mode (the PR branch must be up to date with `main` before merge).
- **Block force-pushes** (`non_fast_forward`) and **block branch deletion**.
- **Dismiss stale approvals** on new pushes.
- **No bypass actors** — the rules apply to **administrators too** (the whole point: even an
  admin can't merge red code straight to prod).

> After importing, confirm the four check names resolve in the picker (run each workflow once
> if not). If GitHub shows a check prefixed (e.g. `CI / verify`), update the matching
> `required_status_checks[].context` to that exact string.

### Option B — classic branch protection (manual)

Settings → Branches → Add rule for `main`: ✅ Require a pull request before merging ·
✅ Require status checks to pass (`verify`, `Migration presence`, `pgTAP suite`, `e2e`) ·
✅ Require branches to be up to date · ✅ Do not allow bypassing the above settings (include
administrators) · ✅ Block force pushes · ✅ Restrict deletions.

### Notes

- **Required approvals = 0.** With a solo maintainer you can't approve your own PR, so the
  ruleset requires the _PR + green checks_ flow without a human approval. Raise
  `required_approving_review_count` to `1` once a second maintainer joins.
- **Emergency bypass.** If you ever need a break-glass path, add an entry to `bypass_actors`
  (e.g. the Repository **admin** role with `bypass_mode: "pull_request"`), rather than
  disabling the ruleset. Prefer fixing CI over bypassing.
- **Merge method.** We squash-merge; you can also pin this under Settings → General →
  Pull Requests (allow squash only) so history stays linear.

## The deploy-ordering workflow (how a migration PR flows)

1. Open the PR. If it adds `supabase/migrations/*.sql`, the `Migration presence` check
   **fails** until acked.
2. Apply the migration to the **production** Supabase DB (SQL editor or `supabase db push`).
3. Add the **`migration-applied`** label → the check re-runs and goes green.
4. Merge → Vercel deploys code against a schema that already supports it. No more
   "code deployed before its migration" incidents.

## Authenticated E2E (remaining human action)

The public `e2e` check is reliable and gates every PR. To also enable the **authenticated**
journeys (free / premium / admin / parent), configure these repository secrets — they point
at the **dedicated TEST** Supabase project, never production:

- `TEST_SUPABASE_URL`
- `TEST_SUPABASE_ANON_KEY`
- `TEST_SUPABASE_SERVICE_ROLE_KEY`
- `E2E_USER_PASSWORD`

Until they are set, `e2e-auth.yml` skips green (it never blocks). Full details and the
anti-prod guard are documented in `e2e/README.md`.

_Observability (health endpoint + Sentry + uptime monitor) remains tracked for the next
quality-sprint wave. The DB-integration test job is already live — it is the `pgTAP suite`
check above._
