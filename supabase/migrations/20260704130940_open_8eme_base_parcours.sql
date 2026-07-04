-- Open the 8ème année de base parcours: flip "coming_soon" → "available".
--
-- The 8ème (2e année du collège) now ships content across 4 of its 6 subjects —
-- english-8eme (5 ch.), math-8eme (12 ch.), sciences-physiques-8eme (6 ch.) and
-- sciences-vie-terre-8eme (8 ch.) = 31 chapters, 186 exercises — whose content
-- migrations (20260704130934..37) applied just before this one. The two remaining
-- subjects (arabe, français) are still in authoring and will be added later via the
-- same idempotent pipeline (stable slugs → additive migrations, no rework).
--
-- The parcours was seeded `coming_soon` ("En construction") by 20260617120000
-- before any content existed, so the class showed the "En construction" teaser and
-- its content stayed locked (resolve_exercise_access → PARCOURS_COMING_SOON).
-- Flipping the status unlocks the 4 available subjects now; the later arabe/français
-- content simply appears under the already-open parcours when it lands.
--
-- This is a FREE `scolaire` parcours (is_premium = false, preview_policy = 'full'),
-- so becoming 'available' opens it fully — no entitlement required.
--
-- Idempotent: re-running is a no-op once the status is already 'available'.
-- Mirrors 20260703210000_open_7eme_base_parcours.sql.
UPDATE public.parcours
SET status = 'available'
WHERE id = 'ecole-8eme-base';
