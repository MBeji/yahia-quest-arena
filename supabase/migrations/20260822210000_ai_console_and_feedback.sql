-- Étude 29 — lot 5 : CE QUE LA FAMILLE VOIT, ET CE QUE L'ADMIN MESURE.
--
-- LA QUESTION À LAQUELLE CE LOT RÉPOND
-- ---------------------------------------------------------------------------
-- « Le ratio 👍/👎 par modèle : le tableau qui dira si un modèle bon marché tient
-- la barre — donnée que personne n'a aujourd'hui » (§1.4). Les quatre lots
-- précédents ont produit la matière ; celui-ci la rend lisible, et en tire la
-- seule décision automatique de l'étude : NOMMER un modèle qui échoue trop
-- (R-19). Nommer, jamais basculer — c'est sa clé, donc son choix (D-11).
--
-- R-14, ENCORE, PARCE QUE C'EST ICI QU'ELLE SE JOUE
-- ---------------------------------------------------------------------------
-- Ce lot est celui des MONTANTS. `get_ai_console` est self-scoped sur
-- `auth.uid()` : elle rend la dépense de SON appelant, et un porteur n'a aucun
-- moyen de la faire parler d'un autre. Un élève qui l'appelle sans porter de clé
-- obtient des zéros — pas une erreur, parce que « pas de clé » n'est pas une
-- anomalie, c'est l'état par défaut de tout le monde (R-1).
--
-- Et la console ADMIN ne voit que des AGRÉGATS : « aucun transcript, aucune clé,
-- aucun montant nominatif au-delà de l'agrégat » (§3.9).

-- ---------------------------------------------------------------------------
-- 1. RETOUR QUALITÉ — 👍/👎, canal SÉPARÉ du catalogue (R-17).
-- ---------------------------------------------------------------------------
-- « Le signalement d'une erreur sur un item forgé va au canal IA, JAMAIS dans la
-- file `content_reports` du catalogue. » Deux raisons : le contenu forgé n'est
-- pas du catalogue (personne ne le corrigera), et noyer la file éditoriale sous
-- des signalements de contenu éphémère la rendrait inutilisable.
CREATE TABLE IF NOT EXISTS public.ai_feedback (
  id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id    UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  usage_id   BIGINT REFERENCES public.ai_usage_events(id) ON DELETE SET NULL,
  quiz_id    UUID REFERENCES public.ai_forged_quizzes(id) ON DELETE CASCADE,
  verdict    TEXT NOT NULL CHECK (verdict IN ('up', 'down')),
  reason     TEXT CHECK (reason IS NULL OR char_length(reason) <= 300),
  -- R-13 : le modèle qui a produit le contenu jugé. Sans lui, la console qualité
  -- mélange les fournisseurs et ne veut plus rien dire.
  model      TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.ai_feedback IS
  'Retours 👍/👎 sur du contenu IA (étude 29 lot 5). Canal SÉPARÉ de content_reports (R-17) : le contenu forgé n''est pas du catalogue. Rétention 12 mois.';

CREATE INDEX IF NOT EXISTS idx_ai_feedback_model ON public.ai_feedback (model, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_ai_feedback_quiz ON public.ai_feedback (quiz_id);

ALTER TABLE public.ai_feedback ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS ai_feedback_select ON public.ai_feedback;
CREATE POLICY ai_feedback_select ON public.ai_feedback
  FOR SELECT TO authenticated
  USING (user_id = (SELECT auth.uid()) OR public.is_admin());
REVOKE ALL ON public.ai_feedback FROM anon, authenticated;
GRANT SELECT ON public.ai_feedback TO authenticated;
GRANT ALL ON public.ai_feedback TO service_role;

-- L'écriture passe par une RPC : le `model` doit venir du QUIZ, pas du client.
-- Laisser le navigateur le déclarer permettrait d'imputer un 👎 au mauvais
-- modèle, et la seule donnée que ce lot produit deviendrait fausse.
CREATE OR REPLACE FUNCTION public.submit_ai_feedback(
  p_quiz UUID,
  p_verdict TEXT,
  p_reason TEXT DEFAULT NULL
)
RETURNS BIGINT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_quiz public.ai_forged_quizzes%ROWTYPE;
  v_id BIGINT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT * INTO v_quiz FROM public.ai_forged_quizzes q WHERE q.id = p_quiz;
  IF NOT FOUND OR (v_quiz.student_user_id <> v_user AND v_quiz.owner_user_id <> v_user) THEN
    RAISE EXCEPTION 'AI_FORGE_NOT_FOUND';
  END IF;

  INSERT INTO public.ai_feedback (user_id, quiz_id, verdict, reason, model)
  VALUES (v_user, p_quiz, p_verdict, NULLIF(btrim(COALESCE(p_reason, '')), ''), v_quiz.model)
  RETURNING id INTO v_id;

  RETURN v_id;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.submit_ai_feedback(UUID, TEXT, TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.submit_ai_feedback(UUID, TEXT, TEXT) TO authenticated;

-- ---------------------------------------------------------------------------
-- 2. LA CONSOLE DU PORTEUR — dépense, activations, qualité (§3.9).
-- ---------------------------------------------------------------------------
-- Ce que l'étude demande : « statut de la clé, dépense, activations, qualité par
-- modèle, journal des 20 derniers appels (surface, date, statut, coût estimé —
-- JAMAIS le contenu) ».
--
-- Le montant est une ESTIMATION et la fonction ne prétend pas autre chose : elle
-- rend des micro-dollars issus d'une table de prix DATÉE (R-12). C'est l'écran
-- qui porte la mention permanente de renvoi au fournisseur.
CREATE OR REPLACE FUNCTION public.get_ai_console()
RETURNS TABLE (
  day_micros BIGINT,
  month_micros BIGINT,
  daily_budget_usd NUMERIC,
  monthly_budget_usd NUMERIC,
  calls_month INT,
  by_feature JSONB,
  by_student JSONB,
  by_model JSONB,
  recent JSONB,
  forge_discard_rate NUMERIC
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_owner UUID := auth.uid();
  v_month_start DATE := date_trunc('month', CURRENT_DATE)::DATE;
BEGIN
  IF v_owner IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  RETURN QUERY
  WITH ledger AS (
    SELECT
      COALESCE(SUM(l.spent_micros) FILTER (WHERE l.day = CURRENT_DATE), 0) AS today,
      COALESCE(SUM(l.spent_micros), 0) AS month
      FROM public.ai_spend_ledger l
     WHERE l.owner_user_id = v_owner AND l.day >= v_month_start
  ),
  events AS (
    SELECT * FROM public.ai_usage_events e
     WHERE e.credential_owner = v_owner AND e.created_at >= v_month_start
  ),
  -- Le rebut de la Forge sur 7 jours : la mesure de R-19. Elle vient des quiz,
  -- pas des événements — c'est là que « combien de candidats jetés » est écrit.
  forge AS (
    SELECT COALESCE(SUM(q.discarded), 0)::NUMERIC AS discarded,
           COALESCE(SUM(COALESCE(jsonb_array_length(q.payload->'items'), 0)), 0)::NUMERIC AS kept
      FROM public.ai_forged_quizzes q
     WHERE q.owner_user_id = v_owner
       AND q.created_at >= now() - INTERVAL '7 days'
  )
  SELECT
    (SELECT today FROM ledger)::BIGINT,
    (SELECT month FROM ledger)::BIGINT,
    c.daily_budget_usd,
    c.monthly_budget_usd,
    (SELECT COUNT(*)::INT FROM events),
    COALESCE((SELECT jsonb_object_agg(f.feature, f.total)
                FROM (SELECT e.feature, SUM(e.cost_usd_micros) AS total
                        FROM events e GROUP BY e.feature) f), '{}'::jsonb),
    -- Par élève : le PSEUDO, pas l'identifiant — la console parent nomme des
    -- enfants, elle n'expose pas des UUID.
    COALESCE((SELECT jsonb_object_agg(COALESCE(s.name, '?'), s.total)
                FROM (SELECT p.display_name AS name, SUM(e.cost_usd_micros) AS total
                        FROM events e
                        LEFT JOIN public.profiles p ON p.id = e.user_id
                       WHERE e.user_id IS NOT NULL
                       GROUP BY p.display_name) s), '{}'::jsonb),
    -- Par modèle : la donnée de R-13, celle qui rend un 👎 imputable.
    COALESCE((SELECT jsonb_object_agg(m.model, jsonb_build_object(
                       'micros', m.total, 'calls', m.calls, 'errors', m.errors))
                FROM (SELECT e.model,
                             SUM(e.cost_usd_micros) AS total,
                             COUNT(*) AS calls,
                             COUNT(*) FILTER (WHERE e.status <> 'ok') AS errors
                        FROM events e GROUP BY e.model) m), '{}'::jsonb),
    -- Les 20 derniers appels : surface, date, statut, coût. JAMAIS le contenu.
    COALESCE((SELECT jsonb_agg(jsonb_build_object(
                       'feature', r.feature, 'model', r.model, 'status', r.status,
                       'errorCode', r.error_code, 'micros', r.cost_usd_micros,
                       'at', r.created_at) ORDER BY r.created_at DESC)
                FROM (SELECT * FROM events ORDER BY created_at DESC LIMIT 20) r), '[]'::jsonb),
    CASE WHEN (SELECT discarded + kept FROM forge) > 0
         THEN ROUND((SELECT discarded FROM forge) / (SELECT discarded + kept FROM forge), 3)
         ELSE 0 END
    FROM public.ai_credentials c
   WHERE c.owner_user_id = v_owner;
END;
$$;

COMMENT ON FUNCTION public.get_ai_console() IS
  'Ce que la console du porteur affiche (§3.9) : dépense jour/mois ESTIMÉE, par surface, par élève, par modèle, 20 derniers appels et taux de rebut de la Forge sur 7 jours (R-19). Jamais le secret, jamais le contenu d''un appel.';

REVOKE EXECUTE ON FUNCTION public.get_ai_console() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_ai_console() TO authenticated;

-- ---------------------------------------------------------------------------
-- 3. LA CONSOLE ADMIN — des AGRÉGATS, et rien d'autre (§3.9).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_ai_admin_overview()
RETURNS TABLE (
  ai_enabled BOOLEAN,
  families_with_key INT,
  families_suspended INT,
  students_enabled INT,
  calls_30d INT,
  micros_30d BIGINT,
  by_provider JSONB,
  by_model JSONB,
  quality_by_model JSONB
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- La console admin est la seule surface de l'étude qui voit au-delà d'une
  -- famille : elle est donc la seule à mériter une garde de rôle explicite.
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  RETURN QUERY
  SELECT
    COALESCE((SELECT s.ai_enabled FROM public.ai_admin_state s WHERE s.id), true),
    (SELECT COUNT(*)::INT FROM public.ai_credentials),
    (SELECT COUNT(*)::INT FROM public.ai_owner_suspensions),
    (SELECT COUNT(*)::INT FROM public.ai_student_access WHERE enabled),
    (SELECT COUNT(*)::INT FROM public.ai_usage_events
      WHERE created_at >= now() - INTERVAL '30 days'),
    (SELECT COALESCE(SUM(cost_usd_micros), 0)::BIGINT FROM public.ai_usage_events
      WHERE created_at >= now() - INTERVAL '30 days'),
    COALESCE((SELECT jsonb_object_agg(p.provider, p.calls)
                FROM (SELECT provider, COUNT(*) AS calls FROM public.ai_usage_events
                       WHERE created_at >= now() - INTERVAL '30 days'
                       GROUP BY provider) p), '{}'::jsonb),
    COALESCE((SELECT jsonb_object_agg(m.model, m.calls)
                FROM (SELECT model, COUNT(*) AS calls FROM public.ai_usage_events
                       WHERE created_at >= now() - INTERVAL '30 days'
                       GROUP BY model) m), '{}'::jsonb),
    -- ⭐ LE tableau de §1.4 : « le ratio 👍/👎 par modèle — la donnée que
    -- personne n'a aujourd'hui ». C'est lui qui dira si un modèle bon marché
    -- tient la barre, et il n'existe nulle part ailleurs.
    COALESCE((SELECT jsonb_object_agg(q.model, jsonb_build_object(
                       'up', q.up, 'down', q.down))
                FROM (SELECT model,
                             COUNT(*) FILTER (WHERE verdict = 'up') AS up,
                             COUNT(*) FILTER (WHERE verdict = 'down') AS down
                        FROM public.ai_feedback
                       WHERE created_at >= now() - INTERVAL '30 days'
                       GROUP BY model) q), '{}'::jsonb);
END;
$$;

COMMENT ON FUNCTION public.get_ai_admin_overview() IS
  'Agrégats plateforme (§3.9) : adoption, fournisseurs, modèles, ratio 👍/👎 par modèle. AUCUN transcript, AUCUNE clé, AUCUN montant nominatif.';

REVOKE EXECUTE ON FUNCTION public.get_ai_admin_overview() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_ai_admin_overview() TO authenticated;

-- ---------------------------------------------------------------------------
-- 4. LES KILL-SWITCHES, actionnables (§2.1 : « couper globalement ou par famille »).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.set_ai_mode_enabled(p_enabled BOOLEAN)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  UPDATE public.ai_admin_state
     SET ai_enabled = COALESCE(p_enabled, true), updated_at = now()
   WHERE id;

  RETURN COALESCE(p_enabled, true);
END;
$$;

REVOKE EXECUTE ON FUNCTION public.set_ai_mode_enabled(BOOLEAN) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_ai_mode_enabled(BOOLEAN) TO authenticated;

CREATE OR REPLACE FUNCTION public.set_ai_owner_suspension(
  p_owner UUID,
  p_suspended BOOLEAN,
  p_reason TEXT DEFAULT NULL
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_suspended THEN
    INSERT INTO public.ai_owner_suspensions (owner_user_id, reason)
    VALUES (p_owner, p_reason)
    ON CONFLICT (owner_user_id) DO UPDATE SET reason = EXCLUDED.reason;
  ELSE
    DELETE FROM public.ai_owner_suspensions WHERE owner_user_id = p_owner;
  END IF;

  RETURN p_suspended;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.set_ai_owner_suspension(UUID, BOOLEAN, TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_ai_owner_suspension(UUID, BOOLEAN, TEXT) TO authenticated;

-- ---------------------------------------------------------------------------
-- 5. Purge du retour qualité — 12 mois (§3.3).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.purge_ai_feedback()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  DELETE FROM public.ai_feedback WHERE created_at < now() - INTERVAL '12 months';
END;
$$;

REVOKE EXECUTE ON FUNCTION public.purge_ai_feedback() FROM PUBLIC, anon, authenticated;

DO $$
BEGIN
  CREATE EXTENSION IF NOT EXISTS pg_cron;
  PERFORM cron.unschedule(jobid) FROM cron.job WHERE jobname = 'purge-ai-feedback';
  PERFORM cron.schedule(
    'purge-ai-feedback', '50 3 * * *',
    $cron$SELECT public.purge_ai_feedback();$cron$
  );
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE
    'pg_cron indisponible (%). Les retours qualité fonctionnent mais ne seront PAS purgés à 12 mois. Activer pg_cron puis rejouer le bloc cron.schedule(...).',
    SQLERRM;
END;
$$;
