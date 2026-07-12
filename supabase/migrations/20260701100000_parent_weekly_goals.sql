-- Objectif de la semaine fixé par le parent — le parent (lié) fixe un nombre de
-- missions pour la semaine en cours ; l'élève le voit sur son dashboard comme une
-- quête famille avec sa progression (COUNT des attempts de la semaine).
--
-- Modèle : une ligne par (élève, semaine ISO, lundi Tunis-local) — le dernier
-- parent qui écrit gagne (les co-parents partagent l'objectif). Écritures via la
-- RPC SECURITY DEFINER uniquement (le lien parent-élève y est vérifié) ; lectures
-- via get_family_weekly_goal (élève lui-même ou parent lié).

CREATE TABLE public.parent_weekly_goals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  student_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  week_start DATE NOT NULL,
  target_exercises INT NOT NULL CHECK (target_exercises BETWEEN 1 AND 50),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (student_user_id, week_start)
);

CREATE INDEX idx_parent_weekly_goals_parent ON public.parent_weekly_goals(parent_user_id);

ALTER TABLE public.parent_weekly_goals ENABLE ROW LEVEL SECURITY;

-- Lecture directe : l'élève voit ses objectifs, le parent voit ceux qu'il a posés.
-- (Pas de policy INSERT/UPDATE : les écritures passent par la RPC definer.)
CREATE POLICY "Students read own goals" ON public.parent_weekly_goals
  FOR SELECT USING ((SELECT auth.uid()) = student_user_id);
CREATE POLICY "Parents read goals they set" ON public.parent_weekly_goals
  FOR SELECT USING ((SELECT auth.uid()) = parent_user_id);

-- Nouvelle table ⇒ grants explicites (gotcha CLAUDE.md : la CI n'applique plus
-- les privilèges par défaut). SELECT seul : pas d'écriture directe client.
GRANT SELECT ON public.parent_weekly_goals TO authenticated;

-- Le lundi (ISO) de la semaine courante, calendrier tunisien.
CREATE OR REPLACE FUNCTION public.app_current_week_start()
RETURNS DATE
LANGUAGE sql
STABLE
SET search_path = public
AS $$
  SELECT date_trunc('week', (clock_timestamp() AT TIME ZONE 'Africa/Tunis'))::date;
$$;

-- Le parent lié fixe (upsert) l'objectif de la semaine courante pour un élève.
CREATE OR REPLACE FUNCTION public.set_parent_weekly_goal(p_student UUID, p_target INT)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_week DATE := public.app_current_week_start();
  v_row public.parent_weekly_goals;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_target IS NULL OR p_target < 1 OR p_target > 50 THEN
    RAISE EXCEPTION 'Invalid weekly target (1-50).';
  END IF;

  IF NOT public.is_parent_of_student(v_user, p_student) THEN
    RAISE EXCEPTION 'Access denied: you are not linked to this student.';
  END IF;

  INSERT INTO public.parent_weekly_goals
    (parent_user_id, student_user_id, week_start, target_exercises)
  VALUES (v_user, p_student, v_week, p_target)
  ON CONFLICT (student_user_id, week_start)
  DO UPDATE SET
    target_exercises = EXCLUDED.target_exercises,
    parent_user_id = EXCLUDED.parent_user_id,
    updated_at = now()
  RETURNING * INTO v_row;

  RETURN jsonb_build_object(
    'weekStart', to_char(v_row.week_start, 'YYYY-MM-DD'),
    'target', v_row.target_exercises
  );
END;
$$;

-- Objectif de la semaine courante + progression (attempts de la semaine).
-- Lisible par l'élève lui-même ou par un parent lié ; NULL si aucun objectif.
CREATE OR REPLACE FUNCTION public.get_family_weekly_goal(p_student UUID)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_week DATE := public.app_current_week_start();
  v_goal public.parent_weekly_goals;
  v_done INT := 0;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF v_user IS DISTINCT FROM p_student
     AND NOT public.is_parent_of_student(v_user, p_student) THEN
    RAISE EXCEPTION 'Access denied.';
  END IF;

  SELECT * INTO v_goal
  FROM public.parent_weekly_goals
  WHERE student_user_id = p_student AND week_start = v_week;

  IF NOT FOUND THEN
    RETURN NULL;
  END IF;

  SELECT COUNT(*)::INT INTO v_done
  FROM public.attempts
  WHERE user_id = p_student
    AND (completed_at AT TIME ZONE 'Africa/Tunis')::date >= v_week;

  RETURN jsonb_build_object(
    'weekStart', to_char(v_goal.week_start, 'YYYY-MM-DD'),
    'target', v_goal.target_exercises,
    'done', v_done
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.app_current_week_start() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.set_parent_weekly_goal(uuid, int) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.get_family_weekly_goal(uuid) FROM PUBLIC, anon;

GRANT EXECUTE ON FUNCTION public.app_current_week_start() TO authenticated;
GRANT EXECUTE ON FUNCTION public.set_parent_weekly_goal(uuid, int) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_family_weekly_goal(uuid) TO authenticated;
