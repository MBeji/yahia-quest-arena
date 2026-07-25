import { describe, expect, it } from "vitest";

import {
  assertLockfileSafeNpm,
  assertOverridesUnchanged,
  assertSafePackageNames,
  buildPlan,
  bumpKind,
  classifyOutdated,
  groupMajors,
  majorGroupOf,
  normalizeOutdated,
  readOutdated,
  renderPrBody,
  semverParts,
} from "../apply-patch-minor.mjs";

describe("semverParts / bumpKind", () => {
  it("parses plain and v-prefixed versions, rejects the rest", () => {
    expect(semverParts("1.2.3")).toEqual([1, 2, 3]);
    expect(semverParts("v10.9.7")).toEqual([10, 9, 7]);
    expect(semverParts("4.1.10-beta.2")).toEqual([4, 1, 10]);
    expect(semverParts("workspace:*")).toBeNull();
    expect(semverParts(undefined)).toBeNull();
  });

  it("classifies the step size", () => {
    expect(bumpKind("1.2.3", "1.2.4")).toBe("patch");
    expect(bumpKind("1.2.3", "1.3.0")).toBe("minor");
    expect(bumpKind("1.2.3", "2.0.0")).toBe("major");
    expect(bumpKind("1.2.3", "1.2.3")).toBe("none");
    expect(bumpKind("1.2.3", "1.2.2")).toBe("none"); // never downgrade
    expect(bumpKind("1.2.3", "1.1.9")).toBe("none");
    expect(bumpKind("git://x", "1.0.0")).toBeNull();
  });
});

describe("normalizeOutdated", () => {
  it("collapses the array form npm uses for multi-location deps", () => {
    expect(
      normalizeOutdated({
        a: [{ current: "1.0.0", wanted: "1.0.1", latest: "1.0.1" }, { current: "0.9.0" }],
        b: { current: "2.0.0", wanted: "2.1.0", latest: "3.0.0" },
        c: null,
      }),
    ).toEqual({
      a: { current: "1.0.0", wanted: "1.0.1", latest: "1.0.1" },
      b: { current: "2.0.0", wanted: "2.1.0", latest: "3.0.0" },
    });
  });
});

describe("majorGroupOf / groupMajors", () => {
  it("keeps the sets that must move together in one group", () => {
    expect(majorGroupOf("@tanstack/react-router")).toBe("tanstack");
    expect(majorGroupOf("@tanstack/react-query")).toBe("tanstack");
    expect(majorGroupOf("react-dom")).toBe("react");
    expect(majorGroupOf("@types/react")).toBe("react");
    expect(majorGroupOf("zod")).toBeNull();
  });

  it("groups the TanStack set as ONE major and leaves a lone package alone", () => {
    const groups = groupMajors([
      { name: "@tanstack/react-router", from: "1.9.0", to: "2.0.0", group: "tanstack" },
      { name: "@tanstack/react-start", from: "1.9.0", to: "2.0.0", group: "tanstack" },
      { name: "zod", from: "3.9.0", to: "4.0.0", group: null },
    ]);
    expect(groups).toHaveLength(2);
    expect(groups.find((g) => g.group === "tanstack").packages.map((p) => p.name)).toEqual([
      "@tanstack/react-router",
      "@tanstack/react-start",
    ]);
    expect(groups.find((g) => g.group === "zod").packages).toHaveLength(1);
  });
});

describe("classifyOutdated", () => {
  const outdated = {
    "in-range-patch": { current: "1.0.0", wanted: "1.0.4", latest: "1.0.4" },
    "in-range-minor": { current: "2.1.0", wanted: "2.4.0", latest: "2.4.0" },
    "minor-plus-major": { current: "3.0.0", wanted: "3.2.0", latest: "4.0.0" },
    "major-only": { current: "5.1.0", wanted: "5.1.0", latest: "6.0.0" },
    "already-current": { current: "1.0.0", wanted: "1.0.0", latest: "1.0.0" },
  };

  it("puts the in-range steps in the lot and the out-of-range majors aside", () => {
    const { patchMinor, majors, excluded } = classifyOutdated(outdated);
    expect(patchMinor).toEqual([
      { name: "in-range-minor", from: "2.1.0", to: "2.4.0", kind: "minor" },
      { name: "in-range-patch", from: "1.0.0", to: "1.0.4", kind: "patch" },
      { name: "minor-plus-major", from: "3.0.0", to: "3.2.0", kind: "minor" },
    ]);
    expect(majors.map((m) => m.name)).toEqual(["major-only", "minor-plus-major"]);
    expect(excluded).toEqual([]);
  });

  it("keeps a package that has BOTH an in-range minor and a major in both lists", () => {
    const { patchMinor, majors } = classifyOutdated(outdated);
    expect(patchMinor.some((p) => p.name === "minor-plus-major")).toBe(true);
    expect(majors.find((m) => m.name === "minor-plus-major")).toMatchObject({
      from: "3.2.0",
      to: "4.0.0",
    });
  });

  it("honours --hold by excluding the package with a reason", () => {
    const { patchMinor, excluded } = classifyOutdated(outdated, ["in-range-patch"]);
    expect(patchMinor.map((p) => p.name)).not.toContain("in-range-patch");
    expect(excluded).toEqual([
      {
        name: "in-range-patch",
        current: "1.0.0",
        wanted: "1.0.4",
        kind: "patch",
        reason: "held back",
      },
    ]);
  });

  it("never guesses at an unparseable version — it reports it", () => {
    const { patchMinor, excluded } = classifyOutdated({
      weird: { current: "git+ssh://x", wanted: "1.0.0", latest: "1.0.0" },
    });
    expect(patchMinor).toEqual([]);
    expect(excluded[0]).toMatchObject({ name: "weird", reason: "unparseable version" });
  });

  it("refuses an in-range MAJOR (a loose range) instead of folding it into the lot", () => {
    const { patchMinor, excluded } = classifyOutdated({
      loose: { current: "1.0.0", wanted: "2.0.0", latest: "2.0.0" },
    });
    expect(patchMinor).toEqual([]);
    expect(excluded[0]).toMatchObject({ name: "loose", kind: "major" });
  });

  // The hole L4 shipped with: `^0.185.0` cannot reach 0.186.0 (npm caret rule on a 0.x
  // line), so three/@types/three, class-variance-authority and eslint-plugin-react-refresh
  // were in NEITHER list — not in the lot, not handed to the agent, upgraded by nobody.
  it("hands the agent a 0.x line the declared range cannot reach", () => {
    const { patchMinor, majors } = classifyOutdated({
      three: { current: "0.185.0", wanted: "0.185.1", latest: "0.186.0" },
    });
    // The in-range patch still rides the lot…
    expect(patchMinor).toEqual([{ name: "three", from: "0.185.0", to: "0.185.1", kind: "patch" }]);
    // …and the unreachable 0.186.0 goes to the agent, tagged with the boundary it crosses.
    expect(majors).toEqual([
      { name: "three", from: "0.185.1", to: "0.186.0", group: "three", boundary: "minor" },
    ]);
  });

  it("hands the agent an out-of-range patch (an exact pin or a ~ range)", () => {
    const { patchMinor, majors } = classifyOutdated({
      pinned: { current: "1.2.3", wanted: "1.2.3", latest: "1.2.4" },
    });
    expect(patchMinor).toEqual([]);
    expect(majors).toEqual([
      { name: "pinned", from: "1.2.3", to: "1.2.4", group: null, boundary: "patch" },
    ]);
  });

  it("tags a real major crossing as such", () => {
    const { majors } = classifyOutdated({
      zod: { current: "3.9.0", wanted: "3.9.0", latest: "4.0.0" },
    });
    expect(majors[0]).toMatchObject({ boundary: "major" });
  });

  it("reports a declared-but-uninstalled package instead of silently dropping it", () => {
    const { patchMinor, majors, excluded } = classifyOutdated({
      ghost: { wanted: "6.3.1", latest: "6.3.1" },
    });
    expect(patchMinor).toEqual([]);
    expect(majors).toEqual([]);
    expect(excluded).toEqual([
      { name: "ghost", current: null, wanted: "6.3.1", kind: "unknown", reason: "not installed" },
    ]);
  });

  it("ignores an up-to-date package entirely", () => {
    const { patchMinor, majors, excluded } = classifyOutdated({
      fine: { current: "1.0.0", wanted: "1.0.0", latest: "1.0.0" },
    });
    expect([patchMinor, majors, excluded]).toEqual([[], [], []]);
  });
});

describe("buildPlan / renderPrBody", () => {
  const plan = buildPlan(
    {
      vite: { current: "8.0.1", wanted: "8.0.3", latest: "8.0.3" },
      zod: { current: "3.9.0", wanted: "3.9.1", latest: "4.0.0" },
      "@tanstack/react-router": { current: "1.9.0", wanted: "1.9.0", latest: "2.0.0" },
      "@tanstack/react-start": { current: "1.9.0", wanted: "1.9.0", latest: "2.0.0" },
      flaky: { current: "1.0.0", wanted: "1.0.1", latest: "1.0.1" },
    },
    ["flaky"],
  );

  it("counts the lot, the exclusions and the major groups", () => {
    expect(plan.counts).toEqual({ patchMinor: 2, excluded: 1, majors: 3, majorGroups: 2 });
  });

  it("renders the bump table, the held-back list and the majors as groups", () => {
    const body = renderPrBody(plan, "2026-07-25");
    expect(body).toContain("| `vite` | 8.0.1 | 8.0.3 | patch |");
    expect(body).toContain("| `zod` | 3.9.0 | 3.9.1 | patch |");
    expect(body).toContain("- `flaky` (1.0.0 → 1.0.1) — held back");
    expect(body).toContain("**tanstack**");
    expect(body).toContain("`@tanstack/react-router` 1.9.0 → 2.0.0");
    expect(body).toContain("auto-merge si le gate complet");
    // The held-back package must not sneak into the applied table.
    expect(body).not.toContain("| `flaky` |");
  });

  it("says so plainly when there is nothing to raise in range", () => {
    const empty = buildPlan({ fine: { current: "1.0.0", wanted: "1.0.0", latest: "1.0.0" } });
    expect(renderPrBody(empty, "2026-07-25")).toContain("Aucune montée dans les ranges");
  });

  it("groups a 0.x runtime with its @types and says why they are out of the lot", () => {
    const zerox = buildPlan({
      three: { current: "0.185.1", wanted: "0.185.1", latest: "0.186.0" },
      "@types/three": { current: "0.185.1", wanted: "0.185.1", latest: "0.186.0" },
      ghost: { wanted: "1.0.0", latest: "1.0.0" },
    });
    expect(zerox.counts).toEqual({ patchMinor: 0, excluded: 1, majors: 2, majorGroups: 1 });

    const body = renderPrBody(zerox, "2026-07-25");
    expect(body).toContain("Hors des ranges déclarés");
    expect(body).toContain("`three` 0.185.1 → 0.186.0 (hors range, saut minor)");
    expect(body).toContain("`@types/three` 0.185.1 → 0.186.0 (hors range, saut minor)");
    expect(body).toContain("- `ghost` (absent → 1.0.0) — not installed");
  });
});

describe("repo traps, enforced instead of remembered", () => {
  it("accepts npm 10 and refuses npm 11 for the lockfile", () => {
    expect(assertLockfileSafeNpm("10.9.7")).toBe(true);
    expect(() => assertLockfileSafeNpm("11.0.1")).toThrow(/npm 10/);
    expect(() => assertLockfileSafeNpm("9.8.1")).toThrow(/npm 10/);
    expect(() => assertLockfileSafeNpm("not-a-version")).toThrow(/cannot parse/);
  });

  it("aborts when the overrides block (the esbuild security pin) moved", () => {
    const pin = { esbuild: "^0.25.10" };
    expect(assertOverridesUnchanged(pin, { esbuild: "^0.25.10" })).toBe(true);
    expect(() => assertOverridesUnchanged(pin, {})).toThrow(/esbuild security pin/);
    expect(() => assertOverridesUnchanged(pin, undefined)).toThrow(/esbuild security pin/);
  });
});

describe("readOutdated", () => {
  it("parses the JSON npm prints even though it exits non-zero when outdated", () => {
    const run = () => {
      const err = new Error("exit 1");
      err.status = 1;
      err.stdout = '{"vite":{"current":"8.0.1","wanted":"8.0.3","latest":"8.0.3"}}';
      throw err;
    };
    expect(readOutdated(run)).toEqual({
      vite: { current: "8.0.1", wanted: "8.0.3", latest: "8.0.3" },
    });
  });

  it("treats empty output as an up-to-date stack", () => {
    expect(readOutdated(() => "")).toEqual({});
    expect(readOutdated(() => "\n")).toEqual({});
  });

  // A spawn failure has no exit status: `npm` missing from PATH, or Windows refusing to run
  // `npm.cmd` without a shell. Swallowing it reported a perfectly up-to-date stack.
  it("rethrows a spawn failure instead of reporting an empty stack", () => {
    const run = () => {
      const err = new Error("spawn npm ENOENT");
      err.code = "ENOENT";
      err.status = null;
      throw err;
    };
    expect(() => readOutdated(run)).toThrow(/ENOENT/);
  });

  it("rethrows a non-zero exit that produced no output", () => {
    const run = () => {
      const err = new Error("EJSONPARSE");
      err.status = 1;
      err.stdout = "";
      throw err;
    };
    expect(() => readOutdated(run)).toThrow(/EJSONPARSE/);
  });
});

describe("assertSafePackageNames", () => {
  it("accepts the scoped and plain names npm actually reports", () => {
    expect(assertSafePackageNames(["vite", "@tanstack/react-router", "@types/three"])).toBe(true);
  });

  it("refuses anything that could reach a shell as something else", () => {
    expect(() => assertSafePackageNames(["vite", "zod && rm -rf /"])).toThrow(/non-package-name/);
    expect(() => assertSafePackageNames(["--registry=http://evil"])).toThrow(/non-package-name/);
  });
});
