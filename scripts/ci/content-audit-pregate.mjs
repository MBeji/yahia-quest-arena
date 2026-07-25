/**
 * Deterministic pre-gate for the private corpus' pedagogical guard — étude
 * « IA → déterministe », volet contenu, lot LC2.
 *
 * `content-audit.yml` (dépôt privé) wakes a review agent twice a week and asks it, in prose,
 * to work out its own scope:
 *
 *   > list the subjects whose files under `content/**` were modified on `main` in roughly the
 *   > last 4 days (`git log --since="4 days ago" --name-only --pretty=format: -- content` …)
 *
 * That is a `git log`. It costs turns to re-derive every run, it varies between runs, and when
 * the window is empty the agent is woken anyway — to conclude "nothing to audit". The corpus
 * moves in campaign bursts, so that empty case is the common one.
 *
 * This script does the mechanical half, exactly like `regression-guard-pregate.mjs` (L3) and
 * `report-triage-pregate.mjs` (L2) do for the engine's own guards:
 *
 *   1. the SCOPE — which subjects changed in the window (a set of directory names);
 *   2. the DEDUP INPUT — the locators already carried by open `content-audit` issues, so the
 *      agent is handed what is already filed instead of re-listing and re-reading issues;
 *   3. the SKIP — nothing changed ⇒ the agent is not woken at all, and the job stays green.
 *
 * WHAT STAYS IA: everything the audit is actually for — re-solving each question blind, judging
 * explanations, distractors, difficulty, linguistic coherence, syllabus fidelity. The pre-gate
 * never decides that a finding is real or that a subject is clean; it only decides whether
 * there is anything at all to look at.
 *
 * FAIL-SAFE toward RUNNING: a pre-gate that skips a real audit hides content defects from the
 * only pass that can see them, so every error here reports run=true. A manual dispatch also
 * bypasses the gate — the operator asked for a sweep.
 */
import { execFileSync } from "node:child_process";
import { appendFileSync, writeFileSync } from "node:fs";
import { pathToFileURL } from "node:url";

/** Corpus layout: `content/<subject>/<chapter>/…`. Anything else is not a subject change. */
export function subjectOf(file, contentDir = "content") {
  const parts = file.replaceAll("\\", "/").split("/");
  if (parts.length < 3 || parts[0] !== contentDir) return null;
  return parts[1] || null;
}

/**
 * Subjects whose files changed in the window, sorted and de-duplicated.
 * `runGit(args) => stdout` is injected so the logic is unit-testable without a repository.
 */
export function changedSubjects(runGit, days, contentDir = "content") {
  const out = runGit([
    "log",
    "--no-merges",
    `--since=${days} days ago`,
    "--name-only",
    "--pretty=format:",
    "--",
    contentDir,
  ]);
  const subjects = new Set();
  for (const line of out.split("\n")) {
    const subject = subjectOf(line.trim(), contentDir);
    if (subject) subjects.add(subject);
  }
  return [...subjects].sort();
}

/**
 * Locators already filed, read from the body of open `content-audit` issues.
 *
 * The contract is a `Locator:` line — imposed on the agent by the workflow prompt, because a
 * dedup that parses free-form prose is a dedup that guesses. An issue without one is reported
 * with an empty locator list rather than dropped: the agent still sees it exists.
 */
export function parseLocators(body) {
  const locators = [];
  for (const line of String(body ?? "").split("\n")) {
    const m = /^\s*(?:[-*]\s*)?(?:\*\*)?Locator(?:\*\*)?\s*:\s*(.+?)\s*$/i.exec(line);
    if (m) locators.push(m[1].replace(/^`|`$/g, ""));
  }
  return locators;
}

/** Normalise `gh issue list --json number,title,body` into the shape the agent is handed. */
export function collectFiledLocators(issues) {
  return (issues ?? []).map((i) => ({
    number: i.number,
    title: i.title,
    locators: parseLocators(i.body),
  }));
}

/**
 * Decide whether the agent has anything to audit.
 *
 * @param {{ eventName?: string, subjects: string[] }} input
 * @returns {{ run: boolean, reason: string, detail: string }}
 */
export function decideRun({ eventName, subjects }) {
  if (eventName === "workflow_dispatch") {
    return { run: true, reason: "manual-dispatch", detail: "the operator asked for a sweep" };
  }
  if (subjects.length === 0) {
    return {
      run: false,
      reason: "no-content-change",
      detail: "no subject under content/ changed in the window",
    };
  }
  return {
    run: true,
    reason: "content-changed",
    detail: `${subjects.length} subject(s) changed: ${subjects.join(", ")}`,
  };
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

const git = (args) => execFileSync("git", args, { encoding: "utf8" });

/** `gh issue list` — non-fatal: a listing failure must not skip the audit, only lose the dedup. */
const listIssues = (label) => {
  try {
    const out = execFileSync(
      "gh",
      [
        "issue",
        "list",
        "--label",
        label,
        "--state",
        "open",
        "--limit",
        "100",
        "--json",
        "number,title,body",
      ],
      { encoding: "utf8", shell: process.platform === "win32" },
    );
    const parsed = JSON.parse(out || "[]");
    return Array.isArray(parsed) ? parsed : [];
  } catch (err) {
    console.warn(
      `[content-audit-pregate] could not list issues (${err?.message ?? err}) — the agent will dedup on its own.`,
    );
    return [];
  }
};

export function run({ runGit = git, issues = listIssues } = {}) {
  const days = Number(process.env.AUDIT_WINDOW_DAYS || 4);
  const contentDir = process.env.CONTENT_DIR || "content";
  const label = process.env.AUDIT_LABEL || "content-audit";
  const eventName = process.env.EVENT_NAME || "";

  const subjects = changedSubjects(runGit, days, contentDir);
  const decision = decideRun({ eventName, subjects });

  // Only pay for the issue listing when the agent is actually going to run.
  const filed = decision.run ? collectFiledLocators(issues(label)) : [];

  const scope = {
    lot: "LC2 (étude IA → déterministe, volet contenu)",
    windowDays: days,
    subjects,
    alreadyFiled: filed,
    counts: {
      subjects: subjects.length,
      openIssues: filed.length,
      filedLocators: filed.reduce((n, i) => n + i.locators.length, 0),
    },
  };
  const outPath = argValue("--out");
  if (outPath) writeFileSync(outPath, `${JSON.stringify(scope, null, 2)}\n`, "utf8");

  console.log(
    `[content-audit-pregate] window=${days}d subjects=${subjects.length} → run=${decision.run} (${decision.reason}: ${decision.detail})`,
  );
  emitOutput("run", String(decision.run));
  emitOutput("reason", decision.reason);
  emitOutput("subjects", subjects.join(" "));
  emitSummary(
    decision.run
      ? `🔍 **Audit de contenu — ${decision.detail}.** ${scope.counts.filedLocators} locator(s) déjà signalé(s) dans ${scope.counts.openIssues} issue(s) ouverte(s), fournis à l'agent pour qu'il ne les redépose pas.`
      : `✅ **Audit de contenu — rien à auditer.** ${decision.detail} (${days} j) ; l'agent aurait conclu « no content changed ». Utiliser **Run workflow** pour forcer une passe.`,
  );
  return { ...decision, scope };
}

// CLI only — the pure helpers above stay importable from tests.
if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    run();
  } catch (err) {
    // Never skip an audit because the pre-gate broke: content defects are only visible here.
    console.error(
      `[content-audit-pregate] error: ${err?.message ?? err} → running the audit (fail-safe).`,
    );
    emitOutput("run", "true");
    emitOutput("reason", "pregate-error");
    emitOutput("subjects", "");
  }
}
