# Database integration tests (pgTAP)

These are **executable** integration tests that run the real Supabase migrations
against a real Postgres and assert the SECURITY DEFINER / RLS / economy
invariants hold **as an actual `authenticated` user** — not against a mock. They
are the safety net that was missing when the `award_xp` GRANT regression
(browser-callable economy mint) shipped undetected: every existing unit test
mocks Supabase, so the SQL had zero executable coverage.

They use [pgTAP](https://pgtap.org/) and run via the Supabase CLI's
`supabase test db`, which:

1. starts the local stack (Docker) and applies **all** of
   `supabase/migrations/*.sql` in order — exactly as prod is built, with the real
   `auth` schema, `auth.uid()`/`auth.jwt()`, and the `anon` / `authenticated` /
   `service_role` roles, and
2. runs every `supabase/tests/*.sql` file, failing on any failing assertion.

> These files live in `supabase/tests/`, **not** `supabase/migrations/`, on
> purpose: the migration-gate CI job only triggers on new files under
> `migrations/`, and these are tests, not schema changes.

## Run locally

Prereqs: Docker running + the Supabase CLI
([install](https://supabase.com/docs/guides/cli)).

```bash
# from the repo root
supabase start          # boots the local stack + applies all migrations
supabase test db        # runs every supabase/tests/*.test.sql, reports TAP
```

`supabase test db` re-applies migrations into a fresh test database on each run,
so the tests are deterministic and independent of any seed content. Each test
file is wrapped in its own `BEGIN … ROLLBACK`, and all fixtures (auth users,
profiles, content rows) are created **inside** that transaction, so nothing
persists between files or runs.

To iterate on a single file you can also pipe it straight into the running DB:

```bash
psql "$(supabase status -o env | grep DB_URL | cut -d= -f2-)" -f supabase/tests/01_economy_grants.test.sql
```

## What is covered

| File                                 | Invariant                                                                                                                                                                                           | Maps to                           |
| ------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `01_economy_grants.test.sql`         | `award_xp` / `award_coins` are **not** EXECUTE-grantable by `authenticated` (catalogue + live permission-denied); `spend_coins` **is** still callable                                               | **S1** (the grant regression net) |
| `02_role_escalation.test.sql`        | direct `UPDATE profiles SET role=…` is rejected; `set_profile_role` allows only `student`/`parent` (else `Invalid role`); a default-role INSERT (signup) is allowed                                 | **S2(a)**                         |
| `02_role_escalation.test.sql`        | `get_subject_leaderboard` result shape has **no** `user_id` column and still has `is_me`                                                                                                            | **S2(b)**                         |
| `03_rls_isolation.test.sql`          | user A cannot SELECT/UPDATE user B's `attempts` under `SET ROLE authenticated`                                                                                                                      | **RLS**                           |
| `04_scoring_submit_attempt.test.sql` | correct+unrushed attempt awards score-proportional XP + full coins; too-fast attempt earns zero (anti-rush); `<60%` fail schedules spaced-repetition; an armed retry shield suppresses that penalty | **scoring**                       |

## Conventions / gotchas when adding tests

- Set `request.jwt.claims` **before** `SET LOCAL ROLE authenticated` — only a
  superuser may set that GUC, and `SET LOCAL` persists across the role switch
  within the transaction. `auth.uid()` reads `request.jwt.claims->>'sub'`.
- Create fixtures (auth users, content) as the default superuser test role; flip
  to `authenticated` only for the assertions that must run under RLS / grants.
- An RPC that mutates state (e.g. `submit_exercise_attempt` completes the
  session) can only be called once — stash its result in a namespaced GUC
  (`test.*`) if you need to assert on multiple fields.
