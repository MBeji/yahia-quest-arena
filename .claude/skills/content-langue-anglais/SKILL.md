---
name: content-langue-anglais
description: >-
  Author English-language-learning content for the "anglais" theme — courses,
  summaries, quizzes, and QCM exercises authored in English (immersion): grammar,
  vocabulary, tenses, reading comprehension, common mistakes, by CEFR level (A1–C2).
  Use whenever the user wants English-learning content / "améliore ton anglais" /
  English grammar or vocab exercises — e.g. "exercices d'anglais sur le present
  perfect", "quiz de vocabulaire anglais A2", "leçon d'anglais sur les phrasal verbs".
  Defers to the content-engine skill (esp. references/language-track.md) for schema,
  quality bar, rewards, style, and validation.
---

# content-langue-anglais — English learning track

Authors content under the `anglais` theme, `contentLanguage: "en"`, `gradeSlug: null`. The content is
written **in English** (immersion). Read the content-engine skill and especially
`content-engine/references/language-track.md` before writing.

## Specifics

- **Theme/subjects**: `themeId: "anglais"`. Use level/strand subjects with suffixed ids, e.g.
  `anglais-a1`, `anglais-a2`, `anglais-grammar`, `anglais-vocab`; sequence with `displayOrder`.
  `nameFr` labels them in French for the catalogue; the content is English. Leave `isPremium` off —
  premium is decided **per parcours**, not by this legacy subject flag, and `anglais` is a free
  `libre` parcours today.
- **Chapters**: one grammar point / tense / vocabulary field / reading skill each. cours.md teaches
  the rule with many example sentences and a forms/conjugation table; quiz.json (5 Q) checks the core
  rule; exercises drill it.
- **Question types that fit**: fill-in-the-gap, pick the correct form/tense, spot-the-error
  (use "find the error" prompts — they exempt the contradiction QA check), choose the right
  translation/meaning, identify the function.
- **Distractors = real interference errors** (false friends, wrong tense/agreement, common L1
  mistakes). Explanations name the rule and why distractors are wrong (≥25 chars).

## Sourcing

Hybrid: generate from model knowledge, verify grammar/usage/idioms and CEFR-level alignment via web
search, cite references in `chapter.json` `sources[]`.

## Then validate and stop

`npm run content:check` → `npm run content:qa:strict` → report (subject(s)/chapter(s), level, counts,
QA results, build/apply/PR steps). Don't build/apply or push unless asked.
