-- Open the Bac Mathématiques parcours: flip "coming_soon" → "available".
--
-- The lycée pilot shipped its first content unit — math-bac-math, chapitre
-- 01-continuite-limites (cours + resume + quiz + ladder d1→d4, 29 questions),
-- applied by 20260705040649 on top of the section-grade seed 20260704235000.
-- The parcours was seeded `coming_soon` so nothing was user-visible; flipping
-- the status makes the Bac Mathématiques track selectable (Explorer/onboarding)
-- for testing and early access.
--
-- ⚠️ This is a PREMIUM `concours` parcours (is_premium = true,
-- preview_policy = 'difficulty_1'): becoming 'available' opens the FREE
-- PREVIEW only — the chapter comprehension quiz + difficulty-1 missions.
-- The d3 boss / d4 défi tiers stay entitlement-gated (resolve_exercise_access);
-- grant testers via admin_grant_parcours(user, 'concours-bac-math', 'beta').
--
-- Content coverage at opening: 1 chapter (pilot). The remaining chapters land
-- through the same idempotent pipeline and simply appear under the already-open
-- parcours (same rollout shape as the 8ème: 20260704130940).
--
-- Idempotent: re-running is a no-op once the status is already 'available'.
UPDATE public.parcours
SET status = 'available'
WHERE id = 'concours-bac-math';
