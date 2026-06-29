-- =========================================================
-- Additive: link each chapter to the official CNP student-textbook
-- (manuel élève) pages that cover it.
--
-- Populated by the content pipeline (content:build → chapters.manuel_ref) and
-- surfaced as a login-gated "Pages du manuel" gallery under the course. The
-- column is nullable and the change is idempotent, so it is safe to land ahead
-- of the rendering/UI code that consumes it (DoD §7: additive migrations first).
--
-- Shape: { "code": "<book code>", "pages": "12-15", "pageNumbers": [12,13,14,15] }
-- Only metadata lives here (book code + page list); the page IMAGES are served
-- from a separate, access-controlled Storage bucket. `chapters` is already
-- world-readable (RLS "Chapters readable by all" + baseline SELECT grant), so
-- no new grant is required for an added column.
-- =========================================================

ALTER TABLE public.chapters
  ADD COLUMN IF NOT EXISTS manuel_ref JSONB;

COMMENT ON COLUMN public.chapters.manuel_ref IS
  'Optional {code, pages, pageNumbers[]}: the official CNP manuel élève book code + page range covering this chapter. Set by content:build; rendered as a login-gated "Pages du manuel" gallery.';
