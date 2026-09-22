// @vitest-environment node
import { describe, expect, it } from "vitest";

import {
  assertLockfileSafeNpm,
  assertOverridesUnchanged,
  assertSafePackageNames,
  buildPlan,
  bumpKind,
  classifyOutdated,
  dropFromPlan,
  eresolveCulprits,
  eresolveReason,
  MAX_CONFLICT_RETRIES,
  groupMajors,
  isolateFailures,
  majorGroupOf,
  normalizeOutdated,
  readOutdated,
  renderPrBody,
  semverParts,
  updateWithConflictRetry,
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

// Le conflit réel de #1092, tel que npm 10 l'imprime.
const ERESOLVE_1092 = [
  "npm error code ERESOLVE",
  "npm error ERESOLVE could not resolve",
  "npm error",
  "npm error While resolving: @react-three/fiber@9.7.0",
  "npm error Found: react@19.3.0",
  "npm error node_modules/react",
  'npm error   react@"^19.2.7" from the root project',
  'npm error   peer react@"^19.3.0" from react-dom@19.3.0',
  "npm error",
  "npm error Could not resolve dependency:",
  'npm error peer react@">=19 <19.3" from @react-three/fiber@9.7.0',
  "npm error node_modules/@react-three/fiber",
  'npm error   @react-three/fiber@"^9.6.1" from the root project',
  "npm error",
  "npm error Conflicting peer dependency: react@19.2.9",
].join("\n");

function lotOf(...names) {
  return buildPlan(
    Object.fromEntries(
      names.map((n) => [n, { current: "1.0.0", wanted: "1.1.0", latest: "1.1.0" }]),
    ),
  );
}

describe("peer conflicts (ERESOLVE) — #1092", () => {
  it("names the DEPENDENT whose peer range breaks, not the dependency it retards", () => {
    expect(
      eresolveCulprits(ERESOLVE_1092, ["react", "react-dom", "@react-three/fiber", "vite"]),
    ).toEqual(["@react-three/fiber"]);
  });

  it("falls back to every lot package the error names when no dependent is in the lot", () => {
    // react-dom only appears in npm's indented context, where its peer HOLDS: not a culprit.
    expect(eresolveCulprits(ERESOLVE_1092, ["react", "react-dom", "vite"])).toEqual(["react"]);
  });

  it("names nothing outside the lot", () => {
    expect(eresolveCulprits(ERESOLVE_1092, ["vite"])).toEqual([]);
  });

  it("reads the old `npm ERR!` prefix too", () => {
    const old = ERESOLVE_1092.replaceAll("npm error", "npm ERR!");
    expect(eresolveCulprits(old, ["react", "@react-three/fiber"])).toEqual(["@react-three/fiber"]);
  });

  it("extracts the line that says why", () => {
    expect(eresolveReason(ERESOLVE_1092)).toBe(
      'peer react@">=19 <19.3" from @react-three/fiber@9.7.0',
    );
  });

  it("moves a dropped package to `excluded` with its reason and recounts", () => {
    const plan = dropFromPlan(lotOf("a", "b"), ["b"], "conflit");
    expect(plan.patchMinor.map((p) => p.name)).toEqual(["a"]);
    expect(plan.excluded).toContainEqual({
      name: "b",
      current: "1.0.0",
      wanted: "1.1.0",
      kind: "minor",
      reason: "conflit",
    });
    expect(plan.counts).toMatchObject({ patchMinor: 1, excluded: 1 });
  });

  it("drops the culprit and applies the rest — one conflict no longer sinks the lot", () => {
    const calls = [];
    const run = (args) => {
      calls.push(args.slice(1));
      if (args.includes("@react-three/fiber")) {
        throw Object.assign(new Error("exit 1"), { status: 1, stderr: ERESOLVE_1092 });
      }
      return "";
    };
    const applied = updateWithConflictRetry(
      lotOf("react", "@react-three/fiber", "vite"),
      run,
      () => {},
    );
    expect(calls).toHaveLength(2);
    expect(calls[1]).toEqual(["react", "vite"]);
    expect(applied.patchMinor.map((p) => p.name)).toEqual(["react", "vite"]);
    const dropped = applied.excluded.find((e) => e.name === "@react-three/fiber");
    expect(dropped.reason).toMatch(/ERESOLVE/);
    expect(dropped.reason).toContain('peer react@">=19 <19.3"');
  });

  it("isolates a package that fails ON ITS OWN when npm names nobody (vite 8.3, 2026-09-22)", () => {
    const crash = "npm error Cannot read properties of null (reading 'edgesOut')";
    let restores = 0;
    const calls = [];
    const run = (args) => {
      calls.push(args.slice(1).join(" "));
      if (args.includes("vite"))
        throw Object.assign(new Error("exit 1"), { status: 1, stderr: crash });
      return "";
    };
    const applied = updateWithConflictRetry(
      lotOf("react", "vite", "zod"),
      run,
      () => {},
      () => restores++,
    );
    expect(calls).toEqual(["react vite zod", "react", "vite", "zod", "react zod"]);
    expect(applied.patchMinor.map((p) => p.name)).toEqual(["react", "zod"]);
    expect(applied.excluded.find((e) => e.name === "vite").reason).toContain("edgesOut");
    expect(restores).toBeGreaterThanOrEqual(4); // before each solo try, and after them
  });

  it("refuses to guess when the lot fails but every package passes alone", () => {
    const run = (args) => {
      if (args.length > 2) throw Object.assign(new Error("exit 1"), { status: 1, stderr: "boom" });
      return "";
    };
    expect(() => updateWithConflictRetry(lotOf("a", "b"), run, () => {})).toThrow(
      /every package passes on its own/,
    );
  });

  it("isolateFailures reports each solo failure with npm's first error line", () => {
    const run = (args) => {
      if (args[1] === "b") {
        throw Object.assign(new Error("x"), {
          stderr: "npm error code E404\nnpm error 404 Not Found - b",
        });
      }
    };
    expect(
      isolateFailures(
        ["a", "b"],
        run,
        () => {},
        () => {},
      ),
    ).toEqual([{ name: "b", why: "404 Not Found - b" }]);
  });

  it("gives up after MAX_CONFLICT_RETRIES drops instead of whittling the lot away", () => {
    const names = Array.from({ length: MAX_CONFLICT_RETRIES + 2 }, (_, i) => `p${i}`);
    let calls = 0;
    const run = (args) => {
      calls++;
      const victim = args[1];
      throw Object.assign(new Error("exit 1"), {
        status: 1,
        stderr: `npm error code ERESOLVE\nnpm error While resolving: ${victim}@1.1.0`,
      });
    };
    expect(() => updateWithConflictRetry(lotOf(...names), run, () => {})).toThrow(
      /still fails after/,
    );
    expect(calls).toBe(MAX_CONFLICT_RETRIES + 1);
  });

  it("falls back to the solo try when ERESOLVE names nothing in the lot", () => {
    const run = () => {
      throw Object.assign(new Error("exit 1"), {
        status: 1,
        stderr: "npm error code ERESOLVE\nnpm error While resolving: elsewhere@1.0.0",
      });
    };
    // Nothing named in the lot: the solo try takes over, `a` fails alone too, the lot empties.
    expect(() => updateWithConflictRetry(lotOf("a"), run, () => {})).toThrow(/every package/);
  });
});
