-- =========================================================
-- Content pipeline schema additions
-- ---------------------------------------------------------
-- Supports the versioned content pipeline (see content/ and
-- scripts/content/). Two additive, idempotent columns:
--   * subjects.content_language : native language of a subject's
--     pedagogical content ('ar' | 'fr' | 'en'), drives RTL rendering.
--   * chapters.summary          : course summary (résumé), markdown,
--     distinct from chapters.lesson_content (the full course).
-- =========================================================

ALTER TABLE public.subjects
  ADD COLUMN IF NOT EXISTS content_language TEXT NOT NULL DEFAULT 'fr';

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'subjects_content_language_check'
  ) THEN
    ALTER TABLE public.subjects
      ADD CONSTRAINT subjects_content_language_check
      CHECK (content_language IN ('ar', 'fr', 'en'));
  END IF;
END
$$;

ALTER TABLE public.chapters
  ADD COLUMN IF NOT EXISTS summary TEXT;
