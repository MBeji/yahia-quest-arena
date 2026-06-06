/**
 * Content QA checks — pure, side-effect-free heuristics over a single question.
 *
 * Extracted from qa.ts so they can be unit-tested in isolation (qa.ts is a thin
 * CLI that loads content from disk and runs these). Each check favours HIGH
 * PRECISION (few false positives) since `--strict` gates CI on [error] findings.
 *
 *   [error] duplicate option texts          → ambiguous question / likely mistake
 *   [warn]  value not echoed in explanation  → key and worked solution may disagree
 *   [warn]  thin explanation                 → < 25 chars, low pedagogical quality
 *   [warn]  explanation contradicts the key  → explanation names a *different*
 *           option as the right answer, or calls the correct option wrong on a
 *           non-"find-the-error" question (the class that slipped past structural
 *           QA). Warn-only: the deep net is cross-agent corrigé review.
 */

export type QAOption = { id: string; text: string };
export type QAQuestion = {
  prompt: string;
  options: QAOption[];
  correctOption: string;
  explanation: string;
  difficulty?: number;
};
export type Flag = { level: "error" | "warn"; where: string; msg: string };

/** Normalise for substring comparison: strip whitespace, fold Arabic-Indic digits, lowercase. */
export function norm(s: string): string {
  const arabicDigits = "٠١٢٣٤٥٦٧٨٩";
  return s.replace(/[٠-٩]/g, (d) => String(arabicDigits.indexOf(d))).replace(/\s+/g, "");
}

/** All digit groups in a string (Arabic-Indic digits folded to Latin first). */
export function numbersIn(s: string): string[] {
  const folded = s.replace(/[٠-٩]/g, (d) => String("٠١٢٣٤٥٦٧٨٩".indexOf(d)));
  return folded.match(/\d+(?:[.,]\d+)?/g) ?? [];
}

export const hasArabic = (s: string) => /[؀-ۿ]/.test(s);

// "find the error / odd one out" prompts: there the correct answer legitimately
// IS the wrong/odd item, so a negative remark about the key is not a contradiction.
const INTRUDER_PROMPT =
  /erreur|incorrecte?|fausse?|faute|intrus|ne\s+convient\s+pas|mistake|wrong|incorrect|odd\s+one|خط[أإ]|غلط|الدخيل|غير\s+صحيح/i;

// Strong, unambiguous phrasings that pin an option as THE answer or as wrong.
// Kept deliberately narrow to avoid false positives on legitimate distractor talk.
const SAYS_CORRECT =
  /(?:la\s+)?bonne\s+réponse\s+est\s+(?:l['’]option\s+|la\s+proposition\s+)?\(?([a-f])\)?|l['’]option\s+\(?([a-f])\)?\s+est\s+(?:la\s+bonne|correcte?|juste|exacte?)|option\s+\(?([a-f])\)?\s+is\s+(?:the\s+)?correct/gi;

const buildSaysWrong = (letter: string) =>
  new RegExp(
    `l['’]option\\s+\\(?${letter}\\)?[^.;:!?\\n]{0,30}(?:est\\s+(?:fausse?|incorrecte?|erronée?)|comporte\\s+une\\s+erreur|n['’]est\\s+pas\\s+correcte?)`,
    "i",
  );

/** Run all per-question heuristics. `where` is a human-readable locator. */
export function auditQuestion(q: QAQuestion, where: string): Flag[] {
  const flags: Flag[] = [];

  // 1) duplicate option texts (case-sensitive: "Na" and "na" are distinct).
  const texts = q.options.map((o) => norm(o.text));
  if (new Set(texts).size !== texts.length) {
    flags.push({ level: "error", where, msg: "duplicate option texts" });
  }

  // 2) numeric answer not echoed in the explanation. Only for symbolic/numeric
  // answers (no Arabic words — avoids morphology false positives).
  const correct = q.options.find((o) => o.id === q.correctOption);
  if (correct && !hasArabic(correct.text) && norm(correct.text).length <= 24) {
    const answerNums = numbersIn(correct.text);
    const explNums = new Set(numbersIn(q.explanation));
    const missing = answerNums.filter((n) => !explNums.has(n));
    if (answerNums.length > 0 && missing.length > 0) {
      flags.push({
        level: "warn",
        where,
        msg: `answer value(s) [${missing.join(", ")}] from "${correct.text}" not echoed in the explanation`,
      });
    }
  }

  // 3) thin explanation
  if (q.explanation.trim().length < 25) {
    flags.push({ level: "warn", where, msg: "explanation is very short" });
  }

  // 4) explanation contradicts the answer key (warn-only, high precision).
  //   a) explanation explicitly names a DIFFERENT option as the right answer
  for (const m of q.explanation.matchAll(SAYS_CORRECT)) {
    const letter = (m[1] ?? m[2] ?? m[3])?.toLowerCase();
    if (letter && letter !== q.correctOption.toLowerCase()) {
      flags.push({
        level: "warn",
        where,
        msg: `explanation calls option "${letter}" the right answer, but the key is "${q.correctOption}"`,
      });
    }
  }
  //   b) explanation calls the CORRECT option wrong (skip find-the-error prompts)
  if (
    correct &&
    !INTRUDER_PROMPT.test(q.prompt) &&
    buildSaysWrong(q.correctOption).test(q.explanation)
  ) {
    flags.push({
      level: "warn",
      where,
      msg: `explanation calls the correct option "${q.correctOption}" wrong`,
    });
  }

  return flags;
}
