// Garde-fous check for arabic-5eme content. Run with Node 22.
// Verifies: exactly 4 options (a,b,c,d), 6 q/exercise, 5 q/quiz, key balance
// (each exercise uses all 4 letters & no letter >2/6; quiz no letter >2/5),
// difficulty ramps (01-pratique <=d2; others <=d3; non-decreasing; quiz d1-2),
// notation (no Arabic-Indic digits, no LaTeX/$), and basic explanation length.
import { readFileSync, readdirSync, statSync } from "node:fs";
import { join } from "node:path";

const ROOT = "content/arabic-5eme";
const EXPECTED_IDS = ["a", "b", "c", "d"];
let errors = 0;
const err = (m) => {
  errors++;
  console.log("✗ " + m);
};

function hasArabicIndic(s) {
  return /[٠-٩۰-۹]/.test(s);
}
function hasLatex(s) {
  return s.includes("$") || /\\(frac|sqrt|times|div|cdot|left|right)/.test(s);
}

function checkQuestion(q, where, capDiff) {
  // 4 options exactly, ids a,b,c,d
  if (!Array.isArray(q.options) || q.options.length !== 4)
    err(`${where}: options != 4 (got ${q.options?.length})`);
  else {
    const ids = q.options.map((o) => o.id);
    if (JSON.stringify(ids) !== JSON.stringify(EXPECTED_IDS))
      err(`${where}: option ids must be exactly [a,b,c,d], got [${ids.join(",")}]`);
  }
  if (!q.options.some((o) => o.id === q.correctOption))
    err(`${where}: correctOption '${q.correctOption}' not among option ids`);
  // notation
  for (const field of [q.prompt, q.explanation, ...q.options.map((o) => o.text)]) {
    if (hasArabicIndic(field)) err(`${where}: Arabic-Indic digit found in "${field.slice(0, 40)}"`);
    if (hasLatex(field)) err(`${where}: LaTeX/$ found in "${field.slice(0, 40)}"`);
  }
  // explanation length
  if ((q.explanation || "").trim().length < 25) err(`${where}: explanation < 25 chars`);
  // difficulty cap
  const d = q.difficulty ?? 2;
  if (capDiff && d > capDiff) err(`${where}: question difficulty ${d} > cap ${capDiff}`);
  return d;
}

function checkRamp(diffs, where) {
  for (let i = 1; i < diffs.length; i++)
    if (diffs[i] < diffs[i - 1])
      err(`${where}: difficulty decreased at Q${i + 1} (${diffs.join(",")})`);
}

function keyCounts(questions) {
  const c = {};
  for (const q of questions) c[q.correctOption] = (c[q.correctOption] || 0) + 1;
  return c;
}

const chapters = readdirSync(ROOT).filter((d) => {
  try {
    return statSync(join(ROOT, d)).isDirectory();
  } catch {
    return false;
  }
});

for (const ch of chapters.sort()) {
  const chDir = join(ROOT, ch);
  // quiz
  const quizPath = join(chDir, "quiz.json");
  try {
    const quiz = JSON.parse(readFileSync(quizPath, "utf8"));
    if (quiz.questions.length !== 5) err(`${ch}/quiz: expected 5 q, got ${quiz.questions.length}`);
    const diffs = [];
    quiz.questions.forEach((q, i) => diffs.push(checkQuestion(q, `${ch}/quiz Q${i + 1}`, 2)));
    checkRamp(diffs, `${ch}/quiz`);
    const kc = keyCounts(quiz.questions);
    for (const [k, v] of Object.entries(kc))
      if (v > 2) err(`${ch}/quiz: key '${k}' used ${v}/5 (>2)`);
  } catch (e) {
    err(`${ch}/quiz: ${e.message}`);
  }
  // exercises
  const exDir = join(chDir, "exercices");
  let exFiles = [];
  try {
    exFiles = readdirSync(exDir).filter((f) => f.endsWith(".json"));
  } catch {
    err(`${ch}: no exercices dir`);
  }
  for (const f of exFiles.sort()) {
    const where = `${ch}/${f}`;
    let ex;
    try {
      ex = JSON.parse(readFileSync(join(exDir, f), "utf8"));
    } catch (e) {
      err(`${where}: ${e.message}`);
      continue;
    }
    if (ex.questions.length !== 6) err(`${where}: expected 6 q, got ${ex.questions.length}`);
    const cap = f.startsWith("01-") ? 2 : 3;
    const diffs = [];
    ex.questions.forEach((q, i) => diffs.push(checkQuestion(q, `${where} Q${i + 1}`, cap)));
    checkRamp(diffs, where);
    const kc = keyCounts(ex.questions);
    const used = Object.keys(kc);
    for (const id of EXPECTED_IDS)
      if (!used.includes(id)) err(`${where}: letter '${id}' never used as key`);
    for (const [k, v] of Object.entries(kc))
      if (v > 2) err(`${where}: key '${k}' used ${v}/6 (>2)`);
  }
}

console.log(
  errors === 0
    ? "✓ GARDE-FOUS OK: 4 options, 6q/ex, 5q/quiz, all 4 letters each ex, no key >2, ramps non-decreasing, notation clean."
    : `\n✗ ${errors} garde-fou error(s).`,
);
process.exit(errors === 0 ? 0 : 1);
