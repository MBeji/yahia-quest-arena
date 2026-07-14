---
name: content-culture-generale
description: >-
  Author trilingual (FR + EN + AR) general-knowledge content for the culture-generale
  theme — courses, summaries, quizzes, and QCM exercises — organized by topic
  (histoire, géographie, politique, économie, sciences, arts, actualités, …) OR as
  varied multi-topic "dungeon" exercise sets. Use whenever the user wants culture
  générale / general-knowledge / trivia content — e.g. "fais un quiz de culture
  générale sur la géographie", "un donjon culture G multi-thèmes", "questions
  d'histoire en 3 langues". Always produces the three language versions. Defers to the
  content-engine skill for schema, quality bar, rewards, style, and validation.
---

# content-culture-generale — general knowledge, trilingual

General knowledge is offered in **all three languages** (FR, EN, AR) — trilingual applies here because
this is a **non-school** theme (school content is monolingual; see `content-ecole-tn`). Since content
is single-language per subject, that means **three sibling subjects** under the `culture-generale` theme — read
`content-engine/references/themes-and-trilingual.md`. Also read the rest of the content-engine skill
(schema, quality bar, rewards, style) before writing.

## Two shapes

- **By topic** — a subject/chapter focused on one field: `histoire`, `geographie`, `politique`,
  `economie`, `sciences`, `arts`, `litterature`, `sport`, `actualites`, etc. Normal chapter structure.
- **Multi-topic "dungeon"** — a single exercise (typically `boss` or `challenge`) whose 6 questions
  span varied topics for a broad-knowledge gauntlet. Use a dungeon-flavored title and a mixed
  difficulty ramp. It still lives inside a chapter with the required cours/resume/quiz.

## Multilingual workflow — native per language (no translation)

1. Produce one sibling subject per requested language, suffixing the id by language, all
   `themeId: "culture-generale"`, `gradeSlug: null`: `culture-generale-<topic>-fr`
   (`contentLanguage: "fr"`), `-en` (`"en"`), `-ar` (`"ar"`). Write each sibling's `nameFr` **in its
   own language** — `-fr` a French name, `-en` an English name, `-ar` an Arabic name (e.g. "Culture
   générale — Histoire" / "General Knowledge — History" / "الثقافة العامة — التاريخ"). No
   `(FR)`/`(EN)`/`(AR)` suffix — the different words/scripts already disambiguate the catalogue.
2. **Generate each language NATIVELY and independently** — author the content directly in that
   language (web-sourced, native phrasing, culturally idiomatic examples). **Do not translate** a base
   language; native generation reads more fluidly. The siblings share the same topic, scope, and
   difficulty ladder, but each is written fresh in its language (questions need not be word-for-word
   identical). Run them as independent native passes (e.g. one agent per language).
3. Follow the content-engine chapter workflow for each language: cours.md, resume.md, quiz.json (5 Q),
   exercises ladder (or the dungeon exercise).

## Quality & sourcing (hybrid — be careful with facts)

General-knowledge facts must be **correct and current**. Generate from model knowledge, then
**verify every non-trivial fact via web search** (dates, figures, capitals, records, "firsts"), and
record sources in each `chapter.json` `sources[]`. Distractors should be plausible near-misses
(a neighboring country, an adjacent year, a similar figure) — never absurd.

**Every correction is a mini-lesson (enrich the user).** Each explanation must give the correct
answer + why + **1–2 extra facts or context** that grow the user's general knowledge, and briefly why
the tempting wrong option is wrong — so that even a wrong answer leaves the user more cultured. Concise
(2–4 sentences), accurate, sourced. See `content-engine/references/quality-bar.md` → "Non-academic
content — every correction is a mini-lesson".

## Then validate and stop

`npm run content:check` → `npm run content:qa:strict` → report (the three subjects/chapters created,
topic(s), question counts per language, QA results, and the build/apply/PR steps). Don't build/apply
or push unless asked.
