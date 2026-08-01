-- Étude 09 — lot 1 : instrumenter l'économie du jeu (vues `econ_*` + RPC admin).
--
-- L'économie est déjà centralisée et son design n'est pas le problème : ce qui
-- manque, c'est la BOUCLE DE MESURE. Personne ne sait si un élève moyen atteint le
-- niveau 5 en trois jours ou en trois mois, si les coins s'accumulent sans puits
-- (inflation → boutique sans valeur), ni si les consommables sont réellement armés
-- puis consommés. Ce lot répond aux questions US-1…US-4 sans requête manuelle.
--
-- D-1 — DES VUES, PAS UNE TABLE. Les agrégats se calculent à la demande sur
-- `attempts`, `profiles`, `inventory_items` × `shop_items`, `parcours_entitlements`.
-- La volumétrie actuelle le permet largement ; une table d'événements économiques
-- serait de la sur-ingénierie v1 (le snapshot journalier est le lot 3, conditionnel).
--
-- D-2 — VUES PRIVÉES + UN SEUL RPC. Les vues sont REVOKE de anon/authenticated, et
-- l'exposition passe par `admin_economy_overview()` (SECURITY DEFINER, garde
-- `is_admin()`, même posture que `admin_list_parcours_entitlements`). Donner un
-- GRANT SELECT aux vues en filtrant côté client fuiterait des agrégats globaux à
-- tout compte connecté — ce sont des chiffres d'entreprise, pas des chiffres d'élève.
--
-- ⚠️ CLAUDE.md : une vue neuve n'hérite d'aucun droit sur une pile fraîche. Les
-- REVOKE sont donc explicites, et la suite pgTAP les vérifie sur base vierge.
--
-- RISK-1 — MÉTRIQUES VANITEUSES : partout des PERCENTILES (p50/p90/max), jamais une
-- moyenne seule. Une moyenne d'XP flatte le tableau de bord en masquant l'élève qui
-- décroche ; c'est précisément ce qu'on cherche à voir.
--
-- D-5 — LES COINS GAGNÉS NE SONT PAS PERSISTÉS par tentative (`attempts` ne porte
-- que `xp_earned`). Le flux de sources est donc RECONSTRUIT par la règle canonique
-- (~1 coin / 5 XP, demi-coins entre 40 et 59 %). C'est une APPROXIMATION assumée :
-- elle est marquée comme telle dans la vue et sur la page, pour que personne ne
-- prenne un estimé pour un relevé. La colonne `attempts.coins_earned` est le
-- durcissement du lot 3, pas un préalable.

-- ===========================================================================
-- 1. econ_xp_daily — l'XP gagné par élève et par jour (US-1).
--    Grain : (jour, élève). Les percentiles se calculent à la lecture, pas ici :
--    une vue qui agrège trop tôt interdit de reposer la question autrement.
-- ===========================================================================
CREATE OR REPLACE VIEW public.econ_xp_daily AS
SELECT
  a.user_id,
  date_trunc('day', a.completed_at)::date AS day,
  SUM(a.xp_earned)::int                   AS xp_earned,
  COUNT(*)::int                           AS attempts
FROM public.attempts a
WHERE a.completed_at IS NOT NULL
GROUP BY a.user_id, date_trunc('day', a.completed_at)::date;

-- ===========================================================================
-- 2. econ_level_velocity — combien de JOURS RÉELS pour atteindre chaque palier.
--    Le cumul d'XP daté est rejoué par élève ; le premier jour où le cumul franchit
--    N × XP_PER_LEVEL date le palier N. On mesure depuis la PREMIÈRE TENTATIVE, pas
--    depuis l'inscription : un compte créé et laissé dormir trois mois dirait « 90
--    jours pour le niveau 2 » et polluerait la médiane d'un bruit qui n'est pas de
--    l'apprentissage.
--    XP_PER_LEVEL (200) est écrit ici parce qu'une vue SQL ne peut pas importer
--    `gamification.ts` — divergence surveillée par la suite pgTAP, qui l'assert.
-- ===========================================================================
CREATE OR REPLACE VIEW public.econ_level_velocity AS
WITH cumulative AS (
  SELECT
    a.user_id,
    a.completed_at,
    SUM(a.xp_earned) OVER (
      PARTITION BY a.user_id ORDER BY a.completed_at
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS xp_cumulative,
    MIN(a.completed_at) OVER (PARTITION BY a.user_id) AS first_attempt_at
  FROM public.attempts a
  WHERE a.completed_at IS NOT NULL
)
SELECT
  c.user_id,
  (c.xp_cumulative / 200 + 1)::int AS level_reached,
  MIN(EXTRACT(EPOCH FROM (c.completed_at - c.first_attempt_at)) / 86400.0)::numeric(10, 2)
    AS days_to_reach
FROM cumulative c
WHERE c.xp_cumulative >= 200
GROUP BY c.user_id, (c.xp_cumulative / 200 + 1)::int;

-- ===========================================================================
-- 3. econ_coin_flows_30d — sources contre puits sur 30 jours glissants (US-2).
--    Les SOURCES sont reconstruites (D-5) ; les PUITS sont réels — le prix des
--    objets acquis, plus les rachats de série. Le ratio d'inflation est le rapport
--    puits/sources : sous 1, les coins s'accumulent et la boutique perd sa valeur.
--    ⚠️ `sources_estimated` porte son nom : ne jamais l'afficher sans le dire.
-- ===========================================================================
CREATE OR REPLACE VIEW public.econ_coin_flows_30d AS
WITH sources AS (
  -- Règle canonique : ~1 coin / 5 XP, moitié entre 40 et 59 % (sous 40 %, rien).
  SELECT COALESCE(SUM(
    CASE
      WHEN a.score_pct >= 60 THEN a.xp_earned / 5.0
      WHEN a.score_pct >= 40 THEN a.xp_earned / 10.0
      ELSE 0
    END
  ), 0)::numeric(12, 2) AS coins_estimated
  FROM public.attempts a
  WHERE a.completed_at >= now() - INTERVAL '30 days'
),
shop_sink AS (
  SELECT COALESCE(SUM(s.price_coins * i.quantity), 0)::int AS coins_spent
  FROM public.inventory_items i
  JOIN public.shop_items s ON s.id = i.shop_item_id
  WHERE i.acquired_at >= now() - INTERVAL '30 days'
)
SELECT
  (SELECT coins_estimated FROM sources) AS sources_estimated,
  (SELECT coins_spent FROM shop_sink)   AS sinks_shop,
  -- Rapport puits / sources. NULL quand rien n'est gagné : afficher « 0 %
  -- d'inflation » sur une économie à l'arrêt serait un chiffre faux, pas prudent.
  CASE
    WHEN (SELECT coins_estimated FROM sources) > 0
      THEN ((SELECT coins_spent FROM shop_sink) / (SELECT coins_estimated FROM sources))::numeric(6, 3)
    ELSE NULL
  END AS sink_ratio;

-- ===========================================================================
-- 4. econ_consumables — armement contre consommation, par objet (US-3).
--    Un consommable jamais consommé est un signal de DESIGN, pas un bug : l'élève
--    l'achète et ne s'en sert pas, ou ne comprend pas quand s'en servir.
--    `is_active` marque l'exemplaire encore armé ; un exemplaire consommé sort de
--    l'inventaire actif. On compte donc les deux faces sans rien inférer.
-- ===========================================================================
CREATE OR REPLACE VIEW public.econ_consumables AS
SELECT
  s.code,
  s.name,
  s.item_type,
  s.price_coins,
  COUNT(i.id)::int                                            AS acquired,
  COUNT(i.id) FILTER (WHERE i.is_active)::int                 AS still_armed,
  COUNT(i.id) FILTER (WHERE NOT i.is_active)::int             AS consumed,
  COUNT(DISTINCT i.student_user_id)::int                      AS holders
FROM public.shop_items s
LEFT JOIN public.inventory_items i ON i.shop_item_id = s.id
GROUP BY s.code, s.name, s.item_type, s.price_coins;

-- ===========================================================================
-- 5. econ_premium_funnel — actifs contre entitlements (US-4).
--    ⚠️ En phase GRATUITE (pivot du 2026-06-21), tout parcours est `is_premium =
--    false` : cette vue mesure donc une machinerie DORMANTE et doit rendre des
--    zéros. C'est voulu — elle existe pour le jour où la phase change, et un zéro
--    honnête vaut mieux qu'une section absente qu'on oublierait de rebrancher.
--    « Actif » = au moins une tentative sur 30 jours.
-- ===========================================================================
CREATE OR REPLACE VIEW public.econ_premium_funnel AS
WITH active AS (
  SELECT DISTINCT a.user_id
  FROM public.attempts a
  WHERE a.completed_at >= now() - INTERVAL '30 days'
),
entitled AS (
  SELECT DISTINCT e.user_id
  FROM public.parcours_entitlements e
  WHERE e.revoked_at IS NULL
    AND (e.expires_at IS NULL OR e.expires_at > now())
)
SELECT
  (SELECT COUNT(*) FROM active)::int                                  AS active_30d,
  (SELECT COUNT(*) FROM entitled)::int                                AS entitled_total,
  (SELECT COUNT(*) FROM active a JOIN entitled e ON e.user_id = a.user_id)::int
                                                                      AS active_entitled,
  (SELECT COUNT(*) FROM public.parcours WHERE is_premium)::int        AS premium_parcours;

-- ===========================================================================
-- Droits des vues — RIEN pour le client. Elles ne sont lisibles que par le
-- propriétaire, donc par le RPC SECURITY DEFINER ci-dessous.
-- ===========================================================================
REVOKE ALL ON public.econ_xp_daily        FROM PUBLIC, anon, authenticated;
REVOKE ALL ON public.econ_level_velocity  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON public.econ_coin_flows_30d  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON public.econ_consumables     FROM PUBLIC, anon, authenticated;
REVOKE ALL ON public.econ_premium_funnel  FROM PUBLIC, anon, authenticated;

-- ===========================================================================
-- Le RPC admin — une seule porte, un seul JSONB, une section par US.
--
-- R-1 : la page est READ-ONLY. Cette fonction ne mute rien, et il n'existe aucune
-- server fn de mutation en face — l'outil de mesure ne doit pas devenir un levier.
-- R-2 : que des AGRÉGATS anonymes. Aucun `user_id` ne sort d'ici ; les vues en
-- portent pour pouvoir calculer des percentiles PAR élève, pas pour les exposer.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.admin_economy_overview()
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_out JSONB;
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT jsonb_build_object(
    -- US-1 : la distribution, jamais la seule moyenne (RISK-1).
    'xp_daily', (
      SELECT jsonb_build_object(
        'p50', percentile_cont(0.5) WITHIN GROUP (ORDER BY d.xp_earned),
        'p90', percentile_cont(0.9) WITHIN GROUP (ORDER BY d.xp_earned),
        'max', MAX(d.xp_earned),
        'active_days', COUNT(*)
      )
      FROM public.econ_xp_daily d
      WHERE d.day >= (now() - INTERVAL '30 days')::date
    ),
    -- US-1 : le temps réel pour atteindre chaque palier, par percentiles.
    'level_velocity', (
      SELECT COALESCE(jsonb_agg(row_to_json(t) ORDER BY t.level_reached), '[]'::jsonb)
      FROM (
        SELECT
          v.level_reached,
          COUNT(*)::int AS students,
          percentile_cont(0.5) WITHIN GROUP (ORDER BY v.days_to_reach)::numeric(10, 2) AS p50_days,
          percentile_cont(0.9) WITHIN GROUP (ORDER BY v.days_to_reach)::numeric(10, 2) AS p90_days
        FROM public.econ_level_velocity v
        WHERE v.level_reached <= 10
        GROUP BY v.level_reached
      ) t
    ),
    -- US-2 : sources RECONSTRUITES (D-5) contre puits réels.
    'coin_flows', (SELECT row_to_json(c) FROM public.econ_coin_flows_30d c),
    -- US-3 : un objet jamais consommé est un signal de design.
    'consumables', (
      SELECT COALESCE(jsonb_agg(row_to_json(k) ORDER BY k.code), '[]'::jsonb)
      FROM public.econ_consumables k
    ),
    -- US-4 : dormant en phase gratuite, et c'est écrit sur la page.
    'premium_funnel', (SELECT row_to_json(f) FROM public.econ_premium_funnel f),
    -- Ce que l'estimation vaut : dit par la donnée, pas par un commentaire que
    -- l'écran ne lit pas.
    'notes', jsonb_build_object(
      'coins_sources_estimated', true,
      'xp_per_level', 200
    )
  ) INTO v_out;

  RETURN v_out;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_economy_overview() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_economy_overview() TO authenticated;
