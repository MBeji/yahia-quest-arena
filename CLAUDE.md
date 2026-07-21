# CLAUDE.md

@AGENTS.md

<!-- Claude Code specific — not read by other tools. Everything else lives in AGENTS.md. -->

- Skills auto-discover from [`.claude/skills/`](./.claude/skills/) (mirrored at
  `.agents/skills/` for other tools) — descriptions are injected automatically; invoke by
  name (`/verify`, `/code-review`, …) or let the model trigger them from context.
- A `PreToolUse` command hook (`.claude/hooks/precommit-checks.mjs`) runs a fast, deterministic
  pass on the staged diff before `git commit` — blocking on hardcoded secrets, `@ts-ignore`/
  `@ts-nocheck`, `--no-verify`, a lowered coverage threshold, or a destructive migration shipped
  with `src/**`. Semantic calls (is this cast/gate-bypass a real problem?) stay `/code-review` at
  PR time; the auth-middleware invariant is the ESLint rule `local/require-server-fn-auth`. Two
  sibling hooks (`guard-generated.mjs`, `format-changed.mjs`) block edits to generated files and
  auto-format changed files. (étude « IA → déterministe » lot L1 replaced the former agent hook.)
- Prefer a dedicated git worktree per parallel session (`.claude/worktrees/…`) to avoid
  collisions on a shared checkout.
- Auto-memory (this session's cross-conversation notes) is a personal cache, not a source of
  project truth — see AGENTS.md § Multi-agent collaboration.
