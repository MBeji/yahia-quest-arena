-- =========================================================
-- Scale hardening: materialize the per-subject leaderboard
-- ---------------------------------------------------------
-- The previous get_subject_leaderboard() re-ran a full
-- SUM(xp_earned) GROUP BY user over the ENTIRE attempts
-- table on every page open. On a shared (nano) instance that
-- is the heaviest recurring query. We move that aggregation
-- off the hot path into a materialized view refreshed every
-- 5 minutes by pg_cron.
--
-- Correctness tradeoff (intentional):
--   * Other students' XP totals lag by <= 5 min (acceptable
--     for a ranking board).
--   * Profile fields (name, level, streak, tier) are joined
--     LIVE, so they are never stale.
--   * The CALLER's own total is computed LIVE (cheap, single
--     user filter) and unioned in, so "my rank" updates
--     instantly after submitting an exercise — no MV lag for
--     the person who just played.
-- =========================================================

-- ---------------------------------------------------------
-- 1. Materialized view: pure per-(subject,user) XP totals.
--    No profile join here, so the refresh stays a fast
--    GROUP BY and is decoupled from profile changes.
-- ---------------------------------------------------------
CREATE MATERIALIZED VIEW IF NOT EXISTS public.subject_leaderboard_totals AS
  SELECT
    a.subject_id,
    a.user_id,
    SUM(a.xp_earned)::BIGINT AS subject_xp
  FROM public.attempts a
  GROUP BY a.subject_id, a.user_id
WITH DATA;

-- Unique index is REQUIRED for REFRESH ... CONCURRENTLY and
-- also serves the per-subject scan below.
CREATE UNIQUE INDEX IF NOT EXISTS uq_subject_leaderboard_totals
  ON public.subject_leaderboard_totals (subject_id, user_id);

-- The MV must NOT be reachable through the PostgREST API.
-- It is only ever read by the SECURITY DEFINER function below
-- (which runs as the owner), so strip direct client access.
REVOKE ALL ON public.subject_leaderboard_totals FROM anon, authenticated;

-- ---------------------------------------------------------
-- 2. Rewrite get_subject_leaderboard to read the MV instead
--    of aggregating attempts live. Same signature + return
--    shape -> totally transparent to the app (no code change).
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_subject_leaderboard(p_subject TEXT, p_limit INT DEFAULT 50)
RETURNS TABLE (
  rank BIGINT,
  user_id UUID,
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
    r.user_id,
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

REVOKE ALL ON FUNCTION public.get_subject_leaderboard(TEXT, INT) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.get_subject_leaderboard(TEXT, INT) FROM anon;
GRANT EXECUTE ON FUNCTION public.get_subject_leaderboard(TEXT, INT) TO authenticated;

-- ---------------------------------------------------------
-- 3. Global leaderboard index. getLeaderboard() orders
--    profiles by xp DESC (filtered to students) and also
--    counts students with xp > me for "my rank". Both are
--    served by this composite index.
-- ---------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_profiles_role_xp
  ON public.profiles (role, xp DESC);

-- ---------------------------------------------------------
-- 4. Auto-refresh the MV every 5 minutes via pg_cron.
--    Wrapped so the migration still succeeds if pg_cron is
--    not yet enabled on the project: the perf-critical parts
--    (MV + function rewrite) above already landed; only the
--    auto-refresh schedule is deferred until pg_cron is on.
-- ---------------------------------------------------------
DO $$
BEGIN
  CREATE EXTENSION IF NOT EXISTS pg_cron;

  -- Idempotent: drop any prior schedule with this name first.
  PERFORM cron.unschedule(jobid)
  FROM cron.job
  WHERE jobname = 'refresh-subject-leaderboard';

  PERFORM cron.schedule(
    'refresh-subject-leaderboard',
    '*/5 * * * *',
    $cron$REFRESH MATERIALIZED VIEW CONCURRENTLY public.subject_leaderboard_totals;$cron$
  );
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE
    'pg_cron unavailable (%). The materialized leaderboard works but will NOT auto-refresh. Enable pg_cron in Supabase -> Database -> Extensions, then re-run just the cron.schedule(...) block.',
    SQLERRM;
END $$;
