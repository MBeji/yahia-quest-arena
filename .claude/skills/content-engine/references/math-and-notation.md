# Math & notation standard — digits, equations, symbols (ALL languages, including Arabic)

This is a **hard rule**, not a style preference: numbers and mathematical/scientific notation are
**standard and international in every subject, whatever its `contentLanguage`** — identical in
Arabic, French, and English content. The production math subject (`content/math`, Arabic, 9ème) is
the precedent: Arabic prose around standard math. Never "arabize" the math itself.

## Digits — Western digits only, everywhere

- Always `0 1 2 3 4 5 6 7 8 9`. **Never Arabic-Indic digits** (`٠١٢٣٤٥٦٧٨٩`) — not in prompts,
  options, explanations, titles, cours.md, resume.md, or SVG figures. This applies to Arabic
  content too (math, sciences, but also dates and quantities in arabe/culture-générale).
- The QA tooling only _folds_ Arabic-Indic digits for comparison; it does not reject them — you
  enforce this rule at authoring time, and `content-audit` flags violations in existing content.

## Equations & expressions — standard international notation, LTR

- Formulas are written exactly as in a French/English textbook: Latin variable names (`x`, `y`,
  `a`, `b`), left-to-right, standard structure. E.g. in an Arabic prompt:
  `ما حلّ المعادلة: 2x + 5 = 13 ؟` — the Arabic question surrounds a standard equation.
- **Operators/symbols**: true minus `−` (U+2212, not the hyphen `-`), `×` for multiplication
  (never the letter x), `÷` or fraction bars, `=`, `≠`, `<`, `>`, `≤`, `≥`, `√`, `π`, `∈`, `⊂`,
  `⟺`, `→`. Exponents as `x²`, `10³` (Unicode superscripts).
- **Keep each formula a contiguous LTR run** inside RTL text: never interleave Arabic words
  _inside_ an equation; write the Arabic sentence, then the full expression, then resume Arabic
  (as the production math content does). In cours.md, put substantial formulas on their own line.
- **Units & scientific symbols stay standard SI**: `cm`, `m²`, `kg`, `g/mol`, `%`, `°C`, `km/h` —
  never transliterated, in any language.

## No LaTeX anywhere — the app has no math renderer

The markdown renderer (`src/shared/lib/markdown.ts`) is a plain-text pipeline: it does **not**
render LaTeX. Any `\sqrt{…}`, `\frac{…}{…}`, `\overrightarrow{…}`, `\begin{pmatrix}`… displays as
raw markup to the student, and inline `$…$` shows its dollar signs literally. Therefore:

- **Everything is plain Unicode math** — cours.md, resume.md, question strings, SVG labels alike.
  `2x − 3 = 7`, `x ≥ −3`, `√(25 × 2) = 5√2`, `(xB − xA ; yB − yA)` all read fine as-is.
- **`$$ … $$` is allowed in cours.md only as a display-block marker** (the renderer turns it into
  a centered, LTR-isolated `lesson-math` block) — but its **content must be plain Unicode**, never
  LaTeX, and the **whole block must sit on a single line** (`$$ formula $$`): the renderer's regex
  doesn't span lines, so a multi-line block renders as literal `$$` paragraphs. One formula per
  block; stack several single-line blocks for a system of equations. Inline `$…$` is forbidden
  (not processed; dollars render).
- **Plain-Unicode equivalents** (match the production question conventions):
  `\sqrt{50}` → `√50`; `\sqrt{25 × 2}` → `√(25 × 2)` (parenthesize multi-term radicands);
  `\frac{a}{b}` → `a/b` with parentheses as needed (`(xA + xB)/2`); subscripts as plain letters
  (`xA`, `yB`); `\overrightarrow{AB}` → bare `AB` with the word for "vector" in prose
  (e.g. `الشعاع AB`); `\begin{pmatrix} x \\ y \end{pmatrix}` → `(x ; y)`; `\boxed{X}` → `**X**`;
  `\times` → `×`; `\le`/`\ge` → `≤`/`≥`; `\parallel` → `∥`; `\implies` → `⟹`; `\iff` → `⟺`;
  `\sin`/`\cos`/`\tan` → `sin`/`cos`/`tan`; `x^2` → `x²`.
- **SVG figures**: numbers and labels inside `<text>` use Western digits and standard symbols.

## Decimal separator & locale details

- `fr` and `ar` content: decimal **comma** (`3,5`) — the Tunisian school convention. `en` content:
  decimal **point** (`3.5`).
- **Thousands separator — bidi-critical in Arabic.** In `ar` content, group digits with a
  **NO-BREAK SPACE U+00A0** (`38 461`), **never a plain space**: in RTL text a plain space is
  bidi-neutral, so `38 461` renders as `461 38` (the groups swap) even though the source is
  correct. U+00A0 has bidi class CS (common number separator), which keeps the whole number a
  single LTR run. In `fr` (LTR) a plain or no-break space both render fine — prefer U+00A0 for
  consistency; in `en` use the comma (`12,500`).
- Intervals, set notation, function notation follow the official textbook convention of the
  subject's grade (e.g. `]−2 ; +∞[`); keep the notation itself standard/LTR even in Arabic prose.
- Worked computations in explanations chain standard notation with `→` and end with the
  verification check: `2x = 8 → x = 4. تحقّق: 2(4) + 5 = 13 ✓`.

## Self-check before running QA

Scan every file you wrote for `[٠-٩]` (must be zero matches), for hyphens used as minus signs in
formulas, for the letter `x` used as a multiplication sign, for **LaTeX residue** (regex
`\\[a-zA-Z]+` — zero matches in any content file) and **inline dollar math** (`$…$` outside
`$$ … $$` display blocks — zero matches), and — **in `ar` content** — for a plain space between
digit groups (regex `\d \d{3}` outside `<svg>` markup, must be zero: use U+00A0). The
`content-audit` skill performs the same scans on existing content.

**Two recurring U+00A0 traps** (seen authoring multi-digit Arabic content):

1. **The file-write path can silently flatten U+00A0 → a plain space.** So re-run the `\d \d{3}` scan
   _after_ writing each file and re-inject U+00A0 (e.g. a byte-level rewrite) wherever a plain space
   reappeared — otherwise the bidi swap ships.
2. **Group consistently across option, prompt and explanation.** An _option_ left ungrouped (`308000`)
   while its prompt/explanation is grouped (`308 000`) trips `content:qa`'s «answer value not echoed»
   warning — that check's number-extractor splits on the U+00A0, so the two forms no longer match.
   Group (or leave ungrouped) the **same way** everywhere in a question.
