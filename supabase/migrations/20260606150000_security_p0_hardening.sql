-- =========================================================
-- P0 SECURITY HARDENING — 2026-06-06
-- ---------------------------------------------------------
-- MUST BE APPLIED TO THE DB *BEFORE* THE CODE THAT DEPENDS ON IT IS
-- DEPLOYED (see CLAUDE.md §7). Pushing code to main auto-deploys to prod;
-- this migration creates the `set_profile_role` RPC that `bootstrapProfile`
-- now calls, so the DB must have it first or signup/onboarding breaks.
--
-- This migration is idempotent and safe to re-run.
--
-- Closes two P0 holes found in the security review:
--
--   S1 — `award_xp` / `award_coins` are browser-callable.
--        Both are GRANTed to `authenticated`, so any logged-in student can
--        `supabase.rpc('award_xp', { p_user: <self>, p_xp: 9999999 })` and mint
--        unlimited XP/coins, bypassing every anti-cheat check baked into
--        `submit_exercise_attempt` / dungeon finalize. These two functions are
--        ONLY ever invoked INTERNALLY via `PERFORM public.award_xp(...)` from
--        other SECURITY DEFINER RPCs, which run as the table OWNER and therefore
--        do NOT need (and must not have) the `authenticated` EXECUTE grant.
--        No application code calls them directly (verified by grep over src/).
--        `spend_coins` is intentionally LEFT GRANTed: it is called by the
--        `recoverStreak` server fn with the user's own client and only ever
--        DECREASES the caller's own balance (self-only check + `yahia_coins >=
--        p_coins` guard), so it cannot be abused to gain currency.
--
--   S2(a) — role self-escalation. The old `prevent_role_escalation()` trigger
--        only blocked role='admin', and the column-level UPDATE grant on
--        `profiles` includes `role`, so a student could
--        `PATCH /profiles { role: 'parent' }` via PostgREST and then read other
--        minors' data through the parent surfaces. We now reject ANY role
--        change that arrives through a normal JWT-authenticated PostgREST
--        request, while still permitting the two legitimate paths:
--          (1) service_role / dashboard SQL (admin provisioning), and
--          (2) the new `set_profile_role` SECURITY DEFINER RPC, which is the
--              single sanctioned way a normal user sets their own student/parent
--              role at onboarding (it self-scopes and only allows student|parent).
--        The role column is also REVOKEd from the client write grants so direct
--        PostgREST writes can never touch it even before the trigger fires.
--
--   S2(b) — peer-UUID leak. `get_subject_leaderboard` returned every peer's raw
--        `user_id`. We drop `user_id` from the leaderboard projection entirely;
--        ranking/highlighting now rely on `rank` + the existing `is_me` flag.
-- =========================================================


-- =========================================================
-- S1 — Revoke direct (browser) access to the economy mint RPCs.
-- =========================================================
-- Idempotent: REVOKE on an already-revoked grant is a no-op. Both functions
-- have the single overload signature (uuid, int).
REVOKE EXECUTE ON FUNCTION public.award_xp(uuid, int)
  FROM authenticated, anon, public;
REVOKE EXECUTE ON FUNCTION public.award_coins(uuid, int)
  FROM authenticated, anon, public;

-- NOTE: `spend_coins(uuid, int)` keeps its `authenticated` grant on purpose —
-- it is the backing RPC for streak recovery and can only reduce the caller's
-- own balance. Do NOT revoke it or streak recovery breaks.


-- =========================================================
-- S2(a) — Block role self-escalation; preserve legitimate role assignment.
-- =========================================================

-- 1. Remove `role` from the client-writable column grants. After this, a direct
--    PostgREST INSERT/UPDATE from the `authenticated` role physically cannot
--    write the `role` column at all (defence in depth, independent of the
--    trigger below). We re-state the column grant lists from
--    20260602120000_security_hardening_rls.sql MINUS `role`, and additionally
--    grant `current_grade_id` (written by the `setCurrentGrade` server fn): that
--    column was added in 20260605120000 AFTER the column-scoped grants landed,
--    so it currently has NO `authenticated` UPDATE grant — restating the grant
--    here both removes `role` and (re)opens `current_grade_id` for onboarding.
REVOKE INSERT, UPDATE ON public.profiles FROM authenticated;

GRANT INSERT (id, display_name) ON public.profiles TO authenticated;
GRANT UPDATE (display_name, avatar_slug, current_streak, last_active_date, current_grade_id)
  ON public.profiles TO authenticated;

-- 2. The sanctioned role-assignment path for ordinary users: a SECURITY DEFINER
--    RPC that sets the CALLER'S OWN role to 'student' or 'parent' (onboarding).
--    It signals the trigger via a transaction-local GUC that only a definer
--    function can set; a direct PostgREST request can never set it.
CREATE OR REPLACE FUNCTION public.set_profile_role(p_role TEXT)
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  rec public.profiles;
  v_uid UUID := auth.uid();
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  -- Ordinary users may only ever choose between the two onboarding roles.
  -- 'admin' is never assignable here (admin is provisioned out-of-band via
  -- service_role / dashboard SQL).
  IF p_role IS DISTINCT FROM 'student' AND p_role IS DISTINCT FROM 'parent' THEN
    RAISE EXCEPTION 'Invalid role';
  END IF;

  -- Authorise the role write for the duration of THIS transaction only. The
  -- trigger below checks this flag; PostgREST cannot set it, so this is the
  -- only door through which a JWT-authenticated user's role change passes.
  PERFORM set_config('app.allow_role_change', 'on', true);

  -- Self-scoped: a user can only set their own role. `handle_new_user` already
  -- created the base row at signup, so this is an UPDATE in practice; we INSERT
  -- defensively in case the bootstrap RPC runs before the trigger row exists.
  INSERT INTO public.profiles (id, role)
  VALUES (v_uid, p_role)
  ON CONFLICT (id) DO UPDATE SET role = EXCLUDED.role
  RETURNING * INTO rec;

  RETURN rec;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.set_profile_role(text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_profile_role(text) TO authenticated;

-- 3. Tighten the trigger: reject ANY *privileged* role write coming from a
--    normal JWT-authenticated request. A "privileged" write is:
--      * an UPDATE that changes `role` (NEW.role <> OLD.role), or
--      * an INSERT that sets `role` to anything OTHER than the default 'student'.
--    A plain INSERT that lands the default 'student' role is benign — that is
--    exactly what `handle_new_user` and the `getDashboard` fallback profile
--    insert do (they never name `role`, so it takes the column default), and the
--    `role` column is no longer in the client INSERT grant anyway, so a direct
--    PostgREST insert physically cannot smuggle a non-default role in. We must
--    NOT block those benign inserts or signup/first-dashboard-load breaks.
--
--    Three escape hatches are preserved for legitimate role provisioning:
--      * the `set_profile_role` definer RPC (sets the per-tx `app.allow_role_change`
--        flag before writing) — the sanctioned student/parent onboarding path,
--      * service_role JWTs (request.jwt.claims.role = 'service_role') — admin
--        provisioning via the API, and
--      * direct SQL with no PostgREST JWT context at all (dashboard / psql ->
--        v_claims IS NULL).
--    Other SECURITY DEFINER functions (award_xp, submit_exercise_attempt, ...)
--    never write `role`, so for their UPDATEs NEW.role IS NOT DISTINCT FROM
--    OLD.role and they sail through untouched.
CREATE OR REPLACE FUNCTION public.prevent_role_escalation()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public
AS $$
DECLARE
  v_claims text := current_setting('request.jwt.claims', true);
  v_jwt_role text := COALESCE((NULLIF(v_claims, '')::json ->> 'role'), '');
  v_allowed text := current_setting('app.allow_role_change', true);
  -- Default role for a fresh row (matches profiles.role DEFAULT 'student').
  v_privileged boolean := CASE
    WHEN TG_OP = 'INSERT' THEN NEW.role IS DISTINCT FROM 'student'
    ELSE NEW.role IS DISTINCT FROM OLD.role
  END;
BEGIN
  IF v_privileged THEN
    -- Sanctioned definer path: set_profile_role flipped the per-tx flag.
    IF v_allowed = 'on' THEN
      RETURN NEW;
    END IF;

    -- service_role tokens may set any role (admin provisioning via API).
    IF v_jwt_role = 'service_role' THEN
      RETURN NEW;
    END IF;

    -- Direct SQL (dashboard / psql) has no PostgREST JWT claims at all.
    IF v_claims IS NULL THEN
      RETURN NEW;
    END IF;

    -- Anything else is a normal JWT-authenticated PostgREST request trying to
    -- set a privileged `role` directly — block it (covers BOTH escalation to
    -- 'admin' and the previously-allowed escalation to 'parent').
    RAISE EXCEPTION 'Not allowed to change role via this path';
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_prevent_role_escalation ON public.profiles;
CREATE TRIGGER trg_prevent_role_escalation
  BEFORE INSERT OR UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.prevent_role_escalation();


-- =========================================================
-- S2(b) — Stop leaking other users' UUIDs from the leaderboard.
-- =========================================================
-- Re-create `get_subject_leaderboard` with `user_id` REMOVED from the return
-- shape. The client keys/highlights rows by `rank` + `is_me` instead. The
-- ranking, "my rank", the live self-total UNION and the student-only filter are
-- all preserved verbatim from 20260604120000_subject_leaderboard_materialized.sql.
--
-- We must DROP first because removing a column changes the function's RETURNS
-- TABLE signature (CREATE OR REPLACE cannot change the output column set).
DROP FUNCTION IF EXISTS public.get_subject_leaderboard(TEXT, INT);

CREATE FUNCTION public.get_subject_leaderboard(p_subject TEXT, p_limit INT DEFAULT 50)
RETURNS TABLE (
  rank BIGINT,
  display_name TEXT,
  hero_class TEXT,
  level INT,
  current_streak INT,
  avatar_tier INT,
  subject_xp BIGINT,
  is_me BOOLEAN
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  WITH totals AS (
    -- Everyone else: from the (<=5 min stale) materialized view.
    SELECT t.user_id, t.subject_xp
    FROM public.subject_leaderboard_totals t
    WHERE t.subject_id = p_subject
      AND t.user_id <> auth.uid()
    UNION ALL
    -- The caller: always fresh & always present (cheap single-user
    -- aggregate, served by idx_attempts_subject_user).
    SELECT auth.uid(), COALESCE(SUM(a.xp_earned), 0)::BIGINT
    FROM public.attempts a
    WHERE a.subject_id = p_subject
      AND a.user_id = auth.uid()
    HAVING COUNT(*) > 0
  ),
  ranked AS (
    SELECT
      RANK() OVER (ORDER BY t.subject_xp DESC) AS rank,
      t.user_id,
      p.display_name,
      p.hero_class,
      p.level,
      p.current_streak,
      p.avatar_tier,
      t.subject_xp
    FROM totals t
    JOIN public.profiles p ON p.id = t.user_id
    WHERE p.role = 'student'
  )
  SELECT
    r.rank,
    r.display_name,
    r.hero_class,
    r.level,
    r.current_streak,
    r.avatar_tier,
    r.subject_xp,
    (r.user_id = auth.uid()) AS is_me
  FROM ranked r
  WHERE r.rank <= GREATEST(p_limit, 1) OR r.user_id = auth.uid()
  ORDER BY r.rank;
$$;

-- DROP wiped the grants; restore the same access policy as before.
REVOKE ALL ON FUNCTION public.get_subject_leaderboard(TEXT, INT) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.get_subject_leaderboard(TEXT, INT) FROM anon;
GRANT EXECUTE ON FUNCTION public.get_subject_leaderboard(TEXT, INT) TO authenticated;
