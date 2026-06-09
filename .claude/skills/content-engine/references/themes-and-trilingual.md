# Themes, grades & the trilingual model

Source: `supabase/migrations/20260605120000_themes_and_grades.sql`, `subjects.content_language`,
and the production `content/*/subject.json` files.

## The catalogue hierarchy

`themes` → `grades` → `subjects` → `chapters` → `exercises` → `questions`. A **theme** is a
top-level track; **grades** exist only under the school theme; everything below `subjects` is
theme/grade-agnostic.

## Seeded themes (use these `themeId`s — they already exist)

| themeId            | name                        | has grades? | typical contentLanguage |
| ------------------ | --------------------------- | ----------- | ----------------------- |
| `ecole-tn`         | Programme scolaire tunisien | **yes**     | per subject (ar/fr/en)  |
| `culture-generale` | Culture générale            | no          | trilingual → 3 subjects |
| `muscle-cerveau`   | Muscler ton cerveau         | no          | trilingual → 3 subjects |
| `anglais`          | Améliore ton anglais        | no          | `en`                    |
| `francais`         | Améliore ton français       | no          | `fr`                    |
| `arabe`            | Améliore ton arabe          | no          | `ar`                    |

Don't invent theme ids. If a genuinely new theme is needed, that's a `themes` seed migration — flag
it to the human rather than referencing a non-existent `themeId` (the FK won't resolve).

## School grades (`ecole-tn` only)

The Tunisian ladder, `gradeSlug` values: `1ere-base`, `2eme-base`, `3eme-base`, `4eme-base`,
`5eme-base`, `6eme-base`, `7eme-base`, `8eme-base`, `9eme-base`, `1ere-sec`, `2eme-sec`, `3eme-sec`,
`bac`. The national-exam years are `6eme-base`, `9eme-base`, `bac`. `9eme-base` is currently the most
populated — but it is just one grade; author for whatever grade is requested. `gradeSlug` is resolved
to a `grades` UUID at compile time, so the `grades` row must exist (all 13 are seeded).

## subject.json by program type

- **School subject** (`ecole-tn`): `themeId: "ecole-tn"`, `gradeSlug: "<grade>"`, `contentLanguage`
  = the subject's **official language of instruction** — one language, **not** trilingual. At
  `9eme-base`: math/svt/arabic in `ar`, french in `fr`, english in `en`. (Scientific subjects switch
  to French in secondary/lycée — see `content-ecole-tn` for the full rule.)
- **Standalone subject** (any non-school theme): `themeId: "<theme>"`, `gradeSlug: null`. Precedent:
  `content/fr-mastery/subject.json` (`themeId: "francais"`, `gradeSlug: null`). Its legacy
  `isPremium` flag is no longer read by the gate — premium is decided per parcours, and `francais`
  is a free `libre` parcours today.

## Trilingual = three sibling subjects (critical)

**Scope:** the trilingual fan-out applies to **non-school standalone themes only** (culture-generale,
muscle-cerveau, …). **School content (`ecole-tn`) is never trilingual** — it is
authored in the subject's single official language of instruction (see the school-subject row above
and the `content-ecole-tn` skill).

Content is **single-language per subject** — there is no `{fr,en,ar}` field. To offer a non-school
program in FR + EN + AR, author **three sibling subject directories**, one per language, all pointing
at the same theme:

```
content/culture-generale-fr/subject.json   → { contentLanguage: "fr", themeId: "culture-generale", gradeSlug: null }
content/culture-generale-en/subject.json   → { contentLanguage: "en", themeId: "culture-generale", gradeSlug: null }
content/culture-generale-ar/subject.json   → { contentLanguage: "ar", themeId: "culture-generale", gradeSlug: null }
```

Rules:

- Subject `id` must be unique + kebab-case, so **suffix the language** (`-fr`/`-en`/`-ar`). They
  cannot all be `culture-generale`.
- Each subject's chapters/quiz/exercises are authored entirely in that subject's language,
  **generated natively in that language — not translated** (more fluid, culturally idiomatic). The
  three siblings cover the **same topic, scope, and difficulty ladder**, but each is authored fresh in
  its own language (web-sourced); they need not be word-for-word identical questions.
- Schema precedent vs. exact precedent: production already has multiple language-specific subjects
  under one theme (`french` / `arabic` / `english` under `ecole-tn`), which proves the
  many-subjects-one-theme + per-subject `contentLanguage` shape is supported. But those are _distinct
  syllabi_, not parallel translations of one program. The sibling-_translation_ pattern here has no
  production example yet — it is the prescribed pattern for trilingual standalone themes.
- `nameFr` is always French even on the `-en`/`-ar` subjects (it's the only display-name field), but
  the _content_ is in the subject's language.
