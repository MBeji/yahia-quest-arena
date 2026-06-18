# Dependency Maintenance Cadence

## Goal

Keep runtime and dev dependencies secure and up to date with predictable operational risk.

## Cadence

- **Twice-weekly (automated): the upgrade guard** (Tue + Fri UTC) — see "Automation"
  below. This is now the primary path; the manual cadence below is the fallback /
  oversight layer.
- Monthly: review outdated packages and security advisories (Dependabot still opens
  its monthly PRs as a backstop).
- Weekly: triage any guard PRs/issues and Dependabot PRs.
- Immediate: patch high/critical vulnerabilities.

## Automation (twice-weekly upgrade guard)

The `.claude/skills/upgrade-guard` skill, run by `.github/workflows/upgrade-guard.yml`,
performs this Process automatically **on Tue + Fri (UTC), after the Nightly tests pass**
(so it only upgrades from a known-green baseline). It was throttled from nightly to
2×/week to keep the agent's runner time + PR/issue noise reasonable — the agent holds a runner for many minutes; a
manual `workflow_dispatch` runs it any other day. It covers npm runtime + dev deps,
TypeScript, the Node toolchain, the pinned Supabase CLI, and the GitHub Actions.

- **Patch + minor** are applied as one lot, the full gate + E2E (public + authed) +
  pgTAP are run on the branch, and the PR is **auto-merged only when all of them are
  green** (a graceful-skipped suite is not "green" → the PR is left for manual merge).
- **Each major** is attempted in isolation — **one PR per major, never bundled** — with
  a changelog summary; a major whose gate stays red becomes a **tracking issue**, not a
  broken PR. Majors are **never auto-merged** (human changelog review).
- The guard **never weakens the gate** and **never pushes to `main`** itself; the
  deterministic `automerge` job is the only thing that merges, and only the fully-green
  patch/minor PR. The repo-specific upgrade traps (npm 10 lockfile, global esbuild
  override on Vite 8, react-hooks 7 `recommended`, react-refresh on `src/routes/**`, the
  do-not-touch `motion`/LazyMotion refactor, the Lovable meta-plugin, the Supabase CLI
  pin → validate pgTAP) live in the skill and must be honoured.

Prereq: the `CLAUDE_CODE_OAUTH_TOKEN` secret (shared with `regression-guard`); without
it the workflow skips gracefully.

## Process

1. Run `npm outdated`.
2. Run `npm run audit:deps`.
3. Group upgrades by risk: patch, minor, major.
4. Prefer patch/minor first, then major with dedicated validation.
5. Validate with `npm run lint`, `npm run test:coverage`, `npm run build:check`.
6. Document notable upgrades in release notes.

## Rules

- Never merge dependency updates without CI green.
- For major upgrades, require explicit changelog review.
- Keep lockfile committed and reviewed.
