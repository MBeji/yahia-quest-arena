-- =========================================================
-- Revoke direct client writes on exercise_sessions (GAP-021 Part 2 — closeout).
-- ---------------------------------------------------------
-- Companion to 20260610180000 (start_exercise_session RPC). Once the app starts
-- sessions exclusively through that SECURITY DEFINER RPC, the direct INSERT/UPDATE/
-- DELETE grants on exercise_sessions are pure attack surface: a direct INSERT let an
-- authenticated user forge a session for ANY exercise via PostgREST and bypass both
-- the premium gate and the comprehension-quiz gate. Revoke them.
--
-- What still works, by design:
--   * SELECT stays granted (RLS-scoped to the owner) — the client/RPCs read sessions.
--   * submit_exercise_attempt still UPDATEs completed_at, but it is SECURITY DEFINER
--     (runs as the function owner), so it is unaffected by these client-role revokes.
--   * service_role (e2e seeding) bypasses RLS and keeps its grants — unaffected.
-- The two now-unreachable owner-write RLS policies are dropped so the schema does not
-- advertise a client INSERT/UPDATE path that no longer has the underlying grant.
--
-- DEPLOY ORDER (CLAUDE.md §7): apply this AFTER the startExerciseSession code that
-- calls start_exercise_session is deployed — otherwise the still-live old code's
-- direct INSERT breaks. Sequence: 180000 -> deploy code -> 190000 (this).
-- =========================================================

REVOKE INSERT, UPDATE, DELETE ON public.exercise_sessions FROM authenticated, anon;

DROP POLICY IF EXISTS "Users insert own exercise sessions" ON public.exercise_sessions;
DROP POLICY IF EXISTS "Users update own exercise sessions" ON public.exercise_sessions;
