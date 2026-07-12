# Interactive formats — beyond the classic QCM (within the current engine)

This is the canonical catalogue of **interactive / innovative exercise formats**. It exists because
the product needs more variety than "read a stem, pick a fact" — and because most of that variety is
achievable **today**, with zero app code, by encoding richer interactions into the existing QCM
schema. The `content-interactif` skill instantiates these formats; every content skill may borrow
them (professor skills already use several as archetypes).

Two tiers — know which one you are authoring for:

- **Tier A — QCM-native (author these now).** Formats fully expressible in the current schema
  (`options: [{id,text}]` + `correctOption` + server-side string-equality scoring). Everything in
  this file is Tier A.
- **Tier B — engine-native types** (numeric input, drag-&-drop ordering/matching, multi-select),
  specified in `docs/interactive-question-types.md`. **All three phases have shipped:
  `numeric`, `ordering`, `matching` and `multi` are ALL authorable now** (shapes and
  authoring rules in `content-schema.md`). For NEW content, prefer native `ordering`/
  `matching`/`multi` over this file's QCM-encoded permutation/multi-select-as-mcq formats —
  the encoded variants stay valid for existing content. Tier B is fully shipped; there is no
  remaining ban.

## The renderer contract (what an author can rely on)

Source: `src/features/quest/components/exercise-player.tsx`, `src/shared/lib/figure.ts`,
`src/shared/lib/question-utils.ts` (see `docs/interactive-question-types.md` for the deep map).

| capability             | status    | authoring consequence                                                                                                                                        |
| ---------------------- | --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Inline SVG             | ✅        | **one `<svg>` max per field** (prompt, each option `text`, explanation); DOMPurify SVG profile; no `<image>`, no external refs                               |
| Markdown / rich text   | ❌        | plain text only — structure with line breaks, `•`, `→`, ①②③, never `**bold**`                                                                                |
| Images (`<img>`, URLs) | ❌        | draw it as SVG or describe it in words                                                                                                                       |
| RTL Arabic + LTR math  | ✅        | bidi-safe: standard digits/equations are auto-isolated (`math-and-notation.md`)                                                                              |
| Option shuffling       | ✅ always | options are **reshuffled** with display letters A–D; **never** reference "option A" or rely on option order — label things inside the text (①②③, step names) |
| Timer                  | boss mode | `boss` = 20 s/question at runtime — a design material (see Sprint chrono)                                                                                    |
| Scoring                | server    | exact match on the option `id`; one single correct option; no partial credit                                                                                 |
| Per-question state     | ❌        | questions are independent — a question must never require having answered the previous one **correctly**                                                     |

## Format catalogue (Tier A)

Every format below is a **QCM under the hood** — the innovation is in the stem design and the
distractor semantics. Difficulty/rewards stay canonical (`rewards-and-modes.md`); each format works
at any difficulty unless noted.

### 1. Texte à trous (cloze)

Stem = a sentence/derivation/code-of-conduct with **one blank** (`…` or `____`); options = candidate
fills. The gold standard for grammar, vocabulary, formulas.

- One blank per question. For a two-blank stem, options pair the fills: `① a rempli / ② sont partis`
  — max two blanks, and each wrong pairing must encode one named misconception.
- The blank must be **decidable from the stem alone** (no "what fits best" vibes — exactly one fill
  is grammatically/mathematically valid).

### 2. Chasse à l'erreur (error hunt)

Stem = a short **worked solution / student sentence / experiment protocol** with exactly ONE planted,
_typical_ error; options = the step/segment where it hides (label steps ①→④ in the stem).
Already an expert archetype (`expert-exercises.md` #4) — usable from d2 upward.

- The planted error comes from the subject's trap taxonomy, never a typo.
- Explanation names the error AND gives the corrected step (it may state the solution's final result
  is wrong — say so explicitly, this format is exempt from the "explanation contradicts key" QA rule).

### 3. Appariement (matching, encoded)

Stem lists **≤3 left items** (①②③) and **3–4 right items** (a–d); options = complete pairings
(`①-b · ②-a · ③-c`). Vocabulary↔definition, auteur↔œuvre, organe↔fonction, unité↔grandeur.

- Distractors are **misconception pairings** (swap exactly the two confusable items), never random
  permutations — with 3 pairs there are 6 permutations, pick the 3 plausible wrong ones.
- Keep right-items ≥ left-items (an unused right item kills pure elimination).

### 4. Remise en ordre (sequencing, encoded)

Stem lists **3–5 steps out of order**, each labeled (①→⑤); options = candidate orders
(`③ → ① → ④ → ②`). Chronologies, protocol steps, solving steps, narrative order, life cycles.

- Wrong orders must be _believable_ — each encodes one specific confusion (swap the two commonly
  inverted steps), not a scramble.
- Never rely on display letters: the labels live in the stem text, so shuffling is harmless.

### 5. QCM visuel (SVG figure — stem and/or options)

The stem carries an inline SVG (geometric figure, schema, graph, matrix) and/or **each option is
itself a small SVG** (visual answers: the completed figure, the correct circuit, the next shape).
This is the `content-iq-training` house style — reuse its SVG craft rules (clean `viewBox`,
minimum stroke 2, no color-only distinction, standard digits in labels).

- One `<svg>` per field — a stem may have one figure, and each option one drawing.
- Keep option SVGs the same size/viewBox so the choice is about content, not layout.
- Any label inside the SVG follows `math-and-notation.md` (Western digits, LTR runs).

### 6. Lecture de document / données

Stem = a small **data table (drawn in SVG or laid out in plain text), experiment result, graph, or
short document**, then a question that requires **interpreting it** before any recall/computation.
Expert archetype #7 — the backbone of SVT/physique/histoire-géo hard tiers, and reading
comprehension for languages.

- All data needed must be in the document; no outside facts beyond the chapter's scope.
- Chain it: a d3/d4 exercise can reuse ONE document across 2–3 successive questions (each question
  restates what it needs — independence rule).

### 7. Histoire-problème séquentielle (story quest)

The exercise's 6 questions form **one continuous RPG scenario** (a market day, a lab investigation,
a dungeon crawl) — each question is the next episode, in the house manga/RPG voice. This is the
flagship "innovant" format: same schema, radically better experience.

- Each question **restates the data it needs** (a player who missed Q2 can still do Q3 — no hidden
  state, the server scores independently).
- The narrative escalates with the per-question difficulty ramp (tags 1→3).
- Perfect for `04-defi` (challenge) files and dungeon-flavored practice.

### 8. Vrai/faux motivé

Stem = one claim (or 4 close claims); options = **verdict + justification** ("Vrai, car…" /
"Faux, car…"). The verdict alone is a coin flip — the justification is what's tested.
Expert archetype #5.

- Exactly one option carries BOTH the right verdict and the right reason; a right verdict with a
  wrong reason is a distractor (and the explanation says why).

### 9. Sprint chrono (timed mental round)

A `boss`-mode exercise **designed for the 20 s/question timer**: short stems, mental-computable
numbers, instant-recall grammar. The interaction IS the time pressure.

- 6–10 questions, stems ≤ 15 words, zero reading friction, no SVG.
- Numbers chosen for mental paths (×5, ×9, complements to 100); distractors = the classic slip
  under speed (digit swap, sign slip, off-by-one).
- Title it as a sprint (⚡) and keep it d2–d3; never make a sprint the only path to core progression.

### 10. Cas limite & transformation contrainte

Two expert archetypes (#6, #8) that read as interactive because the student _does_ something:
find the counter-example that breaks the rule; rewrite under two simultaneous constraints (options =
candidate rewrites). Use them to diversify d3–4 tiers — see `expert-exercises.md`.

## Composition rules (what makes a set feel interactive)

- **Variety quota:** a dedicated interactive exercise mixes **≥3 formats** across its 6 questions
  (e.g. 2 story + 2 visual + 1 matching + 1 error-hunt) — unless it IS a single-format special
  (story quest, sprint chrono).
- **Complement, never replace.** Interactive files take the **next free `NN`** in an existing
  chapter ladder (e.g. `05-mission-interactive.json`, `06-sprint-chrono.json`); they never rewrite
  or renumber the canonical `01-pratique`/`02-boss`/`04-defi` ladder, and never duplicate its
  questions (`generation-pipeline.md` rules).
- **Free tier gets interactivity too.** Keep at least one interactive format present in d1–2 files —
  interactivity is a product differentiator, not a premium perk. Premium d3–4 gets the heavy
  formats (document chains, story défis).
- **Same bar, same gates.** Every question still clears `quality-bar.md` (single defensible key,
  executed-error distractors, explanation that teaches) and the self-verification protocol, then
  `content:check` + `content:qa:strict`.

## Anti-patterns (instant rejects)

- Referencing display letters ("l'option A est…") anywhere — options are shuffled.
- A question that only makes sense if the previous one was answered correctly.
- Matching/ordering options that differ only by an implausible permutation (elimination gift).
- A "story" that is six unrelated questions wearing a costume — the scenario must carry data or
  stakes into the stems.
- Multi-select semantics faked as "Which propositions are true? a) 1+2 b) 2+3…" — that is Tier B;
  the combinatorial options test elimination, not knowledge. (Exception: exactly the vrai/faux
  motivé shape above, which stays single-claim.)
- SVG walls: more than one figure per field, or decorative SVG that carries no information.
