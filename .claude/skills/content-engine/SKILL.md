---
name: content-engine
description: >-
  Shared core for authoring high-quality, gamified learning content in
  yahia-quest-arena's content/ pipeline (subjects, chapters, courses, summaries,
  quizzes, QCM exercises). Use whenever generating or scaffolding educational
  content — quizzes, exercises, missions, lessons — or when a program-specific
  content skill (content-ecole-tn, content-culture-generale, content-muscle-cerveau,
  content-langue-anglais/francais/arabe) or a professor overlay skill (prof-* — hard/elite
  exercises per matière × niveau) defers here for the schema, quality bar, reward rules, RPG
  style, and validation workflow. Trigger on any request to create or edit files under content/,
  write QCM questions, cours.md, resume.md, or quiz.json, or add a new subject/chapter. See
  references/generation-pipeline.md for the skill-selection map. Produces versioned files only — never SQL.
---

# Content engine — author content for the `content/` pipeline

This is the **shared core** every content-generation skill builds on. Content is the product's
business value: the breadth and quality of the quizzes/exercises is what differentiates the
portal. Treat every chapter you author as a flagship example, not filler.

## Which content skill? (router)

These skills all defer here for schema/quality/rewards/style. Pick the **most specific** one; run only one.

| You want…                                                                               | Skill                                     |
| --------------------------------------------------------------------------------------- | ----------------------------------------- |
| School-program content (Tunisian grade × subject, faithful to the CNP) — monolingual    | `content-ecole-tn`                        |
| Course/summary text **only** (`cours.md`/`resume.md`), no quiz/exercises                | `content-cours`                           |
| Audit/fix **existing** content (re-solve keys, grade courses) — report-first            | `content-audit`                           |
| Culture générale (history/geo/economy/politics) — trilingual = 3 sibling subjects       | `content-culture-generale`                |
| Brain-training **with lessons/theory** (logic/reasoning) — trilingual                   | `content-muscle-cerveau`                  |
| Pure visual IQ — SVG figures, **no theory**, deduction only                             | `content-iq-training`                     |
| Learn a language by immersion (grammar/vocab/reading, CEFR) — authored in that language | `content-langue-{anglais,francais,arabe}` |

Full new chapters go through a **program** skill above, not `content-cours`. `muscle-cerveau` teaches the
method (theory + recall); `iq-training` is pure visual deduction with no course — don't confuse the two.
To see what already exists before creating a subject, check `content/CATALOGUE.md` (`npm run content:catalogue`).

> **Start at the pipeline map for the full picture.** `references/generation-pipeline.md` is the single map of the whole
> generation system: the **three layers** — the planning layer (`curriculum-architect`: coverage,
> objectives, prioritized backlog), the base skills (this core + the program wrappers
> `content-ecole-tn`, `content-culture-generale`, `content-muscle-cerveau`, `content-iq-training`,
> `content-langue-*`, plus `content-cours`/`content-interactif`/`content-audit`) that **build &
> complete** a chapter, and the **professor overlay** (`prof-*`) that **raises the ceiling** with
> hard d3–4 exercises for a given matière × niveau — the skill-selection map (task → skill), the
> roles→skills matrix, the cumulative/non-redundant rules, and the reproducible build→migration
> procedure. Read it first; it prevents overlap and duplicate work.

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
- **Subject display name is native — and so is every chapter title.** `subject.json` `nameFr` is the
  subject's display name **in its own `contentLanguage`** (ar → `الرياضيات`, en → `English`, fr →
  `Français`) — never French for an ar/en subject; the field name is legacy (DB compat), the value is
  native. Each `chapter.json` `title` is likewise in the subject's language. No `(FR)`/`(EN)`/`(AR)`
  suffix on trilingual siblings. **Self-check:** for an `ar` subject, `nameFr` and every chapter
  `title` must contain Arabic letters (`[؀-ۿ]`) — only digits/notation stay Latin. See
  `references/content-schema.md`.
- **Indicate difficulty on every mission and quiz.** Each exercise (mission) and the quiz must show
  its difficulty level in its title, using the standard scale in `references/rewards-and-modes.md`.
- **Numbers & equations are standard in every language.** Western digits (0–9) and standard LTR
  mathematical notation everywhere — **including Arabic content** (Arabic prose around standard
  math, never Arabic-Indic digits or arabized formulas). Hard rule: `references/math-and-notation.md`.
- **Illustrate what is spatial/visual — in the COURSE and in the QUESTIONS, at every grade.**
  Geometry, circle & angles, repère & vecteurs, solids, trigonometry, measurement of shapes, a
  curve/graph to read, science diagrams, timelines: the **course** carries a figure next to each
  spatial rule (`::: figure <légende>` + inline `<svg viewBox="…">`), and every **question** whose
  notion is spatial/visual carries an inline `<svg>` too — reading the figure is the skill. Three
  invariants both sides share: illustrate **only where it serves** (a pure computation gets no
  figure — decoration or spoiler), the figure must be **TRUE** (re-derive coordinates; a false
  figure makes a correct item unanswerable), and a question figure **never leaks the key**. Young
  grades (1ère–3ème, 6–8 ans) are the HIGHEST priority and illustrate almost everything, colourfully.
  One shared doctrine + copy-paste SVG templates: `references/course-figures.md`. Quality bars:
  `references/course-quality.md` **Axis 5** (courses) and `references/quality-bar.md` § "Illustrate
  what the question is about" (questions).

## What you do (and where you stop)

Per the agreed flow, content skills produce **files only** and hand off to the human for review.
Run, in order:

1. Gather inputs (theme, grade if school, subject, chapter, language — see each wrapper skill).
2. Scaffold and write the files (see Workflow below), following the schema, quality bar, and style.
3. **Self-verification pass** — re-solve every question blind, verify keys/explanations/key balance/
   notation per the protocol in `references/quality-bar.md` ("Self-verification protocol"). The
   automated checks below catch structure, not correctness — this pass is what guarantees quality.
4. `npm run content:check` — validates all authored content against Zod. Must pass (writes nothing).
5. `npm run content:qa:strict` — answer-key heuristics; must report **0 errors** (warnings are
   advisory but fix the easy ones).
6. **Stop and report** — or, when asked to ship a PR, regenerate the migration for the changed
   subject(s) **only**:

   ```bash
   npm run content:build -- --subject <subject-id>
   ```

   ⚠️ **Never run bare `npm run content:build`** — it regenerates **all ~60 subjects** with a fresh
   timestamp, creating dozens of stray `*_generated_<id>_content.sql` duplicates for unchanged
   subjects. Scope with `--subject <id>` so exactly one migration is produced (run once per changed
   subject). The default fresh timestamp sorts after existing migrations (correct); pass
   `--timestamp <YYYYMMDDHHMMSS>` only when you need a deterministic value that still sorts **after**
   the newest existing migration. If a stray full build happened, `git clean -f supabase/migrations/`
   then rebuild with `--subject`. Commit the generated migration **with** the `content/` files; it
   **auto-applies to prod on merge** via `db-migrate-prod.yml` (never apply by hand, never hand-edit
   the SQL). Full procedure: `references/generation-pipeline.md`. Do **not** push unless explicitly asked.

Never weaken the gate to make content "pass" (no lowering thresholds, no skipping QA).

## Workflow for one chapter

A chapter directory `content/<subject>/NN-<slug>/` requires all of: `chapter.json`, `cours.md`
(non-empty), `resume.md` (non-empty), `quiz.json` (the mandatory gate), and optionally `exercices/`.

1. **Subject** — if new, write `content/<subject>/subject.json` (see `references/content-schema.md`
   for fields; `references/themes-and-trilingual.md` for `themeId`/`gradeSlug`/`contentLanguage`).
2. **Course** — `cours.md`: the full lesson, in the subject's one language, in the RPG style of
   `references/style-guide.md` (~50–75 lines). **`resume.md`**: a tight bullet summary mirroring it.
   The app renders the bold, centered chapter marker («الفصل N» / «Chapitre N» / «Chapter N»,
   auto-numbered) — so the `# H1` and `chapter.json` `title` carry the chapter's epic title only,
   never a hand-written "Chapitre N" (see `references/style-guide.md`).
3. **Quiz** — `quiz.json`: the comprehension gate. **5 questions** (3–10 allowed), 4 options
   (`a`–`d`), difficulty 1–2, short explanations. For **school-program** subjects, students must pass
   at **≥80%** to unlock the chapter's exercises; **non-school themes don't gate** (the quiz is an
   optional warm-up there).
4. **Exercises** — `exercices/NN-<slug>.json`. The **canonical exercise ladder** (file → mode /
   difficulty / reward, with the default **and** language-track variants) lives in
   `references/rewards-and-modes.md` — follow it, don't restate it. **6 questions each**, 4 options,
   ramping per-question difficulty; each title shows its ⭐ difficulty (see also `references/style-guide.md`).
   **Slugs are identity** — add files at the next free `NN`; never renumber/rename/reorder existing
   ones (re-keys the UUID = delete+recreate).
5. **Quality** — every question must clear the bar in `references/quality-bar.md` before you run the
   checks (real distractors, explanation ≥25 chars that justifies the key and why wrong options fail),
   then run the self-verification protocol (same file) before the automated checks.

## Partial deliverables (course only, quiz only, exercises by difficulty)

Not every request is a full chapter. Handle partial asks **inside an existing chapter** without
re-keying anything:

- **Course/summary only** — the specialized **`content-cours`** skill owns this (quality bar:
  `references/course-quality.md`); it (re)writes `cours.md` + `resume.md` in place without touching
  quiz/exercises, and reports if the quiz needs adjusting after a scope change.
- **Quiz only** — (re)write `quiz.json`; it must be answerable from `cours.md` alone (it gates
  comprehension of the course, not of the exercises).
- **Add exercises at a given difficulty** — add new `exercices/NN-<slug>.json` files at the **next
  free `NN`/`displayOrder`** with the canonical mode/reward combo for that difficulty
  (`rewards-and-modes.md`). **Never renumber or rename existing exercise files** (slug = identity →
  delete+recreate), and never duplicate questions already covered in the chapter's other exercises.
- **Audit/fix existing content** — that's the dedicated **`content-audit`** skill (verification
  pass + severity-ranked report; fixes only on request).

Whatever the slice, the same gates apply: quality bar → self-verification → `content:check` →
`content:qa:strict` → stop and report.

## Reference files — read before writing

- `references/generation-pipeline.md` — **the map of the whole system**: base vs professor skills,
  the task→skill selection matrix, the cumulative/non-redundant rules, and the reproducible
  build→migration procedure (incl. the `--subject` trap). **Read first.**
- `references/content-schema.md` — exact file shapes + every Zod constraint + file layout + reserved
  `quiz` slug. **Read before writing any file.**
- `references/expert-exercises.md` — the professor-grade bar for hard **d3–4** exercises (archetypes,
  executed-error distractors, double-solve verification); the `prof-*` skills build on it.
- `references/interactive-formats.md` — the **interactive/innovative format catalogue** (cloze,
  chasse à l'erreur, appariement, remise en ordre, QCM visuel SVG, document, histoire-problème,
  vrai/faux motivé, sprint chrono) encodable in today's QCM engine, plus the renderer contract and
  anti-patterns; the `content-interactif` skill instantiates it. Native input types are Tier B
  (spec: `docs/interactive-question-types.md`) — **`numeric`, `ordering`, `matching` and
  `multi` all shipped and are authorable** (shapes in `references/content-schema.md`).
- `references/quality-bar.md` — the QA gates (Zod hard-fails + `content:qa` heuristics), the
  pedagogical bar, question craft, and the self-verification protocol. Read before writing questions.
- `references/math-and-notation.md` — **hard rule**: Western digits + standard LTR equations/units
  in all languages, including Arabic. Read before writing any math/science or number-bearing content.
- `references/course-quality.md` — the lesson-text bar (clarté, compréhension, exhaustivité,
  expérience pédagogique) for `cours.md`/`resume.md`, incl. the golden rule (every tested notion
  must be taught). Read before writing any course or summary.
- `references/style-guide.md` — the gamified RPG/manga voice, `cours.md`/`resume.md` skeletons,
  per-language tone, and the rule that prompts/options/explanations stay clean and emoji-free.
- `references/rewards-and-modes.md` — modes, difficulty tiers, the (dormant) premium gate, the
  canonical reward table, and the auto-generated quiz rewards.
- `references/themes-and-trilingual.md` — the seven themes, the school grade ladder, and how to
  model a trilingual program as three sibling subjects.
- `references/language-track.md` — extra guidance for the language-learning themes
  (anglais/francais/arabe), used by the `content-langue-*` wrappers.

## Sourcing (hybrid)

Generate from model knowledge first, then verify and enrich facts with web search/fetch, recording
the URLs/references you used in each `chapter.json` `sources[]` (traceability). Be especially careful
with factual claims in culture-générale and with fidelity to the official syllabus in `content-ecole-tn`
— for school content the authoritative scope is the **national CNP program**, captured as the downloaded
CNP corpus (student manuels + teacher guides) indexed under
`content-ecole-tn/references/programmes-officiels/` (see that folder's README; the school-specific Taybah
files there are a secondary cross-check), so defer to `content-ecole-tn` for school work.

**Source-combination rule (whenever a unit has more than one authoritative source).** Use **all**
available sources, combined — a single available source is the reference; **several ⇒ combine them all**,
never drop one. The instantiation that matters most is school content: the official CNP sources are the
**teacher guide** (program: scope/progression/bornes) **and** the **manuel élève** (student textbook:
lessons, examples, exercises, depth) — the manuel élève is an **indispensable complement**, not optional,
at every grade. On a scope divergence the higher-authority source wins (for `ecole-tn`, the teacher
guide). The mechanics live in `content-ecole-tn` and its `programmes-officiels/` README — defer there for
school work; this is the shared principle every program skill follows when its track has multiple sources.

## Report format

When done, report: the subject(s)/chapter(s)/files created, languages produced, question counts,
the `content:check` + `content:qa:strict` results (paste the summary line), any QA warnings left and
why, and the exact build/apply/PR steps the human should run next.
