---
name: verify
description: >-
  Run the local quality gate for yahia-quest-arena before declaring any task
  done or pushing. Runs lint + typecheck + tests (and optionally the full CI
  gate with coverage + build). Use whenever the user asks to "verify", "check
  before push", confirm a change is safe, or after finishing an implementation.
---

# Local quality gate

This project ships with a strict, zero-warning gate. **Never declare a coding
task complete until this gate is green.**

## Steps

1. Run the fast gate:

   ```bash
   npm run verify
   ```

   This runs, in order:
   - `npm run lint` — ESLint, `--max-warnings=0` (Prettier rules included).
   - `npm run typecheck` — `tsc --noEmit` (strict).
   - `npm run test` — Vitest (full suite).

2. If anything fails:
   - Read the actual error output; do not guess.
   - Fix the **root cause** in the source — do not weaken the gate
     (no disabling ESLint rules, no `// @ts-ignore`, no lowering coverage
     thresholds, no `--no-verify`) unless the user explicitly approves and you
     document why.
   - Re-run `npm run verify` until clean.

3. For a release-grade check (matches CI exactly), also run:

   ```bash
   npm run ci:verify
   ```

   This adds `test:coverage` (enforces coverage thresholds), `build:check`
   (production build + bundle budget), `audit:deps`, and the content gates
   `content:qa:strict` + `content:audit:strict`.

## Reporting

End with a clear go/no-go:

- ✅ green: state which steps passed.
- ❌ red: name the failing step, the root cause, and what you changed (or what
  remains) — never report success on a red gate.
