# CLAUDE.md

@AGENTS.md

Claude-only wiring (everything else is in AGENTS.md):

- Skills live in [`.claude/skills/`](./.claude/skills/) (mirrored to `.agents/skills/` by
  `harness:sync`); invoke by name (`/verify`, `/code-review`, …).
- Hooks in [`.claude/hooks/`](./.claude/hooks/), wired by `harness:sync` into
  `.claude/settings.json`: `precommit-checks` (blocks secrets, `@ts-ignore`, `--no-verify`,
  lowered coverage, destructive migration + `src/**` in one commit), `guard-generated`,
  `format-changed`, and `session-start` (cloud sessions only: Node from `.nvmrc`, `npm install`,
  CA chain from `scripts/cloud/ca-chain/`, network-allowlist probe).
- One worktree per parallel session (`.claude/worktrees/…`). Auto-memory is a personal cache,
  not project truth.
