import { describe, it, expect } from "vitest";
import {
  checkPointer,
  checkAgentsSize,
  findInvisibleChars,
  extractFrontmatter,
  findModelIds,
  isJsonValid,
  AGENTS_MD_MAX_LINES,
  AGENTS_MD_MAX_BYTES,
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

  it("returns [] on content with nothing to flag", () => {
    expect(findModelIds("# AGENTS.md\n\nGeneric prose, zero model ids.")).toEqual([]);
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
