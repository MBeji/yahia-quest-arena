# End-to-end tests (Playwright)

The project's **reference test suite**: real browser journeys against the app.
Separate from the Vitest unit/component suite and from `npm run verify` — run it
explicitly (see below).

Two tiers:

| Tier              | Specs              | Backend?                                       | CI workflow                                |
| ----------------- | ------------------ | ---------------------------------------------- | ------------------------------------------ |
| **Public**        | `public/*.spec.ts` | No (dummy Supabase env is fine)                | `E2E` — every PR                           |
| **Authenticated** | `authed/*.spec.ts` | Yes — a dedicated TEST Supabase + seeded users | `E2E (authenticated)` — `main` / on demand |

> ⚠️ Playwright can't run in the restricted build sandbox (browser download blocked). Run locally or in CI.

## Layout

```
e2e/
  fixtures.ts          # extended `test`: Page Objects + `adminDb` fixture
  auth.setup.ts        # logs each role in (via AuthPage) → e2e/.auth/<role>.json
  tsconfig.json        # typecheck config for e2e (npx tsc -p e2e/tsconfig.json)
  pages/               # Page Objects (one per screen) — selectors live HERE
    auth.page.ts  landing.page.ts  dashboard.page.ts  subject.page.ts  quest.page.ts
  helpers/
    env.ts             # single source of truth for e2e env
    users.ts           # roles, test accounts, storageState paths
    db.ts              # service-role client + content helpers (adminDb)
  public/              # logged-out specs (no backend)
  authed/              # authenticated specs (reuse a role's stored session)
scripts/e2e/
  seed-test-users.mjs  # create/refresh the 4 test accounts  (npm run e2e:seed)
  reset-gameplay.mjs   # wipe gameplay state to a clean slate (node scripts/e2e/reset-gameplay.mjs)
```

## Conventions (keep the suite clean & extensible)

- **Selectors live in Page Objects** (`pages/`), never inline in specs. Prefer
  locale-independent locators: ARIA roles/labels, field ids (`#auth-email`),
  route hrefs (`a[href^="/subject/"]`), and the few hardcoded English literals.
  UI copy is i18n (default `en`) — don't assert translated strings.
- **Specs read like scenarios**: `await dashboard.goto(); await expect(...)`. No
  raw `page.locator(...)` chains in specs — add a Page Object method/getter instead.
- **Auth** is declared per spec: `test.use({ storageState: STORAGE_STATE.<role> })`.
- **Data**: never hardcode ids. Query via the `adminDb` fixture (service-role),
  e.g. `await adminDb.premiumSubjectId()`.
- **Determinism**: authed runs start from a clean slate (`reset-gameplay.mjs` runs
  before the suite in CI). If you add a spec that **mutates** gameplay, make sure the
  table it touches is in `GAMEPLAY_TABLES` (scripts/e2e/reset-gameplay.mjs).

## Add a test

- **Public**: drop a `*.spec.ts` in `e2e/public/` — auto-discovered.
- **Authenticated**: drop a `*.spec.ts` in `e2e/authed/`, add
  `test.use({ storageState: STORAGE_STATE.<role> })`.
- **New screen**: add `pages/<screen>.page.ts`, wire it in `fixtures.ts` (one line),
  use it via the fixture.
- **New role**: extend `Role` + `TEST_USERS` + `STORAGE_STATE` (helpers/users.ts) and
  the `USERS` list in `scripts/e2e/seed-test-users.mjs`.

## Run the public tier (no setup)

```bash
npm run test:e2e:install   # one-time: download Chromium
npm run test:e2e           # public/*.spec.ts
```

## Run the authenticated tier

1. **Create a dedicated TEST Supabase project** (never production). Apply all
   `supabase/migrations/` (schema + generated content): `supabase db push`.
2. **Set env** locally (a `.env` you don't commit, or your shell):
   ```bash
   SUPABASE_URL / VITE_SUPABASE_URL                 = https://<test-ref>.supabase.co
   SUPABASE_PUBLISHABLE_KEY / VITE_SUPABASE_PUBLISHABLE_KEY = <test anon key>
   SUPABASE_SERVICE_ROLE_KEY                        = <test service-role key>
   E2E_USER_PASSWORD                                = <a strong password>
   ```
   In **GitHub → Settings → Secrets → Actions**: `TEST_SUPABASE_URL`,
   `TEST_SUPABASE_ANON_KEY`, `TEST_SUPABASE_SERVICE_ROLE_KEY`, `E2E_USER_PASSWORD`.
   The authenticated workflow skips (green) until these are set.
3. **Seed + run**:
   ```bash
   npm run e2e:seed                       # 4 accounts (free/premium/parent/admin), same password
   node scripts/e2e/reset-gameplay.mjs    # optional: clean slate
   npm run test:e2e:auth
   ```

Seeded accounts (all password `E2E_USER_PASSWORD`):
`student.free@`, `student.premium@`, `parent@`, `admin@e2e.xpscholars.test`.

## Maintenance / guardrails

The `E2E` workflow runs these on every PR (they're not part of `npm run verify`):

```bash
npx tsc --noEmit -p e2e/tsconfig.json    # typecheck e2e
npx eslint e2e --max-warnings=0          # lint e2e
```

Debugging: `npx playwright test --ui` (watch/time-travel), `npx playwright show-report`
(last HTML report — also uploaded as a CI artifact). Failures keep a trace, screenshot,
and video.
