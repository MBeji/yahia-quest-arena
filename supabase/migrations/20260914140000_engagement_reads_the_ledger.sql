-- =========================================================================
-- ÉTUDE 34 — LOT 3 : la console d'engagement lit le grand livre.
-- -------------------------------------------------------------------------
-- Une seule fonction est ré-émise, `admin_engagement_overview`, et pour deux
-- raisons qui n'en font qu'une :
--
--   1. **KPI-E change de SOURCE, jamais de définition.** « Chapitre maîtrisé »
--      reste « toutes les missions de catalogue réussies + le quiz de
--      compréhension » — l'arbitrage Q-2 du 2026-09-14 a maintenu la barre à
--      l'étoile 4 contre la recommandation, précisément pour que la série reste
--      comparable. Le chiffre se LIT désormais dans `user_chapter_stars` au lieu
--      d'être recalculé sur le catalogue du jour. Conséquence : il ne peut plus
--      BAISSER quand une campagne publie du contenu. Avant, ajouter une mission
--      à un chapitre retirait ce chapitre du compte de tous les élèves qui
--      l'avaient fini — la série mentait, et rien ne permettait de le voir.
--
--   2. **Le ratio nu se lit de travers, et l'étude en donne la preuve.** Sur le
--      corpus, 56 % des missions sont ⭐⭐⭐/⭐⭐⭐⭐ : un parc entier bloqué à
--      ★★★☆ produit « 0,0 chapitre par actif ». Trois mesures l'entourent donc :
--      la DISTRIBUTION des étoiles (et sa médiane, le chiffre de contrôle de
--      Q-2), les SCEAUX par actif, et les ÉTOILES PRÉSERVÉES — le nombre de
--      couples (élève, chapitre) que le grand livre protège d'une régression.
--
-- ⚠️ Le corps ci-dessous est la révision VIVANTE (`20260905130000`) reprise
-- telle quelle par script, avec trois substitutions ciblées — jamais retapée.
-- `CREATE OR REPLACE` ne touche ni aux privilèges ni au `SECURITY DEFINER` ;
-- la garde `is_admin()` reste la seule porte.
--
-- Migration ADDITIVE : aucun DROP, aucun REVOKE, aucune colonne retirée.
-- Preuves : `supabase/tests/103_engagement_etoiles.test.sql`.
-- =========================================================================

CREATE OR REPLACE FUNCTION public.admin_engagement_overview()
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_out          JSONB;
  v_today        DATE := (now() AT TIME ZONE 'Africa/Tunis')::date;
  v_week         DATE := public.app_current_week_start();
  -- La série se lit sur l'horloge d'`award_xp` (UTC), pas sur celle des semaines.
  v_utc_today    DATE := CURRENT_DATE;
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  WITH
  -- --- KPI-A : la CURR maison (é26 KPI-4). -------------------------------
  -- Huit semaines TERMINÉES et MESURABLES : une semaine n'a de CURR que si sa
  -- SUIVANTE est elle-même finie. La semaine en cours et la précédente sont donc
  -- hors série — publier « 0 % » sur une semaine encore ouverte serait un faux
  -- chiffre, pas un chiffre prudent.
  weeks AS (
    SELECT generate_series(v_week - INTERVAL '9 weeks', v_week - INTERVAL '2 weeks',
                           INTERVAL '1 week')::date AS week_start
  ),
  curr AS (
    SELECT
      w.week_start,
      (SELECT COUNT(*) FROM public.eng_activity_weeks a
        WHERE a.week_start = w.week_start)::int AS active,
      (SELECT COUNT(*) FROM public.eng_activity_weeks a
        WHERE a.week_start = w.week_start
          AND EXISTS (
            SELECT 1 FROM public.eng_activity_weeks n
             WHERE n.user_id = a.user_id
               AND n.week_start = w.week_start + 7
          ))::int AS returned
    FROM weeks w
  ),
  -- --- KPI-B : rétention par cohorte d'inscription. ----------------------
  -- DÉFINITION ARRÊTÉE ICI (et affichée sur la page) : D-N = « revenu au moins
  -- une fois entre J+1 et J+N après l'inscription ». C'est la lecture par
  -- FENÊTRE, pas par jour exact. Deux raisons : à ce volume, un « exactement le
  -- 30ᵉ jour » ne mesurerait que du bruit ; et la fenêtre est monotone
  -- (D1 ≤ D7 ≤ D30), donc un calcul cassé se voit à l'œil nu.
  -- Le jour de l'inscription lui-même n'entre pas : sinon tout élève qui joue sa
  -- première quête serait « retenu » à J+1, et la courbe dirait 100 %.
  members AS (
    SELECT
      p.id AS user_id,
      (p.created_at AT TIME ZONE 'Africa/Tunis')::date AS signup_day,
      date_trunc('week', (p.created_at AT TIME ZONE 'Africa/Tunis')::date)::date AS cohort_week
    FROM public.profiles p
    WHERE p.role = 'student'
      AND (p.created_at AT TIME ZONE 'Africa/Tunis')::date >= v_week - INTERVAL '8 weeks'
  ),
  cohort_flags AS (
    SELECT
      m.cohort_week,
      m.user_id,
      -- Mesurable = la fenêtre est ENTIÈREMENT écoulée. Un compte de la semaine
      -- dernière ne peut pas avoir « raté » son J+30 ; le compter comme perdu
      -- écraserait la cohorte à zéro et ferait paniquer sur une donnée absente.
      (m.signup_day + 1  < v_today) AS d1_measurable,
      (m.signup_day + 7  < v_today) AS d7_measurable,
      (m.signup_day + 30 < v_today) AS d30_measurable,
      EXISTS (SELECT 1 FROM public.eng_activity_days d
               WHERE d.user_id = m.user_id
                 AND d.day > m.signup_day AND d.day <= m.signup_day + 1)  AS d1_back,
      EXISTS (SELECT 1 FROM public.eng_activity_days d
               WHERE d.user_id = m.user_id
                 AND d.day > m.signup_day AND d.day <= m.signup_day + 7)  AS d7_back,
      EXISTS (SELECT 1 FROM public.eng_activity_days d
               WHERE d.user_id = m.user_id
                 AND d.day > m.signup_day AND d.day <= m.signup_day + 30) AS d30_back
    FROM members m
  ),
  cohorts AS (
    SELECT
      c.cohort_week,
      COUNT(*)::int AS size,
      COUNT(*) FILTER (WHERE c.d1_measurable)::int  AS d1_base,
      COUNT(*) FILTER (WHERE c.d7_measurable)::int  AS d7_base,
      COUNT(*) FILTER (WHERE c.d30_measurable)::int AS d30_base,
      COUNT(*) FILTER (WHERE c.d1_measurable  AND c.d1_back)::int  AS d1_back,
      COUNT(*) FILTER (WHERE c.d7_measurable  AND c.d7_back)::int  AS d7_back,
      COUNT(*) FILTER (WHERE c.d30_measurable AND c.d30_back)::int AS d30_back
    FROM cohort_flags c
    GROUP BY c.cohort_week
  ),
  -- --- Activité brute : DAU / WAU / MAU + la courbe des 14 derniers jours. --
  daily AS (
    SELECT
      g.day::date AS day,
      (SELECT COUNT(*) FROM public.eng_activity_days d WHERE d.day = g.day::date)::int AS actives
    FROM generate_series(v_today - 13, v_today, INTERVAL '1 day') g(day)
  ),
  -- --- KPI-C : la série, telle qu'elle est VRAIMENT. ---------------------
  -- `profiles.current_streak` n'est réécrit que par `award_xp` : un élève parti
  -- depuis dix jours porte encore « 12 ». Lire la colonne brute publierait donc
  -- des séries de fantômes. La série EFFECTIVE vaut la colonne tant que
  -- `last_active_date` est aujourd'hui ou hier (la journée n'est pas finie),
  -- et zéro sinon. Même règle que la bannière de rachat (lot 3).
  streaks AS (
    SELECT
      CASE
        WHEN p.last_active_date IS NULL THEN 0
        WHEN p.last_active_date >= v_utc_today - 1 THEN p.current_streak
        ELSE 0
      END AS effective_streak,
      EXISTS (
        SELECT 1 FROM public.eng_activity_days d
         WHERE d.user_id = p.id AND d.day > v_today - 7
      ) AS active_7d
    FROM public.profiles p
    WHERE p.role = 'student'
  ),
  -- --- KPI-D : le consentement push, ses deux sens. ----------------------
  push AS (
    SELECT
      (SELECT COUNT(DISTINCT s.user_id) FROM public.push_subscriptions s)::int AS optin_students,
      (SELECT COUNT(*) FROM public.push_subscriptions)::int                    AS subscriptions,
      (SELECT COUNT(DISTINCT e.user_id) FROM public.push_consent_events e
        WHERE e.action = 'optin'  AND e.occurred_at >= now() - INTERVAL '30 days')::int AS optin_30d,
      (SELECT COUNT(DISTINCT e.user_id) FROM public.push_consent_events e
        WHERE e.action = 'optout' AND e.occurred_at >= now() - INTERVAL '30 days')::int AS optout_30d
  ),
  -- --- KPI-E : LA MÉTRIQUE DE GARDE (R-1). -------------------------------
  -- Précision et progression, publiées à côté de l'engagement. Si l'engagement
  -- monte et que ces deux-là baissent, l'étude a échoué — et ça se lit sur le
  -- même écran, pas dans un rapport séparé qu'on ne relit jamais.
  active_30d AS (
    SELECT DISTINCT d.user_id FROM public.eng_activity_days d
     WHERE d.day > v_today - 30
  ),
  accuracy AS (
    SELECT
      AVG(a.score_pct)::numeric(6, 2)                                        AS avg_pct,
      percentile_cont(0.5) WITHIN GROUP (ORDER BY a.score_pct)::numeric(6, 2) AS p50_pct,
      COUNT(*)::int                                                          AS attempts
    FROM public.attempts a
    WHERE a.completed_at >= now() - INTERVAL '30 days'
      AND a.variant = 'classic'
  ),
  -- Chapitre COMPLÉTÉ : la définition canonique de `get_user_parcours_progress`
  -- (é22 R-15/R-16), rejouée en ensemble au lieu d'être rescopée sur un élève.
  -- On part des chapitres RÉELLEMENT touchés : un chapitre publié porte au moins
  -- une mission obligatoire, donc sans tentative il ne peut pas être complété —
  -- cadrage qui évite le produit cartésien élèves × catalogue.
  touched AS (
    SELECT DISTINCT a.user_id, e.chapter_id
    FROM public.attempts a
    JOIN public.exercises e ON e.id = a.exercise_id
    JOIN active_30d ac ON ac.user_id = a.user_id
    WHERE e.chapter_id IS NOT NULL
  ),
  chapter_gate AS (
    SELECT
      t.user_id,
      t.chapter_id
    FROM touched t
    WHERE EXISTS (
      SELECT 1 FROM public.exercises e
       WHERE e.chapter_id = t.chapter_id
         AND e.source = 'admin' AND e.mode IS DISTINCT FROM 'quiz'
    )
  ),
  -- ⭐ ÉTUDE 34 — MÊME DÉFINITION, AUTRE SOURCE : le chapitre maîtrisé se LIT au
  -- grand livre au lieu d'être recalculé. « Maîtrisé » reste « toutes les
  -- missions de catalogue réussies + le quiz » (Q-2 a maintenu la barre), donc
  -- KPI-E garde sa définition ET sa série. Ce qui change est que le chiffre ne
  -- peut plus BAISSER quand une campagne ajoute du contenu : avant, publier une
  -- mission retirait des chapitres à des élèves qui n'avaient rien fait de mal,
  -- et la série mentait sans que personne puisse le voir.
  chapters_done AS (
    SELECT s.user_id, COUNT(*)::int AS chapters
    FROM public.user_chapter_stars s
    JOIN active_30d ac ON ac.user_id = s.user_id
    WHERE s.star = 4
    GROUP BY s.user_id
  ),
  -- La DISTRIBUTION des étoiles sur les chapitres réellement joués par un actif
  -- (R-18). C'est elle qui empêche de lire « 0,3 chapitre par actif » comme
  -- « ils ne font rien » : un parc entier à ★★★☆ produit ce ratio-là.
  stars_dist AS (
    SELECT
      COALESCE((SELECT MAX(s.star) FROM public.user_chapter_stars s
                 WHERE s.user_id = g.user_id AND s.chapter_id = g.chapter_id), 0)::int AS star
    FROM chapter_gate g
    JOIN active_30d ac ON ac.user_id = g.user_id
  ),
  -- Les sceaux détenus par un actif — la reconnaissance de MATIÈRE, pas de chapitre.
  seals_held AS (
    SELECT COUNT(*)::int AS seals
    FROM public.user_subject_seals sl
    JOIN active_30d ac ON ac.user_id = sl.user_id
  ),
  -- ⭐ « ÉTOILES PRÉSERVÉES » : les couples (élève, chapitre) dont le grand livre
  -- est AU-DESSUS du calcul vivant — c'est-à-dire exactement ceux à qui
  -- l'ancienne règle aurait repris quelque chose. La promesse de l'étude en un
  -- chiffre : tant qu'il est nul, aucune campagne n'a encore fait reculer
  -- personne ; dès qu'il monte, il dit combien de régressions ont été évitées.
  --
  -- ⚠️ Non borné aux actifs 30 j, à dessein : un élève parti garde ses étoiles, et
  -- un compteur de promesse qui baisse quand un élève s'éloigne ne mesurerait
  -- plus la promesse. Un appel de `chapter_star_live` par couple, pas par étoile
  -- (l'agrégat précède le filtre) — requête de console admin, pas chemin chaud.
  stars_preserved AS (
    SELECT COUNT(*)::int AS pairs
    FROM (
      SELECT s.user_id, s.chapter_id, MAX(s.star)::int AS star
      FROM public.user_chapter_stars s
      GROUP BY s.user_id, s.chapter_id
    ) g
    WHERE g.star > public.chapter_star_live(g.user_id, g.chapter_id)
  )
  SELECT jsonb_build_object(
    'curr', (
      SELECT COALESCE(jsonb_agg(jsonb_build_object(
        'week_start', c.week_start,
        'active',     c.active,
        'returned',   c.returned,
        'curr_pct',   CASE WHEN c.active > 0
                        THEN ROUND(100.0 * c.returned / c.active, 1)
                        ELSE NULL END
      ) ORDER BY c.week_start), '[]'::jsonb)
      FROM curr c
    ),
    'cohorts', (
      SELECT COALESCE(jsonb_agg(jsonb_build_object(
        'cohort_week', k.cohort_week,
        'size',        k.size,
        'd1_base',     k.d1_base,  'd1_back',  k.d1_back,
        'd7_base',     k.d7_base,  'd7_back',  k.d7_back,
        'd30_base',    k.d30_base, 'd30_back', k.d30_back,
        -- NULL, pas 0, quand la fenêtre n'est pas écoulée : « pas encore
        -- mesurable » et « personne n'est revenu » ne se ressemblent pas.
        'd1_pct',  CASE WHEN k.d1_base  > 0 THEN ROUND(100.0 * k.d1_back  / k.d1_base,  1) END,
        'd7_pct',  CASE WHEN k.d7_base  > 0 THEN ROUND(100.0 * k.d7_back  / k.d7_base,  1) END,
        'd30_pct', CASE WHEN k.d30_base > 0 THEN ROUND(100.0 * k.d30_back / k.d30_base, 1) END
      ) ORDER BY k.cohort_week), '[]'::jsonb)
      FROM cohorts k
    ),
    'activity', jsonb_build_object(
      'dau', (SELECT COUNT(*) FROM public.eng_activity_days d WHERE d.day = v_today),
      'wau', (SELECT COUNT(DISTINCT d.user_id) FROM public.eng_activity_days d
               WHERE d.day > v_today - 7),
      'mau', (SELECT COUNT(*) FROM active_30d),
      'daily', (SELECT COALESCE(jsonb_agg(jsonb_build_object('day', d.day, 'actives', d.actives)
                                          ORDER BY d.day), '[]'::jsonb) FROM daily d)
    ),
    'streaks', jsonb_build_object(
      'students',   (SELECT COUNT(*) FROM streaks),
      'b0',         (SELECT COUNT(*) FROM streaks WHERE effective_streak = 0),
      'b1_6',       (SELECT COUNT(*) FROM streaks WHERE effective_streak BETWEEN 1 AND 6),
      'b7_29',      (SELECT COUNT(*) FROM streaks WHERE effective_streak BETWEEN 7 AND 29),
      'b30_plus',   (SELECT COUNT(*) FROM streaks WHERE effective_streak >= 30),
      -- KPI-C : la part des ACTIFS HEBDO qui tiennent une série de 7 jours ou plus.
      'weekly_active',       (SELECT COUNT(*) FROM streaks WHERE active_7d),
      'weekly_active_7plus', (SELECT COUNT(*) FROM streaks WHERE active_7d AND effective_streak >= 7)
    ),
    'push', (
      SELECT jsonb_build_object(
        'optin_students', p.optin_students,
        'subscriptions',  p.subscriptions,
        'optin_30d',      p.optin_30d,
        'optout_30d',     p.optout_30d,
        'students_total', (SELECT COUNT(*) FROM public.profiles WHERE role = 'student'),
        -- Taux d'opt-out mensuel = coupures / base exposée (abonnés encore là +
        -- ceux qui viennent de partir). Garde-fou R-4 : < 5 %.
        'optout_pct', CASE
          WHEN (p.optin_students + p.optout_30d) > 0
            THEN ROUND(100.0 * p.optout_30d / (p.optin_students + p.optout_30d), 1)
          ELSE NULL END
      ) FROM push p
    ),
    'learning', jsonb_build_object(
      'active_30d',          (SELECT COUNT(*) FROM active_30d),
      'accuracy_avg_pct',    (SELECT avg_pct  FROM accuracy),
      'accuracy_p50_pct',    (SELECT p50_pct  FROM accuracy),
      'attempts_30d',        (SELECT attempts FROM accuracy),
      'chapters_completed',  (SELECT COALESCE(SUM(chapters), 0) FROM chapters_done),
      'chapters_per_active', CASE
        WHEN (SELECT COUNT(*) FROM active_30d) > 0
          THEN ROUND((SELECT COALESCE(SUM(chapters), 0) FROM chapters_done)::numeric
                     / (SELECT COUNT(*) FROM active_30d), 2)
        ELSE NULL END,
      -- Étude 34 R-18 — ce qui entoure le ratio, et sans quoi il se lit de travers.
      'stars_distribution', jsonb_build_object(
        's0', (SELECT COUNT(*) FROM stars_dist WHERE star = 0),
        's1', (SELECT COUNT(*) FROM stars_dist WHERE star = 1),
        's2', (SELECT COUNT(*) FROM stars_dist WHERE star = 2),
        's3', (SELECT COUNT(*) FROM stars_dist WHERE star = 3),
        's4', (SELECT COUNT(*) FROM stars_dist WHERE star = 4)
      ),
      -- Le CHIFFRE DE CONTRÔLE de Q-2 : si la médiane stagne pendant que la
      -- pratique monte, c'est que l'élite est hors de portée du plus grand
      -- nombre, et la hauteur de barre se rouvre par amendement de l'étude.
      -- Continue (`percentile_cont`), pas discrète : une médiane qui ne peut
      -- valoir que 2 ou 3 ne montre aucune tendance entre les deux.
      'stars_median', (
        SELECT ROUND(percentile_cont(0.5) WITHIN GROUP (ORDER BY star)::numeric, 1)
        FROM stars_dist
      ),
      'seals_total', (SELECT seals FROM seals_held),
      'seals_per_active', CASE
        WHEN (SELECT COUNT(*) FROM active_30d) > 0
          THEN ROUND((SELECT seals FROM seals_held)::numeric
                     / (SELECT COUNT(*) FROM active_30d), 2)
        ELSE NULL END,
      'stars_preserved', (SELECT pairs FROM stars_preserved)
    ),
    'notes', jsonb_build_object(
      'generated_at',    now(),
      'week_timezone',   'Africa/Tunis',
      'streak_clock',    'UTC (award_xp)',
      'retention_rule',  'window',
      'activity_rule',   'attempts + learning_pulses hors browse',
      'current_week',    v_week,
      -- R-18 : la note voyage AVEC le chiffre. Une console qui change de source
      -- sans le dire fabrique une rupture de série que personne ne saura dater.
      'chapters_source', '2026-09-14 (étude 34) : chapters_completed garde sa définition (toutes les missions de catalogue + le quiz) et change de SOURCE — il se lit au grand livre user_chapter_stars au lieu d''être recalculé. Série continue ; le chiffre ne peut plus baisser quand du contenu arrive.'
    )
  ) INTO v_out;

  RETURN v_out;
END;
$$;

-- =========================================================================
-- LE WRAPPER ÉLÈVE DE `student_subject_stars`.
-- -------------------------------------------------------------------------
-- La carte `/parcours` et les cartes matières du QG doivent montrer le SCEAU et
-- le prochain palier, pas un pourcentage. L'agrégat existe déjà
-- (`student_subject_stars`, lot 1) mais il est privilégié : il prend un
-- `p_user`, donc il est `REVOKE`d des clients — le donner tel quel laisserait
-- n'importe quel compte lire la progression d'un autre.
--
-- Même patron que `get_user_parcours_progress` pour `student_parcours_progress`
-- (20260816200000) : une enveloppe self-scopée sur `auth.uid()`, sans paramètre
-- d'identité. Une seule définition de la règle, deux portes.
-- =========================================================================
CREATE OR REPLACE FUNCTION public.get_user_subject_stars(
  p_subject_ids TEXT[] DEFAULT NULL
)
RETURNS TABLE (
  subject_id       TEXT,
  chapters_total   INT,
  chapters_started INT,
  chapters_star1   INT,
  chapters_star2   INT,
  chapters_star3   INT,
  chapters_star4   INT,
  seal_star        SMALLINT,
  seal_at          TIMESTAMPTZ,
  new_chapters     INT,
  new_missions     INT
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  SELECT * FROM public.student_subject_stars((SELECT auth.uid()), p_subject_ids);
$fn$;

COMMENT ON FUNCTION public.get_user_subject_stars(TEXT[]) IS
  'Étude 34 : sceaux et distribution des étoiles par matière, pour l''élève connecté. Enveloppe self-scopée de student_subject_stars — même patron que get_user_parcours_progress.';

REVOKE ALL ON FUNCTION public.get_user_subject_stars(TEXT[]) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_user_subject_stars(TEXT[]) TO authenticated;

COMMENT ON FUNCTION public.admin_engagement_overview() IS
  'Console d''engagement (é31 KPI-A…E). Étude 34 : chapters_completed garde sa définition et change de source (grand livre user_chapter_stars, donc monotone) ; s''y ajoutent la distribution et la médiane des étoiles, les sceaux par actif et les étoiles préservées.';

-- =========================================================================
-- L'ENVELOPPE DU SUIVI QUOTIDIEN porte la DISTRIBUTION des étoiles.
-- -------------------------------------------------------------------------
-- Ré-émise depuis sa révision vivante (`20260914130000`) par script, avec deux
-- substitutions — jamais retapée. Elle gagne une clé `subjectStars` ; rien n'est
-- retiré, donc aucun lecteur existant ne bouge.
--
-- Pourquoi ici et pas dans le rapport lui-même : `_student_daily_report_json`
-- fait ~900 lignes et trois études l'ont déjà ré-émise. L'enveloppe est le
-- point d'extension prévu (patron `||`, posé au lot 1 pour `chapterGaps`) —
-- un ajout ne rouvre pas un fichier que personne ne relit en entier.
-- =========================================================================
CREATE OR REPLACE FUNCTION public._daily_report_with_scopes(
  p_student UUID,
  p_from DATE,
  p_to DATE,
  p_scope TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_scope TEXT;
  v_subject_ids TEXT[];
  v_payload JSONB;
  v_scopes JSONB;
  v_applied TEXT;
  v_label TEXT;
  v_gaps JSONB;
  v_stars JSONB;
BEGIN
  -- « class » est un alias du niveau courant. Le résoudre ici plutôt que de le
  -- laisser tel quel évite une clé qui n'existe dans aucune entrée de la liste —
  -- le sélecteur ne saurait ni la surligner ni la nommer.
  v_scope := p_scope;
  IF v_scope = 'class' THEN
    SELECT 'grade:' || pr.current_grade_id::text INTO v_scope
    FROM public.profiles pr
    WHERE pr.id = p_student AND pr.current_grade_id IS NOT NULL;
    v_scope := COALESCE(v_scope, 'all');
  END IF;

  v_subject_ids := public._scope_subject_ids(p_student, v_scope);
  v_scopes := public._student_activity_scopes(p_student);

  -- Ce qui a VRAIMENT été appliqué : un périmètre qui ne filtre rien s'annonce
  -- « all », sinon le sélecteur afficherait une sélection que les chiffres
  -- démentent.
  v_applied := CASE WHEN v_subject_ids IS NULL THEN 'all' ELSE COALESCE(v_scope, 'all') END;

  SELECT s ->> 'label' INTO v_label
  FROM jsonb_array_elements(v_scopes) s
  WHERE s ->> 'key' = v_applied;

  v_payload := public._student_daily_report_json(p_student, p_from, p_to, v_subject_ids);

  v_payload := jsonb_set(v_payload, '{scope,applied}', to_jsonb(v_applied));
  v_payload := jsonb_set(v_payload, '{scope,label}', COALESCE(to_jsonb(v_label), 'null'::jsonb));

  -- Les lacunes suivent le périmètre choisi : montrer sous une matière filtrée
  -- des chapitres d'une autre serait pire que de ne rien montrer.
  SELECT COALESCE(jsonb_agg(
           jsonb_build_object(
             'subjectId', g.subject_id,
             'chapterId', g.chapter_id,
             'title', g.title,
             'missionsTotal', g.missions_total,
             'missionsPassed', g.missions_passed,
             'quizGated', g.quiz_gated,
             'quizSatisfied', g.quiz_satisfied,
             -- Étude 34 : la prochaine étoile, et ce qui l'en sépare.
             'nextStar', g.next_star,
             'missingForNext', g.missing_for_next
           )
         ), '[]'::jsonb)
    INTO v_gaps
    FROM public.student_chapter_gaps(p_student, v_subject_ids, 3) g;

  -- ⭐ ÉTUDE 34 LOT 3 — LA DISTRIBUTION DES ÉTOILES, par matière.
  --
  -- La colonne « Programme » disait « 3/20 » et rien d'autre. Le 2026-09-04,
  -- l'auteur du produit l'a lue « il a fait 3 chapitres sur 20 » alors que les
  -- dix-sept autres étaient largement entamés : le ratio seul efface le travail
  -- à mi-chemin, et c'est ce constat qui a fait naître l'étude. Les bornes
  -- cumulées (`star >= r`) voyagent donc à côté du compte, pour que le parent
  -- voie une barre empilée plutôt qu'une fraction nue.
  --
  -- Même périmètre que les lacunes : montrer sous une matière filtrée la
  -- distribution d'une autre serait pire que de ne rien montrer.
  SELECT COALESCE(jsonb_agg(
           jsonb_build_object(
             'subjectId',       st.subject_id,
             'chaptersTotal',   st.chapters_total,
             'chaptersStarted', st.chapters_started,
             'star1',           st.chapters_star1,
             'star2',           st.chapters_star2,
             'star3',           st.chapters_star3,
             'star4',           st.chapters_star4,
             'sealStar',        COALESCE(st.seal_star, 0),
             'newChapters',     st.new_chapters,
             'newMissions',     st.new_missions
           )
         ), '[]'::jsonb)
    INTO v_stars
    FROM public.student_subject_stars(p_student, v_subject_ids) st;

  RETURN v_payload || jsonb_build_object(
    'scopes', v_scopes, 'chapterGaps', v_gaps, 'subjectStars', v_stars
  );
END;
$fn$;


REVOKE EXECUTE ON FUNCTION public._daily_report_with_scopes(UUID, DATE, DATE, TEXT)
  FROM PUBLIC, anon, authenticated;
