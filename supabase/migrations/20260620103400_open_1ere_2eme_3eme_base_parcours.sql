-- =========================================================
-- Open the 1ère / 2ème / 3ème année de base school parcours
-- ---------------------------------------------------------
-- MUST BE APPLIED TO THE DB *BEFORE* the content is expected to be visible
-- (see CLAUDE.md §7). Purely a status flip; additive and idempotent.
--
-- WHY: migration 20260617120000 seeded these school-year parcours as
-- `coming_soon` ("en construction") because they had no content. We have now
-- authored the full maths programmes for these grades (subjects math-1ere,
-- math-2eme, math-3eme under grades 1ere-base / 2eme-base / 3eme-base), so we
-- open their parcours. They are free `scolaire` parcours (preview_policy='full'),
-- so the whole track is open.
--
-- Idempotent: re-running the UPDATE is a no-op once the status is 'available'.
-- =========================================================

UPDATE public.parcours
SET status = 'available'
WHERE id IN ('ecole-1ere-base', 'ecole-2eme-base', 'ecole-3eme-base');
