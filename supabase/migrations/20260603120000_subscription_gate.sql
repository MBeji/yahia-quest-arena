-- =========================================================
-- Premium subscription gate
-- ---------------------------------------------------------
-- Advanced features (the Dungeon, and any future paywalled feature/level)
-- require an ACTIVE subscription. A subscription is purchased out-of-band
-- (the student phones the admin) and provisioned by an admin from the
-- subscription dashboard.
--
--   * three plans : monthly / quarterly / annual,
--   * activation  : admin_set_subscription(user, type) — sets activated_at=now()
--                   and expires_at = now() + plan duration,
--   * revocation  : admin_clear_subscription(user) — blocks paid access,
--   * auto-expiry : access is "active" only while expires_at > now(), so it is
--                   revoked automatically at the end date (no cron needed).
--
-- Prices/durations are mirrored in src/shared/constants/subscription.ts.
-- The new profile columns are intentionally NOT granted to `authenticated`
-- (see 20260602120000_security_hardening_rls), so a student can never
-- self-grant a subscription via PostgREST — only the SECURITY DEFINER admin
-- RPCs (run as table owner) can write them.
-- =========================================================

-- ----- 1. Subscription columns on profiles ---------------------------------
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS subscription_type TEXT
    CHECK (subscription_type IN ('monthly', 'quarterly', 'annual')),
  ADD COLUMN IF NOT EXISTS subscription_activated_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS subscription_expires_at TIMESTAMPTZ;

-- ----- 2. Active-subscription helper ---------------------------------------
CREATE OR REPLACE FUNCTION public.has_active_subscription(p_user UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = p_user
      AND subscription_expires_at IS NOT NULL
      AND subscription_expires_at > now()
  );
$$;

REVOKE ALL ON FUNCTION public.has_active_subscription(UUID) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.has_active_subscription(UUID) FROM anon;
GRANT EXECUTE ON FUNCTION public.has_active_subscription(UUID) TO authenticated;

-- ----- 3. Dungeon access gate now requires an active subscription ----------
-- Adds `has_subscription` to the access state and a new highest-priority
-- 'SUBSCRIPTION' reason so the lobby can show the paywall. Other thresholds
-- (PREREQ / LEVEL / DAILY_LIMIT) are unchanged and still mirror
-- src/shared/constants/gamification.ts.
--
-- The return type (OUT columns) changes vs the previous version, so CREATE OR
-- REPLACE is not enough — drop first. start_dungeon_run() calls this function
-- but plpgsql bodies are resolved at run time, so the drop is safe (it is
-- recreated below before anyone calls it).
DROP FUNCTION IF EXISTS public.get_dungeon_access();

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

  v_sub := public.has_active_subscription(v_user);

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

-- ----- 4. Admin: list every user + subscription state ----------------------
CREATE OR REPLACE FUNCTION public.admin_list_subscriptions()
RETURNS TABLE (
  user_id UUID,
  display_name TEXT,
  email TEXT,
  role TEXT,
  subscription_type TEXT,
  subscription_activated_at TIMESTAMPTZ,
  subscription_expires_at TIMESTAMPTZ,
  is_active BOOLEAN
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  RETURN QUERY
  SELECT
    p.id,
    p.display_name,
    u.email::text,
    p.role,
    p.subscription_type,
    p.subscription_activated_at,
    p.subscription_expires_at,
    (p.subscription_expires_at IS NOT NULL AND p.subscription_expires_at > now())
  FROM public.profiles p
  LEFT JOIN auth.users u ON u.id = p.id
  ORDER BY p.display_name;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_list_subscriptions() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_list_subscriptions() FROM anon;
GRANT EXECUTE ON FUNCTION public.admin_list_subscriptions() TO authenticated;

-- ----- 5. Admin: activate (unlock) a subscription --------------------------
CREATE OR REPLACE FUNCTION public.admin_set_subscription(p_user UUID, p_type TEXT)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_interval INTERVAL;
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  v_interval := CASE p_type
    WHEN 'monthly'   THEN INTERVAL '1 month'
    WHEN 'quarterly' THEN INTERVAL '3 months'
    WHEN 'annual'    THEN INTERVAL '12 months'
    ELSE NULL
  END;

  IF v_interval IS NULL THEN
    RAISE EXCEPTION 'INVALID_SUBSCRIPTION_TYPE:%', p_type;
  END IF;

  UPDATE public.profiles
  SET subscription_type = p_type,
      subscription_activated_at = now(),
      subscription_expires_at = now() + v_interval
  WHERE id = p_user;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'USER_NOT_FOUND';
  END IF;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_set_subscription(UUID, TEXT) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_set_subscription(UUID, TEXT) FROM anon;
GRANT EXECUTE ON FUNCTION public.admin_set_subscription(UUID, TEXT) TO authenticated;

-- ----- 6. Admin: block (revoke) a subscription -----------------------------
CREATE OR REPLACE FUNCTION public.admin_clear_subscription(p_user UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  UPDATE public.profiles
  SET subscription_type = NULL,
      subscription_activated_at = NULL,
      subscription_expires_at = NULL
  WHERE id = p_user;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'USER_NOT_FOUND';
  END IF;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_clear_subscription(UUID) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_clear_subscription(UUID) FROM anon;
GRANT EXECUTE ON FUNCTION public.admin_clear_subscription(UUID) TO authenticated;
