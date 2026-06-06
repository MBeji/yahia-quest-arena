---
name: content-engine
description: >-
  Shared core for authoring high-quality, gamified learning content in
  yahia-quest-arena's content/ pipeline (subjects, chapters, courses, summaries,
  quizzes, QCM exercises). Use whenever generating or scaffolding educational
  content — quizzes, exercises, missions, lessons — or when a program-specific
  content skill (content-ecole-tn, content-culture-generale, content-muscle-cerveau,
  content-langue-anglais/francais/arabe) defers here for the schema, quality bar,
  reward rules, RPG style, and validation workflow. Trigger on any request to
  create or edit files under content/, write QCM questions, cours.md, resume.md,
  or quiz.json, or add a new subject/chapter. Produces versioned files only — never SQL.
---

# Content engine — author content for the `content/` pipeline

This is the **shared core** every content-generation skill builds on. Content is the product's
business value: the breadth and quality of the quizzes/exercises is what differentiates the
portal. Treat every chapter you author as a flagship example, not filler.

## How the pipeline works (the why behind the rules)

Pedagogical content lives as **versioned files** under `content/<subject>/NN-<slug>/`. A generator
(`scripts/content/build.ts` → `src/shared/content/`) validates them with Zod, then compiles them to
**idempotent** Supabase migrations. Row IDs are **deterministic UUIDv5** derived from slugs, so
rebuilding updates rows in place (no duplicates) and removed admin content is pruned — while
parent-authored content is never touched.

Consequences you must respect:

- **Author files, never SQL.** Hand-written SQL or hand-edited generated migrations break the
  deterministic-UUID model. You only ever write/extend files under `content/`.
- **Slugs are identity.** Renaming a subject `id`, a chapter folder, or an exercise filename, or
  reordering questions by difficulty, re-keys the UUIDs (delete+recreate, not update). Choose slugs
  once, deliberately.
- **One language per subject.** There is no per-record translation. **Non-school** themes are offered
  trilingual as three sibling subjects, **each generated natively in its language (not translated)**;
  **school** content (`ecole-tn`) is authored only in the subject's **official language of
  instruction** — never trilingual. See `references/themes-and-trilingual.md`.
- **Indicate difficulty on every mission and quiz.** Each exercise (mission) and the quiz must show
  its difficulty level in its title, using the standard scale in `references/rewards-and-modes.md`.

## What you do (and where you stop)

Per the agreed flow, content skills produce **files only** and hand off to the human for review.
Run, in order:

1. Gather inputs (theme, grade if school, subject, chapter, language — see each wrapper skill).
2. Scaffold and write the files (see Workflow below), following the schema, quality bar, and style.
3. `npm run content:check` — validates all authored content against Zod. Must pass (writes nothing).
4. `npm run content:qa:strict` — answer-key heuristics; must report **0 errors** (warnings are
   advisory but fix the easy ones).
5. **Stop. Report** what you created and the exact follow-up the human runs:
   `npm run content:build` → review the generated SQL in `supabase/migrations/` → apply the
   migration to the DB **before** deploying dependent code (the DB-before-deploy rule), then commit
   as a PR. Do **not** run `content:build`/apply or push unless explicitly asked.

Never weaken the gate to make content "pass" (no lowering thresholds, no skipping QA).

## Workflow for one chapter

A chapter directory `content/<subject>/NN-<slug>/` requires all of: `chapter.json`, `cours.md`
(non-empty), `resume.md` (non-empty), `quiz.json` (the mandatory gate), and optionally `exercices/`.

1. **Subject** — if new, write `content/<subject>/subject.json` (see `references/content-schema.md`
   for fields; `references/themes-and-trilingual.md` for `themeId`/`gradeSlug`/`contentLanguage`).
2. **Course** — `cours.md`: the full lesson, in the subject's one language, in the RPG style of
   `references/style-guide.md` (~50–75 lines). **`resume.md`**: a tight bullet summary mirroring it.
3. **Quiz** — `quiz.json`: the comprehension gate. **5 questions** (3–10 allowed), 4 options
   (`a`–`d`), difficulty 1–2, short explanations. Students must pass at **≥80%** to unlock exercises.
4. **Exercises** — `exercices/NN-<slug>.json`, the canonical ladder:
   `01-pratique` (practice, d1, 50/10) · `02-boss` (boss, d3, 120/30) · `03-revision`
   (practice, d2, 70/15, optional) · `04-defi` (challenge, d4, 300/60) · `05-*` (boss, d3, 120/30).
   **6 questions each**, 4 options, ramping per-question difficulty. Each exercise title shows its
   difficulty (⭐ scale) — see `references/rewards-and-modes.md` and `references/style-guide.md`.
5. **Quality** — every question must clear the bar in `references/quality-bar.md` before you run the
   checks (real distractors, explanation ≥25 chars that justifies the key and why wrong options fail).

## Reference files — read before writing

- `references/content-schema.md` — exact file shapes + every Zod constraint + file layout + reserved
  `quiz` slug. **Read before writing any file.**
- `references/quality-bar.md` — the QA gates (Zod hard-fails + `content:qa` heuristics) and the
  pedagogical bar each question must meet. Read before writing questions.
- `references/style-guide.md` — the gamified RPG/manga voice, `cours.md`/`resume.md` skeletons,
  per-language tone, and the rule that prompts/options/explanations stay clean and emoji-free.
- `references/rewards-and-modes.md` — modes, difficulty tiers, the premium gate, the canonical
  reward table, and the auto-generated quiz rewards.
- `references/themes-and-trilingual.md` — the seven themes, the school grade ladder, and how to
  model a trilingual program as three sibling subjects.
- `references/language-track.md` — extra guidance for the language-learning themes
  (anglais/francais/arabe), used by the `content-langue-*` wrappers.

## Sourcing (hybrid)

Generate from model knowledge first, then verify and enrich facts with web search/fetch, recording
the URLs/references you used in each `chapter.json` `sources[]` (traceability). Be especially careful
with factual claims in culture-générale and with fidelity to the official syllabus in `content-ecole-tn`.

## Report format

When done, report: the subject(s)/chapter(s)/files created, languages produced, question counts,
the `content:check` + `content:qa:strict` results (paste the summary line), any QA warnings left and
why, and the exact build/apply/PR steps the human should run next.
