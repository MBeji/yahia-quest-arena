-- =========================================================
-- Manuel-élève page hosting (PR: manuel-pages-hosting) — the Storage bucket is
-- PRIVATE and carries an authenticated-only read policy. This is the access
-- boundary that keeps the copyrighted scans login-gated, so it is asserted as a
-- regression guard (a future change that makes the bucket public or drops the
-- policy must fail here).
--
-- Catalog-level assertions only (no role-switching against storage.objects), so
-- the test does not depend on the pinned image's default storage grants.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(2);

-- The bucket exists and is NOT public (private → reads require the RLS policy).
SELECT is(
  (SELECT public FROM storage.buckets WHERE id = 'manuel-pages'),
  false,
  'manuel-pages bucket exists and is private'
);

-- The authenticated-read policy is present on storage.objects.
SELECT is(
  (SELECT count(*)::int FROM pg_policies
     WHERE schemaname = 'storage'
       AND tablename = 'objects'
       AND policyname = 'Manuel pages readable by authenticated users'),
  1,
  'the manuel-pages authenticated-read policy exists'
);

SELECT * FROM finish();
ROLLBACK;
