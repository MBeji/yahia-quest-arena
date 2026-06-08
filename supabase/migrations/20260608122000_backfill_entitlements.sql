-- =========================================================
-- Cutover backfill: carry existing users + payers onto the parcours model
-- ---------------------------------------------------------
-- MUST run AFTER 20260608120000 (parcours + entitlements exist) and BEFORE the
-- gate-switch code deploys, so nobody loses access at the cutover (CLAUDE.md §7).
-- Pure data migration; idempotent (safe to re-run); leaves profiles.subscription_*
-- intact (still read by the legacy admin dashboard until it migrates off them).
-- =========================================================

-- ----- A. Set current_parcours_id from the existing current_grade_id ----------
-- Every current student picked a school grade (9ème, via the 20260605130000
-- backfill). Map that grade to its concours parcours so they are NOT bounced
-- into the new onboarding. Only grades that have a parcours (9ème, 6ème) map;
-- a profile on any other grade stays NULL -> correctly routed to onboarding.
UPDATE public.profiles p
SET current_parcours_id = (
  SELECT par.id FROM public.parcours par WHERE par.grade_id = p.current_grade_id LIMIT 1
)
WHERE p.current_grade_id IS NOT NULL
  AND p.current_parcours_id IS NULL
  AND EXISTS (SELECT 1 FROM public.parcours par WHERE par.grade_id = p.current_grade_id);


-- ----- B. Convert active subscriptions / beta into entitlements ---------------
-- The legacy gate was all-or-nothing (one active subscription unlocked every
-- subject + difficulty-3 content), so a current payer could reach anything.
-- Preserve that reach by granting BOTH concours parcours, carrying over the
-- expiry so auto-expiry semantics are kept (NOT perpetual). source='beta' for
-- beta testers, else 'purchase'. Idempotent via the NOT EXISTS guard (backstopped
-- by the uq_live_entitlement partial unique index).
INSERT INTO public.parcours_entitlements
  (user_id, parcours_id, source, granted_by, granted_at, expires_at)
SELECT
  p.id,
  x.pid,
  CASE WHEN p.subscription_type = 'beta' THEN 'beta' ELSE 'purchase' END,
  NULL,
  COALESCE(p.subscription_activated_at, now()),
  p.subscription_expires_at
FROM public.profiles p
CROSS JOIN (VALUES ('concours-9eme'), ('concours-6eme')) AS x(pid)
WHERE p.subscription_expires_at IS NOT NULL
  AND p.subscription_expires_at > now()
  AND NOT EXISTS (
    SELECT 1 FROM public.parcours_entitlements e
    WHERE e.user_id = p.id
      AND e.parcours_id = x.pid
      AND e.revoked_at IS NULL
  );
