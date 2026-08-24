#!/usr/bin/env node
/**
 * Strict-YAML gate for `.github/**` — the CI failure that leaves nothing to read.
 *
 * On 2026-08-24 `auto-pr.yml` stopped running for the WHOLE repo: conclusion
 * `failure`, zero jobs, and `gh run view --log-failed` answering "log not found".
 * Two sessions had diagnosed the same defect (the dispatch ran with the PAT,
 * which lacks `actions: write`) and shipped the same fix twice — PR #830 and
 * PR #832 — leaving two `GH_TOKEN:` keys thirteen lines apart in one `env:`
 * block, each behind its own wall of explanatory comments. GitHub's Actions
 * parser refuses a duplicate mapping key and ends the run as `startup_failure`
 * BEFORE any job exists, which is why there is no log and no annotation.
 *
 * Nothing in this repo could see that defect:
 *   - `yaml.safe_load` and most linters ACCEPT a duplicate (last key wins), so
 *     "the YAML is valid" was true and useless;
 *   - the guard-of-guards (#831) counts red runs of the CRON workflows, and
 *     `auto-pr.yml` triggers on `push`;
 *   - a run with zero jobs produces no annotation for anyone to read.
 *
 * Fifth case of "a guard that goes quiet is indistinguishable from a guard that
 * passes" (lesson L-2). Hence a parser, not a convention.
 *
 * WHY A REAL PARSER, NOT A REGEX. A hand-rolled scanner has to understand block
 * scalars, quoting and nesting or it lies in both directions: `run: |` bodies
 * routinely contain `KEY: value` lines that are text, not keys, and the same key
 * name legitimately repeats across sibling jobs. `yaml`'s `uniqueKeys` (on by
 * default) is the same rule the Actions parser applies, and it reports the exact
 * line — so this gate fails for the reason GitHub would, not for a lookalike.
 *
 * Scope is every YAML file GitHub itself parses under `.github/**`: the
 * workflows, and `dependabot.yml` — whose duplicate key would take dependency
 * updates offline just as quietly.
 *
 * ALL parse errors are reported, not only duplicates: any of them yields the
 * same logless `startup_failure`.
 *
 * Runs inside `npm run harness:check` (hence `ci:verify` and CI), and standalone:
 *
 *   node scripts/ci/check-workflow-yaml.mjs
 */

import { existsSync, readFileSync, readdirSync } from "node:fs";
import { join, relative } from "node:path";
import { pathToFileURL } from "node:url";

import { parseDocument } from "yaml";

const ROOT = join(import.meta.dirname, "..", "..");

const YAML_FILE_RE = /\.ya?ml$/;

/**
 * The key text starting at a parser position, so the message can NAME the key.
 * `yaml` points at the key's first character and its message ("Map keys must be
 * unique") never says which one — the single most useful word for the fix.
 */
export function keyAtLinePos(source, linePos) {
  if (typeof source !== "string" || !linePos) return null;
  const line = source.split(/\r?\n/)[linePos.line - 1];
  if (line === undefined) return null;

  const rest = line.slice(linePos.col - 1);
  // A quoted key may legitimately contain `:` — take the balanced span.
  const quoted = /^(["'])((?:\\.|(?!\1).)*)\1/.exec(rest);
  if (quoted) return quoted[0];

  const plain = /^([^:#]+?)\s*:(?:\s|$)/.exec(rest);
  if (plain) return plain[1].trim();
  return rest.trim() || null;
}

/**
 * Best-effort line of the FIRST time this key was set in the same mapping.
 * The parser only points at the duplicate; in the incident the two occurrences
 * sat thirteen lines and two comment blocks apart, and knowing both is what
 * makes the fix a one-line delete instead of a re-read.
 *
 * Walks up from the duplicate at a fixed indentation: deeper lines are nested
 * blocks or block-scalar bodies (skipped — a `run: |` body cannot hold a sibling
 * key), a shallower line means the mapping ended (give up). Returns null when
 * unsure, and the caller then omits the hint. It never DECIDES anything — the
 * duplicate is already proven by the parser.
 */
export function findFirstOccurrenceLine(source, linePos, key) {
  if (typeof source !== "string" || !linePos || !key) return null;
  const lines = source.split(/\r?\n/);
  const indent = linePos.col - 1;

  for (let i = linePos.line - 2; i >= 0; i -= 1) {
    const text = lines[i];
    if (text === undefined) continue;
    const trimmed = text.trimStart();
    if (trimmed === "" || trimmed.startsWith("#")) continue;

    const lead = text.length - trimmed.length;
    if (lead > indent) continue;
    if (lead < indent) return null;
    if (
      text.slice(indent, indent + key.length) === key &&
      /^\s*:/.test(text.slice(indent + key.length))
    ) {
      return i + 1;
    }
  }
  return null;
}

/**
 * Every strict-parse problem in one YAML source, structured.
 * `parseDocument` collects errors instead of throwing, so a file with several
 * duplicates reports all of them in one pass.
 */
export function findYamlProblems(source) {
  if (typeof source !== "string") return [];

  let doc;
  try {
    doc = parseDocument(source);
  } catch (err) {
    // Defensive: parseDocument collects rather than throws, but a crash here
    // must still FAIL the gate rather than let the file through unchecked.
    return [
      {
        code: "PARSE_CRASH",
        line: null,
        key: null,
        firstLine: null,
        detail: String(err?.message ?? err),
      },
    ];
  }

  return doc.errors.map((err) => {
    const linePos = err.linePos?.[0] ?? null;
    const key = err.code === "DUPLICATE_KEY" ? keyAtLinePos(source, linePos) : null;
    return {
      code: err.code,
      line: linePos?.line ?? null,
      key,
      firstLine: key ? findFirstOccurrenceLine(source, linePos, key) : null,
      // The parser appends a source excerpt with a caret; keep its first line.
      detail: String(err.message).split("\n")[0],
    };
  });
}

/** Human-readable annotation for one problem, always naming file and line. */
export function formatProblem(label, problem) {
  const at = problem.line === null ? label : `${label}:${problem.line}`;

  if (problem.code === "DUPLICATE_KEY") {
    const key = problem.key ? `\`${problem.key}\`` : "a mapping key";
    const already = problem.firstLine === null ? "" : ` (already set at line ${problem.firstLine})`;
    return (
      `${at}: duplicate YAML key ${key}${already} — GitHub Actions rejects the file at ` +
      "startup: the run ends as `startup_failure`, with zero jobs and no log to read. " +
      "Delete the redundant key."
    );
  }
  return `${at}: YAML ${problem.code} — ${problem.detail}. GitHub would refuse to start this file.`;
}

/** `entries` is `[[label, source], …]`; returns one message per problem. */
export function checkYamlFiles(entries) {
  const out = [];
  for (const [label, source] of entries) {
    for (const problem of findYamlProblems(source)) out.push(formatProblem(label, problem));
  }
  return out;
}

/** Every YAML file under `.github/**`, as `[[repo-relative path, content], …]`. */
export function collectGithubYaml(root = ROOT) {
  const dir = join(root, ".github");
  if (!existsSync(dir)) return [];

  const out = [];
  const walk = (current) => {
    for (const entry of readdirSync(current, { withFileTypes: true })) {
      const full = join(current, entry.name);
      if (entry.isDirectory()) walk(full);
      else if (YAML_FILE_RE.test(entry.name)) {
        out.push([relative(root, full).split("\\").join("/"), readFileSync(full, "utf8")]);
      }
    }
  };
  walk(dir);
  return out.sort(([a], [b]) => a.localeCompare(b));
}

function main() {
  const entries = collectGithubYaml();
  const problems = checkYamlFiles(entries);

  if (problems.length === 0) {
    console.log(`[workflow-yaml] OK — ${entries.length} file(s) under .github/** parse strictly.`);
    return;
  }

  for (const p of problems) console.error(`::error::${p}`);
  throw new Error(`${problems.length} workflow YAML violation(s) — see annotations above.`);
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    main();
  } catch (err) {
    console.error(`\n✗ ${err instanceof Error ? err.message : String(err)}`);
    process.exit(1);
  }
}
