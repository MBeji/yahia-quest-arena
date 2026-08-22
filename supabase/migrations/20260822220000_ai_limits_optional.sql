-- =========================================================
-- LES PLAFONDS DE CONSOMMATION DEVIENNENT UN RÉGLAGE, ÉTEINT PAR DÉFAUT.
--
-- CE QUE CETTE MIGRATION CHANGE, ET CE QU'ELLE NE CHANGE PAS
-- ---------------------------------------------------------------------------
-- Décision produit du 2026-08-22 : la coupure automatique — argent ET énergie —
-- ne s'applique plus par défaut. Elle reste dans le code, pilotée par une
-- colonne, réarmable depuis les Réglages sans redéploiement. Le jour où une clé
-- fuit, le frein est encore là, à un interrupteur près.
--
-- ⚠️ ON NE COUPE PLUS ; ON CONTINUE DE COMPTER ET DE PRÉVENIR.
-- La réservation reste écrite dans les deux grands livres, `log_ai_usage` reste
-- appelé, et `ai_budget_alerts_due` continue de rendre les seuils 50/80/100 %
-- ainsi que l'alerte d'anomalie. Retirer aussi la mesure rendrait `/admin/ia`,
-- la console de dépense (R-12) et l'avis de modèle (R-19) aveugles — et
-- l'anomalie à 3× la médiane devient JUSTEMENT le dernier garde-fou quand plus
-- rien ne coupe. C'est la seule partie de R-11 qui survit, et elle compte double.
--
-- Ce que cela coûte, écrit noir sur blanc :
--   • RISK-2 (« facture surprise ») n'est plus arrêté par la machine. Il est
--     seulement SIGNALÉ. C'est un choix assumé du porteur du produit.
--   • Le plafond d'énergie de R-9 n'était pas un garde-fou de coût mais un
--     garde-fou PÉDAGOGIQUE (é09 anti-farm, é11 R-12). Il tombe avec le reste :
--     la décision portait explicitement sur les deux.
--
-- La réservation elle-même est CONSERVÉE même quand rien ne coupe : c'est elle
-- qui sérialise deux appels concurrents sur le verrou de ligne du grand livre.
-- La retirer casserait la comptabilité, pas seulement le plafond.
-- =========================================================

-- ---------------------------------------------------------------------------
-- 1. L'interrupteur, par porteur de clé.
-- ---------------------------------------------------------------------------
ALTER TABLE public.ai_credentials
  ADD COLUMN IF NOT EXISTS limits_enforced BOOLEAN NOT NULL DEFAULT false;

COMMENT ON COLUMN public.ai_credentials.limits_enforced IS
  'false (défaut) : les plafonds argent ET énergie sont MESURÉS et ALERTÉS mais ne coupent jamais. true : reserve_ai_spend refuse au-delà, comportement d''origine de R-11/D-8. Décision du 2026-08-22.';

-- ---------------------------------------------------------------------------
-- 2. `reserve_ai_spend` — même signature, la coupure devient conditionnelle.
-- ---------------------------------------------------------------------------
-- La signature ne bouge PAS, volontairement : au merge, le déploiement Vercel et
-- `db-migrate-prod` courent en parallèle. Un code neuf contre une base ancienne
-- (ou l'inverse) doit continuer à fonctionner le temps de la fenêtre.
CREATE OR REPLACE FUNCTION public.reserve_ai_spend(
  p_owner UUID,
  p_student UUID,
  p_micros BIGINT,
  p_energy INT
)
RETURNS TABLE (granted BOOLEAN, reason TEXT, day_micros BIGINT, month_micros BIGINT)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_cred         public.ai_credentials%ROWTYPE;
  v_access       public.ai_student_access%ROWTYPE;
  v_day_total    BIGINT;
  v_month_total  BIGINT;
  v_daily_cap    BIGINT;
  v_monthly_cap  BIGINT;
  v_energy_spent INT;
  v_enforce      BOOLEAN;
BEGIN
  SELECT * INTO v_cred FROM public.ai_credentials c WHERE c.owner_user_id = p_owner;
  IF NOT FOUND THEN
    RETURN QUERY SELECT false, 'AI_KEY_INVALID', 0::BIGINT, 0::BIGINT;
    RETURN;
  END IF;

  v_enforce     := COALESCE(v_cred.limits_enforced, false);
  v_daily_cap   := (v_cred.daily_budget_usd   * 1000000)::BIGINT;
  v_monthly_cap := (v_cred.monthly_budget_usd * 1000000)::BIGINT;

  -- L'UPSERT prend un verrou de LIGNE sur (owner, jour). Deux appels concurrents
  -- se sérialisent ici : le second lit le total que le premier vient d'écrire.
  -- Vrai que les plafonds coupent ou non — c'est la comptabilité, pas le frein.
  INSERT INTO public.ai_spend_ledger (owner_user_id, day)
  VALUES (p_owner, CURRENT_DATE)
  ON CONFLICT (owner_user_id, day) DO UPDATE SET updated_at = now();

  SELECT l.reserved_micros + l.spent_micros INTO v_day_total
    FROM public.ai_spend_ledger l
   WHERE l.owner_user_id = p_owner AND l.day = CURRENT_DATE
     FOR UPDATE;

  SELECT COALESCE(SUM(l.reserved_micros + l.spent_micros), 0) INTO v_month_total
    FROM public.ai_spend_ledger l
   WHERE l.owner_user_id = p_owner
     AND l.day >= date_trunc('month', CURRENT_DATE)::DATE;

  -- Le plafond JOURNALIER protège de l'emballement, le MENSUEL protège la
  -- facture. Les deux restent vérifiés — mais seulement si le porteur les a armés.
  IF v_enforce
     AND (v_day_total + p_micros > v_daily_cap OR v_month_total + p_micros > v_monthly_cap) THEN
    RETURN QUERY SELECT false, 'AI_BUDGET_REACHED', v_day_total, v_month_total;
    RETURN;
  END IF;

  -- L'énergie est réservée DANS LA MÊME TRANSACTION que l'argent (R-11) :
  -- accorder l'un sans l'autre laisserait un appel partir sur un compteur faux.
  -- Le COMPTEUR tourne toujours ; c'est le REFUS qui devient conditionnel.
  IF p_energy > 0 THEN
    SELECT * INTO v_access FROM public.ai_student_access a WHERE a.student_user_id = p_student;
    IF NOT FOUND THEN
      -- Ceci n'est PAS un plafond : c'est l'activation (R-3). Un élève qui n'a
      -- pas été activé ne passe pas, plafonds armés ou non.
      RETURN QUERY SELECT false, 'AI_MODE_OFF', v_day_total, v_month_total;
      RETURN;
    END IF;

    INSERT INTO public.ai_energy_ledger (student_user_id, day, spent)
    VALUES (p_student, CURRENT_DATE, 0)
    ON CONFLICT (student_user_id, day) DO UPDATE SET updated_at = now();

    SELECT e.spent INTO v_energy_spent
      FROM public.ai_energy_ledger e
     WHERE e.student_user_id = p_student AND e.day = CURRENT_DATE
       FOR UPDATE;

    IF v_enforce AND v_energy_spent + p_energy > v_access.daily_energy_max THEN
      RETURN QUERY SELECT false, 'AI_ENERGY_SPENT', v_day_total, v_month_total;
      RETURN;
    END IF;

    UPDATE public.ai_energy_ledger
       SET spent = spent + p_energy, updated_at = now()
     WHERE student_user_id = p_student AND day = CURRENT_DATE;
  END IF;

  UPDATE public.ai_spend_ledger
     SET reserved_micros = reserved_micros + p_micros, updated_at = now()
   WHERE owner_user_id = p_owner AND day = CURRENT_DATE;

  RETURN QUERY SELECT true, NULL::TEXT, v_day_total + p_micros, v_month_total + p_micros;
END;
$$;

COMMENT ON FUNCTION public.reserve_ai_spend(UUID, UUID, BIGINT, INT) IS
  'Réserve argent + énergie dans une seule transaction, AVANT l''appel (R-11/D-8). Depuis le 2026-08-22 le REFUS est conditionné à ai_credentials.limits_enforced (défaut false) : sans lui on compte et on alerte, on ne coupe pas. La réservation, elle, a toujours lieu — c''est elle qui sérialise deux appels concurrents.';

REVOKE EXECUTE ON FUNCTION public.reserve_ai_spend(UUID, UUID, BIGINT, INT) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 3. Lire et écrire le réglage.
-- ---------------------------------------------------------------------------
-- `get_ai_credential_status` gagne une colonne : il faut la DÉPOSER d'abord,
-- PostgreSQL refusant de changer le type de retour d'une fonction en place.
DROP FUNCTION IF EXISTS public.get_ai_credential_status();

CREATE FUNCTION public.get_ai_credential_status()
RETURNS TABLE (
  provider TEXT,
  base_url TEXT,
  model_fast TEXT,
  model_rich TEXT,
  last4 TEXT,
  status TEXT,
  last_error_code TEXT,
  verified_at TIMESTAMPTZ,
  last_used_at TIMESTAMPTZ,
  daily_budget_usd NUMERIC,
  monthly_budget_usd NUMERIC,
  double_solve BOOLEAN,
  consent_version TEXT,
  limits_enforced BOOLEAN
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  RETURN QUERY
  SELECT c.provider, c.base_url, c.model_fast, c.model_rich, c.last4, c.status,
         c.last_error_code, c.verified_at, c.last_used_at,
         c.daily_budget_usd, c.monthly_budget_usd, c.double_solve, c.consent_version,
         c.limits_enforced
    FROM public.ai_credentials c
   WHERE c.owner_user_id = v_user;
END;
$$;

COMMENT ON FUNCTION public.get_ai_credential_status() IS
  'R-4 : l''état de SA propre clé, sans le secret ni son empreinte. `last4` est le seul fragment en clair. Aucune autre porte de lecture n''existe.';

REVOKE EXECUTE ON FUNCTION public.get_ai_credential_status() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_ai_credential_status() TO authenticated;

-- `set_ai_preferences` gagne un paramètre. Ajouter un argument à DÉFAUT sans
-- déposer l'ancienne créerait une surcharge AMBIGUË pour tout appel à trois
-- arguments : on dépose, puis on recrée.
DROP FUNCTION IF EXISTS public.set_ai_preferences(NUMERIC, NUMERIC, BOOLEAN);

CREATE FUNCTION public.set_ai_preferences(
  p_daily_budget_usd NUMERIC,
  p_monthly_budget_usd NUMERIC,
  p_double_solve BOOLEAN,
  p_limits_enforced BOOLEAN DEFAULT NULL
)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_updated INT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  UPDATE public.ai_credentials
     SET daily_budget_usd   = p_daily_budget_usd,
         monthly_budget_usd = p_monthly_budget_usd,
         double_solve       = COALESCE(p_double_solve, true),
         -- NULL ⇒ l'appelant ne se prononce pas, on garde la valeur en place.
         -- C'est ce qui permet à un client d'avant cette migration d'écrire ses
         -- plafonds sans réarmer la coupure à son insu.
         limits_enforced    = COALESCE(p_limits_enforced, public.ai_credentials.limits_enforced),
         updated_at         = now()
   WHERE owner_user_id = v_user;

  GET DIAGNOSTICS v_updated = ROW_COUNT;
  RETURN v_updated > 0;
END;
$$;

COMMENT ON FUNCTION public.set_ai_preferences(NUMERIC, NUMERIC, BOOLEAN, BOOLEAN) IS
  'Plafonds monétaires (R-11), double résolution (R-18bis) et ARMEMENT des plafonds du porteur appelant. Self-scoped : n''écrit jamais la ligne d''un autre. p_limits_enforced NULL laisse le réglage inchangé.';

REVOKE EXECUTE ON FUNCTION public.set_ai_preferences(NUMERIC, NUMERIC, BOOLEAN, BOOLEAN) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_ai_preferences(NUMERIC, NUMERIC, BOOLEAN, BOOLEAN) TO authenticated;

-- ---------------------------------------------------------------------------
-- 4. `get_ai_console` rend aussi le FOURNISSEUR — pour que R-19 vise juste.
-- ---------------------------------------------------------------------------
-- L'avis de modèle (R-19) suggérait jusqu'ici la liste OpenAI à tout ce qui
-- n'était pas Claude, faute de savoir chez QUI le porteur appelle : un porteur
-- DeepSeek se voyait conseiller `gpt-5`, inexistant sur son endpoint. La console
-- rend donc l'adresse, et le client en déduit le bon préréglage. Aucune donnée
-- sensible n'entre ici : `provider` et `base_url` sont déjà lisibles par le
-- porteur via `get_ai_credential_status`, et restent self-scoped sur auth.uid().
DROP FUNCTION IF EXISTS public.get_ai_console();

CREATE FUNCTION public.get_ai_console()
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
  forge_discard_rate NUMERIC,
  provider TEXT,
  base_url TEXT,
  limits_enforced BOOLEAN
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
         ELSE 0 END,
    c.provider,
    c.base_url,
    c.limits_enforced
    FROM public.ai_credentials c
   WHERE c.owner_user_id = v_owner;
END;
$$;

COMMENT ON FUNCTION public.get_ai_console() IS
  'Ce que la console du porteur affiche (§3.9) : dépense jour/mois ESTIMÉE, par surface, par élève, par modèle, 20 derniers appels, taux de rebut de la Forge sur 7 jours (R-19), et le fournisseur — dont l''avis de modèle a besoin pour suggérer des identifiants qui existent chez LUI. Jamais le secret, jamais le contenu d''un appel.';

REVOKE EXECUTE ON FUNCTION public.get_ai_console() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_ai_console() TO authenticated;
