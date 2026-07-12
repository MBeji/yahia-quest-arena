-- =========================================================
-- Public interest counts — anon grant (étude 16 D-7, arbitrage Q-5)
-- ---------------------------------------------------------
-- The « 🔔 N intéressés » badge becomes user-facing on every coming_soon
-- section card, INCLUDING the anonymous public catalogue (/programme and the
-- future /programme/lycee/$annee page — étude 16 D-5). The existing
-- `parcours_interest_counts()` RPC (20260617120000) is already a PII-free
-- aggregate (no user_id in its shape) scoped to coming_soon parcours and
-- SECURITY DEFINER — widening its grant to `anon` is safe and avoids
-- duplicating the function. Voting itself (`toggle_parcours_interest`)
-- remains authenticated-only, unchanged.
-- Idempotent: GRANT is a no-op when already granted.
-- =========================================================

GRANT EXECUTE ON FUNCTION public.parcours_interest_counts() TO anon;
