// Centralized gameplay constants — single source of truth for all thresholds, timers, and rewards.

/** Minimum score percentage to pass an exercise */
export const PASS_THRESHOLD_PCT = 60;

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
