-- =========================================================
-- S2(a) — Role self-escalation is blocked; legitimate paths preserved.
-- S2(b) — Leaderboard no longer leaks peer UUIDs.
-- ---------------------------------------------------------
-- Fix: 20260606150000_security_p0_hardening.sql.
--
-- S2(a): an authenticated student cannot flip their own `role` to 'parent' or
--   'admin' via a direct PostgREST-style UPDATE — both the column grant (role is
--   not in the authenticated UPDATE grant list) AND the prevent_role_escalation
--   trigger block it. The sanctioned `set_profile_role` RPC allows only
--   'student'/'parent' for the caller; anything else raises 'Invalid role'. A
--   plain INSERT landing the default 'student' role (signup path) stays allowed.
--
-- S2(b): get_subject_leaderboard's result shape must NOT contain `user_id`
--   (peer-UUID leak) and MUST still contain `is_me`.
-- =========================================================

BEGIN;
-- pgTAP is normally pre-installed by `supabase test db`; create it defensively
-- so the file is self-contained when run via psql too. Idempotent.
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(10);

-- ---------------------------------------------------------
-- Fixture: a student auth user (+ trigger-created profile).
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email)
VALUES ('22222222-2222-2222-2222-222222222222', 's2-student@test.local');

-- The signup trigger created the profile with the default role='student'.
SELECT is(
  (SELECT role FROM public.profiles WHERE id = '22222222-2222-2222-2222-222222222222'),
  'student',
  'fixture profile starts as a student (default role)'
);

-- ---------------------------------------------------------
-- S2(b) — leaderboard result shape (catalogue check, role-agnostic).
-- pg_get_function_result renders the full RETURNS TABLE column list as text; we
-- assert `user_id` is absent and `is_me` is present.
-- ---------------------------------------------------------
SELECT unlike(
  (SELECT pg_get_function_result('public.get_subject_leaderboard(text, int)'::regprocedure)),
  '%user_id%'::text,
  'S2(b): get_subject_leaderboard does NOT expose a user_id column'::text
);

SELECT like(
  (SELECT pg_get_function_result('public.get_subject_leaderboard(text, int)'::regprocedure)),
  '%is_me%'::text,
  'S2(b): get_subject_leaderboard still exposes the is_me flag'::text
);

-- ---------------------------------------------------------
-- Become the authenticated student for the escalation checks. Set the claims
-- GUC FIRST (while still the superuser test role) — `authenticated` cannot set
-- request.jwt.claims itself, but SET LOCAL persists across the role switch.
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"22222222-2222-2222-2222-222222222222","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- S2(a) — direct self-escalation to 'parent' must fail. Whether it surfaces as a
-- column-grant denial (42501) or the trigger's RAISE depends on the planner;
-- either way the UPDATE must NOT succeed, so we assert it throws at all.
SELECT throws_ok(
  $$ UPDATE public.profiles SET role = 'parent'
       WHERE id = '22222222-2222-2222-2222-222222222222' $$,
  NULL,
  NULL,
  'S2(a): direct UPDATE profiles SET role=parent is rejected'
);

-- Direct self-escalation to 'admin' must likewise fail.
SELECT throws_ok(
  $$ UPDATE public.profiles SET role = 'admin'
       WHERE id = '22222222-2222-2222-2222-222222222222' $$,
  NULL,
  NULL,
  'S2(a): direct UPDATE profiles SET role=admin is rejected'
);

-- The role must be unchanged after the rejected attempts.
SELECT is(
  (SELECT role FROM public.profiles WHERE id = '22222222-2222-2222-2222-222222222222'),
  'student',
  'S2(a): role is still student after the blocked escalation attempts'
);

-- The sanctioned RPC: a student may set their OWN role to the two onboarding
-- roles. 'parent' succeeds and actually persists.
SELECT lives_ok(
  $$ SELECT public.set_profile_role('parent') $$,
  'S2(a): set_profile_role(parent) succeeds for the caller (onboarding path)'
);

-- ...but any non-onboarding role raises 'Invalid role' (admin is out-of-band).
SELECT throws_ok(
  $$ SELECT public.set_profile_role('admin') $$,
  'P0001',
  'Invalid role',
  'S2(a): set_profile_role(admin) raises Invalid role'
);

-- ...and an arbitrary junk role is rejected the same way.
SELECT throws_ok(
  $$ SELECT public.set_profile_role('whatever') $$,
  'P0001',
  'Invalid role',
  'S2(a): set_profile_role(whatever) raises Invalid role'
);

-- A plain INSERT that lands the DEFAULT student role (the signup / dashboard
-- fallback path) must NOT be blocked. We insert a fresh auth user + profile as
-- the authenticated owner of that new row. role is omitted, so it takes the
-- 'student' default; the trigger must let it through.
-- Drop back to the superuser test role to seed the new user, re-scope the JWT
-- claims (only a superuser may set request.jwt.claims), and clear the
-- trigger-created row so we can prove a manual default-role INSERT is accepted.
RESET ROLE;
INSERT INTO auth.users (id, email)
VALUES ('33333333-3333-3333-3333-333333333333', 's2-signup@test.local')
ON CONFLICT (id) DO NOTHING;
DELETE FROM public.profiles WHERE id = '33333333-3333-3333-3333-333333333333';

-- Re-scope auth.uid() to the new user so the RLS WITH CHECK (auth.uid() = id)
-- passes for the manual insert below, then become that authenticated user.
SET LOCAL "request.jwt.claims" = '{"sub":"33333333-3333-3333-3333-333333333333","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT lives_ok(
  $$ INSERT INTO public.profiles (id, display_name)
       VALUES ('33333333-3333-3333-3333-333333333333', 'Aspirant') $$,
  'S2(a): a plain INSERT with the default student role is allowed (signup not broken)'
);

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
