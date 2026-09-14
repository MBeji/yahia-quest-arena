/**
 * Tables cleared by reset-gameplay.mjs between E2E runs.
 * Kept in a side-effect-free module so unit tests can import this list
 * without triggering the reset script's DB connection.
 *
 * Order: children before parents (FK constraints). Tolerant reset: a missing
 * table is silently skipped, not fatal.
 *
 * When adding a new mutable gameplay table, add it HERE (not inline in
 * reset-gameplay.mjs). ⚠️ The co-located test spot-checks NAMED tables whose
 * omission has a known cost — it cannot detect a table nobody thought of, so
 * adding the line here is still a human step.
 */
export const GAMEPLAY_TABLES = [
  "attempts",
  // Le grand livre des étoiles et des sceaux (étude 34). Il doit partir avec le
  // reste, et pour une raison que les autres tables n'ont pas : il est
  // **insert-only et monotone** (R-6). Une étoile inscrite ne se retire jamais,
  // donc sans ce nettoyage le premier run laisse le décor DÉFINITIVEMENT acquis —
  // et toute assertion sur un delta (`starAfter > starBefore`, un sceau qui tombe,
  // un badge de maîtrise) passe une fois puis échoue à chaque run suivant, sur un
  // code pourtant sain. `student_badges` est déjà vidé juste en dessous, mais cela
  // ne suffit pas : les trois badges ne se décernent que lorsqu'un sceau est
  // réellement INSÉRÉ, donc un grand livre survivant les rend indécernables.
  "user_subject_seals",
  "user_chapter_stars",
  "dungeon_run_questions",
  "dungeon_runs",
  "spaced_repetition_schedule",
  "daily_objectives",
  "weekly_quests",
  "student_badges",
  "inventory_items",
  "exercise_assignments",
  "rate_limit_events",
  // User-submitted reports: the nightly E2E spec submits one per run; without
  // clearing these they accumulate and pollute the production-triage queue.
  "content_reports",
  "bug_reports",
];
