-- =========================================================
-- Fix: daily objectives & weekly quests never progressed
-- ---------------------------------------------------------
-- Root cause: nothing ever CREATED the daily_objectives /
-- weekly_quests rows. The submit_exercise_attempt RPC only
-- ran UPDATE ... WHERE objective_type='3_exercises' AND
-- objective_date=today, which matched 0 rows, so progress
-- stayed at 0 and the dashboard showed an empty goal.
--
-- Fix: make row creation idempotent (unique keys) and add an
-- ensure_daily_weekly_goals() helper that upserts today's
-- daily objective and this week's weekly quest. The app calls
-- it on dashboard load and just before each submission, so the
-- existing UPDATE in submit_exercise_attempt now has a row to
-- increment. Idempotent / safe to re-run.
-- =========================================================

-- 1. Remove legacy duplicate rows (a past bug created dupes) so the unique
--    constraints below can be added. Keep one row per natural key.
DELETE FROM public.daily_objectives a
USING public.daily_objectives b
WHERE a.ctid < b.ctid
  AND a.user_id = b.user_id
  AND a.objective_type = b.objective_type
  AND a.objective_date = b.objective_date;

DELETE FROM public.weekly_quests a
USING public.weekly_quests b
WHERE a.ctid < b.ctid
  AND a.user_id = b.user_id
  AND a.quest_type = b.quest_type
  AND a.week_start_date = b.week_start_date;

-- 2. Idempotency keys for the upserts.
ALTER TABLE public.daily_objectives
  DROP CONSTRAINT IF EXISTS uq_daily_objective;
ALTER TABLE public.daily_objectives
  ADD CONSTRAINT uq_daily_objective UNIQUE (user_id, objective_type, objective_date);

ALTER TABLE public.weekly_quests
  DROP CONSTRAINT IF EXISTS uq_weekly_quest;
ALTER TABLE public.weekly_quests
  ADD CONSTRAINT uq_weekly_quest UNIQUE (user_id, quest_type, week_start_date);

-- 3. Ensure the standard daily objective (do 3 exercises) and weekly quest
--    (beat 2 bosses) exist for the caller. SECURITY DEFINER so it can insert
--    regardless of policy nuances, but it only ever acts on auth.uid().
CREATE OR REPLACE FUNCTION public.ensure_daily_weekly_goals(p_user uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_today      DATE := (clock_timestamp() AT TIME ZONE 'UTC')::date;
  v_week_start DATE := date_trunc('week', clock_timestamp() AT TIME ZONE 'UTC')::date;
BEGIN
  -- Only ever create goals for the authenticated caller.
  IF p_user IS NULL OR p_user <> auth.uid() THEN
    RETURN;
  END IF;

  INSERT INTO public.daily_objectives
    (user_id, objective_type, target_value, objective_date, xp_reward, coin_reward)
  VALUES (p_user, '3_exercises', 3, v_today, 50, 10)
  ON CONFLICT (user_id, objective_type, objective_date) DO NOTHING;

  INSERT INTO public.weekly_quests
    (user_id, quest_type, target_value, week_start_date, xp_reward, coin_reward)
  VALUES (p_user, 'beat_2_bosses', 2, v_week_start, 100, 25)
  ON CONFLICT (user_id, quest_type, week_start_date) DO NOTHING;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.ensure_daily_weekly_goals(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.ensure_daily_weekly_goals(uuid) TO authenticated;
