-- Bilan famille actionnable — enrichit get_student_report avec :
--   * weekComparison  : cette semaine (7 j glissants) vs la semaine précédente
--                       (exercices, minutes, score moyen) → le parent voit la dynamique.
--   * chapterInsights : forces / points à renforcer au niveau CHAPITRE sur les
--                       30 derniers jours (attempts → exercises → chapters),
--                       ≥ 2 tentatives pour éviter le bruit d'un essai isolé.
-- Additif (CREATE OR REPLACE, mêmes clés existantes conservées) : sûr avant le code.

CREATE OR REPLACE FUNCTION public.get_student_report(p_student UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_role TEXT;
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
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT role INTO v_role
  FROM public.profiles
  WHERE id = v_user;

  IF v_role IS DISTINCT FROM 'admin' AND v_role IS DISTINCT FROM 'parent' THEN
    RAISE EXCEPTION 'Access denied.';
  END IF;

  IF v_role = 'parent' AND NOT public.is_parent_of_student(v_user, p_student) THEN
    RAISE EXCEPTION 'Access denied: you are not linked to this student.';
  END IF;

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
    SELECT
      sub.id AS "subjectId",
      sub.name_fr AS "name",
      sub.color_token AS "colorToken",
      COUNT(a.*)::INT AS "attempts",
      ROUND(COALESCE(AVG(a.score_pct), 0))::INT AS "avgScore",
      ROUND(COALESCE(SUM(a.duration_seconds), 0)::NUMERIC / 60)::INT AS "totalTimeMinutes"
    FROM public.subjects sub
    JOIN public.attempts a
      ON a.subject_id = sub.id
     AND a.user_id = p_student
    GROUP BY sub.id, sub.name_fr, sub.color_token
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
$$;

REVOKE EXECUTE ON FUNCTION public.get_student_report(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_student_report(uuid) TO authenticated;
