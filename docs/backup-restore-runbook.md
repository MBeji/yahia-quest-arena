# Backup & restore runbook

> Why this exists: production runs on **Supabase Free, which has NO managed backups**. Until the
> paid tier takes over (see "Tier handoff"), the scheduled GitHub Actions workflow
> [`db-backup.yml`](../.github/workflows/db-backup.yml) is the only safety net.
> Owner: Mohamed. Decided in go-live chantier 04 (S1 §7).

## What is covered — and what is not

| Covered (in every dump)                                                           | NOT covered                                                                        |
| --------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| `public` schema — all app data (profiles, content, attempts, entitlements, shop…) | Supabase **Storage files** (none used today — revisit if file uploads ship)        |
| `auth` schema — accounts, identities (so users keep their logins)                 | Vercel env vars & platform config (re-create from `docs/environment-variables.md`) |
|                                                                                   | Code & migrations (that's git)                                                     |

Format: `pg_dump -Fc` (custom, compressed). Postgres server is **17.x** → always restore with
client tools ≥ 17.

## RPO / RTO

- **RPO ≈ 24 h** (daily 02:30 UTC dump). Acceptable for the free beta; first paid users → tier handoff.
- **RTO ≈ 1 h** (new Supabase project + restore + env swap), assuming the runbook below.

## Routine operation

- **Scheduled**: every night 02:30 UTC the workflow dumps **prod** → artifact `db-prod-<stamp>`,
  retention 14 days. Requires the `PROD_SUPABASE_DB_URL` repo secret (Actions). Artifacts live
  under the repo's Actions storage (private-repo quota ~500 MB — 14 × current dump size fits;
  shrink retention if the DB grows).
- **Manual dump**: Actions → `db-backup` → Run workflow → target `test` or `prod`.
- **Restore drill** (run MONTHLY, and after any big schema change): Run workflow with
  `drill = true`. It restores the fresh dump into a throwaway Postgres 17 container on the runner
  and fails unless all invariants pass (profiles/subjects/exercises/questions/auth.users non-empty
  - `start_exercise_session` present). No environment is touched.

## Real restore — scenario A: corrupted/lost data, same project

1. **Stop the bleeding**: pause writes if needed (Vercel → pause deployments is not enough;
   worst case flip the Supabase project to read-only via dashboard, or accept the gap).
2. Download the latest good artifact (Actions → run → Artifacts).
3. Restore `public` (destructive — replaces app data):
   ```bash
   pg_restore --clean --if-exists --no-owner --schema=public \
     -d "$PROD_SUPABASE_DB_URL" db-prod-<stamp>.dump
   ```
4. `auth` data only if accounts were lost (auth SCHEMA already exists, managed by Supabase —
   restore data, not structure):
   ```bash
   pg_restore --data-only --schema=auth -d "$PROD_SUPABASE_DB_URL" db-prod-<stamp>.dump
   ```
   (If conflicts: truncate `auth.users` cascade first — extreme case, accounts re-imported.)
5. Smoke: login + start a quest + submit (the pgTAP-guarded RPC path), check admin consoles.

## Real restore — scenario B: project gone, rebuild from scratch

1. Create a new Supabase project (region **eu-north-1** to keep Vercel co-location).
2. Apply migrations: `supabase db push --db-url <new-url>` (full schema, RLS, RPCs, grants —
   the source of truth is the repo, NOT the dump's structure).
3. Restore **data only** on top:
   ```bash
   pg_restore --data-only --no-owner --schema=public -d "<new-url>" db-prod-<stamp>.dump
   pg_restore --data-only --schema=auth -d "<new-url>" db-prod-<stamp>.dump
   ```
4. Swap env vars (Vercel + local `.env`): `SUPABASE_URL`, both keys (see
   `docs/environment-variables.md`), **redeploy without build cache** (VITE\_\* are inlined).
5. Update the secrets (`PROD_SUPABASE_DB_URL`) and run a manual drill against the new project.
6. Smoke as in scenario A. Auth emails: re-check SMTP settings (dashboard config is NOT in the dump).

## Tier handoff (palier 2 — first real paying users)

Upgrade Supabase to Pro → managed daily backups (7-day retention) become primary;
this workflow stays as belt-and-suspenders (independent copy, in our hands, 14 days).
PITR only if an RPO < 24 h is ever required (paid add-on — decide on real stakes).

## Secrets required (GitHub → Settings → Secrets → Actions)

| Secret                 | Value                                                        | Status                             |
| ---------------------- | ------------------------------------------------------------ | ---------------------------------- |
| `PROD_SUPABASE_DB_URL` | Supabase prod → Connect → **Session pooler** URI (port 5432) | ✅ set, drill-validated 2026-06-12 |
| `TEST_SUPABASE_DB_URL` | already used by `e2e-auth.yml` self-provisioning             | ✅ set, drill-validated 2026-06-12 |

Pooler URI gotchas (each cost a failed run): the user MUST be `postgres.<project-ref>` (bare
`postgres` → "no tenant identifier"); any special character in the password MUST be
percent-encoded (`*` → `%2A`, `@` → `%40`, …) — or keep a generated alphanumeric password.
A wrong password fails as `password authentication failed for user "postgres"` even when the
tenant suffix is correct (the pooler strips the suffix before auth).
