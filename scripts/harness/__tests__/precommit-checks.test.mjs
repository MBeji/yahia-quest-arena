import { describe, expect, it } from "vitest";

import {
  analyzeStaged,
  findViolations,
  formatFindings,
  isPatternScanExempt,
  isSecretExemptPath,
  parseStagedDiff,
} from "../../../.claude/hooks/precommit-checks.mjs";

/** Build a one-file `files` entry from a list of added-line strings. */
function added(path, lines) {
  return [{ path, added: lines.map((text, i) => ({ line: i + 1, text })), removed: [] }];
}

describe("isSecretExemptPath", () => {
  it("exempts docs and example env files", () => {
    for (const p of ["README.md", "docs/agents/x.md", ".env.example", "config.example"]) {
      expect(isSecretExemptPath(p)).toBe(true);
    }
  });
  it("does not exempt real code/config", () => {
    for (const p of ["src/a.ts", "harness/policy.json", "supabase/migrations/x.sql"]) {
      expect(isSecretExemptPath(p)).toBe(false);
    }
  });
});

describe("isPatternScanExempt", () => {
  it("exempts docs, test fixtures and the hook tooling", () => {
    for (const p of [
      "README.md",
      ".env.example",
      "src/features/a/__tests__/a.test.ts",
      "scripts/harness/__tests__/precommit-checks.test.mjs",
      ".claude/hooks/precommit-checks.mjs",
    ]) {
      expect(isPatternScanExempt(p)).toBe(true);
    }
  });
  it("still scans real app code and config", () => {
    for (const p of ["src/config.ts", "harness/policy.json", "scripts/x.mjs"]) {
      expect(isPatternScanExempt(p)).toBe(false);
    }
  });
});

describe("findViolations — secrets", () => {
  // Fixtures are stitched from fragments so no literal credential ever appears in the source:
  // otherwise GitHub push-protection (rightly) blocks the push — and this very hook would flag
  // its own test. At runtime the pieces join into a full token that exercises each detector.
  const S = (...parts) => parts.join("");
  const SECRETS = {
    "JSON Web Token": S(
      "eyJhbGciOiJIUzI1NiJ9",
      ".",
      "eyJzdWIiOiIxMjM0NTY3ODkwIn0",
      ".",
      "SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV",
    ),
    "PEM private key": S("-----BEGIN RSA ", "PRIVATE KEY-----"),
    "AWS access key id": S("AKIA", "IOSFODNN7EXAMPLE"),
    "GitHub token": S("ghp_", "0123456789012345678901234567890123456789"),
    "OpenAI/Anthropic key": S("sk-ant-", "api03-0123456789012345678901234567"),
    "Google API key": S("AIza", "abcdefghijklmnopqrstuvwxyz012345678"),
    "Slack token": S("xoxb-", "0123456789-abcdefghijklmnop"),
  };

  for (const [name, value] of Object.entries(SECRETS)) {
    it(`flags a ${name} in app code`, () => {
      const v = findViolations(added("src/config.ts", [`const k = "${value}";`]));
      expect(v).toHaveLength(1);
      expect(v[0]).toMatchObject({ rule: "secret", file: "src/config.ts" });
    });
  }

  it("does NOT flag secrets inside docs / .env.example", () => {
    const jwt = SECRETS["JSON Web Token"];
    expect(findViolations(added("README.md", [jwt]))).toHaveLength(0);
    expect(findViolations(added(".env.example", [`SUPABASE_KEY=${jwt}`]))).toHaveLength(0);
  });

  it("does NOT scan test fixtures or the hook tooling (no self-flagging)", () => {
    const jwt = SECRETS["JSON Web Token"];
    // The hook's own test carries sample tokens + pattern literals on purpose.
    expect(
      findViolations(added("src/a/__tests__/a.test.ts", [`const t = "${jwt}";`, "// @ts-ignore"])),
    ).toHaveLength(0);
    // A scanner must not match its own source under .claude/hooks/.
    expect(
      findViolations(
        added(".claude/hooks/precommit-checks.mjs", ["-- --no-verify --", "@ts-ignore"]),
      ),
    ).toHaveLength(0);
  });

  it("does NOT flag secret-shaped-but-not-a-secret lookalikes", () => {
    expect(
      findViolations(
        added("src/a.ts", [
          "const token = getToken();",
          'const url = "sk-is-a-prefix";', // sk- too short, no 24+ run
          "// eyJ is a base64 prefix",
        ]),
      ),
    ).toHaveLength(0);
  });
});

describe("findViolations — gate weakening", () => {
  it("flags @ts-ignore and @ts-nocheck but NOT @ts-expect-error", () => {
    expect(findViolations(added("src/a.ts", ["// @ts-ignore"]))[0]).toMatchObject({
      rule: "ts-suppress",
    });
    expect(findViolations(added("src/a.ts", ["// @ts-nocheck"]))).toHaveLength(1);
    expect(findViolations(added("src/a.ts", ["// @ts-expect-error legit"]))).toHaveLength(0);
  });

  it("does NOT flag `as any` or `eslint-disable` (semantic → /code-review)", () => {
    expect(
      findViolations(
        added("src/a.ts", ["const x = y as any;", "// eslint-disable-next-line no-console"]),
      ),
    ).toHaveLength(0);
  });

  it("flags --no-verify in committed code, not in docs", () => {
    expect(findViolations(added("scripts/x.sh", ["git commit --no-verify"]))[0]).toMatchObject({
      rule: "no-verify",
    });
    expect(findViolations(added("docs/x.md", ["never run git commit --no-verify"]))).toHaveLength(
      0,
    );
  });
});

describe("findViolations — coverage thresholds (vitest.config)", () => {
  it("flags a lowered threshold", () => {
    const files = [
      {
        path: "vitest.config.ts",
        added: [{ line: 1, text: "        lines: 70," }],
        removed: ["        lines: 80,"],
      },
    ];
    expect(findViolations(files)[0]).toMatchObject({ rule: "coverage-threshold" });
  });
  it("does NOT flag an increase or an unchanged key", () => {
    const up = [
      {
        path: "vitest.config.ts",
        added: [{ line: 1, text: "        lines: 90," }],
        removed: ["        lines: 80,"],
      },
    ];
    expect(findViolations(up)).toHaveLength(0);
  });
  it("ignores threshold-looking numbers outside vitest.config", () => {
    const files = [
      {
        path: "src/a.ts",
        added: [{ line: 1, text: "const lines: 5 = 3;" }],
        removed: ["const lines: 5 = 9;"],
      },
    ];
    expect(findViolations(files)).toHaveLength(0);
  });
});

describe("findViolations — destructive migration + src (DoD §7)", () => {
  const migration = {
    path: "supabase/migrations/x.sql",
    added: [{ line: 1, text: "ALTER TABLE t DROP COLUMN c;" }],
    removed: [],
  };
  const src = { path: "src/a.ts", added: [{ line: 1, text: "const x = 1;" }], removed: [] };

  it("flags a DROP COLUMN migration committed WITH src/**", () => {
    const v = findViolations([migration, src]);
    expect(v.some((f) => f.rule === "destructive-migration")).toBe(true);
  });
  it("does NOT flag the migration on its own", () => {
    expect(findViolations([migration])).toHaveLength(0);
  });
  it("does NOT flag a non-destructive migration (REVOKE/CREATE) with src", () => {
    const revoke = {
      path: "supabase/migrations/y.sql",
      added: [{ line: 1, text: "REVOKE ALL ON t FROM anon;" }],
      removed: [],
    };
    expect(findViolations([revoke, src])).toHaveLength(0);
  });
});

describe("parseStagedDiff", () => {
  it("splits added/removed per file and tracks new-file line numbers", () => {
    const diff = [
      "diff --git a/src/a.ts b/src/a.ts",
      "index e69de29..f4d3c1e 100644",
      "--- a/src/a.ts",
      "+++ b/src/a.ts",
      "@@ -0,0 +5 @@",
      "+const x = 1;",
      "@@ -9,1 +10,1 @@",
      "-const old = 2;",
      "+const neu = 2;",
    ].join("\n");
    const files = parseStagedDiff(diff);
    expect(files).toHaveLength(1);
    expect(files[0].path).toBe("src/a.ts");
    expect(files[0].added).toEqual([
      { line: 5, text: "const x = 1;" },
      { line: 10, text: "const neu = 2;" },
    ]);
    expect(files[0].removed).toEqual(["const old = 2;"]);
  });

  it("ignores a deleted file (+++ /dev/null)", () => {
    const diff = ["--- a/gone.ts", "+++ /dev/null", "@@ -1 +0,0 @@", "-was here"].join("\n");
    expect(parseStagedDiff(diff)).toHaveLength(0);
  });
});

describe("analyzeStaged", () => {
  it("returns [] on an empty staged diff", () => {
    expect(analyzeStaged(() => "")).toEqual([]);
  });
  it("finds a secret through the full parse→check path", () => {
    const diff = [
      "diff --git a/src/s.ts b/src/s.ts",
      "--- a/src/s.ts",
      "+++ b/src/s.ts",
      "@@ -0,0 +1 @@",
      `+const key = "${"AKIA" + "IOSFODNN7EXAMPLE"}";`,
    ].join("\n");
    const v = analyzeStaged(() => diff);
    expect(v).toHaveLength(1);
    expect(v[0].rule).toBe("secret");
  });
});

describe("formatFindings", () => {
  it("renders rule + file:line and a fix hint", () => {
    const out = formatFindings([{ file: "src/a.ts", line: 3, rule: "secret", message: "msg" }]);
    expect(out).toMatch(/\[secret\] src\/a\.ts:3/);
    expect(out).toMatch(/blocked this commit/);
  });
});
