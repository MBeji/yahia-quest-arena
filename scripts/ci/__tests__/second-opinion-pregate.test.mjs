import { describe, expect, it } from "vitest";

import { decideRun, isReviewWorthyPath, parseLabels, run } from "../second-opinion-pregate.mjs";

describe("isReviewWorthyPath", () => {
  it("counts app code, migrations and CI/automation as risk-bearing", () => {
    for (const f of [
      "src/features/quest/quest.server.ts",
      "src/shared/integrations/supabase/auth-middleware.ts",
      "supabase/migrations/20260721_add.sql",
      ".github/workflows/second-opinion.yml",
      ".github/scripts/check-claude-result.py",
    ]) {
      expect(isReviewWorthyPath(f)).toBe(true);
    }
  });

  it("excludes src tests and non-risk paths (docs, e2e, config)", () => {
    for (const f of [
      "src/features/quest/__tests__/quest.test.ts",
      "src/shared/lib/markdown.spec.tsx",
      "docs/agents/etude.md",
      "README.md",
      "e2e/quest.spec.ts",
      "package.json",
      "eslint.config.js",
    ]) {
      expect(isReviewWorthyPath(f)).toBe(false);
    }
  });
});

describe("decideRun", () => {
  it("always runs on manual dispatch (operator override)", () => {
    expect(decideRun({ eventName: "workflow_dispatch", changedFiles: [] })).toMatchObject({
      run: true,
      reason: "manual-dispatch",
    });
  });

  it("runs on demand when the second-avis label is present, even without risky paths", () => {
    expect(
      decideRun({
        eventName: "pull_request",
        labels: ["needs-review", "second-avis"],
        changedFiles: ["README.md"],
      }),
    ).toMatchObject({ run: true, reason: "label:second-avis" });
  });

  it("runs when the PR touches a risk-bearing path", () => {
    expect(
      decideRun({
        eventName: "pull_request",
        labels: [],
        changedFiles: ["docs/x.md", "src/app.ts"],
      }),
    ).toMatchObject({ run: true, reason: "risky-paths(1)" });
  });

  it("skips a docs-only / test-only PR with no label", () => {
    expect(
      decideRun({
        eventName: "pull_request",
        labels: ["chore"],
        changedFiles: ["docs/x.md", "src/features/a/__tests__/a.test.ts"],
      }),
    ).toMatchObject({ run: false, reason: "out-of-scope" });
  });

  it("honours a custom request label", () => {
    expect(
      decideRun({
        eventName: "pull_request",
        labels: ["deep-review"],
        changedFiles: [],
        requestLabel: "deep-review",
      }),
    ).toMatchObject({ run: true, reason: "label:deep-review" });
  });
});

describe("parseLabels", () => {
  it("parses a toJSON labels array", () => {
    expect(parseLabels('["a","b"]')).toEqual(["a", "b"]);
  });
  it("tolerates empty / null / malformed input", () => {
    expect(parseLabels("")).toEqual([]);
    expect(parseLabels("null")).toEqual([]);
    expect(parseLabels("not json")).toEqual([]);
    expect(parseLabels(undefined)).toEqual([]);
  });
});

describe("run (integration of the pure parts)", () => {
  it("skips a docs-only PR by diffing base...head, without a label", () => {
    const prev = { ...process.env };
    process.env.EVENT_NAME = "pull_request";
    process.env.PR_LABELS = "[]";
    process.env.BASE_SHA = "base1";
    process.env.HEAD_SHA = "head1";
    delete process.env.GITHUB_OUTPUT;
    try {
      const calls = [];
      const runGit = (args) => {
        calls.push(args);
        return "docs/a.md\nREADME.md\n";
      };
      expect(run(runGit)).toMatchObject({ run: false, reason: "out-of-scope" });
      expect(calls[0]).toEqual(["diff", "--name-only", "base1...head1"]);
    } finally {
      process.env = prev;
    }
  });

  it("does NOT diff when a label already decides the run", () => {
    const prev = { ...process.env };
    process.env.EVENT_NAME = "pull_request";
    process.env.PR_LABELS = '["second-avis"]';
    process.env.BASE_SHA = "base1";
    process.env.HEAD_SHA = "head1";
    delete process.env.GITHUB_OUTPUT;
    try {
      let called = false;
      const runGit = () => {
        called = true;
        return "";
      };
      expect(run(runGit)).toMatchObject({ run: true, reason: "label:second-avis" });
      expect(called).toBe(false);
    } finally {
      process.env = prev;
    }
  });
});
