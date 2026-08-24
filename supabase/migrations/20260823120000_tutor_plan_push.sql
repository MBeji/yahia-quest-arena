-- Étude 11 — lot 2 : le rappel du plan du jour, et son opt-in.
--
-- CE QUE CE LOT N'AJOUTE PAS
-- ---------------------------------------------------------------------------
-- Ni moteur de recommandation, ni appel de modèle. Le plan du jour est celui de
-- l'étude 04 A1.1 (`get_daily_plan`), livré et branché depuis le 2026-07-21 ;
-- Q-9 a tranché qu'il n'y aurait pas de second moteur (« `get_tutor_plan_v0`
-- n'est pas écrit »), et le stop-point §4 le rappelle. Ce qui manquait n'était
-- pas la sélection : c'était la VOIX qui la porte, et le rappel qui la sort de
-- l'écran quand l'élève n'y est pas.
--
-- R-10 : la composition vient de SQL, les phrases de la bibliothèque i18n. Zéro
-- token dépensé par jour et par élève — c'est l'étage 0 de §3.7, celui qui rend
-- ~70 % de la personnalisation perçue gratuite.
--
-- POURQUOI UNE RPC PLUTÔT QUE `set_tutor_prefs` ÉLARGIE
-- ---------------------------------------------------------------------------
-- Changer la signature d'une fonction appelée par le client déployé casse la
-- fenêtre de bascule : au merge, Vercel et `db-migrate-prod` courent en
-- parallèle, et pendant quelques minutes du code ancien parle à une base neuve
-- (é29 le dit en toutes lettres à propos de `reserve_ai_spend`). Une RPC neuve à
-- une seule responsabilité ne pose pas la question.

ALTER TABLE public.tutor_prefs
  ADD COLUMN IF NOT EXISTS plan_push BOOLEAN NOT NULL DEFAULT false;

COMMENT ON COLUMN public.tutor_prefs.plan_push IS
  'Étude 11 US-7 : l''élève accepte un rappel push du plan du jour, au plus un par jour. Défaut ÉTEINT — un rappel non demandé est une notification de trop.';

-- ---------------------------------------------------------------------------
-- 1. Lire et écrire la préférence.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_tutor_prefs()
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_row  public.tutor_prefs%ROWTYPE;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;

  SELECT * INTO v_row FROM public.tutor_prefs p WHERE p.user_id = v_user;

  -- L'absence de ligne n'est pas un vide : c'est le réglage par défaut. Le
  -- rendre explicite évite à chaque écran de re-décider ce que « pas de ligne »
  -- veut dire.
  RETURN jsonb_build_object(
    'interests', COALESCE(to_jsonb(v_row.interests), '[]'::jsonb),
    'verbosity', COALESCE(v_row.verbosity, 'normale'),
    'planPush',  COALESCE(v_row.plan_push, false)
  );
END;
$$;

COMMENT ON FUNCTION public.get_tutor_prefs() IS
  'Étude 11 §2.2 : les préférences d''accompagnement de l''élève courant, défauts compris. Aucune PII.';

REVOKE EXECUTE ON FUNCTION public.get_tutor_prefs() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_tutor_prefs() TO authenticated;

CREATE OR REPLACE FUNCTION public.set_tutor_plan_push(p_enabled BOOLEAN)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;

  INSERT INTO public.tutor_prefs (user_id, plan_push, updated_at)
  VALUES (v_user, COALESCE(p_enabled, false), now())
  ON CONFLICT (user_id)
  DO UPDATE SET plan_push = EXCLUDED.plan_push, updated_at = now();
END;
$$;

COMMENT ON FUNCTION public.set_tutor_plan_push(BOOLEAN) IS
  'Étude 11 US-7 : l''élève arme ou désarme son rappel de plan du jour. Une RPC à part de set_tutor_prefs, pour ne pas changer une signature appelée par le client déployé.';

REVOKE EXECUTE ON FUNCTION public.set_tutor_plan_push(BOOLEAN) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_tutor_plan_push(BOOLEAN) TO authenticated;

-- ---------------------------------------------------------------------------
-- 2. L'audience du rappel — trois conditions, toutes en SQL.
-- ---------------------------------------------------------------------------
-- Le JOUR arrive en paramètre plutôt que d'être `CURRENT_DATE` : la journée de
-- l'application est celle de Tunis, et elle est déjà calculée en Node
-- (`appLocalDate`) pour choisir l'audience du rappel de série. Deux définitions
-- de « aujourd'hui » dans le même cron finiraient par diverger un soir d'été.
CREATE OR REPLACE FUNCTION public.tutor_plan_push_audience(p_today DATE)
RETURNS TABLE (user_id UUID, due_count INT)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT p.user_id,
         count(*)::INT AS due_count
    FROM public.tutor_prefs p
    JOIN public.profiles pr ON pr.id = p.user_id
    JOIN public.spaced_repetition_schedule s ON s.user_id = p.user_id
   WHERE p.plan_push
     -- 2. Il a quelque chose à réviser AUJOURD'HUI. Un rappel sans contenu est
     --    la meilleure façon de faire couper les notifications.
     AND s.status = 'pending'
     AND s.scheduled_for <= now()
     -- 3. Il n'est pas déjà venu. Celui qui joue n'a pas besoin qu'on l'appelle,
     --    et c'est aussi ce qui tient la promesse « au plus un par jour » : le
     --    rappel de série vise exactement la même population.
     AND COALESCE(pr.last_active_date::TEXT, '') < p_today::TEXT
   GROUP BY p.user_id;
$$;

COMMENT ON FUNCTION public.tutor_plan_push_audience(DATE) IS
  'Étude 11 US-7 : qui reçoit le rappel du plan du jour — opt-in armé, au moins une révision due, et pas encore venu aujourd''hui (jour de Tunis, calculé en Node).';

REVOKE EXECUTE ON FUNCTION public.tutor_plan_push_audience(DATE) FROM PUBLIC, anon, authenticated;
