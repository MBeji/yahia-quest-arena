-- =========================================================
-- Premium subjects
-- ---------------------------------------------------------
-- A subject can be flagged as premium: the whole module (its chapters,
-- exercises and quiz) is then reserved to users with an ACTIVE subscription,
-- regardless of level. Enforced server-side in quest.startExerciseSession and
-- surfaced (locked + paywall) on the dashboard and subject page.
--
-- Used by the standalone "Maîtrise du français" practice module, which is
-- independent of the school curriculum. The flag is also written by the
-- content pipeline (subject.json -> isPremium), so this migration only needs
-- to add the column; generated content migrations keep it in sync.
-- =========================================================

ALTER TABLE public.subjects
  ADD COLUMN IF NOT EXISTS is_premium BOOLEAN NOT NULL DEFAULT false;
