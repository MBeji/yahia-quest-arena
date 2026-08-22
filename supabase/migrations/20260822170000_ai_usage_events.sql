-- Étude 29 — lot 1 : LA PORTE IA, côté base. La comptabilité de l'étage IA.
--
-- POURQUOI CETTE TABLE EST LA PREMIÈRE DE L'ÉTUDE
-- ---------------------------------------------------------------------------
-- L'étude 29 est une étude sur l'ARGENT autant que sur l'IA : à partir du moment
-- où une famille branche sa propre clé, chaque appel de modèle est une dépense
-- réelle sur un compte qui n'est pas le nôtre. R-7 pose la règle qui rend le
-- reste possible : « un appel IA porte toujours un payeur ». Sans cette colonne,
-- écrite dès le premier appel, aucune dépense n'est imputable, aucun plafond
-- n'est vérifiable, et la console parent du lot 5 n'aurait rien à lire.
--
-- Cette migration REMPLACE le lot 0 de l'étude 11 (D-1, arbitré par Q-1) : il n'y
-- a qu'un seul socle IA, et c'est celui-ci. `ai_usage_events` y gagne trois
-- colonnes que é11 n'avait pas prévues — `payer`, `credential_owner`, `provider`.
--
-- CE QUI N'ENTRE JAMAIS ICI
-- ---------------------------------------------------------------------------
-- Aucun texte d'élève, aucune sortie de modèle, aucun fragment de clé. Une ligne
-- dit COMBIEN et QUOI, jamais QUEL CONTENU. C'est la même posture que
-- `learning_pulses` : l'application sert des mineurs, et une table de télémétrie
-- qui porterait des transcriptions deviendrait la pièce la plus sensible du
-- système sans que personne ne l'ait décidé.
--
-- R-14, ABSOLUE : L'ÉLÈVE N'A AUCUN ACCÈS À CETTE TABLE
-- ---------------------------------------------------------------------------
-- Elle porte des MONTANTS. « Celui qui paie voit sa dépense ; celui dont un
-- autre paie ne voit que l'énergie. » Un enfant ne voit pas d'argent — y compris
-- par PostgREST, y compris en lisant ses propres lignes. La frontière est
-- `credential_owner`, pas le rôle : elle est donc vérifiable en SQL, et testée
-- comme telle (pgTAP S61).
--
-- AGENTS.md : une table neuve embarque ses propres GRANT explicites.

-- ---------------------------------------------------------------------------
-- 1. La table.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.ai_usage_events (
  id               BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  -- L'élève SERVI. NULL quand l'appel ne sert personne : la vérification d'une
  -- clé à l'enregistrement (US-2) est un geste du porteur, pas une leçon.
  -- `ON DELETE SET NULL` et non CASCADE : la dépense a EU LIEU, et un compte
  -- supprimé ne doit pas faire disparaître rétroactivement de l'argent dépensé.
  user_id          UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  -- R-7 : le payeur, résolu server-side AVANT l'appel.
  payer            TEXT NOT NULL CHECK (payer IN ('family', 'platform')),
  -- Le porteur de la clé. NULL sur le chemin plateforme — c'est nous qui payons.
  credential_owner UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  -- R-13 : le fournisseur RÉEL. Sans lui, la console qualité du lot 5 mélange
  -- les fournisseurs et ne veut plus rien dire.
  provider         TEXT NOT NULL,
  -- Les surfaces consommatrices. Vocabulaire fermé, miroir de `AI_FEATURES`
  -- (`src/shared/constants/ai.ts`) : une surface ajoutée côté code sans passer
  -- par une migration se fait refuser ici, et c'est voulu.
  feature          TEXT NOT NULL CHECK (feature IN (
    'verify',          -- vérification de clé (US-2)
    'explain',         -- explication personnalisée (é11 lot 1)
    'reformulate',     -- reformulation (é11 lot 1)
    'chat',            -- chat cadré (é11 lot 3)
    'check',           -- boucle de compréhension (é11 lot 4)
    'forge',           -- génération d'un quiz (é29 lot 4)
    'forge_solve',     -- double résolution d'un candidat (é29 lot 4)
    'exercise_gen',    -- exercices ciblés par le tuteur (é11 lot 5)
    'digest_student',  -- bilan hebdomadaire élève (é11 lot 6)
    'digest_parent'    -- bilan hebdomadaire parent (é11 lot 6)
  )),
  -- Le modèle RÉELLEMENT utilisé, tel que rapporté par le fournisseur. Pas
  -- celui demandé : un service qui substitue un modèle doit se voir (R-13).
  model            TEXT NOT NULL,
  input_tokens     INT NOT NULL DEFAULT 0 CHECK (input_tokens >= 0),
  output_tokens    INT NOT NULL DEFAULT 0 CHECK (output_tokens >= 0),
  cached_tokens    INT NOT NULL DEFAULT 0 CHECK (cached_tokens >= 0),
  -- ESTIMATION (R-12), en micro-dollars ENTIERS. Pas de flottant dans un
  -- compteur d'argent : une comparaison à un plafond doit être exacte, et une
  -- somme de milliers de lignes ne doit pas dériver.
  cost_usd_micros  BIGINT NOT NULL DEFAULT 0 CHECK (cost_usd_micros >= 0),
  status           TEXT NOT NULL CHECK (status IN ('ok', 'rejected', 'error', 'degraded', 'discarded')),
  -- Code STABLE de l'annexe C — jamais le corps d'erreur du fournisseur (R-5).
  error_code       TEXT,
  latency_ms       INT CHECK (latency_ms IS NULL OR latency_ms >= 0),
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.ai_usage_events IS
  'Comptabilité de l''étage IA (étude 29 lot 1, remplace é11 lot 0). Une ligne par appel, avec son PAYEUR. Aucun contenu : ni texte d''élève, ni sortie de modèle, ni fragment de clé. Écriture exclusive via log_ai_usage(). Rétention 12 mois.';
COMMENT ON COLUMN public.ai_usage_events.payer IS
  'R-7 : qui paie. ''family'' = clé du porteur (é29), ''platform'' = clé plateforme (é11, budget A5).';
COMMENT ON COLUMN public.ai_usage_events.cost_usd_micros IS
  'R-12 : ESTIMATION en micro-dollars, calculée depuis une table de prix DATÉE. Ne fait pas foi devant la facture du fournisseur.';

-- La requête de la console parent : « ma dépense, du plus récent au plus vieux ».
CREATE INDEX IF NOT EXISTS idx_ai_usage_owner_day
  ON public.ai_usage_events (credential_owner, created_at DESC);

-- La requête « ce que cet élève a consommé » (compteur d'énergie, lot 3).
CREATE INDEX IF NOT EXISTS idx_ai_usage_user_day
  ON public.ai_usage_events (user_id, created_at DESC);

ALTER TABLE public.ai_usage_events ENABLE ROW LEVEL SECURITY;

-- R-14a : l'élève dont un AUTRE paie ne lit rien ici. Il lit son énergie dans
-- les tables de é11. R-14b : le porteur voit SA dépense en entier, quel que soit
-- son rôle — un compte élève qui porte sa propre clé (ouvert par Q-2) est un
-- porteur, et lui cacher ce qu'il dépense de son propre argent serait pire que
-- le lui montrer.
DROP POLICY IF EXISTS ai_usage_select ON public.ai_usage_events;
CREATE POLICY ai_usage_select ON public.ai_usage_events
  FOR SELECT TO authenticated
  USING (public.is_admin() OR credential_owner = (SELECT auth.uid()));

-- Aucune policy d'écriture : le seul écrivain est log_ai_usage(), dont le
-- propriétaire contourne la RLS.
REVOKE ALL ON public.ai_usage_events FROM anon, authenticated;
GRANT SELECT ON public.ai_usage_events TO authenticated;
GRANT ALL ON public.ai_usage_events TO service_role;

-- ---------------------------------------------------------------------------
-- 2. L'écriture — la seule porte.
-- ---------------------------------------------------------------------------
-- SECURITY DEFINER et REVOKE d'`authenticated` : un client ne fabrique pas une
-- ligne de comptabilité. L'appelant légitime est l'orchestrateur, en
-- `service_role`, qui vient de recevoir l'usage du fournisseur.
CREATE OR REPLACE FUNCTION public.log_ai_usage(
  p_payer TEXT,
  p_provider TEXT,
  p_feature TEXT,
  p_model TEXT,
  p_status TEXT,
  p_user UUID DEFAULT NULL,
  p_credential_owner UUID DEFAULT NULL,
  p_input_tokens INT DEFAULT 0,
  p_output_tokens INT DEFAULT 0,
  p_cached_tokens INT DEFAULT 0,
  p_cost_usd_micros BIGINT DEFAULT 0,
  p_error_code TEXT DEFAULT NULL,
  p_latency_ms INT DEFAULT NULL
)
RETURNS BIGINT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_id BIGINT;
BEGIN
  -- R-7, vérifié en base et pas seulement en TypeScript : un payeur `family`
  -- sans porteur de clé est une dépense ORPHELINE, exactement ce que la règle
  -- interdit. La base est le dernier endroit où l'invariant peut encore tenir.
  IF p_payer = 'family' AND p_credential_owner IS NULL THEN
    RAISE EXCEPTION 'AI_USAGE_FAMILY_REQUIRES_OWNER';
  END IF;

  -- Symétrique : le chemin plateforme n'a pas de porteur, et en inventer un
  -- ferait porter notre dépense à une famille dans la console du lot 5.
  IF p_payer = 'platform' AND p_credential_owner IS NOT NULL THEN
    RAISE EXCEPTION 'AI_USAGE_PLATFORM_HAS_NO_OWNER';
  END IF;

  INSERT INTO public.ai_usage_events (
    user_id, payer, credential_owner, provider, feature, model,
    input_tokens, output_tokens, cached_tokens, cost_usd_micros,
    status, error_code, latency_ms
  )
  VALUES (
    p_user, p_payer, p_credential_owner, p_provider, p_feature, p_model,
    GREATEST(COALESCE(p_input_tokens, 0), 0),
    GREATEST(COALESCE(p_output_tokens, 0), 0),
    GREATEST(COALESCE(p_cached_tokens, 0), 0),
    GREATEST(COALESCE(p_cost_usd_micros, 0), 0),
    p_status,
    p_error_code,
    CASE WHEN p_latency_ms IS NULL THEN NULL ELSE GREATEST(p_latency_ms, 0) END
  )
  RETURNING id INTO v_id;

  RETURN v_id;
END;
$$;

COMMENT ON FUNCTION public.log_ai_usage(TEXT, TEXT, TEXT, TEXT, TEXT, UUID, UUID, INT, INT, INT, BIGINT, TEXT, INT) IS
  'Écrit un événement de comptabilité IA (R-7, R-13). Refuse une dépense orpheline : payer=family exige un credential_owner, payer=platform en interdit un.';

REVOKE EXECUTE ON FUNCTION public.log_ai_usage(TEXT, TEXT, TEXT, TEXT, TEXT, UUID, UUID, INT, INT, INT, BIGINT, TEXT, INT)
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 3. Rétention — 12 mois, alignée sur la télémétrie d'apprentissage.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.purge_ai_usage_events()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  DELETE FROM public.ai_usage_events
  WHERE created_at < now() - INTERVAL '12 months';
END;
$$;

REVOKE EXECUTE ON FUNCTION public.purge_ai_usage_events() FROM PUBLIC, anon, authenticated;

-- Purge quotidienne via pg_cron, enveloppée comme les autres : si l'extension
-- n'est pas disponible (stack locale nue), la migration réussit quand même — la
-- table et les RPC sont en place, seule la planification est différée.
DO $$
BEGIN
  CREATE EXTENSION IF NOT EXISTS pg_cron;

  PERFORM cron.unschedule(jobid)
  FROM cron.job
  WHERE jobname = 'purge-ai-usage-events';

  PERFORM cron.schedule(
    'purge-ai-usage-events',
    '35 3 * * *',
    $cron$SELECT public.purge_ai_usage_events();$cron$
  );
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE
    'pg_cron indisponible (%). La comptabilité IA fonctionne mais ne sera PAS purgée automatiquement. Activer pg_cron (Supabase -> Database -> Extensions) puis rejouer le bloc cron.schedule(...).',
    SQLERRM;
END;
$$;
