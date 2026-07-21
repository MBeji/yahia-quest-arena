import { describe, expect, it } from "vitest";

import { collectWindow, decideSkip, isDocsOnlyPath } from "../regression-guard-pregate.mjs";

describe("isDocsOnlyPath", () => {
  it("treats markdown (anywhere) and docs/** as documentation", () => {
    for (const f of [
      "README.md",
      "STATUS.md",
      "docs/agents/etude-ia-vs-deterministe.md",
      "docs/diagram.svg",
      ".claude/skills/verify/SKILL.md",
      "guide.MDX",
    ]) {
      expect(isDocsOnlyPath(f)).toBe(true);
    }
  });

  it("treats code / DB / config / workflows as test-relevant (not docs)", () => {
    for (const f of [
      "src/features/quest/quest.server.ts",
      "supabase/migrations/20260721_add.sql",
      "scripts/ci/regression-guard-pregate.mjs",
      "e2e/quest.spec.ts",
      "package.json",
      ".github/workflows/regression-guard.yml",
      "eslint.config.js",
    ]) {
      expect(isDocsOnlyPath(f)).toBe(false);
    }
  });
});

describe("decideSkip", () => {
  it("skips an empty window", () => {
    expect(decideSkip([])).toMatchObject({ skip: true, reason: "empty-window" });
  });

  it("skips a documentation-only window (single commit)", () => {
    const commits = [{ sha: "a1", files: ["docs/x.md", "README.md"] }];
    expect(decideSkip(commits)).toMatchObject({ skip: true, reason: "docs-only" });
  });

  it("skips a documentation-only window (several commits)", () => {
    const commits = [
      { sha: "a1", files: ["docs/a.md"] },
      { sha: "a2", files: ["STATUS.md"] },
      { sha: "a3", files: [] }, // empty commit — no code either
    ];
    expect(decideSkip(commits)).toMatchObject({ skip: true, reason: "docs-only" });
  });

  it("wakes the agent when any commit touches a test-relevant file", () => {
    const commits = [
      { sha: "a1", files: ["docs/a.md"] },
      { sha: "a2", files: ["src/features/quest/quest.server.ts"] },
    ];
    expect(decideSkip(commits)).toMatchObject({ skip: false, reason: "work-found" });
  });

  it("wakes the agent for a commit mixing docs AND code (not provably inert)", () => {
    const commits = [{ sha: "a1", files: ["docs/a.md", "src/app.ts"] }];
    expect(decideSkip(commits)).toMatchObject({ skip: false, reason: "work-found" });
  });

  it("wakes the agent for a migration-only change", () => {
    const commits = [{ sha: "a1", files: ["supabase/migrations/20260721_x.sql"] }];
    expect(decideSkip(commits).skip).toBe(false);
  });
});

describe("collectWindow", () => {
  it("parses git output into {sha, files} and passes the window to git log", () => {
    const calls = [];
    const runGit = (args) => {
      calls.push(args);
      if (args[0] === "log") return "sha1\nsha2\n";
      if (args[0] === "diff-tree" && args.includes("sha1")) return "src/a.ts\ndocs/b.md\n";
      if (args[0] === "diff-tree" && args.includes("sha2")) return "README.md\n";
      return "";
    };
    const commits = collectWindow(runGit, 26);
    expect(commits).toEqual([
      { sha: "sha1", files: ["src/a.ts", "docs/b.md"] },
      { sha: "sha2", files: ["README.md"] },
    ]);
    // The log call must be non-merge and scoped to the requested window.
    expect(calls[0]).toEqual(["log", "--no-merges", "--since=26 hours ago", "--format=%H"]);
  });

  it("returns an empty array when no commits are in the window", () => {
    const runGit = (args) => (args[0] === "log" ? "\n" : "");
    expect(collectWindow(runGit, 26)).toEqual([]);
  });
});
