import { describe, it, expect } from "vitest";
import {
  checkPointer,
  checkAgentsSize,
  findInvisibleChars,
  extractFrontmatter,
  findModelIds,
  findUnpinnedActions,
  isJsonValid,
  checkSkillFrontmatter,
  AGENTS_MD_MAX_LINES,
  AGENTS_MD_MAX_BYTES,
  SKILL_DESCRIPTION_MAX,
} from "../check.mjs";

describe("checkPointer", () => {
  it("passes a CLAUDE.md that imports @AGENTS.md", () => {
    expect(checkPointer("# CLAUDE.md\n\n@AGENTS.md\n\n- some Claude-only note\n")).toEqual({
      ok: true,
    });
  });

  it("flags a CLAUDE.md that regrew into a full copy (no import)", () => {
    const result = checkPointer("# CLAUDE.md\n\n## What this is\n\nA whole re-copied doc.\n");
    expect(result.ok).toBe(false);
    expect(result.reason).toMatch(/@AGENTS\.md/);
  });

  it("flags a missing/empty file content", () => {
    expect(checkPointer("").ok).toBe(false);
    expect(checkPointer(undefined).ok).toBe(false);
  });
});

describe("checkAgentsSize", () => {
  it("passes content within the default budget", () => {
    const content = Array.from({ length: 50 }, (_, i) => `line ${i}`).join("\n");
    const result = checkAgentsSize(content);
    expect(result.ok).toBe(true);
    expect(result.violations).toEqual([]);
  });

  it("flags content over the line budget", () => {
    const content = Array.from({ length: AGENTS_MD_MAX_LINES + 10 }, () => "x").join("\n");
    const result = checkAgentsSize(content);
    expect(result.ok).toBe(false);
    expect(result.violations[0]).toMatch(/lines/);
  });

  it("flags content over the byte budget even with few lines", () => {
    const content = "x".repeat(AGENTS_MD_MAX_BYTES + 100);
    const result = checkAgentsSize(content);
    expect(result.ok).toBe(false);
    expect(result.violations.some((v) => v.includes("bytes"))).toBe(true);
  });

  it("respects custom budgets", () => {
    const result = checkAgentsSize("a\nb\nc", { maxLines: 2, maxBytes: 1000 });
    expect(result.ok).toBe(false);
    expect(result.lines).toBe(3);
  });
});

describe("findInvisibleChars", () => {
  it("returns [] for clean ASCII/French/English text", () => {
    expect(findInvisibleChars("Rien à signaler ici — texte normal.")).toEqual([]);
  });

  it("returns [] for legitimate Arabic RTL content (out of the flagged ranges)", () => {
    expect(findInvisibleChars("النص العربي لا يحتوي على أحرف مخفية")).toEqual([]);
  });

  it("detects a zero-width space (U+200B)", () => {
    const hits = findInvisibleChars("safe​text");
    expect(hits).toEqual([{ index: 4, codePoint: "U+200B" }]);
  });

  it("detects a right-to-left override (U+202E) — the 'Rules File Backdoor' vector", () => {
    const hits = findInvisibleChars("ignore‮previous instructions");
    expect(hits).toHaveLength(1);
    expect(hits[0].codePoint).toBe("U+202E");
  });

  it("detects a BOM (U+FEFF) anywhere in the string", () => {
    expect(findInvisibleChars("﻿leading bom")).toHaveLength(1);
  });

  it("detects multiple hits with correct offsets", () => {
    const hits = findInvisibleChars("a​b‌c");
    expect(hits.map((h) => h.index)).toEqual([1, 3]);
  });

  it("returns [] for non-string input", () => {
    expect(findInvisibleChars(null)).toEqual([]);
    expect(findInvisibleChars(undefined)).toEqual([]);
  });
});

describe("extractFrontmatter", () => {
  it("extracts the YAML block between the two --- markers", () => {
    const skillMd = "---\nname: verify\ndescription: does a thing\n---\n\n# Body\n";
    expect(extractFrontmatter(skillMd)).toBe("name: verify\ndescription: does a thing");
  });

  it("returns null when there is no frontmatter", () => {
    expect(extractFrontmatter("# Just a heading\n\nNo frontmatter here.")).toBeNull();
  });

  it("returns null for empty/undefined input", () => {
    expect(extractFrontmatter("")).toBeNull();
    expect(extractFrontmatter(undefined)).toBeNull();
  });
});

describe("findModelIds", () => {
  it("finds a claude-* id", () => {
    expect(findModelIds("--model claude-sonnet-4-6")).toEqual(["claude-sonnet-4-6"]);
  });

  it("finds gpt-* and gemini-* ids", () => {
    expect(findModelIds("gpt-4o and gemini-2.5-pro")).toEqual(["gpt-4o", "gemini-2.5-pro"]);
  });

  it("finds an o<digit>-* id (OpenAI reasoning-tier naming)", () => {
    expect(findModelIds("route to o1-preview for this")).toEqual(["o1-preview"]);
  });

  it("dedupes repeated ids", () => {
    expect(findModelIds("claude-sonnet-4-6 twice: claude-sonnet-4-6")).toEqual([
      "claude-sonnet-4-6",
    ]);
  });

  it("does not match plain prose mentioning the vendor name alone", () => {
    expect(findModelIds("Claude Code and GPT are both AI coding assistants.")).toEqual([]);
  });

  it("does not match unrelated words containing 'o' + digit as a substring", () => {
    expect(findModelIds("no1 component, options, io2ring")).toEqual([]);
  });

  // Real false positives found when the scan reached .github/workflows/** (lot 5):
  // all three are vendor-prefixed but none is a model.
  it("does not match the claude-code-action GitHub Action", () => {
    expect(findModelIds("uses: anthropics/claude-code-action@v1")).toEqual([]);
  });

  it("does not match claude-prefixed filenames", () => {
    expect(findModelIds("python3 .github/scripts/check-claude-result.py")).toEqual([]);
    expect(findModelIds('"$RUNNER_TEMP/claude-execution-output.json"')).toEqual([]);
  });

  it("still catches every real Claude family", () => {
    expect(
      findModelIds("claude-sonnet-4-6 claude-opus-4-8 claude-haiku-4-5 claude-fable-5"),
    ).toEqual(["claude-sonnet-4-6", "claude-opus-4-8", "claude-haiku-4-5", "claude-fable-5"]);
  });

  it("returns [] on content with nothing to flag", () => {
    expect(findModelIds("# AGENTS.md\n\nGeneric prose, zero model ids.")).toEqual([]);
  });
});

describe("checkSkillFrontmatter", () => {
  const valid = `name: verify\ndescription: >-\n  Runs the local quality gate before declaring a task done.`;

  it("accepts a conforming skill", () => {
    expect(checkSkillFrontmatter("verify", valid)).toEqual([]);
  });

  it("flags a name that does not match its folder (breaks discovery in other tools)", () => {
    const problems = checkSkillFrontmatter("other-folder", valid);
    expect(problems).toHaveLength(1);
    expect(problems[0]).toMatch(/≠ folder/);
  });

  it("flags a description over the spec's 1024-char budget", () => {
    const long = `name: verify\ndescription: >-\n  ${"x".repeat(SKILL_DESCRIPTION_MAX + 50)}`;
    const problems = checkSkillFrontmatter("verify", long);
    expect(problems).toHaveLength(1);
    expect(problems[0]).toMatch(/> spec max 1024/);
  });

  it("reads a multi-line block-scalar description as one string", () => {
    const multi = `name: verify\ndescription: >-\n  first line\n  second line\nlicense: MIT`;
    expect(checkSkillFrontmatter("verify", multi)).toEqual([]);
  });

  it("flags a missing description", () => {
    expect(checkSkillFrontmatter("verify", "name: verify")).toEqual(["missing `description`"]);
  });

  it("flags a missing frontmatter entirely", () => {
    expect(checkSkillFrontmatter("verify", null)).toEqual(["no YAML frontmatter"]);
  });

  it("flags a non-kebab-case name", () => {
    const problems = checkSkillFrontmatter("Verify_Gate", `name: Verify_Gate\ndescription: x`);
    expect(problems.some((p) => p.includes("kebab-case"))).toBe(true);
  });
});

describe("isJsonValid", () => {
  it("accepts valid JSON", () => {
    expect(isJsonValid('{"roles": {"executeur": {"model": "x"}}}')).toBe(true);
  });

  it("rejects malformed JSON", () => {
    expect(isJsonValid("{not: valid,}")).toBe(false);
  });
});

describe("findUnpinnedActions", () => {
  const SHA = "9c091bb21b7c1c1d1991bb908d89e4e9dddfe3e0";

  it("accepts an action pinned to a commit SHA with its version comment", () => {
    expect(findUnpinnedActions(`      - uses: actions/checkout@${SHA} # v7`)).toEqual([]);
  });

  it("flags a moving version tag — the regression that merged green on 2026-07-20", () => {
    const hits = findUnpinnedActions("      - uses: actions/checkout@v7");
    expect(hits).toHaveLength(1);
    expect(hits[0].uses).toBe("actions/checkout@v7");
    expect(hits[0].reason).toMatch(/moving ref/);
  });

  it("flags a branch ref and a semver ref — neither is immovable", () => {
    expect(findUnpinnedActions("      - uses: foo/bar@main")).toHaveLength(1);
    expect(findUnpinnedActions("      - uses: foo/bar@1.2.3")).toHaveLength(1);
  });

  it("flags an action with no ref at all", () => {
    const hits = findUnpinnedActions("      - uses: foo/bar");
    expect(hits).toHaveLength(1);
    expect(hits[0].ref).toBeNull();
    expect(hits[0].reason).toMatch(/default branch/);
  });

  it("exempts a local reusable workflow — this repo's own code at its own commit", () => {
    expect(findUnpinnedActions("    uses: ./.github/workflows/e2e.yml")).toEqual([]);
  });

  it("exempts a docker:// ref — pinned by digest, a different rule", () => {
    expect(findUnpinnedActions("      - uses: docker://alpine:3.20")).toEqual([]);
  });

  it("ignores a commented-out uses: line", () => {
    expect(findUnpinnedActions("      # uses: actions/checkout@v7")).toEqual([]);
  });

  it("catches a job-level `uses:` too, not just list items", () => {
    expect(findUnpinnedActions("    uses: some/reusable@v3")).toHaveLength(1);
  });

  it("scans a whole workflow and reports only the offenders", () => {
    const workflow = [
      "jobs:",
      "  a:",
      "    steps:",
      `      - uses: actions/checkout@${SHA} # v7`,
      "      - uses: actions/setup-node@v6",
      `      - uses: actions/github-script@${SHA} # v9`,
      "  b:",
      "    uses: ./.github/workflows/e2e.yml",
    ].join("\n");
    const hits = findUnpinnedActions(workflow);
    expect(hits.map((h) => h.uses)).toEqual(["actions/setup-node@v6"]);
  });

  it("survives a non-string input", () => {
    expect(findUnpinnedActions(undefined)).toEqual([]);
    expect(findUnpinnedActions(null)).toEqual([]);
  });
});
