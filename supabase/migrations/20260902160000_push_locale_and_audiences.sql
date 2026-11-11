-- Étude 31 — lot 4 : LE CANAL DE RETOUR (US-5, R-4, R-16, R-17).
--
-- CE QUI EXISTAIT. Trois payloads, en français pour tout le monde, et une seule
-- audience d'élève : « ta série est en danger », réservée à `current_streak > 0`.
-- Autrement dit : **l'élève qui a PERDU sa série n'est plus jamais recontacté**.
-- Ni relance J+7, ni résultat de ligue (dette assumée é05 US-7), ni jalon. Le
-- déclencheur externe du modèle Hook était vide, et c'est le constat n° 2.
--
-- CE QUE CE LOT POSE
--
-- * **La langue est enfin connue du serveur** (R-17). Elle vivait dans un cookie :
--   un élève qui lit l'application en arabe recevait ses notifications en
--   français. `profiles.locale` la porte, écrite à chaque changement in-app.
-- * **Quatre audiences neuves** (R-16), toutes ANCRÉES SUR UNE DATE EXACTE :
--     `streak-lost`       — série ≥ 3, dernière activité avant-hier ;
--     `league-result`     — lundi, tout participant de la semaine close ;
--     `streak-milestone`  — le soir où la série atteint 7, 30 ou 100 ;
--     `comeback`          — J+7 exact d'inactivité.
--   ⭐ L'ancrage sur un jour EXACT est ce qui tient « une seule fois par période
--   d'absence » (R-16) SANS colonne d'état : `last_active_date = jour - 7` ne peut
--   être vrai qu'un seul soir par absence. Le stop-point du lot demandait de
--   proposer une colonne si la garantie n'était pas atteignable — elle l'est, et
--   une colonne de moins est une divergence de moins.
-- * **Un seul push par élève et par jour, par CONSTRUCTION** (R-4). Cette
--   fonction rend des CANDIDATS ; le pipeline de priorité (`push-audience.ts`)
--   n'en garde qu'un par élève. L'exclusion croisée écrite à la main entre deux
--   audiences (é11 US-7) devient une règle générale — il y en a désormais six,
--   et quinze exclusions deux à deux ne se tiennent pas à la main.
--
-- ⚠️ DEUX HORLOGES, ET C'EST L'EXISTANT. `last_active_date` est écrit par
-- `award_xp` en UTC ; le jour du cron est celui de TUNIS. La comparaison est donc
-- déjà approximative d'une heure dans le code d'aujourd'hui (`isStreakAtRisk`), et
-- ce lot ne change pas cette convention : la corriger demanderait de rejouer la
-- série sur un autre fuseau, ce qui inventerait des séries que le moteur ignore.

-- ===========================================================================
-- 1. `profiles.locale` — la langue du profil (R-17).
-- ===========================================================================
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS locale TEXT NOT NULL DEFAULT 'fr';

DO $$ BEGIN
  ALTER TABLE public.profiles
    ADD CONSTRAINT profiles_locale_check CHECK (locale IN ('fr', 'en', 'ar'));
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

COMMENT ON COLUMN public.profiles.locale IS
  'Langue des notifications (é31 R-17). Écrite à chaque changement de langue in-app ; backfillée « fr » — la valeur d''avant ce lot, où tout partait en français.';

-- Écriture self-scopée : l'élève ne règle que SA langue. Pas de garde de
-- fréquence — changer de langue est un geste d'usage, pas un réglage rare.
CREATE OR REPLACE FUNCTION public.set_profile_locale(p_locale TEXT)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;
  IF p_locale NOT IN ('fr', 'en', 'ar') THEN
    RAISE EXCEPTION 'Invalid locale';
  END IF;
  UPDATE public.profiles SET locale = p_locale WHERE id = auth.uid();
END;
$$;

REVOKE EXECUTE ON FUNCTION public.set_profile_locale(TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_profile_locale(TEXT) TO authenticated;

-- ===========================================================================
-- 2. LES SIX AUDIENCES D'ÉLÈVE, en une seule lecture.
--
--    Une fonction par audience aurait multiplié les allers-retours et, surtout,
--    les définitions de « aujourd'hui ». Ici le jour est un ARGUMENT : celui de
--    Tunis, calculé une fois côté Node, comme le fait déjà
--    `tutor_plan_push_audience`.
--
--    `arg` porte le nombre qu'un texte interpole (révisions dues, jalon de série,
--    pièces de ligue) ; `detail` porte le palier de ligue. Rien d'autre ne sort :
--    ni pseudo, ni e-mail — le dispatcher n'en a pas besoin.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.push_daily_audiences(p_today DATE)
RETURNS TABLE (user_id UUID, tag TEXT, locale TEXT, arg INT, detail TEXT)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  -- 1) Le résultat de ligue — le LUNDI seulement, pour la semaine qui vient de
  --    se clore. Sans cette borne, le même podium serait annoncé sept soirs de
  --    suite. La clôture tourne le lundi à 02:30 ; le cron du soir la trouve.
  SELECT a.user_id, 'league-result'::TEXT, pr.locale, a.coins_awarded, a.tier
    FROM public.duel_league_awards a
    JOIN public.profiles pr ON pr.id = a.user_id
   WHERE pr.role = 'student'
     AND date_trunc('week', p_today)::date = p_today
     AND a.week_start = p_today - 7

  UNION ALL

  -- 2) La série PERDUE. Avant ce lot, c'était le trou : `current_streak > 0`
  --    excluait exactement celui qui venait de tomber. Le seuil de 3 jours évite
  --    de relancer sur une série d'un jour, qui ne représente rien.
  SELECT pr.id, 'streak-lost'::TEXT, pr.locale, pr.current_streak, NULL
    FROM public.profiles pr
   WHERE pr.role = 'student'
     AND pr.current_streak >= 3
     AND pr.last_active_date = p_today - 2

  UNION ALL

  -- 3) La série EN DANGER — l'audience historique, inchangée.
  SELECT pr.id, 'streak-at-risk'::TEXT, pr.locale, pr.current_streak, NULL
    FROM public.profiles pr
   WHERE pr.role = 'student'
     AND pr.current_streak > 0
     AND COALESCE(pr.last_active_date::TEXT, '') < p_today::TEXT

  UNION ALL

  -- 4) Le JALON. Le soir même où la série atteint 7, 30 ou 100 : une félicitation
  --    qui arrive trois jours plus tard ne félicite rien.
  SELECT pr.id, 'streak-milestone'::TEXT, pr.locale, pr.current_streak, NULL
    FROM public.profiles pr
   WHERE pr.role = 'student'
     AND pr.last_active_date = p_today
     AND pr.current_streak IN (7, 30, 100)

  UNION ALL

  -- 5) Le plan du jour — audience existante (é11 US-7), rapatriée ici pour que
  --    le pipeline la voie comme les autres au lieu d'une exclusion à la main.
  SELECT t.user_id, 'tutor-daily-plan'::TEXT, pr.locale, t.due_count, NULL
    FROM public.tutor_plan_push_audience(p_today) t
    JOIN public.profiles pr ON pr.id = t.user_id

  UNION ALL

  -- 6) LE RETOUR AU CALME, à J+7 EXACT. Une seule fois par période d'absence, par
  --    construction : `last_active_date` ne vaut `p_today - 7` qu'un seul soir.
  --    Au-delà, plus rien — R-4 interdit la relance répétée, et un élève parti
  --    depuis trois mois n'a pas besoin d'un rappel de plus.
  SELECT pr.id, 'comeback'::TEXT, pr.locale, NULL, NULL
    FROM public.profiles pr
   WHERE pr.role = 'student'
     AND pr.last_active_date = p_today - 7;
$$;

COMMENT ON FUNCTION public.push_daily_audiences(DATE) IS
  'é31 R-16 : les six audiences d''élève du soir, en CANDIDATS. Le pipeline de priorité (push-audience.ts) n''en garde qu''un par élève — la règle « ≤ 1 push/jour » (R-4) est tenue là, pas ici.';

REVOKE EXECUTE ON FUNCTION public.push_daily_audiences(DATE) FROM PUBLIC, anon, authenticated;

-- ===========================================================================
-- 3. Le badge de ligue (R-14) — décerné par la clôture hebdo elle-même.
--
--    Il vient AVEC le lot 4 parce que la notification de ligue et le badge de
--    ligue naissent du même fait, au même instant. Or/platine/diamant seulement :
--    un podium se fête, une participation se compte.
--    ⚠️ Le badge n'est jamais retiré ni dégradé (R-14) : `award_badge_if_new` ne
--    sait qu'ajouter.
-- ===========================================================================
INSERT INTO public.badges (code, name, description, rarity, icon_name, rule_key, family)
VALUES ('league_podium', 'Podium de Ligue', 'Terminer une semaine de ligue en or, platine ou diamant',
        'epic', 'Trophy', 'league_podium', 'saison')
ON CONFLICT (code) DO UPDATE
  SET description = EXCLUDED.description, family = EXCLUDED.family;

CREATE OR REPLACE FUNCTION public.award_duel_league_week(p_week DATE DEFAULT NULL)
RETURNS INT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_week DATE := COALESCE(p_week, public.app_current_week_start() - 7);
  r RECORD;
  v_tier TEXT;
  v_coins INT;
  v_count INT := 0;
BEGIN
  FOR r IN
    SELECT * FROM public.duel_league_standings(v_week)
  LOOP
    v_tier := public.duel_league_tier(r.rank, r.total);
    v_coins := public.duel_league_tier_coins(v_tier);

    -- Idempotent: a second run for the same week is a no-op (PK conflict).
    INSERT INTO public.duel_league_awards
      (user_id, week_start, tier, rank, points, coins_awarded)
    VALUES (r.user_id, v_week, v_tier, r.rank, r.points, v_coins)
    ON CONFLICT (user_id, week_start) DO NOTHING;

    IF FOUND THEN
      PERFORM public.award_duel_rewards(r.user_id, 0, v_coins);
      -- é31 R-14 — le badge de podium, décerné par la clôture qui possède déjà
      -- le palier. Un balayage séparé serait une seconde source de vérité.
      IF v_tier IN ('gold', 'platinum', 'diamond') THEN
        PERFORM public.award_badge_if_new(r.user_id, 'league_podium', 'League podium: ' || v_tier);
      END IF;
      v_count := v_count + 1;
    END IF;
  END LOOP;
  RETURN v_count;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.award_duel_league_week(DATE) FROM PUBLIC, anon, authenticated;
