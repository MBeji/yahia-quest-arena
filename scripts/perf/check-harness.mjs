/**
 * Keep the k6 load harness honest in the regular CI gate — no k6 binary, no
 * Supabase secrets required. Two guards:
 *
 *   1. Every scenario / lib file under perf/k6 is syntactically valid
 *      (`node --check`) so a broken script can't silently rot until someone
 *      runs a load test.
 *   2. The harness constants (perf/k6/lib/constants.js) still match the product
 *      source of truth — LEADERBOARD_LIMIT and the submit rate-limit budget —
 *      so the load profiles keep reproducing the REAL hot paths. A drift here
 *      means the load test is measuring a fiction.
 *
 * Exits non-zero on any failure. Wired into ci.yml (every PR) and perf.yml.
 */
import { readdirSync, readFileSync, statSync } from "node:fs";
import { execFileSync } from "node:child_process";
import { join } from "node:path";

const ROOT = new URL("../../", import.meta.url).pathname;
const K6_DIR = join(ROOT, "perf/k6");
let errors = 0;
const fail = (m) => {
  errors++;
  console.log("✗ " + m);
};
const ok = (m) => console.log("✓ " + m);

// ---- 1. Syntax-check every JS file in perf/k6 -------------------------------
function walk(dir) {
  for (const name of readdirSync(dir)) {
    const p = join(dir, name);
    if (statSync(p).isDirectory()) walk(p);
    else if (name.endsWith(".js")) {
      try {
        execFileSync(process.execPath, ["--check", p], { stdio: "pipe" });
      } catch (e) {
        fail(
          `syntax error in ${p.replace(ROOT, "")}: ${e.stderr?.toString().split("\n")[0] ?? e.message}`,
        );
      }
    }
  }
}
walk(K6_DIR);
if (errors === 0) ok("all perf/k6 scripts parse");

// ---- 2. Constants stay in sync with the product -----------------------------
const harness = readFileSync(join(K6_DIR, "lib/constants.js"), "utf8");
const gamification = readFileSync(join(ROOT, "src/shared/constants/gamification.ts"), "utf8");
const quest = readFileSync(join(ROOT, "src/features/quest/quest.server.ts"), "utf8");

function num(src, re, label) {
  const m = src.match(re);
  if (!m) {
    fail(`could not locate ${label}`);
    return null;
  }
  return Number(m[1]);
}

const harnessLimit = num(harness, /LEADERBOARD_LIMIT\s*=\s*(\d+)/, "LEADERBOARD_LIMIT (harness)");
const appLimit = num(gamification, /LEADERBOARD_LIMIT\s*=\s*(\d+)/, "LEADERBOARD_LIMIT (app)");
if (harnessLimit !== null && harnessLimit !== appLimit)
  fail(`LEADERBOARD_LIMIT drift: harness=${harnessLimit} vs app=${appLimit}`);
else if (harnessLimit !== null) ok(`LEADERBOARD_LIMIT in sync (${appLimit})`);

// quest.server.ts: isRateLimited(supabase, `submit_${userId}`, 5, 10_000)
// JS numeric separators (10_000) survive in source, so strip "_" before Number.
const toInt = (s) => (s == null ? null : Number(String(s).replace(/_/g, "")));
const rlMax = num(harness, /SUBMIT_RL_MAX\s*=\s*(\d+)/, "SUBMIT_RL_MAX (harness)");
const harWin = toInt(harness.match(/SUBMIT_RL_WINDOW_MS\s*=\s*([\d_]+)/)?.[1]);
const appRl = quest.match(/submit_\$\{userId\}`,\s*(\d+),\s*([\d_]+)/);
if (harWin === null) fail("could not locate SUBMIT_RL_WINDOW_MS (harness)");
if (!appRl) {
  fail("could not locate the submit rate-limit budget in quest.server.ts");
} else {
  const appMax = Number(appRl[1]);
  const appWin = toInt(appRl[2]);
  if (rlMax !== appMax) fail(`submit rate-limit MAX drift: harness=${rlMax} vs app=${appMax}`);
  if (harWin !== appWin) fail(`submit rate-limit WINDOW drift: harness=${harWin} vs app=${appWin}`);
  if (rlMax === appMax && harWin === appWin)
    ok(`submit rate-limit budget in sync (${appMax}/${appWin}ms)`);
}

if (errors) {
  console.log(`\n${errors} harness check(s) failed.`);
  process.exit(1);
}
console.log("\nperf harness OK");
