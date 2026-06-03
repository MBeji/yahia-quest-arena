-- =========================================================
-- Per-subject leaderboard
-- ---------------------------------------------------------
-- Ranks students by total XP earned in a given subject
-- (sum of attempts.xp_earned). SECURITY DEFINER so it can
-- aggregate across users despite per-row RLS on `attempts`;
-- it only returns the same public-safe fields as the global
-- leaderboard, plus the subject XP and the caller's own row.
-- =========================================================

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
    SELECT a.user_id, SUM(a.xp_earned)::BIGINT AS subject_xp
    FROM public.attempts a
    WHERE a.subject_id = p_subject
    GROUP BY a.user_id
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

-- Speeds up the per-subject aggregation.
CREATE INDEX IF NOT EXISTS idx_attempts_subject_user ON public.attempts(subject_id, user_id);
