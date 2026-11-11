-- L'énergie d'un appel IA tué par la plateforme est enfin rendue (é11 R-15).
--
-- LE TROU
-- ---------------------------------------------------------------------------
-- `reserve_ai_spend` et `reserve_platform_spend` décomptent l'énergie de
-- l'élève AVANT l'appel, dans la même transaction que l'argent (R-11). Ensuite,
-- deux issues connues : le succès laisse l'énergie dépensée, la panne la rend
-- (`release_*`). Mais une fonction tuée par la plateforme (`maxDuration`, un
-- conteneur recyclé) n'atteint ni l'une ni l'autre. Pour l'ARGENT, le balayage
-- répare : `reserved_micros` est une colonne à part, remise à zéro après
-- 5 minutes. Pour l'ÉNERGIE, rien : `ai_energy_ledger` n'avait que `spent`, et
-- `sweep_ai_reservations()` ne le visitait pas. L'élève perdait l'unité pour la
-- journée — l'inverse exact de R-15 (dette technique, constaté le 2026-08-26,
-- re-vérifié le 2026-10-26).
--
-- LA RÉPARATION — la même forme que l'argent
-- ---------------------------------------------------------------------------
-- Une colonne `reserved` : l'énergie décomptée par une réservation ET encore en
-- vol. La réservation l'augmente, le succès la solde (`settle_ai_energy`, neuve),
-- la panne connue la libère avec `spent`, et le balayage rend ce qui reste à
-- l'élève. `spent` garde son sens — ce qui est compté contre le plafond —, si
-- bien qu'aucune lecture (`resolve_ai_access`, `get_tutor_energy`, la recharge)
-- ne change.
--
-- L'ORDRE DE DÉPLOIEMENT EST INDIFFÉRENT, et c'est voulu : migration purement
-- additive (une colonne, une fonction, cinq révisions de corps à signature
-- inchangée). Code ancien sur base neuve : le succès ne solde pas `reserved`,
-- le balayage rend l'unité — l'élève y gagne, jamais le contraire. Code neuf sur
-- base ancienne : l'appel à `settle_ai_energy` échoue, journalisé, sans effet.
--
-- Texte des révisions en place (`20260823110000`, `20260822190000` pour
-- `release_ai_reservation`) EXTRAIT ET SUBSTITUÉ PAR SCRIPT : seules les lignes
-- d'énergie changent (leçon #818).

-- ---------------------------------------------------------------------------
-- 1. La colonne.
-- ---------------------------------------------------------------------------
ALTER TABLE public.ai_energy_ledger
  ADD COLUMN IF NOT EXISTS reserved INT NOT NULL DEFAULT 0 CHECK (reserved >= 0);

COMMENT ON COLUMN public.ai_energy_ledger.reserved IS
  'é11 R-15 : part de `spent` réservée par un appel encore en vol. Soldée au succès (settle_ai_energy), rendue à la panne (release_*) ou par sweep_ai_reservations() après 5 minutes.';

-- ---------------------------------------------------------------------------
-- 2. Réserver — l'énergie décomptée est AUSSI marquée « en vol ».
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
       SET spent = spent + p_energy, reserved = reserved + p_energy, updated_at = now()
     WHERE student_user_id = p_student AND day = CURRENT_DATE;
  END IF;

  UPDATE public.ai_spend_ledger
     SET reserved_micros = reserved_micros + p_micros, updated_at = now()
   WHERE owner_user_id = p_owner AND day = CURRENT_DATE;

  RETURN QUERY SELECT true, NULL::TEXT, v_day_total + p_micros, v_month_total + p_micros;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.reserve_ai_spend(UUID, UUID, BIGINT, INT) FROM PUBLIC, anon, authenticated;

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
       SET spent = spent + p_energy, reserved = reserved + p_energy, updated_at = now()
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

REVOKE EXECUTE ON FUNCTION public.reserve_platform_spend(UUID, BIGINT, INT, BIGINT) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 3. Solder au succès — l'énergie reste dépensée, elle n'est plus en vol.
-- ---------------------------------------------------------------------------
-- Une fonction à part plutôt qu'un paramètre de plus à `settle_ai_spend` et
-- `settle_platform_spend` : changer leur signature exigerait un DROP de
-- l'ancienne (destructif, donc une autre fusion), et le solde d'énergie ne
-- dépend pas du payeur.
CREATE OR REPLACE FUNCTION public.settle_ai_energy(
  p_student UUID,
  p_energy INT
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF p_energy > 0 AND p_student IS NOT NULL THEN
    UPDATE public.ai_energy_ledger
       SET reserved = GREATEST(reserved - p_energy, 0), updated_at = now()
     WHERE student_user_id = p_student AND day = CURRENT_DATE;
  END IF;
END;
$$;

COMMENT ON FUNCTION public.settle_ai_energy(UUID, INT) IS
  'é11 R-15 : solde l''énergie d''un appel ABOUTI — elle reste dans `spent`, elle sort de `reserved`, et le balayage ne la rendra pas.';

REVOKE EXECUTE ON FUNCTION public.settle_ai_energy(UUID, INT)
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 4. Libérer (panne connue) — l'énergie rendue n'est plus en vol.
-- ---------------------------------------------------------------------------
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
       SET spent    = GREATEST(spent - p_energy, 0),
           reserved = GREATEST(reserved - p_energy, 0),
           updated_at = now()
     WHERE student_user_id = p_student AND day = CURRENT_DATE;
  END IF;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.release_ai_reservation(UUID, UUID, BIGINT, INT) FROM PUBLIC, anon, authenticated;

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
       SET spent    = GREATEST(spent - p_energy, 0),
           reserved = GREATEST(reserved - p_energy, 0),
           updated_at = now()
     WHERE student_user_id = p_student AND day = CURRENT_DATE;
  END IF;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.release_platform_reservation(UUID, BIGINT, INT) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 5. Balayer (panne INCONNUE) — l'énergie rejoint l'argent.
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

  -- L'énergie d'un appel que la plateforme a tué : ni soldée ni libérée, elle
  -- est RENDUE à l'élève (R-15). Même fenêtre que l'argent — au-delà de
  -- `maxDuration` (300 s), aucun appel légitime n'est encore en vol.
  UPDATE public.ai_energy_ledger
     SET spent      = GREATEST(spent - reserved, 0),
         reserved   = 0,
         updated_at = now()
   WHERE reserved > 0
     AND updated_at < now() - INTERVAL '5 minutes';
END;
$$;

REVOKE EXECUTE ON FUNCTION public.sweep_ai_reservations() FROM PUBLIC, anon, authenticated;
