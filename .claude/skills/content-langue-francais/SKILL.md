---
name: content-langue-francais
description: >-
  Author French-language-learning content for the "francais" theme — courses,
  summaries, quizzes, and QCM exercises authored in French (immersion): grammaire,
  conjugaison, vocabulaire, orthographe, compréhension, fautes fréquentes, by CEFR
  level (A1–C2). Use whenever the user wants French-learning content / "améliore ton
  français" / French grammar, conjugation, or vocab exercises — e.g. "exercices de
  conjugaison au subjonctif", "quiz de vocabulaire français B1", "leçon sur l'accord
  du participe passé". Note: this is the standalone language track (theme francais),
  distinct from school French (content-ecole-tn). Defers to the content-engine skill
  (esp. references/language-track.md) for schema, quality bar, rewards, style, validation.
---

# content-langue-francais — French learning track

Authors content under the `francais` theme, `contentLanguage: "fr"`, `gradeSlug: null`. The content is
written **in French** (immersion). This is the standalone "améliore ton français" track — distinct
from the school program's French subject (use `content-ecole-tn` for that). The existing subject
`fr-mastery` already lives under this theme — extend it or add sibling subjects. The `francais` track
is a **free `libre` parcours** today; premium is decided per parcours, not by the legacy subject
`isPremium` flag. Read the content-engine skill and especially
`content-engine/references/language-track.md` before writing.

## Specifics

- **Theme/subjects**: `themeId: "francais"`. Level/strand subjects with suffixed ids, e.g.
  `francais-grammaire`, `francais-conjugaison`, `francais-vocab`, or `fr-mastery` (existing);
  sequence with `displayOrder`. Leave `isPremium` off — the `francais` parcours is free today, and
  premium is gated per parcours (not by this legacy flag).
- **Chapters**: one rule / tense / vocabulary field / comprehension skill each. cours.md teaches the
  rule with many example sentences and a conjugation/forms table; quiz.json (5 Q); exercises drill it.
- **Question types**: gap-fill, pick the correct form/agreement/conjugation, spot-the-error
  (use "find the error" prompts), choose the right meaning/synonym, identify the function.
- **Distractors = real interference errors** (homophone confusions like a/à, ses/ces, wrong
  agreement, wrong tense). Explanations name the rule and why distractors fail (≥25 chars).

## Sourcing

Hybrid: generate from model knowledge, verify usage/orthographe (e.g. against established references)
and CEFR alignment via web search, cite references in `chapter.json` `sources[]`.

## Then validate and stop

`npm run content:check` → `npm run content:qa:strict` → report (subject(s)/chapter(s), level, counts,
QA results, build/apply/PR steps). Don't build/apply or push unless asked.
