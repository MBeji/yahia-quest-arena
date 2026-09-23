# AGENTS.md — yahia-quest-arena (Na9ra Nal3ab)

> **Source de vérité unique pour tout contributeur, humain ou agent, quel que soit l'outil.**
> En cas de désaccord avec un autre document, ce fichier gagne — corriger l'autre. Les
> fichiers par outil (`CLAUDE.md`, `.github/copilot-instructions.md`, `.gemini/settings.json`)
> ne font que pointer ici : jamais de règle dupliquée. **État du projet** (phase, décisions
> datées, statut réel des features/études) : [`STATUS.md`](./STATUS.md) — à lire avant de
> croire un « X est-il en prod ? ».

## What this is

Gamified learning **academy**: students do "quests" (QCM exercises), earn XP/coins, unlock
badges, level up hero classes, compete on a leaderboard, and tackle a timed "dungeon" boss
mode. Shonen/RPG manga aesthetic, trilingual (FR/EN/AR, RTL).

**Catalogue**: `themes` → `grades` (school theme only, 13 Tunisian levels) → `subjects` →
`chapters` → `exercises` → `questions`. A **parcours** is the student's enrolled `(theme,
grade)` track (kinds `concours`/`scolaire`/`libre`).
**Free phase (since 2026-06-21)**: 100 % free — every parcours `is_premium = false`. The
paywall machinery stays in code but **dormant** (étude 01). No user-facing surface may say
"premium/abonnement/payant".

**Stack**: Vite 8 · TanStack Start (SSR + file routing + server fns) · React 19 · TanStack
Query 5 · Supabase (Postgres + Auth + RLS) · Tailwind 4 / Radix-shadcn · **Vercel** (push to
`main` = prod) · npm on **Node 24** (`.nvmrc`) · Vitest 4 + Testing Library · Playwright (e2e).

## Essential commands

```bash
npm run dev           # Vite dev server (SSR)
npm run verify        # the local gate: fast gates (eol, leak, db chain/types, harness) + lint + typecheck + test
npm run ci:verify     # release-grade superset: + perf, coverage, build:check, audit:deps
npm run harness:sync  # regenerate the per-tool views from harness/ (never hand-edit them)
npm run db:gen-types  # regenerate src/shared/integrations/supabase/types.ts from the migration chain
```

`lint` is zero-warning; `typecheck` covers the app AND the scripts (`tsconfig.scripts.json`).
The `content:*` / `programme:*` commands are the engine — their data lives in the private repo.
E2E targets a dedicated Supabase TEST project ([`e2e/README.md`](./e2e/README.md)), never prod.
Husky: `pre-commit` = lint-staged, `pre-push` = `verify` — never `--no-verify`.

## Data model & access

Full model: [`ARCHITECTURE.md`](./ARCHITECTURE.md) §8. Backbone: `profiles` + the catalogue
hierarchy + `attempts`. Server logic lives in SQL (`handle_new_user`, `award_xp`,
`submit_exercise_attempt` — the privileged ones are `REVOKE`d from anon/authenticated).
**Access is decided server-side only**, by `resolve_exercise_access`: the answer key
(`correct_option`, `distractor_tags`) is **never** sent to the client. Gameplay thresholds:
`src/shared/constants/gamification.ts`. **What a student has earned is recorded, never
recomputed**: chapter stars and subject seals live in an insert-only ledger no content change
can roll back — [`docs/etoiles-et-sceaux.md`](./docs/etoiles-et-sceaux.md).

## Content pipeline — the corpus is NOT in this repo (étude 24)

The corpus, its 43 pedagogical skills, `FableEtudes/` (études; the roadmap itself is `STATUS.md` §6) and the content
workflows live in the **private** repo
[`MBeji/yahia-quest-content`](https://github.com/MBeji/yahia-quest-content). To write content:
open the session there and `add_repo` this one. Only the generic, tested **engine** stays here
(`scripts/content/**`, `src/shared/content/**`), with `STATUS.md` and the <!--count:engine-skills-->5<!--/count--> technical skills.

⚠️ **Never re-commit corpus here.** `npm run leak:check` fails on `content/**`,
`sql/content/**`, a `content-*`/`prof-*` skill or a generated content migration. Content
compiles to `sql/content/<subject>.sql` and ships via the private `apply-content.yml`, never
as a migration. Details: [`docs/content-generation-pipeline.md`](./docs/content-generation-pipeline.md).

## Conventions

- Feature-based: `src/features/{name}/` (16 — ai, auth, bug-report, content-report, dashboard,
  dungeon, duel, exam, notifications, parcours, parent-report, progression, quest, shop,
  subscription, tutor ; `harness:check` fails if this list drifts from `src/features/`).
  Each has `index.ts` (barrel), `{name}.server.ts`, `__tests__/`.
  **Features never import other features** — share via `src/shared/`. Routes stay thin.
- Import aliases: `@/features/{name}`, `@/shared/lib|constants|types|integrations/...`.
  UI primitives: `@/components/ui/*`. i18n: `@/lib/i18n`. `useAuth`: `@/features/auth`.
- Every server fn carries an auth middleware — `requireSupabaseAuth`, or
  `optionalSupabaseAuth` for a deliberate public read (ESLint `local/require-server-fn-auth`),
  plus a zod `.inputValidator` whenever it takes input. Sanitize HTML with DOMPurify
  (`src/shared/lib/markdown.ts`).
- Kebab-case files, server fns are verbs. Log through `@/shared/lib/logger` (redacts
  secrets) — never raw `console`.

## Definition of Done

A change is **done** only when ALL of these hold:

1. **Gate is green** — `npm run verify` (release-grade: `npm run ci:verify`).
2. **No weakening the gate** — no `@ts-ignore`/`as any`, no inline ESLint disables, no
   lowered coverage thresholds, no `--no-verify`.
3. **No new tech debt** — no compat shims, no dead code, feature/shared boundaries respected.
4. **Types are real** — `tsc` passes; Supabase types are generated, never hand-edited.
5. **Tests travel with code** — co-located in `__tests__/`; coverage never regresses.
6. **Small, reviewable commits** — branch off `main`, conventional-commit messages.
7. **DB ↔ code coordinated — prod migrations auto-apply, never by hand.** Merging to `main`
   applies `supabase/migrations/**` via `db-migrate-prod.yml` (backup + guard + `db push`,
   hourly reconciliation). Never `supabase db push`/`db reset` against prod. Additive
   migrations land before the code that uses them; **destructive** ones (DROP/REVOKE) ship in
   a separate merge, once the old code path is gone.
8. **A pushed branch is the session's PR to land.** The push opens the PR with auto-merge
   armed; it merges alone once required checks are green on an up-to-date head. The session
   that pushed **stays on duty until the merge is real** (watch checks, fix reds, confirm),
   then closes clean — child sessions included. Savepoints use a **branch prefix**
   `wip/`/`draft/`/`rescue/`, never `[wip]` in a commit subject (it leaks into `main`).

Detail: [`docs/ci-cd-and-branch-protection.md`](./docs/ci-cd-and-branch-protection.md),
[`docs/passation.md`](./docs/passation.md) (§7 = session-close checklist).

**Definition of Excellence** (product side, étude 26): **depth before breadth** — deepening
wins by default over opening. Criteria and M0-M4 grid:
[`docs/doctrine-verticale.md`](./docs/doctrine-verticale.md).

## Execution policy

**Zero technical intervention by the owner**
([`docs/agents/zero-intervention.md`](./docs/agents/zero-intervention.md)): the owner gives
needs and arbitration, the session executes end to end — asking permission is a manual step.

Source of truth: [`harness/policy.json`](./harness/policy.json) (rules by family, each with its
reason), compiled by `npm run harness:sync` into the per-tool views; `harness:check` fails CI
on drift. Since 2026-09-05 everything is allowed (family `cloud-autonomy`); denials always win.
**Never**: `supabase db push`/`db reset`, `node scripts/db/push-prod.mjs`, `gh secret delete`,
nor dispatching `db-migrate-prod.yml` or `release.yml` — in cloud the MCP dispatch tool does
not know the names, so this written rule is what holds. The hard safety net stays the husky
hooks, the required checks and the absence of prod credentials locally.

## Multi-agent collaboration

Several agents and humans work concurrently. Branch prefix names the author (`claude/…`,
`codex/…`, `humain/<pseudo>/…`); one task = one PR on a distinct file set (reservation
protocol: `FableEtudes/CONTRIBUER.md`, private repo). The PR is the only coordination point.
Project knowledge found in a session goes into this repo (`AGENTS.md`, `STATUS.md`,
`docs/agents/`) — never only in a tool's private memory.

## Where to read next

[`ARCHITECTURE.md`](./ARCHITECTURE.md) (stack, structure, data model, deploy) ·
[`docs/agents/`](./docs/agents/README.md) (operational playbooks — start with
`zero-intervention.md`) · [`docs/journal-decisions.md`](./docs/journal-decisions.md)
(append-only decisions) · [`docs/dette-technique.md`](./docs/dette-technique.md) ·
[`docs/prod-rollback-runbook.md`](./docs/prod-rollback-runbook.md) (incident: freeze, rollback,
revert) · `docs/*.md` (topic specs: CI/CD, dependencies, env vars, logging, XSS, design
surfaces, question types…) · `harness/*.json` (models, policy, controls).

## Known gotchas

- **Generated, never hand-edited**: `src/routeTree.gen.ts`,
  `src/shared/integrations/supabase/types.ts`, `.agents/skills/**`, `.claude/settings.json`.
- **Migrations**: a new table needs explicit `GRANT`s; a migration must sort **after** the
  latest on `main`; prod is not the judge of rebuildability — `db:check-chain` replays the
  chain ([`docs/agents/pieges-du-code.md`](./docs/agents/pieges-du-code.md)).
- **An auth refusal is declared in `auth-refusals.ts`, nowhere else** — message AND client
  behaviour; the `Record<AuthFailure, …>` makes `tsc` fail on a missing line.
- **CI ≠ `verify`**: CI adds `build:check` and `smoke:shell` (the only stage running the prod
  bundle in Chromium). `ci:verify` is the closest local mirror.
- **Dependencies lie**: `audit:deps` queries the registry at run time (same commit, different
  verdict), and a Dependabot title can misstate its diff —
  [`docs/dependency-maintenance.md`](./docs/dependency-maintenance.md).
- **Coverage is scoped to owned code** (`features/`, `shared/`, `lib/`, `hooks/`) — never widen
  `include` to dilute it.
