---
name: content-muscle-cerveau
description: >-
  Author trilingual (FR + EN + AR) brain-training content for the muscle-cerveau theme
  — courses, summaries, quizzes, and QCM exercises on logic, memory, mental arithmetic,
  riddles, puzzles, lateral thinking, and reasoning. Use whenever the user wants
  brain-training / "muscler ton cerveau" / logic / mental-math / puzzle content — e.g.
  "des énigmes de logique", "exercices de calcul mental", "un quiz pour muscler le
  cerveau en 3 langues". Always produces the three language versions. Defers to the
  content-engine skill for schema, quality bar, rewards, style, and validation.
---

# content-muscle-cerveau — brain training, trilingual

Brain-training content offered in **all three languages** (FR, EN, AR) → **three sibling subjects**
under the `muscle-cerveau` theme (`gradeSlug: null`). Trilingual applies because this is a **non-school**
theme (school content is monolingual; see `content-ecole-tn`).

> For **pure IQ / visual reasoning** (logic matrices, spatial puzzles, SVG figures, no theory, no
> memorization), use the specialized **`content-iq-training`** skill instead.

Read `content-engine/references/themes-and-trilingual.md`
and the rest of the content-engine skill before writing.

## What to cover

Organize by cognitive skill: `logique` (sequences, syllogisms, deduction), `calcul-mental`,
`memoire`, `enigmes` (riddles), `pattern` (visual/number patterns), `raisonnement` (lateral thinking,
problem solving). Each chapter teaches a technique in cours.md (how to attack this class of problem),
then drills it.

## Designing good brain-training QCM

- Questions must be **solvable from the prompt alone**, with exactly one defensible answer — avoid
  ambiguous riddles where several answers are arguable.
- Distractors should be the **answers you get from a specific reasoning slip** (off-by-one in a
  sequence, an inverted condition, a miscount) — that's what makes it train the brain.
- Explanations show the **method/steps to reach the answer**, not just the answer — the teaching is
  the technique (≥25 chars; worked steps on hard items per quality-bar.md).
- Calibrate the difficulty ramp; keep free progression at difficulty 1–2, boss/challenge at 3–4.
- **Numbers and operations stay standard in all three languages** — Western digits (0–9) and
  standard notation in the Arabic version too (essential for calcul mental / sequences):
  `content-engine/references/math-and-notation.md`.

## Multilingual workflow — native per language (no translation)

Produce one sibling subject per language (id suffixed `-fr`/`-en`/`-ar`, `themeId: "muscle-cerveau"`,
`contentLanguage` matching; `nameFr` always French with a `(FR)`/`(EN)`/`(AR)` suffix). **Generate
each language natively** — author the puzzles directly in that language rather than translating. This
is essential here: word-play, anagrams, and mental-math phrasing only work when conceived natively.
The siblings share the same cognitive skills and difficulty ladder, but each is authored fresh in its
language (run independent native passes, e.g. one agent per language).

## Sourcing

Hybrid: most puzzles come from model generation; verify any factual/established puzzle or
classic-riddle answer via web search, and cite sources in `sources[]` when used.

## Then validate and stop

`npm run content:check` → `npm run content:qa:strict` → report (three subjects/chapters, skill(s)
covered, counts per language, QA results, build/apply/PR steps). Don't build/apply or push unless asked.
