-- Suivi parental — la couverture du programme du BILAN était recalculée une
-- fois par TENTATIVE de l'élève.
--
-- CE QU'ON A MESURÉ, ET POURQUOI ÇA COMPTE
-- ---------------------------------------------------------------------------
-- `_student_report_json` (20260816200000) calcule la colonne « couverture du
-- programme » par un LEFT JOIN LATERAL qui appelle
-- `student_parcours_progress(p_student, ARRAY[sub.id])`. On soupçonnait qu'il
-- soit évalué pour les ~114 matières du catalogue. EXPLAIN (ANALYZE, BUFFERS)
-- sur la prod, le 2026-08-18, dit pire : `loops=157` — le nombre de TENTATIVES
-- de l'élève. Le planificateur attaque par `idx_attempts_subject`, et évalue le
-- LATERAL une fois par ligne, avant l'agrégation qui n'en rendra que 10.
--
--   avant : 50 485 buffers au total, dont 50 411 (99,85 %) dans la fonction ;
--           66,7 ms d'exécution.
--   après :  7 504 buffers, dont 7 468 dans la CTE ; 27,9 ms. Un seul appel.
--
-- Les chiffres rendus sont IDENTIQUES : contrôle EXCEPT ALL dans les deux sens
-- sur les données de prod, 0 ligne d'écart.
--
-- POURQUOI LE PLANIFICATEUR NE S'EN SORTAIT PAS SEUL
-- ---------------------------------------------------------------------------
-- `student_parcours_progress` est SECURITY DEFINER *et* porte un
-- `SET search_path`. Chacune de ces deux propriétés suffit à faire refuser
-- l'inlining d'une fonction SQL à retour ensembliste
-- (`inline_set_returning_function`, prosecdef / proconfig). Elle reste donc une
-- boîte noire, estimée d'office à 1 000 lignes pour un coût de 0,25 : assez bas
-- pour ne pas décourager l'appel, et assez haut pour lui refuser le `Memoize`
-- qui l'aurait ramenée de 157 appels à 10 — le planificateur en a posé un sur
-- `subjects` et sur `grades`, jamais sur elle.
--
-- CE QUI N'EST PAS TOUCHÉ, ET POURQUOI
-- ---------------------------------------------------------------------------
-- 1. `student_parcours_progress` elle-même. La règle « chapitre terminé » fait
--    autorité là, et son miroir client est `src/shared/lib/chapter-completion.ts`.
--    Les deux doivent changer ensemble ou pas du tout : ici, pas du tout.
--
-- 2. `_student_daily_report_json` (20260817120000) porte le MÊME LATERAL, et
--    c'est lui qu'on croyait le plus exposé — `/suivi` s'exécute en `anon`, dont
--    le statement timeout est de 3 s contre 8 s pour `authenticated`. La mesure
--    l'a infirmé : son plan restreint déjà (`Rows Removed by Filter: 104` tombe
--    avant la jointure), `loops=10`, 3 585 buffers. Et lui appliquer cette
--    réécriture le ferait passer à 7 745 buffers — 2,2× PIRE.
--
--    L'arithmétique, qui vaut pour les deux : un appel ciblé sur une matière
--    coûte ~318 buffers, un appel sur tout le catalogue ~7 400. Le seuil de
--    bascule est donc à ~23 appels. Le bilan appelle une fois par tentative
--    (157, et ça monte avec l'historique) ; le quotidien une fois par matière
--    travaillée (10, et ça ne montera guère). Le même changement franchit le
--    seuil dans un cas et le rate dans l'autre.
--
-- Migration SQL pure : aucun code applicatif ne change, la charge utile JSON
-- est identique au champ près.

CREATE OR REPLACE FUNCTION public._student_report_json(p_student UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_student public.profiles;
  v_total_exercises INT := 0;
  v_total_time_minutes INT := 0;
  v_avg_score INT := 0;
  v_days_active INT := 0;
  v_last10_avg NUMERIC := 0;
  v_prev10_avg NUMERIC := 0;
  v_score_trend INT := 0;
  v_seriousness INT := 0;
  v_verdict TEXT := 'inactive';
  v_subject_stats JSONB := '[]'::jsonb;
  v_daily_activity JSONB := '[]'::jsonb;
  v_week_comparison JSONB;
  v_strengths JSONB := '[]'::jsonb;
  v_weaknesses JSONB := '[]'::jsonb;
BEGIN
  SELECT * INTO v_student
  FROM public.profiles
  WHERE id = p_student;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Student profile not found.';
  END IF;

  SELECT
    COUNT(*)::INT,
    ROUND(COALESCE(SUM(duration_seconds), 0)::NUMERIC / 60)::INT,
    ROUND(COALESCE(AVG(score_pct), 0))::INT,
    COUNT(DISTINCT (completed_at AT TIME ZONE 'UTC')::DATE) FILTER (
      WHERE completed_at >= clock_timestamp() - INTERVAL '7 days'
    )::INT
  INTO v_total_exercises, v_total_time_minutes, v_avg_score, v_days_active
  FROM public.attempts
  WHERE user_id = p_student;

  SELECT COALESCE(AVG(score_pct), 0)
  INTO v_last10_avg
  FROM (
    SELECT score_pct
    FROM public.attempts
    WHERE user_id = p_student
    ORDER BY completed_at DESC
    LIMIT 10
  ) t;

  SELECT COALESCE(AVG(score_pct), 0)
  INTO v_prev10_avg
  FROM (
    SELECT score_pct
    FROM public.attempts
    WHERE user_id = p_student
    ORDER BY completed_at DESC
    OFFSET 10
    LIMIT 10
  ) t;

  IF v_prev10_avg > 0 THEN
    v_score_trend := ROUND(v_last10_avg - v_prev10_avg);
  ELSE
    v_score_trend := 0;
  END IF;

  v_seriousness := ROUND(
    LEAST(COALESCE(v_student.current_streak, 0)::NUMERIC / 7, 1) * 25
    + LEAST(v_days_active::NUMERIC / 5, 1) * 25
    + LEAST(v_avg_score::NUMERIC / 80, 1) * 25
    + LEAST(v_total_time_minutes::NUMERIC / 120, 1) * 25
  );

  IF v_seriousness >= 80 THEN
    v_verdict := 'excellent';
  ELSIF v_seriousness >= 60 THEN
    v_verdict := 'good';
  ELSIF v_seriousness >= 40 THEN
    v_verdict := 'average';
  ELSIF v_total_exercises > 0 THEN
    v_verdict := 'needs_improvement';
  ELSE
    v_verdict := 'inactive';
  END IF;

  SELECT COALESCE(jsonb_agg(row_to_json(s) ORDER BY s.name), '[]'::jsonb)
  INTO v_subject_stats
  FROM (
    -- La couverture des matières, en UN appel au lieu d'un par ligne.
    --
    -- Ce qui était ici appelait la fonction avec `ARRAY[sub.id]`, donc une fois
    -- par ligne de la jointure sur `attempts` — soit une fois par TENTATIVE, et
    -- non par matière. Mesuré en prod le 2026-08-18 : 157 appels pour un élève à
    -- 157 tentatives, 99,85 % des buffers de la requête. La couverture d'une
    -- matière était recalculée autant de fois que l'élève y avait travaillé.
    --
    -- MATERIALIZED est délibéré : il rend l'appel unique GARANTI plutôt que
    -- dépendant d'un choix de planificateur — et c'est un choix de planificateur
    -- qui a produit le défaut. Le `NULL` demande toutes les matières d'un coup ;
    -- celles qui ne publient aucun chapitre restent absentes du résultat, donc à
    -- 0/0 par le COALESCE, exactement comme le LATERAL les laissait à NULL.
    WITH coverage AS MATERIALIZED (
      SELECT pp.subject_id, pp.chapters_total, pp.chapters_completed
        FROM public.student_parcours_progress(p_student, NULL::TEXT[]) pp
    )
    SELECT
      sub.id AS "subjectId",
      sub.name_fr AS "name",
      -- Le NIVEAU, sans lequel « Mathématiques » s'affichait quatre fois à
      -- l'identique : une matière appartient à un niveau (math-6, math-9…).
      g.name_fr AS "gradeName",
      sub.color_token AS "colorToken",
      COALESCE(cov.chapters_total, 0)::INT AS "chaptersTotal",
      COALESCE(cov.chapters_completed, 0)::INT AS "chaptersCompleted",
      COUNT(a.*)::INT AS "attempts",
      ROUND(COALESCE(AVG(a.score_pct), 0))::INT AS "avgScore",
      ROUND(COALESCE(SUM(a.duration_seconds), 0)::NUMERIC / 60)::INT AS "totalTimeMinutes"
    FROM public.subjects sub
    LEFT JOIN public.grades g ON g.id = sub.grade_id
    LEFT JOIN coverage cov ON cov.subject_id = sub.id
    JOIN public.attempts a
      ON a.subject_id = sub.id
     AND a.user_id = p_student
    GROUP BY sub.id, sub.name_fr, g.name_fr, sub.color_token,
             cov.chapters_total, cov.chapters_completed
    HAVING COUNT(a.*) > 0
  ) s;

  WITH days AS (
    SELECT (clock_timestamp() AT TIME ZONE 'UTC')::DATE - i AS day
    FROM generate_series(29, 0, -1) AS i
  ), attempts_by_day AS (
    SELECT
      (completed_at AT TIME ZONE 'UTC')::DATE AS day,
      COUNT(*)::INT AS exercises,
      ROUND(COALESCE(SUM(duration_seconds), 0)::NUMERIC / 60)::INT AS minutes,
      ROUND(COALESCE(AVG(score_pct), 0))::INT AS avg_score
    FROM public.attempts
    WHERE user_id = p_student
      AND completed_at >= (clock_timestamp() AT TIME ZONE 'UTC')::DATE - INTERVAL '29 days'
    GROUP BY (completed_at AT TIME ZONE 'UTC')::DATE
  )
  SELECT COALESCE(jsonb_agg(
    jsonb_build_object(
      'date', to_char(d.day, 'YYYY-MM-DD'),
      'exercises', COALESCE(a.exercises, 0),
      'minutes', COALESCE(a.minutes, 0),
      'avgScore', COALESCE(a.avg_score, 0)
    )
    ORDER BY d.day
  ), '[]'::jsonb)
  INTO v_daily_activity
  FROM days d
  LEFT JOIN attempts_by_day a ON a.day = d.day;

  -- Semaine glissante courante (J-7 → maintenant) vs la précédente (J-14 → J-7).
  SELECT jsonb_build_object(
    'thisWeek', jsonb_build_object(
      'exercises', COALESCE(SUM(CASE WHEN completed_at >= clock_timestamp() - INTERVAL '7 days' THEN 1 ELSE 0 END), 0)::INT,
      'minutes', ROUND(COALESCE(SUM(duration_seconds) FILTER (
        WHERE completed_at >= clock_timestamp() - INTERVAL '7 days'
      ), 0)::NUMERIC / 60)::INT,
      'avgScore', ROUND(COALESCE(AVG(score_pct) FILTER (
        WHERE completed_at >= clock_timestamp() - INTERVAL '7 days'
      ), 0))::INT
    ),
    'lastWeek', jsonb_build_object(
      'exercises', COALESCE(SUM(CASE WHEN completed_at < clock_timestamp() - INTERVAL '7 days' THEN 1 ELSE 0 END), 0)::INT,
      'minutes', ROUND(COALESCE(SUM(duration_seconds) FILTER (
        WHERE completed_at < clock_timestamp() - INTERVAL '7 days'
      ), 0)::NUMERIC / 60)::INT,
      'avgScore', ROUND(COALESCE(AVG(score_pct) FILTER (
        WHERE completed_at < clock_timestamp() - INTERVAL '7 days'
      ), 0))::INT
    )
  )
  INTO v_week_comparison
  FROM public.attempts
  WHERE user_id = p_student
    AND completed_at >= clock_timestamp() - INTERVAL '14 days';

  -- Forces / points à renforcer par chapitre (30 j, ≥ 2 tentatives).
  WITH chapter_stats AS (
    SELECT
      ch.id AS chapter_id,
      ch.title AS chapter_title,
      sub.name_fr AS subject_name,
      sub.id AS subject_id,
      COUNT(a.*)::INT AS attempts,
      ROUND(COALESCE(AVG(a.score_pct), 0))::INT AS avg_score
    FROM public.attempts a
    JOIN public.exercises e ON e.id = a.exercise_id
    JOIN public.chapters ch ON ch.id = e.chapter_id
    JOIN public.subjects sub ON sub.id = ch.subject_id
    WHERE a.user_id = p_student
      AND a.completed_at >= clock_timestamp() - INTERVAL '30 days'
    GROUP BY ch.id, ch.title, sub.name_fr, sub.id
    HAVING COUNT(a.*) >= 2
  )
  SELECT
    COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'chapterId', chapter_id,
        'chapterTitle', chapter_title,
        'subjectId', subject_id,
        'subjectName', subject_name,
        'attempts', attempts,
        'avgScore', avg_score
      ) ORDER BY avg_score DESC, attempts DESC)
      FROM (SELECT * FROM chapter_stats WHERE avg_score >= 80 ORDER BY avg_score DESC, attempts DESC LIMIT 3) top
    ), '[]'::jsonb),
    COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'chapterId', chapter_id,
        'chapterTitle', chapter_title,
        'subjectId', subject_id,
        'subjectName', subject_name,
        'attempts', attempts,
        'avgScore', avg_score
      ) ORDER BY avg_score ASC, attempts DESC)
      FROM (SELECT * FROM chapter_stats WHERE avg_score < 60 ORDER BY avg_score ASC, attempts DESC LIMIT 3) low
    ), '[]'::jsonb)
  INTO v_strengths, v_weaknesses;

  RETURN jsonb_build_object(
    'student', jsonb_build_object(
      'displayName', v_student.display_name,
      'heroClass', v_student.hero_class,
      'level', v_student.level,
      'xp', v_student.xp,
      'currentStreak', v_student.current_streak,
      'longestStreak', v_student.longest_streak,
      'lastActiveDate', v_student.last_active_date,
      'createdAt', v_student.created_at
    ),
    'summary', jsonb_build_object(
      'totalTimeMinutes', v_total_time_minutes,
      'totalExercises', v_total_exercises,
      'avgScore', v_avg_score,
      'daysActiveThisWeek', v_days_active,
      'seriousnessScore', v_seriousness,
      'verdict', v_verdict,
      'scoreTrend', v_score_trend
    ),
    'subjectStats', v_subject_stats,
    'dailyActivity', v_daily_activity,
    'weekComparison', v_week_comparison,
    'chapterInsights', jsonb_build_object(
      'strengths', v_strengths,
      'weaknesses', v_weaknesses
    )
  );
END;
$fn$;

REVOKE EXECUTE ON FUNCTION public._student_report_json(UUID) FROM PUBLIC, anon, authenticated;
