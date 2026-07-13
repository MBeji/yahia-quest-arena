-- =========================================================
-- get_global_leaderboard — materialized ranking (perf audit H1).
-- ---------------------------------------------------------
-- The board reads a materialized view (others) plus the caller's LIVE rank.
-- Assert the ranking is correct, every student appears, and the caller's own
-- row is flagged is_me. We REFRESH the MV (non-concurrent — transaction-safe)
-- after seeding so it reflects the test fixtures.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(4);

-- Three students with distinct XP. Profiles are auto-created by handle_new_user
-- on the auth.users insert; we set role + xp as the superuser (RLS/grants apply
-- only to the client roles, not here).
INSERT INTO auth.users (id, email) VALUES
  ('aa000000-0000-0000-0000-000000000001', 'lb-a@test.local'),
  ('bb000000-0000-0000-0000-000000000002', 'lb-b@test.local'),
  ('cc000000-0000-0000-0000-000000000003', 'lb-c@test.local');

UPDATE public.profiles SET role = 'student', xp = 300 WHERE id = 'aa000000-0000-0000-0000-000000000001';
UPDATE public.profiles SET role = 'student', xp = 200 WHERE id = 'bb000000-0000-0000-0000-000000000002';
UPDATE public.profiles SET role = 'student', xp = 100 WHERE id = 'cc000000-0000-0000-0000-000000000003';

-- Reflect the fixtures into the precomputed ranking.
REFRESH MATERIALIZED VIEW public.global_leaderboard_ranked;

-- Call as student A (top XP).
SET LOCAL "request.jwt.claims" = '{"sub":"aa000000-0000-0000-0000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT rank FROM public.get_global_leaderboard(50) WHERE is_me),
  1::bigint,
  'get_global_leaderboard: the top-XP caller is rank 1 (computed live)'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_global_leaderboard(50) WHERE is_me),
  1,
  'get_global_leaderboard: exactly one is_me row (the caller)'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_global_leaderboard(50)),
  3,
  'get_global_leaderboard: every student appears within the limit'
);

-- Ordering + LIVE profile join: rank 2 is the middle-XP student, xp shown live.
SELECT is(
  (SELECT xp FROM public.get_global_leaderboard(50) WHERE rank = 2),
  200,
  'get_global_leaderboard: rank 2 is the 200-XP student (fields joined live)'
);

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
