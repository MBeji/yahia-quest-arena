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

/** Cost in XP Coins to recover a lost streak */
export const STREAK_RECOVERY_COST = 15;

// ---------------------------------------------------------------------------
// Premium difficulty gate — exercises at or above this difficulty are reserved
// for paying subscribers (subscription only, no level requirement). Difficulty
// 1-2 stay free for everyone; 3+ are premium, across every subject/chapter.
// Enforced server-side in quest.startExerciseSession.
// ---------------------------------------------------------------------------

/** Lowest exercise difficulty that requires an active subscription (3 and 4 are premium). */
export const PREMIUM_MIN_DIFFICULTY = 3;
