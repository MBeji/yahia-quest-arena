-- Per-subject stats as a GROUP BY RPC instead of shipping a user's whole history.
--
-- Scalability audit M4: getDashboard fetched EVERY attempt of the user
-- (subject_id, score_pct, xp_earned) and reduced them in JS on every dashboard
-- load — an unbounded transfer + reduction that grows for a user's lifetime.
-- This RPC returns the bounded per-subject aggregate (one row per subject) and
-- is served by idx_attempts_user (user_id). Self-scoped to the caller via
-- (SELECT auth.uid()) — wrapped per the C1 pattern.

CREATE OR REPLACE FUNCTION public.get_user_subject_stats()
RETURNS TABLE (
  subject_id TEXT,
  attempts_count INT,
  avg_score NUMERIC,
  total_xp BIGINT
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT
    a.subject_id,
    count(*)::int,
    avg(a.score_pct)::numeric,
    coalesce(sum(a.xp_earned), 0)::bigint
  FROM public.attempts a
  WHERE a.user_id = (SELECT auth.uid())
  GROUP BY a.subject_id;
$$;

REVOKE ALL ON FUNCTION public.get_user_subject_stats() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_user_subject_stats() TO authenticated;
