# Style guide — gamified, high-quality, attractive content

Distilled from the production chapters (Arabic `i3rab-wal-bina`, Math `nombres-reels`). The golden
rule: **the fun lives in the wrapper, the assessment stays clean.** RPG/manga framing goes in
`cours.md` titles/narration and in exercise _titles_; the questions, options, and explanations read
like a credible exam — no emojis, no slang.

## Tone

- Shonen/RPG-manga energy: the chapter is a "gate/battlefield", a hard exercise is a "chapter boss",
  the elite challenge is an "élite challenge". Knowledge = power-ups, the student = a hero leveling up.
- Direct second-person, motivational coach voice in the course ("you'll use this a lot", "you've
  cleared the first gate — you're ready for…").
- Restraint where it counts: keep **question prompts, options, and explanations** free of emoji and
  RPG framing — they stay academic. **Titles** (the quiz title and every exercise title) carry the
  standard difficulty indicator (⭐ scale, see below), and exercise titles also carry RPG flavor.

## cours.md skeleton (~50–75 lines)

1. `# ⚔️ <Title> — <epic subtitle>`
2. A blockquote epigraph: `> 💡 «a punchy maxim that motivates the chapter»`
3. 5–7 `##` sections, each led by a thematic emoji (🏰 ⚡ 🛡️ 🔮 🧮 🧪 📐). Bold every key term;
   italicize example phrases.
4. Use **markdown tables** for taxonomies/classifications, and `$$ … $$` display blocks for key
   formulas — **plain Unicode math inside, never LaTeX**, and **single-line only**
   (`$$ formula $$`; multi-line blocks don't render — see `math-and-notation.md`). Inline math is
   bare Unicode (⊂ ≤ √ π x²), never `$…$`.
5. Mid-course callouts: `> 🗡️` for a key tip, `> ⚠️` for a classic trap.
6. Closing `> 🏆` blockquote that frames the chapter as cleared and teases the next one.

> **Chapter number is app-rendered — never hand-write it.** The app shows a bold, centered chapter
> marker in the subject's language — **«الفصل N» / «Chapitre N» / «Chapter N»**, auto-numbered from the
> chapter's `displayOrder` — at the top of the lesson and in the subject's chapter list. So the `# H1`
> (and `chapter.json` `title`) is the chapter's **epic title only, in the subject's language** — do
> **not** prefix it with "Chapitre N" / "الفصل N" yourself, or it doubles up.

## resume.md skeleton (~7–10 lines)

`# 📜 <Résumé / ملخّص>: <Title>` then a flat bullet list, one bullet per cours section: a bolded
concept + its one-line essence. It is a compression of the course, not new material.

## quiz.json

- Title: a comprehension-check label in the content language that also shows the level, e.g.
  FR "Test de compréhension ⭐", EN "Comprehension check ⭐", AR "اختبار فهم الدرس ⭐". The quiz is the
  entry gate (difficulty 1 → ⭐).
- 5 questions, 4 options (`a`–`d`), difficulty 1–2, 1–2 sentence explanations.

## Exercise titles & ladder (RPG-flavored titles, clean bodies)

Every title carries its **difficulty indicator** (⭐ scale from `rewards-and-modes.md`):

| File                     | mode      | difficulty | title pattern (localize; ⭐ = difficulty)                             |
| ------------------------ | --------- | ---------- | --------------------------------------------------------------------- |
| `01-pratique`            | practice  | 1          | "⭐ Exercice : …" / "⭐ تمرين: …"                                     |
| `02-boss`                | boss      | 3          | "⚔️ Boss du chapitre ⭐⭐⭐ : …" / "⚔️ زعيم الفصل ⭐⭐⭐: …"          |
| `03-revision` (optional) | practice  | 2          | "⭐⭐ Révision (type examen) : …" / "⭐⭐ تمرين مراجعة… (نمط امتحان)" |
| `04-defi`                | challenge | 4          | "👑 Défi élite ⭐⭐⭐⭐ : …" / "👑 تحدّي النخبة ⭐⭐⭐⭐: …"          |
| `05-*` (optional)        | boss      | 3          | "📝 Entraînement ⭐⭐⭐ … (révision globale)" / "📝 تدريب ⭐⭐⭐…"    |

- 6 questions per exercise; per-question difficulty ramps and stays ≤ the tier ceiling.
- The ⭐ indicator is in the visible title; it complements (does not replace) the schema `difficulty` field.

## Explanation registers

- **Short** (quiz, easy items): 1–2 sentences — state the rule, apply it to this item.
- **Long** (boss/challenge/review, hard items): a worked solution — show the steps, mark the result
  with `✓`, then a named common-trap callout ("le piège courant… / الخطأ الشائع…") explaining why the
  tempting wrong answer fails. Explain why the key is right **and** why the plausible distractors are wrong.

## Per-language voice

- **Arabic** (`ar`): full Arabic, RTL; Arabic punctuation (، ؛). **Numbers and equations stay
  standard**: Western digits (0–9) and standard LTR formulas/units exactly as in French/English
  content — never Arabic-Indic digits (٠١٢٣), never arabized notation. The Arabic prose wraps the
  standard math (see `math-and-notation.md`). Grammar explanations cite the full إعراب
  (محلّ، علامة، نيابة).
- **French** (`fr`): clear standard French, guillemets « », accents correct.
- **English** (`en`): clear standard English.

Whatever the subject's `contentLanguage`, **all** of cours/resume/quiz/exercises are in that one
language — **including the subject `nameFr` and every chapter `title`** (an `ar` subject is fully
Arabic, names and titles included; only digits/notation stay Latin). The folder slugs and `mode`
values are the only French structural tokens.

## Calibrate to the student's age (and colourful figures for the youngest)

Tune sentence length, vocabulary, and figure density to the learner's age — detailed bands in
`content-ecole-tn/references/programmes-officiels/README.md` § « Adapter à l'âge ». For the youngest
grades (≈ 1ère–3ème), figures should be **playful, colourful illustrations** (dark outline + bright
saturated fills — orange fish, green tree, yellow sun), not grey geometry: the fill colour is kept at
render time (`content-schema.md` § Figures). Keep prompts very short, one figure per question.
