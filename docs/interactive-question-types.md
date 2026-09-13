# Interactive question types — engine evolution spec (Tier B)

> **All three phases SHIPPED (2026-07-05 → 2026-07-06)** — étude
> `FableEtudes/03-types-questions-natifs`: `score_answer` seam + typed keys, per-type server
> validation, unified `<QuestionInput>` (`NumericInput`, @dnd-kit `OrderingBoard`/
> `MatchingBoard`, `MultiSelect`), pipeline union schema + QA lints. **`numeric`, `ordering`,
> `matching` and `multi` are ALL authorable now** (shapes: content-engine
> `references/content-schema.md`). This spec is fully executed.
>
> **La clôture « no more Tier-B types » est LEVÉE par l'étude 20** (volet B, lot 7, 2026-07-27) :
> un sixième type natif, `short_answer`, a rejoint le cadre — la question libre SANS
> propositions, corrigée par appartenance à un ensemble de réponses acceptées. Elle n'a demandé
> aucune colonne nouvelle et aucun écran nouveau : c'est la démonstration que la seam tient. Toute
> évolution ULTÉRIEURE du moteur demande, elle, une nouvelle étude.
> **Tier A** — interactive formats encoded inside the existing QCM schema — is live and
> canonically documented in `content-engine/references/interactive-formats.md`;
> author those freely via the `content-interactif` skill. Tier B adds _native_ input types and
> requires the coordinated DB + RPC + UI + pipeline changes mapped here. Defers to AGENTS.md
> (DoD §7 migration ordering) and ARCHITECTURE.md where they overlap.
>
> 📦 **Since étude 24 (2026-07-20)** the corpus, the `content-*`/`prof-*` skills (hence every
> `content-engine/references/*` file cited below) and the études live in the PRIVATE repo
> `MBeji/yahia-quest-content`. The engine described here — `src/shared/content/`, `scripts/content/`,
> the SQL functions and the UI — stays in this public repo. See
> [`docs/content-generation-pipeline.md`](./content-generation-pipeline.md).

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
  (**ships with its own `GRANT`s** — see AGENTS.md gotcha on baseline table grants).
- `questions.answer_key jsonb NULL` — the typed key for non-mcq types; `correct_option` remains
  the key for `'mcq'` (untouched rows keep working unchanged).
- `options` keeps `[{id, text}]` for every type (items to order/match/select); unused for
  `numeric`.

| type           | options carry                    | answer_key                   | answer payload (client → RPC)   | scoring                                                                                                               |
| -------------- | -------------------------------- | ---------------------------- | ------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `mcq`          | 2–6 choices                      | — (`correct_option`)         | `choice: "<optionId>"`          | id equality (unchanged)                                                                                               |
| `numeric`      | — (optional unit hint in prompt) | `{value, tolerance?, unit?}` | `choice: "<number as string>"`  | `abs(x − value) ≤ tolerance` (default 0)                                                                              |
| `ordering`     | 3–6 steps (ids)                  | `{order: ["b","a","d","c"]}` | `choice: "b,a,d,c"` (id CSV)    | exact sequence match; no partial credit v1                                                                            |
| `matching`     | left+right items (`l1…`, `r1…`)  | `{pairs: [["l1","r2"], …]}`  | `choice: "l1:r2,l2:r1,…"`       | set equality of pairs                                                                                                 |
| `multi`        | 2–6 choices                      | `{correct: ["a","c"]}`       | `choice: "a,c"` (sorted id CSV) | set equality; no partial credit v1                                                                                    |
| `short_answer` | — (aucune proposition)           | `{text, mistakes?}`          | `choice: "<texte tapé>"`        | appartenance à { canonique } ∪ `accepted_answers`, normalisée (étude 20), **puis arbitrage IA d'un refus (étude 33)** |

### ⚠️ `short_answer` est le seul type dont le SERVICE est conditionnel (étude 33, 2026-09-13)

Arbitrage du propriétaire : **une question ouverte n'est proposée qu'à un élève dont le mode IA
est activé, et sa réponse est vérifiée par l'IA.** Les cinq autres types sont servis à tout le
monde, toujours ; celui-ci ne l'est pas, et c'est la seule asymétrie du tableau ci-dessus.

La raison tient à l'asymétrie du verdict déterministe : l'appartenance à l'ensemble
`{ canonique } ∪ accepted_answers` a raison quand elle **accepte** et ne sait pas quand elle
**refuse**. Une formulation juste que personne n'avait prévue était comptée fausse, sans recours
synchrone (« فوق الشجرة » là où la clé disait « فوقها », relevé en production). Plutôt que de
servir la question à tous avec ce risque, on ne la sert qu'à qui dispose d'un juge.

| élément                            | où                                                                      |
| ---------------------------------- | ----------------------------------------------------------------------- |
| la porte                           | `public.can_play_open_questions(élève)` — chemin FAMILLE uniquement     |
| son application                    | `public.is_question_in_play(question, porte)`                           |
| la surface IA à activer            | `open_answer` (`AI_LIVE_FEATURES`, `src/shared/constants/ai.ts`)        |
| le filet                           | `ai_open_answer_verdicts` + la branche `short_answer` de `score_answer` |
| le juge (gabarit, schéma, lecture) | `src/shared/integrations/ai/open-answer.ts`                             |
| l'orchestration                    | `src/shared/integrations/ai/open-answer.server.ts` (`callAi` INJECTÉ)   |
| le câblage côté quête              | `src/features/quest/quest.open-questions.ts`                            |

Quatre invariants tiennent le filet, et il faut les connaître avant d'y toucher :

1. **le modèle ne peut qu'AJOUTER** — il n'est consulté que sur une réponse déjà refusée, donc
   il ne peut retirer aucune acceptation ; le déterministe reste le plancher ;
2. **il ne peut pas rendre juste ce que l'auteur a déclaré faux** — `record_ai_open_answer_verdict`
   refuse en SQL une acceptation qui égalerait une `answer_key -> mistakes` (é20 R-4). La garantie
   n'est pas dans le prompt ;
3. **il n'écrit pas dans le corpus** — `accepted_answers` reste un fichier versionné relu dans un
   diff (é20 R-7). Le verdict est PAR ÉLÈVE, pour UN texte, sur UNE question ;
4. **une panne ne change rien** — pas de verdict ⇒ le comportement d'avant l'étude 33.

⚠️ **Le service ET le dénominateur, jamais l'un sans l'autre.** Retirer la question de l'écran
sans la retirer du total la laisserait sans réponse, donc fausse : une mission de 9 questions
jouée sur 8 et notée sur 9. `submit_exercise_attempt`, `score_quiz` et `get_attempt_review`
portent donc la même garde que le service.

**Trois surfaces excluent `short_answer` sans condition** : le **duel** (le jeu de questions est
FIGÉ et PARTAGÉ — une porte par élève le rendrait inéquitable), le **donjon** et le **bac blanc**
(CHRONOMÉTRÉS — un aller-retour vers un modèle au milieu d'un compte à rebours prendrait du temps
d'épreuve, et seulement à ceux qui formulent autrement). Le pilote d'é20 lot 8 vit dans le lecteur
de quête ; c'est là, et là seulement, que la porte s'ouvre.

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
