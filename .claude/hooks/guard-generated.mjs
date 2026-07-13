#!/usr/bin/env node
// Claude Code PreToolUse hook (Edit|Write|MultiEdit).
// Hard-blocks edits to GENERATED files that must never be hand-edited — the most
// frequently-warned trap in CLAUDE.md. Deterministic, zero model cost (no agent call).
//
// Blocked paths:
//   - src/routeTree.gen.ts                            (TanStack route tree — auto-generated)
//   - src/shared/integrations/supabase/types.ts       (supabase gen types)
//   - supabase/migrations/*_generated_*_content.sql   (content pipeline output)
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

  process.exit(0);
});
