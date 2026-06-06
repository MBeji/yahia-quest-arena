-- =========================================================
-- S1 — Economy mint RPCs are NOT browser-callable.
-- ---------------------------------------------------------
-- This is the regression net for the P0 bug that shipped undetected: `award_xp`
-- and `award_coins` were GRANTed to `authenticated`, so any logged-in student
-- could `supabase.rpc('award_xp', { p_user: <self>, p_xp: 9999999 })` and mint
-- unlimited XP/coins, bypassing every anti-cheat gate. The fix
-- (20260606150000_security_p0_hardening.sql) REVOKEs EXECUTE on both from
-- `authenticated`. `spend_coins` is intentionally LEFT GRANTed (it can only
-- reduce the caller's own balance).
--
-- `supabase test db` runs each file inside its own transaction; we wrap in an
-- explicit BEGIN/ROLLBACK so nothing persists and the file is self-contained.
-- =========================================================

BEGIN;
-- pgTAP is normally pre-installed by `supabase test db`; create it defensively
-- so the file is self-contained when run via psql too. Idempotent.
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(7);

-- ---------------------------------------------------------
-- Grant-catalogue assertions (no role switch needed): the privilege simply must
-- not exist for `authenticated` in information_schema.role_routine_grants.
-- ---------------------------------------------------------

SELECT is_empty(
  $$ SELECT 1
       FROM information_schema.role_routine_grants
      WHERE grantee = 'authenticated'
        AND specific_schema = 'public'
        AND routine_name = 'award_xp'
        AND privilege_type = 'EXECUTE' $$,
  'award_xp has NO EXECUTE grant for authenticated (S1 regression net)'
);

SELECT is_empty(
  $$ SELECT 1
       FROM information_schema.role_routine_grants
      WHERE grantee = 'authenticated'
        AND specific_schema = 'public'
        AND routine_name = 'award_coins'
        AND privilege_type = 'EXECUTE' $$,
  'award_coins has NO EXECUTE grant for authenticated (S1 regression net)'
);

-- Also assert anon/public cannot reach them (defence in depth).
SELECT is_empty(
  $$ SELECT 1
       FROM information_schema.role_routine_grants
      WHERE grantee IN ('authenticated', 'anon', 'public')
        AND specific_schema = 'public'
        AND routine_name IN ('award_xp', 'award_coins')
        AND privilege_type = 'EXECUTE' $$,
  'neither award_xp nor award_coins is granted to anon/public/authenticated'
);

-- spend_coins MUST remain callable by authenticated (streak recovery path).
SELECT isnt_empty(
  $$ SELECT 1
       FROM information_schema.role_routine_grants
      WHERE grantee = 'authenticated'
        AND specific_schema = 'public'
        AND routine_name = 'spend_coins'
        AND privilege_type = 'EXECUTE' $$,
  'spend_coins KEEPS its EXECUTE grant for authenticated (streak recovery)'
);

-- ---------------------------------------------------------
-- Executable assertions: as a real `authenticated` user, calling the mint RPCs
-- must raise a permission-denied. We seed a self profile so the failure is the
-- GRANT, not a missing row.
-- ---------------------------------------------------------

-- Fixture: an auth user. The on_auth_user_created trigger auto-creates the
-- matching public.profiles row (handle_new_user), so the profile exists.
INSERT INTO auth.users (id, email)
VALUES ('11111111-1111-1111-1111-111111111111', 's1-user@test.local');

-- Become that authenticated user. auth.uid() reads request.jwt.claims->>'sub'.
-- Set the claims GUC FIRST (while still the superuser test role): the
-- `authenticated` role is not allowed to set `request.jwt.claims` itself, but a
-- SET LOCAL persists across the subsequent role switch within this transaction.
SET LOCAL "request.jwt.claims" = '{"sub":"11111111-1111-1111-1111-111111111111","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$ SELECT public.award_xp('11111111-1111-1111-1111-111111111111'::uuid, 9999999) $$,
  '42501',  -- insufficient_privilege
  NULL,
  'authenticated cannot EXECUTE award_xp (permission denied)'
);

SELECT throws_ok(
  $$ SELECT public.award_coins('11111111-1111-1111-1111-111111111111'::uuid, 9999999) $$,
  '42501',
  NULL,
  'authenticated cannot EXECUTE award_coins (permission denied)'
);

-- spend_coins IS executable: with a zero balance it fails on the business rule
-- ("Insufficient coins…"), NOT on a permission error — proving EXECUTE is granted.
SELECT throws_ok(
  $$ SELECT public.spend_coins('11111111-1111-1111-1111-111111111111'::uuid, 50) $$,
  'P0001',  -- raise_exception (the function's own "Insufficient coins" RAISE)
  'Insufficient coins or profile not found',
  'spend_coins IS executable by authenticated (fails on balance, not on grant)'
);

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
