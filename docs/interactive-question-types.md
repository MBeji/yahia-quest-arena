# Interactive question types — engine evolution spec (Tier B)

> **Phase B1 (`numeric`) SHIPPED 2026-07-05** (étude `FableEtudes/03-types-questions-natifs`,
> lots B1.1–B1.4: `score_answer` seam + typed keys, per-type server validation, unified
> `<QuestionInput>`/`NumericInput`, pipeline union schema + QA lints). `numeric` is authorable
> (shape: content-engine `references/content-schema.md`). **Phases B2 (ordering/matching) and
> B3 (multi) remain design-only** — content skills must not author those types until they ship.
> **Tier A** — interactive formats encoded inside the existing QCM schema — is live and
> canonically documented in `.claude/skills/content-engine/references/interactive-formats.md`;
> author those freely via the `content-interactif` skill. Tier B adds _native_ input types and
> requires the coordinated DB + RPC + UI + pipeline changes mapped here. Defers to CLAUDE.md
> (DoD §7 migration ordering) and ARCHITECTURE.md where they overlap.

## Why (and why not sooner)

The engine is deliberately mono-type: `questions` has no type column, `options` is
`[{id, text}]` JSONB, and **scoring is a string equality on the option id** (`q.correct_option =
a.choice`) evaluated server-side only (the answer key is hidden from clients — GAP-020). That
single assumption is replicated across five SQL `SECURITY DEFINER` RPCs — which is exactly why
Tier A exists: most interactivity ships without touching them. Tier B is justified only where
encoding breaks pedagogy: free numeric answers (no more elimination by options), true
manipulation (drag-&-drop), and multi-select judgment.

## Target data model (additive, mcq-compatible)

- `questions.question_type text NOT NULL DEFAULT 'mcq'` — new column, additive migration
  (**ships with its own `GRANT`s** — see CLAUDE.md gotcha on baseline table grants).
- `questions.answer_key jsonb NULL` — the typed key for non-mcq types; `correct_option` remains
  the key for `'mcq'` (untouched rows keep working unchanged).
- `options` keeps `[{id, text}]` for every type (items to order/match/select); unused for
  `numeric`.

| type       | options carry                    | answer_key                   | answer payload (client → RPC)   | scoring                                    |
| ---------- | -------------------------------- | ---------------------------- | ------------------------------- | ------------------------------------------ |
| `mcq`      | 2–6 choices                      | — (`correct_option`)         | `choice: "<optionId>"`          | id equality (unchanged)                    |
| `numeric`  | — (optional unit hint in prompt) | `{value, tolerance?, unit?}` | `choice: "<number as string>"`  | `abs(x − value) ≤ tolerance` (default 0)   |
| `ordering` | 3–6 steps (ids)                  | `{order: ["b","a","d","c"]}` | `choice: "b,a,d,c"` (id CSV)    | exact sequence match; no partial credit v1 |
| `matching` | left+right items (`l1…`, `r1…`)  | `{pairs: [["l1","r2"], …]}`  | `choice: "l1:r2,l2:r1,…"`       | set equality of pairs                      |
| `multi`    | 2–6 choices                      | `{correct: ["a","c"]}`       | `choice: "a,c"` (sorted id CSV) | set equality; no partial credit v1         |

Design invariants: answers stay a single string (`choice`) so the existing
`answers: [{questionId, choice}]` wire shape, rate limiting, and attempt persistence survive;
scoring stays all-or-nothing per question (XP/anti-farm math untouched); the answer key stays
server-side (`answer_key` is **never** selected by client-facing queries — same posture as
`correct_option`).

## Touchpoint map (from the code audit — what each phase must change)

**SQL — the five type-aware scoring sites** (today all do `q.correct_option = a.choice`):
`submit_exercise_attempt` (20260601150000), `get_attempt_review` (20260610170000),
`check_answers` (20260621181000), `score_quiz` (20260630130000), `submit_dungeon_answer`
(dungeon migrations). Factor one `score_answer(question, choice) returns boolean` SQL function and
call it from all five — the equality stays the `'mcq'` fast path. pgTAP tests per type.

**Server (zod/TS):** `src/features/quest/quest.server.ts` (`submitAttempt`,
`checkAnswersPublic`, `scoreQuizPublic` — `choice` stays `z.string()`, add per-type format
validation), `src/features/dungeon/dungeon.server.ts` (`submitDungeonAnswer`); regenerate
`src/shared/integrations/supabase/types.ts` (`supabase gen types`).

**UI:** `src/features/quest/components/exercise-player.tsx` — extract the radiogroup block
(options map, keyboard handling, review display) into a per-type `<QuestionInput>`; add
`NumericInput`, `OrderingBoard` (drag or tap-to-order), `MatchingBoard`, `MultiSelect`.
`src/shared/lib/question-utils.ts` — `shuffleOptions`/`DisplayOption` generalize (ordering/matching
shuffle but carry no A–D display letters). `src/routes/_authenticated/dungeon.tsx` duplicates the
options block — unify on `<QuestionInput>` while there. RTL/bidi and SVG rendering reuse
`RichField`/`OptionContent` unchanged.

**Content pipeline:** `src/shared/content/schema.ts` — `questionSchema` becomes a discriminated
union on `type` (default `'mcq'` keeps every existing file valid without edits);
`sql-builder.ts` emits `question_type`/`answer_key`; `content:qa` gains per-type lints (numeric
tolerance sanity, ordering/matching id integrity, multi key ≥2). Then `content-engine`
references + `content-interactif` gain the authoring rules and the Tier-B ban lifts per phase.

## Phasing (each phase = migration lands first, code follows — DoD §7)

1. **B1 `numeric`** — highest pedagogy/effort ratio (math/physique: kills elimination), smallest
   UI (one input). Proves the `score_answer` seam end-to-end.
2. **B2 `ordering` + `matching`** — the real drag-&-drop payoff; supersedes the encoded Tier-A
   permutation formats for new content (encoded variants stay valid).
3. **B3 `multi` (+ optional multi-blank cloze select)** — judgment items; needs the clearest UX
   ("select ALL that apply") to stay fair.

Each phase: additive migration (+grants, timestamp-ordered) → pgTAP → RPC seam → zod/UI behind the
type switch → pipeline schema + QA lints → skills updated → `smoke:shell`/e2e cover the new input.
Rollback posture: a type never breaks `'mcq'` paths; a feature-flagged renderer can fall back to
showing the item as unavailable rather than crashing a session.

## Non-goals

- Free-text / essay grading (no reliable server-side grader; out of product scope).
- Partial credit and per-question hints economics changes (revisit after B2 telemetry).
- Per-record translation or any change to the one-language-per-subject model.
- Renaming legacy slugs/ids as part of this work (slugs are UUIDv5 identity).
