---
name: content-ecole-tn
description: >-
  Author Tunisian national school-program (programme scolaire tunisien) content —
  courses, summaries, quizzes, and QCM exercises — for a specific grade and subject,
  faithful to the OFFICIAL curriculum. Use whenever the user wants school content for
  a grade level (1ère année de base … Baccalauréat, especially the national-exam years
  6ème, 9ème, Bac) and a school subject (maths, sciences physiques, SVT, arabe,
  français, anglais, histoire-géo, etc.) — e.g. "ajoute un chapitre de maths 9ème",
  "génère des exercices de physique pour le bac", "quiz d'arabe 9ème année". This is
  the sensitive, high-fidelity track: stay strictly on the official program. Defers to
  the content-engine skill for schema, quality bar, rewards, style, and validation.
---

# content-ecole-tn — national school program (faithful to the official curriculum)

This is the **critical, sensitive track**. Students rely on it for the national exam, so fidelity to
the official Tunisian program (CNP) is non-negotiable: right scope, right grade level, right
terminology, nothing off-syllabus.

First, **read the content-engine skill and its references** (`.claude/skills/content-engine/`) — they
define the file schema, quality bar, reward table, RPG style, and the validate-then-stop workflow.
This skill only adds the school-specific rules.

## Official-program sources — precedence (consume the transcription; CNP = source of truth)

The authoritative scope is the **national CNP program**. It is now **transcribed once** into a
**persistence layer** (`references/programmes-officiels/programme/<gradeSlug>/<matière>.md`) by a
dedicated session, so generation **consumes that transcription instead of re-reading the scans**.
Start with the index at [`references/programmes-officiels/`](references/programmes-officiels/) → its
[`README.md`](references/programmes-officiels/README.md) (precedence policy, CNP-corpus location +
`CATALOGUE.md`, subject-`id` convention). Precedence, for any grade+subject:

1. **Programme transcription — READ FIRST** —
   `references/programmes-officiels/programme/<gradeSlug>/<matière>.md`, if it exists: a faithful,
   structured transcription of the teacher guide (scope, محاور, progression, in/out-of-scope bornes).
   **This is the scope source for generation.** Spec + work-list:
   [`programme/README.md`](references/programmes-officiels/programme/README.md) ·
   [`programme/_INDEX.md`](references/programmes-officiels/programme/_INDEX.md).
   ⛔ **Do NOT render→vision the CNP scans from the generation track** — scanning is owned by the
   persistence-layer session (it transcribes once; we consume, avoiding duplicate vision work). If the
   transcription for the (grade, subject) is **not yet produced**, the unit is **blocked on the
   persistence layer**: check `programme/_INDEX.md` and request/await its transcription — never scan as a
   workaround.
2. **CNP corpus scans** (`YahiaAcademy/cnp-officiel/`, sibling of the repo) — the **ultimate authority**
   and the source the transcription is made from (student **manuel** = content/scope; **teacher guide** /
   الدليل المرجعي = program; `CATALOGUE.md` maps grade×subject → file). Re-verifiable here via the
   transcription's cited pages. **Reading the scans is the persistence session's job, not generation's.**
3. **Taybah school files** (`programmes-officiels/taybah/<gradeSlug>.md`) — **verification + detail
   complement** only: the kids' school **trimester sequencing** and a cross-check. **Never** use them to
   contradict or narrow the CNP scope — flag divergences, don't silently follow them.

## Inputs to confirm before writing

- **Grade + subject → scope source (authoritative)** → read
  `programmes-officiels/programme/<gradeSlug>/<matière>.md` (the persistence transcription); this sets the
  authoritative scope. If it doesn't exist yet, the unit is blocked on the persistence layer
  (`programme/_INDEX.md`) — don't scan the corpus here. (`programmes-officiels/CATALOGUE.md` maps
  grade×subject → the underlying CNP files, for traceability.)
- **Grade** → the `gradeSlug` (e.g. `1ere-base`, `9eme-base`, `bac`). See `content-engine/references/themes-and-trilingual.md`.
- **School (verification, optional)** → if the content targets a specific school (e.g. _Taybah Primaire_),
  use `programmes-officiels/<école>/<gradeSlug>.md` to cross-check and to follow its **trimester
  sequencing** — a complement to the CNP scope, never overriding it.
- **Subject** → the school subject `id`, **grade-suffixed to stay unique** (`math-1ere`, `arabic-1ere`,
  `eveil-scientifique-1ere`, `education-islamique-1ere`, `french-1ere`, `english-1ere` — see the
  programmes-officiels README); the bare `math`/`svt`/`arabic`/`french`/`english` ids are 9ème's. New
  subject ids live under `themeId: "ecole-tn"`.
- **Language** → the subject's official language of instruction (see the Language section) — one
  language, never trilingual.
- **Chapter** → which official-program chapter/theme, and its `displayOrder`.

## Language — official medium of instruction (monolingual, never trilingual)

School content is **monolingual**: author and test in the **official language of instruction** for
that subject at that grade. The trilingual fan-out (three sibling subjects FR/EN/AR) is for non-school
themes only — do **not** produce FR/EN/AR versions of school content.

Set `subject.json` `contentLanguage` to that language and write every cours/resume/quiz/exercise in
it. The Tunisian medium of instruction (confirm against the official program for the exact
subject+grade):

- **Basic education (1ère–9ème de base):** all subjects in **Arabic** (`ar`), except **français**
  (`fr`) and **anglais** (`en`). So math, sciences physiques, SVT, histoire-géo, arabe at e.g.
  `9eme-base` → `ar`.
- **Secondary (1ère sec–Bac):** scientific & technical subjects (mathématiques, sciences physiques,
  SVT, informatique) switch to **French** (`fr`); humanities (arabe, histoire-géo, philosophie,
  éducation islamique) stay **Arabic** (`ar`); language subjects in their own language.

**Math/science in Arabic stays standard.** When the medium of instruction is Arabic (math, physique,
SVT in basic education), the **digits, equations, formulas, and units remain in standard
international notation** — Western digits (0–9), LTR formulas, SI units — exactly as in
French/English content. Arabic prose wraps standard math; never Arabic-Indic digits or arabized
notation. Hard rule: `content-engine/references/math-and-notation.md`.

## Fidelity workflow (the part that makes this track different)

1. **Anchor to the CNP program (source of truth) — via the transcription.** Ground truth, in order:
   **(a)** the **programme transcription** `programmes-officiels/programme/<gradeSlug>/<matière>.md`
   (faithful render of the teacher guide — scope, محاور, progression, in/out-of-scope bornes);
   **(b)** the **Taybah school file** (`programmes-officiels/<école>/<gradeSlug>.md`) as **verification +
   trimester sequencing** complement; **(c)** web only to fill genuine gaps (`tunisiecollege.net`,
   `tadris.tn`, edunet/CNP). Establish the exact notions the chapter must cover — faithful to the CNP.
   ⛔ **Don't render→vision the CNP scans here** — that's the persistence session's job (consume its
   transcription). If `programme/<gradeSlug>/<matière>.md` is missing, stop: the unit is blocked on the
   persistence layer (`programme/_INDEX.md`). Heed the Taybah files' `[?]`/`[sic]` markers.
2. **Map your chapter to the syllabus.** Cover the official notions for that chapter — no more, no
   less. Match the official vocabulary and notation.
3. **Flag anything off-program.** If you're tempted to add a notion that isn't in the official
   program for this grade, do NOT silently include it — call it out in your report so the human can
   decide. Never inflate scope or pull in higher-grade material.
4. **Cite sources.** Put the official program reference + any pages/URLs you used in each
   `chapter.json` `sources[]`.
5. Then author the files exactly per the content-engine workflow (cours.md, resume.md, quiz.json,
   exercises ladder), keeping core free progression at difficulty 1–2 and boss/challenge at 3–4.

## Sourcing

Hybrid, but official-source-led: the curriculum scope comes from the official program; model
knowledge fills in worked examples and explanations; web search verifies facts and exam-style
conventions. Exam-year grades (6ème/9ème/Bac) should reflect real exam (concours/annales) phrasing.

## Then validate and stop

`npm run content:check` → `npm run content:qa:strict` → `npm run content:audit` (program conformance &
coverage vs the grade manifest under `references/programmes-officiels/manifest/` — flags missing
subjects/chapters, off-program chapters, and incomplete chapters; codify the chapter list there while
reading the CNP guide) → report (files created, grade/subject, official-program coverage, anything
flagged off-program, QA + audit results, and the build/apply/PR steps for the human). Do not build/apply
or push unless asked.
