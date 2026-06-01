-- Parent reporting optimization + global cleanup for shared rate limiting.

CREATE INDEX IF NOT EXISTS idx_rate_limit_events_created_at
  ON public.rate_limit_events(created_at);

CREATE OR REPLACE FUNCTION public.cleanup_rate_limit_events(p_retention_hours INT DEFAULT 24)
RETURNS INT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_deleted INT := 0;
BEGIN
  IF p_retention_hours IS NULL OR p_retention_hours <= 0 THEN
    RAISE EXCEPTION 'Invalid retention window';
  END IF;

  DELETE FROM public.rate_limit_events
  WHERE created_at < clock_timestamp() - make_interval(hours => p_retention_hours);

  GET DIAGNOSTICS v_deleted = ROW_COUNT;
  RETURN v_deleted;
END;
$$;

CREATE OR REPLACE FUNCTION public.check_rate_limit(
  p_key TEXT,
  p_max_requests INT,
  p_window_ms INT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_now TIMESTAMPTZ := clock_timestamp();
  v_window_start TIMESTAMPTZ;
  v_request_count INT;
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_key IS NULL OR btrim(p_key) = '' THEN
    RAISE EXCEPTION 'Rate limit key is required';
  END IF;

  IF p_max_requests IS NULL OR p_max_requests <= 0 THEN
    RAISE EXCEPTION 'Invalid max request limit';
  END IF;

  IF p_window_ms IS NULL OR p_window_ms <= 0 THEN
    RAISE EXCEPTION 'Invalid rate limit window';
  END IF;

  -- Opportunistic global cleanup (~1% of calls) to avoid stale key accumulation.
  IF random() < 0.01 THEN
    PERFORM public.cleanup_rate_limit_events(24);
  END IF;

  PERFORM pg_advisory_xact_lock(hashtextextended(p_key, 0));

  v_window_start := v_now - make_interval(secs => p_window_ms / 1000.0);

  DELETE FROM public.rate_limit_events
  WHERE scope_key = p_key
    AND created_at < v_window_start;

  SELECT COUNT(*)::INT
  INTO v_request_count
  FROM public.rate_limit_events
  WHERE scope_key = p_key
    AND created_at >= v_window_start;

  IF v_request_count >= p_max_requests THEN
    RETURN TRUE;
  END IF;

  INSERT INTO public.rate_limit_events (scope_key)
  VALUES (p_key);

  RETURN FALSE;
END;
$$;

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
    'dailyActivity', v_daily_activity
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.cleanup_rate_limit_events(int) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.get_student_report(uuid) FROM PUBLIC, anon;

GRANT EXECUTE ON FUNCTION public.get_student_report(uuid) TO authenticated;
