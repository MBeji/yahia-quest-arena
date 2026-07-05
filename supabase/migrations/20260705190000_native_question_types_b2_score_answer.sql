-- Native question types — phase B2 lot B2.1 (FableEtudes/03-types-questions-natifs #lot-B2.1).
-- Spec normative : docs/interactive-question-types.md (Tier B).
--
-- Extends THE scoring seam (`score_answer`, D-1) with the two phase-B2 types —
-- the five scoring RPCs already call it, so no scoring RPC changes:
--   * `ordering`  — key `{order:["b","a","d","c"]}`, answer `choice:"b,a,d,c"`
--     (id CSV) : EXACT sequence match, no partial credit (R-2 / spec).
--   * `matching`  — key `{pairs:[["l1","r2"],…]}`, answer `choice:"l1:r2,l2:r1"`
--     (pair CSV) : SET equality of pairs (order-insensitive), no partial credit.
--   Whitespace is stripped before parsing; a malformed answer or key scores
--   false and never raises (R-3 posture, same as numeric). `multi` (phase B3)
--   still scores false. `mcq` and `numeric` semantics are strictly unchanged.
--
-- Also introduces `answer_key_display(question)` — the canonical answer
-- serialized in the SAME wire format as `choice` — and re-creates the three
-- correction-revealing RPCs verbatim with only their reveal expression changed
-- (`COALESCE(correct_option, answer_key->>'value')` covered mcq/numeric only):
--   * get_attempt_review   (verbatim from 20260705150000)
--   * check_answers        (verbatim from 20260705130000)
--   * submit_dungeon_answer(verbatim from 20260705130000)
-- All access gates are unchanged; the key still reaches the client only
-- through these gated SECURITY DEFINER RPCs (R-1).

-- ---------------------------------------------------------------------------
-- 1. The scoring seam, extended with the B2 types.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.score_answer(q public.questions, p_choice text)
RETURNS boolean
LANGUAGE plpgsql
STABLE
SET search_path = public
AS $$
DECLARE
  v_answer numeric;
  v_value numeric;
  v_tolerance numeric;
BEGIN
  IF p_choice IS NULL THEN
    RETURN false;
  END IF;

  -- 'mcq' fast path: strictly the historical semantics (zero regression, US-4).
  IF q.question_type = 'mcq' OR q.question_type IS NULL THEN
    RETURN q.correct_option = p_choice;
  END IF;

  IF q.question_type = 'numeric' THEN
    IF q.answer_key IS NULL OR NOT (q.answer_key ? 'value') THEN
      RETURN false;
    END IF;
    BEGIN
      -- Accept '-', '.' and ',' (normalized) — US-1. Unparseable input is a
      -- wrong answer, never an exception (a bad payload must not kill a session).
      v_answer := replace(btrim(p_choice), ',', '.')::numeric;
      v_value := (q.answer_key ->> 'value')::numeric;
      v_tolerance := COALESCE((q.answer_key ->> 'tolerance')::numeric, 0);
    EXCEPTION WHEN OTHERS THEN
      RETURN false;
    END;
    RETURN abs(v_answer - v_value) <= v_tolerance;
  END IF;

  -- 'ordering': the submitted id CSV must reproduce the key's EXACT sequence.
  -- All-or-nothing (no partial credit, spec R-2); whitespace-insensitive.
  IF q.question_type = 'ordering' THEN
    IF q.answer_key IS NULL
       OR jsonb_typeof(q.answer_key -> 'order') IS DISTINCT FROM 'array' THEN
      RETURN false;
    END IF;
    BEGIN
      RETURN (
        SELECT COALESCE(array_agg(t.part ORDER BY t.ord), ARRAY[]::text[])
        FROM unnest(string_to_array(replace(p_choice, ' ', ''), ',')) WITH ORDINALITY AS t(part, ord)
        WHERE t.part <> ''
      ) = (
        SELECT COALESCE(array_agg(k.val ORDER BY k.ord), ARRAY[]::text[])
        FROM jsonb_array_elements_text(q.answer_key -> 'order') WITH ORDINALITY AS k(val, ord)
      );
    EXCEPTION WHEN OTHERS THEN
      RETURN false;
    END;
  END IF;

  -- 'matching': the submitted "left:right" pair CSV must equal the key's pair
  -- SET (order-insensitive, duplicates collapse, no partial credit).
  IF q.question_type = 'matching' THEN
    IF q.answer_key IS NULL
       OR jsonb_typeof(q.answer_key -> 'pairs') IS DISTINCT FROM 'array' THEN
      RETURN false;
    END IF;
    BEGIN
      RETURN (
        SELECT COALESCE(array_agg(DISTINCT t.part ORDER BY t.part), ARRAY[]::text[])
        FROM unnest(string_to_array(replace(p_choice, ' ', ''), ',')) AS t(part)
        WHERE t.part <> ''
      ) = (
        SELECT COALESCE(
          array_agg(DISTINCT ((p.pair ->> 0) || ':' || (p.pair ->> 1))
                    ORDER BY ((p.pair ->> 0) || ':' || (p.pair ->> 1))),
          ARRAY[]::text[]
        )
        FROM jsonb_array_elements(q.answer_key -> 'pairs') AS p(pair)
      );
    EXCEPTION WHEN OTHERS THEN
      RETURN false;
    END;
  END IF;

  -- Not-yet-shipped types ('multi' — phase B3): score false, never crash (R-3).
  RETURN false;
END;
$$;

-- Server-side only (unchanged posture): no client answer-key oracle.
REVOKE EXECUTE ON FUNCTION public.score_answer(public.questions, text) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 2. Canonical answer display — the key serialized in the `choice` wire format.
--    Used ONLY by the gated correction RPCs below (same disclosure gates).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.answer_key_display(q public.questions)
RETURNS text
LANGUAGE sql
STABLE
SET search_path = public
AS $$
  SELECT CASE q.question_type
    WHEN 'numeric' THEN q.answer_key ->> 'value'
    WHEN 'ordering' THEN
      CASE WHEN jsonb_typeof(q.answer_key -> 'order') = 'array' THEN (
        SELECT string_agg(k.val, ',' ORDER BY k.ord)
        FROM jsonb_array_elements_text(q.answer_key -> 'order') WITH ORDINALITY AS k(val, ord)
      ) END
    WHEN 'matching' THEN
      CASE WHEN jsonb_typeof(q.answer_key -> 'pairs') = 'array' THEN (
        SELECT string_agg((p.pair ->> 0) || ':' || (p.pair ->> 1), ',' ORDER BY p.ord)
        FROM jsonb_array_elements(q.answer_key -> 'pairs') WITH ORDINALITY AS p(pair, ord)
      ) END
    ELSE q.correct_option
  END;
$$;

REVOKE EXECUTE ON FUNCTION public.answer_key_display(public.questions) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 3. get_attempt_review — verbatim from 20260705150000, reveal generalized.
-- ---------------------------------------------------------------------------
DROP FUNCTION IF EXISTS public.get_attempt_review(uuid, jsonb);

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
      -- Canonical answer in the same wire format as `choice` (mcq: option id;
      -- numeric: value; ordering: id CSV; matching: pair CSV). Same disclosure
      -- gate (owned + completed session) for every type.
      public.answer_key_display(q),
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

-- ---------------------------------------------------------------------------
-- 4. check_answers — verbatim from 20260705130000, reveal generalized.
-- ---------------------------------------------------------------------------
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
      q.explanation
    FROM jsonb_array_elements(p_answers) AS a(elem)
    JOIN public.questions q
      ON q.id = nullif(a.elem ->> 'questionId', '')::uuid
    WHERE q.exercise_id = p_exercise_id;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.check_answers(uuid, jsonb) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.check_answers(uuid, jsonb) TO anon, authenticated;

-- ---------------------------------------------------------------------------
-- 5. submit_dungeon_answer — verbatim from 20260705130000, reveal generalized.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.submit_dungeon_answer(
  p_run_id UUID,
  p_question_id UUID,
  p_choice TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_run public.dungeon_runs;
  v_run_question public.dungeon_run_questions;
  v_question public.questions;
  v_is_correct BOOLEAN;
  v_next_floor INT;
  v_floors_cleared INT;
  v_total_correct INT;
  v_total_answered INT;
  v_status TEXT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_run_id IS NULL OR p_question_id IS NULL THEN
    RAISE EXCEPTION 'Run and question are required';
  END IF;

  IF p_choice IS NULL OR btrim(p_choice) = '' THEN
    RAISE EXCEPTION 'Choice is required';
  END IF;

  SELECT *
  INTO v_run
  FROM public.dungeon_runs
  WHERE id = p_run_id
    AND user_id = v_user
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Invalid dungeon run.';
  END IF;

  IF v_run.status <> 'active' THEN
    RAISE EXCEPTION 'Dungeon run is not active.';
  END IF;

  SELECT *
  INTO v_run_question
  FROM public.dungeon_run_questions
  WHERE run_id = p_run_id
    AND question_id = p_question_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Question is not assigned to this run.';
  END IF;

  IF v_run_question.answered_at IS NOT NULL THEN
    RAISE EXCEPTION 'This dungeon question is already answered.';
  END IF;

  IF v_run_question.assigned_floor <> v_run.current_floor THEN
    RAISE EXCEPTION 'Invalid floor progression.';
  END IF;

  SELECT *
  INTO v_question
  FROM public.questions
  WHERE id = p_question_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Question not found.';
  END IF;

  v_is_correct := public.score_answer(v_question, p_choice);

  UPDATE public.dungeon_run_questions
  SET answered_at = clock_timestamp(),
      selected_choice = p_choice,
      is_correct = v_is_correct
  WHERE id = v_run_question.id;

  IF v_is_correct THEN
    v_next_floor := v_run.current_floor + 1;
    v_floors_cleared := v_run.floors_cleared + 1;
    v_total_correct := v_run.total_correct + 1;
    v_total_answered := v_run.total_answered + 1;
    v_status := 'active';

    UPDATE public.dungeon_runs
    SET current_floor = v_next_floor,
        floors_cleared = v_floors_cleared,
        total_correct = v_total_correct,
        total_answered = v_total_answered
    WHERE id = p_run_id;
  ELSE
    v_next_floor := v_run.current_floor;
    v_floors_cleared := v_run.floors_cleared;
    v_total_correct := v_run.total_correct;
    v_total_answered := v_run.total_answered + 1;
    v_status := 'failed';

    UPDATE public.dungeon_runs
    SET status = 'failed',
        ended_at = clock_timestamp(),
        total_answered = v_total_answered
    WHERE id = p_run_id;
  END IF;

  RETURN jsonb_build_object(
    'isCorrect', v_is_correct,
    'nextFloor', v_next_floor,
    'floorsCleared', v_floors_cleared,
    'totalCorrect', v_total_correct,
    'totalAnswered', v_total_answered,
    'runStatus', v_status,
    'questionId', v_question.id,
    'prompt', v_question.prompt,
    'correctChoice', public.answer_key_display(v_question),
    'explanation', v_question.explanation
  );
END;
$$;

-- Signature unchanged; re-assert privileges (self-contained migration).
REVOKE EXECUTE ON FUNCTION public.submit_dungeon_answer(uuid, uuid, text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.submit_dungeon_answer(uuid, uuid, text) TO authenticated;
