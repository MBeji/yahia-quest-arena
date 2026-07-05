-- Native question types — phase B1 lot B1.3 (FableEtudes/03-types-questions-natifs #lot-B1.3).
-- Spec normative : docs/interactive-question-types.md.
--
-- The dungeon question payload must tell the client HOW to render each item:
-- get_dungeon_questions now carries `question_type` (client-readable column,
-- granted in 20260705130000) so the unified <QuestionInput> renderer can show a
-- numeric entry instead of option buttons. Re-created verbatim from
-- 20260601190000 with ONLY that payload key added — selection logic, floor
-- assignment, and the no-answer-key posture are unchanged.

CREATE OR REPLACE FUNCTION public.get_dungeon_questions(
  p_run_id UUID,
  p_batch_size INT DEFAULT 5
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_run public.dungeon_runs;
  v_max_difficulty INT;
  v_questions JSONB := '[]'::jsonb;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_run_id IS NULL THEN
    RAISE EXCEPTION 'Run id is required';
  END IF;

  IF p_batch_size IS NULL OR p_batch_size < 1 OR p_batch_size > 20 THEN
    RAISE EXCEPTION 'Invalid batch size';
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

  v_max_difficulty := LEAST(3, CEIL(v_run.current_floor::NUMERIC / 5.0)::INT);

  WITH inserted AS (
    INSERT INTO public.dungeon_run_questions (run_id, question_id, assigned_floor)
    SELECT p_run_id, c.id, v_run.current_floor + row_number() OVER (ORDER BY c.id) - 1
    FROM (
      SELECT q.id
      FROM public.questions q
      JOIN public.exercises e ON e.id = q.exercise_id
      WHERE e.difficulty <= v_max_difficulty
        AND NOT EXISTS (
          SELECT 1
          FROM public.dungeon_run_questions rq
          WHERE rq.run_id = p_run_id
            AND rq.question_id = q.id
        )
      ORDER BY random()
      LIMIT p_batch_size
    ) c
    ON CONFLICT DO NOTHING
    RETURNING question_id, assigned_floor
  )
  SELECT COALESCE(jsonb_agg(
    jsonb_build_object(
      'id', q.id,
      'prompt', q.prompt,
      'options', q.options,
      'question_type', q.question_type,
      'explanation', q.explanation,
      'assignedFloor', ins.assigned_floor,
      'exercises', jsonb_build_object(
        'difficulty', e.difficulty,
        'subject_id', s.id,
        'subjects', jsonb_build_object(
          'name_fr', s.name_fr,
          'color_token', s.color_token,
          'icon', s.icon
        )
      )
    )
    ORDER BY ins.assigned_floor
  ), '[]'::jsonb)
  INTO v_questions
  FROM inserted ins
  JOIN public.questions q ON q.id = ins.question_id
  JOIN public.exercises e ON e.id = q.exercise_id
  JOIN public.subjects s ON s.id = e.subject_id;

  RETURN jsonb_build_object(
    'currentFloor', v_run.current_floor,
    'questions', v_questions
  );
END;
$$;

-- Signature unchanged; re-assert privileges (self-contained migration).
REVOKE EXECUTE ON FUNCTION public.get_dungeon_questions(uuid, int) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_dungeon_questions(uuid, int) TO authenticated;
