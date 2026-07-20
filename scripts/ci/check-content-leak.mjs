#!/usr/bin/env node
/**
 * Anti-leak gate — étude 24, lot 4.
 *
 * Since the corpus split (étude 24), the pedagogical corpus, the generation
 * factory and the compiled content SQL live in the PRIVATE repo
 * `MBeji/yahia-quest-content`. This gate fails the build if any of them
 * reappears in this public repo — the failure mode RISK-8 predicts: a future
 * session re-committing corpus here out of habit.
 *
 * What counts as a leak:
 *   1. `content/**`                — the corpus itself (NOT `scripts/content/**`,
 *                                    which is the generic, corpus-free engine)
 *   2. `sql/content/**`            — compiled per-subject SQL (`content:emit`)
 *   3. pedagogical skills          — `.claude/skills/{content-*,prof-*,curriculum-architect}`
 *   4. generated content migrations — by PROVENANCE, reusing the very regexes the
 *                                    inventory script uses, so the criterion can
 *                                    never drift between the two (§4.3).
 *
 * What is deliberately NOT a leak: the 17 content migrations written BY HAND
 * (see MANUAL_CONTENT_MIGRATIONS). They stay public on purpose — `content:emit`
 * cannot reproduce them, and three of them also seed non-content data that
 * revoking would silently drop from history. Without this exclusion the gate
 * would fail on the very tip that étude 24 produces.
 */

import { execFileSync } from "node:child_process";
import { basename } from "node:path";
import { pathToFileURL } from "node:url";

import {
  GENERATED_CONTENT_RE,
  GENERATED_REGISTRY_RE,
} from "../db/inventory-content-migrations.mjs";

/**
 * The 17 hand-written content migrations that legitimately remain public.
 * The list is CLOSED: no new hand-written content migration has any reason to
 * exist — the sanctioned channel is `content:emit` into the private repo.
 * Entries marked (+) also seed non-content data.
 */
export const MANUAL_CONTENT_MIGRATIONS = new Set([
  "20260522170000_seed_content.sql", // (+) badges, shop_items
  "20260526180000_arabic_statistics_content.sql",
  "20260526190000_lesson_content_all_chapters.sql",
  "20260526200000_complete_math_program.sql",
  "20260526210000_french_complete_content.sql",
  "20260526211000_french_titles_resume.sql",
  "20260526240000_french_extended_quizzes.sql",
  "20260601120000_rebalance_question_option_positions.sql",
  "20260604130000_fix_french_passive_explanation.sql",
  "20260604140000_content_quality_pass_delta.sql",
  "20260604150000_vague2_comprehension_production.sql",
  "20260604170000_vague4_annales.sql",
  "20260604180000_vague5_annales_physique_frmastery.sql",
  "20260604190000_vague6_densification.sql",
  "20260605120000_themes_and_grades.sql", // (+) grades, themes
  "20260608120000_parcours_entity.sql", // (+) parcours, parcours_entitlements, profiles
  "20260622120000_fix_subject_titles_arabic.sql",
]);

const PEDAGOGICAL_SKILL_RE = /^(content-|prof-)|^curriculum-architect$/;
const SKILL_PATH_RE = /^\.(?:claude|agents)\/skills\/([^/]+)\//;

/** @returns {string[]} every path tracked at the current tip */
function trackedFiles() {
  return execFileSync("git", ["ls-files", "-z"], {
    encoding: "utf8",
    maxBuffer: 64 * 1024 * 1024,
  })
    .split("\0")
    .filter(Boolean);
}

/**
 * @param {string} file repo-relative path
 * @returns {string | null} the rule violated, or null when the path is clean
 */
export function leakReason(file) {
  if (file === "content" || file.startsWith("content/")) {
    return "corpus pédagogique (content/) — il vit dans le repo privé";
  }
  if (file.startsWith("sql/content/")) {
    return "SQL de contenu compilé (sql/content/) — sortie de content:emit, repo privé";
  }
  const skill = SKILL_PATH_RE.exec(file);
  if (skill && PEDAGOGICAL_SKILL_RE.test(skill[1])) {
    return `skill pédagogique (${skill[1]}) — l'usine de génération vit dans le repo privé`;
  }
  if (file.startsWith("supabase/migrations/")) {
    const name = basename(file);
    if (MANUAL_CONTENT_MIGRATIONS.has(name)) return null; // exclusion nommée, §4.4
    if (GENERATED_CONTENT_RE.test(name) || GENERATED_REGISTRY_RE.test(name)) {
      return "migration de contenu générée — le canal est content:emit vers le repo privé";
    }
  }
  return null;
}

function main() {
  const offenders = [];
  for (const file of trackedFiles()) {
    const reason = leakReason(file);
    if (reason) offenders.push({ file, reason });
  }

  if (offenders.length === 0) {
    process.stdout.write(
      "✓ Gate anti-fuite : aucun corpus, skill pédagogique ni migration de contenu générée au tip.\n",
    );
    return;
  }

  const shown = offenders.slice(0, 25);
  process.stderr.write(
    `\n✗ Gate anti-fuite — ${offenders.length} fichier(s) qui ne doivent PAS vivre dans le repo public :\n\n` +
      shown.map(({ file, reason }) => `  ${file}\n      → ${reason}`).join("\n") +
      (offenders.length > shown.length
        ? `\n  … et ${offenders.length - shown.length} autre(s).`
        : "") +
      `\n\nDepuis l'étude 24, le corpus et l'usine de génération vivent dans le repo\n` +
      `privé MBeji/yahia-quest-content. Édite le contenu là-bas ; ce repo ne porte\n` +
      `que le moteur. Si tu penses que ce blocage est une erreur, relis\n` +
      `docs/content-generation-pipeline.md avant de toucher au gate.\n\n`,
  );
  process.exit(1);
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  main();
}
