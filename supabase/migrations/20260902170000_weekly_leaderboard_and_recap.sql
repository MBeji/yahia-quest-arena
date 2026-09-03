-- Étude 31 — lot 5 : LA SEMAINE (US-6, US-7, US-8, R-15, R-18).
--
-- TROIS CONSTATS, UN SEUL CYCLE À FERMER.
--
--   5. « Le classement ne repart jamais » : XP cumulé À VIE, sans reset ni saison.
--      Un compte de septembre ne rattrapera jamais un compte de juin — c'est
--      l'anti-« fresh start » exact, et il décourage précisément celui qui arrive.
--   6. « La ligue se termine dans le silence » : le gain tombe le lundi à 02:30
--      par cron, aucun écran, aucune notification (le lot 4 a posé la seconde).
--   8. Aucune carte ne dit à l'élève ce que sa semaine a produit.
--
-- CE QUE CE FICHIER POSE
--
-- * `get_weekly_leaderboard` — le classement de la SEMAINE ISO en cours, mêmes
--   cohortes que l'existant (global / ma classe / matière), même anti-fuite : le
--   `user_id` d'un tiers ne sort jamais.
-- * `get_weekly_recap` — les faits de la semaine de l'élève, comparés à la
--   précédente. Déterministe, sans aucune récompense attachée (R-18).
--
-- ⚠️ CE QUE LE CLASSEMENT HEBDO COMPTE, ET POURQUOI. Il somme `attempts.xp_earned`
-- (§3.2) : l'XP des MISSIONS. L'XP de donjon et de duel est créditée par
-- `award_xp` sans ligne de tentative, et n'y entre donc pas. Ce n'est pas un
-- oubli : l'arène a DÉJÀ son classement hebdomadaire (la ligue de é05), et
-- reconstituer ici les deux barèmes de récompense serait s'engager à les faire
-- diverger. Le tableau dit « l'XP de tes missions cette semaine », la ligue dit
-- « tes duels cette semaine ».
--
-- ⚠️ HORLOGE : `app_current_week_start()` (lundi, fuseau de Tunis) — la MÊME que
-- la ligue (R-15). Deux « lundis » sur deux écrans, ce serait deux vérités.

-- ===========================================================================
-- 1. Le classement de la semaine (US-7, R-15).
--
--    `p_scope` : 'global' (tout le parc), 'grade' (la classe de l'appelant),
--    ou un identifiant de matière. Le contrat de sortie est celui des trois
--    classements existants, pour que l'écran n'ait qu'un rendu.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.get_weekly_leaderboard(
  p_scope TEXT DEFAULT 'global',
  p_limit INT DEFAULT 50
)
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
  WITH bounds AS (
    SELECT
      public.app_current_week_start() AS week_start,
      (public.app_current_week_start()::timestamp AT TIME ZONE 'Africa/Tunis') AS from_ts,
      ((public.app_current_week_start() + 7)::timestamp AT TIME ZONE 'Africa/Tunis') AS to_ts
  ),
  caller AS (
    SELECT p.current_grade_id AS grade_id
      FROM public.profiles p
     WHERE p.id = (SELECT auth.uid()) AND p.role = 'student'
  ),
  weekly AS (
    -- L'XP des missions de la semaine, par élève. `xp > 0` (cold-start, é15 D-7) :
    -- on ne peuple pas le tableau de concurrents à zéro point, et on n'annonce
    -- jamais un rang à qui n'a rien joué cette semaine.
    SELECT a.user_id, SUM(a.xp_earned)::int AS week_xp
      FROM public.attempts a, bounds b
     WHERE a.completed_at >= b.from_ts
       AND a.completed_at <  b.to_ts
     GROUP BY a.user_id
    HAVING SUM(a.xp_earned) > 0
  ),
  scoped AS (
    SELECT w.user_id, w.week_xp
      FROM weekly w
      JOIN public.profiles p ON p.id = w.user_id AND p.role = 'student'
      LEFT JOIN caller c ON TRUE
     WHERE (
       p_scope = 'global'
       OR (p_scope = 'grade' AND c.grade_id IS NOT NULL AND p.current_grade_id = c.grade_id)
       OR (p_scope NOT IN ('global', 'grade') AND EXISTS (
             SELECT 1 FROM public.attempts a2, bounds b2
              WHERE a2.user_id = w.user_id
                AND a2.subject_id = p_scope
                AND a2.completed_at >= b2.from_ts
                AND a2.completed_at <  b2.to_ts
           ))
     )
  ),
  ranked AS (
    SELECT s.user_id, s.week_xp, rank() OVER (ORDER BY s.week_xp DESC) AS rank
      FROM scoped s
  ),
  combined AS (
    -- Le top, plus la ligne de l'appelant même hors du top : c'est elle qui porte
    -- « ton rang ». Sortie du top pour ne pas apparaître deux fois.
    SELECT r.rank, r.user_id, r.week_xp
      FROM ranked r
     WHERE r.rank <= GREATEST(p_limit, 1) AND r.user_id <> (SELECT auth.uid())
    UNION ALL
    SELECT r.rank, r.user_id, r.week_xp
      FROM ranked r
     WHERE r.user_id = (SELECT auth.uid())
  )
  SELECT
    c.rank,
    p.display_name,
    p.hero_class,
    p.level,
    -- ⚠️ La colonne `xp` porte l'XP DE LA SEMAINE, pas le cumul à vie : c'est le
    -- sens du tableau, et l'écran affiche la même colonne dans les deux onglets.
    c.week_xp AS xp,
    p.current_streak,
    p.avatar_tier,
    (c.user_id = (SELECT auth.uid())) AS is_me
  FROM combined c
  JOIN public.profiles p ON p.id = c.user_id AND p.role = 'student'
  ORDER BY c.rank, p.display_name;
$$;

COMMENT ON FUNCTION public.get_weekly_leaderboard(TEXT, INT) IS
  'é31 R-15 : le classement de la semaine ISO en cours (fuseau Tunis, même horloge que la ligue). Somme `attempts.xp_earned` — l''XP des missions ; les duels ont leur propre ligue.';

REVOKE EXECUTE ON FUNCTION public.get_weekly_leaderboard(TEXT, INT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_weekly_leaderboard(TEXT, INT) TO authenticated;

-- ===========================================================================
-- 2. « Ta semaine » (US-8, R-18) — les faits, et rien d'autre.
--
--    DÉTERMINISTE, et sans aucune récompense attachée : un bilan qui rapporte
--    des XP devient une tâche, et le lire cesse d'être un choix (cohérent
--    é11 R-11). Aucune clé d'IA n'est requise — quand le pilote é29 aura tourné,
--    la prose d'El Ostedh pourra ENRICHIR cette carte, jamais la conditionner
--    (D-7).
--
--    ⚠️ ÉCART ASSUMÉ AU §3.2 : l'étude proposait d'agréger
--    `get_tutor_digest_inputs`. Cette fonction-là est `service_role` et
--    volontairement DÉPERSONNALISÉE (son JSON part chez un fournisseur de
--    modèle) : l'appeler depuis une surface élève supposerait le client admin
--    sur un écran de jeu. Pour les faits de SA propre semaine, une fonction
--    self-scopée est plus simple et strictement moins ouverte.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.get_weekly_recap()
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user  UUID := auth.uid();
  v_week  DATE := public.app_current_week_start();
  v_this  RECORD;
  v_prev  RECORD;
  v_badges JSONB;
  v_league JSONB;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT
    COALESCE(SUM(a.xp_earned), 0)::int                       AS xp,
    COUNT(*)::int                                            AS missions,
    ROUND(COALESCE(AVG(a.score_pct), 0))::int                AS avg_score,
    COUNT(DISTINCT (a.completed_at AT TIME ZONE 'Africa/Tunis')::date)::int AS days_active
    INTO v_this
    FROM public.attempts a
   WHERE a.user_id = v_user
     AND a.completed_at >= (v_week::timestamp AT TIME ZONE 'Africa/Tunis')
     AND a.completed_at <  ((v_week + 7)::timestamp AT TIME ZONE 'Africa/Tunis');

  SELECT
    COALESCE(SUM(a.xp_earned), 0)::int                       AS xp,
    COUNT(*)::int                                            AS missions,
    ROUND(COALESCE(AVG(a.score_pct), 0))::int                AS avg_score,
    COUNT(DISTINCT (a.completed_at AT TIME ZONE 'Africa/Tunis')::date)::int AS days_active
    INTO v_prev
    FROM public.attempts a
   WHERE a.user_id = v_user
     AND a.completed_at >= ((v_week - 7)::timestamp AT TIME ZONE 'Africa/Tunis')
     AND a.completed_at <  (v_week::timestamp AT TIME ZONE 'Africa/Tunis');

  SELECT COALESCE(jsonb_agg(b.code ORDER BY sb.awarded_at), '[]'::jsonb)
    INTO v_badges
    FROM public.student_badges sb
    JOIN public.badges b ON b.id = sb.badge_id
   WHERE sb.student_user_id = v_user
     AND sb.awarded_at >= (v_week::timestamp AT TIME ZONE 'Africa/Tunis');

  -- Le rang de ligue de la semaine CLOSE : c'est le seul qui soit définitif, et
  -- c'est celui que le podium célèbre.
  SELECT to_jsonb(x) INTO v_league
    FROM (
      SELECT a.tier, a.rank, a.coins_awarded AS coins, a.week_start
        FROM public.duel_league_awards a
       WHERE a.user_id = v_user AND a.week_start = v_week - 7
    ) x;

  RETURN jsonb_build_object(
    'weekStart', to_char(v_week::timestamp, 'YYYY-MM-DD'),
    -- Une semaine sans une seule mission n'a pas de bilan à montrer : l'écran a
    -- un état pour ça, et il ne dit pas « tu n'as rien fait » (R-8).
    'hasActivity', (v_this.missions > 0),
    'thisWeek', jsonb_build_object(
      'xp', v_this.xp, 'missions', v_this.missions,
      'avgScore', v_this.avg_score, 'daysActive', v_this.days_active
    ),
    'lastWeek', jsonb_build_object(
      'xp', v_prev.xp, 'missions', v_prev.missions,
      'avgScore', v_prev.avg_score, 'daysActive', v_prev.days_active
    ),
    'delta', jsonb_build_object(
      'xp', v_this.xp - v_prev.xp,
      'missions', v_this.missions - v_prev.missions,
      -- ⚠️ Un écart de moyenne n'a de sens que si les DEUX semaines ont eu des
      -- missions : sinon une reprise après vacances afficherait « +67 points de
      -- progression », un compliment mécanique et faux. NULL = pas comparable.
      'avgScore', CASE WHEN v_this.missions > 0 AND v_prev.missions > 0
                        THEN v_this.avg_score - v_prev.avg_score END,
      'daysActive', v_this.days_active - v_prev.days_active
    ),
    'streak', (SELECT current_streak FROM public.profiles WHERE id = v_user),
    'badges', v_badges,
    'league', v_league
  );
END;
$$;

COMMENT ON FUNCTION public.get_weekly_recap() IS
  'é31 R-18 : les faits de la semaine de l''élève, comparés à la précédente. Déterministe, self-scopé, AUCUNE récompense attachée.';

REVOKE EXECUTE ON FUNCTION public.get_weekly_recap() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_weekly_recap() TO authenticated;
