-- Open the 7ème année de base parcours: flip "coming_soon" → "available".
--
-- The 7ème (1re année du collège) now ships full content across its 6 subjects —
-- english-7eme (5 ch.), french-7eme (6 ch.), arabic-7eme (17 ch.), math-7eme
-- (13 ch.), sciences-vie-terre-7eme (7 ch.), sciences-physiques-7eme (6 ch.),
-- their content migrations applied just before this one. The parcours was seeded
-- `coming_soon` ("En construction") by 20260617120000 before any content existed,
-- so the class showed the "En construction" teaser and its content stayed locked
-- (resolve_exercise_access → PARCOURS_COMING_SOON). Flipping the status unlocks it.
--
-- This is a FREE `scolaire` parcours (is_premium = false, preview_policy = 'full'),
-- so becoming 'available' opens it fully — no entitlement required. 8ème stays
-- `coming_soon` (no content yet).
--
-- Idempotent: re-running is a no-op once the status is already 'available'.
-- Mirrors 20260621170000_open_ecole_1ere_5eme_parcours.sql.
UPDATE public.parcours
SET status = 'available'
WHERE id = 'ecole-7eme-base';
