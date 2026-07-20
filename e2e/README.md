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
  _env.mjs             # loads .env.test + refuses to ever touch the prod project
  check-env.mjs        # doctor: is the TEST env complete?    (npm run e2e:doctor)
  setup-test-db.mjs    # apply migrations (schema) to TEST    (npm run e2e:db:push)
  seed-fixture-content.mjs # seed the e2e fixture catalogue   (npm run e2e:seed-content)
  seed-test-users.mjs  # create/refresh the 4 test accounts   (npm run e2e:seed)
  reset-gameplay.mjs   # wipe gameplay state to a clean slate (npm run e2e:reset)
.env.test.example      # copy → .env.test, fill with TEST project creds (gitignored)
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
  e.g. `await adminDb.premiumParcoursExercise()`.
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

> Everything below talks ONLY to a **dedicated TEST Supabase project**. The suite
> seeds, resets and mutates data — never point it at production. `.env.test`,
> `_env.mjs` and `playwright.config.ts` each refuse the known prod ref as a safety
> net, and `playwright.config.ts` loads `.env.test` so the spawned dev server also
> targets the TEST project (not your `.env`).

### Local — turnkey

```bash
# 0. one-time
npm run test:e2e:install                 # download Chromium
cp .env.test.example .env.test           # then fill in TEST project values

# 1. verify the env is complete (secrets masked)
npm run e2e:doctor

# 2. provision the TEST project: schema, e2e fixture catalogue, accounts, reset
#    (needs TEST_SUPABASE_DB_URL in .env.test for the db push step)
npm run e2e:setup            # = e2e:db:push && e2e:seed-content && e2e:seed && e2e:reset

# 3. run the authenticated journeys
npm run test:e2e:auth
```

Individual steps are also available: `npm run e2e:db:push`, `e2e:seed-content`,
`e2e:seed`, `e2e:reset`. Re-run `e2e:reset` before a fresh pass to get a
deterministic starting point. `e2e:seed-content` seeds the committed fixture
catalogue (every question type + the non-school families the suite covers) —
since étude 24 the corpus no longer travels in migrations, so `e2e:db:push`
alone yields only the legacy `mcq` seed.

### CI

Set these **GitHub → Settings → Secrets → Actions** (the `E2E (authenticated)`
workflow skips green until they exist):

| Secret                           | Purpose                                             |
| -------------------------------- | --------------------------------------------------- |
| `TEST_SUPABASE_URL`              | TEST project API URL (client + server)              |
| `TEST_SUPABASE_ANON_KEY`         | TEST anon / publishable key                         |
| `TEST_SUPABASE_SERVICE_ROLE_KEY` | TEST service-role key (seed / reset)                |
| `E2E_USER_PASSWORD`              | password for the 4 seeded accounts                  |
| `TEST_SUPABASE_DB_URL`           | _optional_ — Postgres URI; lets CI `db push` itself |

With `TEST_SUPABASE_DB_URL` set, the workflow self-provisions the schema (migrations)
each run; without it, applying migrations to the TEST project is a one-time prereq.
The e2e fixture catalogue is (re)seeded every run regardless (`e2e:seed-content`,
service-role only), so a fresh TEST project reaches full coverage.
A raw (un-encoded) password in the URI is fine: `e2e:db:push` percent-encodes the
userinfo automatically before calling the Supabase CLI (`normalizeDbUrl` in
`scripts/e2e/_env.mjs`) — a malformed URI used to fail CI with "invalid userinfo".

Seeded accounts (all password `E2E_USER_PASSWORD`):
`student.free@`, `student.premium@`, `parent@`, `admin@e2e.xpscholars.test`.
Premium is now per-parcours: `student.premium@` is **granted the `concours-9eme` +
`concours-6eme` entitlements** via `admin_grant_parcours` (the seed runs as service-role,
bypassing `is_admin()`); `student.free@` has **no entitlements**. There are no
`subscription_*` columns anymore. Note (free phase, since migration `20260711100000`):
every parcours is `is_premium = false` in prod, so these seeded entitlements exercise the
**dormant** premium machinery — specs assert the free-phase behavior.

## Maintenance / guardrails

The `E2E` workflow runs these on every PR (they're not part of `npm run verify`):

```bash
npx tsc --noEmit -p e2e/tsconfig.json    # typecheck e2e
npx eslint e2e --max-warnings=0          # lint e2e
```

Debugging: `npx playwright test --ui` (watch/time-travel), `npx playwright show-report`
(last HTML report — also uploaded as a CI artifact). Failures keep a trace, screenshot,
and video.
