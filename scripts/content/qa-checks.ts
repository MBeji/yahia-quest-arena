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
 *   [error] figure referenced but absent     → the prompt points the student at
 *           an adjacent figure ("ci-dessous", "الشكل المجاور", "shown below"…)
 *           but no <svg> ships anywhere in the question, so it is unanswerable.
 *   [error] <svg> without a viewBox          → the renderer relies on the
 *           viewBox for the aspect ratio on its fixed-width surface; without it
 *           the figure collapses to a dot/blank.
 *   [error] Arabic radicand of a radical      → Arabic script right after `√`
 *           (or inside its `√(…)` operand) splits the LTR isolate the radical
 *           needs, so it cannot be rendered. Plain arithmetic with Arabic units
 *           (`10 مي + 2 مي`) and a trailing unit (`√64 سم`) are fine — native
 *           bidi orders them — and are deliberately NOT flagged. See
 *           `content-engine` math-and-notation.md.
 *   [error] Arabic comma in math notation     → a set/interval/tuple bracket
 *           group that separates with the Arabic comma «،» (U+060C) — `{−4 ، 4}`,
 *           `]−1 ، 4[` — breaks the LTR run in RTL and renders scrambled. Must use
 *           «;» (preferred) or a Latin «,». A bracket group containing real Arabic
 *           prose is not notation and is left alone.
 *   [warn]  meta-option / "none" calque       → an option that defers to the
 *           other options ("none of the above" / "aucune de ces réponses" /
 *           "لا شيء ممّا سبق") breaks the four-independent-candidates rule, and the
 *           bare calque `لا واحد`/`لا واحدة` is non-idiomatic Arabic for "none".
 *           A *substantive* "nothing/zero" answer (`لا شيء`, `aucun jour`) is
 *           legitimate and NOT flagged. Deep grammatical coherence is the
 *           `content-audit` (human/LLM) pass; this only catches the lexical slice.
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

// Deictic phrases that unambiguously point at an ACCOMPANYING figure. Kept
// narrow on purpose: bare "figure"/"schéma" are excluded because they are far
// more often non-visual in this catalogue ("figure de style", "schéma
// narratif", "figure de proue"). Only location-bearing deixis qualifies.
const FIGURE_REFERENCE =
  /ci-?dessous|ci-?contre|ci-?après|shown\s+(?:below|above)|(?:figure|diagram|picture)\s+(?:below|above)|الشكل\s+(?:المجاور|التالي|المقابل)|كما\s+في\s+الشكل|المبيّن\s+في\s+الشكل|في\s+الشكل\s+المجاور|الرسم\s+(?:المجاور|التالي)/i;

const SVG_BLOCK = /<svg[\s\S]*?<\/svg>/i;

const ARABIC_LETTER = "\\u0600-\\u06FF\\u0750-\\u077F\\u08A0-\\u08FF\\uFB50-\\uFDFF\\uFE70-\\uFEFF";
// A radical whose *radicand* is Arabic script — Arabic right after the radical
// (`√مساحة`) or inside its bracketed operand (`√(2 مي)`). The radical needs an
// LTR isolate, but Arabic embedded in it splits the run and it cannot render.
// Deliberately narrow to stay false-positive-free: a trailing unit separated by
// a space (`√64 سم`) renders fine and is NOT matched, and a plain Arabic
// parenthetical with a number (`(الشكل 3)`, `(سنة 2024)`) is never a radicand.
const RADICAL_OVER_ARABIC = new RegExp(
  `[√∛∜](?:[${ARABIC_LETTER}]|\\([^)]*[${ARABIC_LETTER}][^)]*\\))`,
  "u",
);

/** True when `s` embeds Arabic script as the radicand of a radical (unrenderable in RTL). */
export function hasBidiFragileMath(s: string): boolean {
  return RADICAL_OVER_ARABIC.test(s);
}

// Arabic LETTERS only (U+0621+), so the Arabic comma U+060C and other low
// punctuation are NOT treated as prose — a bracket group whose only Arabic char
// is the comma is pure math notation.
const ARABIC_PROSE =
  "\\u0621-\\u064A\\u066E-\\u06FF\\u0750-\\u077F\\u08A0-\\u08FF\\uFB50-\\uFDFF\\uFE70-\\uFEFF";
const ARABIC_PROSE_RE = new RegExp(`[${ARABIC_PROSE}]`, "u");
// Any bracketed group: set `{…}`, interval `]…[`/`[…]`, tuple `(…)`.
const BRACKET_GROUP = /[[\]{}()][^[\]{}()\n]*[[\]{}()]/gu;

/**
 * True when `s` contains math notation (a set/interval/tuple bracket group) that
 * uses the **Arabic comma `،` (U+060C)** as its separator. The Arabic comma is an
 * Arabic char, so it breaks the LTR run: `{−4 ، 4}` / `]−1 ، 4[` render scrambled
 * in RTL. Math notation must separate with `;` (preferred) or a Latin `,`. A
 * group that contains real Arabic *prose* (e.g. `(الشكل، إلخ)`) is left alone —
 * that is a sentence, not notation.
 */
export function hasArabicCommaInMath(s: string): boolean {
  for (const m of s.matchAll(BRACKET_GROUP)) {
    const g = m[0];
    if (g.includes("،") && /[0-9A-Za-z]/.test(g) && !ARABIC_PROSE_RE.test(g)) return true;
  }
  return false;
}

// Bare non-idiomatic calque of "none" used as a whole option (`لا واحد`/`لا واحدة`).
// The idiomatic `لا شيء` and `ولا واحد منها` are NOT matched, nor is `لا شيء` as a
// substantive answer — only the standalone bare calque.
const NONE_CALQUE = /^لا\s+واحدة?$/u;
// Meta-options that defer to the *other options* rather than answer the question.
// Kept narrow (and length-gated by the caller) so a substantive "nothing/zero"
// answer or a quotation that merely contains "كلّ ما سبق" is not caught.
const META_OPTION =
  /لا\s*شيء\s+ممّ?ا\s+(?:سبق|ذكر)|(?:كلّ?|جميع)\s+(?:ما\s+(?:سبق|ذكر)|الأجوبة|الإجابات)|aucune?\s+(?:de\s+ces\s+r[ée]ponses|des\s+(?:deux|r[ée]ponses))|toutes?\s+(?:ces\s+)?r[ée]ponses|(?:none|all)\s+of\s+the\s+above|both\s+a\s+and\s+b/iu;

/**
 * Classify a single option's text as a banned meta-option, the bare "none" calque,
 * or neither. `length`-gated meta detection keeps long quotations/substantive
 * answers out of the net.
 */
export function classifyOption(text: string): "meta" | "calque" | null {
  const t = text.trim();
  if (NONE_CALQUE.test(t)) return "calque";
  if (t.length <= 40 && META_OPTION.test(t)) return "meta";
  return null;
}

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

  // 5) figure-dependent prompt with no figure shipped → unanswerable.
  //   The prompt sends the student to an adjacent figure but no <svg> is present
  //   anywhere in the question (prompt or any option). A figure may legitimately
  //   live in the options (e.g. "which piece completes it?"), so the whole
  //   question is scanned before flagging.
  if (FIGURE_REFERENCE.test(q.prompt)) {
    const hasFigure = SVG_BLOCK.test(q.prompt) || q.options.some((o) => SVG_BLOCK.test(o.text));
    if (!hasFigure) {
      flags.push({
        level: "error",
        where,
        msg: "prompt references a figure but no <svg> is present (unanswerable without it)",
      });
    }
  }

  // 6) every embedded <svg> must carry a viewBox. The renderer draws figures on
  //   a fixed-width white surface and relies on the viewBox for the aspect ratio;
  //   a viewBox-less SVG has no intrinsic ratio and collapses to a dot/blank.
  //   (See content-engine content-schema.md "rendering contract".)
  const fields = [q.prompt, q.explanation, ...q.options.map((o) => o.text)];
  for (const raw of fields) {
    for (const tag of raw.match(/<svg\b[^>]*>/gi) ?? []) {
      if (!/\bviewBox=/i.test(tag)) {
        flags.push({
          level: "error",
          where,
          msg: "<svg> figure has no viewBox (will collapse when rendered)",
        });
      }
    }
  }

  // 7) bidi-fragile math: Arabic script inside an LTR-isolated construct
  //   (radical operand or bracketed group). Unrenderable — see header.
  for (const [field, raw] of [
    ["prompt", q.prompt] as const,
    ["explanation", q.explanation] as const,
    ...q.options.map((o) => [`option ${o.id}`, o.text] as const),
  ]) {
    if (hasBidiFragileMath(raw)) {
      flags.push({
        level: "error",
        where,
        msg: `Arabic script as the radicand of a radical (√) in ${field} — will mis-render in RTL; write the operand as a number/symbol`,
      });
    }
    if (hasArabicCommaInMath(raw)) {
      flags.push({
        level: "error",
        where,
        msg: `math notation uses the Arabic comma «،» as a separator in ${field} — breaks the LTR run in RTL; use «;» (e.g. «{−4 ; 4}», «]−1 ; 4[»)`,
      });
    }
  }

  // 8) meta-options & the non-idiomatic "none" calque (warn — quality, not structure).
  for (const o of q.options) {
    const kind = classifyOption(o.text);
    if (kind === "meta") {
      flags.push({
        level: "warn",
        where,
        msg: `option "${o.id}" is a meta-option ("none/all of the above"); use four real, independent candidates`,
      });
    } else if (kind === "calque") {
      flags.push({
        level: "warn",
        where,
        msg: `option "${o.id}" "${o.text}" is a non-idiomatic calque for "none"; use «لا شيء» / «ولا واحد منها» or a real distractor`,
      });
    }
  }

  return flags;
}
