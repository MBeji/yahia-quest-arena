-- Fix RPC permissions for award_xp and prevent cross-user abuse.
-- The app calls award_xp from the authenticated client context.

CREATE OR REPLACE FUNCTION public.award_xp(p_user UUID, p_xp INT)
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  rec public.profiles;
  today DATE := CURRENT_DATE;
  new_streak INT;
  new_level INT;
  new_class TEXT;
  new_tier INT;
  caller_role TEXT := current_setting('request.jwt.claim.role', true);
BEGIN
  IF p_xp IS NULL OR p_xp < 0 THEN
    RAISE EXCEPTION 'Invalid xp value';
  END IF;

  -- Allow service role jobs, otherwise enforce self-only updates.
  IF caller_role IS DISTINCT FROM 'service_role' AND auth.uid() IS DISTINCT FROM p_user THEN
    RAISE EXCEPTION 'Not allowed to award XP for another user';
  END IF;

  SELECT * INTO rec FROM public.profiles WHERE id = p_user FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Profile not found';
  END IF;

  -- Streak logic
  IF rec.last_active_date IS NULL THEN
    new_streak := 1;
  ELSIF rec.last_active_date = today THEN
    new_streak := rec.current_streak;
  ELSIF rec.last_active_date = today - INTERVAL '1 day' THEN
    new_streak := rec.current_streak + 1;
  ELSE
    new_streak := 1;
  END IF;

  -- Level curve: each level = 200 xp
  new_level := GREATEST(1, ((rec.xp + p_xp) / 200) + 1);

  -- Hero class progression
  new_class := CASE
    WHEN new_level >= 50 THEN 'S-Rank Legend'
    WHEN new_level >= 31 THEN 'Elite du Concours'
    WHEN new_level >= 21 THEN 'Maitre des Langues'
    WHEN new_level >= 11 THEN 'Guerrier des Equations'
    WHEN new_level >= 6 THEN 'Aspirant Academicien'
    ELSE 'Candidat Civil'
  END;

  new_tier := LEAST(6, GREATEST(1, (new_level / 8) + 1));

  UPDATE public.profiles
  SET
    xp = xp + p_xp,
    level = new_level,
    hero_class = new_class,
    avatar_tier = new_tier,
    current_streak = new_streak,
    longest_streak = GREATEST(longest_streak, new_streak),
    last_active_date = today
  WHERE id = p_user
  RETURNING * INTO rec;

  RETURN rec;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.award_xp(uuid, int) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.award_xp(uuid, int) TO authenticated;
