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
  -- 'challenge' est inclus des ici (ajout du 2026-07-20, suite a l'etude 24 lot 4).
  -- Le mode 'challenge' n'a jamais eu de migration de schema propre : chaque migration de
  -- contenu GENEREE portait un garde idempotent qui elargissait la contrainte juste avant
  -- d'inserer. Ces migrations ayant quitte le repo public (#544), le garde est parti avec
  -- elles -- mais trois migrations de contenu ECRITES A LA MAIN, maintenues au public, y
  -- inserent des exercices 'challenge' entre cette migration-ci et le repose-contrainte du
  -- lot 3b (20260720190000) : 20260604150000, 20260604170000 et 20260604180000. Sur une base
  -- vierge elles violaient donc exercises_mode_check. Elargir ici, au moment ou la contrainte
  -- est posee, est le point de correction naturel ; la prod ne rejoue pas cette migration et
  -- porte deja la contrainte large.
  ALTER TABLE public.exercises
    ADD CONSTRAINT exercises_mode_check CHECK (mode IN ('practice', 'boss', 'quiz', 'challenge'));
END
$$;

-- Helps the gate look up a chapter's quiz attempts quickly.
CREATE INDEX IF NOT EXISTS idx_exercises_chapter_mode ON public.exercises(chapter_id, mode);
