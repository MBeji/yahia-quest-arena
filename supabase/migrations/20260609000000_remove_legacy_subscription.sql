-- =========================================================
-- DESTRUCTIVE cleanup: remove the legacy subscription model.
-- ---------------------------------------------------------
-- Premium access is now per-parcours entitlements (migrations
-- 20260608120000..123000). The active-subscription backfill (20260608122000)
-- already converted every active/beta subscription into parcours_entitlements,
-- so dropping the legacy columns/RPCs loses NO access data. No hand-written
-- src/ code reads subscription_* / has_active_subscription anymore (the gate
-- uses resolve_exercise_access; the dungeon uses a concours entitlement).
--
-- ⚠ DEPLOY ORDER IS *REVERSED* vs CLAUDE.md §7 — this is a TEARDOWN, not an
-- additive change. The currently-running prod code (pre-deploy) still calls the
-- admin subscription RPCs, so dropping them first would 500 mid-cutover. Correct
-- order for PROD:
--     1. deploy the branch code (it no longer references these objects),
--     2. verify prod,
--     3. THEN apply this migration to the prod DB,
--     4. regenerate src/shared/integrations/supabase/types.ts (supabase gen types).
-- Irreversible (DROP FUNCTION / DROP COLUMN) — confirm a prod backup first.
-- Idempotent (IF EXISTS guards), safe to re-run.
-- =========================================================

-- 1) Rewrite admin_review_beta_request to be STATUS-ONLY (drop the subscription_*
--    write at the old lines 153-159). The per-parcours `beta` entitlement is now
--    granted by reviewBetaRequest() (beta-access.server.ts) via admin_grant_parcours.
--    Same signature, so CREATE OR REPLACE swaps the body in place.
CREATE OR REPLACE FUNCTION public.admin_review_beta_request(p_request UUID, p_approve BOOLEAN)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID;
  v_status TEXT;
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT user_id, status INTO v_user, v_status
  FROM public.beta_access_requests
  WHERE id = p_request;

  IF v_user IS NULL THEN
    RAISE EXCEPTION 'REQUEST_NOT_FOUND';
  END IF;
  IF v_status <> 'pending' THEN
    RAISE EXCEPTION 'ALREADY_REVIEWED';
  END IF;

  UPDATE public.beta_access_requests
  SET status = CASE WHEN p_approve THEN 'approved' ELSE 'rejected' END,
      reviewed_at = now(),
      reviewed_by = auth.uid()
  WHERE id = p_request;
  -- Premium grant is now a per-parcours `beta` entitlement issued by the server
  -- fn (reviewBetaRequest -> admin_grant_parcours). No subscription_* write here.
END;
$$;

REVOKE ALL ON FUNCTION public.admin_review_beta_request(UUID, BOOLEAN) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_review_beta_request(UUID, BOOLEAN) TO authenticated;

-- 2) Drop the four dormant legacy RPCs (explicit signatures hit the exact overloads).
DROP FUNCTION IF EXISTS public.has_active_subscription(UUID);
DROP FUNCTION IF EXISTS public.admin_list_subscriptions();
DROP FUNCTION IF EXISTS public.admin_clear_subscription(UUID);
DROP FUNCTION IF EXISTS public.admin_set_subscription(UUID, TEXT);

-- 3) Drop the CHECK constraint, then the three dormant profile columns.
ALTER TABLE public.profiles DROP CONSTRAINT IF EXISTS profiles_subscription_type_check;
ALTER TABLE public.profiles
  DROP COLUMN IF EXISTS subscription_type,
  DROP COLUMN IF EXISTS subscription_activated_at,
  DROP COLUMN IF EXISTS subscription_expires_at;
