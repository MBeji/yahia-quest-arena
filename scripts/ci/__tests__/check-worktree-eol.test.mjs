// @vitest-environment node
import { describe, expect, it } from "vitest";

import { findCrlfOffenders, hasCrlf, isBinary, toLf } from "../check-worktree-eol.mjs";

const buf = (s) => Buffer.from(s, "utf8");

describe("hasCrlf", () => {
  it("finds a CRLF pair", () => {
    expect(hasCrlf(buf("a\r\nb"))).toBe(true);
  });

  it("ignores LF-only content", () => {
    expect(hasCrlf(buf("a\nb\nc\n"))).toBe(false);
  });

  it("ignores a lone CR", () => {
    expect(hasCrlf(buf("a\rb"))).toBe(false);
  });

  it("does not read past the end on a trailing CR", () => {
    expect(hasCrlf(buf("a\r"))).toBe(false);
  });

  it("handles an empty buffer", () => {
    expect(hasCrlf(Buffer.alloc(0))).toBe(false);
  });
});

describe("isBinary", () => {
  it("flags content with a NUL byte", () => {
    expect(isBinary(Buffer.from([0x89, 0x50, 0x00, 0x0d, 0x0a]))).toBe(true);
  });

  it("passes text through", () => {
    expect(isBinary(buf("héllo\r\nwörld"))).toBe(false);
  });
});

describe("toLf", () => {
  it("collapses CRLF to LF", () => {
    expect(toLf(buf("a\r\nb\r\n")).toString()).toBe("a\nb\n");
  });

  it("preserves a lone CR", () => {
    expect(toLf(buf("a\rb")).toString()).toBe("a\rb");
  });

  it("preserves multibyte characters", () => {
    // The trap this guard exists for lives in files full of accented French.
    expect(toLf(buf("déjà\r\nvu — ✅")).toString()).toBe("déjà\nvu — ✅");
  });

  it("is a no-op on already-LF content", () => {
    const already = buf("clean\nfile\n");
    expect(toLf(already).equals(already)).toBe(true);
  });
});

describe("findCrlfOffenders", () => {
  const files = {
    "src/clean.ts": buf("const a = 1;\n"),
    ".claude/hooks/dirty.mjs": buf("#!/usr/bin/env node\r\nimport x from 'y';\r\n"),
    "assets/logo.png": Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x00, 0x0d, 0x0a]),
  };
  const read = (f) => files[f] ?? null;

  it("reports only the CRLF text file", () => {
    expect(findCrlfOffenders(Object.keys(files), read)).toEqual([".claude/hooks/dirty.mjs"]);
  });

  it("never flags a binary file, CRLF bytes or not", () => {
    expect(findCrlfOffenders(["assets/logo.png"], read)).toEqual([]);
  });

  it("skips unreadable paths instead of throwing", () => {
    expect(findCrlfOffenders(["gone.ts"], read)).toEqual([]);
  });

  it("returns an empty list for a clean tree", () => {
    expect(findCrlfOffenders(["src/clean.ts"], read)).toEqual([]);
  });
});
