/**
 * Pick the weekly PROD ROLLBACK CHECKPOINT — the most recent commit on `main`
 * that carries real proof it works, not merely proof it compiled.
 *
 * Why a dedicated notion of "checkpoint" instead of just tagging Friday's tip:
 * the tip of `main` only ever proves `verify` (lint + types + unit + build +
 * shell smoke). The deep suites — Playwright E2E and the pgTAP DB integration —
 * run in `nightly.yml`, hours later, on whatever `main` pointed at 01:00 UTC.
 * A checkpoint we would roll production back to must be backed by BOTH, or it
 * is a guess wearing a tag. So the selection walks the recent successful
 * nightly runs (newest first) and keeps the first whose head commit ALSO has a
 * green `verify` check — never the calendar's tip.
 *
 * Deliberately conservative: when no candidate qualifies, we mint NO tag and
 * say why (`checkpoint-tag.yml` opens a tracking issue). A week without a
 * checkpoint is a fact worth seeing; a checkpoint that lies is an outage during
 * the next outage.
 *
 * Pure helpers are exported and unit-tested; `main()` does the I/O and runs
 * only when executed directly.
 *
 *   node scripts/release/pick-checkpoint.mjs --payload candidates.json
 */
import { readFileSync, appendFileSync } from "node:fs";
import { pathToFileURL } from "node:url";

/** Tags minted by this script all share this prefix. */
export const CHECKPOINT_TAG_PREFIX = "checkpoint/";

/**
 * Evidence older than this is not a checkpoint, it is an archive: `main` has
 * moved on and rolling back to it would revert a week+ of merged work. Slightly
 * over a week so a single failed nightly doesn't skip the checkpoint.
 */
export const MAX_EVIDENCE_AGE_DAYS = 8;

/**
 * The nightly suites, matched by job name (`gh run view --json jobs`).
 *
 * `required: true` means a SKIP is a rejection, not a pass. `e2e-auth` and
 * `perf` are secret-gated by design (they skip green when their TEST/LOAD
 * secrets are unset — see nightly.yml), so they are recorded for the record but
 * never block. `e2e` (public) and pgTAP have no such gate: if they did not run
 * green, nothing here is proven.
 */
export const NIGHTLY_SUITES = [
  { key: "e2e", label: "E2E (public)", match: /e2e.*public/i, required: true },
  { key: "e2e-auth", label: "E2E (authenticated)", match: /e2e.*auth/i, required: false },
  { key: "pgtap", label: "DB integration (pgTAP)", match: /pgtap|db integration/i, required: true },
  { key: "perf", label: "Performance (load)", match: /performance|perf/i, required: false },
];

/**
 * ISO-8601 week of a date (Mon-based, the Thursday rule decides the year).
 * Used for the tag name, so a checkpoint reads as the week it certifies.
 *
 * @param {Date} date
 * @returns {{ year: number, week: number }}
 */
export function isoWeek(date) {
  const d = new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate()));
  const dayNum = d.getUTCDay() || 7; // Mon=1 … Sun=7
  d.setUTCDate(d.getUTCDate() + 4 - dayNum); // → the week's Thursday
  const isoYear = d.getUTCFullYear();
  const yearStart = new Date(Date.UTC(isoYear, 0, 1));
  const week = Math.ceil(((d - yearStart) / 86_400_000 + 1) / 7);
  return { year: isoYear, week };
}

/**
 * Name the checkpoint tag for a date, avoiding collision with tags that already
 * exist (a second checkpoint in the same ISO week — e.g. a manual dispatch after
 * a mid-week fix — gets `.2`, `.3`, …).
 *
 * @param {Date} date
 * @param {string[]} existingTags
 * @returns {string}
 */
export function checkpointTagFor(date, existingTags = []) {
  const { year, week } = isoWeek(date);
  const base = `${CHECKPOINT_TAG_PREFIX}${year}-W${String(week).padStart(2, "0")}`;
  if (!existingTags.includes(base)) return base;
  for (let n = 2; n < 100; n += 1) {
    const candidate = `${base}.${n}`;
    if (!existingTags.includes(candidate)) return candidate;
  }
  /* c8 ignore next */
  throw new Error(`Impossible de nommer un checkpoint pour ${base} (100 collisions).`);
}

/**
 * Map a nightly run's jobs onto the known suites.
 *
 * A suite no job name matches is reported as `unknown` rather than assumed
 * failed: nightly.yml's jobs are reusable-workflow calls whose reported names
 * carry a prefix, and a rename upstream must not silently freeze checkpointing
 * forever. `unknown` is surfaced in the annotation instead of blocking.
 *
 * @param {Array<{name: string, conclusion: string}>} jobs
 * @returns {Record<string, string>} suite key → conclusion (`unknown` if absent)
 */
export function classifySuites(jobs = []) {
  const out = {};
  for (const suite of NIGHTLY_SUITES) {
    const job = jobs.find((j) => suite.match.test(j?.name ?? ""));
    out[suite.key] = job?.conclusion ?? "unknown";
  }
  return out;
}

/**
 * Decide whether one candidate commit can carry a checkpoint.
 *
 * @param {object} candidate
 * @param {string} candidate.headSha       commit the nightly ran on
 * @param {string} candidate.conclusion    the nightly run's own conclusion
 * @param {string} candidate.createdAt     ISO timestamp of the nightly run
 * @param {string} [candidate.verify]      conclusion of the `verify` check on that SHA
 * @param {Array}  [candidate.jobs]        the nightly run's jobs
 * @param {object} opts
 * @param {Date}   opts.now
 * @param {number} [opts.maxAgeDays]
 * @param {string[]} [opts.taggedShas]     SHAs that already carry a checkpoint tag
 * @returns {{ ok: boolean, reason?: string, suites: Record<string,string>, ageDays: number }}
 */
export function evaluateCandidate(
  candidate,
  { now, maxAgeDays = MAX_EVIDENCE_AGE_DAYS, taggedShas = [] } = {},
) {
  const suites = classifySuites(candidate.jobs);
  const ageDays = (now.getTime() - new Date(candidate.createdAt).getTime()) / 86_400_000;

  if (candidate.conclusion !== "success") {
    return { ok: false, reason: `nightly ${candidate.conclusion}`, suites, ageDays };
  }
  if (ageDays > maxAgeDays) {
    return {
      ok: false,
      reason: `preuve trop ancienne (${ageDays.toFixed(1)} j > ${maxAgeDays} j)`,
      suites,
      ageDays,
    };
  }
  if (taggedShas.includes(candidate.headSha)) {
    return { ok: false, reason: "commit déjà taggé comme checkpoint", suites, ageDays };
  }
  if (candidate.verify !== "success") {
    return { ok: false, reason: `check verify = ${candidate.verify ?? "absent"}`, suites, ageDays };
  }
  for (const suite of NIGHTLY_SUITES.filter((s) => s.required)) {
    const conclusion = suites[suite.key];
    // `unknown` is tolerated (see classifySuites); anything else must be green.
    if (conclusion !== "success" && conclusion !== "unknown") {
      return { ok: false, reason: `${suite.label} = ${conclusion}`, suites, ageDays };
    }
  }
  return { ok: true, suites, ageDays };
}

/**
 * Walk candidates newest-first and return the first that qualifies, along with
 * why each rejected one was rejected (the tracking issue quotes this).
 *
 * @param {object[]} candidates - nightly runs, newest first
 * @param {object} opts - forwarded to evaluateCandidate
 * @returns {{ chosen: object | null, rejected: Array<{headSha: string, reason: string}> }}
 */
export function pickCheckpoint(candidates = [], opts = {}) {
  const rejected = [];
  for (const candidate of candidates) {
    const verdict = evaluateCandidate(candidate, opts);
    if (verdict.ok) {
      return { chosen: { ...candidate, ...verdict }, rejected };
    }
    rejected.push({ headSha: candidate.headSha, reason: verdict.reason });
  }
  return { chosen: null, rejected };
}

const SUITE_ICON = { success: "✅", skipped: "⏭️", unknown: "❔" };

/**
 * The annotated tag's message. It is the artifact an operator reads at 02:00
 * during an incident, so it states what is proven, what is NOT, and the one
 * trap that makes rollbacks dangerous here: reverting code does not revert the
 * schema.
 *
 * @param {object} input
 * @returns {string}
 */
export function buildAnnotation({
  tag,
  headSha,
  runUrl,
  runDate,
  suites = {},
  version,
  migrationHead,
  deployment,
}) {
  const lines = [
    `Checkpoint prod — point de retour arrière vérifié.`,
    ``,
    `Tag        : ${tag}`,
    `Commit     : ${headSha}`,
    `Version    : ${version ?? "n/a"} (package.json)`,
    `Migration  : ${migrationHead ?? "aucune"} (tête locale À CE COMMIT)`,
    `Déploiement: ${deployment ?? "non résolu (VERCEL_TOKEN absent au moment du tag)"}`,
    ``,
    `Preuves (nightly du ${runDate})`,
  ];
  for (const suite of NIGHTLY_SUITES) {
    const conclusion = suites[suite.key] ?? "unknown";
    const icon = SUITE_ICON[conclusion] ?? "❌";
    lines.push(`  ${icon} ${suite.label.padEnd(22)} ${conclusion}`);
  }
  lines.push(
    `  ✅ ${"verify (CI sur main)".padEnd(22)} success`,
    ``,
    `Run nightly : ${runUrl}`,
    ``,
    `⚠️  Revenir à ce commit NE RAMÈNE PAS le schéma en arrière : les migrations`,
    `    sont forward-only. Vérifier le delta de migrations depuis ${migrationHead ?? "n/a"}`,
    `    AVANT de rollback. Procédure : docs/prod-rollback-runbook.md`,
  );
  return lines.join("\n");
}

/** Append `key=value` (multi-line safe) to a GitHub Actions output file. */
function emit(file, key, value) {
  if (!file) return;
  const delimiter = `ghadelim_${key}`;
  appendFileSync(file, `${key}<<${delimiter}\n${value}\n${delimiter}\n`, "utf8");
}

/* c8 ignore start — I/O shell, exercised by the workflow, not by unit tests. */
function readPayload(argv, flag) {
  const idx = argv.indexOf(flag);
  return idx === -1 || !argv[idx + 1] ? null : JSON.parse(readFileSync(argv[idx + 1], "utf8"));
}

/**
 * Two modes, because the annotation needs facts only knowable AFTER the commit
 * is chosen (its schema head, its Vercel deployment):
 *
 *   --payload  <f>  pick the checkpoint  → outputs found / tag / sha / …
 *   --annotate <f>  render its annotation → output annotation
 */
export function main(argv = process.argv.slice(2)) {
  const annotatePayload = readPayload(argv, "--annotate");
  if (annotatePayload) {
    const annotation = buildAnnotation(annotatePayload);
    console.log(annotation);
    emit(process.env.GITHUB_OUTPUT, "annotation", annotation);
    return { annotation };
  }

  const payload = readPayload(argv, "--payload");
  if (!payload) {
    console.error(
      "Usage: node scripts/release/pick-checkpoint.mjs --payload <f.json> | --annotate <f.json>",
    );
    process.exit(2);
  }
  const now = payload.now ? new Date(payload.now) : new Date();
  const { chosen, rejected } = pickCheckpoint(payload.candidates ?? [], {
    now,
    taggedShas: payload.taggedShas ?? [],
  });

  const out = process.env.GITHUB_OUTPUT;
  if (!chosen) {
    const why = rejected.length
      ? rejected.map((r) => `- \`${r.headSha.slice(0, 7)}\` : ${r.reason}`).join("\n")
      : "- aucun run nightly trouvé sur `main` dans la fenêtre examinée";
    console.log(`Aucun candidat ne qualifie :\n${why}`);
    emit(out, "found", "false");
    emit(out, "why", why);
    return { chosen: null, rejected };
  }

  const tag = checkpointTagFor(now, payload.existingTags ?? []);
  console.log(`Checkpoint retenu : ${tag} → ${chosen.headSha}`);
  emit(out, "found", "true");
  emit(out, "tag", tag);
  emit(out, "sha", chosen.headSha);
  emit(out, "run_url", chosen.runUrl ?? "");
  emit(out, "run_date", chosen.createdAt ?? "");
  emit(out, "suites", JSON.stringify(chosen.suites));
  return { chosen, rejected, tag };
}

if (import.meta.url === pathToFileURL(process.argv[1] ?? "").href) {
  main();
}
/* c8 ignore stop */
