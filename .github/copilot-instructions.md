---
applyTo: "**"
---

# Copilot instructions — Na9ra Nal3ab

## Canonical sources (read these first)

`CLAUDE.md` and `ARCHITECTURE.md` at the repo root are the **single source of truth** for
this codebase — conventions, import paths, the data model, the content pipeline, testing,
and the Definition of Done. When anything here disagrees with them, they win. Do not restate
their rules here (they drift); read them and follow them.

This file only carries Copilot-specific reminders that aren't worth a round-trip to the
canonical docs:

- **Honor the feature/shared boundary.** Each feature lives in `src/features/{name}/` and is
  self-contained; features never import other features (share via `src/shared/`). Routes are
  thin. Import UI primitives from `@/components/ui/*` (there is no `@/shared/ui`).
- **Server functions** use `createServerFn` from `@tanstack/react-start` with the
  `requireSupabaseAuth` middleware and a zod `.inputValidator` — see ARCHITECTURE.md §6.
- **Don't suggest weakening the gate**: no `any`/`@ts-ignore`/`as any` to dodge types, no
  inline ESLint disables, no lowering coverage thresholds, no `--no-verify`. New/changed
  behavior ships with co-located tests in the feature's `__tests__/`.
- **Logging** goes through `@/shared/lib/logger`, never raw `console`. HTML is sanitized via
  `@/shared/lib/markdown` (DOMPurify).
- **Subject content** is generated, not hand-written: edit `content/` and run
  `npm run content:build` (see CLAUDE.md "Subsystems & further docs"). Migrations must be
  applied to the DB before the dependent code is deployed.
