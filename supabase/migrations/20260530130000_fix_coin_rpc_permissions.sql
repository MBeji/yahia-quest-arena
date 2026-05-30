-- Fix RPC permissions for award_coins/spend_coins and prevent cross-user abuse.

CREATE OR REPLACE FUNCTION public.award_coins(p_user UUID, p_coins INT)
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  rec public.profiles;
  caller_role TEXT := current_setting('request.jwt.claim.role', true);
BEGIN
  IF p_coins IS NULL OR p_coins <= 0 THEN
    RAISE EXCEPTION 'Invalid coin value';
  END IF;

  -- Allow service role jobs, otherwise enforce self-only updates.
  IF caller_role IS DISTINCT FROM 'service_role' AND auth.uid() IS DISTINCT FROM p_user THEN
    RAISE EXCEPTION 'Not allowed to award coins for another user';
  END IF;

  UPDATE public.profiles
  SET yahia_coins = COALESCE(yahia_coins, 0) + p_coins
  WHERE id = p_user
  RETURNING * INTO rec;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Profile not found';
  END IF;

  RETURN rec;
END;
$$;

CREATE OR REPLACE FUNCTION public.spend_coins(p_user UUID, p_coins INT)
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  rec public.profiles;
  caller_role TEXT := current_setting('request.jwt.claim.role', true);
BEGIN
  IF p_coins IS NULL OR p_coins <= 0 THEN
    RAISE EXCEPTION 'Invalid coin value';
  END IF;

  -- Allow service role jobs, otherwise enforce self-only updates.
  IF caller_role IS DISTINCT FROM 'service_role' AND auth.uid() IS DISTINCT FROM p_user THEN
    RAISE EXCEPTION 'Not allowed to spend coins for another user';
  END IF;

  UPDATE public.profiles
  SET yahia_coins = yahia_coins - p_coins
  WHERE id = p_user AND yahia_coins >= p_coins
  RETURNING * INTO rec;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Insufficient coins or profile not found';
  END IF;

  RETURN rec;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.award_coins(uuid, int) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.spend_coins(uuid, int) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.award_coins(uuid, int) TO authenticated;
GRANT EXECUTE ON FUNCTION public.spend_coins(uuid, int) TO authenticated;
