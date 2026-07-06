---
name: content-interactif
description: >-
  Author INTERACTIVE / innovative exercises that go beyond the classic QCM — texte à trous (cloze),
  chasse à l'erreur, appariement (matching), remise en ordre (sequencing), QCM visuel SVG, lecture de
  document/données, histoire-problème séquentielle (story quest), vrai/faux motivé, sprint chrono —
  all encoded inside the current QCM engine, for ANY theme (school ecole-tn, culture-generale,
  muscle-cerveau, langues). Use whenever the user wants "exercices interactifs", "innovants",
  "variés", "autre chose que des QCM", "un exercice à trous", "un exercice d'appariement / de remise
  en ordre", "une mission scénarisée / histoire", "un sprint chrono" — e.g. "ajoute des exercices
  interactifs au chapitre fractions 6ème", "une mission scénarisée de SVT 9ème", "un sprint de calcul
  mental 4ème". Native input types are Tier B (docs/interactive-question-types.md) et TOUS
  SHIPPED : saisie numérique (`type: "numeric"`), drag & drop natif (`ordering`/`matching`)
  et multi-sélection (`type: "multi"`) sont authorable. Defers to the content-engine skill
  (references/interactive-formats.md) for the format catalogue, schema, quality bar, rewards, and
  validation.
---

# content-interactif — interactive missions inside the QCM engine

You are the **interactive exercise designer**: you widen the _experience_ range of the arena —
scenarios, visuals, manipulations, time pressure — while staying 100 % inside the current QCM
schema, so everything you author ships today with zero app code.

**Read first:** `content-engine/SKILL.md` + its references — above all
[`interactive-formats.md`](../content-engine/references/interactive-formats.md) (the format
catalogue + renderer contract + anti-patterns: it is THE spec for this skill), plus
`quality-bar.md`, `rewards-and-modes.md`, `math-and-notation.md`, and `style-guide.md`.

## Scope — what this skill does and does not do

- **Does:** add interactive exercise files (`exercices/NN-<slug>.json`) to **existing chapters** of
  any subject, or author the exercise tier of a new chapter alongside the responsible program
  wrapper. Formats: the ten in `interactive-formats.md` (Tier A only).
- **Does not:** author courses/quizzes (→ program wrapper / `content-cours`), or raise the
  d3–4 ceiling of school exam subjects on its own (→ co-design with the matching `prof-*`
  skill: the professor owns the trap taxonomy and calibration; this skill owns the
  interaction format). All Tier-B native types (`numeric`, `ordering`, `matching`, `multi`)
  ARE authorable — shapes and rules in content-engine `references/content-schema.md`; prefer
  them over the QCM-encoded permutation/multi-select formats for new content.

## Program fidelity still applies

An interactive skin never loosens the content rules of the subject's track:

- **School (`ecole-tn`):** scope + terminology from `content-ecole-tn` (CNP transcription first;
  grade's official language of instruction; exam-year phrasing for 6ème/9ème/Bac).
- **Non-school themes:** the matching wrapper's rules (trilingual siblings for
  culture-generale/muscle-cerveau, immersion for langue-\*, visual-first for iq-training).
- Notation is standard everywhere (`math-and-notation.md`), difficulty stars in every title,
  canonical rewards per difficulty — no exceptions for "special" formats.

## Workflow

1. **Confirm target** (theme, subject, grade if school, chapter) and **audit the existing ladder**
   (`content/<subject>/<NN-chapter>/exercices/*.json`): what tiers exist, what formats are already
   used, what the ceiling is. Interactive files take the **next free `NN`/`displayOrder`** — never
   rename/renumber/duplicate (`generation-pipeline.md`).
2. **Pick formats deliberately.** Match format to notion (cloze → grammar/formulas; matching →
   vocab/functions; sequencing → protocols/chronologies; visual SVG → geometry/schemas/matrices;
   document → data interpretation; story quest → multi-step problems; sprint → automatisms).
   Respect the variety quota (≥3 formats per mixed exercise) or go single-format special
   (story quest / sprint chrono).
3. **Author** 6+ questions per exercise, per-question difficulty ramp, in the chapter's language and
   RPG voice. Apply the format craft rules AND the anti-patterns list from
   `interactive-formats.md` — shuffle-safety (no display-letter references), question independence,
   one `<svg>` per field, executed-error distractors.
4. **Self-verify** per `quality-bar.md` (re-solve blind; for matching/sequencing, enumerate ALL
   permutations and prove exactly one option is fully correct; for SVG, re-read the figure as the
   student sees it).
5. **Validate and stop:** `npm run content:check` → `npm run content:qa:strict` (0 errors) → report
   (chapter, files, formats used per question, QA output). Files only — build with
   `npm run content:build -- --subject <id>`, apply, push **only when asked**.

## Placement & rewards (canonical)

| file (next free NN)      | typical format        | difficulty/mode/rewards               |
| ------------------------ | --------------------- | ------------------------------------- |
| `NN-mission-interactive` | mixed ≥3 formats      | d2 practice 75/15 (free tier)         |
| `NN-histoire-<slug>`     | story quest           | d3 boss 120/30 or d4 challenge 300/60 |
| `NN-sprint-chrono`       | sprint (boss timer)   | d2–d3 boss 120/30                     |
| `NN-mission-visuelle`    | visual SVG / document | any tier, rewards per table           |

Keep at least one interactive file reachable in the free tier (d1–2) of a chapter you enrich —
interactivity is a differentiator for prospects, not a premium-only perk.
