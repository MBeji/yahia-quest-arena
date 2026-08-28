-- Objectif du jour, en plus de l'objectif de la semaine — même mécanique que
-- `20260701100000_parent_weekly_goals.sql` (upsert par le parent lié, lu par
-- l'élève et le parent, écritures RPC-only) mais bornée au jour Tunis-local.
-- Cette migration relâche aussi le plafond des deux objectifs : 1-50 forçait
-- un parent voulant un cap large (ex. « 200 questions cette semaine ») à
-- mentir sur le champ. Nouveau plafond commun : 1 000, toujours borné pour
-- garder `target_exercises` dans un entier raisonnable côté UI (barre de
-- progression, alertes).

-- ---------------------------------------------------------
-- 1. Plafond élargi de l'objectif hebdo existant.
-- ---------------------------------------------------------
ALTER TABLE public.parent_weekly_goals
  DROP CONSTRAINT IF EXISTS parent_weekly_goals_target_exercises_check;
ALTER TABLE public.parent_weekly_goals
  ADD CONSTRAINT parent_weekly_goals_target_exercises_check
  CHECK (target_exercises BETWEEN 1 AND 1000);

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

  IF p_target IS NULL OR p_target < 1 OR p_target > 1000 THEN
    RAISE EXCEPTION 'Invalid weekly target (1-1000).';
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

-- ---------------------------------------------------------
-- 2. Objectif du jour — nouvelle table, même forme que l'hebdo.
-- ---------------------------------------------------------
CREATE TABLE public.parent_daily_goals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  student_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  day DATE NOT NULL,
  target_exercises INT NOT NULL CHECK (target_exercises BETWEEN 1 AND 1000),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (student_user_id, day)
);

CREATE INDEX idx_parent_daily_goals_parent ON public.parent_daily_goals(parent_user_id);

ALTER TABLE public.parent_daily_goals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Students read own daily goals" ON public.parent_daily_goals
  FOR SELECT USING ((SELECT auth.uid()) = student_user_id);
CREATE POLICY "Parents read daily goals they set" ON public.parent_daily_goals
  FOR SELECT USING ((SELECT auth.uid()) = parent_user_id);

-- Nouvelle table ⇒ grants explicites (gotcha AGENTS.md). SELECT seul : pas
-- d'écriture directe client.
GRANT SELECT ON public.parent_daily_goals TO authenticated;

-- Le jour courant, calendrier tunisien (miroir de app_current_week_start).
CREATE OR REPLACE FUNCTION public.app_current_day()
RETURNS DATE
LANGUAGE sql
STABLE
SET search_path = public
AS $$
  SELECT (clock_timestamp() AT TIME ZONE 'Africa/Tunis')::date;
$$;

-- Le parent lié fixe (upsert) l'objectif du jour courant pour un élève.
CREATE OR REPLACE FUNCTION public.set_parent_daily_goal(p_student UUID, p_target INT)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_day DATE := public.app_current_day();
  v_row public.parent_daily_goals;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_target IS NULL OR p_target < 1 OR p_target > 1000 THEN
    RAISE EXCEPTION 'Invalid daily target (1-1000).';
  END IF;

  IF NOT public.is_parent_of_student(v_user, p_student) THEN
    RAISE EXCEPTION 'Access denied: you are not linked to this student.';
  END IF;

  INSERT INTO public.parent_daily_goals
    (parent_user_id, student_user_id, day, target_exercises)
  VALUES (v_user, p_student, v_day, p_target)
  ON CONFLICT (student_user_id, day)
  DO UPDATE SET
    target_exercises = EXCLUDED.target_exercises,
    parent_user_id = EXCLUDED.parent_user_id,
    updated_at = now()
  RETURNING * INTO v_row;

  RETURN jsonb_build_object(
    'day', to_char(v_row.day, 'YYYY-MM-DD'),
    'target', v_row.target_exercises
  );
END;
$$;

-- Objectif du jour courant + progression (attempts du jour). Lisible par
-- l'élève lui-même ou par un parent lié ; NULL si aucun objectif.
CREATE OR REPLACE FUNCTION public.get_family_daily_goal(p_student UUID)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_day DATE := public.app_current_day();
  v_goal public.parent_daily_goals;
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
  FROM public.parent_daily_goals
  WHERE student_user_id = p_student AND day = v_day;

  IF NOT FOUND THEN
    RETURN NULL;
  END IF;

  SELECT COUNT(*)::INT INTO v_done
  FROM public.attempts
  WHERE user_id = p_student
    AND (completed_at AT TIME ZONE 'Africa/Tunis')::date = v_day;

  RETURN jsonb_build_object(
    'day', to_char(v_goal.day, 'YYYY-MM-DD'),
    'target', v_goal.target_exercises,
    'done', v_done
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.app_current_day() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.set_parent_daily_goal(uuid, int) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.get_family_daily_goal(uuid) FROM PUBLIC, anon;

GRANT EXECUTE ON FUNCTION public.app_current_day() TO authenticated;
GRANT EXECUTE ON FUNCTION public.set_parent_daily_goal(uuid, int) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_family_daily_goal(uuid) TO authenticated;
