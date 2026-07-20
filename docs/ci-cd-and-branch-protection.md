# CI/CD & branch protection

This repo auto-deploys: **pushing to `main` deploys to Vercel production.** Therefore
`main` must only ever receive code that passed CI and whose DB migrations are already
applied. The guardrails below enforce that. (Background: AGENTS.md §7; the full
end-of-dev → production walkthrough lives in [passation.md](./passation.md).)

## Merge automation (push → PR → checks → merge — zéro geste humain)

- **`auto-pr.yml`** — pushing any non-`main` branch auto-opens its PR **ready with
  auto-merge armed** (squash + delete branch): it merges alone once the ruleset's
  required checks are green on an up-to-date head. Nobody marks ready, nobody merges
  by hand (décision 2026-07-12 — AGENTS.md DoD §8: the session that pushed watches
  its checks until the merge lands). Deliberate WIP opts out: `[wip]` / `[draft]` /
  `[no-automerge]` in the head-commit subject, or a `wip/` / `draft/` / `rescue/`
  branch prefix, opens a **draft** instead (promote with `gh pr ready`). A repeat
  push re-arms a ready-but-unarmed PR (self-healing) but never promotes an existing
  draft. Without `GH_AUTOMATION_PAT`, the workflow also dispatches the required-check
  workflows on the branch (a PR created with the Actions token fires no
  `pull_request` events, so its checks would otherwise never report).
- **`automerge.yml`** — (re)arms GitHub native auto-merge on every ready, same-repo
  PR; the `no-automerge` label opts out (and disarms). Its `keep-up-to-date` job
  runs on every push to `main` and updates armed PRs left behind (the ruleset's strict
  mode only merges an up-to-date head, and GitHub never updates a branch by itself),
  re-dispatching their checks when no PAT is configured. **"Behind" is decided by the
  compare API (`behind_by`), never by `mergeStateStatus`** — that field is recomputed
  lazily after a push to `main` and reads stale/UNKNOWN in the very seconds the job
  runs, which stranded armed PRs before 2026-07-12. If update-branch fails (merge
  conflict), the PR is labelled **`needs-rebase`**: the next working session rebases
  it (AGENTS.md DoD §8) — never Mohamed.
- **`MERGE_FREEZE`** (repository **variable**) — the kill-switch for this whole chain. Set to
  `1`, every pushed branch opens as a **draft**, nothing arms, armed PRs get disarmed and
  `keep-up-to-date` stops advancing them: no merge can reach `main`, so no deploy can undo a
  production rollback. `hotfix/` and `revert/` branches are **exempt** (the fix that ends an
  incident must still ship — through the same required checks as ever). Set/cleared by
  `rollback-prod.yml` (modes `freeze-only` / `unfreeze`) or by hand
  (`gh variable set MERGE_FREEZE --body 1|0`). Why it exists and when to use it:
  [prod-rollback-runbook.md](./prod-rollback-runbook.md).
- Repo-settings prerequisites (one-time, all in place): "Allow GitHub Actions to create
  and approve pull requests" (Settings → Actions → General), "Allow auto-merge"
  (Settings → General), and the `GH_AUTOMATION_PAT` secret (since 2026-07-06 — see
  [passation.md](./passation.md), « Le piège du bot non-collaborateur »). For the freeze,
  that PAT also needs the repository **Variables: read and write** permission.

## Required status checks

| Check                | Workflow / job                                                    | What it guarantees                                                                                                                                                                                  |
| -------------------- | ----------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `verify`             | `.github/workflows/ci.yml` → job `verify`                         | lint + typecheck + tests&nbsp;+ coverage + content gate (`content:check` + `content:qa:strict`) + perf-harness sync + build + bundle budget + prod-shell browser smoke + runtime dep audit all pass |
| `Migration presence` | `.github/workflows/migration-gate.yml` → job `migration-presence` | informational: surfaces which `supabase/migrations/*.sql` a PR adds — they **auto-apply** to prod on merge via `db-migrate-prod.yml`. Always green                                                  |
| `Migration order`    | `.github/workflows/migration-gate.yml` → job `migration-order`    | **blocking**: rejects a migration whose timestamp sorts at/before one already on `main` — a back-dated file silently jams `db-migrate-prod` and leaves prod behind code (#97 → #227 → #229)         |
| `CodeQL`             | `.github/workflows/codeql.yml` → job `analyze` (name `CodeQL`)    | static security analysis (SAST, `security-extended` suite) of the JS/TS codebase — the code-level complement to `audit:deps` (packages) and pgTAP (SQL grants/RLS)                                  |

> **Check names are the values GitHub actually reports** (verified via the checks API), which
> may differ from the lowercase job key — e.g. the job `migration-presence` surfaces as the
> check **`Migration presence`**. The ruleset's `required_status_checks[].context` values must
> match these reported names exactly; they only appear in the settings picker once each
> workflow has run at least once.

> **pgTAP and Playwright E2E are not PR gates.** Both are slow suites: they run in the
> nightly build (`nightly.yml`), on demand, and inside the upgrade guard's own gate.
> The `pgTAP suite` check still proves every migration applies cleanly on a fresh DB
> before it can reach prod (nightly + upgrade-guard), just not per-PR.

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
- **Require status checks**: `verify`, `Migration presence`, `Migration order`, `CodeQL`,
  with _strict_ mode (the PR branch must be up to date with `main` before merge).
- **Block force-pushes** (`non_fast_forward`) and **block branch deletion**.
- **Dismiss stale approvals** on new pushes.
- **No bypass actors** — the rules apply to **administrators too** (the whole point: even an
  admin can't merge red code straight to prod).

> After importing, confirm the four check names resolve in the picker (run each workflow once
> if not). If GitHub shows a check prefixed (e.g. `CI / verify`), update the matching
> `required_status_checks[].context` to that exact string. Re-import (or hand-edit the
> existing ruleset) after ANY change to the JSON — the file is the versioned intent, the
> imported ruleset is the enforcement.

### Option B — classic branch protection (manual)

Settings → Branches → Add rule for `main`: ✅ Require a pull request before merging ·
✅ Require status checks to pass (`verify`, `Migration presence`, `Migration order`,
`CodeQL`) · ✅ Require branches to be up to date · ✅ Do not allow bypassing the above
settings (include administrators) · ✅ Block force pushes · ✅ Restrict deletions.

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

Prod migrations **auto-apply** on merge — nobody runs SQL by hand (AGENTS.md §7).

1. Open the PR. The `Migration presence` check lists any `supabase/migrations/*.sql`
   it adds (informational, always green); the `pgTAP suite` check proves they apply
   cleanly on a fresh DB.
2. Merge → `db-migrate-prod.yml` takes a pre-apply `pg_dump` backup of prod, then
   `supabase db push` applies the new migration(s) to production (prod-ref guard,
   reuses `PROD_SUPABASE_DB_URL`). Vercel deploys the code in parallel.
3. Additive migrations are safe ahead of their code, so this order holds. Ship a
   **destructive** migration (DROP/REVOKE) in a separate merge **after** the
   dependent code is gone.
4. Manual control when needed: `gh workflow run db-migrate-prod.yml` (or the Actions
   tab) with mode `push` / read-only `list` / one-time `repair-all`.

## When the chain ships something broken (rollback)

The same automation that makes shipping free makes an outage self-perpetuating: a rollback
performed on Vercel is undone by the next PR that merges itself. So the recovery path is
**freeze first, then roll back** — both driven by `rollback-prod.yml`, with the full decision
tree, the database caveat and the drill in
[prod-rollback-runbook.md](./prod-rollback-runbook.md).

- **`checkpoint-tag.yml`** — every Monday 06:00 UTC, tags the newest commit on `main` that has
  BOTH a green `verify` and a green nightly (E2E + pgTAP) **on that exact commit**, as
  `checkpoint/YYYY-Www`. The tip of `main` only ever proves `verify`; the suites that catch a
  dead browser or an unappliable migration run at night. No qualifying commit ⇒ **no tag** and a
  `checkpoint-missing` issue. Selection logic: `scripts/release/pick-checkpoint.mjs` (unit-tested).
- **`rollback-prod.yml`** — manual dispatch, modes `rollback` / `freeze-only` / `unfreeze`. Sets
  `MERGE_FREEZE`, disarms armed PRs, re-promotes the previous (or a named) Vercel production
  deployment, re-checks that prod answers, and opens a `prod-incident` issue carrying the rest
  of the checklist. Needs `VERCEL_TOKEN` / `VERCEL_PROJECT_ID` / `VERCEL_ORG_ID`; without them
  it fails with the dashboard instructions rather than half-acting.

> **Rolling the code back never rolls the schema back.** Migrations are forward-only and
> `db-migrate-prod.yml` has already applied them. Additive ones are safe under older code by
> construction (that's why DoD §7 orders them that way); a destructive one needs the
> pre-migration dump artifact. Runbook, § « L'axe base de données ».

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

_Observability (health endpoint + Sentry + uptime monitor) remains the largest hole in the
recovery loop: with none of them, an outage is discovered by a human opening the site, and that
detection delay dominates the RTO (see the rollback runbook, § « Détection — le trou connu »).
It remains tracked for the next
quality-sprint wave. The DB-integration test job is already live — it is the `pgTAP suite`
check above._
