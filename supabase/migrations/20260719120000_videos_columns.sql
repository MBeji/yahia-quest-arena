-- =========================================================
-- Étude 23 — Vidéos explicatives (lot 1, socle données).
-- Additive: two JSONB columns compiled from content/videos.json + the chapter/
-- exercise refs (same pattern as chapters.manuel_ref — set by content:build,
-- never hand-edited). No new RLS/grant: both tables are already world-readable
-- and the payload is public curated content (a display subset of a versioned
-- registry — no free URL, only provider + validated videoId, étude 23 D-10).
--
-- chapters.videos: ordered array (0–3) of compiled display objects for the
--   chapter's « En vidéo » section; the first is the default review video (R-6).
--   NOT NULL DEFAULT '[]' so a chapter without videos carries an empty list.
-- exercises.correction_video: single compiled object (nullable) — the exercise's
--   dedicated correction video, overriding the chapter fallback on the result
--   screen. NULL = fall back to the chapter's first video.
--
-- Compiled shape (per object):
--   { id, provider, videoId, title, channel, lang, durationSec, startSec?, endSec? }
-- =========================================================

ALTER TABLE public.chapters
  ADD COLUMN IF NOT EXISTS videos JSONB NOT NULL DEFAULT '[]'::jsonb;

ALTER TABLE public.exercises
  ADD COLUMN IF NOT EXISTS correction_video JSONB;

COMMENT ON COLUMN public.chapters.videos IS
  'Compiled display objects (0-3, ordered) of the chapter''s curated explainer videos (étude 23). Source of truth: content/videos.json + chapter.json refs. Set by content:build; never hand-edited.';
COMMENT ON COLUMN public.exercises.correction_video IS
  'Compiled display object of the exercise''s dedicated correction video (étude 23), overriding the chapter fallback on the result screen. NULL = use the chapter''s first video.';
