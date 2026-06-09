-- =========================================================
-- Remove the "anti-vieillissement" program (theme + its free parcours)
-- ---------------------------------------------------------
-- The theme was seeded in 20260605120000 and received a free 'libre' parcours in
-- 20260608120000, but it has NO content (no subjects) and the product no longer
-- offers it. Forward-only teardown (history stays immutable). Idempotent.
--
-- Deleting the parcours cascades any parcours_entitlements
-- (parcours_entitlements.parcours_id ON DELETE CASCADE). Deleting the theme
-- cascades its grades/subjects (none) and its parcours (already gone). Any
-- profile whose current_parcours_id pointed here is reset to NULL
-- (profiles.current_parcours_id ON DELETE SET NULL) → the onboarding guard
-- re-routes that student to pick a parcours.
--
-- Behaviour-compatible with the deployed code (themes/parcours are read
-- dynamically), so it can be applied any time — no reversed-order constraint.
-- =========================================================
DELETE FROM public.parcours WHERE id = 'anti-vieillissement';
DELETE FROM public.themes   WHERE id = 'anti-vieillissement';
