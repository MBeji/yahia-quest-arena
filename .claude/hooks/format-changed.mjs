#!/usr/bin/env node
// Claude Code PostToolUse hook.
// After Claude edits/creates a file, auto-format it with Prettier so the
// codebase never accumulates formatting drift (the project enforces a
// zero-warning Prettier/ESLint policy). Formatting failures never block the edit.
import { execSync } from "node:child_process";

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
    process.exit(0);
  }

  const filePath = payload?.tool_input?.file_path ?? payload?.tool_input?.filePath;
  if (
    typeof filePath !== "string" ||
    !/\.(ts|tsx|js|jsx|mjs|cjs|json|css|md|html|ya?ml)$/i.test(filePath)
  ) {
    process.exit(0);
  }

  try {
    execSync(`npx prettier --write "${filePath}"`, { stdio: "ignore" });
  } catch {
    // Never fail the tool call because of a formatting hiccup.
  }
  process.exit(0);
});
