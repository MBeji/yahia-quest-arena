-- =========================================================
-- Open the 5ème année de base school parcours
-- ---------------------------------------------------------
-- MUST BE APPLIED TO THE DB *BEFORE* the content is expected to be visible
-- (see CLAUDE.md §7). Purely a status flip; additive and idempotent.
--
-- WHY: migration 20260617120000 seeded this school-year parcours as
-- `coming_soon` ("en construction") because it had no content. We have now
-- authored the full Mathématiques and Éveil scientifique programmes for the
-- 5ème grade (subjects math-5eme and eveil-scientifique-5eme under grade
-- 5eme-base), so we open its parcours. It is a free `scolaire` parcours
-- (preview_policy='full'), so the whole track is open.
--
-- Idempotent: re-running the UPDATE is a no-op once the status is 'available'.
-- =========================================================

UPDATE public.parcours
SET status = 'available'
WHERE id = 'ecole-5eme-base';
