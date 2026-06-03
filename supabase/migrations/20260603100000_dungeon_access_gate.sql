-- =========================================================
-- Dungeon access gate
-- ---------------------------------------------------------
-- The Dungeon now requires real prior progress and limits the
-- number of runs per day by player level:
--   * prerequisite : attempted exercises in >= 2 subjects AND
--     >= 3 distinct chapters,
--   * daily runs   : min(level, 5)  (level 0 => 0 => no access).
-- Thresholds mirror src/shared/constants/gamification.ts.
-- =========================================================

-- Read-only access state for the current user (drives the UI + the gate).
CREATE OR REPLACE FUNCTION public.get_dungeon_access()
RETURNS TABLE (
  level INT,
  max_runs_per_day INT,
  runs_today INT,
  subjects_done INT,
  chapters_done INT,
  required_subjects INT,
  required_chapters INT,
  can_access BOOLEAN,
  reason TEXT
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_level INT;
  v_max INT;
  v_runs INT;
  v_subjects INT;
  v_chapters INT;
  c_req_subjects CONSTANT INT := 2;
  c_req_chapters CONSTANT INT := 3;
  c_cap CONSTANT INT := 5;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT p.level INTO v_level FROM public.profiles p WHERE p.id = v_user;
  v_level := COALESCE(v_level, 0);
  v_max := LEAST(GREATEST(v_level, 0), c_cap);

  SELECT COUNT(DISTINCT a.subject_id) INTO v_subjects
  FROM public.attempts a WHERE a.user_id = v_user;

  SELECT COUNT(DISTINCT e.chapter_id) INTO v_chapters
  FROM public.attempts a
  JOIN public.exercises e ON e.id = a.exercise_id
  WHERE a.user_id = v_user;

  SELECT COUNT(*) INTO v_runs
  FROM public.dungeon_runs d
  WHERE d.user_id = v_user
    AND d.created_at >= date_trunc('day', timezone('utc', now()));

  level := v_level;
  max_runs_per_day := v_max;
  runs_today := v_runs;
  subjects_done := v_subjects;
  chapters_done := v_chapters;
  required_subjects := c_req_subjects;
  required_chapters := c_req_chapters;

  IF v_subjects < c_req_subjects OR v_chapters < c_req_chapters THEN
    can_access := false; reason := 'PREREQ';
  ELSIF v_max < 1 THEN
    can_access := false; reason := 'LEVEL';
  ELSIF v_runs >= v_max THEN
    can_access := false; reason := 'DAILY_LIMIT';
  ELSE
    can_access := true; reason := '';
  END IF;

  RETURN NEXT;
END;
$$;

REVOKE ALL ON FUNCTION public.get_dungeon_access() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.get_dungeon_access() FROM anon;
GRANT EXECUTE ON FUNCTION public.get_dungeon_access() TO authenticated;

-- Enforce the gate at run creation (authoritative — cannot be bypassed by
-- calling the RPC directly).
CREATE OR REPLACE FUNCTION public.start_dungeon_run()
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_run_id UUID;
  v_access RECORD;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT * INTO v_access FROM public.get_dungeon_access();
  IF NOT v_access.can_access THEN
    RAISE EXCEPTION 'DUNGEON_LOCKED:%', v_access.reason;
  END IF;

  INSERT INTO public.dungeon_runs (user_id)
  VALUES (v_user)
  RETURNING id INTO v_run_id;

  RETURN v_run_id;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.start_dungeon_run() FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.start_dungeon_run() FROM anon;
GRANT EXECUTE ON FUNCTION public.start_dungeon_run() TO authenticated;
