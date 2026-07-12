# Rewards, modes & difficulty

Source: `src/shared/constants/gamification.ts`, `src/shared/content/schema.ts`,
`src/shared/content/sql-builder.ts`, and the reward distribution across existing exercises.

## Modes

| mode        | author it? | notes                                                                     |
| ----------- | ---------- | ------------------------------------------------------------------------- |
| `practice`  | yes        | standard practice exercise                                                |
| `boss`      | yes        | chapter boss; timed at 20s/question at runtime                            |
| `challenge` | yes        | "Défi élite" tier — d4 ceiling (dormant premium gate)                     |
| `quiz`      | **no**     | auto-generated from `quiz.json`; `display_order=0`, fixed 20 XP / 5 coins |

`practice|boss|challenge` is the full authorable enum. Multiple files may share a mode (e.g. both
`02-boss` and `05-entrainement` use `boss`); the filename slug carries the finer role.

## Difficulty

- **Exercise** `difficulty`: 1–4 → 1 easy · 2 medium · 3 boss · 4 élite.
- **Question** `difficulty`: 1–3 (optional, untagged = 2). Questions are emitted easiest→hardest, so
  difficulty tags set ordering — keep them deliberate.
- **Premium gate (dormant in the current free phase): difficulty 3–4 are the premium-gate ceiling
  _per parcours_** — a premium parcours would require a live entitlement to unlock them, with the
  chapter comprehension quiz + every difficulty-1 (⭐) mission always open as the free preview.
  Enforced server-side by `resolve_exercise_access` (see CLAUDE.md "Access gate"), but every
  parcours is currently `is_premium=false` (2026-06-21 pivot + étude 15 Q-2) — **nothing is gated
  today**, all difficulties are open to everyone. Still author as if it mattered: keep **core
  progression at difficulty 1–2**; reserve 3–4 for boss/challenge, so the free-preview shape stays
  correct whenever premium reactivates (frozen étude `FableEtudes/01-paiement-en-ligne`).

### Difficulty indicator — show it on every mission & quiz

Every exercise (mission) and the quiz must display its level in its **title**, using this standard
scale (localize the label to the content language; the stars are universal). This is in addition to
the schema `difficulty` field (which the engine uses for gating/ordering):

| difficulty     | stars    | FR               | EN            | AR    |
| -------------- | -------- | ---------------- | ------------- | ----- |
| 1              | ⭐       | Facile           | Easy          | سهل   |
| 2              | ⭐⭐     | Moyen            | Medium        | متوسط |
| 3              | ⭐⭐⭐   | Difficile / Boss | Hard / Boss   | صعب   |
| 4              | ⭐⭐⭐⭐ | Élite            | Elite         | نخبة  |
| quiz (auto d1) | ⭐       | Compréhension    | Comprehension | فهم   |

## Canonical reward table (use these)

| difficulty | mode      | xpReward | rewardCoins | use                                              |
| ---------- | --------- | -------- | ----------- | ------------------------------------------------ |
| 1          | practice  | 50       | 10          | free intro practice                              |
| 2          | practice  | 75       | 15          | free standard practice                           |
| 3          | boss      | 120      | 30          | chapter boss (parcours premium-gate, dormant)    |
| 4          | challenge | 300      | 60          | élite challenge (parcours premium-gate, dormant) |
| (auto)     | quiz      | 20       | 5           | generated from quiz.json — never author          |

Keep boss at difficulty 3 and challenge at difficulty 4 (the dominant pattern); avoid off-pattern
combos like `difficulty:4, mode:boss` or `difficulty:3, mode:practice`. Coins track XP at roughly
1 coin per 5 XP. The optional `03-revision` step uses practice/d2 with ~70/15.

## Scoring thresholds you must design around (server-enforced)

| constant                   | value | meaning for authoring                                                                                                 |
| -------------------------- | ----- | --------------------------------------------------------------------------------------------------------------------- |
| `PASS_THRESHOLD_PCT`       | 60    | min score to pass an exercise                                                                                         |
| `QUIZ_PASS_THRESHOLD_PCT`  | 80    | quiz ≥80% (not rushed) unlocks a chapter's exercises — **school-program subjects only; non-school themes never gate** |
| `MIN_SECONDS_PER_QUESTION` | 4     | attempts under `4s × questions` earn nothing & don't satisfy the gate — keep ≥5–6 questions                           |
| `HALF_COIN_THRESHOLD_PCT`  | 40    | 40–59% → half coins; <40% → none                                                                                      |
| `improved`                 | —     | re-attempts only re-award on an improved score (anti-farm)                                                            |

Don't set rewards expecting them to apply on a sub-60%, rushed, or non-improving attempt — the engine
won't grant them. Don't put essential free progression behind difficulty 3–4 (those are the dormant
premium-gate ceiling; today every difficulty is free, but keep the quiz + difficulty-1 missions as
the self-contained core so the free-preview shape stays correct whenever premium reactivates).
