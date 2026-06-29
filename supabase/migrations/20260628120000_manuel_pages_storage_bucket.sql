-- =========================================================
-- Hosting for the official CNP student-textbook (manuel élève) page images.
--
-- A PRIVATE Storage bucket whose objects are readable ONLY by authenticated
-- users (login-gated, per the feature decision). The page images carry a ©
-- watermark baked in by the render pipeline; this RLS is the access boundary.
--
-- Path convention: `<book code>/<page>.webp` (e.g. `103304/12.webp`), matched
-- to chapters via `chapters.manuel_ref` ({ code, pages, pageNumbers }).
--
-- Reads: authenticated users only (signed URLs minted server-side with the
-- user's JWT — anon has no policy → no access). Writes: performed out-of-band
-- by the render pipeline with the service role, which bypasses RLS (no
-- insert/update/delete policy is granted to normal users on purpose).
-- =========================================================

-- Private bucket, webp-only, modest per-object size cap.
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES ('manuel-pages', 'manuel-pages', false, 5242880, ARRAY['image/webp'])
ON CONFLICT (id) DO NOTHING;

-- Authenticated users may READ objects in this bucket (and thus obtain signed
-- URLs). Idempotent: drop-then-create so re-applying converges.
DROP POLICY IF EXISTS "Manuel pages readable by authenticated users" ON storage.objects;
CREATE POLICY "Manuel pages readable by authenticated users"
  ON storage.objects
  FOR SELECT
  TO authenticated
  USING (bucket_id = 'manuel-pages');
