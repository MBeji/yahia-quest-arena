-- Aggregate best score by exercise in DB to avoid loading unbounded attempt history in app servers.

CREATE OR REPLACE FUNCTION public.get_best_scores_by_exercise(p_subject UUID)
RETURNS TABLE(exercise_id UUID, best_score INT)
LANGUAGE plpgsql
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

REVOKE EXECUTE ON FUNCTION public.get_best_scores_by_exercise(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_best_scores_by_exercise(uuid) TO authenticated;
