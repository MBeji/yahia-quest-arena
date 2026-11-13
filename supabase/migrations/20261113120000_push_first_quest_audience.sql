-- Étude 40, lot 2 — LA PREMIÈRE QUÊTE : une septième audience d'élève (R-7, R-8, R-10).
--
-- LE CONSTAT (étude 40, T-3, relevé du 2026-11-12). 36 élèves sur 60 n'avaient jamais
-- joué après avoir créé leur compte. Les six audiences de l'étude 31 exigent TOUTES une
-- activité passée (`current_streak`, `last_active_date`, un duel) : l'élève qui s'inscrit
-- sans jouer n'était dans aucune, push allumé ou non.
--
-- CE QUE CETTE MIGRATION FAIT. Elle ré-émet `push_daily_audiences` depuis sa révision
-- VIVANTE (`20260902160000`, reprise par script, jamais retapée) avec UNE branche de plus,
-- `first-quest` : inscrit la veille ou il y a trois jours (jour de Tunis), sans aucun jour
-- d'activité. Deux soirs exacts, puis plus jamais — tenu par l'ancrage sur deux dates,
-- comme `comeback`, sans colonne d'état.
--
-- CE QU'ELLE NE FAIT PAS. Le pipeline de priorité (`push-audience.ts`) range `first-quest`
-- en AVANT-DERNIER, devant `comeback` (R-7) ; la règle « un push par élève et par jour »
-- (é31 R-4) reste tenue par `resolveDailyPushPlan`, pas ici.
--
-- Migration ADDITIVE : `CREATE OR REPLACE` garde privilèges et `SECURITY DEFINER` ; le
-- REVOKE est rejoué tel quel. Preuves : `supabase/tests/113_push_first_quest.test.sql`.

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
     AND pr.last_active_date = p_today - 7

  UNION ALL

  -- 7) LA PREMIÈRE QUÊTE (étude 40, lot 2 — R-8, R-10). Inscrit HIER ou il y a TROIS
  --    jours, jamais actif. Le constat qui la fonde : 36 élèves sur 60 n'avaient jamais
  --    joué après l'inscription, et aucune des six audiences ci-dessus ne pouvait les
  --    joindre — toutes exigent une activité passée. Deux dates exactes, puis plus
  --    rien : le patron de `comeback`, sans colonne d'état. Le premier jour d'activité
  --    (`last_active_date` renseignée) l'en sort pour toujours.
  SELECT pr.id, 'first-quest'::TEXT, pr.locale, NULL, NULL
    FROM public.profiles pr
   WHERE pr.role = 'student'
     AND pr.last_active_date IS NULL
     AND (pr.created_at AT TIME ZONE 'Africa/Tunis')::date IN (p_today - 1, p_today - 3);
$$;

COMMENT ON FUNCTION public.push_daily_audiences(DATE) IS
  'é31 R-16, é40 lot 2 : les sept audiences d''élève du soir, en CANDIDATS. Le pipeline de priorité (push-audience.ts) n''en garde qu''un par élève — la règle « ≤ 1 push/jour » (R-4) est tenue là, pas ici.';

REVOKE EXECUTE ON FUNCTION public.push_daily_audiences(DATE) FROM PUBLIC, anon, authenticated;
