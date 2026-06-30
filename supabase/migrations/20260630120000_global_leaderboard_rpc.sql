-- =========================================================
-- Global leaderboard RPC (RLS-safe)
-- ---------------------------------------------------------
-- BUG: the global leaderboard read `public.profiles` DIRECTLY
-- from `getLeaderboard`. Since migration 20260522153000 the
-- profiles SELECT policy is "Users can view own or linked
-- profiles" (auth.uid() = id OR a parent/student link), so a
-- student's leaderboard query returned ONLY their own row —
-- "I can see my score but not the others".
--
-- The per-subject board never had this problem because it goes
-- through the SECURITY DEFINER `get_subject_leaderboard`, which
-- aggregates across users despite per-row RLS. This function is
-- the global counterpart: same public-safe projection, ranked by
-- total XP, with the caller flagged via `is_me`.
--
-- SECURITY: like the subject board, it deliberately returns NO
-- peer `user_id` — only the public-safe fields a leaderboard
-- shows (name, hero class, level, XP, streak, avatar tier) plus
-- the `is_me` flag computed against auth.uid(). No UUID leaves
-- the server.
-- =========================================================

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
  WITH ranked AS (
    SELECT
      RANK() OVER (ORDER BY p.xp DESC) AS rank,
      p.id,
      p.display_name,
      p.hero_class,
      p.level,
      p.xp,
      p.current_streak,
      p.avatar_tier
    FROM public.profiles p
    WHERE p.role = 'student'
  )
  SELECT
    r.rank,
    r.display_name,
    r.hero_class,
    r.level,
    r.xp,
    r.current_streak,
    r.avatar_tier,
    (r.id = auth.uid()) AS is_me
  -- Top `p_limit` players, plus the caller's own row even when it
  -- falls outside the visible window (so "my rank" is always known).
  FROM ranked r
  WHERE r.rank <= GREATEST(p_limit, 1) OR r.id = auth.uid()
  ORDER BY r.rank;
$$;

REVOKE ALL ON FUNCTION public.get_global_leaderboard(INT) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.get_global_leaderboard(INT) FROM anon;
GRANT EXECUTE ON FUNCTION public.get_global_leaderboard(INT) TO authenticated;
