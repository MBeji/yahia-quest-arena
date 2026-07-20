/**
 * Free-answer text handling — the TS mirror of étude 17's SQL primitives.
 *
 * Étude 20 (lot 1) scores a typed answer against a SET of accepted answers
 * instead of a single string. The SET is authored in content files
 * (`acceptedAnswers`) and validated at BUILD time by `content:qa` — the runtime
 * SQL trusts it blindly (étude §5). That makes the QA gate the only defence
 * against a poisoned set, so the gate must reason with EXACTLY the same
 * normalisation as the database.
 *
 * D-3 keeps the single source of truth in SQL: content files carry readable
 * text, and `public.normalize_recall_text` normalises at scoring time. This
 * module is a deliberate REPLICA for the build-time gate only — never for
 * scoring. RISK-2 (TS/SQL drift) is defused by `PARITY_CORPUS` below, asserted
 * from BOTH sides:
 *
 *   - Vitest (`__tests__/free-answer.test.ts`) runs it against this file, and
 *     additionally proves every case appears in the pgTAP file — so a case
 *     added here cannot silently skip the SQL side;
 *   - pgTAP (`supabase/tests/34_accepted_answers_set.test.sql`) runs the same
 *     rows against `public.normalize_recall_text`.
 *
 * Neither mirrored function is modified by étude 20 (R-8, R-6): both are ported
 * as deployed in `20260714120000_recall_mode_foundations.sql`.
 */

/**
 * Strip Arabic tashkeel/tatweel — SQL step 3, `regexp_replace(t, '[ً-ْـٰ]', '', 'g')`.
 * Removed by code point rather than a regex character class: several of these
 * are lone combining marks (U+064B–U+0652 tashkeel, U+0670 superscript alef;
 * U+0640 is tatweel), which a class literal renders as an unreadable grapheme
 * and which trip `no-misleading-character-class` even when escaped.
 */
function stripArabicDiacritics(input: string): string {
  let out = "";
  for (const ch of input) {
    const c = ch.codePointAt(0)!;
    if ((c >= 0x64b && c <= 0x652) || c === 0x640 || c === 0x670) continue;
    out += ch;
  }
  return out;
}

/** Latin letters carrying a diacritic, and their bare counterparts — SQL step 2. */
const LATIN_ACCENTS = "àâäáãéèêëïîíôöòõùûüúÿçñ";
const LATIN_PLAIN = "aaaaaeeeeiiioooouuuuycn";

/** Arabic letters folded to a canonical form — SQL step 3 (أإآ→ا, ى→ي, ة→ه). */
const ARABIC_FOLDED = "أإآىة";
const ARABIC_CANONICAL = "ااايه";

/** Arabic-Indic and extended Arabic-Indic digits — SQL step 4. */
const ARABIC_INDIC_DIGITS = "٠١٢٣٤٥٦٧٨٩۰۱۲۳۴۵۶۷۸۹";
const WESTERN_DIGITS = "01234567890123456789";

/** Everything outside this set is dropped — SQL step 7 (note: space survives here). */
const NON_TYPABLE = /[^a-z0-9. ء-ي]/g;

/** Sentinel protecting interdigit dots while the others are purged — SQL `chr(1)`. */
const DOT_SENTINEL = "\u0001";

/** The keyboard-typable charset a normalised answer must match (R-5 / R-2(i)). */
export const TYPABLE_CHARSET = /^[a-z0-9.ء-ي]+$/;

/** Apply a `translate()`-style character map, mirroring the SQL builtin. */
function translate(input: string, from: string, to: string): string {
  let out = "";
  for (const ch of input) {
    const i = from.indexOf(ch);
    if (i === -1) out += ch;
    else if (i < to.length) out += to[i];
    // A source character with no target is DELETED — same as SQL translate().
  }
  return out;
}

/**
 * TS replica of `public.normalize_recall_text` (étude 17, 9 steps, unchanged by
 * étude 20 per R-8). Build-time only — the runtime verdict is always SQL's.
 *
 * Known, accepted divergence: SQL `char_length` counts characters where JS
 * counts UTF-16 units. They agree on every character this charset admits (all
 * BMP); astral input is rejected by the charset guard anyway.
 */
export function normalizeRecallText(input: string | null | undefined): string {
  // (1) NFKC then lowercase.
  let t = (input ?? "").normalize("NFKC").toLowerCase();
  // (2) ligatures, then Latin de-accenting.
  t = translate(t.replaceAll("œ", "oe").replaceAll("æ", "ae"), LATIN_ACCENTS, LATIN_PLAIN);
  // (3) Arabic: strip tashkeel/tatweel, then fold أ/إ/آ→ا, ى→ي, ة→ه.
  t = translate(stripArabicDiacritics(t), ARABIC_FOLDED, ARABIC_CANONICAL);
  // (4) Arabic-Indic digits → Western.
  t = translate(t, ARABIC_INDIC_DIGITS, WESTERN_DIGITS);
  // (6) decimal comma → dot (Latin ',' and Arabic '٫').
  t = t.replaceAll("٫", ".").replaceAll(",", ".");
  // (7) drop every symbol/punctuation except '.'.
  t = t.replace(NON_TYPABLE, "");
  // (8) keep ONLY dots sitting between two digits: protect them behind a
  //     sentinel (twice — the regex cannot overlap, cf. "1.2.3"), purge the
  //     rest, then restore.
  t = t
    .replace(/([0-9])\.([0-9])/g, `$1${DOT_SENTINEL}$2`)
    .replace(/([0-9])\.([0-9])/g, `$1${DOT_SENTINEL}$2`)
    .replaceAll(".", "")
    .replaceAll(DOT_SENTINEL, ".");
  // (9) drop all whitespace.
  return t.replace(/\s/g, "");
}

/** Prompt patterns that make a question depend on its options — R-2(g), closed list. */
const OPTION_DEPENDENT =
  /(lequel|laquelle|lesquel|parmi|suivante?s?|ci-dessous|ci-dessus|intrus|incorrect|which of|following|below|odd one out|مما يلي|من بين|أي من|الدخيل|الخاطئ)/i;

/** Rich content that cannot be typed back — R-2(d). */
const RICH_CONTENT = /(<svg|<img|!\[|\$\$|http)/i;

/** Structural mathematical symbols (incl. Unicode super/subscripts) — R-2(e). */
const MATH_STRUCTURE = /[=<>^√×÷±≤≥≠≈→∈∪∩²³¹⁰-⁹₀-₉]/;

/** Composite markers: '/', ellipsis, '...', '___' — R-2(f). */
const COMPOSITE_MARKER = /[/…]|\.\.\.|_{3,}/;

/** A question as the eligibility mirror needs to see it (authored shape). */
export type EligibilityInput = {
  type: string;
  prompt: string;
  options: ReadonlyArray<{ id: string; text: string }>;
  correctOption?: string;
};

/**
 * TS replica of `public.is_question_recall_eligible` (étude 17 R-2 a–i, strictly
 * unchanged by étude 20 per R-6/Q-4). Used by `content:qa` only, to warn when an
 * authored `acceptedAnswers` would never be consumed. Build-time only.
 */
export function isRecallEligible(q: EligibilityInput): boolean {
  // (a) an mcq carrying a correct option.
  if (q.type !== "mcq" || !q.correctOption) return false;
  // (b) at least 3 options.
  if (!Array.isArray(q.options) || q.options.length < 3) return false;

  const text = q.options.find((o) => o.id === q.correctOption)?.text;
  if (text === undefined) return false;

  // (c) 1–60 characters, single line, ≤ 6 words.
  if (text.length < 1 || text.length > 60) return false;
  if (/[\n\r]/.test(text)) return false;
  const words = text.trim().split(/\s+/).filter(Boolean).length;
  if (words === 0 || words > 6) return false;

  // (d) no rich content, (e) no structural math, (f) no composite marker.
  if (RICH_CONTENT.test(text)) return false;
  if (MATH_STRUCTURE.test(text)) return false;
  if (COMPOSITE_MARKER.test(text) || text.trim().startsWith("(")) return false;

  // (g) self-sufficient prompt.
  if (OPTION_DEPENDENT.test(q.prompt ?? "")) return false;

  const norm = normalizeRecallText(text);
  // (i) typable charset (also rejects an answer normalising to empty).
  if (!TYPABLE_CHARSET.test(norm)) return false;
  // (h) no collision with a normalised distractor.
  return !q.options.some((o) => o.id !== q.correctOption && normalizeRecallText(o.text) === norm);
}

/**
 * The TS↔SQL parity corpus (RISK-2). Every row is asserted against this module
 * by Vitest AND against the deployed SQL by pgTAP; the Vitest suite also proves
 * each `input` literally appears in the pgTAP file, so the two sides cannot
 * drift apart unnoticed.
 */
export const PARITY_CORPUS: ReadonlyArray<{ input: string; expected: string; why: string }> = [
  { input: "Élève", expected: "eleve", why: "FR accents folded, case lowered" },
  { input: "sœur", expected: "soeur", why: "FR ligature œ folded (NFKC keeps it)" },
  { input: "L'Afrique", expected: "lafrique", why: "FR apostrophe dropped (article variant)" },
  { input: "Le Conseil de sécurité", expected: "leconseildesecurite", why: "FR spaces dropped" },
  { input: "They're", expected: "theyre", why: "EN contraction apostrophe dropped" },
  { input: "cannot have", expected: "cannothave", why: "EN multi-word joined" },
  { input: "مَدْرَسَةٌ", expected: "مدرسه", why: "AR tashkeel stripped, ة folded to ه" },
  { input: "النبات الأخضر", expected: "النباتالاخضر", why: "AR أ folded to ا, spaces dropped" },
  { input: "فوق الشجرة", expected: "فوقالشجره", why: "AR positional phrase (the prod case)" },
  { input: "٤٢", expected: "42", why: "AR-Indic digits to Western" },
  { input: "3,14", expected: "3.14", why: "decimal comma to dot, interdigit dot kept" },
  { input: "1 000", expected: "1000", why: "digit groups joined" },
  { input: "50 %", expected: "50", why: "percent sign made insignificant" },
  { input: "etc.", expected: "etc", why: "trailing dot dropped (not interdigit)" },
  { input: "π", expected: "", why: "off-keyboard char dropped" },
];
