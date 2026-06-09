# Language-track authoring (anglais / francais / arabe)

Used by the `content-langue-anglais`, `content-langue-francais`, and `content-langue-arabe` wrappers.
These themes teach a language as a skill, independent of any school grade.

## Mapping

- One theme per language: `anglais` (contentLanguage `en`), `francais` (`fr`), `arabe` (`ar`).
- The teaching/instruction language **is** the target language (immersion): an English-track subject
  is authored in English, a French track in French, an Arabic track in Arabic. `gradeSlug: null`.
- A single language theme can hold several subjects to model proficiency levels or strands — suffix
  the subject `id`, e.g. `anglais-a1`, `anglais-a2`, `anglais-grammar`, `anglais-vocab`. Use
  `displayOrder` to sequence them. `nameFr` still labels them in French for the catalogue.
- Premium access is now decided **per parcours**, not by the subject's `isPremium` flag (legacy). A
  language theme that maps to a premium parcours gates the **whole subject** behind a live parcours
  entitlement, but free users still get the **free preview** (the chapter comprehension quiz +
  difficulty-1 missions) via `resolve_exercise_access`. The standalone language tracks ship as **free**
  `libre` parcours today, so leave `isPremium` off.

## What a good language chapter contains

Organize chapters by a coherent skill or theme (a tense, a grammar point, a vocabulary field, reading
comprehension, common mistakes). For each:

- **cours.md**: the rule/pattern with plenty of example sentences (italicized), a small table for
  conjugations/forms, and the RPG framing in titles/callouts (per style-guide.md).
- **quiz.json** (5 Q): comprehension of the chapter's core rule, difficulty 1–2.
- **exercices**: the canonical ladder. Question types that work well for languages — fill-in-the-gap,
  pick the correct form, spot the error (use "find the error/intruder" prompts, which exempt the
  contradiction QA check), choose the right translation, identify the tense/function.

## Quality specifics for languages

- **Distractors = real interference errors**: a common false-friend, a wrong tense/agreement, a
  typical L1-interference mistake — not random words.
- **Explanations teach the rule**, not just "this is correct": name the grammar point and why the
  distractors are wrong. Keep ≥25 chars (quality-bar.md).
- Sentences and examples must be **natural and correct** in the target language; verify idioms and
  usage via web search when unsure and cite sources in `chapter.json`.
- Keep each subject strictly in its one language (the immersion language); only slugs/`mode`/URLs are
  exceptions.

## Hybrid sourcing

Generate from model knowledge, then verify grammar/usage/idioms and (for graded levels) align to a
recognized framework like CEFR (A1–C2) via web search; record references in `sources[]`.
