-- =========================================================
-- Scale hardening: materialize the GLOBAL leaderboard (perf audit H1).
-- ---------------------------------------------------------
-- get_global_leaderboard() computed RANK() OVER (ORDER BY xp DESC) across EVERY
-- student profile on every dashboard/leaderboard open. A window RANK cannot push
-- the LIMIT into it, so it scans + ranks the whole student set each call — the
-- #1 read hotspot at user scale. Mirror the per-subject board: precompute the
-- ranking in a materialized view refreshed every 5 minutes by pg_cron.
--
-- Correctness tradeoff (intentional — "periodic" leaderboard):
--   * Other students' RANK positions lag by <= 5 min.
--   * Every displayed field (xp, name, level, streak, tier) is joined LIVE from
--     profiles, so shown values are never stale — only the ordering lags.
--   * The CALLER's own rank is computed LIVE (a cheap indexed count), so "my
--     rank" updates instantly after playing and a brand-new player (not yet in
--     the MV) still gets a row.
-- =========================================================

-- ---------------------------------------------------------
-- 1. Materialized view: precomputed (rank, user_id) by xp DESC. No profile
--    fields here, so the refresh is a lean rank-only pass decoupled from
--    profile edits.
-- ---------------------------------------------------------
CREATE MATERIALIZED VIEW IF NOT EXISTS public.global_leaderboard_ranked AS
  SELECT
    RANK() OVER (ORDER BY p.xp DESC) AS rank,
    p.id AS user_id
  FROM public.profiles p
  WHERE p.role = 'student'
WITH DATA;

-- Unique index is REQUIRED for REFRESH ... CONCURRENTLY; the rank index serves
-- the top-N scan in the function.
CREATE UNIQUE INDEX IF NOT EXISTS uq_global_leaderboard_ranked_user
  ON public.global_leaderboard_ranked (user_id);
CREATE INDEX IF NOT EXISTS idx_global_leaderboard_ranked_rank
  ON public.global_leaderboard_ranked (rank);

-- Never reachable through PostgREST: only the SECURITY DEFINER function reads it.
REVOKE ALL ON public.global_leaderboard_ranked FROM anon, authenticated;

-- ---------------------------------------------------------
-- 2. Rewrite get_global_leaderboard to read the MV (others) + the caller's LIVE
--    rank. Same signature + return shape -> transparent to the app (no code
--    change): no user_id column, keeps is_me (see 02_role_escalation S2(b)).
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_global_leaderboard(p_limit INT DEFAULT 50)
RETURNS TABLE (
  rank BIGINT,
  display_name TEXT,
  hero_class TEXT,
  level INT,
  xp INT,
  current_streak INT,
  avatar_tier INT,
  is_me BOOLEAN
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  WITH me AS (
    -- The caller's LIVE rank + row: instant after playing, and present even for a
    -- brand-new student not yet in the 5-min MV. Served by idx_profiles_role_xp.
    SELECT
      p.id AS user_id,
      (1 + (SELECT count(*) FROM public.profiles o
              WHERE o.role = 'student' AND o.xp > p.xp))::BIGINT AS rank
    FROM public.profiles p
    WHERE p.id = (SELECT auth.uid()) AND p.role = 'student'
  ),
  board AS (
    -- Everyone else: top-N by the (<= 5 min stale) precomputed rank.
    SELECT r.rank, r.user_id
    FROM public.global_leaderboard_ranked r
    WHERE r.rank <= GREATEST(p_limit, 1)
      AND r.user_id <> (SELECT auth.uid())
  ),
  combined AS (
    SELECT rank, user_id FROM board
    UNION ALL
    SELECT rank, user_id FROM me
  )
  SELECT
    c.rank,
    p.display_name,
    p.hero_class,
    p.level,
    p.xp,
    p.current_streak,
    p.avatar_tier,
    (c.user_id = (SELECT auth.uid())) AS is_me
  FROM combined c
  JOIN public.profiles p ON p.id = c.user_id AND p.role = 'student'
  ORDER BY c.rank;
$$;

REVOKE ALL ON FUNCTION public.get_global_leaderboard(INT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_global_leaderboard(INT) TO authenticated;

-- ---------------------------------------------------------
-- 3. Auto-refresh every 5 minutes via pg_cron. Wrapped so the migration still
--    succeeds if pg_cron is not enabled yet: the MV + function rewrite above
--    already landed; only the schedule is deferred until pg_cron is on.
-- ---------------------------------------------------------
DO $$
BEGIN
  CREATE EXTENSION IF NOT EXISTS pg_cron;

  PERFORM cron.unschedule(jobid)
  FROM cron.job
  WHERE jobname = 'refresh-global-leaderboard';

  PERFORM cron.schedule(
    'refresh-global-leaderboard',
    '*/5 * * * *',
    $cron$REFRESH MATERIALIZED VIEW CONCURRENTLY public.global_leaderboard_ranked;$cron$
  );
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE
    'pg_cron unavailable (%). The materialized global leaderboard works but will NOT auto-refresh. Enable pg_cron in Supabase -> Database -> Extensions, then re-run just the cron.schedule(...) block.',
    SQLERRM;
END $$;
