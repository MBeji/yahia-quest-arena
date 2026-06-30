// Mirrors src/shared/constants/gamification.ts so the load profiles match the
// real product limits. Keep in sync if the app constants change.
export const LEADERBOARD_LIMIT = 50;

// Rate-limit budget the app applies before submit_exercise_attempt
// (src/features/quest/quest.server.ts:705 — "max 5 submissions per 10 seconds").
// Mirrored so the gameplay scenario reproduces the exact two-round-trip write
// path (audit C-2). Keep in sync with quest.server.ts.
export const SUBMIT_RL_MAX = 5;
export const SUBMIT_RL_WINDOW_MS = 10_000;
