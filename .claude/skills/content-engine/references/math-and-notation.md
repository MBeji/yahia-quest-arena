# Math & notation standard — digits, equations, symbols (ALL languages, including Arabic)

This is a **hard rule**, not a style preference: numbers and mathematical/scientific notation are
**standard and international in every subject, whatever its `contentLanguage`** — identical in
Arabic, French, and English content. The production math subject (`content/math`, Arabic, 9ème) is
the precedent: Arabic prose around standard math. Never "arabize" the math itself.

## Digits — Western digits only, everywhere

- Always `0 1 2 3 4 5 6 7 8 9`. **Never Arabic-Indic digits** (`٠١٢٣٤٥٦٧٨٩`) — not in prompts,
  options, explanations, titles, cours.md, resume.md, or SVG figures. This applies to Arabic
  content too (math, sciences, but also dates and quantities in arabe/culture-générale).
- The QA tooling only *folds* Arabic-Indic digits for comparison; it does not reject them — you
  enforce this rule at authoring time, and `content-audit` flags violations in existing content.

## Equations & expressions — standard international notation, LTR

- Formulas are written exactly as in a French/English textbook: Latin variable names (`x`, `y`,
  `a`, `b`), left-to-right, standard structure. E.g. in an Arabic prompt:
  `ما حلّ المعادلة: 2x + 5 = 13 ؟` — the Arabic question surrounds a standard equation.
- **Operators/symbols**: true minus `−` (U+2212, not the hyphen `-`), `×` for multiplication
  (never the letter x), `÷` or fraction bars, `=`, `≠`, `<`, `>`, `≤`, `≥`, `√`, `π`, `∈`, `⊂`,
  `⟺`, `→`. Exponents as `x²`, `10³` (Unicode superscripts) or LaTeX in cours.md.
- **Keep each formula a contiguous LTR run** inside RTL text: never interleave Arabic words
  *inside* an equation; write the Arabic sentence, then the full expression, then resume Arabic
  (as the production math content does). In cours.md, put substantial formulas on their own line.
- **Units & scientific symbols stay standard SI**: `cm`, `m²`, `kg`, `g/mol`, `%`, `°C`, `km/h` —
  never transliterated, in any language.

## Where LaTeX vs plain Unicode

- **cours.md**: display formulas may use `$$ … $$` LaTeX blocks (rendered); inline math uses plain
  Unicode symbols.
- **Question strings** (prompt/options/explanation in quiz.json and exercises): **plain Unicode
  math only** — no LaTeX delimiters; they are rendered as plain text. `2x − 3 = 7`, `x ≥ −3`,
  `√49 = 7` all read fine as-is.
- **SVG figures**: numbers and labels inside `<text>` use Western digits and standard symbols.

## Decimal separator & locale details

- `fr` and `ar` content: decimal **comma** (`3,5`) — the Tunisian school convention. `en` content:
  decimal **point** (`3.5`). Thousands: prefer a thin/regular space (`12 500`) in fr/ar, comma in en.
- Intervals, set notation, function notation follow the official textbook convention of the
  subject's grade (e.g. `]−2 ; +∞[`); keep the notation itself standard/LTR even in Arabic prose.
- Worked computations in explanations chain standard notation with `→` and end with the
  verification check: `2x = 8 → x = 4. تحقّق: 2(4) + 5 = 13 ✓`.

## Self-check before running QA

Scan every file you wrote for `[٠-٩]` (must be zero matches), for hyphens used as minus signs in
formulas, and for the letter `x` used as a multiplication sign. The `content-audit` skill performs
the same scan on existing content.
