# Rewards, modes & difficulty

Source: `src/shared/constants/gamification.ts`, `src/shared/content/schema.ts`,
`src/shared/content/sql-builder.ts`, and the reward distribution across existing exercises.

## Modes

| mode        | author it? | notes                                                                     |
| ----------- | ---------- | ------------------------------------------------------------------------- |
| `practice`  | yes        | standard practice exercise                                                |
| `boss`      | yes        | chapter boss; timed at 20s/question at runtime                            |
| `challenge` | yes        | premium "Défi élite" tier                                                 |
| `quiz`      | **no**     | auto-generated from `quiz.json`; `display_order=0`, fixed 20 XP / 5 coins |

`practice|boss|challenge` is the full authorable enum. Multiple files may share a mode (e.g. both
`02-boss` and `05-entrainement` use `boss`); the filename slug carries the finer role.

## Difficulty

- **Exercise** `difficulty`: 1–4 → 1 easy · 2 medium · 3 boss · 4 élite.
- **Question** `difficulty`: 1–3 (optional, untagged = 2). Questions are emitted easiest→hardest, so
  difficulty tags set ordering — keep them deliberate.
- **Premium gate: difficulty ≥ 3 requires an active subscription** (`PREMIUM_MIN_DIFFICULTY = 3`).
  Therefore keep **core, free progression at difficulty 1–2**; reserve 3–4 for paid boss/challenge.

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

| difficulty | mode      | xpReward | rewardCoins | use                                     |
| ---------- | --------- | -------- | ----------- | --------------------------------------- |
| 1          | practice  | 50       | 10          | free intro practice                     |
| 2          | practice  | 75       | 15          | free standard practice                  |
| 3          | boss      | 120      | 30          | chapter boss (premium)                  |
| 4          | challenge | 300      | 60          | élite challenge (premium + level)       |
| (auto)     | quiz      | 20       | 5           | generated from quiz.json — never author |

Keep boss at difficulty 3 and challenge at difficulty 4 (the dominant pattern); avoid off-pattern
combos like `difficulty:4, mode:boss` or `difficulty:3, mode:practice`. Coins track XP at roughly
1 coin per 5 XP. The optional `03-revision` step uses practice/d2 with ~70/15.

## Scoring thresholds you must design around (server-enforced)

| constant                   | value | meaning for authoring                                                                       |
| -------------------------- | ----- | ------------------------------------------------------------------------------------------- |
| `PASS_THRESHOLD_PCT`       | 60    | min score to pass an exercise                                                               |
| `QUIZ_PASS_THRESHOLD_PCT`  | 80    | quiz must be passed ≥80% (and not rushed) to unlock the chapter's exercises                 |
| `MIN_SECONDS_PER_QUESTION` | 4     | attempts under `4s × questions` earn nothing & don't satisfy the gate — keep ≥5–6 questions |
| `HALF_COIN_THRESHOLD_PCT`  | 40    | 40–59% → half coins; <40% → none                                                            |
| `improved`                 | —     | re-attempts only re-award on an improved score (anti-farm)                                  |

Don't set rewards expecting them to apply on a sub-60%, rushed, or non-improving attempt — the engine
won't grant them. Don't put essential free progression behind difficulty 3–4 (it's paywalled).
