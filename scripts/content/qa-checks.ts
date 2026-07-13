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

export type QAOption = { id: string; text: string; misconceptionTag?: string };
export type QAQuestion = {
  prompt: string;
  options: QAOption[];
  correctOption: string;
  explanation: string;
  difficulty?: number;
};
/** Native numeric-entry question (Tier B, phase B1) — no options, a typed key. */
export type QANumericQuestion = {
  prompt: string;
  answerKey: { value: number; tolerance?: number; unit?: string };
  explanation: string;
  difficulty?: number;
};
/** Native board question (Tier B, phase B2) — items in options, a typed key. */
export type QABoardQuestion = {
  prompt: string;
  options: QAOption[];
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

/**
 * Field-level rendering checks shared by every question type:
 *   [error] <svg> without a viewBox (collapses on the fixed-width surface);
 *   [error] Arabic radicand of a radical / Arabic comma in math notation
 *           (both break the LTR isolate in RTL — see the header).
 */
export function auditRenderedFields(
  fields: ReadonlyArray<readonly [string, string]>,
  where: string,
): Flag[] {
  const flags: Flag[] = [];
  for (const [field, raw] of fields) {
    for (const tag of raw.match(/<svg\b[^>]*>/gi) ?? []) {
      if (!/\bviewBox=/i.test(tag)) {
        flags.push({
          level: "error",
          where,
          msg: "<svg> figure has no viewBox (will collapse when rendered)",
        });
      }
    }
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
  return flags;
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

  // 6+7) rendering checks (svg viewBox, bidi-fragile math) — shared with the
  //   numeric audit; see auditRenderedFields.
  flags.push(
    ...auditRenderedFields(
      [
        ["prompt", q.prompt] as const,
        ["explanation", q.explanation] as const,
        ...q.options.map((o) => [`option ${o.id}`, o.text] as const),
      ],
      where,
    ),
  );

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

/**
 * Registry cross-check for misconception tags (étude 04 D-4/R-5). Every
 * `misconceptionTag` used on a distractor must be declared in the closed
 * registry `content/misconceptions.json` — an unknown tag is an [error] (the
 * telemetry would record a tag nothing can ever explain to the student). The
 * schema already guarantees the tag's namespaced SHAPE and that the correct
 * option is untagged; this adds the VOCABULARY check the schema cannot do.
 */
export function auditMisconceptionTags(
  q: QAQuestion,
  known: ReadonlySet<string>,
  where: string,
): Flag[] {
  const flags: Flag[] = [];
  for (const o of q.options) {
    if (o.misconceptionTag && !known.has(o.misconceptionTag)) {
      flags.push({
        level: "error",
        where,
        msg: `option "${o.id}" uses misconception tag "${o.misconceptionTag}" not declared in content/misconceptions.json`,
      });
    }
  }
  return flags;
}

/** Prepared vocabulary of the competency registries (étude 07 D-1). */
export type CompetencyVocabulary = {
  /** Every declared competency id, across all family registries. */
  ids: ReadonlySet<string>;
  /** family → the subject-id prefixes it covers (`math` → `math`, `math-*`). */
  subjectPrefixes: ReadonlyMap<string, readonly string[]>;
};

/**
 * Registry cross-check for evaluated competencies (étude 07 R-1/R-2 — the twin
 * of {@link auditMisconceptionTags}, applying to EVERY question type). An id
 * missing from `content/competences/<famille>.json` is an [error] (the junction
 * row would violate the registry FK); a family whose declared subject prefixes
 * do not cover the tagging subject is a [warn] (cross-matière tagging is almost
 * always an authoring slip, but stays reviewable).
 */
export function auditCompetencyRefs(
  q: { competencies?: string[] },
  subjectId: string,
  vocab: CompetencyVocabulary,
  where: string,
): Flag[] {
  const flags: Flag[] = [];
  for (const id of q.competencies ?? []) {
    const family = id.split(".")[0] ?? id;
    if (!vocab.ids.has(id)) {
      flags.push({
        level: "error",
        where,
        msg: `references competency "${id}" not declared in content/competences/${family}.json`,
      });
      continue;
    }
    const prefixes = vocab.subjectPrefixes.get(family) ?? [];
    if (!prefixes.some((p) => subjectId === p || subjectId.startsWith(`${p}-`))) {
      flags.push({
        level: "warn",
        where,
        msg: `competency "${id}" belongs to family "${family}" which does not cover subject "${subjectId}" (declared prefixes: ${prefixes.join(", ")})`,
      });
    }
  }
  return flags;
}

/**
 * Per-question heuristics for the native board/checklist questions
 * (`ordering` / `matching` / `multi` — Tier B, phases B2–B3). Their
 * STRUCTURAL integrity (permutation / bijection / proper-subset keys, id
 * charset) is hard-enforced by the Zod schema; this pass keeps the quality
 * heuristics that still apply:
 *   [error] duplicate item texts (two identical steps/pairs are unorderable);
 *   [warn]  thin explanation; [error] figure referenced but absent;
 *   [error] rendering checks (svg viewBox, bidi) — shared.
 */
export function auditBoardQuestion(q: QABoardQuestion, where: string): Flag[] {
  const flags: Flag[] = [];

  const texts = q.options.map((o) => norm(o.text));
  if (new Set(texts).size !== texts.length) {
    flags.push({ level: "error", where, msg: "duplicate option texts" });
  }

  if (q.explanation.trim().length < 25) {
    flags.push({ level: "warn", where, msg: "explanation is very short" });
  }

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

  flags.push(
    ...auditRenderedFields(
      [
        ["prompt", q.prompt] as const,
        ["explanation", q.explanation] as const,
        ...q.options.map((o) => [`option ${o.id}`, o.text] as const),
      ],
      where,
    ),
  );

  return flags;
}

/**
 * Per-question heuristics for native `numeric` questions (Tier B, phase B1):
 *   [error] tolerance as wide as the value    → any plausible answer passes;
 *           an acceptance window ≥ |value| is almost surely an authoring typo.
 *   [warn]  very generous tolerance (> 25 %)  → double-check it is intended.
 *   [warn]  canonical value not echoed in the explanation (same spirit as the
 *           mcq check: the key and the worked solution may disagree).
 *   [warn]  thin explanation                  → same bar as mcq.
 *   [error] figure referenced but absent / rendering checks — shared.
 */
export function auditNumericQuestion(q: QANumericQuestion, where: string): Flag[] {
  const flags: Flag[] = [];
  const { value, tolerance } = q.answerKey;

  if (tolerance !== undefined && tolerance > 0 && value !== 0) {
    if (tolerance >= Math.abs(value)) {
      flags.push({
        level: "error",
        where,
        msg: `numeric tolerance ${tolerance} is as wide as the value ${value} — any plausible answer would score correct`,
      });
    } else if (tolerance > Math.abs(value) / 4) {
      flags.push({
        level: "warn",
        where,
        msg: `numeric tolerance ${tolerance} is more than 25% of the value ${value} — double-check it is intended`,
      });
    }
  }

  // Canonical value echoed in the explanation (dot or comma decimal accepted).
  const dot = String(Math.abs(value));
  const explNums = new Set(numbersIn(q.explanation));
  if (!explNums.has(dot) && !explNums.has(dot.replace(".", ","))) {
    flags.push({
      level: "warn",
      where,
      msg: `canonical value ${value} not echoed in the explanation`,
    });
  }

  if (q.explanation.trim().length < 25) {
    flags.push({ level: "warn", where, msg: "explanation is very short" });
  }

  if (FIGURE_REFERENCE.test(q.prompt) && !SVG_BLOCK.test(q.prompt)) {
    flags.push({
      level: "error",
      where,
      msg: "prompt references a figure but no <svg> is present (unanswerable without it)",
    });
  }

  flags.push(
    ...auditRenderedFields(
      [
        ["prompt", q.prompt],
        ["explanation", q.explanation],
      ],
      where,
    ),
  );

  return flags;
}
