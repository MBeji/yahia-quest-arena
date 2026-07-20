/**
 * Anti-drift gate for the AI-native harness (étude 25, "harness:check"). Guards the
 * invariants a model-agnostic harness depends on:
 *
 *   1. Pointer integrity — CLAUDE.md must stay a thin `@AGENTS.md` import, never
 *      regrow into a second copy of the canonical instructions (the exact drift
 *      étude 25 was written to kill — see its §2.4).
 *   2. AGENTS.md size budget — ≤250 lines / ≤24 KiB, under Codex's 32 KiB default
 *      truncation and the industry-observed ~200-line adherence threshold.
 *   3. No hidden Unicode (zero-width / bidi-override / tag characters) in the
 *      instruction/harness surface — the "Rules File Backdoor" class of attack
 *      (invisible instructions smuggled into a rules file a human reviews visually).
 *   4. No model identifier hardcoded outside `harness/models.json` — the one file
 *      a model bump should ever touch. Covers AGENTS.md/CLAUDE.md, `harness/**` and
 *      (since lot 5) `.github/workflows/**`, whose guards resolve their model from
 *      `models.json` at run time. GENERATED views are exempt: the id they contain is
 *      compiled from `models.json`, and invariant 6 proves it was not hand-edited.
 *   5. Every `harness/*.json` file parses as JSON.
 *   6. Every generated view matches what `harness:sync` would produce from the
 *      sources — the anti-drift guarantee that makes invariant 4's exemption safe.
 *
 * Driven by `.github/workflows/ci.yml` (job `verify`) and `npm run ci:verify`.
 * Pure helpers are exported and unit-tested; `main()` does the filesystem walk and
 * runs only when this file is executed directly.
 *
 *   node scripts/harness/check.mjs
 */
import { readFileSync, readdirSync, existsSync } from "node:fs";
import { join, relative } from "node:path";
import { pathToFileURL } from "node:url";
import { buildViews } from "./sync.mjs";

const ROOT = join(import.meta.dirname, "..", "..");

export const AGENTS_MD_MAX_LINES = 250;
export const AGENTS_MD_MAX_BYTES = 24 * 1024;

/** CLAUDE.md must stay a pointer: contain the `@AGENTS.md` import. */
export function checkPointer(claudeMdContent) {
  if (typeof claudeMdContent !== "string" || !claudeMdContent.includes("@AGENTS.md")) {
    return {
      ok: false,
      reason:
        "CLAUDE.md no longer imports @AGENTS.md — it must stay a thin pointer (étude 25 D-1).",
    };
  }
  return { ok: true };
}

/** AGENTS.md must stay under the line/byte budget (D-1b). */
export function checkAgentsSize(
  agentsMdContent,
  { maxLines = AGENTS_MD_MAX_LINES, maxBytes = AGENTS_MD_MAX_BYTES } = {},
) {
  const lines = agentsMdContent.split("\n").length;
  const bytes = Buffer.byteLength(agentsMdContent, "utf8");
  const violations = [];
  if (lines > maxLines) {
    violations.push(`${lines} lines > budget of ${maxLines}`);
  }
  if (bytes > maxBytes) {
    violations.push(`${bytes} bytes > budget of ${maxBytes} (Codex truncates AGENTS.md at 32 KiB)`);
  }
  return { ok: violations.length === 0, lines, bytes, violations };
}

// Zero-width, bidi-override, and Unicode tag ranges — invisible or
// direction-flipping characters that render identically to nothing in a
// GitHub diff review but change what an agent reads. NOT Arabic script (which
// lives at U+0600-U+06FF and is legitimate content elsewhere in this repo —
// deliberately out of these ranges and out of this scan's scope entirely).
const INVISIBLE_RE = /[​-‏‪-‮⁠-⁤﻿\u{E0000}-\u{E007F}]/gu;

/** Returns every invisible/bidi codepoint found, with its index. */
export function findInvisibleChars(text) {
  if (typeof text !== "string") return [];
  return [...text.matchAll(INVISIBLE_RE)].map((m) => ({
    index: m.index,
    codePoint: `U+${m[0].codePointAt(0).toString(16).toUpperCase().padStart(4, "0")}`,
  }));
}

/** Extracts the YAML frontmatter block (between the two `---` lines) of a SKILL.md. */
export function extractFrontmatter(skillMdContent) {
  const match = /^---\r?\n([\s\S]*?)\r?\n---/.exec(skillMdContent ?? "");
  return match ? match[1] : null;
}

/** Max description length imposed by the open Agent Skills spec (agentskills.io). */
export const SKILL_DESCRIPTION_MAX = 1024;

/**
 * Validates a skill against the portable parts of the Agent Skills spec — the
 * ones another tool will actually enforce when it reads `.agents/skills/`:
 * `name` must equal the folder name and match the charset, and `description`
 * must fit the 1024-character budget (it is injected into every session's
 * system prompt, which is why the spec caps it).
 */
export function checkSkillFrontmatter(folderName, frontmatter) {
  const problems = [];
  if (frontmatter === null) return ["no YAML frontmatter"];

  const name = /^name:\s*(.+)$/m.exec(frontmatter)?.[1]?.trim();
  if (!name) problems.push("missing `name`");
  else if (name !== folderName) problems.push(`name "${name}" ≠ folder "${folderName}"`);
  else if (!/^[a-z0-9]+(-[a-z0-9]+)*$/.test(name))
    problems.push(`name "${name}" is not kebab-case`);

  // `description` is usually a YAML block scalar (`>-`), so take everything up
  // to the next top-level key rather than a single line.
  const raw = /^description:\s*(?:>-|>|\|-|\|)?\s*\n?([\s\S]*?)(?=\n[a-zA-Z-]+:|$)/m.exec(
    frontmatter,
  )?.[1];
  const description = raw?.replace(/\s+/g, " ").trim() ?? "";
  if (!description) problems.push("missing `description`");
  else if (description.length > SKILL_DESCRIPTION_MAX) {
    problems.push(`description is ${description.length} chars > spec max ${SKILL_DESCRIPTION_MAX}`);
  }

  return problems;
}

// Matches a model IDENTIFIER, keyed on the model FAMILY — not on the vendor
// prefix alone. Anchoring on `claude-*` was too loose once the scan reached
// `.github/workflows/**`: `claude-code-action` (a GitHub Action), and the
// `claude-result.py` / `claude-execution-output.json` filenames all matched,
// none of which is a model. Families are cheap to extend when a new one ships.
const MODEL_ID_RE =
  /\bclaude-(?:sonnet|opus|haiku|fable|instant)[a-z0-9.-]*\b|\bgpt-[0-9][a-z0-9.-]*\b|\bgemini-[0-9][a-z0-9.-]*\b|\bo[0-9](?:-[a-z]+)?\b/gi;

/** Returns every model-id-shaped token found in text (deduped). */
export function findModelIds(text) {
  if (typeof text !== "string") return [];
  return [...new Set([...text.matchAll(MODEL_ID_RE)].map((m) => m[0]))];
}

export function isJsonValid(text) {
  try {
    JSON.parse(text);
    return true;
  } catch {
    return false;
  }
}

function readIfExists(path) {
  return existsSync(path) ? readFileSync(path, "utf8") : null;
}

/** Recursively lists files under `dir` matching `pattern`, or [] if `dir` is absent. */
function walk(dir, pattern) {
  if (!existsSync(dir)) return [];
  const out = [];
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const full = join(dir, entry.name);
    if (entry.isDirectory()) out.push(...walk(full, pattern));
    else if (pattern.test(entry.name)) out.push(full);
  }
  return out;
}

function main() {
  const problems = [];
  const rel = (p) => relative(ROOT, p).split("\\").join("/");

  // 1. Pointer integrity.
  const claudeMd = readIfExists(join(ROOT, "CLAUDE.md"));
  if (claudeMd === null) {
    problems.push("CLAUDE.md is missing.");
  } else {
    const pointer = checkPointer(claudeMd);
    if (!pointer.ok) problems.push(pointer.reason);
  }

  // 2. AGENTS.md size budget.
  const agentsMd = readIfExists(join(ROOT, "AGENTS.md"));
  if (agentsMd === null) {
    problems.push("AGENTS.md is missing — it is the canonical source (étude 25 D-1).");
  } else {
    const size = checkAgentsSize(agentsMd);
    for (const v of size.violations) problems.push(`AGENTS.md over budget: ${v}.`);
  }

  // Harness surface scanned for BOTH invisible Unicode and stray model ids.
  // Since lot 5 the guard workflows resolve their model from harness/models.json,
  // so `.github/workflows/**` is in scope too — this is what makes the study's
  // "zero hardcoded model id" KPI actually enforced rather than aspirational.
  const generatedViews = new Set(buildViews(ROOT).map(([relPath]) => relPath));
  const surface = [
    ["AGENTS.md", agentsMd],
    ["CLAUDE.md", claudeMd],
    ...[...generatedViews].map((relPath) => [relPath, readIfExists(join(ROOT, relPath))]),
    ...walk(join(ROOT, "harness"), /\.(json|md)$/).map((p) => [rel(p), readIfExists(p)]),
    ...walk(join(ROOT, ".github", "workflows"), /\.ya?ml$/).map((p) => [rel(p), readIfExists(p)]),
  ].filter(([, content]) => content !== null);

  for (const [label, content] of surface) {
    for (const hit of findInvisibleChars(content)) {
      problems.push(`${label}: hidden Unicode ${hit.codePoint} at offset ${hit.index}.`);
    }
    // Exempt: models.json declares the ids, and generated views merely compile
    // them (invariant 6 catches a hand-edit).
    if (label !== "harness/models.json" && !generatedViews.has(label)) {
      for (const id of findModelIds(content)) {
        problems.push(
          `${label}: hardcoded model id "${id}" — resolve it via harness/models.json instead.`,
        );
      }
    }
  }

  // 3. Skill frontmatters — hidden Unicode, plus conformance to the portable
  // parts of the Agent Skills spec (lot 3): the mirror at `.agents/skills/` is
  // read by tools that DO enforce them, so a skill that drifts here silently
  // stops working there.
  for (const skillMd of walk(join(ROOT, ".claude", "skills"), /^SKILL\.md$/)) {
    const frontmatter = extractFrontmatter(readIfExists(skillMd));
    const folderName = rel(skillMd).split("/").at(-2);

    for (const problem of checkSkillFrontmatter(folderName, frontmatter)) {
      problems.push(`${rel(skillMd)}: ${problem} (Agent Skills spec).`);
    }

    if (frontmatter === null) continue;
    for (const hit of findInvisibleChars(frontmatter)) {
      problems.push(
        `${rel(skillMd)} frontmatter: hidden Unicode ${hit.codePoint} at offset ${hit.index}.`,
      );
    }
  }

  // 4. JSON validity of every harness/*.json file.
  for (const jsonFile of walk(join(ROOT, "harness"), /\.json$/)) {
    const content = readIfExists(jsonFile);
    if (content !== null && !isJsonValid(content)) {
      problems.push(`${rel(jsonFile)} is not valid JSON.`);
    }
  }

  // 5. Generated views must match their harness sources (lot 4). This is what
  // lets the model id inside a GENERATED file be legitimate: it is not
  // hand-written, it is compiled from harness/models.json — and any hand-edit
  // (including a model bumped only here) shows up as drift below.
  for (const [relPath, expected] of buildViews(ROOT)) {
    const actual = readIfExists(join(ROOT, relPath));
    if (actual === null) {
      problems.push(`${relPath} is missing — run \`npm run harness:sync\`.`);
    } else if (actual !== expected) {
      problems.push(
        `${relPath} drifted from its harness sources — run \`npm run harness:sync\` and commit the result.`,
      );
    }
  }

  if (problems.length === 0) {
    console.log(
      "[harness:check] OK — pointers intact, AGENTS.md in budget, no hidden Unicode, " +
        "no stray model ids, generated views in sync.",
    );
    return;
  }

  for (const p of problems) console.error(`::error::${p}`);
  throw new Error(`${problems.length} harness gate violation(s) — see annotations above.`);
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    main();
  } catch (err) {
    console.error(`\n✗ ${err instanceof Error ? err.message : String(err)}`);
    process.exit(1);
  }
}
