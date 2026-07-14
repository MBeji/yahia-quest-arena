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

- **Theme/subjects**: `themeId: "anglais"`, `contentLanguage: "en"`, `gradeSlug: null`. Follow the
  two-axis model in `content-engine/references/language-track.md`: **one subject per CEFR level, the
  full A1→C2 ladder** — `anglais-a1` (Débutant) … `anglais-c2` (Maîtrise), six subjects sequenced by
  `displayOrder` — **plus one dedicated `anglais-donjon`** subject (`01-donjon` opener + one
  `NN-gauntlet-{band}` chapter per level, `gauntlet-a2`…`gauntlet-c2`). This is the shipped reference
  English track — match its shape. Build levels bottom-up (finish A1 first). `nameFr` is the catalogue
  label **in English** (e.g. "English — Beginner (A1)"), like the content — the field name is legacy,
  not a French requirement. Leave `isPremium` off (`anglais` is a free `libre` parcours;
  premium is per parcours).
- **Chapters**: one competence each, ordered simplest→most complex within the level (**~5–8 per
  level**). Beyond grammar/tense chapters, **every level ships a vocabulary chapter** (everyday vocab,
  phrasal verbs, idioms, confusables, word-formation) **and a dedicated reading-comprehension chapter**
  (`…-reading` / `-reading-inference` / `-reading-critical` as the band rises). cours.md teaches the
  rule with many example sentences and a forms/conjugation table; quiz.json (5 Q) checks the core rule;
  exercises drill it via the ascending ladder (01-pratique → 02-revision → 03-boss → 04-defi → **05-drill**,
  the cumulative whole-chapter consolidation rung; see language-track.md).
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
