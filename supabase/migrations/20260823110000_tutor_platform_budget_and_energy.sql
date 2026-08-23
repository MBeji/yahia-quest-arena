-- Étude 11 — R-12 et R-13 sur le chemin PLATEFORME, et la recharge d'énergie.
--
-- LE TROU QUE CETTE MIGRATION FERME
-- ---------------------------------------------------------------------------
-- L'étude 29 a livré la porte unique et, en toutes lettres, a laissé une moitié
-- ouverte : « Le chemin PLATEFORME (é11, budget A5). Volontairement minimal
-- ici : le lot 1 de é11 le complétera avec son propre plafond journalier. » Le
-- lot 1 ne l'a pas fait, et le résultat est mesurable dans le code d'aujourd'hui :
-- `resolve_ai_access` renvoie `payer = 'platform'` pour TOUT élève sans clé de
-- famille, et `callOnPlatform()` appelle le fournisseur sans réserver ni argent
-- ni énergie. `platformDailyBudgetUsd()` existe, lit sa variable, et n'a aucun
-- appelant.
--
-- Autrement dit : le jour où `ANTHROPIC_API_KEY` est posée en production, chaque
-- élève de la plateforme a un tuteur illimité à nos frais. R-13 exige l'inverse
-- — « un dépassement doit être impossible, pas signalé » — et Q-3 a chiffré ce
-- que ça veut dire : 5 $/jour, soit ≤ 150 $/mois quelle que soit l'adoption.
--
-- POURQUOI UN GRAND LIVRE SÉPARÉ PLUTÔT QUE `ai_spend_ledger`
-- ---------------------------------------------------------------------------
-- `ai_spend_ledger` a pour clé le PORTEUR de la clé. Sur le chemin plateforme il
-- n'y a pas de porteur : la clé est une variable d'environnement, pas une ligne
-- de `ai_credentials`. Y loger la dépense plateforme demanderait un porteur
-- fictif — un utilisateur qui n'existe pas, dont la ligne casserait la clé
-- étrangère et la lecture par le parent. Une table à une seule dimension (le
-- jour) dit la même chose sans mentir sur le dénominateur.
--
-- ET POURQUOI LA COUPURE EST INCONDITIONNELLE ICI
-- ---------------------------------------------------------------------------
-- Côté famille, `limits_enforced` vaut `false` par défaut depuis le 2026-08-22 :
-- on compte et on alerte, on ne coupe pas — c'est la facture d'un parent, et
-- c'est lui qui décide d'armer le frein. Côté plateforme, c'est NOTRE facture,
-- et R-13 ne laisse pas le choix : la vérification est atomique, dans le chemin
-- de requête, avant l'appel. Deux payeurs, deux postures, la même porte.

-- ---------------------------------------------------------------------------
-- 1. Les deux constantes d'énergie, en miroir documenté du code.
-- ---------------------------------------------------------------------------
-- Même posture que la gamification (AGENTS.md) : les seuils vivent dans
-- `src/shared/constants/ai.ts`, et la base en garde un miroir IMMUTABLE quand
-- elle doit décider seule. Les changer demande une migration, donc une revue.
CREATE OR REPLACE FUNCTION public.tutor_daily_energy()
RETURNS INT
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT 10;
$$;

COMMENT ON FUNCTION public.tutor_daily_energy() IS
  'Étude 11 R-12 / Q-2 : énergie tuteur quotidienne d''un élève SANS ligne ai_student_access (chemin plateforme). Miroir de TUTOR_DAILY_ENERGY.';

CREATE OR REPLACE FUNCTION public.tutor_hard_daily_cap()
RETURNS INT
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT 30;
$$;

COMMENT ON FUNCTION public.tutor_hard_daily_cap() IS
  'Étude 11 R-12 / Q-2 : plafond DUR d''énergie par jour, recharges comprises. Garde-fou pédagogique (é09 anti-farm), pas garde-fou de coût. Miroir de TUTOR_HARD_DAILY_CAP.';

REVOKE EXECUTE ON FUNCTION public.tutor_daily_energy() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.tutor_hard_daily_cap() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.tutor_daily_energy() TO authenticated;
GRANT EXECUTE ON FUNCTION public.tutor_hard_daily_cap() TO authenticated;

-- ---------------------------------------------------------------------------
-- 2. La recharge — `ai_energy_ledger` gagne son bonus (R-12, D-9).
-- ---------------------------------------------------------------------------
-- « Consommer un item `hints` de l'inventaire = +3 énergie. » L'économie
-- existante des indices finance l'usage intensif, en pièces gagnées en jouant :
-- aucune monnaie neuve, aucun argent réel, et le wording de la phase gratuite
-- reste tenable (D-14).
ALTER TABLE public.ai_energy_ledger
  ADD COLUMN IF NOT EXISTS bonus INT NOT NULL DEFAULT 0 CHECK (bonus >= 0);

COMMENT ON COLUMN public.ai_energy_ledger.bonus IS
  'Étude 11 R-12 : énergie regagnée aujourd''hui en consommant des indices (+3 par charge). Relève le plafond du JOUR, jamais au-delà de tutor_hard_daily_cap().';

-- ---------------------------------------------------------------------------
-- 3. Le grand livre PLATEFORME.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.ai_platform_ledger (
  day             DATE PRIMARY KEY,
  reserved_micros BIGINT NOT NULL DEFAULT 0 CHECK (reserved_micros >= 0),
  spent_micros    BIGINT NOT NULL DEFAULT 0 CHECK (spent_micros >= 0),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.ai_platform_ledger IS
  'Étude 11 R-13 : la dépense IA du jour payée par la PLATEFORME. Une ligne par jour — il n''y a pas de porteur de clé sur ce chemin. La coupure y est inconditionnelle (Q-3 : 5 $/jour).';

ALTER TABLE public.ai_platform_ledger ENABLE ROW LEVEL SECURITY;

-- Aucun élève n'a à lire notre facture. L'admin, si — c'est la console de é29
-- lot 5 qui la rendra (lot 7 de la présente étude).
DROP POLICY IF EXISTS ai_platform_ledger_select ON public.ai_platform_ledger;
CREATE POLICY ai_platform_ledger_select ON public.ai_platform_ledger
  FOR SELECT TO authenticated
  USING (public.is_admin());

REVOKE ALL ON public.ai_platform_ledger FROM anon, authenticated;
GRANT SELECT ON public.ai_platform_ledger TO authenticated;
GRANT ALL ON public.ai_platform_ledger TO service_role;

-- ---------------------------------------------------------------------------
-- 4. Réserver — argent ET énergie, atomiquement, AVANT l'appel (R-13/D-8).
-- ---------------------------------------------------------------------------
-- Le budget arrive en PARAMÈTRE et non d'une table : c'est une variable
-- d'environnement (`AI_PLATFORM_DAILY_BUDGET_USD`), et la copier en base
-- obligerait à la tenir à jour à deux endroits. La base garde ce qu'elle sait
-- faire seule — sérialiser deux appels concurrents sur la même ligne du jour.
CREATE OR REPLACE FUNCTION public.reserve_platform_spend(
  p_student UUID,
  p_micros BIGINT,
  p_energy INT,
  p_budget_micros BIGINT
)
RETURNS TABLE (granted BOOLEAN, reason TEXT, day_micros BIGINT, energy_left INT)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_day_total    BIGINT;
  v_spent        INT;
  v_bonus        INT;
  v_max          INT;
BEGIN
  -- L'UPSERT prend un verrou de LIGNE sur le jour. Deux appels concurrents se
  -- sérialisent ici : le second lit le total que le premier vient d'écrire.
  INSERT INTO public.ai_platform_ledger (day)
  VALUES (CURRENT_DATE)
  ON CONFLICT (day) DO UPDATE SET updated_at = now();

  SELECT l.reserved_micros + l.spent_micros INTO v_day_total
    FROM public.ai_platform_ledger l
   WHERE l.day = CURRENT_DATE
     FOR UPDATE;

  IF v_day_total + p_micros > GREATEST(p_budget_micros, 0) THEN
    RETURN QUERY SELECT false, 'AI_BUDGET_REACHED', v_day_total, 0;
    RETURN;
  END IF;

  -- L'énergie de l'élève. Sur ce chemin il n'a pas de ligne d'activation : son
  -- plafond est celui de l'étude (10), relevé par ses recharges, borné par le
  -- plafond dur (30).
  IF p_energy > 0 THEN
    INSERT INTO public.ai_energy_ledger (student_user_id, day, spent)
    VALUES (p_student, CURRENT_DATE, 0)
    ON CONFLICT (student_user_id, day) DO UPDATE SET updated_at = now();

    SELECT e.spent, e.bonus INTO v_spent, v_bonus
      FROM public.ai_energy_ledger e
     WHERE e.student_user_id = p_student AND e.day = CURRENT_DATE
       FOR UPDATE;

    v_max := LEAST(public.tutor_daily_energy() + COALESCE(v_bonus, 0),
                   public.tutor_hard_daily_cap());

    IF COALESCE(v_spent, 0) + p_energy > v_max THEN
      RETURN QUERY SELECT false, 'AI_ENERGY_SPENT', v_day_total,
                          GREATEST(v_max - COALESCE(v_spent, 0), 0);
      RETURN;
    END IF;

    UPDATE public.ai_energy_ledger
       SET spent = spent + p_energy, updated_at = now()
     WHERE student_user_id = p_student AND day = CURRENT_DATE;

    v_spent := COALESCE(v_spent, 0) + p_energy;
  ELSE
    SELECT e.spent, e.bonus INTO v_spent, v_bonus
      FROM public.ai_energy_ledger e
     WHERE e.student_user_id = p_student AND e.day = CURRENT_DATE;
    v_max := LEAST(public.tutor_daily_energy() + COALESCE(v_bonus, 0),
                   public.tutor_hard_daily_cap());
  END IF;

  UPDATE public.ai_platform_ledger
     SET reserved_micros = reserved_micros + p_micros, updated_at = now()
   WHERE day = CURRENT_DATE;

  RETURN QUERY SELECT true, NULL::TEXT, v_day_total + p_micros,
                      GREATEST(v_max - COALESCE(v_spent, 0), 0);
END;
$$;

COMMENT ON FUNCTION public.reserve_platform_spend(UUID, BIGINT, INT, BIGINT) IS
  'Étude 11 R-13 : réserve argent plateforme + énergie élève dans une seule transaction, avant l''appel. La coupure est INCONDITIONNELLE — c''est notre facture, et un dépassement doit être impossible.';

REVOKE EXECUTE ON FUNCTION public.reserve_platform_spend(UUID, BIGINT, INT, BIGINT)
  FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.settle_platform_spend(
  p_reserved_micros BIGINT,
  p_actual_micros BIGINT
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE public.ai_platform_ledger
     SET reserved_micros = GREATEST(reserved_micros - p_reserved_micros, 0),
         spent_micros    = spent_micros + GREATEST(p_actual_micros, 0),
         updated_at      = now()
   WHERE day = CURRENT_DATE;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.settle_platform_spend(BIGINT, BIGINT)
  FROM PUBLIC, anon, authenticated;

-- R-15 : un élève ne paie pas en énergie la panne d'un fournisseur.
CREATE OR REPLACE FUNCTION public.release_platform_reservation(
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
  UPDATE public.ai_platform_ledger
     SET reserved_micros = GREATEST(reserved_micros - p_micros, 0), updated_at = now()
   WHERE day = CURRENT_DATE;

  IF p_energy > 0 AND p_student IS NOT NULL THEN
    UPDATE public.ai_energy_ledger
       SET spent = GREATEST(spent - p_energy, 0), updated_at = now()
     WHERE student_user_id = p_student AND day = CURRENT_DATE;
  END IF;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.release_platform_reservation(UUID, BIGINT, INT)
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 5. La recharge par indice — R-12, avec l'invariant anti-gaspillage.
-- ---------------------------------------------------------------------------
-- Copie fidèle de la mécanique de `consume_hint` (20260606140000) : on choisit
-- la charge la plus ancienne, on verrouille SA ligne d'inventaire, on décrémente,
-- on supprime à zéro. Et surtout, on ne consomme RIEN quand la recharge
-- n'apporterait rien — un élève déjà au plafond dur ne perd pas son indice.
CREATE OR REPLACE FUNCTION public.recharge_tutor_energy()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user      UUID := auth.uid();
  v_inv_id    UUID;
  v_item_name TEXT;
  v_spent     INT;
  v_bonus     INT;
  v_base      INT;
  v_cap       INT;
  v_gain      CONSTANT INT := 3;   -- TUTOR_ENERGY_PER_HINT
BEGIN
  IF v_user IS NULL THEN RAISE EXCEPTION 'Not authenticated.'; END IF;

  -- Le plafond de BASE est celui du porteur quand l'élève en a un, celui de
  -- l'étude sinon. Une seule notion d'énergie, deux origines de plafond.
  SELECT COALESCE(
           (SELECT a.daily_energy_max FROM public.ai_student_access a
             WHERE a.student_user_id = v_user),
           public.tutor_daily_energy())
    INTO v_base;

  INSERT INTO public.ai_energy_ledger (student_user_id, day, spent)
  VALUES (v_user, CURRENT_DATE, 0)
  ON CONFLICT (student_user_id, day) DO UPDATE SET updated_at = now();

  SELECT e.spent, e.bonus INTO v_spent, v_bonus
    FROM public.ai_energy_ledger e
   WHERE e.student_user_id = v_user AND e.day = CURRENT_DATE
     FOR UPDATE;

  v_cap := public.tutor_hard_daily_cap();

  -- Déjà au plafond dur : la charge ne servirait à rien, on ne la prend pas.
  IF v_base + COALESCE(v_bonus, 0) >= v_cap THEN
    RETURN jsonb_build_object(
      'consumed', false, 'reason', 'AT_CAP',
      'used', COALESCE(v_spent, 0),
      'max', LEAST(v_base + COALESCE(v_bonus, 0), v_cap),
      'left', GREATEST(LEAST(v_base + COALESCE(v_bonus, 0), v_cap) - COALESCE(v_spent, 0), 0)
    );
  END IF;

  SELECT inv.id, si.name
    INTO v_inv_id, v_item_name
    FROM public.inventory_items inv
    JOIN public.shop_items si ON si.id = inv.shop_item_id
   WHERE inv.student_user_id = v_user
     AND inv.quantity >= 1
     AND si.item_type IN ('booster', 'potion')
     AND (si.effect_payload ? 'hints' OR si.effect_payload ? 'hintBoost')
   ORDER BY inv.acquired_at ASC
   LIMIT 1
   FOR UPDATE OF inv;

  IF NOT FOUND THEN
    RETURN jsonb_build_object(
      'consumed', false, 'reason', 'NO_ITEM',
      'used', COALESCE(v_spent, 0),
      'max', LEAST(v_base + COALESCE(v_bonus, 0), v_cap),
      'left', GREATEST(LEAST(v_base + COALESCE(v_bonus, 0), v_cap) - COALESCE(v_spent, 0), 0)
    );
  END IF;

  UPDATE public.inventory_items SET quantity = quantity - 1 WHERE id = v_inv_id;
  DELETE FROM public.inventory_items WHERE id = v_inv_id AND quantity <= 0;

  -- Le bonus ne dépasse jamais ce qui reste sous le plafond dur : une charge
  -- prise au-delà serait de l'énergie qu'aucun appel ne pourrait dépenser.
  UPDATE public.ai_energy_ledger
     SET bonus = LEAST(bonus + v_gain, GREATEST(v_cap - v_base, 0)), updated_at = now()
   WHERE student_user_id = v_user AND day = CURRENT_DATE
  RETURNING bonus INTO v_bonus;

  RETURN jsonb_build_object(
    'consumed', true, 'reason', 'OK', 'itemName', v_item_name,
    'used', COALESCE(v_spent, 0),
    'max', LEAST(v_base + v_bonus, v_cap),
    'left', GREATEST(LEAST(v_base + v_bonus, v_cap) - COALESCE(v_spent, 0), 0)
  );
END;
$$;

COMMENT ON FUNCTION public.recharge_tutor_energy() IS
  'Étude 11 R-12 / D-9 : consomme une charge d''indice de l''inventaire pour +3 énergie tuteur. Ne consomme rien si l''élève est déjà au plafond dur ou n''a pas de charge (invariant anti-gaspillage de consume_hint).';

REVOKE EXECUTE ON FUNCTION public.recharge_tutor_energy() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.recharge_tutor_energy() TO authenticated;

-- L'état d'énergie, pour l'écran (lot 7). Lecture seule, propriétaire seul.
CREATE OR REPLACE FUNCTION public.get_tutor_energy()
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user  UUID := auth.uid();
  v_spent INT;
  v_bonus INT;
  v_base  INT;
  v_max   INT;
BEGIN
  IF v_user IS NULL THEN RAISE EXCEPTION 'Not authenticated.'; END IF;

  SELECT COALESCE(
           (SELECT a.daily_energy_max FROM public.ai_student_access a
             WHERE a.student_user_id = v_user),
           public.tutor_daily_energy())
    INTO v_base;

  SELECT e.spent, e.bonus INTO v_spent, v_bonus
    FROM public.ai_energy_ledger e
   WHERE e.student_user_id = v_user AND e.day = CURRENT_DATE;

  v_max := LEAST(v_base + COALESCE(v_bonus, 0), public.tutor_hard_daily_cap());

  RETURN jsonb_build_object(
    'used', COALESCE(v_spent, 0),
    'bonus', COALESCE(v_bonus, 0),
    'max', v_max,
    'left', GREATEST(v_max - COALESCE(v_spent, 0), 0),
    'canRecharge', v_base + COALESCE(v_bonus, 0) < public.tutor_hard_daily_cap()
  );
END;
$$;

COMMENT ON FUNCTION public.get_tutor_energy() IS
  'Étude 11 R-12 : l''énergie tuteur du jour de l''élève courant — consommée, bonus, plafond, restante. Lecture seule.';

REVOKE EXECUTE ON FUNCTION public.get_tutor_energy() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_tutor_energy() TO authenticated;

-- ---------------------------------------------------------------------------
-- 6. Les deux révisions vivantes — le bonus entre dans le chemin FAMILLE.
-- ---------------------------------------------------------------------------
-- Texte des révisions en place (`20260822190000` pour la première,
-- `20260822220000` pour la seconde), SUBSTITUÉ par script et diffé : seules les
-- lignes d'énergie changent. Retaper une fonction de quatre-vingts lignes
-- réinvente son algorithme sans le dire (leçon #818).
--
-- Sans elles, la recharge par indice n'aurait d'effet que sur le chemin
-- plateforme : un enfant dont les parents ont branché leur clé paierait un
-- indice pour rien.

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
  v_spent   INT;
  v_bonus   INT;
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
  -- é11 R-12 : le plafond du jour = celui du porteur + les recharges gagnées
  -- en consommant un indice, sans jamais dépasser le plafond DUR pédagogique.
  SELECT e.spent, e.bonus INTO v_spent, v_bonus
    FROM public.ai_energy_ledger e
   WHERE e.student_user_id = p_student AND e.day = CURRENT_DATE;

  SELECT GREATEST(
           LEAST(v_access.daily_energy_max + COALESCE(v_bonus, 0),
                 public.tutor_hard_daily_cap())
           - COALESCE(v_spent, 0),
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

REVOKE EXECUTE ON FUNCTION public.resolve_ai_access(UUID, TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.resolve_ai_access(UUID, TEXT) TO authenticated;

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
  v_energy_bonus INT;
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

    SELECT e.spent, e.bonus INTO v_energy_spent, v_energy_bonus
      FROM public.ai_energy_ledger e
     WHERE e.student_user_id = p_student AND e.day = CURRENT_DATE
       FOR UPDATE;

    -- é11 R-12 : la recharge par indice relève le plafond du JOUR, jamais
    -- au-delà du plafond dur — c'est un garde-fou pédagogique, pas de coût.
    IF v_enforce AND v_energy_spent + p_energy >
       LEAST(v_access.daily_energy_max + COALESCE(v_energy_bonus, 0),
             public.tutor_hard_daily_cap()) THEN
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

REVOKE EXECUTE ON FUNCTION public.reserve_ai_spend(UUID, UUID, BIGINT, INT) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 7. Balayage et purge — le grand livre plateforme rejoint les autres.
-- ---------------------------------------------------------------------------
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

  -- Une réservation plateforme morte gèle une part de NOTRE plafond du jour, et
  -- ferait taire le tuteur pour tout le monde jusqu'à minuit.
  UPDATE public.ai_platform_ledger
     SET reserved_micros = 0, updated_at = now()
   WHERE reserved_micros > 0
     AND updated_at < now() - INTERVAL '5 minutes';
END;
$$;

REVOKE EXECUTE ON FUNCTION public.sweep_ai_reservations() FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.purge_ai_ledgers()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  DELETE FROM public.ai_spend_ledger    WHERE day < CURRENT_DATE - INTERVAL '13 months';
  DELETE FROM public.ai_energy_ledger   WHERE day < CURRENT_DATE - INTERVAL '13 months';
  DELETE FROM public.ai_platform_ledger WHERE day < CURRENT_DATE - INTERVAL '13 months';
  DELETE FROM public.ai_budget_alerts   WHERE notified_at < now() - INTERVAL '13 months';
END;
$$;

REVOKE EXECUTE ON FUNCTION public.purge_ai_ledgers() FROM PUBLIC, anon, authenticated;
