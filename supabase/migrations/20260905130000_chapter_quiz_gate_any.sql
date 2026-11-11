-- LE QUIZ D'UN CHAPITRE N'EST PLUS TIRÉ AU HASARD — une définition, quatre lecteurs.
--
-- LE DÉFAUT, TROUVÉ EN INSTRUMENTANT LE SUIVI PARENTAL (2026-09-04)
-- ---------------------------------------------------------------------------
-- Trois fonctions serveur décidaient si le quiz de compréhension d'un chapitre
-- était franchi, et TOUTES TROIS choisissaient « le » quiz par un
-- `LIMIT 1` SANS `ORDER BY` :
--
--   * `student_parcours_progress` (20260816200000) — la carte /parcours de
--     l'élève ET la couverture du suivi parental ;
--   * `student_chapter_gaps` (20260904120000) — ce qui manque à un chapitre ;
--   * `admin_engagement_overview` (20260902130000) — « chapitres complétés par
--     actif », la métrique de garde de é31 R-1.
--
-- Le CLIENT, lui, ne tire rien : `quest.server.ts` marque le chapitre débloqué
-- dès que N'IMPORTE LEQUEL de ses quiz est passé. Rien n'interdit deux quiz dans
-- un chapitre — ni contrainte de base, ni gate de contenu — et le jour où ça
-- arrive, l'élève voit son chapitre ouvert pendant que sa progression, celle de
-- son parent et le KPI de la console en comptent un autre. Sans qu'aucun test ne
-- tombe : `LIMIT 1` sans ordre rend une ligne VALIDE, simplement arbitraire, et
-- qui peut changer d'un plan d'exécution à l'autre.
--
-- ⚠️ ORDONNER LE TIRAGE AURAIT ÉTÉ LE MAUVAIS CORRECTIF. Il rend la réponse
-- stable et la laisse FAUSSE : un élève ayant passé le second quiz resterait
-- bloqué, définitivement et proprement. Le tirage n'est pas mal ordonné, il n'a
-- pas lieu d'être — c'est le client qui a raison.
--
-- CE QUE CE LOT CHANGE, ET DANS QUEL SENS
-- ---------------------------------------------------------------------------
-- La règle devient celle du client : GATÉ si la matière est scolaire et que le
-- chapitre porte au moins un quiz ; FRANCHI si l'élève a réussi AU MOINS UN de
-- ces quiz (≥ 80 % et ≥ 4 s/question — le seuil ne bouge pas d'un point).
--
-- ⚠️ C'est un changement de RÉSULTAT, pas d'affichage, et il ne va que dans un
-- sens : un chapitre peut désormais compter là où il ne comptait pas. Aucun
-- chapitre déjà complété ne peut se dé-compléter — la nouvelle condition est
-- strictement plus faible que l'ancienne (elle accepte tout quiz, l'ancienne un
-- seul). Aucun élève ne perd de progression.
--
-- ⭐ ET SURTOUT : LE PRÉDICAT N'EXISTE PLUS QU'UNE FOIS. Il était écrit quatre
-- fois — trois en SQL, une en TypeScript. C'est la divergence qu'`auth-refusals.ts`
-- a déjà payée deux fois, et celle que le commentaire de `chapter-completion.ts`
-- redoutait à voix haute (« si tu changes une règle ici, change la migration dans
-- le même lot »). Les trois lecteurs SQL appellent désormais la même fonction ;
-- le pgTAP 96 vérifie qu'ils rendent le même verdict sur un décor à DEUX quiz.

-- ---------------------------------------------------------------------------
-- 1. La définition, seule et nommée.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.chapter_quiz_gated(p_chapter UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  -- Une matière hors école n'a pas de théorie à valider (culture générale, IQ,
  -- langues) : ses chapitres ne sont jamais gatés, quiz ou pas.
  SELECT EXISTS (
    SELECT 1
      FROM public.exercises q
      JOIN public.chapters c ON c.id = q.chapter_id
      JOIN public.subjects s ON s.id = c.subject_id
     WHERE q.chapter_id = p_chapter
       AND q.mode = 'quiz'
       AND s.grade_id IS NOT NULL
  );
$fn$;

CREATE OR REPLACE FUNCTION public.chapter_quiz_cleared(p_user UUID, p_chapter UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  -- N'IMPORTE LEQUEL des quiz du chapitre suffit — exactement ce que le hub de
  -- l'élève applique depuis toujours (`quest.server.ts`, `quizPassedByChapter`).
  -- Le seuil est inchangé : 80 % ET au moins 4 s par question, pour qu'une
  -- réussite au hasard en vitesse n'ouvre pas le chapitre.
  SELECT NOT public.chapter_quiz_gated(p_chapter)
      OR EXISTS (
        SELECT 1
          FROM public.attempts a
          JOIN public.exercises q ON q.id = a.exercise_id
         WHERE q.chapter_id = p_chapter
           AND q.mode = 'quiz'
           AND a.user_id = p_user
           AND a.score_pct >= 80
           AND a.duration_seconds >= a.total_count * 4
      );
$fn$;

-- `chapter_quiz_gated` ne lit que du CATALOGUE (public par RLS) ; `cleared` lit
-- les tentatives d'un élève arbitraire et reste donc fermée aux clients.
REVOKE ALL ON FUNCTION public.chapter_quiz_gated(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.chapter_quiz_gated(UUID) TO authenticated;
REVOKE ALL ON FUNCTION public.chapter_quiz_cleared(UUID, UUID) FROM PUBLIC, anon, authenticated;

COMMENT ON FUNCTION public.chapter_quiz_cleared(UUID, UUID) IS
  'La porte du quiz de compréhension, définie UNE fois : non gaté, ou au moins un quiz du chapitre réussi a 80 % et >= 4 s/question. Miroir exact de quizPassedByChapter (quest.server.ts).';

-- ---------------------------------------------------------------------------
-- 2. Les trois lecteurs, réémis PAR SUBSTITUTION depuis leur révision vivante.
--    Corps identiques ligne pour ligne, hors les ancres du gate — c'est la règle
--    que 20260831130000 a posée, et elle vaut ici pour la même raison.
--
--    a) `student_parcours_progress` (depuis 20260816200000)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.student_parcours_progress(
  p_user UUID,
  p_subject_ids TEXT[] DEFAULT NULL
)
RETURNS TABLE (
  subject_id TEXT,
  chapters_total INT,
  chapters_completed INT
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  WITH published AS (
    SELECT c.id AS chapter_id, c.subject_id
      FROM public.chapters c
     WHERE (p_subject_ids IS NULL OR c.subject_id = ANY (p_subject_ids))
       AND EXISTS (
         SELECT 1
           FROM public.exercises e
          WHERE e.chapter_id = c.id
            AND e.source = 'admin'
            AND e.mode IS DISTINCT FROM 'quiz'
       )
  ),
  completed AS (
    SELECT p.chapter_id
      FROM published p
     -- LA SEULE MODIFICATION : le tirage arbitraire d'UN quiz a disparu.
     WHERE public.chapter_quiz_cleared(p_user, p.chapter_id)
     AND NOT EXISTS (
       SELECT 1
         FROM public.exercises e
        WHERE e.chapter_id = p.chapter_id
          AND e.source = 'admin'
          AND e.mode IS DISTINCT FROM 'quiz'
          AND NOT EXISTS (
            SELECT 1
              FROM public.attempts a2
             WHERE a2.user_id = p_user
               AND a2.exercise_id = e.id
               AND a2.variant = 'classic'
               AND a2.score_pct >= 60
          )
     )
  )
  SELECT
    p.subject_id,
    count(*)::int,
    count(c.chapter_id)::int
    FROM published p
    LEFT JOIN completed c ON c.chapter_id = p.chapter_id
   GROUP BY p.subject_id;
$fn$;
-- ---------------------------------------------------------------------------
--    b) `student_chapter_gaps` (depuis 20260904120000)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.student_chapter_gaps(
  p_user UUID,
  p_subject_ids TEXT[] DEFAULT NULL,
  p_per_subject INT DEFAULT 3
)
RETURNS TABLE (
  subject_id TEXT,
  chapter_id UUID,
  title TEXT,
  missions_total INT,
  missions_passed INT,
  quiz_gated BOOLEAN,
  quiz_satisfied BOOLEAN
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  WITH missions AS (
    -- La mission de catalogue, et son état — mêmes prédicats que
    -- `student_parcours_progress`, pas une reformulation.
    SELECT
      c.id AS chapter_id,
      c.subject_id,
      c.title,
      c.display_order,
      e.id AS exercise_id,
      EXISTS (
        SELECT 1
          FROM public.attempts a
         WHERE a.user_id = p_user
           AND a.exercise_id = e.id
           AND a.variant = 'classic'
           AND a.score_pct >= 60
      ) AS passed
      FROM public.chapters c
      JOIN public.exercises e
        ON e.chapter_id = c.id
       AND e.source = 'admin'
       AND e.mode IS DISTINCT FROM 'quiz'
     WHERE (p_subject_ids IS NULL OR c.subject_id = ANY (p_subject_ids))
  ),
  gated AS (
    -- Plus aucun tirage : les deux prédicats sont ceux que TOUT LE MONDE lit.
    SELECT
      c.id AS chapter_id,
      public.chapter_quiz_gated(c.id) AS quiz_gated
      FROM public.chapters c
     WHERE (p_subject_ids IS NULL OR c.subject_id = ANY (p_subject_ids))
  ),
  rolled AS (
    SELECT
      m.subject_id,
      m.chapter_id,
      m.title,
      m.display_order,
      count(*)::INT AS missions_total,
      count(*) FILTER (WHERE m.passed)::INT AS missions_passed,
      g.quiz_gated,
      public.chapter_quiz_cleared(p_user, m.chapter_id) AS quiz_satisfied
      FROM missions m
      JOIN gated g ON g.chapter_id = m.chapter_id
     GROUP BY m.subject_id, m.chapter_id, m.title, m.display_order, g.quiz_gated
  ),
  ranked AS (
    SELECT
      r.*,
      -- « Le plus proche du but » d'abord : c'est ce qui rend la carte
      -- ACTIONNABLE. Un chapitre à qui il ne manque que le quiz vient en tête —
      -- c'est UN geste, et personne ne sait aujourd'hui qu'il est dû.
      row_number() OVER (
        PARTITION BY r.subject_id
        ORDER BY (r.missions_total - r.missions_passed) ASC,
                 r.missions_passed DESC,
                 r.display_order,
                 r.chapter_id
      ) AS rn
      FROM rolled r
     WHERE NOT (r.quiz_satisfied AND r.missions_passed = r.missions_total)
  )
  SELECT
    ranked.subject_id,
    ranked.chapter_id,
    ranked.title,
    ranked.missions_total,
    ranked.missions_passed,
    ranked.quiz_gated,
    ranked.quiz_satisfied
    FROM ranked
   WHERE ranked.rn <= GREATEST(p_per_subject, 0)
   ORDER BY ranked.subject_id, ranked.rn;
$fn$;
-- ---------------------------------------------------------------------------
--    c) `admin_engagement_overview` (depuis 20260902130000)
--
--    ⚠️ Le `LIMIT 1` y cadrait aussi le produit cartésien ; le remplacer par un
--    appel corrélé garde le même cadrage (`touched` borne déjà aux chapitres
--    réellement joués) et sert par idx_attempts_user_exercise. C'est une requête
--    de console admin, pas un chemin chaud.
-- ---------------------------------------------------------------------------
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
  chapters_done AS (
    SELECT g.user_id, COUNT(*)::int AS chapters
    FROM chapter_gate g
    WHERE public.chapter_quiz_cleared(g.user_id, g.chapter_id)
    AND NOT EXISTS (
      SELECT 1 FROM public.exercises e
       WHERE e.chapter_id = g.chapter_id
         AND e.source = 'admin' AND e.mode IS DISTINCT FROM 'quiz'
         AND NOT EXISTS (
           SELECT 1 FROM public.attempts a
            WHERE a.user_id = g.user_id AND a.exercise_id = e.id
              AND a.variant = 'classic' AND a.score_pct >= 60
         )
    )
    GROUP BY g.user_id
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
        ELSE NULL END
    ),
    'notes', jsonb_build_object(
      'generated_at',    now(),
      'week_timezone',   'Africa/Tunis',
      'streak_clock',    'UTC (award_xp)',
      'retention_rule',  'window',
      'activity_rule',   'attempts + learning_pulses hors browse',
      'current_week',    v_week
    )
  ) INTO v_out;

  RETURN v_out;
END;
$$;
-- Les privilèges des trois réémises sont INCHANGÉS : `CREATE OR REPLACE` n'y
-- touche pas, et on ne recopie surtout pas un GRANT depuis le fichier source
-- (le piège que é31 lot 2 a payé sur `award_coins`). On les réaffirme, pour que
-- l'intention soit lisible ici plutôt que deux migrations plus loin.
REVOKE EXECUTE ON FUNCTION public.student_parcours_progress(UUID, TEXT[])
  FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.student_chapter_gaps(UUID, TEXT[], INT)
  FROM PUBLIC, anon, authenticated;
