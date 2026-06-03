-- =========================================================
-- Chapter comprehension quiz
-- ---------------------------------------------------------
-- Allow exercises.mode = 'quiz' for the mandatory per-chapter
-- comprehension quiz that gates access to practice/boss exercises.
-- The access gate itself is enforced in application server code
-- (startExerciseSession) against the `attempts` table.
-- =========================================================

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'exercises_mode_check') THEN
    ALTER TABLE public.exercises DROP CONSTRAINT exercises_mode_check;
  END IF;
  ALTER TABLE public.exercises
    ADD CONSTRAINT exercises_mode_check CHECK (mode IN ('practice', 'boss', 'quiz'));
END
$$;

-- Helps the gate look up a chapter's quiz attempts quickly.
CREATE INDEX IF NOT EXISTS idx_exercises_chapter_mode ON public.exercises(chapter_id, mode);
