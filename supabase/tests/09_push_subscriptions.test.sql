-- =========================================================
-- S9 — push_subscriptions: RPC-only access, no direct table grants.
-- ---------------------------------------------------------
-- push_subscriptions (20260613120000_push_subscriptions.sql) ships with RLS
-- enabled, NO table policies, and NO direct grants to anon/authenticated.
-- All client writes go through the SECURITY DEFINER RPCs:
--   save_push_subscription  → GRANT EXECUTE TO authenticated
--   delete_push_subscription → GRANT EXECUTE TO authenticated
-- The cron sender (notifications.cron.server.ts) reads/prunes via the
-- service-role key, which bypasses RLS.
--
-- This suite asserts:
--   S9(a) — no direct table grants → authenticated/anon cannot reach the
--            table through PostgREST.
--   S9(b) — save_push_subscription IS callable by authenticated.
--   S9(c) — delete_push_subscription IS callable by authenticated.
--   S9(d) — neither RPC is callable by anon/public.
--   S9(e) — authenticated cannot SELECT the table directly (42501).
--   S9(f) — save_push_subscription inserts a row on behalf of the caller.
--   S9(g) — delete_push_subscription removes the caller's own endpoint.
--   S9(h) — user isolation: user B cannot delete user A's subscription
--            (WHERE user_id = auth.uid() guard).
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(8);

-- ---------------------------------------------------------
-- S9(a): no direct table grants to anon or authenticated.
-- ---------------------------------------------------------
SELECT is_empty(
  $$ SELECT 1
       FROM information_schema.role_table_grants
      WHERE table_schema = 'public'
        AND table_name   = 'push_subscriptions'
        AND grantee IN ('anon', 'authenticated') $$,
  'S9(a): push_subscriptions has no direct table grants to anon or authenticated'
);

-- ---------------------------------------------------------
-- S9(b): save_push_subscription IS granted EXECUTE to authenticated.
-- ---------------------------------------------------------
SELECT isnt_empty(
  $$ SELECT 1
       FROM information_schema.role_routine_grants
      WHERE grantee          = 'authenticated'
        AND specific_schema  = 'public'
        AND routine_name     = 'save_push_subscription'
        AND privilege_type   = 'EXECUTE' $$,
  'S9(b): save_push_subscription IS granted EXECUTE to authenticated'
);

-- ---------------------------------------------------------
-- S9(c): delete_push_subscription IS granted EXECUTE to authenticated.
-- ---------------------------------------------------------
SELECT isnt_empty(
  $$ SELECT 1
       FROM information_schema.role_routine_grants
      WHERE grantee          = 'authenticated'
        AND specific_schema  = 'public'
        AND routine_name     = 'delete_push_subscription'
        AND privilege_type   = 'EXECUTE' $$,
  'S9(c): delete_push_subscription IS granted EXECUTE to authenticated'
);

-- ---------------------------------------------------------
-- S9(d): neither RPC is callable by anon or public.
-- ---------------------------------------------------------
SELECT is_empty(
  $$ SELECT 1
       FROM information_schema.role_routine_grants
      WHERE grantee         IN ('anon', 'public')
        AND specific_schema  = 'public'
        AND routine_name    IN ('save_push_subscription', 'delete_push_subscription')
        AND privilege_type   = 'EXECUTE' $$,
  'S9(d): neither push RPC is granted to anon or public'
);

-- ---------------------------------------------------------
-- Fixtures: two auth users (triggers auto-create their profiles).
-- The UUID prefix 99000001/99000002 does not collide with any other
-- test file in this suite (each file is isolated in its own ROLLBACK).
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email)
VALUES ('99000001-0000-0000-0000-000000000001', 'push-s9-user1@test.local'),
       ('99000002-0000-0000-0000-000000000002', 'push-s9-user2@test.local');

-- Switch to user 1 for the runtime assertions.
-- Set the JWT claims FIRST (only the superuser test role may write this GUC);
-- the claim persists across the subsequent SET LOCAL ROLE.
SET LOCAL "request.jwt.claims" = '{"sub":"99000001-0000-0000-0000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- S9(e): authenticated cannot SELECT the table directly.
SELECT throws_ok(
  $$ SELECT * FROM public.push_subscriptions LIMIT 1 $$,
  '42501',
  NULL,
  'S9(e): authenticated cannot SELECT from push_subscriptions directly (42501)'
);

-- S9(f): save_push_subscription inserts a row for the caller.
SELECT lives_ok(
  $$ SELECT public.save_push_subscription(
       'https://fcm.googleapis.com/push/s9-u1-endpoint',
       'p256dh-s9-u1',
       'auth-s9-u1',
       'TestAgent/1.0'
     ) $$,
  'S9(f): save_push_subscription succeeds for authenticated user'
);

-- S9(g): delete_push_subscription removes the caller''s own endpoint.
SELECT lives_ok(
  $$ SELECT public.delete_push_subscription(
       'https://fcm.googleapis.com/push/s9-u1-endpoint'
     ) $$,
  'S9(g): delete_push_subscription removes own endpoint without error'
);

-- ---------------------------------------------------------
-- S9(h): user isolation — user B cannot delete user A's subscription.
-- Back to superuser to seed the row directly, then switch to user B.
-- ---------------------------------------------------------
RESET ROLE;

-- Insert user A's endpoint via the superuser (bypasses RLS).
INSERT INTO public.push_subscriptions (user_id, endpoint, p256dh, auth)
VALUES (
  '99000001-0000-0000-0000-000000000001',
  'https://fcm.googleapis.com/push/s9-u1-isolation',
  'p256dh-s9-iso',
  'auth-s9-iso'
);

-- Become user B.
SET LOCAL "request.jwt.claims" = '{"sub":"99000002-0000-0000-0000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- delete_push_subscription WHERE endpoint = … AND user_id = auth.uid().
-- Since auth.uid() = user B ≠ user A, the DELETE matches 0 rows (silent no-op).
SELECT public.delete_push_subscription(
  'https://fcm.googleapis.com/push/s9-u1-isolation'
);

RESET ROLE;

SELECT isnt_empty(
  $$ SELECT 1 FROM public.push_subscriptions
      WHERE endpoint = 'https://fcm.googleapis.com/push/s9-u1-isolation' $$,
  'S9(h): user isolation — user B''s delete_push_subscription call cannot remove user A''s endpoint'
);

SELECT * FROM finish();
ROLLBACK;
