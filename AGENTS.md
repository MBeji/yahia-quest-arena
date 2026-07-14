# AGENTS.md — yahia-quest-arena (Na9ra Nal3ab)

> **This file is the single canonical source of truth.** When it disagrees with any
> other doc, AGENTS.md wins — fix the other doc. [`ARCHITECTURE.md`](./ARCHITECTURE.md)
> is the deeper architecture companion; the per-topic policy files under `docs/` and the
> Copilot pointer at `.github/copilot-instructions.md` defer to these two. This file
> covers commands, conventions, and gotchas not obvious from the code. **Project state**
> (current phase, dated decisions, real feature/étude/chantier status) lives in
> [`STATUS.md`](./STATUS.md) — read it before trusting any "is X live?" claim.

## What this is

Gamified learning **academy** — a broad catalogue, not a single course. Students do "quests"
(QCM exercises), earn XP/coins, unlock badges, level up hero classes, compete on a leaderboard,
and tackle a timed "dungeon" boss mode. Shonen/RPG manga aesthetic, trilingual (FR/EN/AR with RTL).

**Catalogue hierarchy** (this is the key mental model — the app is wider than its origins):
`themes` → `grades` → `subjects` → `chapters` → `exercises` → `questions`.

- A **theme** is a top-level track. Seeded themes: `ecole-tn` (Programme scolaire tunisien),
  plus standalone tracks `culture-generale`, `muscle-cerveau`, and
  language tracks `anglais` / `francais` / `arabe`. Only the school theme has grades
  (`themes.has_grades`).
- **Grades** exist _only_ under the school theme: the full Tunisian ladder, 1ère année de base →
  Baccalauréat (13 levels). 6ème, 9ème and Bac are national-exam years
  (`grades.is_concours_national`). The student picks one at onboarding → `profiles.current_grade_id`.
- So **"9ème année" is just one grade**, under one theme. It's currently the most-populated grade
  (most `content/` subjects target `9eme-base`), but treat that as data, not as the app's scope.
  Everything below `subjects` (chapters/exercises + all gameplay: XP, quiz gate, dungeon,
  leaderboard) is theme/grade-agnostic.
- A **parcours** is the student's enrolled track (`profiles.current_parcours_id`), resolved from a
  `(theme, grade)` pair. Kinds: `concours` (exam-year milestones — 9ème, 6ème, bac-math),
  `scolaire` (one per school grade) and `libre` (standalone themes) — ~35 parcours total.
  **Free phase (current)**: since the 2026-06-21 pivot and the étude 15 Q-2 arbitrage
  (2026-07-10), the app is **100 % free** — migration `20260711100000` set `is_premium = false`
  on every parcours, so **no mission is gated**. The per-parcours **entitlement** machinery
  stays in place but **dormant** (see "Access gate" under Data model; étude 01 — gelée — is the
  designated re-activation vehicle). No user-facing surface may say "premium/abonnement/payant"
  during this phase (étude 15 D-3).
  The dashboard is scoped to the active parcours; the public catalogue (`/programme`) doubles as
  the Explorer (`/themes` 301-redirects there) and lets a student switch.

**Stack**: Vite 8 · TanStack Start (SSR + file routing + server fns) · React 19 · TanStack Query 5 · Supabase (Postgres + Auth + RLS) · Tailwind 4 / Radix-shadcn · **deploys to Vercel** — push to `main` auto-deploys prod via `scripts/build-vercel.mjs` (`vercel.json`). A Cloudflare Workers config also exists, but Vercel is the live target. Package manager: **npm** (`package-lock.json`; Node 22 / npm 10 in CI). Tests: Vitest 4 + Testing Library (unit) and Playwright (e2e).

## Essential commands

```bash
npm run dev          # Vite dev server (SSR)
npm run build        # production build
npm run build:check  # build + bundle-budget check
npm run smoke:shell  # prod-bundle browser smoke: public shell must render crash-free in Chromium
npm test             # vitest run — run `npm test` for the current test/file count
npm run test:watch   # watch mode
npm run test:coverage
npm run lint         # eslint src --max-warnings=0  (zero-warning policy)
npm run typecheck    # tsc --noEmit (strict)
npm run format       # prettier --write .
npm run verify       # lint + typecheck + test                          (fast local gate / pre-push)
npm run ci:verify    # verify + coverage + build:check + audit:deps + content:qa:strict + content:audit:strict  (full gate)
```

**Content pipeline** (authored files → Supabase migrations — see "Content pipeline" below):

```bash
npm run content:check                    # validate all content, write nothing
npm run content:build -- --subject <id>  # regenerate the migration for ONE changed subject only
npm run content:qa                        # content quality checks
npm run content:qa:strict                 # same, fail on warnings (part of ci:verify)
```

⚠️ Never run bare `npm run content:build` — it regenerates **all ~60 subjects** with fresh
timestamps (stray duplicate migrations you must not commit). Always scope with `--subject <id>`.
Full pipeline map + skill selection: `content-engine/references/generation-pipeline.md`.

**E2E (Playwright)** — needs a dedicated TEST Supabase project + seeded users; not part of the unit gate:

```bash
npm run test:e2e:install   # one-time: install chromium
npm run test:e2e           # public (chromium + mobile) specs — no backend needed

# Authenticated tier — TEST project only (cp .env.test.example .env.test first):
npm run e2e:doctor         # verify .env.test is complete (secrets masked)
npm run e2e:setup          # provision TEST: db:push + seed users + reset gameplay
npm run test:e2e:auth      # authenticated specs (uses e2e/.auth/*.json storage state)
```

`.env.test` (gitignored) holds the **dedicated TEST** Supabase creds; `playwright.config.ts`
loads it so the spawned dev server targets TEST, and `_env.mjs` + the config refuse the known
prod ref as a safety net. Never point e2e at production — it seeds/resets/mutates data. Full
runbook: [`e2e/README.md`](./e2e/README.md).

**Git hooks (husky):** `pre-commit` runs `lint-staged` (Prettier + ESLint `--fix` on
staged files); `pre-push` runs `npm run verify`. Installed automatically via the
`prepare` script on `npm install`. Never bypass with `--no-verify` without a stated reason.

## Execution flow

- `src/server.ts` — SSR/Worker fetch entry; wraps responses and normalizes h3-swallowed
  catastrophic 500s into a branded error page.
- `src/start.ts` — `createStart`: registers CSRF + error request-middleware and the
  `attachSupabaseAuth` function-middleware globally.
- `src/router.tsx` — router factory (QueryClient in context).
- `src/routes/` — file-based routes (thin). `__root.tsx` → `_authenticated.tsx` (auth guard
  - nav shell) → feature pages. Auth redirect happens in a `useEffect`, not during render.
- Data access: every server fn is `createServerFn(...).middleware([requireSupabaseAuth])`.
  The middleware validates the `Bearer` JWT and injects `{ supabase, userId, claims }` into
  `context`. See `src/shared/integrations/supabase/auth-middleware.ts`.

## Data model (Supabase)

`profiles` (xp/level/streak/coins/hero_class/role/`current_grade_id`/`current_parcours_id`) · `themes` → `grades`
(school theme only) → `subjects` → `chapters` → `exercises` → `questions` (QCM, `options` JSONB)
· `attempts` · `exercise_sessions` · `student_badges` /
`shop_items` / `inventory_items` · `daily_objectives` · `weekly_quests` ·
`spaced_repetition_schedule` (SM-2) · `dungeon_runs` · `duel_queue` / `duels` /
`duel_participants` (real-time duels + weekly leagues — étude 05) · `parent_student_links` ·
`parcours` (tracks — kinds concours/scolaire/libre; **all free in the current phase**) ·
`parcours_entitlements` (per-parcours grants, dormant; `source` ∈
{purchase/beta/gift/family}; family pack via `parent_student_links`) · `parcours_interest`
(votes on `coming_soon` parcours) · `beta_access_requests` ·
`content_reports` (user-flagged content errors) · `bug_reports` (user bug reports) ·
`themes` / `grades` · `question_attempts`
(append-only per-question telemetry — moteur adaptatif étude 04) + `user_misconceptions` (its
per-(user, tag) aggregate, trigger-maintained) · `competencies` / `competency_prereqs` /
`question_competencies` (knowledge graph — étude 07 lot 1). (The old `subscriptions` columns +
RPCs were removed in migration `20260609000000`.)

**Adaptive-engine telemetry (étude 04, phase A0).** Each answer submitted through
`submit_exercise_attempt`/`submit_dungeon_answer` also appends a `question_attempts` row in the
same transaction, resolving the chosen distractor's **misconception tag** from the **server-only**
`questions.distractor_tags` map (never sent to the client — same posture as `correct_option`; the
correct option stays untagged). Tags are namespaced by subject (`math.frac.add-denominators`) and
drawn from the closed registry `content/misconceptions.json` (id → FR/EN/AR labels), authored via the
optional per-option `misconceptionTag` content field and validated by `content:qa`. A trigger keeps
`user_misconceptions` (occurrences + distinct sessions) for the later "Révision du jour" / "Points
faibles" lots; raw telemetry is purged after 12 months (`purge_question_attempts`, pg_cron).

**Knowledge graph (étude 07, lot 1).** Competencies live in versioned family registries
`content/competences/<famille>.json` (`math.geo.thales-direct` → FR/EN/AR labels + same-family
prereq DAG, cycle = `content:check` error), compiled — like all content — into relational tables
(`competencies`, `competency_prereqs`; stable UUIDv5, family-scoped prune) via
`npm run content:build -- --competences` (registry ONLY — never regenerates subjects). Questions
declare 1–3 evaluated competencies via the optional `competencies` content field (first =
primary, ANY question type), compiled into the client-readable `question_competencies` junction —
unlike `distractor_tags` these ids describe the question, not the options, so they never leak the
key. Unknown id = `content:qa` error; family≠subject = warning (`subjectPrefixes` in the
registry). Per-student mastery (EWMA + forgetting) arrives with lot 2 (`user_competency_mastery`).

Server-side logic lives in SQL: `handle_new_user` (auto-profile on signup), `award_xp`
(streak + level curve: 200 XP/level, hero-class tiers), and the `submit_exercise_attempt`
RPC (atomic scoring + rewards + badge unlocks). All tables have RLS; the two privileged
functions are `REVOKE`d from anon/authenticated. Gameplay thresholds are centralized in
`src/shared/constants/gamification.ts` — change rules there, not inline.

**Access gate (per-parcours) — premium machinery DORMANT in the free phase.** Access is decided
server-side by the single authoritative RPC `resolve_exercise_access(exercise)`: a non-premium
parcours is always open; a premium parcours would open a mission only for a holder of a live
`parcours_entitlement` — directly, or via an active linked parent (the **family pack**) —
**except the free preview** (the chapter comprehension quiz + difficulty-1 missions,
`FREE_PREVIEW_MAX_DIFFICULTY`). Since migration `20260711100000` (free phase) **every parcours has
`is_premium = false`**, so the first branch always applies and nothing is gated; the paywall
component (`SubscriptionPaywall`) and the user-facing beta-access form are wired but unreachable.
`has_parcours_entitlement(user, parcours)` encapsulates the check; `set_current_parcours` sets the
student's active track at onboarding; admin provisioning stays live at `/admin/subscriptions`
(`admin_grant_parcours` / `admin_revoke_parcours` / `admin_list_parcours_entitlements`).
The Dungeon is **no longer entitlement-gated** — `get_dungeon_access()` keeps only the
progression locks (PREREQ / LEVEL / DAILY_LIMIT). The legacy global "difficulty ≥ 3 +
subscription" gate is **gone** — no code reads `subscription_*` / `has_active_subscription`.

**Consumables (shop items):** `shop_items.effect_payload` (JSONB) drives three live
mechanics, all keyed off `inventory_items.is_active` = "armed" (skins use `is_equipped`).
Potions (`xpMultiplier`/`coinMultiplier`) and the retry shield (`retries`) share a
**next-quest slot** (one armed at a time); the streak shield (`streakShield`) is a separate
**passive slot**; hints (`hints`/`hintBoost`) are spent on demand, never armed.
`activate_inventory_item` arms; `submit_exercise_attempt` applies/consumes potions
(`potionApplied`) and the retry shield (suppresses the spaced-rep penalty on a `<60%` fail,
`retryShieldUsed`); `award_xp` consumes a streak shield to save a one-missed-day streak;
`consume_hint` reveals `questions.explanation` on demand (decrements one charge). Anti-waste: a
consumable is consumed only when it actually takes effect, and never bypasses the
`tooFast`/`≥60%`/`improved` anti-farm gates. Apply consumable migrations before deploy (§7).
See ARCHITECTURE.md "Consumables (shop items)" for the full model.

## Content pipeline (`content/`)

Pedagogical content (subjects, chapters, courses, summaries, quizzes, exercises) is **not**
hand-written SQL — it lives as versioned files under `content/<subject>/NN-<slug>/`
(`subject.json`, `chapter.json`, `cours.md`, `resume.md`, `quiz.json`, `exercices/*.json`),
validated by Zod (`src/shared/content/schema.ts`), then compiled by
`scripts/content/build.ts` into **idempotent** SQL in `supabase/migrations/`. IDs are
**deterministic UUIDv5** derived from slugs, so rebuilding updates rows in place (no dupes)
and removed admin content is pruned — **parent-authored content is never touched**. Each
`subject.json` declares `themeId` (required) + `gradeSlug` (resolved to a `grades` UUID at
compile time, never hard-coded). `quiz.json` is mandatory; for **school-program** subjects it gates a
chapter's exercises (student must pass ≥ `QUIZ_PASS_THRESHOLD_PCT`), but **non-school themes never
gate on the quiz** (theory is optional there — `quest.startExerciseSession` skips the gate when
`grade_id` is null). Edit content as files → `content:build` →
review the generated SQL → apply to the DB **before** deploying dependent code (DoD §7).
Full spec: [`content/README.md`](./content/README.md) (in French).

**Generating content — use the skills.** Content authoring is industrialized via a suite of
Codex skills under [`.Codex/skills/`](./.Codex/skills/). **Start at the pipeline map**
([`content-engine/references/generation-pipeline.md`](./.Codex/skills/content-engine/references/generation-pipeline.md)):
it harmonizes the whole system into **a planning layer + two authoring layers** —
`curriculum-architect` (coverage audit across the 13 grades × official subjects, pedagogical
objectives & progression, prioritized dependency-aware backlog; **plans only**, never authors; its
`references/programme-map.md` is the official grade×subject matrix), base skills that build &
complete a chapter (`content-engine` + program wrappers + `content-cours`/`content-interactif`/
`content-audit`) and the professor overlay (`prof-*`) that raises the ceiling with hard d3–4
exercises — with a task→skill selection matrix, an agent-roles→skills matrix (translator/
calibrator/exporter are by-design mechanisms, not agents), the
cumulative/non-redundant rules, and the reproducible build→migration procedure (incl. the
`content:build --subject <id>` rule — bare `content:build` regenerates all ~60 subjects and must never
be committed). `content-engine` is the shared core
(schema, quality bar, reward table, RPG style, trilingual model, validate-then-stop workflow) in its
`references/`; thin per-program wrappers defer to it: `content-ecole-tn` (national school program,
**faithful to the official curriculum**), `content-culture-generale` and `content-muscle-cerveau`
(trilingual FR/EN/AR → three sibling subjects), `content-iq-training` (visual IQ/reasoning, SVG
figures), and `content-langue-{anglais,francais,arabe}` (immersion, one per language).
`content-cours` specializes in lesson texts (writes/rewrites `cours.md`/`resume.md` against the
course-quality bar: clarté, compréhension, exhaustivité — every tested notion must be taught —
expérience pédagogique). `content-interactif` authors **interactive/innovative missions** beyond
the classic QCM — texte à trous, chasse à l'erreur, appariement, remise en ordre, QCM visuel SVG,
lecture de document, histoire-problème séquentielle, vrai/faux motivé, sprint chrono — all encoded
inside the current QCM engine (catalogue + renderer contract:
`content-engine/references/interactive-formats.md`); **native** input types are a spec'd engine
evolution (`docs/interactive-question-types.md`), **fully shipped**: `numeric` entry,
drag-&-drop `ordering`/`matching`, and `multi` (multi-select) are all live and authorable
(`type` + `answerKey`, shapes in the content-engine `content-schema.md`).
`content-audit` is the review counterpart: it audits **existing** content
(re-solves every question, checks keys/distractors/notation/calibration, and grades courses/summaries
against the same course-quality bar) and produces a severity-ranked report. For **hard/elite**
content, a suite of **specialized "professor" skills** (`.Codex/skills/prof-*`) — one per
(matière × niveau), like a real subject teacher — authors difficulty-3/4 (⭐⭐⭐ boss / ⭐⭐⭐⭐ défi)
exercises that raise the ceiling above what exists, faithful to the program. The **exam years** get a
dedicated professor per (matière × niveau): `prof-math-9eme`, `prof-physique-9eme` (subject id `svt`),
`prof-svt-9eme` (id `sciences-vie-terre`), `prof-francais-9eme`, `prof-arabe-9eme`, `prof-anglais-9eme`,
and `prof-math-6eme`. The **primary cycle** (1ère→5ème) is covered by grade-aware, multi-level
professors — one per subject, each with a per-grade chapter map and age calibration:
`prof-math-primaire` (1ère→5ème), `prof-arabe-primaire` (1ère→5ème), `prof-eveil-primaire`
(الإيقاظ العلمي, 1ère→6ème), and `prof-islamique-primaire` (1ère→4ème, Quran text in **رواية قالون**
only — Tunisia's official reading). The **collège cycle** (7ème–8ème; 9ème keeps its dedicated
professors) is covered the same grade-aware way: `prof-math-college`, `prof-physique-college`,
`prof-svt-college`, `prof-arabe-college`, `prof-francais-college`, `prof-anglais-college` (the 8ème
base shipped 2026-07 — all six core subjects; a professor only overlays existing chapters). The **lycée cycle**
(1ère sec→bac) is covered by section-aware professors — sections are grade nodes and scientific
subjects switch ar→fr at 1ère sec (authored **natively in French, in the official manuals' jargon,
never as translation** — décision 2026-07-13), all specified in `docs/lycee-architecture.md`: `prof-math-lycee`, `prof-physique-lycee`, `prof-svt-lycee`,
`prof-francais-lycee`, `prof-anglais-lycee`, `prof-arabe-lycee`, `prof-philo-lycee`,
`prof-histoire-geo-lycee`, `prof-eco-gestion-lycee`, `prof-info-lycee` (they also own the
`NN-annales-bac` d4 tier; the lycée base is a pilot — section seed merged, one complete chapter
`math-bac-math/01-continuite-limites` — the rest waits on secondary transcriptions + base). Each carries its
subject's chapter map and misconception/trap taxonomy; all defer to `content-engine`'s shared
`references/expert-exercises.md` (hard-item archetypes, executed-error distractors, double-solve
verification) and to `content-ecole-tn` for program fidelity. Skills produce
**files only** (then run `content:check` + `content:qa:strict`); you review the diff, then build/apply.
**Non-school** programs are trilingual = three sibling subjects (one `contentLanguage` each) under one
theme; **school** content (`ecole-tn`) stays in the subject's **official language of instruction**
(monolingual). Every mission/quiz indicates its difficulty level (⭐ scale) in its title. There is no
per-record translation. **Notation is standard in every language**: Western digits (0–9), LTR
equations, SI units — including Arabic content (Arabic prose around standard math; never
Arabic-Indic digits). Rule: `content-engine/references/math-and-notation.md`.

## Conventions

- Feature-based: `src/features/{auth,dashboard,quest,dungeon,duel,shop,progression,parent-report,subscription,content-report,bug-report,notifications,parcours}/`
  (13 features). Each has `index.ts` (public barrel), `{name}.server.ts`, optional
  `components/`, `__tests__/`. The notable ones beyond the historical core:
  - **`subscription/`** — the **dormant premium layer**: per-parcours **entitlements** + the
    out-of-band (phone) paywall component + beta-access requests. Intact and reversible, but
    inert in the free phase (see "Access gate"); the admin consoles (`/admin/subscriptions`,
    `/admin/beta-requests`) stay live.
  - **`duel/`** — real-time duels + weekly leagues (étude 05, shipped): matchmaking queue,
    arena, Realtime presence/progress with authoritative polling fallback, league standings.
  - **`content-report/`** — user-flagged content errors ("Signaler une erreur") + admin triage
    (`/admin/content-reports`). Technically end-to-end; the weekly ops triage process is the
    part not yet running (see STATUS.md).
  - **`bug-report/`** — global bug-report launcher + `/admin/bug-reports` triage.
  - **`notifications/`** — Web-push subscriptions + the service-worker push handlers.
  - **`parcours/`** — gamified journey-map / adventure-path UI: a world map of **subjects**
    (`JourneyMap`/`buildSubjectNodes` at `/parcours`). Every map node routes to the **shared
    public subject hub** `/matiere/$subjectId` (chapters + quiz-gate + exercises — chantier
    C8 converged the connected screens onto the public « Référence » register). Four legacy
    authenticated paths survive only as permanent 301 redirects: `/subject/$subjectId` →
    `/matiere/$subjectId`, `/lesson/$chapterId` → `/chapitre/$chapterId`, and `/themes` +
    `/themes/$familyId` → `/programme` (the public catalogue doubles as the Explorer). The
    earlier per-subject zigzag chapter map (`SubjectPath`/`buildChapterNodes`) was removed;
    there is **one** chapter screen.

  (Leaderboard has no feature folder — `getLeaderboard` lives in `dashboard.server.ts`.
  Onboarding has no feature folder — it is an inline route at `routes/_authenticated/onboarding.tsx`.)

- **Features never import other features** — share via `src/shared/`. Routes stay thin (no business logic).
- Import aliases: `@/features/{name}`, `@/shared/lib|constants|types|integrations/...`. UI primitives live at `@/components/ui/*`, i18n at `@/lib/i18n`, the mobile hook at `@/hooks/use-mobile`.
- Input validation with **zod** on every server fn (`.inputValidator`). Sanitize HTML with DOMPurify (`src/shared/lib/markdown.ts`).
- Naming: kebab-case files, server fns are verbs (`getSubject`, `submitAttempt`). Structured logging via `@/shared/lib/logger` (redacts secrets) — not raw `console`.

## Subsystems & further docs

- **Subject content → SQL migrations (the right way to add content).** Authored content
  lives under `content/` (one dir per subject). The deterministic generator in
  `src/shared/content/{schema,loader,sql-builder}.ts` validates it (zod schema) and emits an
  idempotent Supabase migration per subject (stable v5 UUIDs, no machine-dependent output).
  Scripts: `npm run content:build` (regenerate migrations into `supabase/migrations/`),
  `npm run content:check` (build in `--check` mode, no writes), `npm run content:qa` /
  `content:qa:strict` (content QA; strict variant runs in `ci:verify`). **Add subjects/
  chapters/exercises by editing `content/` and rebuilding — never hand-write content
  migrations.**
- **End-to-end tests (Playwright).** Specs live in `/e2e`; config is `playwright.config.ts`
  (repo root).
  Scripts: `npm run test:e2e` (public projects: `public-chromium` + `public-mobile`),
  `npm run test:e2e:auth` (`authed-chromium`), `npm run test:e2e:install` (install the
  browser). Authenticated runs are seeded via `scripts/e2e/seed-test-users.mjs`. E2E is
  separate from the Vitest unit/integration gate.
- **Merge automation (push → PR → checks → merge — fully automatic, zero human
  steps; décision 2026-07-12).** Pushing any non-`main` branch auto-opens its PR
  **ready with auto-merge armed** (`auto-pr.yml`, squash + delete branch): it merges
  alone once the `main-protection` ruleset's required checks — `verify` +
  `Migration presence` + `Migration order` + `CodeQL` (SAST, `codeql.yml`) — are
  green on an up-to-date head (ruleset JSON at `.github/rulesets/main-protection.json`,
  imported in repo Settings → Rules; re-import after changing it). Nobody marks
  anything ready and nobody merges by hand — the session that pushed owns the PR
  until the merge lands (DoD §8). Deliberate WIP opts out: `[wip]` / `[draft]` /
  `[no-automerge]` in the head-commit subject (or a `wip/`/`draft/`/`rescue/` branch
  prefix) opens a **draft** instead — promote with `gh pr ready`; the `no-automerge`
  label freezes a PR, and a later push never promotes an existing draft.
  `automerge.yml` (re)arms ready PRs on PR events and, on every push to `main`,
  updates armed PRs left behind — "behind" decided by the compare API (`behind_by`),
  never the lazily-recomputed `mergeStateStatus` (staleness that stranded armed PRs
  until 2026-07-12) — and labels **`needs-rebase`** any armed PR whose auto-update
  fails on a conflict (the next session rebases it). Merging to `main` then
  auto-deploys (Vercel) and auto-applies migrations (§7). Prereqs (all in place):
  "Allow auto-merge" (General), "Allow GitHub Actions to create and approve pull
  requests" (Actions → General), and **`GH_AUTOMATION_PAT`** (Settings → Secrets and
  variables → Actions — a fine-grained PAT of a real collaborator, scoped to this
  repo, `contents`/`pull requests`/`workflows: write`, provisioned 2026-07-06):
  without it, PRs are opened by the `github-actions[bot]` actor, which is not a repo
  collaborator, so GitHub gates every `pull_request`-triggered required check behind
  manual "Approve and run" — the same mechanism as an outside contributor's fork PR,
  applied to our own automation. Both workflows fall back to `GITHUB_TOKEN` + a
  `workflow_dispatch` workaround when the secret is absent, but that path is **not
  deterministic** (see docs/passation.md).
- **Scheduled automations (GitHub Actions + repo skills).** Run on a schedule, all
  gracefully skipping without `CLAUDE_CODE_OAUTH_TOKEN`. The E2E/pgTAP nightly runs
  **every night**; the three Codex-agent guards run **2×/week** (each holds a runner for
  many minutes — keeps their PR/issue noise reasonable; the repo is public so Actions
  minutes are unlimited & free):
  `regression-guard.yml` (**Mon+Thu** 23:00 UTC → skill `regression-guard`: reconciles
  tests, opens a PR + bug issues), `nightly.yml` (01:00 UTC, **every night**: full E2E +
  pgTAP, tracking issue), then `upgrade-guard.yml` (**Tue+Fri**, after that night's green
  nightly → skill `upgrade-guard`: stack upgrades —
  auto-merges the patch/minor lot only when the full gate + E2E + pgTAP are green, one PR
  per major, never bundled), and `content-audit.yml` (**Wed+Sat** 22:07 UTC → skill
  `content-audit`: re-solves every question in the content changed that week, opens one
  tracking issue per BLOCKER/MAJOR — review-only, the correctness net the deterministic
  content gate can't be). None ever push to `main` directly (only `automerge` merges a
  fully-green patch/minor PR). Cadence + traps: `docs/dependency-maintenance.md`.
- **Policy docs (`docs/*.md`).** Topic-specific rules referenced from here:
  `docs/environment-variables.md`, `docs/logging-standard.md`, `docs/xss-rendering-policy.md`,
  `docs/content-voice-and-composition.md` (étude 15 — voix/ton par audience, lexique trilingue,
  règles et gabarits de composition des écrans : normatif pour tout texte user-facing),
  `docs/release-tagging-policy.md`, `docs/dependency-maintenance.md`,
  `docs/ci-cd-and-branch-protection.md`, `docs/passation.md` (the end-of-dev →
  production walkthrough), `docs/content-generation-pipeline.md` (narrated, diagrammed
  walkthrough of the content workflows/pipeline — skills, gates, UUIDv5 idempotency, prod
  auto-apply — a companion to this file, `content/README.md`, and the skills' own
  `generation-pipeline.md`), `docs/interactive-question-types.md` (the normative spec for
  native interactive question types — numeric/ordering/matching/multi-select: data model,
  the five type-aware scoring RPCs, UI/pipeline touchpoints, phased rollout — **all three
  phases (B1 `numeric`, B2 `ordering`/`matching`, B3 `multi`) shipped 2026-07-05/06**, étude
  `FableEtudes/03-types-questions-natifs` (fully executed); the QCM-encodable
  interactive formats live in `content-engine/references/interactive-formats.md`), and
  `docs/lycee-architecture.md` (secondary-cycle architecture: sections as grade nodes +
  slugs/subject-id conventions, the ar→fr language switch (native-French authoring, official
  jargon, no translation — décision 2026-07-13), bac-\* parcours (premium dormant), the full
  lycée mission ladder incl. `NN-annales-bac`, seed-migration spec and
  phased rollout). Two **functional** how-to guides (audience: authors / product / ops, French)
  complement the normative specs above: `docs/guide-types-questions-natifs.md` (étude 03 — when to
  use each native question type + the authoring shapes) and `docs/guide-duels-et-ligues.md` (étude
  05 — the duel/league player flow, game constants, pg_cron jobs, optional Realtime, ops notes).
  These defer
  to AGENTS.md / ARCHITECTURE.md for anything that overlaps.
- **Epic studies (`FableEtudes/`).** Complete functional + technical architecture dossiers for
  the project's epics — 16 studies, from paiement en ligne (**gelée** post-pivot gratuité) to
  ouverture du lycée; several are already **delivered** (03 types natifs, 05 duels/ligues,
  13 ScribeKit, 14 refonte UX) — statuses live in the index and in `STATUS.md`. Written by the
  architect model and executed **lot by lot** by a
  cheaper executor model. Start at [`FableEtudes/README.md`](./FableEtudes/README.md): roles
  (architect decides, executor implements, human validates), study lifecycle/statuses, the
  `_TEMPLATE.md` format, and the non-negotiable execution rules (one lot = one PR, closed scope,
  STOP-and-escalate on any divergence, full DoD). An executor NEVER re-designs: when a study and
  the code disagree, it stops and escalates. Studies defer to AGENTS.md/ARCHITECTURE.md and to
  the normative `docs/*.md` they reference.

## Working mode — Definition of Done

A change is **done** only when ALL of these hold. This is non-negotiable; it is how
the project stays regression- and debt-free while being improved by AI.

1. **The gate is green.** Run `npm run verify` (lint + typecheck + tests). For
   release-grade work run `npm run ci:verify` (adds coverage + build + audit).
   Never report a task complete on a red gate. (Skill: `/verify`.)
2. **No weakening the gate.** Do not silence problems instead of fixing them:
   no `// @ts-ignore` / `as any` to dodge types, no disabling ESLint rules inline,
   no lowering Vitest coverage thresholds, no `--no-verify`. If an exception is
   truly warranted, get explicit sign-off and document _why_ in the code.
3. **No new tech debt.** No backward-compat shims, no dead code, no duplicated
   modules. Delete what you replace. Respect the feature/shared boundaries
   (features never import features).
4. **Types are real.** `tsc` must pass. The Supabase types in
   `src/shared/integrations/supabase/types.ts` are generated — prefer regenerating
   (`supabase gen types`) over hand-editing; if you must hand-edit (offline), keep it
   minimal and note it.
5. **Tests travel with code.** New/changed behavior ships with co-located tests in
   the feature's `__tests__/`. Coverage must not regress.
6. **Small, reviewable commits.** Branch off `main`; commit/push only when asked.
   Conventional-commit style messages (`feat:`, `fix:`, `test:`, `chore:`…).
7. **DB ↔ code changes are coordinated — prod migrations auto-apply, never by
   hand.** Pushing to `main` auto-deploys to Vercel **and** auto-applies any new
   `supabase/migrations/**` to the production Supabase DB via
   [`db-migrate-prod.yml`](.github/workflows/db-migrate-prod.yml) (it takes a
   pre-apply `pg_dump` backup, guards that the target really is prod, then runs
   `supabase db push`; it reuses the existing `PROD_SUPABASE_DB_URL` secret — no
   credentials ever leave GitHub). **Do NOT apply prod migrations manually** (no
   SQL editor, no local `db push`): author the migration, merge it, the workflow
   applies it. It can also be dispatched by hand — `push` / read-only `list` /
   one-time `repair-all` — from the Actions tab or
   `gh workflow run db-migrate-prod.yml`. An **hourly reconciliation** run also
   catches merges whose push fired no workflow events (auto-merge squashes are
   performed with `GITHUB_TOKEN`): it compares main's newest migration to prod's
   history and applies any pending ones — prod can never silently fall behind
   for more than an hour. Additive migrations are safe ahead of
   the code that uses them, so the order still holds: land the migration (it
   applies on merge) → then the dependent code. Ship a **destructive** migration
   (DROP/REVOKE) in a **separate** merge, **after** the code that stopped using the
   old shape is live. The `pgTAP suite` check proves every migration applies
   cleanly on a fresh DB before merge.
8. **A pushed branch is the session's PR to LAND — Mohamed never touches the PR
   lifecycle (décision 2026-07-12).** The chain is 100 % automatic: the push opens
   the PR ready with auto-merge armed, and it merges alone when the required checks
   are green on an up-to-date head — no human reads, readies or merges anything.
   The session that pushed stays on duty until the merge is real: watch the checks
   (`gh pr checks <n> --watch`), fix any red check and push the fix, confirm the
   merge actually happened, then clean up (prune the local branch/worktree; the
   remote branch auto-deletes). Deliberate savepoint? Push with `[wip]`/`[draft]`
   in the subject (or a `wip/`/`draft/`/`rescue/` branch) and own its promotion
   later. Before ending, sweep `gh pr list` for `needs-rebase` or armed-but-red
   PRs and rescue what you can. Never end a session with its PR unmerged unless a
   written blocker says why (PR comment or STATUS.md).

When unsure about scope or a destructive action, ask before proceeding.

## Known gotchas / traps

- **Feature/shared migration is complete.** All backward-compat re-export shims
  (`src/lib/gamification.*`, `dashboard-helpers`, `family-link`, `guest-access`) and the
  duplicated `src/lib/*` utils / `src/integrations/supabase/*` / `src/hooks/use-auth` /
  `src/components/dashboard/*` copies have been removed. Canonical homes:
  server fns + helpers → `@/features/{name}`; utils/logger/supabase/types → `@/shared/*`.
- **Not yet relocated to `shared/` (still real code, not shims):** i18n lives at `@/lib/i18n`,
  the mobile hook at `@/hooks/use-mobile`, and shadcn UI primitives at `@/components/ui/*`.
  There is **no `src/shared/ui`** directory — import UI primitives as `@/components/ui/*`
  (the `@/*` alias maps to `./src/*`). There is no `src/integrations/` directory either; the
  Supabase client/middleware live at `@/shared/integrations/supabase/*`. The `useAuth` hook
  lives at `@/features/auth` (not `@/hooks`).
- `src/routeTree.gen.ts` is auto-generated — never edit by hand.
- `src/shared/integrations/supabase/auth-middleware.ts` is marked "automatically generated";
  edit with care.
- Env vars required at runtime: `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY` (set in the deploy
  platform). Missing → middleware throws a descriptive error.
- The Vite config is **inline** in `vite.config.ts` — the TanStack Start, React, Tailwind,
  Cloudflare and tsconfig-paths plugins are composed by hand (the scaffold's old vendored
  meta-plugin was de-vendored and `bun.lock` dropped).
  `manualChunks` there is hand-tuned to the bundle budgets; reshaping vendor groups can
  introduce a circular vendor chunk (prod-crash risk), so change it deliberately and re-run
  `npm run build:check`. The `esbuild` override in `package.json` is a security pin — keep it.
- **Coverage is scoped to owned code** (`features/`, `shared/`, `lib/`, `hooks/`) in
  `vitest.config.ts`; vendored shadcn UI (`components/ui`), thin route wrappers,
  barrels, generated files, and SSR entry glue are excluded by design. Thresholds are
  **80%** on all metrics (actual ≈ 93% stmts / 93% lines / 81% branches). Don't lower them,
  and don't widen `include` to dilute the metric with vendored/glue code.
- Some server fns defensively tolerate missing RPCs (e.g. `get_best_scores_by_exercise`
  falls back to empty) — keep that graceful-degradation pattern.
- **New tables need EXPLICIT grants.** The base migrations carry almost no `GRANT`s, and
  the CI local stack (db-tests.yml) stopped applying Supabase's default table privileges
  (supabase/postgres ≥ 17.6.1.134): a `CREATE TABLE` without its own
  `GRANT SELECT … TO authenticated` works on cloud but breaks the nightly pgTAP suite on a
  fresh DB. The end-state baseline lives in `20260612221000_baseline_table_grants.sql`;
  every new table migration must ship its own grants. The Supabase CLI is **version-pinned**
  in `db-tests.yml` / `e2e-auth.yml` — bump deliberately, with a green run.
- **Migrations must be in timestamp order — a back-dated file jams prod.** Supabase applies
  migrations in 14-digit-timestamp order and refuses to insert one _before_ the last-applied
  remote migration (without `--include-all`), so a new migration whose `YYYYMMDDHHMMSS_` prefix
  sorts at/before a migration already on `main` makes `supabase db push` abort — silently
  stalling every later migration and leaving **prod behind code** (this cost #97 → #227 → #229).
  The **`Migration order`** PR check (`migration-gate.yml` → `scripts/db/check-migration-order.mjs`)
  now fails such a PR pre-merge; when it fires, re-timestamp the file to sort _after_ the newest
  existing migration. If an auto-apply ever does fail, `db-migrate-prod.yml` opens a
  **`prod-migration-failure`** tracking issue (auto-closed on the next green apply).
- **E2E ≠ unit gate.** Playwright specs (`e2e/`, run via `e2e.yml` / `e2e-auth.yml`) hit a
  **dedicated TEST Supabase project** with seeded users (`scripts/e2e/`), not the unit-test
  mocks. They are not part of `npm run verify`/`ci:verify`; don't point them at prod.
- **CI workflow runs a subset.** `.github/workflows/ci.yml` runs lint + typecheck +
  test:coverage + **content:check + content:qa:strict** + build:check + **smoke:shell** +
  audit:deps. `smoke:shell` (incident 2026-07-01) loads the REAL production bundle in a
  Chromium and fails on any page error or branded error page: it is the only tier that
  executes prod-gated client code (`import.meta.env.PROD`) — tsc can see `any` (unregistered
  router), the unit gate excludes route glue, SSR never runs effects, and the Playwright e2e
  tier runs the DEV server. A green gate without it proved compatible with a dead prod. The content
  gate is now enforced on every PR (it used to be local-only via `ci:verify`); `content:qa:strict`
  fails CI on any `[error]` (warnings still only surface). `content:qa:strict` catches **structure/
  notation**, not **correctness** — a wrong answer key passes it; that's what the scheduled
  `content-audit.yml` sweep is for (below).
- The Copilot guide (`.github/copilot-instructions.md`) still references `@/shared/ui/` for UI
  primitives — that move never happened; use `@/components/ui/*` (same drift noted above).
