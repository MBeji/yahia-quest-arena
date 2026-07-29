-- =========================================================
-- Parcours interest votes — toggle, guard, counts, RLS isolation
-- ---------------------------------------------------------
-- Asserts the "register interest in a coming-soon class" mechanism against REAL
-- Postgres with the real `authenticated` role:
--   * toggle_parcours_interest adds then removes the caller's vote (idempotent);
--   * it is allowed ONLY on a coming_soon parcours (rejected on an available one);
--   * parcours_interest_counts reports the live aggregate count;
--   * RLS: a user cannot read another user's vote rows.
-- Le parcours AVAILABLE utilisé comme repoussoir (concours-9eme) vient du
-- catalogue (20260605120000). Le parcours COMING_SOON, lui, est une fixture
-- propre au test : le catalogue n'en fournit aucun de façon stable — chaque
-- campagne de contenu en ouvre (R-8), et s'appuyer sur l'un d'eux fait tomber
-- ce test le jour de son ouverture (ce qu'a fait ecole-7eme-base, ouvert par
-- 20260729120000). La fixture est annulée par le ROLLBACK final.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(11);

-- ---------------------------------------------------------
-- Fixtures (as the superuser test role; no JWT claims yet).
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('a1111111-1111-1111-1111-111111111111', 'pi-a@test.local'),
  ('b2222222-2222-2222-2222-222222222222', 'pi-b@test.local');

-- Parcours coming_soon dédié au test (voir l'en-tête). theme_id existant +
-- grade_id NULL : ne heurte pas l'index unique (theme_id, COALESCE(grade)).
INSERT INTO public.parcours
  (id, name_fr, kind, theme_id, grade_id, is_premium, preview_policy, display_order, icon, color, status)
VALUES
  ('pi-test-coming-soon', 'Fixture — classe en construction', 'libre', 'ecole-tn', NULL,
   false, 'full', 999, 'GraduationCap', 'subject-math', 'coming_soon');

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
  public.toggle_parcours_interest('pi-test-coming-soon'), true,
  'toggle: first call on a coming_soon parcours registers interest (true)');

SELECT is(
  (SELECT count(*)::int FROM public.parcours_interest
     WHERE user_id = 'a1111111-1111-1111-1111-111111111111'
       AND parcours_id = 'pi-test-coming-soon'),
  1, 'toggle: the caller sees their own vote row (RLS read own)');

SELECT is(
  public.toggle_parcours_interest('pi-test-coming-soon'), false,
  'toggle: second call removes the vote (false)');

SELECT is(
  (SELECT count(*)::int FROM public.parcours_interest
     WHERE user_id = 'a1111111-1111-1111-1111-111111111111'),
  0, 'toggle: the vote row is gone after toggling off');

-- Re-arm a live vote for the counts + isolation checks below.
SELECT is(
  public.toggle_parcours_interest('pi-test-coming-soon'), true,
  'toggle: re-registering interest returns true again');

SELECT throws_ok(
  $$ SELECT public.toggle_parcours_interest('concours-9eme') $$,
  'PARCOURS_NOT_COMING_SOON:concours-9eme',
  'guard: voting on an AVAILABLE parcours is rejected');

SELECT is(
  (SELECT interest_count FROM public.parcours_interest_counts()
     WHERE parcours_id = 'pi-test-coming-soon'),
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

-- ---------------------------------------------------------
-- Public counts (étude 16 D-7 / Q-5): the aggregate is anon-readable —
-- the « N intéressés » badge lives on the PUBLIC catalogue — while voting
-- stays authenticated-only.
-- ---------------------------------------------------------
SELECT ok(
  has_function_privilege('anon', 'public.parcours_interest_counts()', 'EXECUTE'),
  'grants: anon can EXECUTE parcours_interest_counts (public badge)');

SELECT ok(
  NOT has_function_privilege('anon', 'public.toggle_parcours_interest(text)', 'EXECUTE'),
  'grants: anon still cannot EXECUTE toggle_parcours_interest (voting needs an account)');

SET LOCAL ROLE anon;
SELECT is(
  (SELECT interest_count FROM public.parcours_interest_counts()
     WHERE parcours_id = 'pi-test-coming-soon'),
  1::bigint, 'counts: an anonymous visitor reads the same PII-free aggregate');
RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
