-- =========================================================
-- HOTFIX — start_exercise_session: "column reference started_at is ambiguous"
-- ---------------------------------------------------------
-- The RPC declares OUT parameters (session_id, started_at) via RETURNS TABLE.
-- Inside the final INSERT ... RETURNING, the bare `started_at` matched BOTH the
-- exercise_sessions.started_at column AND the OUT parameter of the same name, so
-- PL/pgSQL (variable_conflict = error, the default) raised SQLSTATE 42702 on EVERY
-- call. Because the companion REVOKE (20260610190000) already removed the direct
-- INSERT path, this broke quest-start entirely in production: the server fn calls
-- this RPC and got the ambiguity error every time.
--
-- Not caught earlier because the JS unit tests mock supabase.rpc (no SQL executed)
-- and the authenticated e2e suite had not run against a TEST DB carrying this RPC.
--
-- Fix: qualify the RETURNING columns with the table name so they unambiguously bind
-- to the columns, not the OUT parameters. Pure function-body change, identical
-- signature and returned column names (session_id, started_at) — so it is a safe,
-- additive CREATE OR REPLACE with NO deploy-ordering constraint (the live code
-- already calls this RPC; applying this migration immediately restores quest-start).
-- =========================================================

CREATE OR REPLACE FUNCTION public.start_exercise_session(p_exercise_id UUID)
RETURNS TABLE (session_id UUID, started_at TIMESTAMPTZ)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user    UUID := auth.uid();
  v_mode    TEXT;
  v_chapter UUID;
  v_grade   UUID;
  v_allowed BOOLEAN;
  v_reason  TEXT;
  v_quiz_id UUID;
  v_passed  BOOLEAN;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  -- Exercise + its subject's grade. School subjects bind to a grade; non-school
  -- themes (culture-générale, muscle-cerveau/IQ, language tracks) leave grade_id
  -- NULL -> they have no theory to validate, so the quiz gate never applies.
  SELECT e.mode, e.chapter_id, s.grade_id
    INTO v_mode, v_chapter, v_grade
    FROM public.exercises e
    JOIN public.subjects s ON s.id = e.subject_id
   WHERE e.id = p_exercise_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Exercise not found';
  END IF;

  -- 1) PREMIUM gate. resolve_exercise_access returns exactly one row; fail closed:
  --    any not-allowed outcome blocks, and the reason picks the localized message.
  SELECT ra.allowed, ra.reason
    INTO v_allowed, v_reason
    FROM public.resolve_exercise_access(p_exercise_id) ra;

  IF v_allowed IS DISTINCT FROM true THEN
    IF v_reason = 'PARCOURS_COMING_SOON' THEN
      RAISE EXCEPTION 'PARCOURS_COMING_SOON';
    ELSE
      RAISE EXCEPTION 'PARCOURS_LOCKED';
    END IF;
  END IF;

  -- 2) COMPREHENSION-QUIZ gate — school subjects only, non-quiz exercises only, and
  --    only when a quiz actually exists for the chapter (graceful for legacy
  --    chapters without one).
  IF v_grade IS NOT NULL AND v_mode IS DISTINCT FROM 'quiz' AND v_chapter IS NOT NULL THEN
    SELECT e.id
      INTO v_quiz_id
      FROM public.exercises e
     WHERE e.chapter_id = v_chapter AND e.mode = 'quiz'
     LIMIT 1;

    IF v_quiz_id IS NOT NULL THEN
      -- A qualifying pass: >= 80% AND not rushed (>= 4s/question), so a fast random
      -- pass cannot unlock the chapter without comprehension.
      SELECT EXISTS (
        SELECT 1
          FROM public.attempts a
         WHERE a.user_id = v_user
           AND a.exercise_id = v_quiz_id
           AND a.score_pct >= 80
           AND a.duration_seconds >= a.total_count * 4
      ) INTO v_passed;

      IF NOT v_passed THEN
        RAISE EXCEPTION 'QUIZ_LOCKED';
      END IF;
    END IF;
  END IF;

  -- Gates passed -> create the session as the owner and return it. Columns in the
  -- RETURNING list are table-qualified so they bind to exercise_sessions columns,
  -- not to the same-named OUT parameters (was SQLSTATE 42702: ambiguous reference).
  RETURN QUERY
    INSERT INTO public.exercise_sessions AS es (user_id, exercise_id)
    VALUES (v_user, p_exercise_id)
    RETURNING es.id, es.started_at;
END;
$$;

REVOKE ALL ON FUNCTION public.start_exercise_session(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.start_exercise_session(UUID) TO authenticated;
