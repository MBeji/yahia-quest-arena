-- =========================================================
-- S30 — The content release journal is OPS-PRIVATE.
-- ---------------------------------------------------------
-- `content_releases` (étude 24 lot 3) replaces the bookkeeping the corpus loses
-- when it leaves the migration framework (D-3): which subjects were applied,
-- from which commit, by whom. It is written only by the private repo's apply
-- workflow, running as service_role.
--
-- Nothing client-side may touch it. The posture is deliberately stricter than
-- the catalogue tables: RLS is enabled with NO policy at all, so a leaked anon
-- or authenticated key sees an empty table rather than an ops trail (git SHAs
-- and subject lists of a private corpus). This file is the regression net for
-- that posture — a future migration adding a read policy or a client GRANT
-- fails here.
--
-- `supabase test db` runs each file inside its own transaction; we wrap in an
-- explicit BEGIN/ROLLBACK so nothing persists and the file is self-contained.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(6);

SELECT has_table('public', 'content_releases', 'content_releases exists');

SELECT columns_are(
  'public',
  'content_releases',
  ARRAY['id', 'applied_at', 'git_sha', 'subjects', 'actor'],
  'content_releases carries exactly the journal columns (étude 24 §4.2)'
);

SELECT ok(
  (SELECT relrowsecurity FROM pg_class WHERE oid = 'public.content_releases'::regclass),
  'RLS is enabled on content_releases'
);

-- Deny-all is expressed by the ABSENCE of policies, so assert that absence
-- explicitly: adding one would silently open the journal.
SELECT is_empty(
  $$ SELECT policyname
       FROM pg_policies
      WHERE schemaname = 'public' AND tablename = 'content_releases' $$,
  'no RLS policy exists — deny-all for every client role by design'
);

SELECT is_empty(
  $$ SELECT 1
       FROM information_schema.role_table_grants
      WHERE table_schema = 'public'
        AND table_name = 'content_releases'
        AND grantee IN ('anon', 'authenticated') $$,
  'neither anon nor authenticated holds any privilege on the journal'
);

SELECT isnt_empty(
  $$ SELECT 1
       FROM information_schema.role_table_grants
      WHERE table_schema = 'public'
        AND table_name = 'content_releases'
        AND grantee = 'service_role' $$,
  'service_role (the apply workflow) can write the journal'
);

SELECT * FROM finish();
ROLLBACK;
