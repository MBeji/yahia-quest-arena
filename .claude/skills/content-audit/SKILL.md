---
name: content-audit
description: >-
  Pedagogical audit of EXISTING content under content/ — verify answer keys by
  re-solving every question, check distractor quality, explanation correctness,
  question clarity & cognitive load, age/grade-appropriateness (vocabulary,
  context, number range vs the pupil's age), correct rendering/display (SVG
  figures, bidi-safe notation), difficulty calibration, answer-key balance,
  duplicates, standard math/digit notation (Western digits everywhere, including
  Arabic), language purity, and factual accuracy — AND audit the lesson texts
  (cours.md / resume.md) against
  the course-quality bar: clarity, ease of understanding, completeness (every
  tested notion taught), learning experience. Produces a severity-ranked report;
  applies fixes only on request. Use whenever the user asks to "auditer",
  "vérifier", "review", "QA" the pedagogical content, a subject, a chapter, the
  quizzes/exercises, or the courses/summaries — e.g. "audite le contenu de maths
  9ème", "vérifie les quiz de culture générale", "le cours est-il clair et
  complet ?", "audite les résumés". Defers to the content-engine skill for the
  schema, quality bar, course-quality bar, and notation rules.
---

# content-audit — pedagogical verification of existing content

The automated gates (`content:check`, `content:qa:strict`) catch **structure**, not **correctness**:
a question with a wrong answer key, a misleading explanation, or an off-syllabus notion passes them
all. This skill is the deep net — a human-grade review of content that already exists under
`content/`, applying the same bar the authoring skills must meet
(`content-engine/references/quality-bar.md` and `references/math-and-notation.md` — read both first).

## Conformité au programme & couverture (`content:audit`) — école-tn

The per-item checklist below audits what **exists**; it cannot see what is **missing**. For `ecole-tn`
content, run **`npm run content:audit`** first: it diffs the content tree against the per-grade
**program manifests** (`content-ecole-tn/references/programmes-officiels/manifest/<gradeSlug>.json` — a
declarative transcription of the official CNP program) and reports, per grade + subject, **missing
subjects**, **missing / off-program chapters**, and **incomplete chapters** (a chapter lacking course +
summary + quiz + **at least one mission**), plus language mismatches. Advisory by default; `--strict`
fails only on a **sealed** grade. This is the coverage/conformity net — the rest of this skill is the
per-item correctness net. (Format + how to seal a grade: the programmes-officiels README, § Manifeste.)

## Dérouler un audit complet de niveau (runbook) — uniquement sur contenu **figé**

⚠️ **N'auditer qu'un contenu figé.** Tant qu'une session génère/réaligne un (niveau, matière), tout audit
produit une **worklist périmée**. Lancer ce runbook seulement quand la génération du périmètre est
**terminée et mergée sur `main`** (aucun worktree `_wt-*` actif sur ce sujet).

1. **Figer le périmètre** : worktree isolé sur `main` à jour ; noter l'**empreinte** du contenu —
   `git rev-parse --short HEAD`. Elle date la validité du rapport.
2. **Couverture** : `npm run content:audit` (matières/chapitres manquants, hors-programme, incomplets vs manifeste).
3. **Audit pédagogique par item** : fan-out **un sous-agent par matière** (lecture seule, **aucun fix**). Prompt type :

   > Lis `content-audit/SKILL.md` + `content-engine/references/{quality-bar,math-and-notation,course-quality}.md`.
   > Audite TOUS les chapitres de `<matière>` (chapter.json, cours.md, resume.md, quiz.json, exercices/\*.json).
   > **Re-résous CHAQUE question à l'aveugle** puis compare à `correctOption`. Vérifie notation (chiffres latins,
   > pas de LaTeX, bidi-safe, SVG `viewBox`), **clarté de l'énoncé & charge cognitive**, **conformité à l'âge**
   > (vocabulaire, contexte, ordre de grandeur des nombres vs le niveau/âge), pureté de langue, qualité du cours
   > (golden rule, exemple par règle, miroir résumé↔cours), et **conformité au programme** vs
   > `programme/<grade>/<matière>.md` + `manifest/<grade>.json` + `taybah/<grade>.md`.
   > Rends un rapport classé par sévérité (BLOCKER/MAJOR/MINOR) : `fichier` + `locator` + défaut + correction proposée.
   > Indique le nombre de questions re-résolues. NE MODIFIE RIEN.

   Consolider les retours (+ la sortie `content:audit`) en **un seul** rapport.

4. **Persister** : `programmes-officiels/audit/<AAAA-MM-JJ>-<scope>.md`, **en-tête tamponné** de l'empreinte
   (« valide au commit `<SHA>` — ré-auditer si le contenu a bougé »). C'est la worklist remise à la session de correction.
5. **Boucle de correction** (autre session) : appliquer les fix → re-`content:audit` + `content:qa:strict` →
   `content:build` → appliquer la migration → **sceller** le niveau (`sealed:true`) une fois conforme + complet.

Exemple : `programmes-officiels/audit/2026-06-21-primaire-math.md`.

## Inputs

- **Scope**: a subject (`content/<subject>/`), a chapter, a theme's subjects, or the whole catalogue.
  Large scopes: fan out one sub-agent per subject and consolidate.
- **Axis**: **items** (questions/keys — the checklist below), **courses** (cours.md/resume.md —
  the course audit below), or **both** (default). "Audite les cours/résumés" → courses only.
- **Mode**: **report-only** (default) or **report + fix** (only when the user explicitly asks for
  fixes).

## The audit checklist (per question, per exercise, per chapter)

Work file by file. For every question:

1. **Re-solve it blind** — derive the answer without looking at `correctOption`, then compare.
   A mismatch is a **[BLOCKER]**: determine whether the key or your derivation is wrong (web-verify
   if factual) before flagging.
2. **Explanation vs key** — the explanation must assert the keyed option, restate the computed
   value for numeric answers, and never validate a distractor. Contradiction = **[BLOCKER]**;
   thin/non-teaching explanation (no rule, no method, no trap named on d3–4) = **[MAJOR]**.
   **Never reference options by letter.** Because the engine shuffles option order at display
   (see item 8), an explanation that says "option (b) is correct / the error is (c)" points at a
   letter the student never sees — and in practice these letter tags are frequently **wrong**
   (they name a different option than the key, which both misleads the learner and trips the
   layer-2 contradiction check). A by-letter reference that **inverts** the key (names a distractor
   as the answer) = **[BLOCKER]**; a by-letter reference that is merely stale/misleading but doesn't
   invert = **[MAJOR]** if it's wrong, **[MINOR]** if it's right-but-letter-based. Fix by describing
   the option's **content** ("the present-perfect form is correct"), never its letter. This is a
   pervasive authoring anti-pattern in the language tracks — scan every "find the incorrect/correct
   sentence" explanation for it.
3. **Distractor quality** — each wrong option should encode a specific misconception/reasoning
   slip; filler or absurd options = **[MAJOR]**; overlapping/synonymous options = **[MAJOR]**.
4. **Question craft** — meta-options ("all of the above"…), un-emphasized negative stems,
   correct-answer-is-longest giveaways, ambiguous stems with two defensible answers
   (= **[BLOCKER]**), unsorted numeric options = **[MINOR]** unless they leak the key.
   4b. **Clarity & cognitive load** — read the stem once at a learner's pace. It must land on the first
   pass: as short as the task allows (one sentence where possible), no nested or back-referencing
   clauses that force a re-read, no data irrelevant to the answer, no undefined symbol/abbreviation, a
   single interpretation. A prompt that is correct and on-syllabus but **convoluted, padded, or only
   disambiguated once you read the options** = **[MAJOR]** (rewrite the phrasing or split the task);
   a stem genuinely open to two readings = **[BLOCKER]** (overlaps item 4's double-answer rule).
5. **Notation** — scan for Arabic-Indic digits `[٠-٩]` (must be zero — **[MAJOR]**), hyphen-as-minus
   in formulas, letter `x` as multiplication sign, non-SI units. **LaTeX anywhere = rendered raw**
   (the app has no math renderer — see `math-and-notation.md`): any `\command` (regex `\\[a-zA-Z]+`)
   in question strings **or** cours.md/resume.md = **[MAJOR]**; inline `$…$` (dollars display
   literally) = **[MAJOR]**; `$$ … $$` blocks are legal only with plain-Unicode content.
   In `ar` content, a **plain space between digit groups** (`\d \d{3}`
   outside `<svg>`) = **[MAJOR]**: the bidi algorithm swaps the groups at render time (`38 461`
   displays as `461 38`) — it must be a NO-BREAK SPACE U+00A0. Also in `ar` content, an **Arabic
   radicand** (regex `[√∛∜](?:[؀-ۿ]|\([^)]*[؀-ۿ])` — e.g. `√(المساحة)`, `√المساحة`) = **[MAJOR]**:
   Arabic inside the radical fragments the LTR isolate and renders scrambled; rewrite as a
   number/symbol (`√(S)`, `√32`) or the root in words (`جذر المساحة`). And the **Arabic comma `،`
   (U+060C) used as a separator inside a math bracket group** — a set `{−4 ، 4}`, interval
   `]−1 ، 4[`, tuple `(3 ، 4 ، 5)`, coordinates `(x ، y)` = **[MAJOR]**: the Arabic comma breaks
   the LTR run so the notation renders scrambled (`{−4 ، 4}` → `4}،{−4`); it must be `;` (preferred)
   or a Latin `,`. An Arabic comma in ordinary prose, or inside a bracket holding real Arabic words,
   is fine — only comma-separated **notation** inside brackets is flagged. Note the **inverse**
   non-issue: plain arithmetic with an Arabic unit (`10 مي + 2 مي = ؟`, `5 د + 200 مي`) renders
   **correctly** natively — do NOT flag it, and do NOT "fix" it by isolating. Audit the **rendered**
   form, not just the source: any RTL string mixing digit runs with neutral separators is suspect.
   Standard digits/equations apply in **all** languages including Arabic.
6. **Language purity & coherence** — content not in the subject's `contentLanguage` (beyond math
   symbols, slugs, `mode`, URLs) = **[MAJOR]**. Beyond purity, **read every prompt and option aloud
   in the content language and judge its coherence** (no regex catches this — it is the auditor's
   job): grammatical correctness, **agreement** (Arabic: gender, and dual `هما`/`بينهما`/`كلاهما`
   only with exactly two referents — a dual over an enumerated set of three+ is incoherent, e.g.
   `ثلاثة أعمدة … أيّها بينهما؟` = **[MAJOR]**), clear pronoun referents, an unambiguous question
   clause, and idiomatic phrasing free of calques/translationese (the bare `لا واحد` for "none" is a
   calque = **[MINOR]**; prefer `لا شيء` / `ولا واحد منها` or a real distractor). A question whose
   wording does not parse cleanly = **[MAJOR]** even when the keyed answer is correct. Distinguish a
   **substantive** "nothing/zero" answer (`لا شيء` = _nothing happens_, legitimate) from a banned
   **meta-option** that defers to the other options (`لا شيء ممّا سبق`, "none of the above").
7. **Factual accuracy** — for culture-générale/sciences/history claims, spot-check non-trivial
   facts via web search; wrong fact = **[BLOCKER]**, missing `sources[]` for verified claims =
   **[MINOR]**. For `ecole-tn`, also check **syllabus fidelity against the CNP program** (the source of
   truth), read via the **programme transcription**
   `content-ecole-tn/references/programmes-officiels/programme/<gradeSlug>/<matière>.md` (consume it; it
   **combines the teacher guide — scope — AND the manuel élève — content/examples/exercises**; the
   `cnp-officiel/` scans are the ultimate authority but reading them is the persistence session's job —
   `CATALOGUE.md` maps grade×subject → both files for traceability). Every notion must be in the official CNP
   scope for that grade — off-program or wrong-grade notions = **[MAJOR]**. Conversely, content noticeably
   **thinner than what the manuel élève teaches** for a chapter (missing official examples/depth) = **[MINOR]**
   — the manuel élève is an indispensable complement, not optional. The Taybah school file
   (`programmes-officiels/<école>/<gradeSlug>.md`) is a secondary cross-check / trimester sequencing, not
   the authority.
   7b. **Age / grade appropriateness** — distinct from syllabus scope (item 7) and difficulty calibration
   (item 10): does the item _read_ as written for the learner's developmental stage? Judge the
   vocabulary level, sentence length, the real-world context/scenario it leans on, the magnitude of the
   numbers, and the cognitive load against the audience — the **school grade** (primary
   `1ère…6ème année de base` ≈ 6–12 yo, collège `7ème…9ème` ≈ 12–15, secondary through `Bac` ≈ 15–18)
   or, for non-school themes, the **declared level** (CEFR band for languages, the difficulty tier
   elsewhere). Flag, even when the notion is on-syllabus and the key is right: vocabulary clearly above
   the grade, an **adult or irrelevant scenario for young children** (taxes, mortgages, the workplace,
   driving) where a familiar one (animals, toys, the classroom, sharing snacks) was needed, numbers or
   abstraction past the grade's range, a **childish/condescending register for teens**, or any mature or
   age-unsafe theme = **[MAJOR]** (→ **[BLOCKER]** only if the mismatch makes the item unanswerable or
   the theme is genuinely inappropriate for the age). A subtle register slip a child would still parse =
   **[MINOR]**. This is presentation/accessibility, not whether the notion belongs in the program.

Per exercise / chapter:

8. **Answer-key balance & content-based leaks.** First the key fact: **the engine shuffles option
   order at display time** (`shuffleOptions`, a per-attempt Fisher-Yates, in both the quest exercise
   route and the dungeon — `src/shared/lib/question-utils.ts`). So the **letter** a `correctOption`
   sits on is _not_ player-visible: a constant or skewed key letter is **not** a giveaway — it is
   only authoring tidiness, **[MINOR]** at most (many subjects deliberately author the correct option
   first; that is fine). Do **not** flag "all keys are `a`" as a [MAJOR]. What shuffling does **not**
   hide is a **content-based leak**, and that is the real defect to hunt: the correct option being the
   **longest / most-detailed / most-hedged / only one carrying a parenthetical justification** while
   the distractors are bare — a test-wise pupil then picks the key by shape, not knowledge. A single
   such item = **[MAJOR]**; a chapter-wide pattern (e.g. the key carries "(ظرف زمان) منصوب" while
   distractors are one-word labels in most items) = **[MAJOR]**, called out once for the whole
   exercise/chapter. Fix by homogenising option length/detail (strip the parenthetical into the
   `explanation`, or add an equivalent one to each distractor).
   **Measure it, don't eyeball it.** Per exercise, count the share of items where the correct option
   is the **strictly longest** of its options; a baseline of ~25% is chance (4 options), so anything
   ≥~50% is a systemic leak = **[MAJOR]** for the chapter/subject. (A loose "1.5–1.6× longest distractor"
   heuristic **drastically undercounts** — a catalogue sweep that flagged a subject at 14% read 50–70%
   on the strict measure. Trust the strict count.) The leak concentrates by **question type**: it is
   near-zero for arithmetic / single-word fill-in items, and severe for **"explain why / what's the
   difference / identify the figure-or-rule and its effect / which statement is fully correct"** items,
   where the keyed answer naturally bundles a definition the distractors lack — science, éducation
   islamique, and the comprehension/figures-de-style chapters of the language subjects are the hotspots.
   Caveat (avoid false positives): when the longer-correct items are **reading-inference / definition**
   questions whose distractors are _also_ full developed clauses, the length carries no real tell —
   verify on the subject's short-answer items before escalating, and say so in the report.
9. **Duplicates** — same fact/computation re-asked with cosmetic changes, within or across the
   chapter's quiz + exercises = **[MAJOR]**.
10. **Difficulty calibration** — per-question difficulty honest and non-decreasing within the
    exercise; exercise `difficulty`/`mode`/rewards match the canonical table in
    `rewards-and-modes.md`; quiz stays d1–2; titles carry the ⭐ indicator = **[MINOR]** each.
11. **Course/quiz coherence** — the quiz is answerable from `cours.md` alone; `resume.md` mirrors
    the course; SVG figures are self-contained and unambiguous.
12. **Figures render visibly** (see `content-schema.md` "rendering contract") — every `<svg>` has a
    `viewBox` (no `viewBox` → collapses = **[MAJOR]**); the primary ink is dark (`currentColor` or
    dark hues) so it shows on the white "paper" surface — an SVG whose only strokes/fills are
    white/near-white is invisible = **[MAJOR]**. A prompt/option that references a figure but ships
    none = **[BLOCKER]** (also caught by `content:qa --strict`).

Also run `npm run content:check` and `npm run content:qa` over the scope and fold their findings in
(they're fast and catch regressions in files you didn't open).

## The course & summary audit (axis: courses)

Grade each chapter's `cours.md` + `resume.md` against
`content-engine/references/course-quality.md` (read it first — it defines the four axes and the
severity mapping). Per chapter:

1. **Exhaustivité (golden rule first)** — extract the list of notions/edge cases the chapter's
   quiz + exercises test, and point each to the course section that teaches it. Any
   tested-but-untaught notion = **[MAJOR]**. Then check full official-scope coverage — school content
   against the **CNP program** (source of truth: the programme transcription
   `content-ecole-tn/references/programmes-officiels/programme/<gradeSlug>/<matière>.md` — consume it,
   scanning the corpus is the persistence session's job; Taybah files only as a secondary cross-check),
   else `chapter.json` scope — and flag off-program additions. The transcription **combines the teacher
   guide AND the manuel élève**: a chapter that covers the scope but is **thinner than the manuel élève**
   (missing the official lessons/examples/exercises the student textbook teaches) is **incomplete** =
   **[MINOR]** (→ **[MAJOR]** if a whole notion the manuel élève teaches is absent) — the manuel élève is
   an indispensable complement, not optional.
2. **Clarté** — one notion per section, terms defined at first use in the official terminology,
   grade-calibrated sentences, formulas displayed on their own line, tables for classifications.
3. **Facilité de compréhension** — concrete example before each rule, **a worked example for
   every rule** (a rule without one = **[MAJOR]**), simple→complex ordering, ≤1 new notion per
   section, `> ⚠️` traps placed where the confusion is born.
4. **Expérience pédagogique** — style-guide skeleton (epigraph, emoji sections, callouts,
   closing), motivation, length 50–75 lines, and **resume.md as a standalone revision tool**
   (one bullet per section, bolded concept + essence, no invented material).
5. **Factual & notation pass** — re-derive every worked example and formula in the course
   (wrong result = **[BLOCKER]**); run the notation scans (Arabic-Indic digits, bidi-unsafe
   `\d \d{3}` in ar, hyphen-minus, LaTeX residue `\\[a-zA-Z]+` and inline `$…$` — both render
   raw); check language purity.

Report one line per axis per chapter with the findings that drove it, then the severity list.
Fix mode: course rewrites are UUID-safe (in-place `cours.md`/`resume.md` edits); large rewrites
belong to the **`content-cours`** skill — hand off rather than improvising a new course inline.

## Report format (the deliverable)

A severity-ranked report, per subject/chapter:

- **[BLOCKER]** wrong key, contradicting explanation, factually false, ambiguous double-answer,
  a figure referenced but missing, or an age mismatch that makes the item unanswerable/unsafe —
  with file path, question locator (e.g. `exercices/02-boss.json q4`), the defect, and the proposed
  correction.
- **[MAJOR]** weak distractors, non-teaching explanations, notation/rendering violations, duplicates,
  off-syllabus, language impurity, **convoluted/ambiguous stem (clarity)**, **off-age vocabulary,
  context, or number range for the grade**.
- **[MINOR]** key balance, ordering, ⭐ titles, thin sources.
- A summary table: questions audited / blockers / majors / minors per chapter, plus an overall
  verdict (ship / fix-first).

## Fix mode (only on explicit request)

- Edit the content **files** only — never generated SQL, never the schema/scripts.
- **Preserve identity**: never rename subject ids, chapter folders, or exercise filenames, and
  never reorder questions across difficulty tags (UUIDs are keyed on slugs + emission order).
  Fixing text/options/keys/explanations in place is safe.
- Don't just flip a wrong key — make the explanation, distractors, and key coherent as a set.
- After fixes: re-run the audit pass on the touched files, then `npm run content:check` +
  `npm run content:qa:strict` (0 errors), then **stop and report** (build/apply/PR steps are the
  human's, per content-engine).
