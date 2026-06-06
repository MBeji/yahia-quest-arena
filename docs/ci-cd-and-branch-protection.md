# CI/CD & branch protection

This repo auto-deploys: **pushing to `main` deploys to Vercel production.** Therefore
`main` must only ever receive code that passed CI and whose DB migrations are already
applied. The guardrails below enforce that. (Background: CLAUDE.md §7.)

## Required status checks

| Check                | Workflow / job                                                    | What it guarantees                                                                                                                                |
| -------------------- | ----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `verify`             | `.github/workflows/ci.yml` → job `verify`                         | lint + typecheck + tests&nbsp;+ coverage + build + bundle budget + runtime dep audit all pass                                                     |
| `migration-presence` | `.github/workflows/migration-gate.yml` → job `migration-presence` | a PR that adds a `supabase/migrations/*.sql` carries the `migration-applied` label (human ack the migration was applied to prod **before** merge) |

> **`e2e` is intentionally NOT required yet.** The `e2e.yml` / `e2e-auth.yml` Playwright
> workflows are currently unreliable in CI (the Playwright `webServer` boots `npm run dev`
> and waits on `http://localhost:8080`; that readiness step times out at 120s). Making a
> flaky check required trains everyone to ignore CI. Keep e2e as an **informational**
> (non-blocking) check until it is made deterministic — see "E2E follow-up" below — then
> add its job to the required list.

## Enabling protection on `main`

Branch protection is a repository **setting** (not code), so it must be turned on once in
GitHub. Two equivalent options:

### Option A — import the ruleset (fastest)

GitHub → **Settings → Rules → Rulesets → New ruleset → Import a ruleset** → upload
[`.github/rulesets/main-protection.json`](../.github/rulesets/main-protection.json) → **Create**.

It encodes:

- **Require a pull request** before merging to `main` (no direct pushes).
- **Require status checks**: `verify` + `migration-presence`, with _strict_ mode
  (the PR branch must be up to date with `main` before merge).
- **Block force-pushes** (`non_fast_forward`) and **block branch deletion**.
- **Dismiss stale approvals** on new pushes.
- **No bypass actors** — the rules apply to **administrators too** (the whole point: even an
  admin can't merge red code straight to prod).

> After importing, confirm the two check names match exactly. A GitHub Actions check's
> context is its **job name** (`verify`, `migration-presence`). If GitHub shows them prefixed
> (e.g. `CI / verify`), update the ruleset's `required_status_checks[].context` to match —
> the names only resolve in the picker once each workflow has run at least once.

### Option B — classic branch protection (manual)

Settings → Branches → Add rule for `main`: ✅ Require a pull request before merging ·
✅ Require status checks to pass (`verify`, `migration-presence`) · ✅ Require branches to be
up to date · ✅ Do not allow bypassing the above settings (include administrators) ·
✅ Block force pushes · ✅ Restrict deletions.

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

1. Open the PR. If it adds `supabase/migrations/*.sql`, the `migration-presence` check
   **fails** until acked.
2. Apply the migration to the **production** Supabase DB (SQL editor or `supabase db push`).
3. Add the **`migration-applied`** label → the check re-runs and goes green.
4. Merge → Vercel deploys code against a schema that already supports it. No more
   "code deployed before its migration" incidents.

## E2E follow-up (tracked)

Make the Playwright `webServer` deterministic so `e2e` can become a required check:

- Bind the dev server to an explicit IPv4 host/port, or serve a production build instead of
  `npm run dev`, so the readiness probe (`http://localhost:8080`) is reliable across runners.
- Confirm the public landing page renders under dummy Supabase env (it must not require a
  real backend).
- Once green on three consecutive runs, add `e2e` (public) to the required-checks list.

_Observability (health endpoint + Sentry + uptime monitor) and a DB-integration test job
are tracked separately in the quality sprint._
