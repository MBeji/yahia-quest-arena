#!/usr/bin/env node
// Claude Code PreToolUse hook (Bash — `if: Bash(git commit*)`).
// Replaces the pre-commit AGENT guard with a deterministic pass (étude "IA → déterministe",
// lot L1). Same intent — a fast, targeted look at the staged diff, NOT an architecture
// review — but as a script it runs in < 1 s, spends zero tokens, and gives the same verdict
// every time. The semantic checks the agent also did (does this cast/disable hide a real
// problem? does this bypass an anti-cheat/premium/RLS gate?) are NOT mechanical, so they move
// to /code-review at the PR — exactly where the old prompt said they belonged.
//
// What it BLOCKS (added lines of the staged diff — `git diff --cached -U0`):
//   1. a hardcoded secret/key/token (high-precision patterns), outside docs/.env.example;
//   2. `@ts-ignore` / `@ts-nocheck` — a type-gate dodge (DoD §2; `@ts-expect-error`, the
//      reviewed alternative, is allowed);
//   3. `--no-verify` written into committed code/config — bypassing the gate (DoD §2/§8);
//   4. a LOWERED coverage threshold in vitest.config (DoD §2);
//   5. a destructive migration (DROP TABLE/COLUMN/CONSTRAINT) committed together with `src/**`
//      — ship destructive SQL in its own commit, after the old code path is gone (DoD §7).
//
// What it deliberately does NOT block: `as any` and inline `eslint-disable`. Both have many
// legitimate uses in this codebase (35 `as any`, 4 disables in src today), so a hard block
// would be a false-positive machine that breaks every commit; whether a given one is a real
// dodge is a semantic call left to /code-review. Generated-file edits stay covered by
// `guard-generated.mjs`.
//
// To block, the hook writes the findings to stderr and exits 2 — Claude Code feeds a
// PreToolUse exit-2 stderr back to the model and denies the `git commit`. Any other situation
// (not a commit, empty diff, git/parse error) exits 0 and never blocks: the real gates stay
// the husky pre-push `verify`, the required CI checks, and GitHub push-protection.
import { execFileSync } from "node:child_process";
import { pathToFileURL } from "node:url";

/** Documentation / example files — their contents are illustrative, not real. */
export function isSecretExemptPath(path) {
  return (
    /\.mdx?$/i.test(path) ||
    path.startsWith("docs/") ||
    /(^|\/)\.env\.example$/.test(path) ||
    /\.example$/.test(path)
  );
}

/**
 * Files where the string-pattern scans (secrets, `@ts-ignore`, `--no-verify`) don't apply:
 * docs & example envs, test fixtures (which carry sample tokens and pattern literals on
 * purpose), and the hook tooling itself under `.claude/hooks/` (a scanner that references
 * the very patterns it detects must not match its own source). App code and real config
 * are always scanned. The path-scoped checks (migration, coverage) are not gated on this —
 * they only ever look at `supabase/migrations/**` and `vitest.config.*`.
 */
export function isPatternScanExempt(path) {
  return (
    isSecretExemptPath(path) ||
    /(^|\/)__tests__\//.test(path) ||
    /\.(test|spec)\.[cm]?[jt]sx?$/.test(path) ||
    path.startsWith(".claude/hooks/")
  );
}

// High-precision secret patterns: each matches a real credential SHAPE, not a keyword, so a
// variable named `token` or a fake `mock-key` does not trip it. Validated against the tree:
// zero matches in committable files at authoring time.
const SECRET_PATTERNS = [
  { name: "JSON Web Token", re: /eyJ[A-Za-z0-9_-]{6,}\.eyJ[A-Za-z0-9_-]{6,}\.[A-Za-z0-9_-]{6,}/ },
  { name: "PEM private key", re: /-----BEGIN(?:[A-Z ]+)? PRIVATE KEY-----/ },
  { name: "AWS access key id", re: /\bAKIA[0-9A-Z]{16}\b/ },
  { name: "GitHub token", re: /\bgh[pousr]_[A-Za-z0-9]{36,}\b/ },
  { name: "OpenAI/Anthropic key", re: /\bsk-(?:ant-)?[A-Za-z0-9_-]{24,}\b/ },
  { name: "Google API key", re: /\bAIza[0-9A-Za-z_-]{35}\b/ },
  { name: "Slack token", re: /\bxox[baprs]-[A-Za-z0-9-]{10,}\b/ },
];

const DESTRUCTIVE_SQL = /\b(?:DROP\s+TABLE|DROP\s+COLUMN|DROP\s+CONSTRAINT)\b/i;
const COVERAGE_KEYS = /\b(lines|statements|functions|branches)\s*:\s*(\d+(?:\.\d+)?)\b/g;

/**
 * Parse `git diff --cached -U0` into per-file added/removed lines.
 * @returns {{ path: string, added: {line:number,text:string}[], removed: string[] }[]}
 */
export function parseStagedDiff(diffText) {
  const files = [];
  let current = null;
  let newLine = 0;
  for (const raw of diffText.split("\n")) {
    if (raw.startsWith("+++ ")) {
      // "+++ b/path" (or "+++ /dev/null" for a deletion).
      const path = raw.slice(4).replace(/^b\//, "");
      current = { path, added: [], removed: [] };
      if (path !== "/dev/null") files.push(current);
      continue;
    }
    if (raw.startsWith("--- ")) continue;
    if (raw.startsWith("@@")) {
      // "@@ -old,n +new,m @@" — track the new-file line counter.
      const m = /\+(\d+)/.exec(raw);
      newLine = m ? Number(m[1]) : 0;
      continue;
    }
    if (!current) continue;
    if (raw.startsWith("+")) {
      current.added.push({ line: newLine, text: raw.slice(1) });
      newLine += 1;
    } else if (raw.startsWith("-")) {
      current.removed.push(raw.slice(1));
    }
  }
  return files;
}

/** Collect coverage-threshold `key: number` pairs from a set of diff lines. */
function thresholdsOf(lines) {
  const out = {};
  for (const text of lines) {
    for (const m of text.matchAll(COVERAGE_KEYS)) out[m[1]] = Number(m[2]);
  }
  return out;
}

/**
 * Run every deterministic check over the parsed staged diff.
 * @returns {{ file: string, line: number|null, rule: string, message: string }[]}
 */
export function findViolations(files) {
  const findings = [];
  const paths = files.map((f) => f.path);
  const touchesSrc = paths.some((p) => p.startsWith("src/"));

  for (const file of files) {
    const exempt = isPatternScanExempt(file.path);
    const isVitestConfig = /(^|\/)vitest\.config\.[cm]?[jt]s$/.test(file.path);
    const isMigration = /(^|\/)supabase\/migrations\/.*\.sql$/.test(file.path);

    for (const { line, text } of file.added) {
      if (!exempt) {
        for (const { name, re } of SECRET_PATTERNS) {
          if (re.test(text)) {
            findings.push({
              file: file.path,
              line,
              rule: "secret",
              message: `possible hardcoded secret (${name}). Move it to an env var / secret store; never commit credentials.`,
            });
          }
        }
        if (/@ts-ignore\b|@ts-nocheck\b/.test(text)) {
          findings.push({
            file: file.path,
            line,
            rule: "ts-suppress",
            message:
              "`@ts-ignore`/`@ts-nocheck` dodges the type gate (DoD §2). Fix the type, or use a justified `@ts-expect-error`.",
          });
        }
        if (/--no-verify\b/.test(text)) {
          findings.push({
            file: file.path,
            line,
            rule: "no-verify",
            message: "`--no-verify` bypasses the git hooks (DoD §2/§8). Remove it.",
          });
        }
      }
      if (isMigration && DESTRUCTIVE_SQL.test(text) && touchesSrc) {
        findings.push({
          file: file.path,
          line,
          rule: "destructive-migration",
          message:
            "destructive migration (DROP TABLE/COLUMN/CONSTRAINT) committed with src/** — ship it in its own commit, after the old code path is gone (DoD §7).",
        });
      }
    }

    if (isVitestConfig) {
      const before = thresholdsOf(file.removed);
      const after = thresholdsOf(file.added.map((a) => a.text));
      for (const key of Object.keys(after)) {
        if (key in before && after[key] < before[key]) {
          findings.push({
            file: file.path,
            line: null,
            rule: "coverage-threshold",
            message: `coverage threshold '${key}' lowered ${before[key]} → ${after[key]} (DoD §2: coverage never regresses).`,
          });
        }
      }
    }
  }
  return findings;
}

/** Format findings for the stderr block message. */
export function formatFindings(findings) {
  const lines = ["✗ Pre-commit checks blocked this commit:\n"];
  for (const f of findings) {
    const at = f.line === null ? f.file : `${f.file}:${f.line}`;
    lines.push(`  • [${f.rule}] ${at}\n      ${f.message}`);
  }
  lines.push(
    "\nThese are deterministic, high-signal checks. Fix them, or if a finding is a false positive, adjust the change so it no longer matches (the full semantic review happens at /code-review on the PR).",
  );
  return lines.join("\n");
}

/** Read the staged diff and run the checks. Returns findings (empty = allow). */
export function analyzeStaged(run = (args) => execFileSync("git", args, { encoding: "utf8" })) {
  const diff = run(["diff", "--cached", "-U0", "--no-color"]);
  if (!diff.trim()) return [];
  return findViolations(parseStagedDiff(diff));
}

function readStdin() {
  return new Promise((resolve) => {
    let raw = "";
    process.stdin.setEncoding("utf8");
    process.stdin.on("data", (c) => (raw += c));
    process.stdin.on("end", () => resolve(raw));
    process.stdin.on("error", () => resolve(""));
  });
}

async function main() {
  const raw = await readStdin();
  let command = "";
  try {
    command = JSON.parse(raw || "{}")?.tool_input?.command ?? "";
  } catch {
    process.exit(0); // never block on a parse hiccup
  }
  // Belt-and-suspenders with the `if: Bash(git commit*)` matcher: only act on a real commit.
  if (!/\bgit\b[^\n]*\bcommit\b/.test(command)) process.exit(0);

  let findings;
  try {
    findings = analyzeStaged();
  } catch {
    process.exit(0); // git failed → fail open; the pre-push gate + CI still run
  }

  if (findings.length > 0) {
    process.stderr.write(`${formatFindings(findings)}\n`);
    process.exit(2);
  }
  process.exit(0);
}

// CLI only — the pure helpers above stay importable from tests.
if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  main();
}
