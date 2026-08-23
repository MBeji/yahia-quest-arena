-- Étude 29 — lot 3 : LE MODE S'ALLUME, ET IL NE PEUT PAS DÉRAPER.
--
-- CE QUE CE LOT REND POSSIBLE, ET CE QU'IL REND IMPOSSIBLE
-- ---------------------------------------------------------------------------
-- Possible : qu'un porteur de clé allume l'IA pour tel de ses enfants, pour
-- telle surface, avec tel plafond d'énergie. Impossible : qu'un appel parte
-- au-delà d'un plafond monétaire.
--
-- Le stop-point de l'étude est explicite : « le lot 4 ne démarre pas avant que
-- le lot 3 coupe RÉELLEMENT — une Forge branchée sur un budget non appliqué est
-- le scénario de facture surprise » (RISK-2). Ce fichier est donc écrit autour
-- d'une seule question : la coupure est-elle atomique ?
--
-- D-8 — LA COUPURE EST DANS LE CHEMIN DE REQUÊTE, PAS DANS UN CRON
-- ---------------------------------------------------------------------------
-- `reserve_ai_spend` vérifie ET réserve dans la MÊME transaction, et R-11 exige
-- que l'énergie et l'argent soient réservés ensemble. Un cron de surveillance
-- découvrirait le dépassement une fois qu'il est payé ; deux transactions
-- séparées laisseraient deux onglets dépenser deux fois le dernier dollar.
-- La ligne du grand livre est verrouillée par `INSERT … ON CONFLICT DO UPDATE`,
-- qui prend un verrou de ligne : deux appels concurrents se sérialisent, et le
-- second voit le total du premier. C'est ce que teste pgTAP S63.
--
-- R-14 — LES MONTANTS NE DESCENDENT PAS CHEZ L'ÉLÈVE
-- ---------------------------------------------------------------------------
-- `ai_spend_ledger` n'est lisible que par son propriétaire. L'élève, lui, lit
-- `ai_student_access` — où il n'y a pas un dollar, seulement de l'énergie, une
-- mécanique de jeu (é11 R-12).
--
-- AGENTS.md : chaque table neuve embarque ses propres GRANT explicites.

-- ---------------------------------------------------------------------------
-- 1. Les kill-switches DONNÉES (D-14 : pas de framework de feature flags).
-- ---------------------------------------------------------------------------
-- L'admin doit pouvoir « couper globalement ou par famille » (§2.1) sans
-- redéploiement. Les kill-switches d'ENVIRONNEMENT (`AI_MODE_ENABLED`,
-- `AI_BYOK_ENABLED`) restent : ceux-ci s'y ajoutent, ils ne les remplacent pas.
CREATE TABLE IF NOT EXISTS public.ai_admin_state (
  -- Singleton : une seule ligne, garantie par le CHECK sur la clé primaire.
  id         BOOLEAN PRIMARY KEY DEFAULT true CHECK (id),
  ai_enabled BOOLEAN NOT NULL DEFAULT true,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
INSERT INTO public.ai_admin_state (id) VALUES (true) ON CONFLICT (id) DO NOTHING;

ALTER TABLE public.ai_admin_state ENABLE ROW LEVEL SECURITY;
-- Lisible par tous les comptes connectés : l'état « le mode est coupé » n'est
-- pas un secret, et l'UI doit pouvoir dégrader sans passer par une RPC.
DROP POLICY IF EXISTS ai_admin_state_read ON public.ai_admin_state;
CREATE POLICY ai_admin_state_read ON public.ai_admin_state
  FOR SELECT TO authenticated USING (true);
REVOKE ALL ON public.ai_admin_state FROM anon, authenticated;
GRANT SELECT ON public.ai_admin_state TO authenticated;
GRANT ALL ON public.ai_admin_state TO service_role;

-- Coupure ciblée d'une famille — l'outil d'incident de RISK-1 et de R-8.
CREATE TABLE IF NOT EXISTS public.ai_owner_suspensions (
  owner_user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  reason        TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);
ALTER TABLE public.ai_owner_suspensions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS ai_owner_suspensions_read ON public.ai_owner_suspensions;
CREATE POLICY ai_owner_suspensions_read ON public.ai_owner_suspensions
  FOR SELECT TO authenticated
  USING (owner_user_id = (SELECT auth.uid()) OR public.is_admin());
REVOKE ALL ON public.ai_owner_suspensions FROM anon, authenticated;
GRANT SELECT ON public.ai_owner_suspensions TO authenticated;
GRANT ALL ON public.ai_owner_suspensions TO service_role;

-- ---------------------------------------------------------------------------
-- 2. ACTIVATION PAR ÉLÈVE — c'est ici que le mode s'allume, pas dans le coffre.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.ai_student_access (
  student_user_id  UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  owner_user_id    UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  -- R-3 : le défaut de TOUTE activation est ÉTEINT. Une clé enregistrée
  -- n'allume rien.
  enabled          BOOLEAN NOT NULL DEFAULT false,
  -- Sous-ensemble fermé de AI_FEATURES. Le porteur choisit surface par surface :
  -- « explication oui, chat non » est un réglage légitime, pas un cas tordu.
  features         TEXT[] NOT NULL DEFAULT '{}',
  -- R-9 : le parent peut BAISSER l'énergie, et la monter jusqu'au plafond dur —
  -- jamais au-delà. Le plafond dur ne se règle pas : ce n'est pas un garde-fou
  -- de coût, c'est un garde-fou pédagogique (é09 anti-farm, é11 R-12).
  daily_energy_max INT NOT NULL DEFAULT 10 CHECK (daily_energy_max BETWEEN 0 AND 30),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
  -- PAS de CHECK (owner <> student) : depuis Q-2 un compte peut porter SA propre
  -- clé et s'auto-activer. La contrainte de la v1 interdisait précisément ce cas.
);

COMMENT ON TABLE public.ai_student_access IS
  'Activation du mode IA, par élève et par surface (étude 29 R-3). Défaut : éteint. Écriture exclusive via set_ai_student_access. Aucun montant ici — l''élève y lit son énergie, pas de l''argent (R-14).';

CREATE INDEX IF NOT EXISTS idx_ai_access_owner ON public.ai_student_access (owner_user_id);

ALTER TABLE public.ai_student_access ENABLE ROW LEVEL SECURITY;

-- L'élève lit SA ligne (il doit savoir que le mode est allumé, é29 US-5) ; le
-- porteur lit celles de ses élèves liés, et la sienne ; l'admin tout.
DROP POLICY IF EXISTS ai_access_select_self ON public.ai_student_access;
CREATE POLICY ai_access_select_self ON public.ai_student_access
  FOR SELECT TO authenticated
  USING (
    student_user_id = (SELECT auth.uid())
    OR owner_user_id = (SELECT auth.uid())
    OR public.is_admin()
  );

-- Aucune policy d'écriture : tout passe par set_ai_student_access.
REVOKE ALL ON public.ai_student_access FROM anon, authenticated;
GRANT SELECT ON public.ai_student_access TO authenticated;
GRANT ALL ON public.ai_student_access TO service_role;

-- ---------------------------------------------------------------------------
-- 3. LES DEUX GRANDS LIVRES — argent et énergie.
-- ---------------------------------------------------------------------------
-- L'argent est compté par PORTEUR (c'est sa facture) ; l'énergie par ÉLÈVE
-- (c'est sa mécanique de jeu). Deux dénominateurs différents, deux tables — les
-- fusionner obligerait à choisir un des deux et à mentir sur l'autre.
CREATE TABLE IF NOT EXISTS public.ai_spend_ledger (
  owner_user_id   UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  day             DATE NOT NULL,
  -- Réservé AVANT l'appel, remplacé par le réel après (§3.7).
  reserved_micros BIGINT NOT NULL DEFAULT 0 CHECK (reserved_micros >= 0),
  spent_micros    BIGINT NOT NULL DEFAULT 0 CHECK (spent_micros >= 0),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (owner_user_id, day)
);

COMMENT ON TABLE public.ai_spend_ledger IS
  'Le compteur qui COUPE avant l''appel (R-11). Réservation puis solde réel, dans la transaction de l''appel (D-8). Rétention 13 mois.';

ALTER TABLE public.ai_spend_ledger ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS ai_ledger_select ON public.ai_spend_ledger;
CREATE POLICY ai_ledger_select ON public.ai_spend_ledger
  FOR SELECT TO authenticated
  USING (owner_user_id = (SELECT auth.uid()) OR public.is_admin());
REVOKE ALL ON public.ai_spend_ledger FROM anon, authenticated;
GRANT SELECT ON public.ai_spend_ledger TO authenticated;
GRANT ALL ON public.ai_spend_ledger TO service_role;

CREATE TABLE IF NOT EXISTS public.ai_energy_ledger (
  student_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  day             DATE NOT NULL,
  spent           INT NOT NULL DEFAULT 0 CHECK (spent >= 0),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (student_user_id, day)
);

COMMENT ON TABLE public.ai_energy_ledger IS
  'Énergie IA consommée par élève et par jour (é11 R-12). Séparé de l''argent : l''élève peut lire ceci, jamais ai_spend_ledger (R-14).';

ALTER TABLE public.ai_energy_ledger ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS ai_energy_select ON public.ai_energy_ledger;
CREATE POLICY ai_energy_select ON public.ai_energy_ledger
  FOR SELECT TO authenticated
  USING (
    student_user_id = (SELECT auth.uid())
    OR public.is_admin()
    OR EXISTS (
      SELECT 1 FROM public.ai_student_access a
       WHERE a.student_user_id = public.ai_energy_ledger.student_user_id
         AND a.owner_user_id = (SELECT auth.uid())
    )
  );
REVOKE ALL ON public.ai_energy_ledger FROM anon, authenticated;
GRANT SELECT ON public.ai_energy_ledger TO authenticated;
GRANT ALL ON public.ai_energy_ledger TO service_role;

-- L'énergie consommée est aussi portée par l'événement, pour que la console du
-- lot 5 puisse dire « où est passée l'énergie », surface par surface. Le grand
-- livre, lui, reste le juge : c'est LUI qui est verrouillé à la réservation.
ALTER TABLE public.ai_usage_events
  ADD COLUMN IF NOT EXISTS energy_cost INT NOT NULL DEFAULT 0 CHECK (energy_cost >= 0);

-- ---------------------------------------------------------------------------
-- 4. ALERTES — une par seuil et par mois, pas une par appel (R-11).
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.ai_budget_alerts (
  owner_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  -- 'pct50' | 'pct80' | 'pct100' pour le mensuel ; 'anomaly' pour la garde
  -- indépendante du plafond (3× la médiane 7 j, plancher 0,50 $).
  kind          TEXT NOT NULL CHECK (kind IN ('pct50', 'pct80', 'pct100', 'anomaly')),
  -- La période de dédoublonnage : le mois pour les seuils, le JOUR pour
  -- l'anomalie — c'est ce qui fait qu'elle prévient « le jour même » et pas une
  -- fois pour toutes.
  period        TEXT NOT NULL,
  notified_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (owner_user_id, kind, period)
);

ALTER TABLE public.ai_budget_alerts ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS ai_budget_alerts_select ON public.ai_budget_alerts;
CREATE POLICY ai_budget_alerts_select ON public.ai_budget_alerts
  FOR SELECT TO authenticated
  USING (owner_user_id = (SELECT auth.uid()) OR public.is_admin());
REVOKE ALL ON public.ai_budget_alerts FROM anon, authenticated;
GRANT SELECT ON public.ai_budget_alerts TO authenticated;
GRANT ALL ON public.ai_budget_alerts TO service_role;

-- ---------------------------------------------------------------------------
-- 5. LA RÉSOLUTION — le point où tout se décide (§3.4).
-- ---------------------------------------------------------------------------
-- Une seule fonction, appelée avant CHAQUE appel IA, quel que soit le payeur.
-- Elle ne rend JAMAIS le secret — seulement l'identité du coffre à ouvrir. Le
-- chargement du chiffré se fait ensuite en Node, en service_role, puis le
-- déchiffrement en mémoire. C'est la couture qui garantit qu'un bug d'un seul
-- côté ne suffit pas (§3.1).
CREATE OR REPLACE FUNCTION public.resolve_ai_access(p_student UUID, p_feature TEXT)
RETURNS TABLE (
  allowed BOOLEAN,
  payer TEXT,
  owner_user_id UUID,
  provider TEXT,
  base_url TEXT,
  model_fast TEXT,
  model_rich TEXT,
  energy_left INT,
  double_solve BOOLEAN,
  reason TEXT
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_access  public.ai_student_access%ROWTYPE;
  v_cred    public.ai_credentials%ROWTYPE;
  v_energy  INT;
BEGIN
  -- 1. Le mode global est-il allumé ? (kill-switch données ; l'env est côté Node)
  IF NOT COALESCE((SELECT s.ai_enabled FROM public.ai_admin_state s WHERE s.id), true) THEN
    RETURN QUERY SELECT false, NULL::TEXT, NULL::UUID, NULL::TEXT, NULL::TEXT,
                        NULL::TEXT, NULL::TEXT, 0, NULL::BOOLEAN, 'AI_MODE_OFF';
    RETURN;
  END IF;

  -- 2. L'élève a-t-il une ligne activée, avec CETTE surface ?
  SELECT * INTO v_access
    FROM public.ai_student_access a
   WHERE a.student_user_id = p_student;

  IF NOT FOUND OR NOT v_access.enabled OR NOT (p_feature = ANY (v_access.features)) THEN
    RETURN QUERY SELECT * FROM public._resolve_ai_platform('AI_MODE_OFF');
    RETURN;
  END IF;

  -- 3. Le lien famille existe-t-il TOUJOURS (R-3) ? Résolu à CHAQUE appel,
  --    jamais mis en cache côté client : un élève délié perd l'accès
  --    immédiatement. L'auto-détention (Q-2) est le cas où il n'y a pas de lien
  --    à vérifier — le porteur et l'élève sont le même compte.
  IF v_access.owner_user_id <> p_student
     AND NOT public.is_parent_of_student(v_access.owner_user_id, p_student) THEN
    RETURN QUERY SELECT * FROM public._resolve_ai_platform('AI_LINK_BROKEN');
    RETURN;
  END IF;

  -- 4. La famille est-elle suspendue par l'admin ? (incident, R-8)
  IF EXISTS (SELECT 1 FROM public.ai_owner_suspensions s
              WHERE s.owner_user_id = v_access.owner_user_id) THEN
    RETURN QUERY SELECT * FROM public._resolve_ai_platform('AI_MODE_OFF');
    RETURN;
  END IF;

  -- 5. Le crédential est-il actif ?
  SELECT * INTO v_cred
    FROM public.ai_credentials c
   WHERE c.owner_user_id = v_access.owner_user_id;

  IF NOT FOUND OR v_cred.status <> 'active' THEN
    RETURN QUERY SELECT * FROM public._resolve_ai_platform('AI_KEY_INVALID');
    RETURN;
  END IF;

  -- 6. Reste-t-il de l'énergie ? (é11 R-12, plafond ai_student_access)
  SELECT GREATEST(
           v_access.daily_energy_max - COALESCE(
             (SELECT e.spent FROM public.ai_energy_ledger e
               WHERE e.student_user_id = p_student AND e.day = CURRENT_DATE), 0),
           0)
    INTO v_energy;

  IF v_energy <= 0 THEN
    RETURN QUERY SELECT false, 'family', v_access.owner_user_id, v_cred.provider,
                        v_cred.base_url, v_cred.model_fast, v_cred.model_rich,
                        0, v_cred.double_solve, 'AI_ENERGY_SPENT';
    RETURN;
  END IF;

  RETURN QUERY SELECT true, 'family', v_access.owner_user_id, v_cred.provider,
                      v_cred.base_url, v_cred.model_fast, v_cred.model_rich,
                      v_energy, v_cred.double_solve, NULL::TEXT;
END;
$$;

COMMENT ON FUNCTION public.resolve_ai_access(UUID, TEXT) IS
  'Résout le droit d''émettre un appel IA pour un élève et une surface (§3.4). Ne rend JAMAIS le secret — seulement l''identité du coffre à ouvrir. Le lien famille est revérifié à chaque appel (R-3).';

-- Le repli PLATEFORME, factorisé : chaque branche de refus du chemin famille y
-- passe, parce que « pas de clé de famille » ne veut pas dire « pas d'IA » — le
-- chemin plateforme de é11 reste allumé (D-2, Q-5).
--
-- ⚠️ Il ne rend PAS `allowed = true` de lui-même : la disponibilité de la clé
-- plateforme et son budget se décident en Node (`ANTHROPIC_API_KEY`,
-- `AI_PLATFORM_DAILY_BUDGET_USD`), qui sont des variables d'environnement. La
-- base rend `payer='platform'` et laisse Node conclure — sans quoi il faudrait
-- copier un secret d'environnement en base pour que le SQL puisse en juger.
CREATE OR REPLACE FUNCTION public._resolve_ai_platform(p_reason TEXT)
RETURNS TABLE (
  allowed BOOLEAN,
  payer TEXT,
  owner_user_id UUID,
  provider TEXT,
  base_url TEXT,
  model_fast TEXT,
  model_rich TEXT,
  energy_left INT,
  double_solve BOOLEAN,
  reason TEXT
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT false, 'platform', NULL::UUID, 'anthropic', NULL::TEXT,
         NULL::TEXT, NULL::TEXT, 0,
         -- Sur le chemin plateforme la double résolution est TOUJOURS complète :
         -- c'est nous qui payons, et c'est notre nom sur le contenu (R-18bis.4).
         true, p_reason;
$$;

REVOKE EXECUTE ON FUNCTION public._resolve_ai_platform(TEXT) FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.resolve_ai_access(UUID, TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.resolve_ai_access(UUID, TEXT) TO authenticated;

-- ---------------------------------------------------------------------------
-- 6. ACTIVATION — R-2 + lien famille + plafond dur (R-9).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.set_ai_student_access(
  p_student UUID,
  p_enabled BOOLEAN,
  p_features TEXT[],
  p_energy_max INT
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  -- Plafond DUR de l'énergie quotidienne. Il double le CHECK de la table à
  -- dessein : le CHECK dit « la donnée est invalide », celui-ci dit « ce geste
  -- est refusé », et c'est le second qui produit un message utile.
  c_hard_cap CONSTANT INT := 30;
  v_owner UUID := auth.uid();
BEGIN
  IF v_owner IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  -- R-3 : le porteur active SES élèves liés, ou LUI-MÊME (auto-détention, Q-2).
  IF v_owner <> p_student AND NOT public.is_parent_of_student(v_owner, p_student) THEN
    RAISE EXCEPTION 'AI_NOT_LINKED';
  END IF;

  -- On n'active que si une clé existe : allumer le mode sans clé produirait une
  -- surface qui échoue au premier clic, ce que R-1 et é11 R-15 interdisent.
  IF p_enabled AND NOT EXISTS (
    SELECT 1 FROM public.ai_credentials c WHERE c.owner_user_id = v_owner
  ) THEN
    RAISE EXCEPTION 'AI_NO_CREDENTIAL';
  END IF;

  -- R-9 : jamais au-delà du plafond dur.
  IF p_energy_max IS NULL OR p_energy_max < 0 OR p_energy_max > c_hard_cap THEN
    RAISE EXCEPTION 'AI_ENERGY_CAP_EXCEEDED';
  END IF;

  INSERT INTO public.ai_student_access AS a
    (student_user_id, owner_user_id, enabled, features, daily_energy_max)
  VALUES
    (p_student, v_owner, COALESCE(p_enabled, false), COALESCE(p_features, '{}'), p_energy_max)
  ON CONFLICT (student_user_id) DO UPDATE SET
    -- Le porteur qui écrit devient le porteur de référence : remplacer une
    -- activation, c'est reprendre l'élève à son compte.
    owner_user_id    = v_owner,
    enabled          = EXCLUDED.enabled,
    features         = EXCLUDED.features,
    daily_energy_max = EXCLUDED.daily_energy_max,
    updated_at       = now()
  -- Un AUTRE porteur ne peut pas écraser l'activation en place sans être, lui
  -- aussi, lié à l'élève — ce que la garde du dessus a déjà vérifié.
  WHERE a.student_user_id = p_student;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.set_ai_student_access(UUID, BOOLEAN, TEXT[], INT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_ai_student_access(UUID, BOOLEAN, TEXT[], INT) TO authenticated;

-- ---------------------------------------------------------------------------
-- 7. LA COUPURE — atomique, dans le chemin de requête (R-11, D-8).
-- ---------------------------------------------------------------------------
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
BEGIN
  SELECT * INTO v_cred FROM public.ai_credentials c WHERE c.owner_user_id = p_owner;
  IF NOT FOUND THEN
    RETURN QUERY SELECT false, 'AI_KEY_INVALID', 0::BIGINT, 0::BIGINT;
    RETURN;
  END IF;

  v_daily_cap   := (v_cred.daily_budget_usd   * 1000000)::BIGINT;
  v_monthly_cap := (v_cred.monthly_budget_usd * 1000000)::BIGINT;

  -- L'UPSERT prend un verrou de LIGNE sur (owner, jour). Deux appels concurrents
  -- se sérialisent ici : le second lit le total que le premier vient d'écrire.
  -- C'est ce qui rend la double dépense impossible, et c'est testé (pgTAP S63).
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
  -- facture. Les deux sont vérifiés — ni l'un ni l'autre ne suffit seul.
  IF v_day_total + p_micros > v_daily_cap OR v_month_total + p_micros > v_monthly_cap THEN
    RETURN QUERY SELECT false, 'AI_BUDGET_REACHED', v_day_total, v_month_total;
    RETURN;
  END IF;

  -- L'énergie est réservée DANS LA MÊME TRANSACTION que l'argent (R-11) :
  -- accorder l'un sans l'autre laisserait un appel partir sur un compteur faux.
  IF p_energy > 0 THEN
    SELECT * INTO v_access FROM public.ai_student_access a WHERE a.student_user_id = p_student;
    IF NOT FOUND THEN
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

    IF v_energy_spent + p_energy > v_access.daily_energy_max THEN
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
  'R-11/D-8 : vérifie les DEUX plafonds et réserve argent + énergie dans une seule transaction, AVANT l''appel. Un refus rend un code stable, jamais une exception — l''UI dégrade en silence (é11 R-15).';

REVOKE EXECUTE ON FUNCTION public.reserve_ai_spend(UUID, UUID, BIGINT, INT) FROM PUBLIC, anon, authenticated;

-- Le solde réel remplace la réservation. Appelé après l'appel, quel qu'en soit
-- le sort : un appel qui a échoué CHEZ le fournisseur a pu être facturé.
CREATE OR REPLACE FUNCTION public.settle_ai_spend(
  p_owner UUID,
  p_reserved_micros BIGINT,
  p_actual_micros BIGINT
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE public.ai_spend_ledger
     SET reserved_micros = GREATEST(reserved_micros - p_reserved_micros, 0),
         spent_micros    = spent_micros + GREATEST(p_actual_micros, 0),
         updated_at      = now()
   WHERE owner_user_id = p_owner AND day = CURRENT_DATE;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.settle_ai_spend(UUID, BIGINT, BIGINT) FROM PUBLIC, anon, authenticated;

-- Libération d'une réservation dont l'appel n'a jamais eu lieu (panne réseau,
-- adresse recalée, abandon). L'énergie est REMBOURSÉE — é11 R-15 : un élève ne
-- paie pas en énergie une panne de fournisseur.
CREATE OR REPLACE FUNCTION public.release_ai_reservation(
  p_owner UUID,
  p_student UUID,
  p_micros BIGINT,
  p_energy INT
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE public.ai_spend_ledger
     SET reserved_micros = GREATEST(reserved_micros - p_micros, 0), updated_at = now()
   WHERE owner_user_id = p_owner AND day = CURRENT_DATE;

  IF p_energy > 0 AND p_student IS NOT NULL THEN
    UPDATE public.ai_energy_ledger
       SET spent = GREATEST(spent - p_energy, 0), updated_at = now()
     WHERE student_user_id = p_student AND day = CURRENT_DATE;
  END IF;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.release_ai_reservation(UUID, UUID, BIGINT, INT)
  FROM PUBLIC, anon, authenticated;

-- Nettoyage des réservations mortes en vol (timeout 5 min, §3.7). Sans lui, un
-- processus tué au mauvais moment gèle une part du plafond jusqu'à minuit.
CREATE OR REPLACE FUNCTION public.sweep_ai_reservations()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE public.ai_spend_ledger
     SET reserved_micros = 0, updated_at = now()
   WHERE reserved_micros > 0
     AND updated_at < now() - INTERVAL '5 minutes';
END;
$$;

REVOKE EXECUTE ON FUNCTION public.sweep_ai_reservations() FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 8. ALERTES — les seuils, ET l'anomalie que les seuils manquent (R-11).
-- ---------------------------------------------------------------------------
-- « Parce que ces plafonds sont larges, les alertes en pourcentage arrivent trop
-- tard — 80 % de 20 $ se déclenche après 16 $ dépensés. » L'anomalie est la
-- garde qui attrape une boucle, un abus ou un bug ; le plafond mensuel, lui,
-- n'attrape que la conséquence.
CREATE OR REPLACE FUNCTION public.ai_budget_alerts_due(p_owner UUID)
RETURNS TABLE (kind TEXT, period TEXT, month_usd NUMERIC, day_usd NUMERIC)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  c_anomaly_factor    CONSTANT NUMERIC := 3;
  c_anomaly_floor_usd CONSTANT NUMERIC := 0.5;
  v_cred     public.ai_credentials%ROWTYPE;
  v_month    NUMERIC;
  v_today    NUMERIC;
  v_median   NUMERIC;
  v_pct      NUMERIC;
  v_month_id TEXT := to_char(CURRENT_DATE, 'YYYY-MM');
  v_day_id   TEXT := to_char(CURRENT_DATE, 'YYYY-MM-DD');
BEGIN
  SELECT * INTO v_cred FROM public.ai_credentials c WHERE c.owner_user_id = p_owner;
  IF NOT FOUND THEN RETURN; END IF;

  SELECT COALESCE(SUM(l.spent_micros), 0) / 1000000.0 INTO v_month
    FROM public.ai_spend_ledger l
   WHERE l.owner_user_id = p_owner
     AND l.day >= date_trunc('month', CURRENT_DATE)::DATE;

  SELECT COALESCE(l.spent_micros, 0) / 1000000.0 INTO v_today
    FROM public.ai_spend_ledger l
   WHERE l.owner_user_id = p_owner AND l.day = CURRENT_DATE;
  v_today := COALESCE(v_today, 0);

  -- (a) Seuils de plafond mensuel — une notification par seuil et par MOIS.
  v_pct := CASE WHEN v_cred.monthly_budget_usd > 0
                THEN 100 * v_month / v_cred.monthly_budget_usd ELSE 0 END;

  RETURN QUERY
  SELECT t.k, v_month_id, v_month, v_today
    FROM (VALUES ('pct100', 100), ('pct80', 80), ('pct50', 50)) AS t(k, threshold)
   WHERE v_pct >= t.threshold
     AND NOT EXISTS (
       SELECT 1 FROM public.ai_budget_alerts a
        WHERE a.owner_user_id = p_owner AND a.kind = t.k AND a.period = v_month_id
     )
   -- Un seul seuil à la fois : franchir 100 % ne doit pas envoyer trois
   -- notifications d'un coup à quelqu'un qui vient d'être coupé.
   ORDER BY t.threshold DESC
   LIMIT 1;

  -- (b) Anomalie — indépendante du plafond, dédoublonnée par JOUR.
  SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY d.usd) INTO v_median
    FROM (
      SELECT COALESCE(l.spent_micros, 0) / 1000000.0 AS usd
        FROM generate_series(CURRENT_DATE - 7, CURRENT_DATE - 1, INTERVAL '1 day') AS g(day)
        LEFT JOIN public.ai_spend_ledger l
          ON l.owner_user_id = p_owner AND l.day = g.day::DATE
    ) d;

  IF v_today >= c_anomaly_floor_usd
     AND v_today > c_anomaly_factor * COALESCE(v_median, 0)
     AND NOT EXISTS (
       SELECT 1 FROM public.ai_budget_alerts a
        WHERE a.owner_user_id = p_owner AND a.kind = 'anomaly' AND a.period = v_day_id
     ) THEN
    RETURN QUERY SELECT 'anomaly'::TEXT, v_day_id, v_month, v_today;
  END IF;
END;
$$;

COMMENT ON FUNCTION public.ai_budget_alerts_due(UUID) IS
  'R-11 : les alertes non encore envoyées. (a) seuils 50/80/100 % du mensuel, une fois par seuil et par mois ; (b) ANOMALIE — une journée au-delà de 3× la médiane des 7 précédentes, plancher 0,50 $, dédoublonnée par jour.';

REVOKE EXECUTE ON FUNCTION public.ai_budget_alerts_due(UUID) FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.mark_ai_budget_alert(p_owner UUID, p_kind TEXT, p_period TEXT)
RETURNS void
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  INSERT INTO public.ai_budget_alerts (owner_user_id, kind, period)
  VALUES (p_owner, p_kind, p_period)
  ON CONFLICT (owner_user_id, kind, period) DO NOTHING;
$$;

REVOKE EXECUTE ON FUNCTION public.mark_ai_budget_alert(UUID, TEXT, TEXT)
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 9. RÉVOCATION — elle éteint maintenant aussi les activations (US-8).
-- ---------------------------------------------------------------------------
-- Le lot 2 ne pouvait pas le faire : `ai_student_access` n'existait pas encore.
-- « Toutes les activations enfants tombent » — et elles tombent en même temps
-- que la clé, dans la même transaction, sinon un élève garderait une seconde un
-- mode allumé sans clé derrière.
CREATE OR REPLACE FUNCTION public.revoke_ai_credential()
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_deleted INT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  DELETE FROM public.ai_student_access WHERE owner_user_id = v_user;

  DELETE FROM public.ai_credentials WHERE owner_user_id = v_user;
  GET DIAGNOSTICS v_deleted = ROW_COUNT;

  -- La dépense historique RESTE : `ai_usage_events` et `ai_spend_ledger` ne sont
  -- pas touchés. Ce sont des agrégats sans secret, et effacer une dépense parce
  -- qu'on a retiré la clé serait réécrire l'histoire d'une facture.
  RETURN v_deleted > 0;
END;
$$;

COMMENT ON FUNCTION public.revoke_ai_credential() IS
  'US-8 : supprime la ligne du coffre ET toutes les activations élèves du porteur, dans la même transaction. La dépense historique reste. Ne révoque PAS la clé chez le fournisseur.';

REVOKE EXECUTE ON FUNCTION public.revoke_ai_credential() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.revoke_ai_credential() TO authenticated;

-- ---------------------------------------------------------------------------
-- 10. LA LISTE DU PORTEUR — ses élèves, et l'état de chacun.
-- ---------------------------------------------------------------------------
-- Aucun montant : cette liste est lue par l'écran d'activation, pas par la
-- console de dépense (lot 5). Mélanger les deux ferait descendre des dollars
-- dans une requête que rien n'oblige à en porter.
CREATE OR REPLACE FUNCTION public.get_ai_students()
RETURNS TABLE (
  student_user_id UUID,
  display_name TEXT,
  is_self BOOLEAN,
  enabled BOOLEAN,
  features TEXT[],
  daily_energy_max INT,
  energy_spent_today INT
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_owner UUID := auth.uid();
BEGIN
  IF v_owner IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  RETURN QUERY
  -- Les élèves liés, PLUS le porteur lui-même (auto-détention, Q-2 : « le
  -- porteur active ses élèves liés, ou lui-même »).
  WITH candidates AS (
    SELECT l.student_user_id AS sid
      FROM public.parent_student_links l
     WHERE l.parent_user_id = v_owner AND l.is_active
    UNION
    SELECT v_owner
  )
  SELECT c.sid,
         p.display_name,
         c.sid = v_owner,
         COALESCE(a.enabled, false),
         COALESCE(a.features, '{}'),
         COALESCE(a.daily_energy_max, 10),
         COALESCE(e.spent, 0)
    FROM candidates c
    LEFT JOIN public.profiles p ON p.id = c.sid
    LEFT JOIN public.ai_student_access a
      ON a.student_user_id = c.sid AND a.owner_user_id = v_owner
    LEFT JOIN public.ai_energy_ledger e
      ON e.student_user_id = c.sid AND e.day = CURRENT_DATE
   ORDER BY (c.sid = v_owner), p.display_name;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.get_ai_students() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_ai_students() TO authenticated;

-- ---------------------------------------------------------------------------
-- 11. Purges (§3.3) et balayage des réservations mortes.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.purge_ai_ledgers()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  DELETE FROM public.ai_spend_ledger  WHERE day < CURRENT_DATE - INTERVAL '13 months';
  DELETE FROM public.ai_energy_ledger WHERE day < CURRENT_DATE - INTERVAL '13 months';
  DELETE FROM public.ai_budget_alerts WHERE notified_at < now() - INTERVAL '13 months';
END;
$$;

REVOKE EXECUTE ON FUNCTION public.purge_ai_ledgers() FROM PUBLIC, anon, authenticated;

DO $$
BEGIN
  CREATE EXTENSION IF NOT EXISTS pg_cron;

  PERFORM cron.unschedule(jobid) FROM cron.job WHERE jobname = 'purge-ai-ledgers';
  PERFORM cron.schedule(
    'purge-ai-ledgers', '40 3 * * *',
    $cron$SELECT public.purge_ai_ledgers();$cron$
  );

  -- Toutes les 10 minutes : une réservation morte gèle une part du plafond d'une
  -- famille, et personne ne saurait pourquoi son mode IA « ne marche plus ».
  PERFORM cron.unschedule(jobid) FROM cron.job WHERE jobname = 'sweep-ai-reservations';
  PERFORM cron.schedule(
    'sweep-ai-reservations', '*/10 * * * *',
    $cron$SELECT public.sweep_ai_reservations();$cron$
  );
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE
    'pg_cron indisponible (%). Les plafonds fonctionnent, mais les réservations mortes ne seront PAS balayées et les grands livres pas purgés. Activer pg_cron puis rejouer les blocs cron.schedule(...).',
    SQLERRM;
END;
$$;
