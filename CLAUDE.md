# CLAUDE.md

@AGENTS.md

<!-- Claude Code specific — not read by other tools. Everything else lives in AGENTS.md. -->

- Skills auto-discover from [`.claude/skills/`](./.claude/skills/) (mirrored at
  `.agents/skills/` for other tools) — descriptions are injected automatically; invoke by
  name (`/verify`, `/code-review`, …) or let the model trigger them from context.
- A `PreToolUse` agent hook runs a fast, bounded review on the staged diff before `git commit`
  (blocking on secrets, gate-weakening, missing auth middleware — never a full architecture
  review; that's `/code-review` at PR time). Deterministic hooks
  (`.claude/hooks/guard-generated.mjs`, `format-changed.mjs`) block edits to generated files
  and auto-format changed files.
- Prefer a dedicated git worktree per parallel session (`.claude/worktrees/…`) to avoid
  collisions on a shared checkout.
- Auto-memory (this session's cross-conversation notes) is a personal cache, not a source of
  project truth — see AGENTS.md § Multi-agent collaboration.
