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
 * isolating it would reverse the run. Only glyphs that actually flip are wrapped.
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
 * (`( ) [ ] { } ⟨ ⟩ ⌊ ⌋ ⌈ ⌉ < > ≤ ≥ ∈ ∉ ⊂ ⊃ ⊆ ⊇`), arrows, big operators and
 * grouping bars. Both raw operators and their HTML-escaped forms (`&lt;`,
 * `&gt;`) count, so the helper is safe to run before or after HTML escaping.
 */
const BIDI_FLIP_SIGNAL = /[√∛∜()[\]{}⟨⟩⌊⌋⌈⌉<>≤≥≮≯∈∉⊂⊃⊆⊇←→⟵⟶⟸⟹⟺∑∏∫|‖]|&lt;|&gt;|&le;|&ge;/u;

/**
 * Wrap every non-Arabic run that carries a bidi-flipping glyph (see
 * {@link BIDI_FLIP_SIGNAL}) in `text` with LTR isolates so it renders
 * left-to-right even inside RTL prose. Runs that are plain arithmetic, units or
 * bare numbers are left alone — the native bidi algorithm already orders them
 * correctly, and isolating them would reverse them. Text with no Arabic at all
 * is returned unchanged — LTR content (French/English) has no reordering bug.
 */
export function isolateLtrRuns(text: string): string {
  if (!text || !ARABIC_RE.test(text)) return text;
  return text.replace(SEGMENT_RE, (segment) => {
    if (ARABIC_RE.test(segment)) return segment;
    return BIDI_FLIP_SIGNAL.test(segment) ? `${LRI}${segment}${PDI}` : segment;
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
