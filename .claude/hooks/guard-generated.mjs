#!/usr/bin/env node
// Claude Code PreToolUse hook (Edit|Write|MultiEdit).
// Hard-blocks edits to GENERATED files that must never be hand-edited — the most
// frequently-warned trap in AGENTS.md. Deterministic, zero model cost (no agent call).
//
// Blocked paths:
//   - src/routeTree.gen.ts                            (TanStack route tree — auto-generated)
//   - src/shared/integrations/supabase/types.ts       (supabase gen types)
//   - supabase/migrations/*_generated_*_content.sql   (content pipeline output)
//   - .agents/skills/**                               (harness skills mirror — étude 25 lot 3;
//                                                        edit .claude/skills/ then `npm run
//                                                        harness:sync`. Pre-armed in lot 2, ahead
//                                                        of the mirror itself landing in lot 3.)
//   - .claude/settings.json                           (compiled from harness/policy.json +
//                                                        the hooks wired in scripts/harness/sync.mjs)
//
// Hand-authored migrations (e.g. 20260610_revoke_*.sql) are NOT blocked — only the
// content-generated ones the build owns. To block, the hook exits with code 2 and
// writes the reason to stderr; Claude Code feeds a PreToolUse exit-2 stderr back to
// the model and denies the tool call. Any other situation exits 0 (never blocks).
let raw = "";
process.stdin.setEncoding("utf8");
process.stdin.on("data", (chunk) => {
  raw += chunk;
});
process.stdin.on("end", () => {
  let payload;
  try {
    payload = JSON.parse(raw || "{}");
  } catch {
    process.exit(0); // never block on a parse hiccup
  }

  const filePath = payload?.tool_input?.file_path ?? payload?.tool_input?.filePath ?? "";
  if (typeof filePath !== "string" || filePath === "") {
    process.exit(0);
  }

  // Normalize Windows backslashes so the patterns match on any platform.
  const p = filePath.replace(/\\/g, "/");

  const isGenerated =
    /(^|\/)src\/routeTree\.gen\.ts$/.test(p) ||
    /(^|\/)src\/shared\/integrations\/supabase\/types\.ts$/.test(p) ||
    /(^|\/)supabase\/migrations\/[^/]*_generated_[^/]*_content\.sql$/.test(p);
  const isHarnessSkillsMirror = /(^|\/)\.agents\/skills\//.test(p);
  const isHarnessGeneratedView = /(^|\/)\.claude\/settings\.json$/.test(p);

  if (isGenerated) {
    process.stderr.write(
      `Blocked: "${filePath}" is a GENERATED file and must not be hand-edited.\n` +
        `Regenerate it at its source instead:\n` +
        `  - src/routeTree.gen.ts → produced by the TanStack router plugin (runs on dev/build).\n` +
        `  - src/shared/integrations/supabase/types.ts → \`supabase gen types\`.\n` +
        `  - supabase/migrations/*_generated_*_content.sql → edit content/ then \`npm run content:build\`.\n`,
    );
    process.exit(2);
  }

  if (isHarnessSkillsMirror) {
    process.stderr.write(
      `Blocked: "${filePath}" is under the GENERATED harness skills mirror (.agents/skills/).\n` +
        `Edit the source skill under .claude/skills/ instead, then run \`npm run harness:sync\`.\n`,
    );
    process.exit(2);
  }

  if (isHarnessGeneratedView) {
    process.stderr.write(
      `Blocked: "${filePath}" is GENERATED from the harness sources (étude 25 D-4).\n` +
        `Edit the source instead, then run \`npm run harness:sync\`:\n` +
        `  - permissions (allow/deny) → harness/policy.json\n` +
        `  - the hooks wiring → scripts/harness/sync.mjs (buildClaudeSettings)\n` +
        `  - the pre-commit checks themselves → .claude/hooks/precommit-checks.mjs\n`,
    );
    process.exit(2);
  }

  process.exit(0);
});
