-- Étude 22, lot 5 (R-25) — le donjon sert les questions du parcours actif.
--
-- LE DÉFAUT RÉPARÉ : le pool du donjon était le catalogue ENTIER, filtré sur la seule
-- difficulté du palier. Un élève de 3ème année de base recevait donc, en pleine arène, des
-- questions de bac — et un lycéen des questions de primaire. Ce n'est pas une feature de
-- découverte, c'est un défaut de pertinence (arbitrage Q-2 du 2026-07-18).
--
-- LE SCOPE, ET SA PROFONDEUR DE REPLI (R-25) : on compte les questions éligibles encore non
-- assignées dans la run, au palier courant :
--   * >= 60 au niveau de la CLASSE du parcours actif  -> pool `grade`
--   * sinon >= 30 au niveau du CYCLE (primaire/collège/secondaire) -> pool `cycle`
--   * sinon -> `all`, le catalogue entier, c'est-à-dire le comportement actuel.
-- Un élève sans parcours actif reste en `all`. Le repli garantit qu'une classe au contenu
-- encore mince ne produit jamais une arène vide : on préfère élargir que refuser.
--
-- D-7 : on répare **par la donnée, pas par un verrou** — aucune porte nouvelle, aucun accès
-- retiré. `get_dungeon_access` n'est pas touchée (stop-point du lot).
--
-- DEUX ÉCARTS ASSUMÉS PAR RAPPORT À LA LETTRE DE L'ÉTUDE, tous deux resserrant le pool :
--
--   1. Le cycle est lu dans `grades.cycle`, qui EXISTE déjà en base ('primaire' | 'college' |
--      'secondaire'), au lieu d'être re-dérivé de plages de `display_order` (1-6 / 7-9 / >= 10)
--      comme le §3 le proposait. Re-dériver aurait dupliqué une vérité déjà stockée et cassé
--      silencieusement le jour où un `display_order` bouge.
--
--   2. Le pool exclut désormais `e.source = 'parent'` en plus des quiz. La fonction est
--      SECURITY DEFINER, donc elle CONTOURNE la RLS de `exercises` — laquelle réserve
--      justement les missions familiales à leur auteur, à l'élève ciblé et à son parent
--      (20260522153000). En l'état, une mission qu'un parent écrit pour son enfant pouvait
--      donc être tirée dans le donjon de n'importe quel autre élève. Le donjon est une arène
--      de CATALOGUE : `source = 'admin'` est à la fois la correction de cette fuite et la
--      lecture exacte de R-25 (« missions non-quiz » du parcours).
--
-- Recréée à partir de 20260705170000 (dernière définition active) ; la logique d'attribution
-- d'étage, l'absence de clé de réponse dans la charge utile et la forme du retour sont
-- inchangées, `poolScope` excepté — que le lobby affiche (R-30) et que le client journalise.

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
  v_theme TEXT;
  v_grade UUID;
  v_cycle TEXT;
  v_cycle_grades UUID[];
  v_pool_scope TEXT := 'all';
  v_available INT;
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

  -- Le parcours actif est résolu SERVEUR (comme match_duel) : le client ne peut pas
  -- réclamer un autre pool que le sien.
  SELECT pa.theme_id, pa.grade_id
    INTO v_theme, v_grade
    FROM public.profiles pr
    JOIN public.parcours pa ON pa.id = pr.current_parcours_id
   WHERE pr.id = v_user;

  IF v_theme IS NOT NULL AND v_grade IS NOT NULL THEN
    SELECT count(*)
      INTO v_available
      FROM public.questions q
      JOIN public.exercises e ON e.id = q.exercise_id
      JOIN public.subjects s ON s.id = e.subject_id
     WHERE e.difficulty <= v_max_difficulty
       AND e.mode IS DISTINCT FROM 'quiz'
       AND e.source = 'admin'
       AND s.theme_id = v_theme
       AND s.grade_id = v_grade
       AND NOT EXISTS (
         SELECT 1
           FROM public.dungeon_run_questions rq
          WHERE rq.run_id = p_run_id
            AND rq.question_id = q.id
       );

    IF v_available >= 60 THEN
      v_pool_scope := 'grade';
    ELSE
      -- Repli d'un cran : les classes du même cycle, dans le même thème.
      SELECT g.cycle INTO v_cycle FROM public.grades g WHERE g.id = v_grade;

      IF v_cycle IS NOT NULL THEN
        SELECT array_agg(g.id)
          INTO v_cycle_grades
          FROM public.grades g
         WHERE g.theme_id = v_theme
           AND g.cycle = v_cycle;

        SELECT count(*)
          INTO v_available
          FROM public.questions q
          JOIN public.exercises e ON e.id = q.exercise_id
          JOIN public.subjects s ON s.id = e.subject_id
         WHERE e.difficulty <= v_max_difficulty
           AND e.mode IS DISTINCT FROM 'quiz'
           AND e.source = 'admin'
           AND s.theme_id = v_theme
           AND s.grade_id = ANY (v_cycle_grades)
           AND NOT EXISTS (
             SELECT 1
               FROM public.dungeon_run_questions rq
              WHERE rq.run_id = p_run_id
                AND rq.question_id = q.id
           );

        IF v_available >= 30 THEN
          v_pool_scope := 'cycle';
        END IF;
      END IF;
    END IF;
  END IF;

  WITH inserted AS (
    INSERT INTO public.dungeon_run_questions (run_id, question_id, assigned_floor)
    SELECT p_run_id, c.id, v_run.current_floor + row_number() OVER (ORDER BY c.id) - 1
    FROM (
      SELECT q.id
      FROM public.questions q
      JOIN public.exercises e ON e.id = q.exercise_id
      JOIN public.subjects s ON s.id = e.subject_id
      WHERE e.difficulty <= v_max_difficulty
        AND e.mode IS DISTINCT FROM 'quiz'
        AND e.source = 'admin'
        AND NOT EXISTS (
          SELECT 1
          FROM public.dungeon_run_questions rq
          WHERE rq.run_id = p_run_id
            AND rq.question_id = q.id
        )
        AND (
          v_pool_scope = 'all'
          OR (v_pool_scope = 'grade' AND s.theme_id = v_theme AND s.grade_id = v_grade)
          OR (v_pool_scope = 'cycle' AND s.theme_id = v_theme
              AND s.grade_id = ANY (v_cycle_grades))
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
    'poolScope', v_pool_scope,
    'questions', v_questions
  );
END;
$$;

-- Signature unchanged; re-assert privileges (self-contained migration).
REVOKE EXECUTE ON FUNCTION public.get_dungeon_questions(uuid, int) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_dungeon_questions(uuid, int) TO authenticated;
