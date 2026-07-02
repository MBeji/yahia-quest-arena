# Expert exercises — the professor-grade bar for difficulty 3–4

This is the shared excellence standard for **hard** content: boss (⭐⭐⭐, d3) and élite/défi
(⭐⭐⭐⭐, d4) exercises, and exam-style (annales) sets. It sits **on top of** `quality-bar.md`
(which stays fully binding) and is consumed by the specialized **professor skills**
(`.claude/skills/prof-*`) — one per (matière × niveau), each of which owns its subject's trap
taxonomy and archetypes. This file owns everything subject-independent about hard items.

For where this fits in the whole system (base vs professor layers, skill selection, the cumulative
build→migration procedure), see `generation-pipeline.md`. The professor overlay only ever **adds**
top tiers to an existing chapter — audit the ladder first, fill upward, never duplicate.

## What "hard" must mean (and must NOT mean)

Difficulty comes from **reasoning depth**, never from obscurity. A d3/d4 item is hard because it
requires **more steps, combined notions, or transfer to an unseen situation** — while staying 100 %
inside the official program for the grade.

Legitimate sources of difficulty:

- **Multi-step chains**: the answer requires 2–4 dependent sub-results (find x, then use x).
- **Notion combination**: two or three chapter notions in one item (e.g. Thalès + équation;
  passif + concordance des temps).
- **Transfer**: a standard tool applied in a non-rehearsed disguise (data table, real scenario,
  figure description).
- **Reverse direction**: given the result, reconstruct the datum ("quelle valeur de départ… ?"),
  or judge validity ("laquelle de ces affirmations est fausse ?").
- **Discrimination**: near-miss cases where the method _almost_ applies (réciproque vs théorème
  direct, exception grammaticale) — the heart of exam selectivity.

Illegitimate difficulty (never do this):

- Off-program notions or vocabulary above the grade — fidelity beats difficulty, always.
- Trick wording, ambiguity, double negations, or items whose difficulty is _parsing the sentence_.
- Arithmetic ugliness for its own sake (huge numbers, radicals that don't simplify) — keep numbers
  **chosen so the reasoning is the work, not the calculation**.
- Two defensible answers, "all of the above", or options that overlap.

## Calibration — d3 (boss) vs d4 (élite)

| tier              | steps              | notions                                     | typical stem                                                |
| ----------------- | ------------------ | ------------------------------------------- | ----------------------------------------------------------- |
| d3 boss ⭐⭐⭐    | 2 dependent steps  | 1–2, same chapter                           | full-strength chapter item, exam question difficulty        |
| d4 élite ⭐⭐⭐⭐ | 3+ dependent steps | 2–3, may cross chapters of the same subject | concours discriminator — the item that ranks the top decile |

Per-question `difficulty` tags (1–3) still ramp **within** the exercise: open a d4 exercise with its
easiest question (tag 2), close with the hardest (tag 3). Six questions minimum (anti-rush floor).
Rewards/modes come from the canonical table (`rewards-and-modes.md`): d3 = `boss` 120/30,
d4 = `challenge` 300/60 — no off-pattern combos. Both tiers are premium-gated; **never** convert an
existing d1–2 free exercise to d3–4 (that would shrink the free preview).

## Archetype catalogue (subject-agnostic skeletons)

The professor skills instantiate these with subject content:

1. **Chaîne** — compute A, feed A into B ("أوجد x أوّلًا، ثمّ استنتج…" / "déduisez-en…").
2. **Combinée** — one scenario, two tools from different chapters of the subject.
3. **Sens inverse** — result given, find the input or the missing parameter.
4. **Chasse à l'erreur** — a worked solution with ONE planted, _typical_ error; find the wrong step.
   (Exempt from the QA "explanation contradicts key" rule — say so in the explanation.)
5. **Vrai/faux motivé** — 4 close statements, exactly one true (or one false); each false one encodes
   a named misconception.
6. **Cas limite / contre-exemple** — where the standard method fails or needs a condition
   (réciproque, domaine de validité, exception).
7. **Document/données** — a small table, figure description, or experiment result to interpret
   before any computation (SVT/physique/statistiques; reading tasks for languages).
8. **Transformation contrainte** — languages: rewrite under 2+ simultaneous constraints
   (passif **et** temps imposé; discours indirect **et** changement de personne).

An élite exercise mixes at least 3 different archetypes across its questions.

## Distractor engineering — the executed-error protocol

At d3/d4, every distractor must be the **result of actually executing a specific wrong path**, not a
random neighbour value:

1. Solve the item correctly. Write the full derivation in the explanation.
2. Pick 3 misconceptions **from the subject's trap taxonomy** (each professor skill lists it).
3. **Execute each misconception to the end** — the wrong number/form you obtain IS the distractor.
   (If a wrong path lands on the correct answer, change the item's numbers.)
4. In the explanation, name the #1 trap and _why_ it fails: "الخطأ الشائع…" / "le piège courant…" /
   "common trap…". At d4 this sentence is mandatory.
5. Homogeneity check: same length/format/precision across options — the correct one must not be
   recognisable by form (cf. quality-bar "Homogeneous options").

## Verification protocol — double solve, then adversarial pass

Hard items are where wrong keys hide. Before shipping an exercise:

1. **Re-solve every question from scratch** (fresh pass, no peeking at your explanation) and check
   the key matches. For numeric items, verify by an **independent route** (substitute back, check
   order of magnitude, verify units).
2. **Adversarial pass**: for each question, try to argue each distractor is defensible. If you can
   build a reasonable case for a second option, rewrite.
3. Confirm every fact/date/constant used is on-program and correct (web-verify non-trivial ones;
   cite in `chapter.json` `sources[]`).
4. Run `npm run content:check` + `npm run content:qa:strict` — then stop and report (never
   build/apply/push unless asked).

## The ladder-completion workflow (what a professor session does)

1. **Audit the chapter's existing ladder** (`content/<subject>/<NN-chapter>/exercices/`): what tiers
   exist (standard files: `01-pratique` d1, `02-boss` d3, `03-revision` d2, `04-defi` d4,
   `05-entrainement` d3)? Read them — the new items must not duplicate or near-duplicate any
   existing question, and must be **strictly harder** than the current ceiling when the mission is
   "raise the ceiling".
2. **Fill upward, never sideways**: add the missing d3/d4 files, or add a **new top tier** file
   (`06-defi-concours.json`, d4 `challenge`, 300/60) whose questions outclass the existing `04-defi`
   (more steps, more combination) while staying on-program.
3. **Exam-style sets** go in the subject's annales chapter (`…-annales-…`) and imitate real concours
   phrasing and structure.
4. Titles carry the tier: stars + localized label (`rewards-and-modes.md` table), e.g.
   "👑 تحدّي النخبة ⭐⭐⭐⭐: …" / "👑 Défi élite ⭐⭐⭐⭐ : …".
5. Files only → validate → report. The human reviews the diff, builds, applies.
