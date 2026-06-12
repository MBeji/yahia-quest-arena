# Course & summary quality — the bar for `cours.md` and `resume.md`

The questions have their bar (`quality-bar.md`); this is the equivalent for the **lesson text**.
A chapter's course is what the student reads _before_ being tested — if it is unclear, incomplete,
or unteachable, every downstream question becomes unfair. Both the authoring skill
(`content-cours`) and the audit skill (`content-audit`) grade against the four axes below.
`style-guide.md` gives the skeleton/voice; this file defines **what makes the content good**.

## Axis 1 — Clarté (clarity)

- **One notion per section.** Each `##` section introduces exactly one new concept. If a section
  teaches two rules, split it.
- **Define before use.** Every technical term is defined in the content language at first
  occurrence, using the **official program's terminology** for that grade (never a synonym the
  textbook doesn't use).
- **Short sentences, active voice.** Target ≤ 20 words per sentence in explanatory prose;
  one idea per sentence. Vocabulary calibrated to the grade (a 6ème course reads simpler than Bac).
- **Formulas isolated.** Display formulas on their own line (`$$ … $$`); never bury a formula
  mid-sentence. Notation per `math-and-notation.md` (standard digits/LTR everywhere, U+00A0 in
  Arabic grouped numbers).
- **Tables for structure.** Any classification/taxonomy/conjugation with ≥3 cases becomes a
  markdown table, not a paragraph.

## Axis 2 — Facilité de compréhension (ease of understanding)

- **Concrete before abstract.** Open each notion with a concrete example or familiar situation,
  _then_ state the general rule — not the reverse.
- **Every rule has a worked example.** No rule without at least one example computed/applied
  step by step right next to it (the «مثال محسوب» / «exemple détaillé» pattern). A rule without
  an example is considered not taught.
- **Progression simple → complexe.** Sections ordered so each builds only on what precedes;
  introduce at most **one** new notion per section (cognitive load).
- **Anchor to prior knowledge.** Open by connecting to what the student already masters
  («tu sais déjà… / أنت تعرف…»), especially the previous chapter/grade.
- **Name the traps where they arise.** Each classic mistake gets a `> ⚠️` callout at the point
  of the course where the confusion is born — the same traps the exercises' distractors encode.

## Axis 3 — Exhaustivité (completeness)

- **Golden rule — no orphan tested notion:** everything the chapter's `quiz.json` and
  `exercices/*.json` assess MUST be teachable from `cours.md` alone. Before finishing, list every
  notion the items test and point to the section that teaches it. A tested-but-untaught notion is
  a **[MAJOR]** audit finding (it makes questions unfair).
- **Full official scope, nothing more.** Cover all the notions of the official chapter for the
  grade (school content — see `content-ecole-tn`), and no off-program material. For non-school
  themes, cover the scope announced by `chapter.json`'s description.
- **Edge cases included.** The boundary/degenerate cases the exercises like to probe (zero,
  equality case, no-solution case, carry in rounding…) are stated in the course, not discovered
  in a correction.
- **Resume ↔ course bijection.** `resume.md` has one bullet per course section (same order),
  each = **bolded concept + one-line essence**. No section unmirrored, no bullet inventing
  material absent from the course.

## Axis 4 — Expérience pédagogique (learning experience)

- **The style-guide skeleton is the vehicle**: epic title + epigraph that motivates ("why this
  matters"), 5–7 emoji-led sections, mid-course `> 🗡️` tips and `> ⚠️` traps, closing `> 🏆`
  that frames the chapter as cleared and teases the next.
- **Motivate before teaching**: the epigraph/intro answers «à quoi ça sert ?» in one punchy line
  (real use, exam stake, or power gained).
- **Right length**: ~50–75 lines for `cours.md` (a 10-minute read), ~7–10 bullets for
  `resume.md`. Longer = split the chapter; shorter = scope is probably uncovered.
- **The summary is a standalone revision tool**: a student re-reading only `resume.md` the night
  before recovers every key rule/formula of the chapter. If a bullet is too vague to revise from,
  it fails.
- **Language purity & RTL**: entirely in the subject's `contentLanguage` (per `quality-bar.md`),
  Arabic prose around standard math, fluent and idiomatic — never translated-sounding.

## Audit grading (used by content-audit)

Map findings to the standard severities:

- **[BLOCKER]** — factually false statement or rule; course contradicts the answer keys of its
  own quiz/exercises; formula or worked example with a wrong result.
- **[MAJOR]** — tested-but-untaught notion (golden rule); rule without a worked example;
  off-program/wrong-grade notion (school); section incomprehensible at grade level; resume bullet
  missing for a section or inventing new material; notation violations (Arabic-Indic digits,
  bidi-unsafe grouped numbers, arabized formulas); language impurity.
- **[MINOR]** — style-guide skeleton gaps (missing epigraph/callouts/closing); sentence-length /
  jargon issues; length out of range; weak motivation; table opportunity missed; resume order
  drift.

Verdict per chapter: **ship** (no blocker, ≤1 major) or **fix-first**. Report per axis: one line
each for clarté / compréhension / exhaustivité / expérience with the findings that drove it.
