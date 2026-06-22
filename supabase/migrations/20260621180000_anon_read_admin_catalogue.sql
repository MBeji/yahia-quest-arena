-- C8 / L0.2 — Public-first: allow ANONYMOUS read of the ADMIN catalogue
-- (exercises + their questions) so courses & exercises are browsable without login.
--
-- 20260522153000_family_content_rewards restricted exercises/questions SELECT to
-- auth.role() = 'authenticated'. The public-first pivot needs the `anon` role to
-- read admin-sourced catalogue rows too. We ADD permissive policies scoped TO anon
-- and to source = 'admin' only — parent-authored rows (source = 'parent') stay
-- private. Permissive policies are OR-combined, so the existing authenticated
-- policies are unchanged.
--
-- Answer-key safety: questions' column grants (20260610170000_hide_answer_key)
-- already restrict ALL client roles (incl. anon) to
-- (id, exercise_id, prompt, options, display_order); correct_option/explanation
-- stay reachable only via the SECURITY DEFINER RPCs (get_attempt_review,
-- consume_hint). This migration does NOT touch column grants — the key stays
-- masked for anon.
--
-- Grants: anon already has table SELECT on exercises (20260612221000 baseline) and
-- the column-level SELECT on questions (20260610170000), so no new GRANTs here.
-- Lesson text lives in chapters.lesson_content / chapters.summary, already
-- anon-readable (chapters RLS is USING(true) + baseline grant).

DROP POLICY IF EXISTS "Admin exercises readable by anon" ON public.exercises;
CREATE POLICY "Admin exercises readable by anon"
  ON public.exercises
  FOR SELECT
  TO anon
  USING (source = 'admin');

DROP POLICY IF EXISTS "Admin questions readable by anon" ON public.questions;
CREATE POLICY "Admin questions readable by anon"
  ON public.questions
  FOR SELECT
  TO anon
  USING (
    EXISTS (
      SELECT 1
      FROM public.exercises e
      WHERE e.id = questions.exercise_id
        AND e.source = 'admin'
    )
  );
