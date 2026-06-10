# Language-track authoring (anglais / francais / arabe)

Used by the `content-langue-anglais`, `content-langue-francais`, and `content-langue-arabe` wrappers.
These themes teach a language as a skill, independent of any school grade. Read this before writing.

## Mapping

- One theme per language: `anglais` (contentLanguage `en`), `francais` (`fr`), `arabe` (`ar`).
- The teaching/instruction language **is** the target language (immersion): an English-track subject
  is authored in English, a French track in French, an Arabic track in Arabic. `gradeSlug: null` always.
- The standalone language tracks ship as **free** `libre` parcours today, so leave `isPremium` off
  (premium is decided per parcours, not by this legacy flag). The free preview rules still apply, but
  on a free parcours every mission is open regardless of difficulty.

## Structure: two axes — CEFR-level subjects + a Donjon (author both)

A language theme is offered along two complementary axes. A learner can climb **by level / by chapter**,
or test themselves on **the whole language at once** in the Donjon.

### Axis 1 — by level: one subject per CEFR level (the ascending ladder)

Model proficiency as **separate subjects, one per CEFR level**, so a learner picks their level and
climbs from the simplest to the most complex. Subject `id` = `{lang}-{level}`:

| level | subject id (anglais) | nameFr (display — always French)    | displayOrder |
| ----- | -------------------- | ----------------------------------- | ------------ |
| A1    | `anglais-a1`         | Anglais — Débutant (A1)             | 1            |
| A2    | `anglais-a2`         | Anglais — Élémentaire (A2)          | 2            |
| B1    | `anglais-b1`         | Anglais — Intermédiaire (B1)        | 3            |
| B2    | `anglais-b2`         | Anglais — Intermédiaire avancé (B2) | 4            |
| C1    | `anglais-c1`         | Anglais — Autonome (C1)             | 5            |

Same `{lang}-{level}` shape for `francais-*` and `arabe-*` (for Arabic use ascending bands such as
مبتدئ / متوسط / متقدّم, keeping the slug as `arabe-a1`, `arabe-a2`, …). `nameFr` is always French — it
is the only display field — even though the content is in the target language.

- **Chapters = competences**, ordered simplest→most complex within the level: a grammar point, a tense,
  a vocabulary field, a reading/spelling skill. **~5 chapters per level** is a good flagship size.
- Calibrate each level to its CEFR band: A1 = the verb _to be_, present simple, articles & plurals,
  everyday vocabulary, basic questions; B2/C1 = nuance, register, idioms, complex syntax, inference.
- Build levels **bottom-up** (finish A1 before A2) so the ascending path is always complete end-to-end.

### Axis 2 — by whole theme: a dedicated Donjon subject (mixed, varied)

In addition to the per-chapter path, every language gets **one dedicated "Donjon" subject** that mixes
the whole language in a single varied gauntlet — _questions sur tout le thème_, not tied to one
chapter. This mirrors the `culture-generale-dungeon-*` precedent.

- Subject `id` = `{lang}-donjon` (e.g. `anglais-donjon`); `nameFr` e.g. "Anglais — Donjon (tout le
  thème)"; `attribute: "Polyvalence"`, `icon: "Swords"`, a high `displayOrder` (after the levels).
- One chapter (`01-donjon`) whose exercises **interleave competences** — each question is tagged with
  its strand in the prompt: `"Grammar — …"`, `"Vocabulary — …"`, `"Reading — …"`, `"Spelling — …"`
  (localized to the content language).
- Use the full ascending ladder below so the donjon itself ramps easy→elite and feels varied.
- The donjon **grows with the track**: while only A1 exists it mixes A1 material; as higher levels are
  authored, add donjon chapters/exercises spanning them. Say in the report which band it currently covers.

## The ascending exercise ladder (use this — ordered easy→elite)

Every level chapter **and** the donjon chapter use this 4-rung ladder (canonical modes + rewards from
`rewards-and-modes.md`), ordered so difficulty climbs from the simplest to the most complex:

| file          | mode      | difficulty | xp / coins | displayOrder | title pattern (localize; ⭐ = difficulty) |
| ------------- | --------- | ---------- | ---------- | ------------ | ----------------------------------------- |
| `01-pratique` | practice  | 1          | 50 / 10    | 1            | "⭐ Practice: …" / "⭐ Entraînement : …"  |
| `02-revision` | practice  | 2          | 75 / 15    | 2            | "⭐⭐ Review: …" / "⭐⭐ Révision : …"    |
| `03-boss`     | boss      | 3          | 120 / 30   | 3            | "⚔️ Chapter Boss ⭐⭐⭐: …"               |
| `04-defi`     | challenge | 4          | 300 / 60   | 4            | "👑 Elite Challenge ⭐⭐⭐⭐: …"          |

- **6 questions per exercise**, per-question difficulty ramping (1→3) and ≤ the tier ceiling. **5
  questions in `quiz.json`** (difficulty 1–2), titled e.g. "Comprehension Check ⭐".
- Free parcours never gate on difficulty, so all four rungs are always playable — the ladder is purely
  the ascending experience the learner asked for, not a paywall.

## What a good language chapter contains

- **cours.md**: the rule/pattern with plenty of _italicized example sentences_, a small forms/
  conjugation **table**, and RPG framing in titles/callouts (per `style-guide.md`).
- **quiz.json** (5 Q): comprehension of the chapter's core rule, difficulty 1–2.
- **exercices**: the ladder above. Question types that work well for languages — fill-in-the-gap, pick
  the correct form/tense/agreement, spot-the-error (use "find the error/intruder" prompts, which exempt
  the contradiction QA check), choose the right translation/meaning, identify the tense/function.
  **Vary the type across the six questions** — don't repeat one format six times.

## Quality specifics for languages

- **Distractors = real interference errors**: a common false-friend, a wrong tense/agreement, a typical
  L1-interference mistake — not random words.
- **Every correction is a mini-lesson** (`quality-bar.md` Layer 3): name the grammar point, give one
  clean example, and say why each tempting distractor is wrong — so even a missed question teaches.
  Keep explanations ≥25 chars (a full sentence or more).
- Sentences and examples must be **natural and correct** in the target language; verify idioms and
  usage via web search when unsure and cite sources in `chapter.json` `sources[]`.
- Keep each subject strictly in its one immersion language; only slugs/`mode`/URLs are exceptions.
- **Balance the key** — spread `correctOption` across a/b/c/d; no duplicate/near-duplicate questions
  within or across a level's chapters (or the donjon).

## Hybrid sourcing

Generate from model knowledge, then verify grammar/usage/idioms and align to a recognized framework
like CEFR (A1–C2) via web search; record references in `sources[]`.
