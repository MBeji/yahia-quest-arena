-- Atomic coin award function to prevent race conditions
CREATE OR REPLACE FUNCTION public.award_coins(p_user UUID, p_coins INT)
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  rec public.profiles;
BEGIN
  UPDATE public.profiles
  SET yahia_coins = COALESCE(yahia_coins, 0) + p_coins
  WHERE id = p_user
  RETURNING * INTO rec;

  IF NOT FOUND THEN RAISE EXCEPTION 'Profile not found'; END IF;
  RETURN rec;
END;
$$;

-- Atomic coin deduction (for purchases) — fails if insufficient funds
CREATE OR REPLACE FUNCTION public.spend_coins(p_user UUID, p_coins INT)
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  rec public.profiles;
BEGIN
  UPDATE public.profiles
  SET yahia_coins = yahia_coins - p_coins
  WHERE id = p_user AND yahia_coins >= p_coins
  RETURNING * INTO rec;

  IF NOT FOUND THEN RAISE EXCEPTION 'Insufficient coins or profile not found'; END IF;
  RETURN rec;
END;
$$;

-- Restrict access to service_role only
REVOKE EXECUTE ON FUNCTION public.award_coins(uuid, int) FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.spend_coins(uuid, int) FROM PUBLIC, anon, authenticated;
