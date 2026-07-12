-- =========================================================
-- Duels — lot 1 schema (étude 05, FableEtudes/05-duels-ligues #lot-1).
-- ---------------------------------------------------------
--   1. Grants: duel_queue is join/leave-able by authenticated (SELECT/INSERT/
--      DELETE, never UPDATE); duels/duel_participants are SELECT-only; anon sees
--      nothing; writes on duels/participants are RPC-only (lot 2).
--   2. Constraints: the status CHECK and the one-entry-per-user queue PK.
--   3. RLS under a REAL authenticated role: duel_queue is owner-only; a duel and
--      its participants are visible ONLY to a participant (both rows — opponent
--      progress), and a non-participant sees nothing.
--   4. is_duel_participant resolves membership without RLS recursion (the queries
--      simply returning instead of erroring proves the recursion break holds).
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(20);

-- ---------------------------------------------------------
-- Fixtures (superuser: RLS bypassed for the seed). Three users; one parcours;
-- a duel between A and B; C is a bystander (non-participant).
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'duel-a@test.local'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'duel-b@test.local'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'duel-c@test.local');

INSERT INTO public.parcours (id, name_fr, kind, theme_id, icon, color)
VALUES ('duel-test-parc', 'Duel Test', 'libre', 'ecole-tn', 'Swords', 'subject-math');

INSERT INTO public.duels (id, parcours_id, question_ids, status, expires_at)
VALUES ('d0000000-0000-0000-0000-000000000001', 'duel-test-parc',
        ARRAY['d1111111-1111-1111-1111-111111111111'::uuid], 'active',
        now() + INTERVAL '24 hours');

INSERT INTO public.duel_participants (duel_id, user_id) VALUES
  ('d0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  ('d0000000-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb');

INSERT INTO public.duel_queue (user_id, parcours_id) VALUES
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'duel-test-parc');

-- =========================================================
-- 1–5. duel_queue grants: join/leave (SELECT/INSERT/DELETE), never UPDATE; anon none.
-- =========================================================
SELECT is(has_table_privilege('authenticated', 'public.duel_queue', 'SELECT'), true,
  'duel_queue: authenticated may SELECT (own row via RLS)');
SELECT is(has_table_privilege('authenticated', 'public.duel_queue', 'INSERT'), true,
  'duel_queue: authenticated may INSERT (join the queue)');
SELECT is(has_table_privilege('authenticated', 'public.duel_queue', 'DELETE'), true,
  'duel_queue: authenticated may DELETE (leave the queue)');
SELECT is(has_table_privilege('authenticated', 'public.duel_queue', 'UPDATE'), false,
  'duel_queue: a queue row is immutable — no UPDATE');
SELECT is(has_table_privilege('anon', 'public.duel_queue', 'SELECT'), false,
  'duel_queue: anon sees nothing');

-- =========================================================
-- 6–11. duels / duel_participants grants: SELECT-only, writes RPC-only, anon none.
-- =========================================================
SELECT is(has_table_privilege('authenticated', 'public.duels', 'SELECT'), true,
  'duels: authenticated may SELECT (participant via RLS)');
SELECT is(
  has_table_privilege('authenticated', 'public.duels', 'INSERT')
    OR has_table_privilege('authenticated', 'public.duels', 'UPDATE')
    OR has_table_privilege('authenticated', 'public.duels', 'DELETE'),
  false, 'duels: no client writes (matchmaking/finalize are RPC-only)');
SELECT is(has_table_privilege('anon', 'public.duels', 'SELECT'), false,
  'duels: anon sees nothing');
SELECT is(has_table_privilege('authenticated', 'public.duel_participants', 'SELECT'), true,
  'duel_participants: authenticated may SELECT (participant via RLS)');
SELECT is(
  has_table_privilege('authenticated', 'public.duel_participants', 'INSERT')
    OR has_table_privilege('authenticated', 'public.duel_participants', 'UPDATE')
    OR has_table_privilege('authenticated', 'public.duel_participants', 'DELETE'),
  false, 'duel_participants: no client writes (scoring is RPC-only)');
SELECT is(has_table_privilege('anon', 'public.duel_participants', 'SELECT'), false,
  'duel_participants: anon sees nothing');

-- =========================================================
-- 12–13. Constraints: status CHECK + one queue entry per user (PK).
-- =========================================================
SELECT throws_ok(
  $$ INSERT INTO public.duels (parcours_id, question_ids, status, expires_at)
     VALUES ('duel-test-parc', ARRAY[]::uuid[], 'brawling', now() + INTERVAL '1 hour') $$,
  '23514', NULL, 'duels: an unknown status violates the CHECK');
SELECT throws_ok(
  $$ INSERT INTO public.duel_queue (user_id, parcours_id)
     VALUES ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'duel-test-parc') $$,
  '23505', NULL, 'duel_queue: a user can hold at most one queue entry (PK)');

-- =========================================================
-- 14–15. is_duel_participant resolves membership (no RLS recursion).
-- =========================================================
SELECT is(
  public.is_duel_participant('d0000000-0000-0000-0000-000000000001',
                             'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  true, 'is_duel_participant: true for a player of the duel');
SELECT is(
  public.is_duel_participant('d0000000-0000-0000-0000-000000000001',
                             'cccccccc-cccc-cccc-cccc-cccccccccccc'),
  false, 'is_duel_participant: false for a bystander');

-- =========================================================
-- 16–17. RLS: duel_queue is owner-only (user A cannot see C's queue row).
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"cccccccc-cccc-cccc-cccc-cccccccccccc","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT is(
  (SELECT count(*)::int FROM public.duel_queue), 1,
  'RLS: user C sees ONLY their own queue row');
RESET ROLE;

SET LOCAL "request.jwt.claims" = '{"sub":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT is_empty(
  $$ SELECT 1 FROM public.duel_queue
       WHERE user_id = 'cccccccc-cccc-cccc-cccc-cccccccccccc' $$,
  'RLS: user A canNOT see another user''s queue row (owner-only)');

-- =========================================================
-- 18–20. RLS: a duel + its participants are participant-only.
-- (Still acting as user A, a participant.)
-- =========================================================
SELECT is(
  (SELECT count(*)::int FROM public.duels
     WHERE id = 'd0000000-0000-0000-0000-000000000001'), 1,
  'RLS: a participant (A) can read their duel');
SELECT is(
  (SELECT count(*)::int FROM public.duel_participants
     WHERE duel_id = 'd0000000-0000-0000-0000-000000000001'), 2,
  'RLS: a participant sees BOTH rows of the duel (opponent progress)');
RESET ROLE;

SET LOCAL "request.jwt.claims" = '{"sub":"cccccccc-cccc-cccc-cccc-cccccccccccc","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT is(
  (SELECT count(*)::int FROM public.duels) +
  (SELECT count(*)::int FROM public.duel_participants), 0,
  'RLS: a non-participant (C) sees neither the duel nor its participants');
RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
