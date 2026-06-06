-- =========================================================
-- Performance: index the FK columns on the hottest gameplay path
-- ---------------------------------------------------------
-- Postgres does NOT auto-create indexes for foreign keys. These three FKs sit on
-- the most-executed query path in the app (load subject -> load exercise ->
-- submit attempt) and were unindexed, causing sequential scans that get worse as
-- the content catalogue grows and under exam-season concurrency:
--
--   * questions.exercise_id  — read on every quest load AND every submit
--                              (getExercise, submitAttempt review, and the
--                              submit_exercise_attempt RPC join on questions).
--   * exercises.subject_id   — scanned on every subject ("parcours") page open
--                              (getSubject) and the per-subject leaderboard.
--   * chapters.subject_id    — scanned on subject + lesson navigation
--                              (getSubject chapters, getChapterLesson siblings).
--
-- Purely additive, idempotent, no code dependency. Safe to apply any time.
--
-- NOTE on locking: a plain CREATE INDEX takes a brief ACCESS EXCLUSIVE lock while
-- it builds. At the current content scale (tens of thousands of rows) this is
-- sub-second to a few seconds — fine to run in a low-traffic window. If/when
-- these tables grow large, run the CONCURRENTLY variant instead, OUTSIDE a
-- transaction (it cannot run inside one):
--   CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_questions_exercise ON public.questions(exercise_id);
-- =========================================================

CREATE INDEX IF NOT EXISTS idx_questions_exercise ON public.questions(exercise_id);
CREATE INDEX IF NOT EXISTS idx_exercises_subject  ON public.exercises(subject_id);
CREATE INDEX IF NOT EXISTS idx_chapters_subject   ON public.chapters(subject_id, display_order);
