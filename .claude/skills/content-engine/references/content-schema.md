# Content schema — exact file shapes & constraints

Source of truth: `src/shared/content/schema.ts` (Zod) + `src/shared/content/loader.ts` (file
layout). Anything that fails validation never reaches the DB. **Read this before writing any file.**

## Directory layout (loader.ts)

```
content/
  <subject-id>/                 # a dir is a SUBJECT iff it contains subject.json
    subject.json                # REQUIRED
    NN-<slug>/                  # a dir is a CHAPTER iff it contains chapter.json; dir name = chapter slug
      chapter.json              # REQUIRED
      cours.md                  # REQUIRED, non-empty after trim → chapters.lesson_content
      resume.md                 # REQUIRED, non-empty after trim → chapters.summary
      quiz.json                 # REQUIRED (mandatory comprehension gate)
      exercices/                # OPTIONAL (French spelling). Each *.json = one exercise
        NN-<slug>.json          # filename minus ".json" = exercise slug
```

- Subjects/chapters are discovered by the presence of `subject.json` / `chapter.json`.
- `NN-` numeric prefixes only sort the folders on disk; the real ordering in-app is `displayOrder`.
- The chapter **directory name** is its slug; the exercise **filename** (minus `.json`) is its slug.
- `quiz` is a **reserved exercise slug** (the compiled quiz uses it) — never create `exercices/quiz.json`.
- IDs are deterministic UUIDv5 from slug paths (`subjectId/chapterSlug/exerciseSlug/qN`). Stable
  slugs ⇒ in-place updates; renames ⇒ delete+recreate.

## subject.json

| Field             | Type         | Required    | Constraint                                                                                                                                                                                              |
| ----------------- | ------------ | ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `id`              | string       | yes         | kebab-case `^[a-z][a-z0-9-]*$`, unique. Becomes `subjects.id` literally                                                                                                                                 |
| `nameFr`          | string       | yes         | non-empty. The only display name — write it in the subject's **own `contentLanguage`** (ar→`الرياضيات`, en→`English`, fr→`Français`). Field name is legacy (DB compat); the value is native, not French |
| `description`     | string       | yes         | non-empty                                                                                                                                                                                               |
| `attribute`       | string       | yes         | non-empty (RPG attribute label, e.g. "Force", "Logique")                                                                                                                                                |
| `colorToken`      | string       | yes         | non-empty, maps to a CSS var (e.g. `subject-math`)                                                                                                                                                      |
| `icon`            | string       | yes         | non-empty, a lucide icon name (e.g. `GraduationCap`)                                                                                                                                                    |
| `displayOrder`    | number       | yes         | positive integer                                                                                                                                                                                        |
| `contentLanguage` | enum         | yes         | `"ar"` \| `"fr"` \| `"en"` — the one language the content is written in (drives RTL)                                                                                                                    |
| `themeId`         | string       | yes         | kebab-case, FK → an existing `themes.id` (see themes-and-trilingual.md)                                                                                                                                 |
| `gradeSlug`       | string\|null | no (→null)  | school subjects only (e.g. `9eme-base`); `null` for standalone themes                                                                                                                                   |
| `isPremium`       | boolean      | no (→false) | **legacy/secondary** — premium is now decided **per parcours**, not by this flag                                                                                                                        |

There is **no** `nameEn`/`nameAr` — `nameFr` is the single display-name field, and you write it in the
subject's `contentLanguage` (the "Fr" in the name is legacy only). There is **no** per-language text
anywhere else.

> **Premium is per-parcours, not per-subject.** Access is governed by the parcours a subject resolves
> to (its theme+grade) and enforced server-side by `resolve_exercise_access` — not by `isPremium`. The
> `isPremium` flag is legacy and no longer read by the gate; leave it `false`/omit it. The **free
> preview** (the chapter comprehension quiz + every difficulty-1 mission) always shows, even on a
> premium parcours, so a prospect can taste a chapter before paying. See CLAUDE.md "Premium gate".

## chapter.json

| Field          | Type     | Required | Constraint                                                                            |
| -------------- | -------- | -------- | ------------------------------------------------------------------------------------- |
| `title`        | string   | yes      | non-empty (in the subject's language)                                                 |
| `description`  | string   | yes      | non-empty                                                                             |
| `displayOrder` | number   | yes      | positive integer                                                                      |
| `sources`      | string[] | no (→[]) | each ref ≥3 chars — URLs/citations you actually used (hybrid sourcing)                |
| `manuel`       | object   | no       | `{ code, pages }` — official student-textbook pages covering this chapter (see below) |

`cours.md` and `resume.md` are separate files, not fields.

### `manuel` — official student-textbook (manuel élève) pages

For school content (`content-ecole-tn`), a chapter MAY link to the pages of the **official CNP
student textbook** that cover it, so the app can show them under the course (login-gated
"Pages du manuel" gallery). Shape:

```json
"manuel": { "code": "103304", "pages": "12-15" }
```

| Field   | Type   | Constraint                                                                                                            |
| ------- | ------ | --------------------------------------------------------------------------------------------------------------------- |
| `code`  | string | alphanumeric `[A-Za-z0-9_-]+` — the CNP **manuel élève** book code (not the teacher guide)                            |
| `pages` | string | 1-based page expression: a single page, an inclusive range, or a comma list — `"12"`, `"12-15"`, `"12-15, 18, 20-21"` |

The build expands `pages` into a sorted, de-duplicated `pageNumbers[]` and stores
`{ code, pages, pageNumbers }` in `chapters.manuel_ref` (JSONB). Optional and additive — omit it
when the mapping is unknown. The page **images** are served from a separate access-controlled
bucket; this field carries only the metadata.

## Question object (shared by quiz.json and exercise files)

| Field           | Type     | Required | Constraint                                                                      |
| --------------- | -------- | -------- | ------------------------------------------------------------------------------- |
| `prompt`        | string   | yes      | non-empty                                                                       |
| `options`       | option[] | yes      | **2–6** items (use 4). Each `{ id: string≥1, text: string≥1 }`                  |
| `correctOption` | string   | yes      | must equal one of the option **ids** (not the text, not an index)               |
| `explanation`   | string   | yes      | non-empty (revealed by the hint consumable). Aim ≥25 chars — see quality-bar.md |
| `difficulty`    | number   | no       | integer 1–3 (untagged → treated as 2). Questions are emitted easiest→hardest    |

Cross-field rules (Zod refine): option **ids must be unique**; `correctOption` ∈ option ids.
Convention: option ids `a`,`b`,`c`,`d`.

### Figures (inline SVG) in questions

Any question field (`prompt`, an option's `text`, `explanation`) is a plain string, but it may embed
**one** `<svg>…</svg>` block to carry a figure (geometry diagrams, IQ matrices, shape sequences,
visual answer options). The renderer splits the field into its text and the SVG, sanitizes the SVG
(DOMPurify SVG profile — drawing primitives only), and shows the figure; surrounding text renders
normally. No schema/DB change is needed (it is just markup inside the string), and it round-trips
through the pipeline unchanged.

**The rendering contract (author to it):** the renderer always draws the figure on a **white "paper"
surface** (white background, dark default text colour), sized to a **definite width** the renderer
controls — ~256px max for a prompt, a ~64px box for an option — and scaled by the SVG's **`viewBox`**.
So: author every figure as if it sits **on white paper**, and let the `viewBox` (not width/height
attributes) drive the size.

Rules for authoring figures:

- **Self-contained SVG only.** Use a `viewBox`, and drawing primitives: `path`, `rect`, `circle`,
  `ellipse`, `line`, `polyline`, `polygon`, `g`, `text`, `tspan`, gradients/patterns. **Forbidden /
  stripped:** `<script>`, `<style>`, `<foreignObject>`, `<a>`, `<image>`, `<use>`, any `on*` handler,
  any `href`/`xlink:href`, external URLs. No raster images — vectors only.
- **Always set a `viewBox`** (e.g. `viewBox="0 0 100 100"`) and **do not rely on `width`/`height`
  attributes** for sizing — the renderer controls the on-screen size. A `viewBox`-less SVG has no
  aspect ratio and collapses.
- **Dark ink on the white paper for outlines.** Draw strokes/outlines with dark, opaque ink —
  `currentColor` (preferred: it inherits the dark default text colour), `#1f2937`, `#222`, `#0f172a`.
  **Never make the figure's primary marks white or near-white** (`#fff`, very light greys/pastels):
  on the white surface they are invisible.
- **Colour is encouraged — especially for young grades.** Fills survive sanitization and render in
  colour, so fill shapes with bright, saturated hues _inside_ their dark outlines (a green tree, an
  orange fish, a yellow sun, a red apple, a blue water drop). The only rule is **colour fills, dark
  outline** — keep a dark `stroke` so every shape stays legible on the white paper. For primary
  (≈ 1ère–3ème) prefer playful, recognizable, colourful illustrations over bare grey geometry; for
  abstract geometry (angles, axes, number lines, older maths) neutral dark ink is fine.
- **One `<svg>` per field.** A figure-only option is just its `<svg>` (no text needed); a stimulus is
  `prompt` text + one `<svg>`.
- Keep figures compact and legible (a `viewBox` around `0 0 100 100`–ish, explicit dark `stroke`/`fill`,
  readable when scaled to ~64px for options / ~256px max for prompts).
- The answer to a visual item must be **unambiguous and derivable from the figure alone**.

## quiz.json

| Field       | Type       | Required | Constraint                                                                                             |
| ----------- | ---------- | -------- | ------------------------------------------------------------------------------------------------------ |
| `title`     | string     | no       | if present, non-empty                                                                                  |
| `questions` | question[] | yes      | **3–10** (use 5). Difficulty skews 1–2 (comprehension check; gates exercises for school subjects only) |

Compiled to a `mode='quiz'`, `display_order=0` exercise with fixed rewards (20 XP / 5 coins) —
you do **not** author quiz rewards.

## exercices/\*.json

| Field          | Type       | Required | Constraint                                                                             |
| -------------- | ---------- | -------- | -------------------------------------------------------------------------------------- |
| `title`        | string     | yes      | non-empty (RPG-flavored, see style-guide.md)                                           |
| `difficulty`   | number     | yes      | integer **1–4** (1 easy · 2 medium · 3 boss · 4 élite; 3–4 premium-gated per parcours) |
| `mode`         | enum       | yes      | `"practice"` \| `"boss"` \| `"challenge"` (never `"quiz"`)                             |
| `xpReward`     | number     | yes      | positive integer — use the canonical table (rewards-and-modes.md)                      |
| `rewardCoins`  | number     | yes      | non-negative integer                                                                   |
| `displayOrder` | number     | yes      | positive integer (match the filename `NN`)                                             |
| `questions`    | question[] | yes      | **1–50** (use 6)                                                                       |

## Defaults you may omit

`gradeSlug` (→null), `isPremium` (→false), `chapter.sources` (→[]), `quiz.title`, question
`difficulty`. Everything else listed as required must be present.
