# End-to-end tests (Playwright)

Real browser journeys. Two tiers:

| Tier              | Specs                                                | Needs a backend?                                           | Where it runs                                         |
| ----------------- | ---------------------------------------------------- | ---------------------------------------------------------- | ----------------------------------------------------- |
| **Public**        | `landing.spec.ts`, `auth-redirects.spec.ts`          | No (dummy Supabase env is fine)                            | `E2E` workflow, on every PR                           |
| **Authenticated** | `authed/*.spec.ts` (free / premium / admin / parent) | **Yes** — a dedicated TEST Supabase project + seeded users | `E2E (authenticated)` workflow, on `main` / on demand |

> ⚠️ Playwright can't run in the build sandbox (browser download is blocked). Run it locally or in CI.

## Run the public tier (no setup)

```bash
npx playwright install chromium
npm run test:e2e
```

## Run the authenticated tier

### 1. Create a dedicated TEST Supabase project

- A **separate** project from production (never point these at prod).
- Apply **all** SQL migrations from `supabase/migrations/` **and** the generated content, so subjects/exercises exist for the journeys.

### 2. Set the secrets / env

Locally, export (or put in a `.env` you don't commit):

```bash
export SUPABASE_URL="https://<test-ref>.supabase.co"
export SUPABASE_PUBLISHABLE_KEY="<test anon key>"
export VITE_SUPABASE_URL="$SUPABASE_URL"
export VITE_SUPABASE_PUBLISHABLE_KEY="$SUPABASE_PUBLISHABLE_KEY"
export SUPABASE_SERVICE_ROLE_KEY="<test service-role key>"
export E2E_USER_PASSWORD="<a strong password>"
```

In **GitHub → Settings → Secrets and variables → Actions**, add:

- `TEST_SUPABASE_URL`
- `TEST_SUPABASE_ANON_KEY`
- `TEST_SUPABASE_SERVICE_ROLE_KEY`
- `E2E_USER_PASSWORD`

The `E2E (authenticated)` workflow skips (stays green) until these are set.

### 3. Seed the test users (idempotent)

```bash
npm run e2e:seed
```

Creates / refreshes 4 accounts (all password `E2E_USER_PASSWORD`):

| Email                                 | Role    | Subscription    |
| ------------------------------------- | ------- | --------------- |
| `student.free@e2e.xpscholars.test`    | student | none (free)     |
| `student.premium@e2e.xpscholars.test` | student | active (annual) |
| `parent@e2e.xpscholars.test`          | parent  | —               |
| `admin@e2e.xpscholars.test`           | admin   | —               |

### 4. Run

```bash
npm run test:e2e:auth
```

The `setup` project logs each role in through the real UI and saves its session
to `e2e/.auth/<role>.json` (git-ignored); the `authed-*` project reuses it.

## What the authenticated specs cover

- **free-user**: dashboard + subject cards, daily-goal widget renders, and a
  difficulty 3+ mission shows the **subscription paywall + beta CTA**.
- **premium-user**: a difficulty 3+ mission does **not** show the paywall.
- **admin-and-parent**: admin reaches `/admin/subscriptions` and sees admin nav;
  parent reaches `/parent-report`.

> Selectors are intentionally resilient but may need a small tweak after the
> first real run if UI copy differs — adjust in the relevant `authed/*.spec.ts`.
