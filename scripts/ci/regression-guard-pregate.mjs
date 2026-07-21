/**
 * Deterministic pre-gate for the regression-guard workflow (étude "IA → déterministe",
 * lot L3). It decides — for free, in < 1 s — whether the day's changes can POSSIBLY need
 * a test-suite reconciliation, BEFORE spending an agent (tokens + a runner held for many
 * minutes) only to conclude "all green".
 *
 * The regression-guard agent reconciles the Vitest / pgTAP / Playwright suites with the
 * code/content merged to `main` in roughly the last 26 h. If nothing test-relevant changed
 * in that window — an empty window, or documentation-only commits — the agent would find
 * nothing to reconcile and post "all green". This script proves that case deterministically
 * and skips the agent, staying green.
 *
 * SAFE BY CONSTRUCTION (§4.3 "le pré-gate ne peut que skipper un run qui aurait dit vert"):
 * it skips ONLY when every commit in the window is provably documentation-only (or the
 * window is empty). Anything else — a src/DB/e2e/script/config change, anything not proven
 * inert — wakes the agent, whose real job ("is this failing test stale or a real bug?")
 * stays IA (§4.6). Two fail-safes preserve today's behaviour on any doubt:
 *   - a manual `workflow_dispatch` run bypasses the pre-gate in the workflow (the operator
 *     asked for a sweep — mirrors report-triage's "dispatch instantané inchangé");
 *   - any error here reports skip=false (run the agent), never a silent skip.
 */
import { execFileSync } from "node:child_process";
import { appendFileSync } from "node:fs";
import { pathToFileURL } from "node:url";

/**
 * True when a changed path cannot affect any test suite: pure documentation.
 * Markdown anywhere, or anything under `docs/`. Kept deliberately narrow — an
 * unknown path is treated as test-relevant so the agent still runs (safe direction).
 */
export function isDocsOnlyPath(file) {
  return /\.mdx?$/i.test(file) || file.startsWith("docs/");
}

/**
 * Decide whether the agent sweep can be skipped, from the window's commits.
 *
 * @param {{ sha: string, files: string[] }[]} commits  non-merge commits in the window
 * @returns {{ skip: boolean, reason: string, detail: string }}
 */
export function decideSkip(commits) {
  if (commits.length === 0) {
    return { skip: true, reason: "empty-window", detail: "no non-merge commits in the window" };
  }
  // A commit is test-relevant as soon as ONE of its files is not pure documentation.
  // (An empty commit touches no files → not test-relevant → contributes to a skip.)
  const testRelevant = commits.filter((c) => c.files.some((f) => !isDocsOnlyPath(f)));
  if (testRelevant.length === 0) {
    return {
      skip: true,
      reason: "docs-only",
      detail: `${commits.length} commit(s) in the window, all documentation-only`,
    };
  }
  return {
    skip: false,
    reason: "work-found",
    detail: `${testRelevant.length}/${commits.length} commit(s) touch test-relevant files`,
  };
}

/**
 * Collect the non-merge commits of the last `hours` hours on the current HEAD, each with
 * its changed file list. `runGit(args) => stdout` is injected so the logic is unit-testable
 * without a real repository.
 */
export function collectWindow(runGit, hours) {
  const shas = runGit(["log", "--no-merges", `--since=${hours} hours ago`, "--format=%H"])
    .split("\n")
    .map((s) => s.trim())
    .filter(Boolean);
  return shas.map((sha) => ({
    sha,
    files: runGit(["diff-tree", "--no-commit-id", "--name-only", "-r", sha])
      .split("\n")
      .map((s) => s.trim())
      .filter(Boolean),
  }));
}

function emitOutput(key, value) {
  const file = process.env.GITHUB_OUTPUT;
  if (file) appendFileSync(file, `${key}=${value}\n`);
}

function emitSummary(markdown) {
  const file = process.env.GITHUB_STEP_SUMMARY;
  if (file) appendFileSync(file, `${markdown}\n`);
}

export function run(runGit = (args) => execFileSync("git", args, { encoding: "utf8" })) {
  const hours = Number(process.env.WINDOW_HOURS || 26);
  const commits = collectWindow(runGit, hours);
  const decision = decideSkip(commits);

  console.log(
    `[regression-pregate] window=${hours}h commits=${commits.length} → skip=${decision.skip} (${decision.reason}: ${decision.detail})`,
  );
  emitOutput("skip", String(decision.skip));
  emitOutput("reason", decision.reason);
  emitSummary(
    decision.skip
      ? `✅ **Regression guard — no sweep needed.** ${decision.detail} in the last ${hours} h (${decision.reason}); the agent would have reported all-green. Use **Run workflow** to force a sweep.`
      : `🔍 **Regression guard — running the sweep.** ${decision.detail} in the last ${hours} h.`,
  );
  return decision;
}

// CLI only — the pure helpers above stay importable from tests.
if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    run();
  } catch (err) {
    // A pre-gate error must NEVER silently skip the sweep. Fail toward running the agent
    // (skip=false) and exit 0 so the workflow proceeds exactly as it does today.
    console.error(`[regression-pregate] error: ${err?.message ?? err} → not skipping (fail-safe).`);
    emitOutput("skip", "false");
    emitOutput("reason", "pregate-error");
  }
}
