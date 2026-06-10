---
name: content-langue-arabe
description: >-
  Author Arabic-language-learning content for the "arabe" theme — courses, summaries,
  quizzes, and QCM exercises authored in Arabic (immersion, RTL): نحو، صرف، إملاء،
  مفردات، قراءة، أخطاء شائعة (grammar, morphology, spelling, vocabulary, reading,
  common mistakes), by level. Use whenever the user wants Arabic-learning content /
  "améliore ton arabe" / Arabic grammar (nahw), morphology (sarf), or vocab exercises
  — e.g. "تمارين في النحو", "quiz de vocabulaire arabe", "leçon sur الإعراب". Note:
  this is the standalone language track (theme arabe), distinct from school Arabic
  (content-ecole-tn). Defers to the content-engine skill (esp. references/language-track.md).
---

# content-langue-arabe — Arabic learning track

Authors content under the `arabe` theme, `contentLanguage: "ar"`, `gradeSlug: null`. The content is
written **in Arabic** (immersion, RTL). This is the standalone "améliore ton arabe" track — distinct
from the school program's Arabic subject (use `content-ecole-tn` for that). Read the content-engine
skill and especially `content-engine/references/language-track.md` before writing.

## Specifics

- **Theme/subjects**: `themeId: "arabe"`, `contentLanguage: "ar"`, `gradeSlug: null`. Follow the
  two-axis model in `content-engine/references/language-track.md`: **one subject per level** —
  `arabe-a1` (مبتدئ), `arabe-a2`, `arabe-b1`, `arabe-b2`, `arabe-c1` (CEFR-style ascending bands) —
  sequenced by `displayOrder`, **plus one dedicated `arabe-donjon`** subject (the whole-theme mixed
  gauntlet, تحدٍّ شامل). Build levels bottom-up. `nameFr` is the French catalogue label; the content
  is Arabic. Leave `isPremium` off (free `libre` parcours; premium is per parcours).
- **Chapters**: one competence each (نحو / صرف / إملاء / مفردات / قراءة), ordered simplest→most complex
  within the level (~5 per level). cours.md teaches the rule with many italicized example sentences and
  a forms table; quiz.json (5 Q); exercises drill it via the ascending ladder (see language-track.md).
  Use Arabic punctuation (، ؛) and full إعراب in grammar explanations (محلّ، علامة، نيابة).
- **Question types**: gap-fill (الفراغ), pick the correct إعراب/form, spot-the-error / الدخيل
  (use "find the error/intruder" prompts — they exempt the contradiction QA check), choose the right
  meaning, identify the function (موقع الكلمة).
- **Distractors = real interference errors** (confusing الكسرة vs الياء, wrong case ending, wrong
  derived form). Explanations name the rule and why distractors fail (≥25 chars).

## Sourcing

Hybrid: generate from model knowledge, verify grammar/usage via web search against reputable Arabic
references, cite in `chapter.json` `sources[]`.

## Then validate and stop

`npm run content:check` → `npm run content:qa:strict` → report (subject(s)/chapter(s), level, counts,
QA results, build/apply/PR steps). Don't build/apply or push unless asked.
