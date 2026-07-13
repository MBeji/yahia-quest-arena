---
name: content-iq-training
description: >-
  Author IQ-test / cognitive-training exercises — no theory, no memorization, pure
  reasoning — for yahia-quest-arena's brain-training theme (muscle-cerveau). Generates
  VISUAL missions/quizzes using inline SVG figures
  (logic matrices, shape sequences, geometric/spatial puzzles) plus logical reasoning,
  mathematical reasoning, and fluid-intelligence problem solving. Use whenever the user
  wants "muscle ton cerveau" / anti-âge cérébral / anti-atrophie / test de QI /
  raisonnement logique / intelligence fluide / matrices visuelles / raisonnement spatial
  — e.g. "génère des tests de QI", "des matrices logiques visuelles", "exercices de
  raisonnement spatial". Every item is solvable by deduction, never by recall. Defers to
  the content-engine skill for schema, SVG figures, quality bar, rewards, and validation.
---

# content-iq-training — cognitive training (IQ-style), visual, no theory, no recall

This skill trains the **capacity to reason**, not the **stock of knowledge**. That distinction is the
whole point: a culture-générale quiz tests what you _remember_; this tests what you can _deduce_. If an
item can be answered by recalling a fact, a date, a definition, a name, or a memorized formula, it does
**not** belong here — rewrite it so the answer must be _worked out_ from the item itself.

First read the content-engine skill and its references (`.claude/skills/content-engine/`), **especially
`references/content-schema.md` → "Figures (inline SVG) in questions"** and `references/rewards-and-modes.md`
(difficulty ladder + ⭐ indicators). This skill only adds the IQ-specific rules below.

## Mapping

- **Theme**: `muscle-cerveau`. `gradeSlug: null` (non-school).
- **Native per language** (see content-engine): produce one sibling subject per requested language
  (`-fr`/`-en`/`-ar`). IQ figures are **language-neutral** (shapes/numbers) and can be reused across
  languages; only the short instruction text and the explanation are authored natively in each language.
- Organize by domain: `logique`, `maths-raisonnement`, `intelligence-fluide`, `geometrie-spatial`.

## The three non-negotiable rules

1. **No theory / no chapters of lessons.** The schema still requires a chapter shell, so make
   `cours.md` and `resume.md` a **one-line consigne**, never a lesson — e.g. cours.md:
   `# 🧠 Entraînement — aucune leçon. Observe, déduis la règle, applique-la.` and resume.md a single
   reminder line. All the value is in the quiz + exercises (the missions). Do **not** teach a method or
   explain theory in cours.md.
2. **No memorization.** Forbidden: trivia, vocabulary, capitals, dates, "recall the formula/theorem",
   anything answerable from stored knowledge. Required: the answer is **derivable purely by deduction**
   from the figure/sequence/relations given in the item.
3. **Visual-first.** Most items carry an **inline SVG figure** (per content-schema.md): matrices,
   shape/number-in-shape sequences, rotations/reflections, odd-one-out, analogies, paper-folding,
   spatial nets. For shape/matrix items the **answer options are themselves SVG figures** (one `<svg>`
   per option, no text). Pure-text reasoning (number/letter sequences, syllogisms, word problems) is
   fine when a figure adds nothing — but reach for a figure whenever the reasoning is spatial/visual.

## Domains & item types

- **Raisonnement logique**: matrices (Raven-style: 3×3 grid, one missing cell → pick the completing
  figure), sequences (what comes next), analogies (A is to B as C is to ?), odd-one-out, conditional
  deduction / syllogisms.
- **Mathématiques (raisonnement, pas rappel)**: number sequences with a hidden rule, numeric/symbolic
  analogies, novel relation puzzles, magic-square / arithmetic-grid logic, ratio/proportion reasoning
  — never "apply the memorized formula".
- **Intelligence fluide**: novel problems with no taught method — pattern induction, rule discovery,
  transformation chains, set/logic puzzles.
- **Géométrie & raisonnement spatial**: rotations, reflections (mirror), counting hidden cubes/faces,
  2D→3D nets (which net folds into the solid), assembling/superimposing shapes, symmetry.

## Quality bar (IQ-specific)

- **Exactly one defensible answer**, derivable from the item ALONE. Avoid ambiguous "aha" riddles where
  several answers are arguable — for every item, be able to state the single rule that yields the key.
- **Distractors = specific reasoning slips**: the off-by-one in the sequence, the wrong rotation
  direction, the missed reflection, the rule applied to the wrong attribute (colour vs shape vs count),
  the inverted condition. Each wrong option should be what a particular flawed deduction produces.
- **Enriching correction = explain the REASONING, not a fact** (this is the non-academic enrichment rule
  applied to IQ): state the hidden rule/pattern, show the deduction step by step (with a `✓`), and name
  why each tempting wrong option fails. Even a missed item must teach a transferable reasoning move.
- **Difficulty ladder + ⭐** as usual: quiz ⭐ (warm-up reasoning, d1–2) · `01-pratique` ⭐ (d1) ·
  `02-defi-logique` ⚔️ ⭐⭐⭐ (boss, d3) · optional `03-...` ⭐⭐ (d2) · `04-elite-qi` 👑 ⭐⭐⭐⭐
  (challenge, d4). Keep free progression at d1–2 (d3–4 are the premium-gate ceiling — dormant in
  the current free phase, so nothing is actually gated today; see CLAUDE.md "Access gate"). 6 items
  per exercise, 4 options.

## Figures — how to build them

Follow content-schema.md "Figures (inline SVG)": one self-contained `<svg viewBox="…">` per field,
drawing primitives only (no script/style/foreignObject/href/image/use). Keep them compact and legible
(≈`0 0 100 100`, **always a `viewBox`, no width/height — the renderer sizes them**), readable at ~64px
(options) / ~256px (prompt). **Figures render on a white "paper" surface, so ink them dark**
(`currentColor` or dark hues like `#1f2937`/`#222`); never use white/near-white as the primary mark, or
it vanishes on the white background. For a matrix, draw the 3×3 grid with a clearly empty cell (a "?");
make each option a small standalone `<svg>`.
Numbers inside figures and in number-sequence items use **Western digits (0–9) in all languages,
including Arabic** (`content-engine/references/math-and-notation.md`) — this also keeps figures
reusable across the three sibling subjects.

## Then validate and stop

`npm run content:check` → `npm run content:qa:strict` → report (theme/subject(s), domains, item counts,
how many are visual, QA results, the build/apply/PR steps). Files only; don't build/apply or push unless asked.
