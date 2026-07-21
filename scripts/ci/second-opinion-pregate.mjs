/**
 * Deterministic scope pre-gate for the (dormant) second-opinion workflow
 * (étude "IA → déterministe", lot L5). As committed, second-opinion.yml would wake a
 * cross-family review agent on EVERY push of EVERY PR once its secret is set. L5 bounds
 * that in the MECHANICS — not in reviewer discipline — BEFORE the guard is ever armed, so
 * the economy is guaranteed the day someone flips it on.
 *
 * A PR is "in scope" for a second opinion when ANY of:
 *   - manual `workflow_dispatch` (the operator asked for it — like L3's escape hatch);
 *   - the PR carries the on-demand `second-avis` label;
 *   - the PR changes a risk-bearing path: app code (`src/**`, excluding its tests),
 *     a database migration (`supabase/migrations/**`), or CI/automation (`.github/**`).
 *
 * Everything else — a docs-only, test-only, or config-only PR — is skipped: the primary
 * review already covers it and a redundant cross-family pass earns nothing there. The
 * agent's actual value (spotting a bug class the primary model's family misses) is
 * preserved on exactly the diffs where a missed defect would ship.
 *
 * FAIL-SAFE toward NOT running: this guard only ever posts an OPTIONAL comment (never a
 * required check), and L5's whole purpose is to bound its cost — so any error here reports
 * run=false. The next `synchronize` re-evaluates. Debounce (no pile-up on rapid pushes)
 * stays handled by the workflow's `concurrency: cancel-in-progress`.
 */
import { execFileSync } from "node:child_process";
import { appendFileSync } from "node:fs";
import { pathToFileURL } from "node:url";

const DEFAULT_REQUEST_LABEL = "second-avis";

/** A test file under src/** — excluded from the "app code changed" signal. */
function isSrcTest(file) {
  return /(^|\/)__tests__\//.test(file) || /\.(test|spec)\.[cm]?[jt]sx?$/.test(file);
}

/**
 * True when a changed path carries enough risk to justify a redundant cross-family
 * review: app code (non-test), a DB migration, or CI/automation.
 */
export function isReviewWorthyPath(file) {
  if (file.startsWith(".github/")) return true;
  if (file.startsWith("supabase/migrations/")) return true;
  if (file.startsWith("src/")) return !isSrcTest(file);
  return false;
}

/**
 * Decide whether to run the second opinion.
 *
 * @param {object} input
 * @param {string} input.eventName            github.event_name
 * @param {string[]} [input.labels]           PR label names
 * @param {string[]} [input.changedFiles]     files changed by the PR
 * @param {string} [input.requestLabel]       on-demand label (default "second-avis")
 * @returns {{ run: boolean, reason: string }}
 */
export function decideRun({
  eventName,
  labels = [],
  changedFiles = [],
  requestLabel = DEFAULT_REQUEST_LABEL,
}) {
  if (eventName === "workflow_dispatch") {
    return { run: true, reason: "manual-dispatch" };
  }
  if (labels.includes(requestLabel)) {
    return { run: true, reason: `label:${requestLabel}` };
  }
  const risky = changedFiles.filter(isReviewWorthyPath);
  if (risky.length > 0) {
    return { run: true, reason: `risky-paths(${risky.length})` };
  }
  return { run: false, reason: "out-of-scope" };
}

/** Parse the `toJSON(labels.*.name)` payload; tolerate null / malformed input. */
export function parseLabels(raw) {
  if (!raw) return [];
  try {
    const value = JSON.parse(raw);
    return Array.isArray(value) ? value : [];
  } catch {
    return [];
  }
}

function emitOutput(key, value) {
  const file = process.env.GITHUB_OUTPUT;
  if (file) appendFileSync(file, `${key}=${value}\n`);
}

export function run(runGit = (args) => execFileSync("git", args, { encoding: "utf8" })) {
  const eventName = process.env.EVENT_NAME || "";
  const labels = parseLabels(process.env.PR_LABELS);
  const requestLabel = process.env.REQUEST_LABEL || DEFAULT_REQUEST_LABEL;

  // Only compute the PR file list when the cheap signals didn't already decide "run".
  let changedFiles = [];
  const needFiles = eventName !== "workflow_dispatch" && !labels.includes(requestLabel);
  if (needFiles && process.env.BASE_SHA && process.env.HEAD_SHA) {
    changedFiles = runGit([
      "diff",
      "--name-only",
      `${process.env.BASE_SHA}...${process.env.HEAD_SHA}`,
    ])
      .split("\n")
      .map((s) => s.trim())
      .filter(Boolean);
  }

  const decision = decideRun({ eventName, labels, changedFiles, requestLabel });
  console.log(
    `[second-opinion-pregate] event=${eventName} labels=[${labels.join(",")}] changed=${changedFiles.length} → run=${decision.run} (${decision.reason})`,
  );
  emitOutput("run", String(decision.run));
  emitOutput("reason", decision.reason);
  return decision;
}

// CLI only — the pure helpers above stay importable from tests.
if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    run();
  } catch (err) {
    // Optional comment + cost-bounding intent → fail toward NOT running (skip), logged.
    console.error(
      `[second-opinion-pregate] error: ${err?.message ?? err} → run=false (fail-safe).`,
    );
    emitOutput("run", "false");
    emitOutput("reason", "pregate-error");
  }
}
