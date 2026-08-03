-- Étude 09 — correction du lot 1 : les coins gagnés n'étaient pas à estimer.
--
-- Le lot 1 (20260801120000) reconstruisait les sources de coins par « la règle
-- canonique » : ~1 coin / 5 XP, moitié entre 40 et 59 %. En écrivant le simulateur
-- du lot 2, la règle a été confrontée à son autorité — `submit_exercise_attempt` —
-- et elle ne s'y trouve pas :
--
--   * il n'existe AUCUNE règle de demi-coins. L'éligibilité est binaire
--     (`NOT too_fast AND score_pct >= 60 AND score_pct > prev_best`) : en dessous,
--     ni XP ni coins. La branche « 40-59 % → xp/10 » de la vue décrivait un
--     comportement que le moteur n'a jamais eu ;
--   * les coins ne sont pas dérivés de l'XP. C'est `exercises.reward_coins`, un
--     FORFAIT authoré par exercice. Le rapport « ~1 coin / 5 XP » est une
--     convention d'écriture du corpus, pas un calcul du moteur.
--
-- La branche morte ne faussait pas les chiffres (sous 60 %, `xp_earned` vaut 0,
-- donc `xp/10` valait 0) — mais une vue qui documente une règle inexistante finit
-- par être lue comme la spécification. C'est ce qu'on corrige.
--
-- ET LA PRÉMISSE DE D-5 TOMBE AVEC. « Les coins gagnés ne sont pas persistés, donc
-- on estime » : vrai pour la colonne, faux pour l'information. Tout est là —
-- `attempts.xp_earned > 0` dit EXACTEMENT quelles tentatives ont été récompensées
-- (c'est la même porte d'éligibilité qui décide des deux), et
-- `exercises.reward_coins` dit combien. Le flux se CALCULE.
--
-- Reste une seule inconnue, et elle est nommée dans la vue : une potion a pu
-- multiplier les coins d'une tentative, et ce multiplicateur n'est stocké nulle
-- part. C'est un écart borné (les potions sont rares et se consomment), là où le
-- précédent était une règle inventée. `sources_estimated` devient donc
-- `sources_earned`, avec une note honnête plutôt qu'un nom vague.

-- DROP + CREATE, pas OR REPLACE : Postgres refuse de RENOMMER une colonne de vue,
-- et `sources_estimated` devient `sources_earned` — le nom faisait partie du
-- mensonge. Le RPC qui la lit résout ses noms à l'exécution, donc l'ordre importe
-- peu ; il est recréé plus bas de toute façon.
DROP VIEW IF EXISTS public.econ_coin_flows_30d;

CREATE VIEW public.econ_coin_flows_30d AS
WITH sources AS (
  -- Les tentatives RÉCOMPENSÉES, à leur forfait réel. `xp_earned > 0` est la
  -- signature de l'éligibilité : le RPC met XP et coins à zéro ensemble.
  SELECT COALESCE(SUM(e.reward_coins), 0)::int AS coins_earned
  FROM public.attempts a
  JOIN public.exercises e ON e.id = a.exercise_id
  WHERE a.completed_at >= now() - INTERVAL '30 days'
    AND a.xp_earned > 0
),
shop_sink AS (
  SELECT COALESCE(SUM(s.price_coins * i.quantity), 0)::int AS coins_spent
  FROM public.inventory_items i
  JOIN public.shop_items s ON s.id = i.shop_item_id
  WHERE i.acquired_at >= now() - INTERVAL '30 days'
)
SELECT
  (SELECT coins_earned FROM sources)::numeric(12, 2) AS sources_earned,
  (SELECT coins_spent FROM shop_sink)                AS sinks_shop,
  -- Rapport puits / sources. NULL quand rien n'est gagné : afficher « 0 %
  -- d'inflation » sur une économie à l'arrêt serait un chiffre faux, pas prudent.
  CASE
    WHEN (SELECT coins_earned FROM sources) > 0
      THEN ((SELECT coins_spent FROM shop_sink)::numeric
            / (SELECT coins_earned FROM sources))::numeric(6, 3)
    ELSE NULL
  END AS sink_ratio;

REVOKE ALL ON public.econ_coin_flows_30d FROM PUBLIC, anon, authenticated;

-- Le RPC renomme la clé et corrige sa note : ce n'est plus une estimation dérivée
-- d'une règle, c'est la somme des forfaits réellement versés — à la potion près.
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
    'coin_flows', (SELECT row_to_json(c) FROM public.econ_coin_flows_30d c),
    'consumables', (
      SELECT COALESCE(jsonb_agg(row_to_json(k) ORDER BY k.code), '[]'::jsonb)
      FROM public.econ_consumables k
    ),
    'premium_funnel', (SELECT row_to_json(f) FROM public.econ_premium_funnel f),
    'notes', jsonb_build_object(
      -- La seule inconnue restante, nommée : un multiplicateur de potion n'est
      -- stocké nulle part, donc les sources sont un plancher.
      'coins_exclude_potion_multipliers', true,
      'xp_per_level', 200
    )
  ) INTO v_out;

  RETURN v_out;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_economy_overview() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_economy_overview() TO authenticated;
