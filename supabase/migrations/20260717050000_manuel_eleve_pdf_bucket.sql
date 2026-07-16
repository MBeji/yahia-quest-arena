-- =========================================================
-- Hosting for the official CNP student-textbook (manuel élève) FULL PDFs.
--
-- Sibling of the `manuel-pages` bucket (per-chapter page images): this one
-- holds the complete book as ONE PDF per volume, surfaced on the SUBJECT page
-- (« Manuel officiel » card). Same access posture: PRIVATE bucket, readable
-- ONLY by authenticated users (login is the gate — decision 2026-07-16: the
-- PDF is hosted as-is, no watermark), served through short-lived signed URLs.
--
-- Path convention: `<book code>.pdf` (e.g. `102306.pdf`, `102105P01.pdf`),
-- matched to subjects via `subjects.manuel_refs` ([{ code, label }]).
--
-- Reads: authenticated users only (signed URLs minted server-side with the
-- user's JWT — anon has no policy → no access). Writes: performed out-of-band
-- by scripts/manuel/upload-pdf.mjs with the service role, which bypasses RLS
-- (no insert/update/delete policy is granted to normal users on purpose).
-- =========================================================

-- Private bucket, PDF-only. 60 MB cap: the largest student PDF in the corpus
-- is ~57 MB; Supabase's own per-file ceiling still applies on top.
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES ('manuel-eleve', 'manuel-eleve', false, 62914560, ARRAY['application/pdf'])
ON CONFLICT (id) DO NOTHING;

-- Authenticated users may READ objects in this bucket (and thus obtain signed
-- URLs). Idempotent: drop-then-create so re-applying converges.
DROP POLICY IF EXISTS "Manuel eleve PDFs readable by authenticated users" ON storage.objects;
CREATE POLICY "Manuel eleve PDFs readable by authenticated users"
  ON storage.objects
  FOR SELECT
  TO authenticated
  USING (bucket_id = 'manuel-eleve');
