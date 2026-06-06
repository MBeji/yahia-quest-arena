-- =========================================================
-- Security hardening (RLS / privilege) — 2026-06-02 review
-- =========================================================
-- Closes:
--   * CRITICAL: a user could UPDATE their own profile row directly and set
--     role='admin' / xp / yahia_coins / level, escalating privileges and
--     cheating the economy, bypassing the award_xp / spend_coins RPCs.
--   * MEDIUM: students could self-insert badges, and the daily/weekly summary
--     views could leak cross-user aggregates.
--
-- Mechanism: column-level GRANTs restrict what the `authenticated` role (the
-- user-scoped client) may write. The SECURITY DEFINER RPCs (award_xp,
-- award_coins, spend_coins, award_badge_if_new, ...) run as the table OWNER and
-- are therefore UNAFFECTED by these grants — they keep working unchanged.
-- Verified against current app writes: the client only ever writes
-- display_name / avatar_slug / current_streak / last_active_date / role.

-- ----- 1. profiles: restrict client-writable columns ------------------------
REVOKE INSERT, UPDATE ON public.profiles FROM authenticated;

-- Allowed at signup / profile bootstrap.
GRANT INSERT (id, display_name, role) ON public.profiles TO authenticated;

-- Allowed cosmetic + streak-recovery writes. NOTE: xp, level, yahia_coins,
-- avatar_tier, longest_streak, hero_class are intentionally NOT granted — they
-- are mutated only by SECURITY DEFINER RPCs.
GRANT UPDATE (display_name, avatar_slug, current_streak, last_active_date, role)
  ON public.profiles TO authenticated;

-- ----- 2. profiles: block self-escalation to the admin role -----------------
-- A normal PostgREST request (authenticated/anon) may never set role='admin'.
-- service_role tokens and direct SQL (dashboard, no JWT claims) still can, so
-- legitimate admin provisioning is unaffected.
CREATE OR REPLACE FUNCTION public.prevent_role_escalation()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public
AS $$
DECLARE
  v_claims text := current_setting('request.jwt.claims', true);
BEGIN
  IF NEW.role = 'admin'
     AND (TG_OP = 'INSERT' OR NEW.role IS DISTINCT FROM OLD.role)
     AND v_claims IS NOT NULL
     AND COALESCE((v_claims::json ->> 'role'), '') <> 'service_role'
  THEN
    RAISE EXCEPTION 'Not allowed to assign the admin role';
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_prevent_role_escalation ON public.profiles;
CREATE TRIGGER trg_prevent_role_escalation
  BEFORE INSERT OR UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.prevent_role_escalation();

-- ----- 3. student_badges: award only via SECURITY DEFINER RPC ---------------
-- No client code writes badges directly; they are granted by award_badge_if_new.
REVOKE INSERT, UPDATE, DELETE ON public.student_badges FROM authenticated;

-- ----- 4. Aggregate views must respect the caller's RLS ---------------------
ALTER VIEW IF EXISTS public.daily_objective_summary SET (security_invoker = true);
ALTER VIEW IF EXISTS public.weekly_quest_summary SET (security_invoker = true);
