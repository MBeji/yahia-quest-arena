-- =========================================================
-- Fix: get_best_scores_by_exercise must take a TEXT subject id
-- ---------------------------------------------------------
-- subjects.id (and attempts.subject_id) are TEXT ('math', 'french', …),
-- but the function was declared with a UUID parameter. Every call therefore
-- failed ('math'::uuid is invalid), the caller swallowed the error, and the
-- subject page never showed completed exercises (best scores / stars).
-- Redeclare the function with a TEXT parameter.
-- =========================================================

DROP FUNCTION IF EXISTS public.get_best_scores_by_exercise(uuid);

CREATE OR REPLACE FUNCTION public.get_best_scores_by_exercise(p_subject TEXT)
RETURNS TABLE(exercise_id UUID, best_score INT)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_subject IS NULL THEN
    RAISE EXCEPTION 'Subject id is required';
  END IF;

  RETURN QUERY
  SELECT a.exercise_id, MAX(a.score_pct)::INT AS best_score
  FROM public.attempts a
  WHERE a.user_id = v_user
    AND a.subject_id = p_subject
  GROUP BY a.exercise_id;
END;
$$;

REVOKE ALL ON FUNCTION public.get_best_scores_by_exercise(text) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.get_best_scores_by_exercise(text) FROM anon;
GRANT EXECUTE ON FUNCTION public.get_best_scores_by_exercise(text) TO authenticated;
