-- =========================================================
-- Open the "4ème année de base" school parcours (now that it has content)
-- ---------------------------------------------------------
-- MUST BE APPLIED TO THE DB *BEFORE* THE CODE/CONTENT THAT DEPENDS ON IT IS
-- VISIBLE (see CLAUDE.md §7). Purely a status flip; additive and idempotent.
--
-- WHY ------------------------------------------------------------------------
-- Migration 20260617120000 seeded one parcours per school grade, with the 10
-- non-exam years (incl. `ecole-4eme-base`) marked `status = 'coming_soon'`
-- ("en construction") because they had no content yet. We have since authored
-- the full 4ème maths programme (subject `math-4eme`, 16 chapters) and started
-- éveil scientifique (`eveil-scientifique-4eme`), all under grade `4eme-base`.
--
-- The parcours `ecole-4eme-base` is what the dashboard/Explorer gates entry on,
-- independently of whether subjects exist under the grade. While it stays
-- `coming_soon` the class shows the "en construction" teaser and cannot be
-- entered. This migration flips it to `available` so the 4ème content becomes
-- visible and enterable. (It is a free `scolaire` parcours with
-- preview_policy='full', so the whole track is open.)
--
-- Idempotent: re-running the UPDATE is a no-op once the status is 'available'.
-- =========================================================

UPDATE public.parcours
SET status = 'available'
WHERE id = 'ecole-4eme-base';
