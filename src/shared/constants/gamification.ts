// Centralized gameplay constants — single source of truth for all thresholds, timers, and rewards.

/** Minimum score percentage to pass an exercise */
export const PASS_THRESHOLD_PCT = 60;

/**
 * Minimum score percentage to pass a chapter's mandatory comprehension quiz.
 * Until a chapter's `mode='quiz'` exercise is passed at or above this score,
 * the chapter's practice/boss exercises stay locked (enforced server-side).
 */
export const QUIZ_PASS_THRESHOLD_PCT = 80;

/**
 * Minimum plausible seconds per question. An attempt completed faster than
 * (questions × this) is treated as "too fast to be real" — it earns no XP/coins
 * (server-enforced in submit_exercise_attempt) and does NOT satisfy the
 * comprehension-quiz gate. Mirrors the 4s/question used in the scoring RPC.
 */
export const MIN_SECONDS_PER_QUESTION = 4;

/** Score threshold for half coin reward */
export const HALF_COIN_THRESHOLD_PCT = 40;

/** Ideal time per question in seconds (used in speed bonus calculation) */
export const IDEAL_TIME_PER_QUESTION_S = 30;

/** Minimum duration floor for speed calculation (prevents gaming via instant submit) */
export const MIN_DURATION_FLOOR_S = 15;

/** Speed factor bounds */
export const SPEED_FACTOR_MIN = 0.5;
export const SPEED_FACTOR_MAX = 1.4;

/** Badge: speed_demon threshold in seconds */
export const SPEED_DEMON_THRESHOLD_S = 60;

/** Badge: streak milestone */
export const STREAK_BADGE_THRESHOLD = 7;

/** XP per level (linear model) */
export const XP_PER_LEVEL = 200;

/** Spaced repetition intervals in milliseconds */
export const SPACED_REPETITION_INTERVALS_MS = [
  1 * 86_400_000, // 1 day
  3 * 86_400_000, // 3 days
  7 * 86_400_000, // 7 days
] as const;

/** Maximum difficulty level */
export const MAX_DIFFICULTY_LEVEL = 4;

/** Minimum difficulty level */
export const MIN_DIFFICULTY_LEVEL = 1;

/** Threshold to increase difficulty (recent average > this) */
export const DIFFICULTY_INCREASE_THRESHOLD = 75;

/** Threshold to decrease difficulty (recent average < this) */
export const DIFFICULTY_DECREASE_THRESHOLD = 40;

/** Number of recent attempts used for difficulty adaptation */
export const RECENT_ATTEMPTS_WINDOW = 10;

/** Leaderboard max entries */
export const LEADERBOARD_LIMIT = 50;

/**
 * Étude 22 R-23 (Q-1, arbitrée) — seuil à partir duquel l'onglet « Ma classe » devient
 * l'onglet PAR DÉFAUT du classement, silencieusement.
 *
 * Sous ce seuil la cohorte est trop maigre pour être motivante : arriver 2ᵉ sur 3 ne dit rien.
 * On reste alors sur « Global », et l'onglet classe montre son état d'invitation plutôt qu'un
 * podium famélique.
 */
export const GRADE_TAB_DEFAULT_MIN_RANKED = 10;

/** Dashboard recent attempts limit */
export const DASHBOARD_RECENT_LIMIT = 50;

/** Default daily objectives created when none exist */
export const DEFAULT_DAILY_OBJECTIVES = [
  { type: "10_min", target: 10, xp: 50, coins: 10 },
  { type: "3_exercises", target: 3, xp: 75, coins: 15 },
] as const;

/** Default weekly quests created when none exist */
export const DEFAULT_WEEKLY_QUESTS = [
  { type: "maintain_streak_5", target: 5, xp: 150, coins: 30 },
  { type: "beat_2_bosses", target: 2, xp: 200, coins: 50 },
] as const;

/** Boss mode: time per question in seconds */
export const BOSS_TIME_PER_QUESTION_S = 20;

// ---------------------------------------------------------------------------
// Dungeon access gate — the Dungeon requires real prior progress, and the
// number of daily runs scales with the player's level.
// NOTE: these thresholds are mirrored in SQL (get_dungeon_access /
// start_dungeon_run); keep both in sync.
// ---------------------------------------------------------------------------

/** Daily dungeon runs = min(level, this cap). Level 0 ⇒ 0 ⇒ no access. */
export const DUNGEON_MAX_RUNS_PER_DAY = 5;

/** Distinct subjects the player must have attempted to unlock the Dungeon. */
export const DUNGEON_REQUIRED_SUBJECTS = 2;

/** Distinct chapters the player must have attempted to unlock the Dungeon. */
export const DUNGEON_REQUIRED_CHAPTERS = 3;

/** Max dungeon runs allowed per day for a given level. */
export function dungeonRunsPerDay(level: number): number {
  return Math.max(0, Math.min(level, DUNGEON_MAX_RUNS_PER_DAY));
}

/** Cost in Coins to recover a lost streak */
export const STREAK_RECOVERY_COST = 15;

// ---------------------------------------------------------------------------
// Duels (étude 05 — duels temps réel & ligues). 1v1 on a frozen question set
// drawn from the two players' shared parcours. Duels are an ENGAGEMENT feature,
// open to ALL parcours (FREE + premium) — unlike the Dungeon (a premium perk) —
// so the matchmaking queue stays deep (Q-4 resolved: no entitlement gate).
// NOTE: these values are mirrored in SQL (match_duel / submit_duel_answer /
// finalize_duel); keep both in sync, same discipline as the Dungeon constants.
// ---------------------------------------------------------------------------

/** Number of questions in a duel set (frozen at matchmaking, identical for both). */
export const DUEL_QUESTION_COUNT = 5;

/** A duel with no result by this many hours after creation expires (async tolerance). */
export const DUEL_EXPIRY_HOURS = 24;

/** At most this many simultaneously-active duels per player (R-10). */
export const DUEL_MAX_ACTIVE = 3;

/**
 * At most this many REWARDED duels per player per day (anti-farm, R-7). Beyond
 * the cap a duel is still playable but grants 0 XP / 0 coins. Mirrors the
 * Dungeon daily-run cap so the two competitive loops stay balanced.
 */
export const DUEL_MAX_REWARDED_PER_DAY = 5;

/**
 * Duel reward tiers (Q-1 resolved). Anchored to the practice-exercise economy
 * (a full exercise ≈ 75 XP / 15 coins): a win is a touch below that, a loss is
 * a real participation reward (never negative — R-8), a draw sits between. A
 * forfeit win (opponent expired without finishing) pays the win tier.
 */
export const DUEL_REWARDS = {
  win: { xp: 60, coins: 12 },
  draw: { xp: 40, coins: 8 },
  loss: { xp: 20, coins: 4 },
} as const;

/**
 * Highest exercise difficulty included in a premium parcours' FREE PREVIEW.
 * In a premium parcours WITHOUT an entitlement, the chapter comprehension quiz
 * and difficulty-1 (⭐) missions are free; difficulty >= 2 requires unlocking the
 * parcours. The server gate (resolve_exercise_access RPC) is authoritative; this
 * mirrors the rule for the lock/preview affordances in the UI.
 */
export const FREE_PREVIEW_MAX_DIFFICULTY = 1;

// --- Recall mode (étude 17) — mirrors the SQL constants of the recall
// migrations; the server gates are authoritative, these drive the UI. ---

/**
 * XP multiplier for a successful recall session (R-5). Mirrors the `1.5`
 * factor in `submit_exercise_attempt`'s recall branch — playing without the
 * options is harder, so it pays more (same anti-farm gates apply).
 */
export const RECALL_XP_MULTIPLIER = 1.5;

/**
 * Minimum recall-eligible questions for a mission to offer the recall mode
 * (R-2). Below this the chip is never shown (US-6, no dead end). Mirrors the
 * `>= 3` eligibility check in `get_recall_availability` / the start gate.
 */
export const RECALL_MIN_QUESTIONS = 3;

/**
 * Classic score (%) that unlocks a mission's recall mode (R-3): a 100% classic
 * run (not rushed). Mirrors the `score_pct = 100` unlock check server-side.
 */
export const RECALL_UNLOCK_SCORE_PCT = 100;

/**
 * Client-side cap on a typed recall answer's length. Eligible target answers
 * are 1–60 chars by construction (R-2c), so 120 is generous; the wire bound
 * stays `MAX_CHOICE_LENGTH` (512). Purely a UI guard against runaway input.
 */
export const RECALL_MAX_ANSWER_LENGTH = 120;
