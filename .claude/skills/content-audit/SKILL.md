---
name: content-audit
description: >-
  Pedagogical audit of EXISTING content under content/ — verify answer keys by
  re-solving every question, check distractor quality, explanation correctness,
  difficulty calibration, answer-key balance, duplicates, standard math/digit
  notation (Western digits everywhere, including Arabic), language purity, and
  factual accuracy. Produces a severity-ranked report; applies fixes only on
  request. Use whenever the user asks to "auditer", "vérifier", "review", "QA"
  the pedagogical content, a subject, a chapter, or the quizzes/exercises — e.g.
  "audite le contenu de maths 9ème", "vérifie les quiz de culture générale",
  "y a-t-il des erreurs dans les corrigés ?". Defers to the content-engine skill
  for the schema, quality bar, and notation rules.
---

# content-audit — pedagogical verification of existing content

The automated gates (`content:check`, `content:qa:strict`) catch **structure**, not **correctness**:
a question with a wrong answer key, a misleading explanation, or an off-syllabus notion passes them
all. This skill is the deep net — a human-grade review of content that already exists under
`content/`, applying the same bar the authoring skills must meet
(`content-engine/references/quality-bar.md` and `references/math-and-notation.md` — read both first).

## Inputs

- **Scope**: a subject (`content/<subject>/`), a chapter, a theme's subjects, or the whole catalogue.
  Large scopes: fan out one sub-agent per subject and consolidate.
- **Mode**: **report-only** (default) or **report + fix** (only when the user explicitly asks for
  fixes).

## The audit checklist (per question, per exercise, per chapter)

Work file by file. For every question:

1. **Re-solve it blind** — derive the answer without looking at `correctOption`, then compare.
   A mismatch is a **[BLOCKER]**: determine whether the key or your derivation is wrong (web-verify
   if factual) before flagging.
2. **Explanation vs key** — the explanation must assert the keyed option, restate the computed
   value for numeric answers, and never validate a distractor. Contradiction = **[BLOCKER]**;
   thin/non-teaching explanation (no rule, no method, no trap named on d3–4) = **[MAJOR]**.
3. **Distractor quality** — each wrong option should encode a specific misconception/reasoning
   slip; filler or absurd options = **[MAJOR]**; overlapping/synonymous options = **[MAJOR]**.
4. **Question craft** — meta-options ("all of the above"…), un-emphasized negative stems,
   correct-answer-is-longest giveaways, ambiguous stems with two defensible answers
   (= **[BLOCKER]**), unsorted numeric options = **[MINOR]** unless they leak the key.
5. **Notation** — scan for Arabic-Indic digits `[٠-٩]` (must be zero — **[MAJOR]**), hyphen-as-minus
   in formulas, letter `x` as multiplication sign, non-SI units, LaTeX delimiters inside question
   strings (**[MINOR]**). In `ar` content, a **plain space between digit groups** (`\d \d{3}`
   outside `<svg>`) = **[MAJOR]**: the bidi algorithm swaps the groups at render time (`38 461`
   displays as `461 38`) — it must be a NO-BREAK SPACE U+00A0. Audit the **rendered** form, not
   just the source: any RTL string mixing digit runs with neutral separators is suspect. Standard
   digits/equations apply in **all** languages including Arabic.
6. **Language purity** — content not in the subject's `contentLanguage` (beyond math symbols,
   slugs, `mode`, URLs) = **[MAJOR]**.
7. **Factual accuracy** — for culture-générale/sciences/history claims, spot-check non-trivial
   facts via web search; wrong fact = **[BLOCKER]**, missing `sources[]` for verified claims =
   **[MINOR]**. For `ecole-tn`, also check **syllabus fidelity**: off-program or wrong-grade
   notions = **[MAJOR]**.

Per exercise / chapter:

8. **Answer-key balance** — tally `correctOption` letters; one letter > ~40% of an exercise =
   **[MINOR]**, a constant letter = **[MAJOR]**.
9. **Duplicates** — same fact/computation re-asked with cosmetic changes, within or across the
   chapter's quiz + exercises = **[MAJOR]**.
10. **Difficulty calibration** — per-question difficulty honest and non-decreasing within the
    exercise; exercise `difficulty`/`mode`/rewards match the canonical table in
    `rewards-and-modes.md`; quiz stays d1–2; titles carry the ⭐ indicator = **[MINOR]** each.
11. **Course/quiz coherence** — the quiz is answerable from `cours.md` alone; `resume.md` mirrors
    the course; SVG figures are self-contained and unambiguous.

Also run `npm run content:check` and `npm run content:qa` over the scope and fold their findings in
(they're fast and catch regressions in files you didn't open).

## Report format (the deliverable)

A severity-ranked report, per subject/chapter:

- **[BLOCKER]** wrong key, contradicting explanation, factually false, ambiguous double-answer —
  with file path, question locator (e.g. `exercices/02-boss.json q4`), the defect, and the proposed
  correction.
- **[MAJOR]** weak distractors, non-teaching explanations, notation violations, duplicates,
  off-syllabus, language impurity.
- **[MINOR]** key balance, ordering, ⭐ titles, thin sources.
- A summary table: questions audited / blockers / majors / minors per chapter, plus an overall
  verdict (ship / fix-first).

## Fix mode (only on explicit request)

- Edit the content **files** only — never generated SQL, never the schema/scripts.
- **Preserve identity**: never rename subject ids, chapter folders, or exercise filenames, and
  never reorder questions across difficulty tags (UUIDs are keyed on slugs + emission order).
  Fixing text/options/keys/explanations in place is safe.
- Don't just flip a wrong key — make the explanation, distractors, and key coherent as a set.
- After fixes: re-run the audit pass on the touched files, then `npm run content:check` +
  `npm run content:qa:strict` (0 errors), then **stop and report** (build/apply/PR steps are the
  human's, per content-engine).
