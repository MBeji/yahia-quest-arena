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

## The official school-program references (read these — they are the ground truth)

The schools' **actual announced programs** are extracted, per grade and per trimester, under
[`references/programmes-officiels/`](references/programmes-officiels/) — start with its
[`README.md`](references/programmes-officiels/README.md) (index, precedence policy, subject-`id`
convention, age-adaptation note). When a file exists for the grade+subject you're authoring (e.g.
`programmes-officiels/taybah/1ere-base.md`), **it is authoritative**: match its notions, official
terminology, and **trimester split** exactly. The generic national program (CNP) is only a fallback
(grades with no school file) and a complement (terminology/examples) — **never** a license to widen scope
beyond what the school announces.

## Inputs to confirm before writing

- **School** → which school's program applies (e.g. _Taybah Primaire_) → the
  `programmes-officiels/<école>/` folder. If the family's school is unknown, ask; fall back to the generic
  CNP only when no school program is available.
- **Grade** → the `gradeSlug` (e.g. `1ere-base`, `9eme-base`, `bac`). See `content-engine/references/themes-and-trilingual.md`.
- **Trimester** → which trimester (T1/T2/T3) the chapter belongs to, per the school program's split. Keep
  the chapter within its trimester's scope; order `displayOrder` T1 → T2 → T3.
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

1. **Anchor to the school program (precedence).** Ground truth, in order: **(a)** the school's own
   program — `references/programmes-officiels/<école>/<gradeSlug>.md` — when it exists: take the exact
   notions, official terminology, and **trimester** for this grade+subject from it; **(b)** otherwise the
   generic CNP program (`Programme.pdf`/`Programme.docx` in the parent folder, `programme-9eme-annee-tunisie.md`,
   or web — `tunisiecollege.net`, `tadris.tn`, edunet/CNP). Establish the exact list of notions the chapter
   must cover for this grade+subject+trimester — **no more than the school announces**. (Heed the source
   file's `[?]` OCR-uncertain and `[sic]` markers — verify those against the original if a chapter leans on them.)
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

`npm run content:check` → `npm run content:qa:strict` → report (files created, grade/subject,
official-program coverage, anything flagged off-program, QA results, and the build/apply/PR steps for
the human). Do not build/apply or push unless asked.
