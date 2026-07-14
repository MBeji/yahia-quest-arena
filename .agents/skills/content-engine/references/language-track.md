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

| level | subject id (anglais) | nameFr (display — in the subject's language) | displayOrder |
| ----- | -------------------- | -------------------------------------------- | ------------ |
| A1    | `anglais-a1`         | English — Beginner (A1)                      | 1            |
| A2    | `anglais-a2`         | English — Elementary (A2)                    | 2            |
| B1    | `anglais-b1`         | English — Intermediate (B1)                  | 3            |
| B2    | `anglais-b2`         | English — Upper-Intermediate (B2)            | 4            |
| C1    | `anglais-c1`         | English — Advanced (C1)                      | 5            |
| C2    | `anglais-c2`         | English — Mastery (C2)                       | 6            |

**Author the full CEFR ladder A1→C2** (six levels). The reference English program shipped all six
(`anglais-a1`…`anglais-c2`); a complete track is A1 through C2, not A1–C1. Same `{lang}-{level}` shape
for `francais-*` and `arabe-*` (for Arabic use ascending bands such as مبتدئ / متوسط / متقدّم, keeping
the slug as `arabe-a1`, `arabe-a2`, …). `nameFr` is the only display field, and you write it **in the
subject's target language** (an `anglais-*` subject gets an English name, an `arabe-*` an Arabic one) —
the field name is legacy, not a French requirement.

- **Chapters = competences**, ordered simplest→most complex within the level. **~5–8 chapters per
  level** (the reference English levels run 5–8; A1 stays small, mid/high bands are richer). Each level
  must cover more than grammar — every level ships, in addition to its grammar/tense chapters:
  - **at least one vocabulary chapter** (a vocabulary field, e.g. everyday vocab, phrasal verbs, idioms,
    confusables/false-friends, word-formation), and
  - **a dedicated reading-comprehension chapter** (named `…-reading` / `…-reading-inference` /
    `…-reading-critical` as the band rises) — a short passage + comprehension questions.
- Calibrate each level to its CEFR band: A1 = the verb _to be_, present simple, articles & plurals,
  everyday vocabulary, basic questions; B2/C1/C2 = nuance, register, idioms, inversion/cleft/ellipsis,
  word-formation, complex syntax, inference and critical reading.
- Build levels **bottom-up** (finish A1 before A2) so the ascending path is always complete end-to-end.

### Axis 2 — by whole theme: a dedicated Donjon subject (mixed, varied)

In addition to the per-chapter path, every language gets **one dedicated "Donjon" subject** that mixes
the whole language in a single varied gauntlet — _questions sur tout le thème_, not tied to one
chapter. This mirrors the `culture-generale-dungeon-*` precedent.

- Subject `id` = `{lang}-donjon` (e.g. `anglais-donjon`); `nameFr` in the track's language, e.g.
  "English — Gauntlet (whole theme)"; `attribute: "Polyvalence"`, `icon: "Swords"`, a high
  `displayOrder` (after the levels).
- The donjon's chapters **interleave competences** — each question is tagged with its strand in the
  prompt: `"Grammar — …"`, `"Vocabulary — …"`, `"Reading — …"`, `"Spelling — …"` (localized to the
  content language).
- **One gauntlet chapter per CEFR band** (the proven layout): a `01-donjon` opener that mixes the whole
  language, then one band chapter per level — `NN-gauntlet-{band}` (`02-gauntlet-a2`, `03-gauntlet-b1`,
  … `06-gauntlet-c2`) — each blending that band's chapters across all strands. The reference English
  donjon is `01-donjon` + `gauntlet-a2…gauntlet-c2`.
- Use the full ascending ladder below in every gauntlet chapter so each one ramps easy→elite and varied.
- The donjon **grows with the track**: while only A1 exists it mixes A1 material in `01-donjon`; as each
  higher level is authored, add its `NN-gauntlet-{band}` chapter. Say in the report which bands it covers.

## The ascending exercise ladder (use this — ordered easy→elite)

Every level chapter **and** the donjon chapter use the **language-track variant** of the canonical
ladder (`rewards-and-modes.md`) — reordered strictly ascending (review at `02`, boss at `03`) plus an
added cumulative `05-drill`, so difficulty climbs from the simplest to the most complex:

| file          | mode      | difficulty | xp / coins | displayOrder | title pattern (localize; ⭐ = difficulty) |
| ------------- | --------- | ---------- | ---------- | ------------ | ----------------------------------------- |
| `01-pratique` | practice  | 1          | 50 / 10    | 1            | "⭐ Practice: …" / "⭐ Entraînement : …"  |
| `02-revision` | practice  | 2          | 75 / 15    | 2            | "⭐⭐ Review: …" / "⭐⭐ Révision : …"    |
| `03-boss`     | boss      | 3          | 120 / 30   | 3            | "⚔️ Chapter Boss ⭐⭐⭐: …"               |
| `04-defi`     | challenge | 4          | 300 / 60   | 4            | "👑 Elite Challenge ⭐⭐⭐⭐: …"          |
| `05-drill`    | practice  | 2          | 75 / 15    | 5            | "⭐⭐ Drill: …" / "⭐⭐ Drill : …"        |

- **`05-drill` is a cumulative consolidation rung** (added to every chapter once the ladder is mature):
  6 **brand-new** questions that re-sample the **whole chapter** end-to-end (no duplicates of the quiz or
  of 01–04), at the ⭐⭐ review tier. It reinforces retention without raising the ceiling — give every
  finished chapter one. The four rungs above (01–04) are the spine; `05-drill` is the extra-reps top-up.
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
- **Verify every key blind, then balance it** — re-solve each question yourself before trusting the
  answer key; then spread `correctOption` across a/b/c/d. Watch for single-letter sweeps (a run of all-`b`
  is a red flag, not a coincidence). No duplicate/near-duplicate questions within or across a level's
  chapters (or the donjon) — `05-drill` questions must be new, not recycled from 01–04 or the quiz.

## Proven rollout sequence (large language tracks)

Building a full A1→C2 track is big; do it in reviewable phases rather than one mega-drop (this is how
the reference English track was built — one PR per phase):

1. **Levels, bottom-up** — author the grammar/tense spine of each level A1→C2 + the donjon, complete
   end-to-end, before broadening.
2. **Audit** — re-solve every question blind, fix keys/distractors/calibration, balance the key
   (use the `content-audit` skill). Do this _before_ broadening, while the surface is small.
3. **Broaden** — add the vocabulary and reading-comprehension chapters each level needs, plus any
   missing grammar competences.
4. **Drill** — add the cumulative `05-drill` rung to every finished chapter (top-up reps).

Each phase ends at the validate-and-stop gate (`content:check` + `content:qa:strict`, 0 errors) and is
its own PR. Build the SQL migrations only when asked, after the files pass.

## Hybrid sourcing

Generate from model knowledge, then verify grammar/usage/idioms and align to a recognized framework
like CEFR (A1–C2) via web search; record references in `sources[]`.
