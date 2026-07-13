-- Security hardening (public-surface audit 2026-07, finding #1) — stop returning
-- the explanation to ANONYMOUS callers of check_answers.
--
-- `check_answers` powers the public practice correction (anon-callable, reachable
-- directly via PostgREST with the publishable key). It returns, per question,
-- `is_correct` + the correct answer + the `explanation`. The correct answer is the
-- point of a public correction and stays. The `explanation`, however, is the richer
-- pedagogical content that signed-in students otherwise spend a hint charge to
-- reveal (consume_hint) — handing it to unauthenticated callers lets the whole
-- explanation bank be scraped for free, outside any account/economy.
--
-- Fix: gate `explanation` on `auth.uid()` INSIDE the SECURITY DEFINER function, so
-- the restriction holds on BOTH the server-fn path and a direct PostgREST call.
-- Anonymous callers (auth.uid() IS NULL) get NULL; signed-in callers are unchanged
-- (they already see the explanation in the post-answer correction). Additive
-- CREATE OR REPLACE — grants are preserved; safe to apply before/independent of code.

CREATE OR REPLACE FUNCTION public.check_answers(p_exercise_id uuid, p_answers jsonb)
RETURNS TABLE (question_id uuid, is_correct boolean, correct_option text, explanation text)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_source text;
  v_mode text;
BEGIN
  IF p_answers IS NULL OR jsonb_typeof(p_answers) <> 'array' THEN
    RETURN;
  END IF;

  SELECT e.source, e.mode
    INTO v_source, v_mode
    FROM public.exercises e
    WHERE e.id = p_exercise_id;

  -- Only the public (admin) catalogue is anonymously checkable; the comprehension
  -- quiz is the gate and is never anonymously corrected.
  IF v_source IS DISTINCT FROM 'admin' OR v_mode = 'quiz' THEN
    RETURN;
  END IF;

  RETURN QUERY
    SELECT
      q.id,
      public.score_answer(q, a.elem ->> 'choice') AS is_correct,
      public.answer_key_display(q) AS correct_option,
      -- The explanation is withheld from anonymous callers (hint-economy content);
      -- signed-in callers keep it, exactly as in the connected post-answer review.
      CASE WHEN auth.uid() IS NULL THEN NULL ELSE q.explanation END AS explanation
    FROM jsonb_array_elements(p_answers) AS a(elem)
    JOIN public.questions q
      ON q.id = nullif(a.elem ->> 'questionId', '')::uuid
    WHERE q.exercise_id = p_exercise_id;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.check_answers(uuid, jsonb) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.check_answers(uuid, jsonb) TO anon, authenticated;
