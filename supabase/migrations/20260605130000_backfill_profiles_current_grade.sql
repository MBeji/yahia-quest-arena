-- =========================================================
-- Backfill profiles.current_grade_id for pre-grade-selection accounts.
--
-- The grade-selection onboarding step (#54) sets profiles.current_grade_id for
-- new students, but accounts created before it have NULL. Those profiles work
-- today only because getDashboard falls back to "all grade-bound subjects"
-- (the 9ème année de base is the single populated grade). Once other grades
-- gain content that implicit fallback would mix grades together, so we make the
-- 9ème assignment explicit here.
--
-- Idempotent: only still-NULL profiles are touched; re-running is a no-op.
-- Pure data migration — no dependent code change (the fallback stays as a safety
-- net for any profile created between deploys).
-- =========================================================

UPDATE public.profiles
   SET current_grade_id = (
     SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '9eme-base'
   )
 WHERE current_grade_id IS NULL;
