# End-to-end tests (Playwright)

The project's **reference test suite**: real browser journeys against the app.
Separate from the Vitest unit/component suite and from `npm run verify` — run it
explicitly (see below).

Three tiers:

| Tier              | Specs                   | Backend?                                       | CI workflow                                 |
| ----------------- | ----------------------- | ---------------------------------------------- | ------------------------------------------- |
| **Public**        | `public/*.spec.ts`      | No (dummy Supabase env is fine)                | `E2E` — nightly / on demand                 |
| **Public-anon**   | `public-anon/*.spec.ts` | Yes — anon reads on the TEST project           | `E2E (authenticated)` — nightly / on demand |
| **Authenticated** | `authed/*.spec.ts`      | Yes — a dedicated TEST Supabase + seeded users | `E2E (authenticated)` — nightly / on demand |

⚠️ **No e2e tier gates a pull request.** Both workflows are `workflow_call` +
`workflow_dispatch` only — there is no `pull_request` trigger — so a broken spec
surfaces at the next nightly, not at review time.

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
  public-anon/         # logged-out specs that DO need the TEST backend (anon reads)
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
  locale-independent locators: `data-testid`, field ids (`#auth-email`), route hrefs
  (`a[href^="/matiere/"]`). ⚠️ An **`aria-label` is not one** — it is translated like
  the rest, and the app's default locale is **French** (GAP-010), not English. A
  `getByRole("button", { name: /english copy/i })` then matches nobody.
- **Every negative assertion needs a paired positive one**, on the SAME Page Object
  getter. A selector used only in `toHaveCount(0)` reports green when it has gone
  stale — it measures a void, not an absence. That is issue #733, and it has bitten
  **three** times: `dashboard.adminNavLink` (fixed in #796), `dungeon.enterButton` after
  it (#797), and the `/admin/subscriptions` refusal notice (#805) — that last one written
  `/access denied|accès refusé/i` while the rendered copy comes from
  `t.subscription.accessDenied`, « Accès réservé aux administrateurs. » in French, the app
  default, so it could match nobody in any of the three languages. Each fix pairs the
  getter BOTH ways: `adminSubscriptions.accessDenied` is proven matchable by
  `authorization.spec` and proven absent by `admin-and-parent.spec`; `consolePanel` is the
  mirror.
- **And when no positive is WRITABLE, the negative doesn't belong in this tier at all.**
  A surface the current phase makes structurally unreachable cannot be paired: the quest
  paywall (`SubscriptionPaywall`) only mounts on a `resolve_exercise_access` refusal, and
  no account can provoke one while every `parcours.is_premium` is false. Its two getters
  — `paywallPremiumText` and the `betaCta` living _inside_ it — carried five negatives
  that nothing could ever turn red; both are deleted. The rule they leave behind:
  **assert the cause, not the absence of its consequence.** The free-phase invariant is
  now `adminDb.premiumParcoursIds()` being empty (`premium-gate.spec.ts`) — one row
  flipped back to premium turns it red, and the failure names the parcours. The dormant
  UI keeps its _paired_ coverage at the **unit** tier
  (`src/features/subscription/__tests__/`), the only tier that can render it on demand.
  Do **not** stage the positive by flipping a global catalogue flag: the suite runs
  `fullyParallel` and the neighbouring specs read that same row.

  Same verdict, other shape (#805): a surface that is never RENDERED at all.
  `/parent-report` refuses server-side (`getLinkedStudents` throws) and the route has no
  `isError` branch, so no refusal copy ever reaches the page — a `toHaveCount(0)` aimed at
  one measures a void by construction. Dropped, not re-aimed: what IS observable there,
  a student landing on the alliance-link UI with nobody linked, is what
  `authorization.spec` pins.

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
>
> Two consequences worth knowing before a local run:
>
> - the **authed / public-anon tiers refuse to start** without an explicit TEST
>   backend. An unset `SUPABASE_URL` is not "no backend" — it let the dev server
>   resolve one from the repo-root `.env` (production) through Vite's `loadEnv`
>   file fallback, so absent is now as fatal as wrong;
> - the **backendless public tier** (`npm run test:e2e`) runs on the same dummy
>   pair CI injects, so it can't reach a real backend at all — with or without
>   `.env.test`.

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

## Un nightly rouge : lire la TRACE avant de lire le code

Le rapport Playwright est **téléchargeable depuis n'importe quel run**, et il contient la console
du navigateur. C'est presque toujours là qu'est la réponse — pas dans le code.

```bash
gh api repos/MBeji/yahia-quest-arena/actions/runs/<RUN_ID>/artifacts \
  --jq '.artifacts[] | "\(.name) \(.size_in_bytes)"'
gh run download <RUN_ID> -n playwright-report -D /tmp/pw     # ou playwright-report-auth
unzip -o -q /tmp/pw/data/<hash>.zip -d /tmp/trace            # la trace d'UN test
node -e 'for (const l of require("fs").readFileSync("/tmp/trace/0-trace.trace","utf8").trim().split("\n")) {
  const j = JSON.parse(l); if (j.type === "console" || j.type === "pageerror") console.log(j.messageType, j.text);
}'
```

**Ce que ça a coûté de ne pas le faire.** Du 2026-08-25 au 08-29, le nightly a rougi **cinq
nuits**. La cause tenait en une ligne de console — `Module "node:dns" has been externalized for
browser compatibility` — présente dans un artefact attaché à **chaque** run. Elle a été trouvée
après deux jours de lecture de code et **quatre hypothèses réfutées** : la bulle IA, la garde
d'authentification, les identifiants Supabase factices du job public, puis la piste de
configuration du plugin. Toutes plausibles, toutes fausses.

### Deux réflexes qui font gagner des heures

**Compter les tests qui échouent avant de chercher pourquoi.** Quatre routes gardées tombant
_ensemble_ écartent d'emblée toute cause propre à l'une d'elles — il faut une explication qui les
prenne toutes. C'est ce qui a orienté vers la coquille partagée.

**Comparer avec la production.** L'application tourne sur le même commit :
`https://www.na9ranal3ab.tn` dans un vrai navigateur. Si le comportement y est correct, la panne
est **propre au banc d'essai** (serveur de dev Vite, modules non bundlés) et pas au produit — ce
qui change complètement où chercher, et ce qu'on a le droit d'annoncer.

### ⚠️ Une suite « annulée » n'est pas une suite verte

Le nightly s'arrête au premier rouge : quand la suite publique échoue, l'authentifiée est
**annulée**. Elle a donc pu casser sans que personne ne le voie. Le motif s'est produit **trois
fois de suite** en une semaine — chaque correctif révélant la panne suivante, une nuit à la fois.
Toujours lire l'état de CHAQUE suite, jamais le seul verdict du run :

```bash
gh run view <RUN_ID> --json jobs --jq '.jobs[] | "\(.name): \(.conclusion)"'
```

## Maintenance / guardrails

These two live inside the `E2E` workflow and are **not** part of `npm run verify`.
Since that workflow never runs on a PR (see above), nothing runs them for you — run
them yourself before pushing anything under `e2e/`:

```bash
npx tsc --noEmit -p e2e/tsconfig.json    # typecheck e2e
npx eslint e2e --max-warnings=0          # lint e2e
```

And don't leave a spec's fate to the next nightly — dispatch the tier your change
touches on your own branch:

```bash
gh workflow run e2e.yml --ref <branch>        # public tier (needs no secret)
gh workflow run e2e-auth.yml --ref <branch>   # public-anon + authenticated tiers
```

Debugging: `npx playwright test --ui` (watch/time-travel), `npx playwright show-report`
(last HTML report — also uploaded as a CI artifact). Failures keep a trace, screenshot,
and video.

## Repro manuelle : « Invalid token » en fin d'exercice

La panne que ferme le filet de sauvegarde (outbox + brouillon + rejeu serveur).
Elle n'est **pas** dans la suite Playwright, et c'est un choix : la reproduire
exige d'abaisser la durée de vie des JWT du projet, un réglage de projet
Supabase que ni un test ni un workflow ne peut poser — et qui, laissé en place,
fausserait toutes les autres spécifications authentifiées.

Elle est déterministe malgré tout, si on suit l'ordre.

**Préparer (une fois, sur le projet TEST — jamais la prod).**
Supabase Studio → Authentication → Sessions → _Access token (JWT) expiry_ :
`300` secondes. Le noter pour le remettre à `3600` après.

**Reproduire — doit ÉCHOUER avant le correctif.**

1. Se connecter avec un compte de test, ouvrir une mission de `/quest/$exerciseId`.
2. Répondre à une question, puis **laisser l'onglet en arrière-plan 6 minutes**
   (plan d'un autre onglet, ou écran verrouillé sur mobile — le gel des
   minuteries est le cœur du sujet : il empêche le ticker d'`autoRefreshToken`
   de se déclencher).
3. Revenir, terminer la mission, valider la dernière question.

Avant le correctif : la soumission lève `Unauthorized: Invalid token`, le toast
d'erreur passe, et **les réponses sont perdues** — elles ne vivaient que dans
l'état React. Après : la pastille passe à « Pas encore enregistré », la file
rejoue la soumission avec un jeton neuf, et le score s'affiche.

**Vérifier le filet lui-même — la coupure réseau.**

1. Ouvrir une mission, répondre à toutes les questions sauf la dernière.
2. DevTools → Network → _Offline_.
3. Valider la dernière question. La pastille passe à « Pas encore enregistré ».
4. **Recharger la page** en restant hors ligne : la file survit (localStorage).
5. Repasser en ligne. Le flush part au montage et à l'événement `online` ; la
   tentative apparaît dans `attempts` sans qu'on ait rien cliqué.

**Lire ce que la boîte noire en dit.** Après quelques jours en production, la
requête d'en-tête de `20260831140000_client_errors_telemetry.sql` tranche entre
les trois hypothèses. `jeton_valide_refuse > 0` confirme le diagnostic d'horloge
de #914 ; `retour_de_veille` dominant désignerait plutôt le gel des minuteries
mobiles. Les deux peuvent coexister.

**Ne pas oublier** de remettre le JWT expiry du projet TEST à `3600`.
