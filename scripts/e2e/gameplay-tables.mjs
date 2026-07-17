/**
 * Tables cleared by reset-gameplay.mjs between E2E runs.
 * Kept in a side-effect-free module so unit tests can import this list
 * without triggering the reset script's DB connection.
 *
 * Order: children before parents (FK constraints). Tolerant reset: a missing
 * table is silently skipped, not fatal.
 *
 * When adding a new mutable gameplay table, add it HERE (not inline in
 * reset-gameplay.mjs) so the unit-test coverage catches omissions.
 */
export const GAMEPLAY_TABLES = [
  "attempts",
  "dungeon_run_questions",
  "dungeon_runs",
  "spaced_repetition_schedule",
  "daily_objectives",
  "weekly_quests",
  "difficulty_adaptation",
  "student_badges",
  "inventory_items",
  "exercise_assignments",
  "rate_limit_events",
  // User-submitted reports: the nightly E2E spec submits one per run; without
  // clearing these they accumulate and pollute the production-triage queue.
  "content_reports",
  "bug_reports",
];
