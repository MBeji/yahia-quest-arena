-- Native question types — phase B1 lot B1.2 (FableEtudes/03-types-questions-natifs #lot-B1.2).
-- Spec normative : docs/interactive-question-types.md.
--
-- The end-of-quest correction (submitAttempt → get_attempt_review) used to
-- recompute per-question correctness CLIENT-SERVER-SIDE as a string equality
-- (`correct_option === choice`). That was faithful for mcq, but lies for
-- `numeric`: an in-tolerance answer (e.g. 3.15 for value 3.14 ± 0.01) counts
-- correct in the score yet would display as wrong in the review.
--
-- Fix: get_attempt_review gains an OPTIONAL `p_answers` parameter (the same
-- payload shape the submit RPC receives) and returns `is_correct` per question,
-- scored through the single authoritative seam `score_answer` — the review can
-- no longer diverge from the score. Calling WITHOUT p_answers keeps working
-- (is_correct is NULL) so the deploy window is safe; every other gate
-- (owner-only, completed-session-only, never for quizzes) is unchanged from
-- 20260705130000. The DROP is required because adding a defaulted parameter
-- would otherwise create an ambiguous overload for PostgREST; the function is
-- recreated in the same transaction with a superset signature.

DROP FUNCTION IF EXISTS public.get_attempt_review(uuid);

CREATE FUNCTION public.get_attempt_review(p_session_id uuid, p_answers jsonb DEFAULT NULL)
RETURNS TABLE (
  question_id uuid,
  prompt text,
  correct_option text,
  explanation text,
  is_correct boolean
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user uuid := auth.uid();
  v_owner uuid;
  v_exercise uuid;
  v_completed timestamptz;
  v_mode text;
BEGIN
  -- A malformed answers payload never breaks the review: treat it as absent.
  IF p_answers IS NOT NULL AND jsonb_typeof(p_answers) <> 'array' THEN
    p_answers := NULL;
  END IF;

  SELECT s.user_id, s.exercise_id, s.completed_at
    INTO v_owner, v_exercise, v_completed
    FROM public.exercise_sessions s
    WHERE s.id = p_session_id;

  -- Only the owner, only after the attempt has been submitted, may see the
  -- correction. Comprehension quizzes never reveal it (anti-memorisation of the gate).
  IF v_owner IS NULL OR v_owner IS DISTINCT FROM v_user THEN
    RETURN;
  END IF;
  IF v_completed IS NULL THEN
    RETURN;
  END IF;

  SELECT e.mode INTO v_mode FROM public.exercises e WHERE e.id = v_exercise;
  IF v_mode = 'quiz' THEN
    RETURN;
  END IF;

  RETURN QUERY
    SELECT
      q.id,
      q.prompt,
      -- mcq: the option id; numeric: the canonical value. Same disclosure
      -- gate (owned + completed session) for both.
      COALESCE(q.correct_option, q.answer_key ->> 'value'),
      q.explanation,
      -- Scored through the same seam as the submit RPC (score_answer), so the
      -- review can never contradict the score. NULL when no answers were given
      -- (legacy call shape).
      CASE
        WHEN p_answers IS NULL THEN NULL
        ELSE public.score_answer(q, a.choice)
      END
    FROM public.questions q
    LEFT JOIN (
      SELECT DISTINCT ON (ans.question_id)
        ans.question_id,
        ans.choice
      FROM (
        SELECT
          nullif(elem ->> 'questionId', '')::uuid AS question_id,
          elem ->> 'choice' AS choice
        FROM jsonb_array_elements(COALESCE(p_answers, '[]'::jsonb)) AS elem
      ) ans
      WHERE ans.question_id IS NOT NULL
      ORDER BY ans.question_id
    ) a ON a.question_id = q.id
    WHERE q.exercise_id = v_exercise
    ORDER BY q.display_order;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.get_attempt_review(uuid, jsonb) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_attempt_review(uuid, jsonb) TO authenticated;
