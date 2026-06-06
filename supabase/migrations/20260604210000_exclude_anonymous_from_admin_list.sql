-- =========================================================
-- Hide leftover anonymous (guest) accounts from admin lists
-- ---------------------------------------------------------
-- Guest access was removed from the app, but pre-existing
-- anonymous auth users (created while guest mode was on) still
-- have profile rows. admin_list_subscriptions listed ALL
-- profiles, so those "Aspirant" (no-email) guests kept showing
-- up. Exclude anonymous users (auth.users.is_anonymous) from
-- the admin subscriptions list. Idempotent.
-- =========================================================

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
  -- Only real (login) accounts — never anonymous/guest leftovers.
  WHERE u.is_anonymous IS NOT TRUE
  ORDER BY p.display_name;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_list_subscriptions() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_list_subscriptions() FROM anon;
GRANT EXECUTE ON FUNCTION public.admin_list_subscriptions() TO authenticated;

-- ---------------------------------------------------------
-- OPTIONAL cleanup (commented out — destructive). Uncomment to
-- permanently delete the leftover anonymous accounts and their
-- data. They have no email and no real value. Cascades through
-- FKs (profiles, attempts, sessions, …).
-- ---------------------------------------------------------
-- DELETE FROM public.profiles p USING auth.users u
-- WHERE u.id = p.id AND u.is_anonymous = true;
-- DELETE FROM auth.users WHERE is_anonymous = true;
