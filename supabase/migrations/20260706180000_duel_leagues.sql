-- Duels temps réel & ligues — lot 5 : ligues hebdomadaires (FableEtudes/05-duels-ligues #lot-5).
--
-- Q-3 tranché (délégation humaine « fais les choix selon tes connaissances ») :
--   * Saison = SEMAINE ISO, calendrier Tunis (réutilise app_current_week_start()).
--   * Score hebdo = points type championnat sur les duels `finished` de la semaine :
--     victoire unique 3, nul (ex æquo en tête) 1, défaite 0 ; départage wins puis played.
--   * 5 tranches par centile du classement hebdo : diamond (≤10%), platinum (≤25%),
--     gold (≤50%), silver (≤75%), bronze (reste).
--   * Récompenses de fin de semaine = COINS (monnaie existante) au rollover hebdo,
--     idempotentes via le registre duel_league_awards :
--       diamond 100 · platinum 60 · gold 30 · silver 15 · bronze 5.
--
-- D-6 : la ligue est une AGRÉGATION hebdomadaire au-dessus des duels — aucun nouveau
-- canal, aucune écriture de jeu. Les récompenses réutilisent award_duel_rewards (D-5).
-- La notification push de fin de semaine est un suivi (l'infra push existe mais son
-- branchement cron est hors périmètre du cœur du lot) ; la récompense reste visible via
-- le registre (RLS owner) dans le hub.

-- ---------------------------------------------------------------------------
-- 1. Le registre des récompenses de ligue (idempotence + affichage « semaine passée »).
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.duel_league_awards (
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  week_start    DATE NOT NULL,
  tier          TEXT NOT NULL,
  rank          INT NOT NULL,
  points        INT NOT NULL,
  coins_awarded INT NOT NULL,
  awarded_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, week_start)
);

CREATE INDEX IF NOT EXISTS idx_duel_league_awards_user
  ON public.duel_league_awards (user_id, week_start DESC);

ALTER TABLE public.duel_league_awards ENABLE ROW LEVEL SECURITY;

-- The student reads their OWN awards (surfaced in the hub); admin reads all. No
-- write policy — awards are inserted only by the SECURITY DEFINER function below.
CREATE POLICY "League awards readable by owner" ON public.duel_league_awards
  FOR SELECT USING (user_id = (SELECT auth.uid()) OR public.is_admin());

REVOKE ALL ON public.duel_league_awards FROM anon, authenticated;
GRANT SELECT ON public.duel_league_awards TO authenticated;
GRANT ALL ON public.duel_league_awards TO service_role;

-- ---------------------------------------------------------------------------
-- 2. Tier from the weekly rank (percentile-based; rank 1 = top).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.duel_league_tier(p_rank INT, p_total INT)
RETURNS TEXT
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT CASE
    WHEN p_total IS NULL OR p_total <= 0 THEN 'bronze'
    WHEN p_rank::numeric / p_total <= 0.10 THEN 'diamond'
    WHEN p_rank::numeric / p_total <= 0.25 THEN 'platinum'
    WHEN p_rank::numeric / p_total <= 0.50 THEN 'gold'
    WHEN p_rank::numeric / p_total <= 0.75 THEN 'silver'
    ELSE 'bronze'
  END;
$$;

-- Coins granted at week end per tier.
CREATE OR REPLACE FUNCTION public.duel_league_tier_coins(p_tier TEXT)
RETURNS INT
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT CASE p_tier
    WHEN 'diamond' THEN 100
    WHEN 'platinum' THEN 60
    WHEN 'gold' THEN 30
    WHEN 'silver' THEN 15
    ELSE 5
  END;
$$;

-- ---------------------------------------------------------------------------
-- 3. Weekly standings for a given week (Tunis-local [p_week, p_week+7)).
--    A set-returning helper reused by both the read RPC and the reward job, so
--    the ranking logic lives in ONE place.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.duel_league_standings(p_week DATE)
RETURNS TABLE (user_id UUID, points INT, wins INT, played INT, rank INT, total INT)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  WITH finished AS (
    SELECT dp.user_id, dp.duel_id, dp.score
    FROM public.duel_participants dp
    JOIN public.duels d ON d.id = dp.duel_id
    WHERE d.status = 'finished'
      AND dp.finished_at IS NOT NULL
      AND (d.created_at AT TIME ZONE 'Africa/Tunis')::date >= p_week
      AND (d.created_at AT TIME ZONE 'Africa/Tunis')::date < p_week + 7
  ),
  scored AS (
    SELECT
      user_id,
      -- top score of the duel + how many players share the caller's score
      max(score) OVER (PARTITION BY duel_id) AS top,
      count(*) OVER (PARTITION BY duel_id, score) AS same_score,
      score
    FROM finished
  ),
  pointed AS (
    SELECT
      user_id,
      CASE WHEN score = top AND same_score = 1 THEN 3   -- unique winner
           WHEN score = top THEN 1                       -- tie at the top → draw
           ELSE 0 END AS pts,
      CASE WHEN score = top AND same_score = 1 THEN 1 ELSE 0 END AS win
    FROM scored
  ),
  agg AS (
    SELECT user_id, sum(pts)::int AS points, sum(win)::int AS wins, count(*)::int AS played
    FROM pointed
    GROUP BY user_id
  )
  SELECT
    a.user_id,
    a.points,
    a.wins,
    a.played,
    RANK() OVER (ORDER BY a.points DESC, a.wins DESC, a.played DESC)::int AS rank,
    (SELECT count(*)::int FROM agg) AS total
  FROM agg a;
$$;

REVOKE EXECUTE ON FUNCTION public.duel_league_standings(DATE) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 4. get_duel_league — the current week's standings for the client (top-N + the
--    caller's own row), public-safe fields + is_me (patron get_global_leaderboard).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_duel_league(p_limit INT DEFAULT 20)
RETURNS TABLE (
  rank INT,
  display_name TEXT,
  hero_class TEXT,
  avatar_tier INT,
  points INT,
  wins INT,
  played INT,
  tier TEXT,
  is_me BOOLEAN
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  WITH s AS (
    SELECT * FROM public.duel_league_standings(public.app_current_week_start())
  ),
  picked AS (
    -- top-N, plus the caller's own row even if outside the top-N
    SELECT * FROM s WHERE rank <= GREATEST(p_limit, 1)
    UNION
    SELECT * FROM s WHERE user_id = (SELECT auth.uid())
  )
  SELECT
    picked.rank,
    p.display_name,
    p.hero_class,
    p.avatar_tier,
    picked.points,
    picked.wins,
    picked.played,
    public.duel_league_tier(picked.rank, picked.total) AS tier,
    (picked.user_id = (SELECT auth.uid())) AS is_me
  FROM picked
  JOIN public.profiles p ON p.id = picked.user_id
  ORDER BY picked.rank, p.display_name;
$$;

REVOKE EXECUTE ON FUNCTION public.get_duel_league(INT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_duel_league(INT) TO authenticated;

-- ---------------------------------------------------------------------------
-- 5. award_duel_league_week — grant end-of-week coins (idempotent via the PK).
--    Defaults to the PRIOR week (the one that just ended at the Monday rollover).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.award_duel_league_week(p_week DATE DEFAULT NULL)
RETURNS INT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_week DATE := COALESCE(p_week, public.app_current_week_start() - 7);
  r RECORD;
  v_tier TEXT;
  v_coins INT;
  v_count INT := 0;
BEGIN
  FOR r IN
    SELECT * FROM public.duel_league_standings(v_week)
  LOOP
    v_tier := public.duel_league_tier(r.rank, r.total);
    v_coins := public.duel_league_tier_coins(v_tier);

    -- Idempotent: a second run for the same week is a no-op (PK conflict).
    INSERT INTO public.duel_league_awards
      (user_id, week_start, tier, rank, points, coins_awarded)
    VALUES (r.user_id, v_week, v_tier, r.rank, r.points, v_coins)
    ON CONFLICT (user_id, week_start) DO NOTHING;

    IF FOUND THEN
      PERFORM public.award_duel_rewards(r.user_id, 0, v_coins);
      v_count := v_count + 1;
    END IF;
  END LOOP;
  RETURN v_count;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.award_duel_league_week(DATE) FROM PUBLIC, anon, authenticated;

-- Weekly rollover: Monday 02:30 UTC (~03:30 Tunis) awards the just-ended week.
-- Wrapped defensively so the migration succeeds without pg_cron (functions above
-- already landed; only the schedule defers).
DO $$
BEGIN
  CREATE EXTENSION IF NOT EXISTS pg_cron;
  PERFORM cron.unschedule(jobid) FROM cron.job WHERE jobname = 'award-duel-league-week';
  PERFORM cron.schedule(
    'award-duel-league-week',
    '30 2 * * 1',
    $cron$SELECT public.award_duel_league_week();$cron$
  );
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE
    'pg_cron unavailable (%). Duel leagues work but end-of-week coins will NOT auto-grant. Enable pg_cron then re-run just the cron.schedule(...) block.',
    SQLERRM;
END $$;
