-- =========================================================
-- Parcours interest votes — toggle, guard, counts, RLS isolation
-- ---------------------------------------------------------
-- Asserts the "register interest in a coming-soon class" mechanism against REAL
-- Postgres with the real `authenticated` role:
--   * toggle_parcours_interest adds then removes the caller's vote (idempotent);
--   * it is allowed ONLY on a coming_soon parcours (rejected on an available one);
--   * parcours_interest_counts reports the live aggregate count;
--   * RLS: a user cannot read another user's vote rows.
-- The school parcours (concours-9eme available, ecole-1ere-base coming_soon) come
-- from 20260605120000 + 20260617120000; fixtures only add users.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(8);

-- ---------------------------------------------------------
-- Fixtures (as the superuser test role; no JWT claims yet).
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('a1111111-1111-1111-1111-111111111111', 'pi-a@test.local'),
  ('b2222222-2222-2222-2222-222222222222', 'pi-b@test.local');

INSERT INTO public.profiles (id, display_name) VALUES
  ('a1111111-1111-1111-1111-111111111111', 'InterestA'),
  ('b2222222-2222-2222-2222-222222222222', 'InterestB')
ON CONFLICT (id) DO NOTHING;

-- ---------------------------------------------------------
-- As user A (authenticated): toggle on/off + guard.
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"a1111111-1111-1111-1111-111111111111","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  public.toggle_parcours_interest('ecole-1ere-base'), true,
  'toggle: first call on a coming_soon parcours registers interest (true)');

SELECT is(
  (SELECT count(*)::int FROM public.parcours_interest
     WHERE user_id = 'a1111111-1111-1111-1111-111111111111'
       AND parcours_id = 'ecole-1ere-base'),
  1, 'toggle: the caller sees their own vote row (RLS read own)');

SELECT is(
  public.toggle_parcours_interest('ecole-1ere-base'), false,
  'toggle: second call removes the vote (false)');

SELECT is(
  (SELECT count(*)::int FROM public.parcours_interest
     WHERE user_id = 'a1111111-1111-1111-1111-111111111111'),
  0, 'toggle: the vote row is gone after toggling off');

-- Re-arm a live vote for the counts + isolation checks below.
SELECT is(
  public.toggle_parcours_interest('ecole-1ere-base'), true,
  'toggle: re-registering interest returns true again');

SELECT throws_ok(
  $$ SELECT public.toggle_parcours_interest('concours-9eme') $$,
  'PARCOURS_NOT_COMING_SOON:concours-9eme',
  'guard: voting on an AVAILABLE parcours is rejected');

SELECT is(
  (SELECT interest_count FROM public.parcours_interest_counts()
     WHERE parcours_id = 'ecole-1ere-base'),
  1::bigint, 'counts: the aggregate reflects the live vote');

RESET ROLE;

-- ---------------------------------------------------------
-- As user B: cannot read user A's vote rows (RLS isolation).
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"b2222222-2222-2222-2222-222222222222","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.parcours_interest
     WHERE user_id = 'a1111111-1111-1111-1111-111111111111'),
  0, 'RLS: a user cannot read another user''s interest votes');

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
