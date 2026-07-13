-- Free-beta phase: open the WHOLE bac-math parcours (d3 boss + d4 défi included).
--
-- Product context: the platform is currently in its all-free phase — no parcours
-- is monetized yet. The lycée pilot parcours was seeded with the TARGET premium
-- shape (is_premium = true, preview 'difficulty_1'), which correctly locked the
-- ⭐⭐⭐ boss / ⭐⭐⭐⭐ défi tiers behind an entitlement… that nobody sells yet.
--
-- This flips concours-bac-math to fully free for the beta phase:
--   * is_premium = false  -> resolve_exercise_access short-circuits to OPEN
--     (see 20260608121000: `IF v_parcours_id IS NULL OR v_is_premium = false`).
--   * preview_policy = 'full' for coherence with the other free parcours.
--   * kind stays 'concours' — it IS the concours product; only the gate is
--     paused. Re-gating at monetization time (FableEtudes/01-paiement-en-ligne)
--     is the inverse one-line UPDATE (is_premium = true, preview 'difficulty_1'),
--     shipped together with the checkout so the paywall never precedes the
--     ability to pay.
--
-- Idempotent: re-running is a no-op.
UPDATE public.parcours
SET is_premium = false,
    preview_policy = 'full'
WHERE id = 'concours-bac-math';
