/**
 * Deterministic patch/minor dependency lot (étude "IA → déterministe", lot L4).
 *
 * `upgrade-guard.yml` is the most expensive job in the repo: an agent holds a runner for many
 * minutes, twice a week. But its nominal output — the patch/minor lot — is a CLOSED procedure,
 * spelled out step by step in the skill: `npm outdated` → `npm update` inside the declared
 * ranges → full lockfile install → `npm run ci:verify` → one PR labelled `dependencies`.
 * Nothing in there needs judgement, so nothing in there needs an agent (§4.4).
 *
 * This script owns exactly that lot, in two phases:
 *
 *   detect  → reads `npm outdated --json`, splits it into the in-range patch/minor lot and
 *             everything the declared ranges cannot reach (major boundaries AND 0.x lines),
 *             groups what MUST move together, and writes a machine-readable plan (+ a
 *             ready-to-post PR body).
 *   apply   → `npm update <planned…>` then a full `npm install` to normalise the lockfile.
 *
 * WHAT STAYS IA (§4.4/§4.6), and why:
 *   - **majors**: reading a changelog, judging a breaking change, writing the migration. The
 *     plan hands the agent grouped majors so it never has to discover them itself.
 *   - **a red patch/minor lot**: deciding between "this is a correct changelog-prescribed
 *     adjustment, fix it properly" and "hold this one package back" is a judgement call. The
 *     script supports the outcome (`--hold`) but does not make the call.
 *
 * SCOPE, deliberately narrow: the **npm** lot only. The Node toolchain, the pinned Supabase
 * CLI and the GitHub Actions SHAs are major-class by the skill's own rules (each needs its own
 * PR and a changelog read), so they stay entirely with the agent.
 *
 * Two repo traps stop being prompt text and become hard checks here — the whole point of the
 * étude, since a trap only honoured when the agent remembers it is not a guardrail:
 *   - **npm 10, never 11** for the lockfile (npm 11 rewrites cross-platform native bindings →
 *     `npm ci` then fails on Linux CI);
 *   - the **`overrides` block must survive untouched** (it carries the global esbuild security
 *     pin) — compared before/after the update, and a change aborts the apply.
 */
import { execFileSync } from "node:child_process";
import { readFileSync, writeFileSync, appendFileSync } from "node:fs";
import { pathToFileURL } from "node:url";

/**
 * Packages that must move as ONE major: upgrading half a set leaves the app in a state no
 * changelog describes. The skill names the TanStack set explicitly; type-defs travel with
 * their runtime for the same reason. `three` ships its breaking releases on a 0.x line
 * (0.185 → 0.186), which is why "out of the declared range" — not "crosses a major" — is the
 * criterion in `classifyOutdated`: with the narrower rule this group could never fire.
 */
export const MAJOR_GROUPS = [
  {
    name: "tanstack",
    match: /^@tanstack\//,
  },
  {
    name: "react",
    match: /^(react|react-dom|@types\/react|@types\/react-dom)$/,
  },
  {
    name: "three",
    match: /^(three|@types\/three)$/,
  },
];

/** Parse a semver-ish version into [major, minor, patch]; null when it is not parseable. */
export function semverParts(version) {
  const m = /^v?(\d+)\.(\d+)\.(\d+)/.exec(String(version ?? "").trim());
  return m ? [Number(m[1]), Number(m[2]), Number(m[3])] : null;
}

/** How big is the step from `from` to `to`? "none" when equal/downgrade, null when unparseable. */
export function bumpKind(from, to) {
  const a = semverParts(from);
  const b = semverParts(to);
  if (!a || !b) return null;
  if (b[0] > a[0]) return "major";
  if (b[0] < a[0]) return "none"; // a downgrade is never part of a lot
  if (b[1] > a[1]) return "minor";
  if (b[1] < a[1]) return "none";
  if (b[2] > a[2]) return "patch";
  return "none";
}

/**
 * `npm outdated --json` reports one object per package, but the value is an ARRAY when the same
 * dependency is installed at several locations. Normalise to a single entry (the first, which is
 * the top-level one) so the rest of the code sees one shape.
 */
export function normalizeOutdated(raw) {
  const out = {};
  for (const [name, value] of Object.entries(raw ?? {})) {
    const entry = Array.isArray(value) ? value[0] : value;
    if (entry && typeof entry === "object") out[name] = entry;
  }
  return out;
}

/** Which major group does a package belong to? `null` = it moves on its own. */
export function majorGroupOf(name) {
  return MAJOR_GROUPS.find((g) => g.match.test(name))?.name ?? null;
}

/**
 * Split `npm outdated` into the in-range patch/minor lot and everything the declared range
 * cannot reach.
 *
 * `current` → `wanted` is what `npm update` does (inside the declared `^` range).
 * `wanted` → `latest` is, by construction of `npm outdated`, **out of that range**: reaching
 * it means editing `package.json`, reading a changelog and shipping its own PR — i.e. the
 * agent. That holds whatever the numeric distance, and counting only major boundaries left a
 * silent hole: under npm's caret rule `^0.185.0` can no more reach 0.186.0 than `^1.9.0` can
 * reach 2.0.0, so every 0.x package of the repo (`three`, `@types/three`,
 * `class-variance-authority`, `eslint-plugin-react-refresh`) landed in NEITHER list — frozen,
 * with nobody left to notice since the agent no longer reads `npm outdated` itself. Same hole
 * for a `~` range or an exact pin. `boundary` keeps the distinction the agent needs to size
 * its changelog read.
 *
 * @param {object} raw            parsed `npm outdated --json`
 * @param {string[]} heldBack     packages to exclude from the lot (an earlier red gate)
 */
export function classifyOutdated(raw, heldBack = []) {
  const held = new Set(heldBack);
  const outdated = normalizeOutdated(raw);
  const patchMinor = [];
  const majors = [];
  const excluded = [];

  for (const name of Object.keys(outdated).sort()) {
    const { current, wanted, latest } = outdated[name];

    if (!current) {
      // Declared but absent from the tree (npm reports no `current`): there is nothing to
      // update FROM. Reported rather than dropped — a lot that concludes "nothing to do"
      // because the tree is broken is exactly the silent no-op this étude exists to prevent.
      excluded.push({ name, current: null, wanted, kind: "unknown", reason: "not installed" });
    } else {
      // In-range step (what `npm update` will do).
      const inRange = bumpKind(current, wanted);
      if (inRange === "patch" || inRange === "minor") {
        if (held.has(name)) {
          excluded.push({ name, current, wanted, kind: inRange, reason: "held back" });
        } else {
          patchMinor.push({ name, from: current, to: wanted, kind: inRange });
        }
      } else if (inRange === null && wanted && current !== wanted) {
        // Unparseable versions (git/file/alias specs): never guessed at, always reported.
        excluded.push({ name, current, wanted, kind: "unknown", reason: "unparseable version" });
      } else if (inRange === "major") {
        // Defensive: a range that can reach a major (e.g. `*`) is NOT a patch/minor lot item.
        excluded.push({
          name,
          current,
          wanted,
          kind: "major",
          reason: "in-range major — needs review",
        });
      }
    }

    // Out of the declared range: handed to the agent, never applied here.
    const boundary = bumpKind(wanted, latest);
    if (boundary && boundary !== "none") {
      majors.push({ name, from: wanted, to: latest, group: majorGroupOf(name), boundary });
    }
  }
  return { patchMinor, majors, excluded };
}

/** Collapse majors into the groups that must move together (one PR per group). */
export function groupMajors(majors) {
  const groups = new Map();
  for (const m of majors) {
    const key = m.group ?? `solo:${m.name}`;
    if (!groups.has(key)) groups.set(key, { group: m.group ?? m.name, packages: [] });
    groups.get(key).packages.push(m);
  }
  return [...groups.values()];
}

/** The full plan: the lot to apply, the majors to hand over, what was left out and why. */
export function buildPlan(raw, heldBack = []) {
  const { patchMinor, majors, excluded } = classifyOutdated(raw, heldBack);
  return {
    lot: "L4 (étude IA → déterministe)",
    patchMinor,
    excluded,
    majorGroups: groupMajors(majors),
    counts: {
      patchMinor: patchMinor.length,
      excluded: excluded.length,
      majors: majors.length,
      majorGroups: groupMajors(majors).length,
    },
  };
}

/** The PR body, rendered from the plan — the same table the skill asks for, minus the agent. */
export function renderPrBody(plan, date) {
  const lines = [
    `## Lot patch & minor du ${date}`,
    "",
    "Monté **dans les ranges déclarés** (`npm update`, aucun franchissement de major) par",
    "`scripts/deps/apply-patch-minor.mjs` — lot déterministe, sans agent (étude IA → déterministe, L4).",
    "",
  ];

  if (plan.patchMinor.length === 0) {
    lines.push("_Aucune montée dans les ranges._", "");
  } else {
    lines.push("| Paquet | De | Vers | Type |", "| ------ | -- | ---- | ---- |");
    for (const p of plan.patchMinor)
      lines.push(`| \`${p.name}\` | ${p.from} | ${p.to} | ${p.kind} |`);
    lines.push("");
  }

  if (plan.excluded.length > 0) {
    lines.push("### Écartés du lot", "");
    for (const e of plan.excluded)
      lines.push(`- \`${e.name}\` (${e.current ?? "absent"} → ${e.wanted}) — ${e.reason}`);
    lines.push("");
  }

  if (plan.majorGroups.length > 0) {
    lines.push(
      "### Hors des ranges déclarés (chacune sa PR)",
      "",
      "Ces montées demandent une **édition de `package.json`** : le range déclaré ne les atteint",
      "pas — franchissement de major, ou ligne 0.x (`^0.185.0` n'atteint pas 0.186.0). Chacune",
      "part dans **sa propre PR**, après lecture de son changelog — c'est le rôle que le garde",
      "agent conserve (§4.4 de l'étude).",
      "",
    );
    for (const g of plan.majorGroups) {
      const pkgs = g.packages
        .map(
          (p) =>
            `\`${p.name}\` ${p.from} → ${p.to}` +
            (p.boundary && p.boundary !== "major" ? ` (hors range, saut ${p.boundary})` : ""),
        )
        .join(", ");
      lines.push(`- **${g.group}** : ${pkgs}`);
    }
    lines.push("");
  }

  lines.push(
    "🤖 auto-merge si le gate complet + E2E (public + authentifié) + pgTAP sont verts (garde nocturne).",
  );
  return `${lines.join("\n")}\n`;
}

/** The npm that regenerates the lockfile must be 10.x — npm 11 breaks `npm ci` on Linux CI. */
export function assertLockfileSafeNpm(version) {
  const parts = semverParts(version);
  if (!parts) throw new Error(`cannot parse the npm version ("${version}")`);
  if (parts[0] !== 10) {
    throw new Error(
      `npm ${version} would rewrite the lockfile's cross-platform native bindings — this repo ` +
        `pins the lockfile to npm 10 (see the upgrade-guard skill's trap list). Aborting.`,
    );
  }
  return true;
}

/** The `overrides` block carries the global esbuild security pin: it must survive an update. */
export function assertOverridesUnchanged(before, after) {
  const a = JSON.stringify(before ?? null);
  const b = JSON.stringify(after ?? null);
  if (a !== b) {
    throw new Error(
      `the package.json "overrides" block changed during the update (${a} → ${b}); it carries the ` +
        `global esbuild security pin and must never be dropped. Aborting.`,
    );
  }
  return true;
}

function emitOutput(key, value) {
  const file = process.env.GITHUB_OUTPUT;
  if (file) appendFileSync(file, `${key}=${value}\n`);
}

function emitSummary(markdown) {
  const file = process.env.GITHUB_STEP_SUMMARY;
  if (file) appendFileSync(file, `${markdown}\n`);
}

function argValue(flag) {
  const i = process.argv.indexOf(flag);
  return i !== -1 ? process.argv[i + 1] : null;
}

/**
 * npm ships as `npm.cmd` on Windows, which `execFile` does not resolve — and Node refuses to
 * spawn a `.cmd` without a shell since CVE-2024-27980. CI is Linux, but the skill invites
 * driving this script by hand in a local session, where the spawn failure used to be read as
 * "the stack is up to date" (see `readOutdated`). Args are package names, validated by
 * `assertSafePackageNames` before they ever reach a shell.
 */
const npm = (args) =>
  execFileSync("npm", args, {
    encoding: "utf8",
    stdio: ["ignore", "pipe", "inherit"],
    shell: process.platform === "win32",
  });

/** npm's own package-name grammar — the only thing this script ever passes to `npm update`. */
const SAFE_PACKAGE_NAME = /^(?:@[a-z0-9-~][a-z0-9-._~]*\/)?[a-z0-9-~][a-z0-9-._~]*$/;

/** Nothing but a real package name reaches the command line (Windows runs it through a shell). */
export function assertSafePackageNames(names) {
  const bad = names.filter((n) => !SAFE_PACKAGE_NAME.test(n));
  if (bad.length > 0) {
    throw new Error(`refusing to pass a non-package-name to npm: ${bad.join(", ")}`);
  }
  return true;
}

/**
 * `npm outdated` exits non-zero as soon as anything is outdated — that is not an error, and
 * the JSON is still on stdout. Everything else IS an error: a spawn failure (npm missing, a
 * `.cmd` refused) or a genuine npm crash has no usable output, and swallowing it would report
 * an empty, perfectly up-to-date stack — the exact silent no-op this lot exists to avoid.
 */
export function readOutdated(run = npm) {
  let stdout = "";
  try {
    stdout = run(["outdated", "--json"]);
  } catch (err) {
    const out = String(err?.stdout ?? "");
    if (typeof err?.status !== "number" || out.trim() === "") throw err;
    stdout = out;
  }
  const text = String(stdout).trim();
  return text ? JSON.parse(text) : {};
}

function detect() {
  const heldBack = (argValue("--hold") ?? "")
    .split(",")
    .map((s) => s.trim())
    .filter(Boolean);
  const plan = buildPlan(readOutdated(), heldBack);

  const outPath = argValue("--out");
  if (outPath) writeFileSync(outPath, `${JSON.stringify(plan, null, 2)}\n`, "utf8");
  const bodyPath = argValue("--pr-body");
  if (bodyPath) writeFileSync(bodyPath, renderPrBody(plan, argValue("--date") ?? "—"), "utf8");

  console.log(
    `[deps] patch/minor=${plan.counts.patchMinor} hors-range=${plan.counts.majors} (${plan.counts.majorGroups} group(s)) excluded=${plan.counts.excluded}`,
  );
  for (const p of plan.patchMinor)
    console.log(`[deps]   ${p.name} ${p.from} → ${p.to} (${p.kind})`);
  for (const g of plan.majorGroups)
    console.log(
      `[deps]   OUT-OF-RANGE ${g.group}: ${g.packages
        .map((p) => `${p.name} ${p.from}→${p.to} (${p.boundary})`)
        .join(", ")}`,
    );
  for (const e of plan.excluded) console.log(`[deps]   excluded ${e.name}: ${e.reason}`);

  emitOutput("has_patch_minor", String(plan.counts.patchMinor > 0));
  emitOutput("has_majors", String(plan.counts.majors > 0));
  emitOutput("patch_minor_count", String(plan.counts.patchMinor));
  emitOutput("major_group_count", String(plan.counts.majorGroups));
  emitSummary(
    (plan.counts.patchMinor > 0
      ? `⬆️ **Lot patch/minor** : ${plan.counts.patchMinor} paquet(s) dans les ranges` +
        (plan.counts.majors > 0
          ? `, plus ${plan.counts.majors} montée(s) hors range laissée(s) à l'agent`
          : "") +
        "."
      : `✅ **Rien à monter dans les ranges.**` +
        (plan.counts.majors > 0
          ? ` ${plan.counts.majors} montée(s) hors range détectée(s) — traitée(s) hors lot.`
          : "")) +
      (plan.counts.excluded > 0 ? ` ${plan.counts.excluded} paquet(s) écarté(s) du lot.` : ""),
  );
  return plan;
}

function apply() {
  const planPath = argValue("--plan");
  if (!planPath) throw new Error("apply requires --plan <plan.json>");
  const plan = JSON.parse(readFileSync(planPath, "utf8"));
  const names = plan.patchMinor.map((p) => p.name);
  if (names.length === 0) {
    console.log("[deps] nothing to apply.");
    return plan;
  }

  assertSafePackageNames(names);
  assertLockfileSafeNpm(npm(["--version"]).trim());
  const overridesBefore = JSON.parse(readFileSync("package.json", "utf8")).overrides;

  console.log(`[deps] npm update ${names.join(" ")}`);
  npm(["update", ...names]);
  // Full install (never --package-lock-only): the lockfile must be normalised the way `npm ci`
  // will read it back in CI.
  console.log("[deps] npm install (normalising the lockfile)");
  npm(["install", "--no-audit", "--no-fund"]);

  assertOverridesUnchanged(
    overridesBefore,
    JSON.parse(readFileSync("package.json", "utf8")).overrides,
  );
  console.log(`[deps] applied ${names.length} in-range upgrade(s); overrides intact.`);
  return plan;
}

// CLI only — the pure helpers above stay importable from tests.
if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  const mode = process.argv[2];
  try {
    if (mode === "detect") detect();
    else if (mode === "apply") apply();
    else {
      console.error(
        "usage: apply-patch-minor.mjs <detect|apply> [--out plan.json] [--pr-body body.md] [--plan plan.json] [--hold pkg,pkg] [--date YYYY-MM-DD]",
      );
      process.exit(2);
    }
  } catch (err) {
    // Unlike a pre-gate, this script MUTATES the tree: a failure must be loud and red, never a
    // half-applied lot silently pushed to a branch.
    console.error(`[deps] ${err?.message ?? err}`);
    process.exit(1);
  }
}
