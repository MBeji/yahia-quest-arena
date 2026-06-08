-- =========================================================
-- Dungeon access gate — reposition to a CONCOURS parcours entitlement
-- ---------------------------------------------------------
-- The Dungeon used to be gated on `has_active_subscription`. The premium model
-- moved to per-parcours entitlements, so the Dungeon is now a premium perk
-- reserved to holders of a concours parcours entitlement (the family pack is
-- included transparently via has_parcours_entitlement).
--
-- Only the source of `v_sub` changes. The OUT columns (incl. `has_subscription`)
-- and the highest-priority `reason='SUBSCRIPTION'` branch are kept identical so
-- the dungeon server fn / lobby UI are untouched. The OUT shape is unchanged, so
-- CREATE OR REPLACE is sufficient (no DROP needed).
--
-- DEPLOY ORDER (CLAUDE.md §7): apply this migration to the DB BEFORE pushing the
-- dependent code — pushing to `main` auto-deploys to Vercel prod, so the schema
-- must support the new gate first.
-- =========================================================

CREATE OR REPLACE FUNCTION public.get_dungeon_access()
RETURNS TABLE (
  level INT,
  max_runs_per_day INT,
  runs_today INT,
  subjects_done INT,
  chapters_done INT,
  required_subjects INT,
  required_chapters INT,
  has_subscription BOOLEAN,
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
  v_sub BOOLEAN;
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

  -- The dungeon is a premium perk reserved to holders of a concours parcours
  -- entitlement (family pack included via has_parcours_entitlement).
  v_sub := EXISTS (
    SELECT 1 FROM public.parcours p
    WHERE p.kind = 'concours'
      AND public.has_parcours_entitlement(v_user, p.id)
  );

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
  has_subscription := v_sub;

  IF NOT v_sub THEN
    can_access := false; reason := 'SUBSCRIPTION';
  ELSIF v_subjects < c_req_subjects OR v_chapters < c_req_chapters THEN
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
