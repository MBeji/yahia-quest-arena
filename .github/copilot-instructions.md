---
applyTo: "**"
---

# Copilot instructions — Na9ra Nal3ab

`AGENTS.md` at the repo root is the **single canonical source of truth** for this codebase —
conventions, import paths, the data model, the content pipeline, testing, execution policy,
and the Definition of Done. GitHub Copilot reads it natively (VS Code Chat, coding agent, CLI,
code review); this file exists only so repo-scoped custom instructions are also active for
older Copilot surfaces. Do not restate AGENTS.md's rules here — they drift; read AGENTS.md.

One exception worth stating up front, because it changes where files belong: since étude 24
(2026-07-20) the **pedagogical corpus and the generation skills live in the PRIVATE repo**
`MBeji/yahia-quest-content`. This repo keeps only the generic, corpus-free engine
(`scripts/content/`, `src/shared/content/`). Never create or restore `content/**`, a
`content-*`/`prof-*`/`curriculum-architect` skill, or a generated content migration here —
`npm run leak:check` fails the build on any of them. Details:
`docs/content-generation-pipeline.md`.
