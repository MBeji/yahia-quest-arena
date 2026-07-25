#!/usr/bin/env node
/**
 * Roadmap drift gate — does the execution order still know what has shipped?
 *
 * `FableEtudes/ROADMAP.md` is the ordered reste-à-faire: a session takes the first
 * unchecked line of its file. Its own rule is "tick the box in the same PR that
 * delivers the lot" — a rule that became UNENFORCEABLE at the étude-24 split,
 * because the roadmap now lives in the private content repo while nearly every
 * lot ships in this public one. No single PR can touch both.
 *
 * It drifted exactly as you would expect: between 2026-07-20 and 2026-07-25,
 * NINE delivered lots stayed unticked (é22 lots 3/4/5/6, é04-A1.1, é20 lot 1,
 * é07 lots 2/4/5) and a whole 6-lot étude was missing. A session obeying the
 * roadmap would have rebuilt work already on `main`.
 *
 * So the invariant is checked instead of promised: every lot delivered on `main`
 * since the roadmap's baseline must be CITED in the roadmap (by its PR number).
 * Citing is all it asks — a line may cite a PR as done, deferred or superseded.
 * The gate has an opinion about awareness, never about status.
 *
 * Deliberately one-directional. It reports lots the roadmap has never heard of;
 * it does not try to match a commit to a line by prose, which would be guesswork.
 * Known blind spot: a lot squashed under a PR title that does not name it (é25
 * lot 3 landed under #558, "exclure le miroir des skills de Prettier") is not
 * detected — a false negative, never a false positive.
 *
 *   node scripts/ci/check-roadmap-sync.mjs --roadmap ../corpus/FableEtudes/ROADMAP.md
 *
 * The roadmap declares its own baseline, so this repo holds no state:
 *   <!-- roadmap-sync: since-pr=536 -->
 *
 * The baseline is a PR NUMBER, not a date. `git log --since` does not filter —
 * it STOPS the traversal at the first older commit, so with squash-merges landing
 * out of chronological order it silently drops commits that are inside the window
 * (verified: #547 vanished from a `--since=2026-07-20` walk while #564, merged
 * 40 minutes later, showed up). PR numbers are monotonic and have no traversal
 * semantics, so nothing can go missing.
 */

import { execFileSync } from "node:child_process";
import { readFileSync } from "node:fs";
import { pathToFileURL } from "node:url";

/**
 * A commit subject announces a lot delivery.
 *
 * NB: JavaScript's `\b` is ASCII-only, so `/\bétude\b/` never matches — the
 * boundary before `é` cannot exist. Every pattern here avoids word boundaries on
 * accented text; getting this wrong silently drops 84 % of the real commits.
 */
const STUDY_RE = /(?:étude|etude)[- ]|(?:^|[\s(,])é\s?\d{2}(?:\b|[^\d])/i;
const LOT_RE = /(?:lots?)\s*[A-Z]?[\d.]|(?:^|[\s(,])L\d/i;
const PR_RE = /\(#(\d{2,6})\)\s*$/;
const BASELINE_RE = /<!--\s*roadmap-sync:\s*since-pr=(\d{2,6})\s*-->/;

/** Is this commit subject announcing the delivery of an étude lot? */
export function isLotDelivery(subject) {
  return STUDY_RE.test(subject) && LOT_RE.test(subject);
}

/** The PR number a squashed commit subject ends with, or null. */
export function pullRequestNumber(subject) {
  const m = PR_RE.exec(subject);
  return m ? m[1] : null;
}

/** Every `#NNN` the roadmap mentions, anywhere, in any form. */
export function citedPullRequests(markdown) {
  return new Set(Array.from(markdown.matchAll(/#(\d{2,6})\b/g), (m) => m[1]));
}

/** The baseline PR number the roadmap declares for itself, or null. */
export function declaredBaseline(markdown) {
  const m = BASELINE_RE.exec(markdown);
  return m ? Number(m[1]) : null;
}

/**
 * Lots delivered after the baseline PR that the roadmap never mentions.
 *
 * @param {string[]} subjects commit subjects, newest first
 * @param {Set<string>} cited PR numbers the roadmap mentions
 * @param {number} baseline PR number the roadmap is caught up to
 * @returns {{ pr: string, subject: string }[]}
 */
export function findUncitedLots(subjects, cited, baseline) {
  const missing = [];
  for (const subject of subjects) {
    if (!isLotDelivery(subject)) continue;
    const pr = pullRequestNumber(subject);
    if (!pr || Number(pr) <= baseline || cited.has(pr)) continue;
    missing.push({ pr, subject });
  }
  return missing;
}

function argValue(flag, fallback) {
  const i = process.argv.indexOf(flag);
  return i !== -1 && process.argv[i + 1] ? process.argv[i + 1] : fallback;
}

function main() {
  const roadmapPath = argValue("--roadmap", "FableEtudes/ROADMAP.md");
  const ref = argValue("--ref", "origin/main");

  let markdown;
  try {
    markdown = readFileSync(roadmapPath, "utf8");
  } catch {
    console.error(
      `[roadmap-sync] roadmap introuvable : ${roadmapPath}\n` +
        "      Ce gate se lance depuis le moteur avec le corpus privé à côté :\n" +
        "      node scripts/ci/check-roadmap-sync.mjs --roadmap ../corpus/FableEtudes/ROADMAP.md",
    );
    process.exit(2);
  }

  const baseline = declaredBaseline(markdown);
  if (!baseline) {
    console.error(
      "[roadmap-sync] la roadmap ne déclare pas sa base de référence.\n" +
        "      Ajouter la ligne : <!-- roadmap-sync: since-pr=NNN -->",
    );
    process.exit(2);
  }

  const log = execFileSync("git", ["log", ref, "--pretty=%s"], {
    encoding: "utf8",
    maxBuffer: 32 * 1024 * 1024,
  });
  const subjects = log.split("\n").filter(Boolean);
  const uncited = findUncitedLots(subjects, citedPullRequests(markdown), baseline);

  if (uncited.length === 0) {
    console.log(
      `[roadmap-sync] OK — depuis #${baseline}, chaque lot livré sur ${ref} est cité dans la roadmap.`,
    );
    return;
  }

  console.error(
    `[roadmap-sync] ${uncited.length} lot(s) livré(s) après #${baseline} que la roadmap ignore.\n` +
      "      Une session qui prend « la première ligne non cochée » referait ce travail.\n" +
      "      Citer chaque PR sur la ligne concernée (cochée, reportée ou sans objet) :\n",
  );
  for (const { pr, subject } of uncited) console.error(`  #${pr}  ${subject}`);
  process.exit(1);
}

if (import.meta.url === pathToFileURL(process.argv[1]).href) {
  main();
}
