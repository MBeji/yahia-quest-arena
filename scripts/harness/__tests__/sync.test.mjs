import { describe, it, expect } from "vitest";
import { flattenAllow, buildClaudeSettings, serialise } from "../sync.mjs";

const POLICY = {
  allow: {
    $comment: "ignored — not a rule group",
    gates: ["Bash(npm run verify)", "Bash(npm test)"],
    "git-readonly": ["Bash(git status)"],
  },
  deny: [
    { rule: "Bash(supabase db push:*)", reason: "prod migrates via CI only" },
    { rule: "Bash(supabase db reset:*)", reason: "destructive" },
  ],
};

describe("flattenAllow", () => {
  it("flattens intent groups into a single ordered list", () => {
    expect(flattenAllow(POLICY.allow)).toEqual([
      "Bash(npm run verify)",
      "Bash(npm test)",
      "Bash(git status)",
    ]);
  });

  it("skips $-prefixed keys (comments, not rule groups)", () => {
    expect(flattenAllow({ $comment: "note", a: ["x"] })).toEqual(["x"]);
  });

  it("tolerates a missing or empty allow map", () => {
    expect(flattenAllow(undefined)).toEqual([]);
    expect(flattenAllow({})).toEqual([]);
  });

  it("ignores a group whose value is not an array", () => {
    expect(flattenAllow({ bad: "oops", good: ["x"] })).toEqual(["x"]);
  });
});

describe("buildClaudeSettings", () => {
  const settings = buildClaudeSettings({ policy: POLICY });

  it("reduces deny entries to their rule (the reason stays documentation)", () => {
    expect(settings.permissions.deny).toEqual([
      "Bash(supabase db push:*)",
      "Bash(supabase db reset:*)",
    ]);
  });

  it("carries a DO NOT EDIT marker so a human opening the file is warned", () => {
    expect(settings.$comment).toMatch(/DO NOT EDIT/);
    expect(settings.$comment).toMatch(/harness:sync/);
  });

  it("wires the three deterministic command hooks, including the pre-commit guard", () => {
    expect(settings.hooks.PreToolUse[0].hooks[0].command).toContain("guard-generated.mjs");
    const preCommit = settings.hooks.PreToolUse[1].hooks[0];
    expect(preCommit).toMatchObject({ type: "command", if: "Bash(git commit*)" });
    expect(preCommit.command).toContain("precommit-checks.mjs");
    expect(settings.hooks.PostToolUse[0].hooks[0].command).toContain("format-changed.mjs");
  });

  it("no longer emits an agent hook or a hardcoded model (étude IA→déterministe, L1)", () => {
    const json = serialise(settings);
    expect(json).not.toContain('"type": "agent"');
    expect(json).not.toContain('"model"');
    expect(json).not.toContain('"prompt"');
  });

  it("is deterministic — same sources produce a byte-identical object", () => {
    const again = buildClaudeSettings({ policy: POLICY });
    expect(serialise(again)).toBe(serialise(settings));
  });
});

describe("serialise", () => {
  it("emits Prettier-compatible JSON (2-space indent, trailing newline)", () => {
    const out = serialise({ a: { b: 1 } });
    expect(out).toBe('{\n  "a": {\n    "b": 1\n  }\n}\n');
  });
});
