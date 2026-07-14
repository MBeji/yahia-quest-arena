---
name: regression-guard
description: >-
  Daily non-regression sweep for yahia-quest-arena. Reconciles the test suites
  (Vitest unit, pgTAP DB, Playwright e2e) with the day's code/content changes:
  updates STALE tests that drifted from intended behaviour, ADDS coverage for new
  behaviour, runs the gate, and — critically — distinguishes a stale test from a
  REAL BUG. Real bugs are reported (tracking issue / PR), never papered over by
  weakening a test. Use when asked to "mettre à jour les tests", "garantir la non
  régression", "vérifier que tout marche après les changements du jour", "remonter
  les vrais bugs", or when run on a schedule before the nightly build. Defers to
  the `verify` skill for the gate and the `code-review` skill for diff reasoning.
---

# Regression guard — keep the tests honest with the day's changes

This skill runs a **reconciliation sweep**: it looks at what changed in the repo
over a window (typically the last day), makes sure every suite still reflects the
**intended** behaviour, and produces a verdict — **green**, or **a list of real
bugs to report**. It is the automated counterpart to a careful human "did our
tests keep up, and is anything actually broken?" pass.

> **The one rule that must never bend.** A failing or missing test is either a
> _stale test_ (the code intentionally changed; the test lagged) or a _real bug_
> (the code is wrong; the test correctly caught it). You may **update or add**
> tests for the first. You must **NEVER** edit, relax, skip, or delete a test to
> make a real bug pass — that hides the defect. When in doubt, treat it as a real
> bug and report it. This is exactly the trap that let the FR-default and
> nav-overflow regressions ship unseen; the guard exists to stop it.

## When this runs

- **Scheduled** (recommended): once a day, _before_ the nightly build (the
  nightly cron is 01:00 UTC / 02:00 Tunisia). The guard opens a PR with any test
  updates and/or a bug report; the nightly then validates main as usual.
- **On demand**: invoke after a busy day of changes, or before a release.

Never push test changes straight to `main`. Output is always a **reviewable PR**
plus, for genuine defects, a **tracking issue** — a human stays in the loop.

## Workflow (do these in order)

### 1. Scope the day's changes

- Determine the window: commits on `main` since the last green nightly (or since
  `~1 day ago`). `git log --oneline --since="26 hours ago" origin/main` and
  `git diff --stat <last-green-sha>..origin/main`.
- Classify the diff by area, because each area maps to a suite:
  - `src/features/**`, `src/lib/**`, `src/hooks/**`, `src/shared/**` → **Vitest** unit/integration.
  - `supabase/migrations/**`, RPCs, RLS, grants → **pgTAP** (`supabase/tests/*.sql`).
  - routes / UI shell / user journeys → **Playwright e2e** (`e2e/`), public vs authed.
  - `content/**` → content QA (`content:qa:strict`) — not behaviour tests, flag separately. Pedagogical
    fidelity (scope, and **completeness vs the combined CNP sources — teacher guide + manuel élève**, the
    student textbook being an indispensable complement) is **`content-audit`**'s job, not this skill's —
    point school-content drift there rather than encoding it as a unit test.
- Ignore pure docs/comment changes.

### 2. Run the gate and the slow suites to see current truth

- `npm run verify` (lint + typecheck + unit). For release-grade, `npm run ci:verify`.
- pgTAP: the local Supabase stack (`supabase db start` + `supabase test db`) — see
  `.github/workflows/db-tests.yml`. Needs Docker.
- e2e: public tier needs no backend; the authed tier needs the TEST project
  (`npm run e2e:setup && npm run test:e2e:auth`) — see `e2e/README.md`.
- Collect every failure and every **coverage gap** (new behaviour with no test).

### 3. Triage each failure / gap — the heart of the skill

For each one, decide which bucket it is, with evidence:

- **Stale test (selector/label/route/locale drift, renamed export, moved file).**
  The code change was intentional and correct; the test encodes the _old_ shape.
  → **Update the test** to assert the _new intended_ behaviour. Prefer
  locale-proof / structural selectors (href, testid, role) over brittle text.
  Examples seen in this repo: the FR-default locale renamed UI labels; the nav
  refactor moved the sign-out button. Those are stale-test updates.

- **Missing coverage (new feature, new branch, new RPC with no test).**
  → **Add** a co-located test (`__tests__/` for unit, `supabase/tests/NN_*.sql`
  for DB, `e2e/authed|public/*.spec.ts` for journeys). New table migrations must
  also ship their grants (see AGENTS.md) — assert them in pgTAP.

- **Real bug (the app/SQL behaves wrong; the test is right to fail).**
  → **Do NOT touch the test.** Reproduce minimally, capture evidence (failing
  assertion, expected vs received, screenshot/trace for e2e, SQL error for
  pgTAP), and **report it** (step 5). If it's a clear, low-risk fix that is
  squarely the intended behaviour, you MAY fix the _code_ (not the test) and let
  the existing test prove it — but a behaviour change that's a real product
  decision is reported, not silently changed.

If you cannot confidently tell stale-test from real-bug, it is a **real bug**:
report it. Verifying "is this the intended behaviour?" usually means reading the
related code, the i18n catalogs, the route, or asking via the PR.

### 4. Make the gate green honestly

- Apply the stale-test updates and the added coverage from step 3.
- Re-run `npm run verify` (+ the relevant slow suite) until green — green because
  the tests now track reality, **never** because a test was weakened.
- Respect the Definition of Done (AGENTS.md): no `--no-verify`, no `as any`/
  `@ts-ignore` to dodge types, no disabling ESLint inline, no lowering Vitest
  coverage thresholds, no widening coverage `include` to dilute the metric.

### 5. Report — two distinct outputs

- **Test updates / added coverage → a draft PR.** Conventional-commit messages
  (`test:`, `fix(test):`). The PR body lists, per change, _why_ (which day's
  commit drifted it) and proves the gate is green. A human reviews and merges.
- **Real bugs → a tracking issue** (or a comment on the offending PR), one per
  bug, titled clearly, with: repro steps, expected vs actual, the failing
  test/assertion, and severity. Link the commit suspected of introducing it
  (`git log -S` / `git bisect` mentally from the diff). Do **not** open a PR that
  "fixes" it by editing the test.
- If everything is already green and covered: a short "all green" report,
  including what changed today and which suites exercised it. Silence is not a
  pass — say so explicitly.

## Guardrails

- One reviewable PR for test changes; never auto-merge, never push to `main`.
- Never convert a real bug into a test edit. When unsure → report.
- Keep tests deterministic and resilient (structural selectors, no arbitrary
  sleeps; mirror the existing page-object / pgTAP conventions).
- Tests travel with the code they cover; coverage must not regress.
- Defers to: **`verify`** (the gate), **`code-review`** (reading the diff for
  correctness). For content changes, run **`content:qa:strict`** rather than
  inventing behaviour tests; for pedagogical fidelity and completeness vs the
  **combined CNP sources (teacher guide + manuel élève)**, defer to **`content-audit`**.
