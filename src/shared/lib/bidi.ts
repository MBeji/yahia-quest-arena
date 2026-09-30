/**
 * Bidirectional-text helpers for embedding standard (LTR) math/scientific
 * notation inside RTL (Arabic) prose.
 *
 * The project rule (`content-engine/references/math-and-notation.md`) is that
 * notation stays international and **left-to-right** in every language — Arabic
 * prose wraps a standard formula. But math symbols are bidi-neutral: `√`, `=`,
 * `×`, `÷`, `(`, `)` all have Unicode bidi class "ON" (Other Neutral). Dropped
 * verbatim into an RTL paragraph they inherit the surrounding RTL direction, so
 * the browser reorders them: `√64` renders as `64√`, and a multi-term
 * expression like `√50 = √(25 × 2) = 5√2` is scrambled to `2√5 = (2 × 25)√ = 50√`.
 *
 * The fix is to make such a formula a **contiguous LTR run**. CSS already does
 * this for `$$ … $$` display blocks (`.lesson-math { direction: ltr }`), but
 * inline math inside prompts, options, explanations and lesson paragraphs was
 * never isolated. We do it here by wrapping every non-Arabic run that carries a
 * **mirrored/direction-sensitive** glyph (a radical, bracket, comparison, arrow…
 * — see {@link BIDI_FLIP_SIGNAL}) in Unicode directional **isolates**
 * (U+2066 LRI … U+2069 PDI). Isolates work in both React text nodes and raw HTML
 * strings, need no CSS, and don't introduce new DOM nodes.
 *
 * Crucially we do **not** isolate plain digits or linear operators (`+ − × ÷ =`):
 * the native bidi algorithm already orders `10 مي + 2 مي = ؟` correctly, and
 * isolating it would reverse the run. Only glyphs that actually flip are wrapped —
 * and the few number-and-letter formulas that come out half reversed
 * ({@link DIGIT_FIRST_FORMULA}, {@link LEADING_SIGN_LETTER}).
 */

/** LEFT-TO-RIGHT ISOLATE — opens an isolated LTR run. */
const LRI = "⁦";
/** POP DIRECTIONAL ISOLATE — closes the run opened by LRI. */
const PDI = "⁩";

/**
 * Arabic script blocks: base Arabic, Supplement, Extended-A, and the
 * presentation-form blocks. Used to split text into Arabic vs. non-Arabic runs.
 */
const ARABIC_CHARS = "\\u0600-\\u06FF\\u0750-\\u077F\\u08A0-\\u08FF\\uFB50-\\uFDFF\\uFE70-\\uFEFF";
const ARABIC_RE = new RegExp(`[${ARABIC_CHARS}]`, "u");
const SEGMENT_RE = new RegExp(`[${ARABIC_CHARS}]+|[^${ARABIC_CHARS}]+`, "gu");

/**
 * A non-Arabic run is worth isolating **only when it carries a character that
 * actually flips or mirrors** under the RTL bidi algorithm — otherwise isolating
 * does more harm than good.
 *
 * The browser's native UBA already lays out plain arithmetic correctly inside
 * RTL prose: digits anchor as LTR weak runs, so `10 مي + 2 مي = ؟`,
 * `النتيجة = 8`, `5 × 3 = 15`, `90°` and `12 صم²` all render right. **Wrapping
 * those in an LTR isolate breaks them** — the whole run becomes one LTR atom
 * whose right edge is the *end* of the expression, so it reads reversed against
 * the surrounding RTL flow (`10 مي + 2 مي` → `10مي 2 + مي`). So the linear
 * operators (`+ − × ÷ = ≠ ± % ° . , /`), digits, sub/superscripts, `π`, `∞`
 * and Arabic-script units must **not** trigger isolation.
 *
 * What genuinely needs isolation is a run containing a **mirrored or
 * direction-sensitive** glyph: the radical `√` (a prefix that otherwise lands
 * after its operand — `√64` → `64√`), the Bidi_Mirrored bracket/relation set
 * (`( ) [ ] { } ⟨ ⟩ ⌊ ⌋ ⌈ ⌉ < > ≤ ≥ ∈ ∉ ∋ ∌ ⊂ ⊃ ⊄ ⊅ ⊆ ⊇ ⊈ ⊉ ⊊ ⊋`), arrows, big
 * operators and grouping bars. The set relations go as a WHOLE family: `⊄` or `∋`
 * left out stays at the RTL level when it stands alone in Arabic prose and is drawn
 * with its mirror glyph — `⊄` read as `⊅`, the statement reversed (#1117). The angle
 * signs `∠ ∡ ∢` are in the same case: `يحقّق ∠ABy = 60°` was drawn `ABy = 60°⦣`, the
 * sign detached from its letters and mirrored. Both raw operators and their HTML-escaped
 * forms (`&lt;`, `&gt;`) count, so the helper is safe to run before or after HTML escaping.
 */
const BIDI_FLIP_SIGNAL =
  /[√∛∜()[\]{}⟨⟩⌊⌋⌈⌉<>≤≥≮≯∈∉∋∌⊂⊃⊄⊅⊆⊇⊈⊉⊊⊋←→⟵⟶⟸⟹⟺∑∏∫∠∡∢|‖]|&lt;|&gt;|&le;|&ge;/u;

/**
 * A segment that is **only** whitespace and paired bracket characters with no
 * other LTR-anchoring content.  The browser's native bidi algorithm mirrors
 * paired brackets correctly inside RTL prose (`(` ↔ `)`), so isolating them
 * as LTR reverses their visual order — the close bracket appears before the
 * open bracket in reading order (bug reported: C5/C6/C7, parenthesised Arabic
 * diacritics and chapter titles).  We skip isolation for these segments and let
 * the natural bidi-mirror apply.
 */
const SOLO_BRACKETS_RE = /^[\s()[\]{}⟨⟩⌊⌋⌈⌉]+$/u;

/**
 * Subset of {@link BIDI_FLIP_SIGNAL} that mandates isolation **even when the
 * segment is bracket-only**: radicals (`√`…), comparison / set relations
 * (`< > ≤ ≥ ∈ ⊂`…), arrows, large operators and grouping bars.  These glyphs
 * do not benefit from bidi-mirroring and must be forced LTR.
 */
const STRONG_FLIP_SIGNAL = /[√∛∜<>≤≥≮≯∈∉∋∌⊂⊃⊄⊅⊆⊇⊈⊉⊊⊋←→⟵⟶⟸⟹⟺∑∏∫∠∡∢|‖]|&lt;|&gt;|&le;|&ge;/u;

/**
 * A **tight signed number** — a `+`/`−` glued directly to a digit (`−5`, `+90`,
 * `−2x`), *not* following an operand. This is the one direction-sensitive form
 * `BIDI_FLIP_SIGNAL` misses: a bare negative like `−5` dropped into RTL prose
 * (`… إذن −5 أقرب …`) has no bracket or relation to anchor it, so the neutral sign
 * inherits the RTL run and can render `5−` — the exact scramble seen in the
 * concours défis. Isolating the run fixes it.
 *
 * The lookbehind `(?<![\d)])` is what keeps this safe: it fires **only** on a
 * *leading* sign, never on binary subtraction/addition. Those are written spaced
 * by convention (`5 − 3`, `10 مي + 2 مي`, `0 د − 1`) — the native bidi algorithm
 * already lays them out correctly, and the space means the sign is not glued to a
 * digit, so this pattern never matches them. Only the tight, unary sign is caught.
 *
 * The two extra alternatives cover **signed exponents and indices** (superscript or
 * subscript minus/plus glued to its digit). They deliberately carry **no lookbehind**:
 * a superscript minus (U+207B) or subscript minus (U+208B) is never a binary operator,
 * so there is no subtraction to protect, and the sign always *follows* its base digit.
 * Without them a bare negative exponent dropped into Arabic prose renders reversed.
 * Found on the 9eme maths powers chapter, where the sibling gap in isMathExpression
 * (utils.ts) was flipping whole QCM options — including two correct answers.
 */
const SIGNED_NUMBER = /(?<![\d)])[−–+][0-9]|[⁻⁺][⁰¹²³⁴⁵⁶⁷⁸⁹]|[₋₊][₀₁₂₃₄₅₆₇₈₉]/u;

/**
 * Two more forms the native algorithm scrambles, both **mixed number-and-letter
 * formulas** whose reading order depends on what comes first. After an Arabic word a
 * Latin LETTER is a strong left-to-right character, and every number after it inherits
 * that direction (rule W7) — so `x − 3 = 5` and `AB = 5 − x` already render left to right.
 * But when the formula opens with a number, or with a sign glued to a letter, the first
 * term sits at the RTL level and only the tail turns left-to-right: the formula comes out
 * half reversed.
 *
 *  - {@link DIGIT_FIRST_FORMULA}: a number, an operator, then a letter, with no letter
 *    before (`25 + k = 9` drawn `k = 9 + 25`, `1/b` drawn `b/1`, `3 − x`, `10 × 3^p`).
 *  - {@link LEADING_SIGN_LETTER}: a sign glued to a letter that does not follow an operand
 *    (`−x + 1` drawn `x + 1−`, `−b`, `+b`).
 *
 * Measured on the whole corpus (96 943 Arabic strings), about 260 and 110 segments. Digit-only
 * arithmetic (`10 − 4 = 6`, `3 + 5 = ؟`) carries no letter, stays untouched and keeps
 * reading right to left with the sentence, as designed above.
 */
const DIGIT_FIRST_FORMULA = /^[^A-Za-z]*?\d[\d.,]*\s*[+−–×÷/=^]\s*[A-Za-z]/u;
const LEADING_SIGN_LETTER = /^[^A-Za-z]*?(?<![\d)])[−–+][A-Za-z]/u;

/**
 * Wrap every non-Arabic run that carries a bidi-flipping glyph (see
 * {@link BIDI_FLIP_SIGNAL}) or a tight signed number (see {@link SIGNED_NUMBER})
 * in `text` with LTR isolates so it renders left-to-right even inside RTL prose.
 * Runs that are plain arithmetic, units or bare numbers are left alone — the
 * native bidi algorithm already orders them correctly, and isolating them would
 * reverse them. Text with no Arabic at all is returned unchanged — LTR content
 * (French/English) has no reordering bug.
 *
 * The Latin punctuation that BORDERS a formula (`.,;:` closing a sentence or
 * opening an énoncé) stays OUTSIDE the isolate — see {@link peelEdgePunctuation}.
 */
export function isolateLtrRuns(text: string): string {
  if (!text || !ARABIC_RE.test(text)) return text;
  return text.replace(SEGMENT_RE, (segment) => {
    if (ARABIC_RE.test(segment)) return segment;
    const [lead, core, tail] = peelEdgePunctuation(segment);
    return needsLtrIsolate(core) ? `${lead}${LRI}${core}${PDI}${tail}` : segment;
  });
}

/**
 * HTML-aware variant of {@link isolateLtrRuns}: isolates math runs only inside
 * text content, never inside tag markup (so class names, ids and attributes are
 * left alone). Used by the markdown renderer on its final HTML output.
 */
export function isolateLtrRunsHtml(html: string): string {
  if (!html || !ARABIC_RE.test(html)) return html;
  return html
    .split(/(<[^>]*>)/)
    .map((piece) => (piece.startsWith("<") ? piece : isolateLtrRuns(piece)))
    .join("");
}

/* --------------------------------------------------------------------------
 * Une équation ne se coupe JAMAIS en deux lignes.
 *
 * Les isolats ci-dessus corrigent l'ORDRE des glyphes, pas le RETOUR À LA
 * LIGNE : `LRI … PDI` reste cassable à chaque espace. Un énoncé arabe un peu
 * long — `… ما حلول المعادلة (x − 4)(x + 2) = 0 ؟` — voit donc son équation
 * scindée par le navigateur, `(x − 4)` finissant une ligne et `(x + 2) = 0`
 * ouvrant la suivante. Chaque ligne étant réordonnée POUR ELLE-MÊME par
 * l'algorithme bidi, l'élève lit deux moitiés de formule mêlées à la prose —
 * le défaut signalé en capture.
 *
 * Aucun caractère ne peut réparer cela ; seul le rendu le peut. On expose donc
 * la même segmentation sous forme de RUNS, que React pose en éléments
 * `.math-run` (insécables, isolés LTR — `src/styles.css`), plus un test de
 * « ligne-équation » pour poser une formule seule sur sa ligne, hors du texte
 * de la question.
 * ------------------------------------------------------------------------ */

/**
 * Un morceau de champ de contenu tel qu'il sera posé.
 *
 * `math` — le run est une formule : rendu isolé, gauche-à-droite.
 * `nowrap` — et il est assez court pour tenir sur une ligne, donc insécable.
 *   Au-delà de {@link NOWRAP_MAX} la formule ne tient de toute façon sur aucune
 *   ligne de téléphone : la rendre insécable la ferait déborder de la carte
 *   (barre de défilement horizontale sur toute la page). Elle garde alors le
 *   comportement d'aujourd'hui — isolée, mais cassable.
 */
export type TextRun = { text: string; math: boolean; nowrap: boolean };

/**
 * Longueur au-delà de laquelle une formule n'est plus rendue insécable.
 *
 * 32 signes ≈ 15 em pour de la notation, soit la largeur utile d'une carte de
 * quête sur le plus petit téléphone visé, au corps du titre d'énoncé (20 px).
 * Au-delà, l'insécable ne « garde plus la formule sur une ligne » : il la fait
 * déborder de la carte et ouvre une barre de défilement horizontale sur toute
 * la page — pire que le défaut qu'on corrige.
 *
 * Le seuil ne coûte presque rien : mesuré sur le corpus (2 765 runs isolés dans
 * des énoncés arabes), **99,3 % tiennent en 32 signes** et le 99ᵉ centile est à
 * 27 — `(x − 4)(x + 2) = 0`, le cas signalé, en fait 18. Ce qui dépasse est une
 * CHAÎNE de calcul de corrigé (jusqu'à 132 signes relevés), qu'aucun réglage ne
 * fera tenir sur une ligne ; elle garde le comportement d'aujourd'hui.
 */
const NOWRAP_MAX = 32;

/** La condition exacte qu'applique {@link isolateLtrRuns} à un segment non arabe. */
function needsLtrIsolate(segment: string): boolean {
  return (
    (BIDI_FLIP_SIGNAL.test(segment) &&
      (!SOLO_BRACKETS_RE.test(segment) || STRONG_FLIP_SIGNAL.test(segment))) ||
    SIGNED_NUMBER.test(segment) ||
    DIGIT_FIRST_FORMULA.test(segment) ||
    LEADING_SIGN_LETTER.test(segment)
  );
}

/**
 * Sépare un segment non arabe DÉJÀ jugé à isoler en `[attaque, formule, queue]`,
 * la ponctuation latine qui le borde (`.`, `,`, `;`, `:`) et la parenthèse qu'il
 * ouvre ou ferme sans sa compagne allant à l'attaque ou à la queue.
 * `attaque + formule + queue` redonne toujours le segment.
 *
 * Pourquoi : isolée avec la formule, cette ponctuation se lit dans l'isolat
 * gauche-à-droite. Le point qui ferme `المجال هو [−3 ; −1].` se dessinait alors
 * entre le dernier mot arabe et la formule (à droite d'elle) au lieu d'être à
 * l'extrémité gauche de la ligne qui termine la phrase ; les deux points de
 * `أمثلة: √9 = 3` passaient après la formule ; et le « ( » de `… = 12 + 8√2 (الحدّان …)`,
 * qui ouvre un membre de phrase ARABE, restait à droite de la formule, du mauvais
 * côté du texte qu'il enferme. Hors de l'isolat, ces caractères sont des neutres
 * entre deux forts RTL : ils prennent le sens de la phrase, et l'appariement des
 * parenthèses fait le reste.
 *
 * Garde-fous : la ponctuation d'attaque n'est retirée que si un espace la suit
 * (`: √9`, jamais le point d'un décimal `.5`) ; une parenthèse n'est retirée que
 * si elle n'a pas de compagne DANS la formule — `(x − 4)(x + 2) = 0` reste entière.
 * C'est la FORMULE (et non le segment entier) que les appelants soumettent à
 * {@link needsLtrIsolate} : un segment dont la seule raison d'être isolé était une
 * parenthèse de prose (`2012 (` dans le titre `مناظرة 2012 (تقني)`) ne l'est plus,
 * et se rend comme le navigateur sait le faire.
 */
function peelEdgePunctuation(segment: string): [lead: string, core: string, tail: string] {
  const count = (text: string, char: string) => text.split(char).length - 1;
  let lead = "";
  let core = segment;
  let tail = "";
  for (;;) {
    const punctuation = /^\s*[.,;:]+(?=\s)/u.exec(core)?.[0];
    const closer = count(core, ")") > count(core, "(") ? /^\s*\)/u.exec(core)?.[0] : undefined;
    const peeled = punctuation ?? closer;
    if (!peeled) break;
    lead += peeled;
    core = core.slice(peeled.length);
  }
  for (;;) {
    const punctuation = /\s*[.,;:]+\s*$/u.exec(core)?.[0];
    const opener = count(core, "(") > count(core, ")") ? /\s*\(\s*$/u.exec(core)?.[0] : undefined;
    const peeled = punctuation ?? opener;
    if (!peeled) break;
    tail = peeled + tail;
    core = core.slice(0, core.length - peeled.length);
  }
  return [lead, core, tail];
}

/**
 * Caractères admis dans un jeton mathématique : chiffres, lettres latines,
 * opérateurs, relations, exposants/indices Unicode, délimiteurs, symboles et la
 * ponctuation qui colle à une formule. Tout le reste (lettres accentuées,
 * écriture arabe, guillemets typographiques…) marque de la prose et coupe le run.
 */
const MATH_TOKEN_CHARS =
  "0-9A-Za-z+\\-−–±*/=<>≤≥≠≈≡%‰¹²³⁰⁴-⁹⁺⁻₀-₉₊₋√∛∜×÷·^_()\\[\\]{}⟨⟩⌊⌋⌈⌉|‖πµσΩ∆°′″.,;:…!?∈∉∋∌⊂⊃⊄⊅⊆⊇⊈⊉⊊⊋∪∩∅ℝℕℤℚℂ∥⊥∠→⟶⟵⟸⟹⟺∑∏∫∞'";
const MATH_TOKEN_RE = new RegExp(`^[${MATH_TOKEN_CHARS}]+$`, "u");
/** Un opérateur, une relation ou un délimiteur — ce qui fait d'une suite de jetons une formule. */
const MATH_OPERATOR_RE = /[+\-−–±*/=<>≤≥≠≈≡×÷·√∛∜()[\]{}⟨⟩⌊⌋⌈⌉∈∉∋∌⊂⊃⊄⊅⊆⊇⊈⊉⊊⊋∪∩∥⊥→⟶⟵⟸⟹⟺∑∏∫^]/u;
/** Une relation : `x = 5` est une formule à lui seul, `2 + 3` demande deux jetons. */
const MATH_RELATION_RE = /[=<>≤≥≠≈≡⟹⟺]|&lt;|&gt;|&le;|&ge;/u;
/** Suite d'au moins trois lettres latines — un MOT, sauf s'il est dans la liste ci-dessous. */
const WORD_RE = /[A-Za-z]{3,}/gu;

/**
 * Les seuls mots de trois lettres et plus, TOUT EN MINUSCULES OU CAPITALISÉS, qui
 * appartiennent à une formule : noms de fonctions et unités SI. Tout autre mot de
 * cette forme coupe le run — c'est ce qui empêche l'atome d'avaler la phrase
 * anglaise qui l'entoure (`(like it), so it` était happé par la parenthèse avant
 * cette liste).
 *
 * Les mots à MAJUSCULE INTERNE n'ont pas besoin d'y figurer : `AlCl`, `NaOH`,
 * `SO`, `PGCD` ne sont pas des mots de prose — aucune langue n'écrit ainsi — et
 * {@link hasProseWord} les laisse passer sur ce seul critère. C'est ce qui rend
 * une équation-bilan de chimie (`2Al + 3Cl₂ → 2AlCl₃`) lisible comme une formule.
 */
const MATH_WORDS = new Set([
  "sin",
  "cos",
  "tan",
  "cot",
  "sec",
  "csc",
  "sinh",
  "cosh",
  "tanh",
  "arcsin",
  "arccos",
  "arctan",
  "log",
  "exp",
  "lim",
  "sup",
  "inf",
  "min",
  "max",
  "abs",
  "det",
  "mod",
  "gcd",
  "lcm",
  "pgcd",
  "ppcm",
  "mol",
  "rad",
  "deg",
  "atm",
  "ppm",
  "kwh",
  "kpa",
  "hpa",
  "dag",
]);

/**
 * Un jeton est mathématique s'il n'emprunte que le jeu de caractères ci-dessus,
 * qu'aucun de ses mots n'est de la prose (voir {@link hasProseWord}), ET qu'il
 * porte un signe d'appartenance : un chiffre — indices et exposants Unicode
 * compris, pour `SO₂` —, un opérateur, une longueur ≤ 2 (`x`, `AB`, `n`), ou un
 * nom de fonction connu (`sin`, seul dans `n₁ sin i₁ = n₂ sin i₂`). Un mot de
 * prose (`Calculer`, `solution.`, `museum)`) échoue au test des mots ; un mot
 * court sans opérateur (`the`) échoue au signe.
 */
function hasProseWord(token: string): boolean {
  for (const word of token.match(WORD_RE) ?? []) {
    if (MATH_WORDS.has(word.toLowerCase())) continue;
    if (/[A-Z]/u.test(word.slice(1))) continue; // majuscule interne : formule, pas prose
    return true;
  }
  return false;
}

function isMathToken(token: string): boolean {
  if (!token || !MATH_TOKEN_RE.test(token)) return false;
  if (hasProseWord(token)) return false;
  return (
    /[0-9₀-₉⁰-⁹¹²³]/u.test(token) ||
    MATH_OPERATOR_RE.test(token) ||
    token.length <= 2 ||
    MATH_WORDS.has(token.toLowerCase())
  );
}

/** Vrai quand la suite de jetons forme une formule (et pas une énumération de lettres). */
function isMathPhrase(tokens: string[]): boolean {
  const joined = tokens.join(" ");
  if (MATH_RELATION_RE.test(joined)) return true;
  return tokens.length > 1 && MATH_OPERATOR_RE.test(joined);
}

/**
 * Un jeton qu'un opérateur seul rattache à la formule : une suite de lettres
 * latines (`x` et `AB`, mais aussi `de`, `so`, `La`) ou un `?` isolé — inconnue
 * d'un énoncé de primaire dans `? + 250 = 700`, simple ponctuation dans
 * `… = 0 ?`. C'est le voisinage, pas le glyphe, qui tranche.
 */
const PROSE_SHAPED_RE = /^(?:[A-Za-z]+|\?)$/u;
/** Un jeton fait seulement d'opérateurs — `=`, `+`, `≤`, `→` : ce qui LIE une lettre à la formule. */
const BARE_OPERATOR_RE = /^[+\-−–±*/=<>≤≥≠≈≡×÷·∈∉∋∌⊂⊃⊄⊅⊆⊇⊈⊉⊊⊋∪∩∥⊥→⟶⟵⟸⟹⟺]+$/u;

/**
 * Rogne les bords d'un run des jetons purement alphabétiques qu'aucun opérateur
 * ne rattache à la formule, et rend les bornes `[début, fin]` retenues (`fin`
 * < `début` si tout tombe).
 *
 * C'est la garde qui sépare `x` de `de`. Les deux sont des jetons d'une ou deux
 * lettres, donc « mathématiques » ; mais dans `x = 5` le voisin de `x` est
 * l'opérateur nu `=`, alors que dans `la solution de (x − 4)(x + 2) = 0` le
 * voisin de `de` est `(x`. Sans ce rognage, l'atome insécable emportait le mot
 * qui précède la formule — et, en anglais, des bouts de phrase entiers
 * (`it), so it`).
 */
function trimProseEdges(tokens: string[]): [number, number] {
  const bound = (index: number) =>
    index >= 0 && index < tokens.length && BARE_OPERATOR_RE.test(tokens[index]);
  let low = 0;
  let high = tokens.length - 1;
  while (low <= high && PROSE_SHAPED_RE.test(tokens[low]) && !bound(low + 1)) low += 1;
  while (high >= low && PROSE_SHAPED_RE.test(tokens[high]) && !bound(high - 1)) high -= 1;
  return [low, high];
}

const run = (text: string, math: boolean): TextRun => ({
  text,
  math,
  nowrap: math && text.trim().length <= NOWRAP_MAX,
});

/**
 * Découpe une prose SANS arabe en runs, en marquant les seules formules. Rien
 * n'est réordonné ici — un texte latin dans un contexte latin n'a pas de bug
 * d'ordre : on marque uniquement pour que le rendu garde la formule d'un seul
 * tenant. Une chaîne de calcul trop longue pour une ligne n'est pas marquée du
 * tout : l'insécable la ferait déborder, et elle n'a rien à isoler.
 */
function splitLtrProse(text: string): TextRun[] {
  const pieces = text.split(/(\s+)/);
  const runs: TextRun[] = [];
  let prose: string[] = [];
  const flushProse = () => {
    if (prose.length) runs.push(run(prose.join(""), false));
    prose = [];
  };
  for (let index = 0; index < pieces.length; index += 1) {
    if (!isMathToken(pieces[index])) {
      prose.push(pieces[index]);
      continue;
    }
    // Étend le run tant que les jetons restent mathématiques (séparateurs compris),
    // puis rogne les mots que rien ne rattache à la formule.
    const spots: number[] = [];
    for (let scan = index; scan < pieces.length && isMathToken(pieces[scan]); scan += 2) {
      spots.push(scan);
    }
    const last = spots[spots.length - 1];
    const [low, high] = trimProseEdges(spots.map((spot) => pieces[spot]));
    const tokens = spots.slice(low, high + 1).map((spot) => pieces[spot]);
    const body = high < low ? "" : pieces.slice(spots[low], spots[high] + 1).join("");
    const whole = pieces.slice(index, last + 1).join("");
    const start = index;
    index = last;
    if (!tokens.length || !isMathPhrase(tokens) || body.trim().length > NOWRAP_MAX) {
      prose.push(whole);
      continue;
    }
    prose.push(pieces.slice(start, spots[low]).join(""));
    flushProse();
    runs.push(run(body, true));
    prose.push(pieces.slice(spots[high] + 1, last + 1).join(""));
  }
  flushProse();
  return runs;
}

/**
 * Découpe `text` en runs de prose et de formules, pour un rendu où la formule
 * tient d'un seul tenant.
 *
 * En contexte arabe la segmentation est **exactement** celle de
 * {@link isolateLtrRuns} — mêmes runs, même signal : le rendu n'isole donc ni
 * plus ni moins qu'aujourd'hui, il rend seulement l'isolat incassable. En
 * contexte latin il n'y a rien à isoler, on repère juste les formules.
 *
 * Les espaces qui bordent une formule appartiennent à la PROSE, pas au run :
 * posés dans le span insécable, ils supprimeraient la seule coupure possible
 * entre deux formules voisines (`[0 ; 10[ ، [10 ; 20[ ، [20 ; 30[` — la virgule
 * arabe n'admet aucun saut avant elle, l'espace qui la suit était pris dans
 * l'insécable), et une liste d'intervalles ne passerait plus jamais à la ligne :
 * elle débordait de la carte d'un téléphone (14 à 582 px mesurés).
 *
 * La ponctuation latine qui borde une formule (`.,;:`) est de la prose, elle
 * aussi : voir {@link peelEdgePunctuation}.
 */
export function splitMathRuns(text: string): TextRun[] {
  if (!text) return [];
  if (!ARABIC_RE.test(text)) return splitLtrProse(text);
  const runs: TextRun[] = [];
  const pushProse = (chunk: string) => {
    if (!chunk) return;
    const previous = runs[runs.length - 1];
    if (previous && !previous.math) previous.text += chunk;
    else runs.push(run(chunk, false));
  };
  for (const segment of text.match(SEGMENT_RE) ?? []) {
    if (ARABIC_RE.test(segment)) {
      pushProse(segment);
      continue;
    }
    const [edgeLead, core, edgeTail] = peelEdgePunctuation(segment);
    if (!needsLtrIsolate(core)) {
      pushProse(segment);
      continue;
    }
    const [, lead, body, tail] = core.match(/^(\s*)([\s\S]*?)(\s*)$/u) as RegExpMatchArray;
    pushProse(edgeLead + lead);
    runs.push(run(body, true));
    pushProse(tail + edgeTail);
  }
  return runs;
}

/**
 * Vrai quand `line` est une ligne-équation : **rien que** de la notation, avec
 * un opérateur ou une relation. Une telle ligne se rend en bloc centré LTR,
 * séparée du texte de la question — la forme demandée pour un énoncé qui pose
 * une formule.
 *
 * Volontairement plus strict que `isMathExpression` (`src/shared/lib/utils.ts`),
 * qui sert à orienter le texte d'une OPTION et accepte donc n'importe quelle
 * suite de lettres latines (« Paris » y est « mathématique », sans dommage
 * puisqu'il est bien LTR). Ici une phrase de prose promue en bloc centré serait
 * un défaut visible : on exige que chaque jeton soit mathématique.
 */
export function isDisplayEquation(line: string): boolean {
  const tokens = line.trim().split(/\s+/).filter(Boolean);
  if (!tokens.length) return false;
  if (!tokens.every(isMathToken)) return false;
  // Un mot que rien ne rattache à la formule reste de la prose, même seul sur sa
  // ligne : `A B C` n'est pas une équation à centrer.
  const [low, high] = trimProseEdges(tokens);
  if (low !== 0 || high !== tokens.length - 1) return false;
  return isMathPhrase(tokens);
}
