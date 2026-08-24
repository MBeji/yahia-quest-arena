import { join } from "node:path";

import { describe, expect, it } from "vitest";

import {
  checkYamlFiles,
  collectGithubYaml,
  findFirstOccurrenceLine,
  findYamlProblems,
  formatProblem,
  keyAtLinePos,
} from "../check-workflow-yaml.mjs";

// `\${{ … }}` keeps GitHub's expression syntax literal inside a template literal.
const DUPLICATE = `name: demo
on: push
jobs:
  open:
    runs-on: ubuntu-latest
    env:
      GH_TOKEN: \${{ secrets.PAT }}
      REPO: \${{ github.repository }}
      GH_TOKEN: \${{ secrets.GITHUB_TOKEN }}
`;

// The SAME file with the redundant key removed. Everything else is byte-identical:
// if the detector reported on this one too, its verdict on DUPLICATE would prove
// nothing (memory "vérifier une absence avec un contrôle négatif").
const CLEAN = `name: demo
on: push
jobs:
  open:
    runs-on: ubuntu-latest
    env:
      GH_TOKEN: \${{ secrets.PAT }}
      REPO: \${{ github.repository }}
`;

describe("findYamlProblems — the defect it exists for", () => {
  it("catches a duplicate key and names the key, its line, and the first one", () => {
    const problems = findYamlProblems(DUPLICATE);

    expect(problems).toHaveLength(1);
    expect(problems[0]).toMatchObject({
      code: "DUPLICATE_KEY",
      key: "GH_TOKEN",
      line: 9,
      firstLine: 7,
    });
  });

  it("stays silent on the same file without the duplicate (negative control)", () => {
    expect(findYamlProblems(CLEAN)).toEqual([]);
  });

  it("replays the 2026-08-24 incident: two sessions, one fix, two keys", () => {
    // Reduced but faithful to auto-pr.yml as it landed: the second GH_TOKEN sat
    // thirteen lines below the first, each behind its own comment wall, in the
    // step-level `env:` that ALSO overrides a job-level GH_TOKEN of the same
    // name — a legitimate shadow the gate must not confuse with the duplicate.
    const incident = `name: Auto PR
on: push
jobs:
  open:
    env:
      GH_TOKEN: \${{ secrets.GH_AUTOMATION_PAT || secrets.GITHUB_TOKEN }}
    steps:
      - name: Dispatch required checks
        env:
          # On SURCHARGE ici le GH_TOKEN du job (le PAT) par le GITHUB_TOKEN,
          # et c'est indispensable : le PAT n'a PAS la permission « Actions ».
          # Constaté au premier run de cette étape (PR #829) — HTTP 403.
          GH_TOKEN: \${{ secrets.GITHUB_TOKEN }}
          REPO: \${{ github.repository }}
          BRANCH: \${{ github.ref_name }}
          # Le GITHUB_TOKEN, PAS le PAT — et c'est la correction du soir.
          # Le job tourne avec GH_TOKEN = PAT || GITHUB_TOKEN, ce qui convient
          # pour ouvrir la PR mais PAS pour dispatcher.
          GH_TOKEN: \${{ secrets.GITHUB_TOKEN }}
        run: gh workflow run ci.yml
`;

    const problems = findYamlProblems(incident);

    expect(problems).toHaveLength(1);
    expect(problems[0]).toMatchObject({ code: "DUPLICATE_KEY", key: "GH_TOKEN", line: 19 });
    expect(problems[0].firstLine).toBe(13);
  });
});

describe("findYamlProblems — what must NOT trip it", () => {
  it("ignores repeated key-shaped lines inside a block scalar", () => {
    // The control that separates a parser from a regex: a `run: |` body is text,
    // and shell text is full of `NAME: value` lines.
    const source = `jobs:
  a:
    steps:
      - run: |
          echo "GH_TOKEN: redacted"
          echo "GH_TOKEN: redacted"
`;
    expect(findYamlProblems(source)).toEqual([]);
  });

  it("ignores the same key in two sibling mappings", () => {
    const source = `jobs:
  a:
    env:
      GH_TOKEN: one
  b:
    env:
      GH_TOKEN: two
`;
    expect(findYamlProblems(source)).toEqual([]);
  });

  it("accepts every workflow idiom this repo actually uses", () => {
    const source = `name: CI
on:
  push:
    branches: [main]
  workflow_dispatch:
permissions:
  contents: read
  actions: write
jobs:
  verify:
    if: \${{ github.event_name == 'push' }}
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683
      - name: Multi-line condition
        if: >
          github.ref == 'refs/heads/main' &&
          github.actor != 'dependabot[bot]'
        run: npm run verify
`;
    expect(findYamlProblems(source)).toEqual([]);
  });

  it("returns nothing for a non-string input rather than throwing", () => {
    expect(findYamlProblems(undefined)).toEqual([]);
    expect(findYamlProblems(null)).toEqual([]);
  });
});

describe("findYamlProblems — other startup_failure causes", () => {
  it("reports a plain syntax error, which is equally logless", () => {
    const problems = findYamlProblems(`jobs:\n  a: [1, 2\n`);

    expect(problems).toHaveLength(1);
    expect(problems[0].code).not.toBe("DUPLICATE_KEY");
    expect(problems[0].line).toBeTypeOf("number");
  });
});

describe("keyAtLinePos", () => {
  it("reads a plain key", () => {
    expect(keyAtLinePos("      GH_TOKEN: x\n", { line: 1, col: 7 })).toBe("GH_TOKEN");
  });

  it("reads a quoted key that contains a colon", () => {
    expect(keyAtLinePos(`  "on: push": x\n`, { line: 1, col: 3 })).toBe(`"on: push"`);
  });

  it("returns null past the end of the source", () => {
    expect(keyAtLinePos("a: 1\n", { line: 9, col: 1 })).toBeNull();
  });
});

describe("findFirstOccurrenceLine", () => {
  it("skips a block-scalar body on the way up", () => {
    const source = `env:
  GH_TOKEN: real
  SCRIPT: |
    GH_TOKEN: text
  GH_TOKEN: dupe
`;
    expect(findFirstOccurrenceLine(source, { line: 5, col: 3 }, "GH_TOKEN")).toBe(2);
  });

  it("does not mistake a longer key with the same prefix", () => {
    const source = `env:
  GH_TOKENS: plural
  GH_TOKEN: single
`;
    expect(findFirstOccurrenceLine(source, { line: 3, col: 3 }, "GH_TOKEN")).toBeNull();
  });

  it("gives up rather than guess once the mapping has ended", () => {
    const source = `a:
  GH_TOKEN: one
b:
  GH_TOKEN: two
`;
    expect(findFirstOccurrenceLine(source, { line: 4, col: 3 }, "GH_TOKEN")).toBeNull();
  });
});

describe("formatProblem", () => {
  it("names file, line, key and the first occurrence", () => {
    const message = formatProblem(".github/workflows/auto-pr.yml", {
      code: "DUPLICATE_KEY",
      line: 305,
      key: "GH_TOKEN",
      firstLine: 292,
      detail: "Map keys must be unique",
    });

    expect(message).toContain(".github/workflows/auto-pr.yml:305");
    expect(message).toContain("`GH_TOKEN`");
    expect(message).toContain("already set at line 292");
    expect(message).toContain("startup_failure");
  });

  it("omits the hint when the first occurrence could not be located", () => {
    const message = formatProblem("f.yml", {
      code: "DUPLICATE_KEY",
      line: 4,
      key: "k",
      firstLine: null,
      detail: "Map keys must be unique",
    });

    expect(message).toContain("f.yml:4");
    expect(message).not.toContain("already set");
  });
});

describe("checkYamlFiles", () => {
  it("reports the offending file only", () => {
    const messages = checkYamlFiles([
      [".github/workflows/good.yml", CLEAN],
      [".github/workflows/bad.yml", DUPLICATE],
    ]);

    expect(messages).toHaveLength(1);
    expect(messages[0]).toContain(".github/workflows/bad.yml:9");
  });

  it("is silent on an all-clean set (negative control)", () => {
    expect(
      checkYamlFiles([
        ["a.yml", CLEAN],
        ["b.yml", CLEAN],
      ]),
    ).toEqual([]);
  });
});

describe("collectGithubYaml", () => {
  // The control that keeps THIS guard from becoming the thing it guards against:
  // an empty file list would make the gate vacuously green forever, and nothing
  // else in the suite would notice. Assert it really reaches the workflows.
  it("actually finds this repo's workflows", () => {
    const paths = collectGithubYaml().map(([relPath]) => relPath);

    expect(paths).toContain(".github/workflows/ci.yml");
    expect(paths).toContain(".github/workflows/auto-pr.yml");
    expect(paths).toContain(".github/dependabot.yml");
    expect(paths.length).toBeGreaterThan(15);
  });

  it("reads real content, not empty strings", () => {
    const [, source] = collectGithubYaml().find(([p]) => p === ".github/workflows/ci.yml");

    expect(source).toContain("jobs:");
  });

  it("returns [] when there is no .github directory", () => {
    expect(collectGithubYaml(join(import.meta.dirname, "no-such-root"))).toEqual([]);
  });
});
