# Quality bar — what makes content pass and what makes it good

Two layers gate content. Layer 1 (Zod) is a hard fail — invalid content never compiles. Layer 2
(`content:qa`) catches answer-key defects. Beyond both, there is a pedagogical bar that no tool can
enforce but that defines the product's value — hold yourself to it.

## Layer 1 — structural (Zod, always hard-fails, run via `content:check`)

- Quiz 3–10 questions; exercise 1–50 questions; options 2–6 per question.
- Option **ids unique**; `correctOption` must equal one of the option ids.
- Difficulty: question 1–3, exercise 1–4. `xpReward` > 0; `rewardCoins` ≥ 0; `displayOrder` > 0.
- Subject `id`/`themeId` kebab-case; `contentLanguage` ∈ {ar,fr,en}.

## Layer 2 — answer-key heuristics (`content:qa` / `content:qa:strict`)

`content:qa` is advisory (always exits 0). `content:qa:strict` exits 1 only on **errors**. There is
exactly one error-level check; the rest are warnings. Fix all errors; fix warnings unless there's a
real reason not to.

1. **[ERROR] Duplicate option texts** — two options with the same text (after folding Arabic-Indic
   digits and stripping whitespace). This is the only check that fails `--strict`. Every option must
   be textually distinct.
2. **[warn] Answer value not echoed** — for a _short, non-Arabic, numeric_ correct answer (≤24 chars),
   the number(s) must also appear in the explanation. Always restate the computed answer in the
   explanation.
3. **[warn] Thin explanation** — explanation `< 25` characters. Write explanations of at least a full
   sentence; aim well past 25 chars.
4. **[warn] Explanation contradicts the key** — the explanation names a _different_ option (a–f) as
   correct, or calls the _correct_ option wrong. Keep the explanation consistent with `correctOption`.
   (Exempt for "find the error / intruder / odd-one-out" prompts, where the correct answer is itself
   the wrong item.)

Note: there is **no** automated check for duplicate _questions_, banned content, answer-position
balance, or difficulty distribution — you own those by judgment (below).

## Layer 3 — the pedagogical bar (judgment; this is the real value)

- **Every distractor encodes a specific, named misconception** — a sign error, a confused rule, a
  classic trap. No filler/obviously-absurd options. The wrong answers should be tempting to a student
  who half-understands.
- **Explanations teach.** State the rule, apply it to this item (show the computation with a `✓`
  check on harder questions), and on boss/challenge items name the common trap ("الخطأ الشائع…" /
  "le piège courant…") explaining why the plausible wrong answer fails.
- **Difficulty ramps within an exercise** (start at 1, end near the exercise's tier ceiling) and the
  quiz skews easy (difficulty 1–2) since it only gates comprehension.
- **Balance the answer key** — spread `correctOption` across a/b/c/d; don't let it sit on one letter.
- **No duplicate or near-duplicate questions** within or across a chapter's exercises.
- **Respect the anti-rush floor**: an attempt under `4s × question count` earns nothing and doesn't
  satisfy the gate, so keep enough questions (quiz 5, exercise 6) that a genuine attempt clears it.
- **Factual accuracy**: verify non-trivial facts via web search and cite them in `chapter.json`
  `sources[]`. For the school program, fidelity to the official syllabus overrides everything
  (see content-ecole-tn).
- **Language purity**: write entirely in the subject's `contentLanguage`. The only non-content-language
  tokens allowed are math/LaTeX symbols, folder slugs, `mode` values, and source URLs.
- **Standard notation everywhere**: Western digits (0–9) and standard LTR equations/units in **all**
  languages — Arabic content never uses Arabic-Indic digits or arabized formulas. Hard rule; see
  `math-and-notation.md`.

## Question craft — what an irreproachable QCM item looks like

Beyond the distractor/explanation rules above, every item must pass these craft checks:

- **One stem, one task, one defensible answer.** The prompt asks exactly one thing and is
  self-contained (solvable without seeing the options first, for computation items). If two options
  could be argued correct, rewrite the item.
- **Linguistically well-formed and idiomatic.** Every prompt and option must read as natural,
  grammatically correct prose in the content language — read each one aloud; if a native speaker
  would stumble, rewrite it. In Arabic in particular: correct agreement, and **dual pronouns
  (`هما`, `بينهما`, `كلاهما`) only when there are exactly two referents** — never a dangling dual
  over an enumerated set of three or more. The question clause must parse unambiguously on first
  read, with a clear referent. ✗ `ثلاثة أعمدة … أيّها بينهما في الطول؟` (dual `هما` over three
  columns — incoherent) → ✓ `… أيّها ليس الأقصر ولا الأطول؟`. Avoid calque/translationese
  constructions (e.g. the bare `لا واحد` for "none" — write idiomatic `لا شيء` / `ولا واحد منها`,
  or better, a real distractor).
- **No meta-options.** Never options that reference the _other options_ — "all of the above",
  "none of the above" / "aucune de ces réponses" / "لا شيء ممّا سبق", "a and b", "I don't know".
  Four real, independent candidate answers. (A substantive "nothing / zero / none-of-the-world"
  answer — `لا شيء` meaning _nothing happens_, `0`, `aucun jour` — is a legitimate real answer, not
  a meta-option; the ban is only on options that defer to the answer list itself.)
- **Negative stems are rare and bolded.** Prefer positive phrasing; if you must ask "which is
  **not**…", bold/emphasize the negation so it cannot be skimmed past (and remember such prompts
  exempt the contradiction check — don't overuse them).
- **Homogeneous options.** Same grammatical form, same order of magnitude of length and detail.
  The correct answer must not be recognizable as the longest, most precise, or most hedged option.
- **Deterministic option order.** Sort numeric options ascending (or descending — consistently);
  order text options logically (chronological, alphabetical, or by length). Randomizing the _key_
  is the engine's job via your key balance — the _display_ order should look deliberate.
- **No option leaks.** An option must not be contradicted or confirmed by the wording of the stem
  or of another option; distractors must not overlap (two options that mean the same thing).
- **Difficulty tag is honest.** A d1 question is answerable by a student who just read the course;
  a d3 question requires combining ≥2 notions or a multi-step computation. Don't tag for ordering
  convenience.

## Self-verification protocol — run it BEFORE `content:check`/`content:qa`

The automated layers catch structure, not correctness. Before running the checks, do a **blind
verification pass** over every file you wrote:

1. **Re-solve every question yourself, without looking at `correctOption`**, then compare. Any
   mismatch = fix the item (don't just flip the key — understand which was wrong).
2. **Re-read each explanation against the key**: it must assert the keyed option and only that one,
   restate the computed value (numeric answers), and not accidentally validate a distractor.
3. **Tally the answer key** across each exercise and across the chapter: no letter > ~40% of items,
   every letter used at least once per exercise where possible.
4. **Scan for duplicates / near-duplicates** (same fact or computation re-asked with cosmetic
   changes) within and across the chapter's exercises and quiz.
5. **Scan notation**: zero Arabic-Indic digits, true minus `−` in formulas, standard units, and —
   in `ar` content — **no plain space inside grouped numbers** (`\d \d{3}` outside `<svg>` must be
   zero; use U+00A0, else the bidi algorithm swaps the groups at render time — see
   `math-and-notation.md`).
6. **Check the ramp**: per-question difficulty is non-decreasing within each exercise and matches
   the exercise tier; the quiz stays at d1–2.

Only after this pass run `content:check` and `content:qa:strict`. To audit _existing_ content with
the same rigor, use the **`content-audit`** skill.

## Non-academic content — every correction is a mini-lesson

For **non-school programs** (culture-générale, muscle-cerveau, language tracks), the explanation is a
**mini-lesson, not a verdict**. Whether the student answered right or wrong, the correction must leave
them knowing more than before:

- State the correct answer and **why** it is correct.
- **Add 1–2 extra facts / context** around it — for culture-générale a date, a cause, a related
  figure, a "le savais-tu ?"; for languages the rule plus a clean example; for brain-training the
  method and why it works.
- Briefly say why the tempting wrong option is wrong (the misconception), so a wrong answer still teaches.

The goal: even a missed question grows the user's general culture and is memorable. Keep it concise
(2–4 sentences), accurate (verify facts via web, cite in `chapter.json` `sources[]`), and never
contradict the key. This is on top of the ≥25-char / no-duplicate-options rules above.
