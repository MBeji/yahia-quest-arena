---
name: content-audit
description: >-
  Pedagogical audit of EXISTING content under content/ — verify answer keys by
  re-solving every question, check distractor quality, explanation correctness,
  difficulty calibration, answer-key balance, duplicates, standard math/digit
  notation (Western digits everywhere, including Arabic), language purity, and
  factual accuracy — AND audit the lesson texts (cours.md / resume.md) against
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
   > pas de LaTeX, bidi-safe, SVG `viewBox`), pureté de langue, qualité du cours (golden rule, exemple par règle,
   > miroir résumé↔cours), et **conformité au programme** vs `manifest/<grade>.json` + `taybah/<grade>.md`.
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
3. **Distractor quality** — each wrong option should encode a specific misconception/reasoning
   slip; filler or absurd options = **[MAJOR]**; overlapping/synonymous options = **[MAJOR]**.
4. **Question craft** — meta-options ("all of the above"…), un-emphasized negative stems,
   correct-answer-is-longest giveaways, ambiguous stems with two defensible answers
   (= **[BLOCKER]**), unsorted numeric options = **[MINOR]** unless they leak the key.
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
   **substantive** "nothing/zero" answer (`لا شيء` = *nothing happens*, legitimate) from a banned
   **meta-option** that defers to the other options (`لا شيء ممّا سبق`, "none of the above").
7. **Factual accuracy** — for culture-générale/sciences/history claims, spot-check non-trivial
   facts via web search; wrong fact = **[BLOCKER]**, missing `sources[]` for verified claims =
   **[MINOR]**. For `ecole-tn`, also check **syllabus fidelity against the CNP program** (the source of
   truth): the CNP corpus for this grade+subject (`content-ecole-tn/references/programmes-officiels/CATALOGUE.md`
   → `cnp-officiel/`: student manuel + teacher guide). Every notion must be in the official CNP scope for
   that grade — off-program or wrong-grade notions = **[MAJOR]**. The Taybah school file
   (`programmes-officiels/<école>/<gradeSlug>.md`) is a secondary cross-check / trimester sequencing, not
   the authority.

Per exercise / chapter:

8. **Answer-key balance** — tally `correctOption` letters; one letter > ~40% of an exercise =
   **[MINOR]**, a constant letter = **[MAJOR]**.
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
   against the **CNP program** (source of truth: the CNP corpus for this grade+subject via
   `content-ecole-tn/references/programmes-officiels/CATALOGUE.md`; Taybah files only as a secondary
   cross-check), else `chapter.json` scope — and flag off-program additions.
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

- **[BLOCKER]** wrong key, contradicting explanation, factually false, ambiguous double-answer —
  with file path, question locator (e.g. `exercices/02-boss.json q4`), the defect, and the proposed
  correction.
- **[MAJOR]** weak distractors, non-teaching explanations, notation violations, duplicates,
  off-syllabus, language impurity.
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
