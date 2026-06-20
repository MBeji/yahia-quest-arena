---
name: content-cours
description: >-
  Author or rewrite course lessons (cours.md) and summaries (resume.md) for any
  chapter under content/ — specialized in lesson-text quality: clarity, ease of
  understanding, completeness (everything the quiz/exercises test must be taught),
  and learning experience. Use whenever the user wants to write, rewrite, improve,
  clarify, or complete a course or a summary — e.g. "réécris le cours du chapitre X",
  "le résumé n'est pas clair", "améliore la leçon", "le cours ne couvre pas tout",
  "rends ce chapitre plus pédagogique". Works for new chapters (course part) and
  existing ones (safe in-place rewrite). Defers to the content-engine skill —
  especially references/course-quality.md and references/style-guide.md.
---

# content-cours — specialized course & summary authoring

This skill owns the **lesson text**: `cours.md` and `resume.md`. The four quality axes are
defined in `content-engine/references/course-quality.md` (clarté, facilité de compréhension,
exhaustivité, expérience pédagogique) — **read it first**, along with
`references/style-guide.md` (skeleton/voice), `references/math-and-notation.md` (notation,
including the Arabic NBSP rule), and the program wrapper if school content (`content-ecole-tn`:
official scope + language of instruction).

## When it applies

- **New chapter**: write the course+summary as part of the full chapter workflow (the rest —
  quiz/exercises — follows content-engine).
- **Rewrite/improve an existing chapter's lesson**: clarity pass, completeness pass, or full
  rewrite. **Safe in-place**: `cours.md`/`resume.md` map to `chapters.lesson_content`/`summary`
  and carry no UUIDs of their own — rewriting them never re-keys anything. Never rename the
  chapter folder.
- **Summary only**: tighten `resume.md` to the bijection rule (one bullet per course section,
  standalone revision value).

## Workflow

1. **Establish the scope to cover.** School content: the official chapter scope from the **school
   program** — `content-ecole-tn/references/programmes-officiels/<école>/<gradeSlug>.md` for this
   grade+subject+trimester (authoritative; CNP only as fallback) — plus `chapter.json` sources. Non-school:
   `chapter.json` description. Then — critical — **read the chapter's `quiz.json` and every
   `exercices/*.json` FIRST** and extract the list of notions/edge cases they test: the course must teach
   all of them (golden rule, no orphan tested notion). If an item tests something genuinely off-scope, flag
   it in the report instead of silently teaching off-program material.
2. **Plan the sections**: 5–7 sections, one notion each, simple → complexe, each new notion
   anchored on the previous. Place the `> ⚠️` traps where the confusion is born (mirror the
   exercises' distractors).
3. **Write `cours.md`** per the style-guide skeleton and course-quality Axis 1–2: concrete
   example before each rule, a worked example for every rule, formulas displayed on their own
   line, tables for classifications, grade-calibrated sentences, ~50–75 lines.
4. **Write `resume.md`**: one bullet per section, same order, bolded concept + one-line essence,
   7–10 bullets, revisable standalone.
5. **Self-verification (before the checks)** — walk course-quality's four axes; verify the
   tested-notions list from step 1 is fully covered (cite section per notion); verify
   resume ↔ course bijection; run the notation scans (`[٠-٩]`, `\d \d{3}` in ar, hyphen-minus).
   If you changed which notions the course covers, re-check the quiz is still answerable from
   the course alone — and report any quiz/exercise that should be adjusted (don't edit items
   unless asked; that's content-engine/content-audit territory).
6. `npm run content:check` (must pass) — then **stop and report**: chapter(s) touched, the
   tested-notion coverage map, axis-by-axis self-assessment, and the human's build/apply steps
   (a course rewrite changes `chapters` rows → `content:build` + apply before deploy, UUIDs
   stable).

## Quality specifics to honor

- **Trilingual programs**: each sibling subject's course is written natively in its language —
  rewrite siblings independently, never by translation (`themes-and-trilingual.md`).
- **Arabic**: full RTL prose around standard math, U+00A0 inside grouped numbers
  (`math-and-notation.md`), official Arabic terminology of the grade.
- Never weaken: don't shorten a course by dropping tested notions; don't add off-program
  material to "enrich"; don't move the fun into the assessment (RPG stays in titles/narration).
