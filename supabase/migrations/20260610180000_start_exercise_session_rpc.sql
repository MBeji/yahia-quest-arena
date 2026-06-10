-- =========================================================
-- start_exercise_session (GAP-021 Part 2) — server-authoritative session start.
-- ---------------------------------------------------------
-- Moves the "start a quest" gate OUT of the server fn (which did a direct INSERT
-- into exercise_sessions, so any authenticated user could forge a session via
-- PostgREST and bypass BOTH gates below) INTO this SECURITY DEFINER RPC, which
-- enforces, in one authoritative place:
--   1. the per-parcours PREMIUM gate — delegates to resolve_exercise_access (the
--      single authoritative resolver: free/preview/entitlement), and
--   2. the school-program COMPREHENSION-QUIZ gate — a practice/boss exercise stays
--      locked until the chapter's quiz is GENUINELY passed: score >= 80% AND not
--      rushed (>= 4s/question). Thresholds mirror src/shared/constants/gamification.ts
--      (QUIZ_PASS_THRESHOLD_PCT / MIN_SECONDS_PER_QUESTION); keep both in sync.
-- then inserts the session as the owner and returns it.
--
-- DEPLOY ORDER (CLAUDE.md §7) — this migration is ADDITIVE and BEHAVIOUR-NEUTRAL:
-- nothing calls start_exercise_session until the startExerciseSession server fn is
-- switched to it. Apply it FIRST, deploy the code, THEN apply the companion REVOKE
-- migration (20260610190000) that closes the direct-INSERT hole. Splitting the
-- REVOKE keeps the cutover zero-downtime (no window where sessions can't start).
--
-- Gate signalling: raises 'PARCOURS_LOCKED' / 'PARCOURS_COMING_SOON' / 'QUIZ_LOCKED'
-- (matched by the server fn to localized messages). Idempotent (CREATE OR REPLACE).
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

  -- Gates passed -> create the session as the owner and return it.
  RETURN QUERY
    WITH ins AS (
      INSERT INTO public.exercise_sessions (user_id, exercise_id)
      VALUES (v_user, p_exercise_id)
      RETURNING id, started_at
    )
    SELECT ins.id, ins.started_at FROM ins;
END;
$$;

REVOKE ALL ON FUNCTION public.start_exercise_session(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.start_exercise_session(UUID) TO authenticated;
