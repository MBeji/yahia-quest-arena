-- Suivi parental — le filtre « sa classe ».
--
-- LE BESOIN. « Si mon fils est en 9ème, je veux voir son activité par rapport à
-- sa classe uniquement, indépendamment de ce qu'il a fait de révision sur
-- d'autres niveaux ou les extras. » Un élève de 9ème qui révise sa 8ème et suit
-- l'éducation islamique voyait tout fondu dans les mêmes totaux : son temps, ses
-- scores, son engagement. Impossible d'y lire où il en est de SON programme.
--
-- CE QUE « SA CLASSE » VEUT DIRE. Les matières dont le niveau est celui de
-- l'élève (`profiles.current_grade_id`) — exactement la notion que le classement
-- « Ma classe » emploie déjà (étude 22, décision D-5 : un « Concours 9ème » et un
-- « 9ème » sont des pairs). Les extras n'ont pas de niveau, les autres années en
-- ont un autre : les deux sortent du périmètre sans règle supplémentaire.
--
-- LE RISQUE, ET COMMENT IL EST TENU. Le rapport lit `attempts` et
-- `learning_pulses` dans une dizaine de requêtes. En filtrer neuf sur dix
-- donnerait un tableau où le temps est ramené à la classe mais pas les scores —
-- pire qu'aucun filtre. Aucun prédicat n'est donc posé requête par requête :
-- toute lecture passe par `_scoped_attempts` / `_scoped_pulses`, qui portent le
-- périmètre une fois pour toutes. La composition de cette migration échoue s'il
-- subsiste une seule lecture directe des deux tables.
--
-- CE QUI EST MIS DE CÔTÉ EST DIT. Le filtre rend aussi `excludedMinutes` et
-- `excludedExercises` : un filtre qui cache sans l'annoncer se lirait comme une
-- chute d'activité. L'activité qu'aucune matière ne porte (donjon, duels,
-- navigation) en fait partie — elle n'est rattachable à aucun niveau.

-- ---------------------------------------------------------------------------
-- 1. Les deux sources scopées. `p_subject_ids IS NULL` = aucun filtre.
--    LANGUAGE sql STABLE : Postgres sait les inliner, le plan reste celui d'un
--    accès direct aux index (user_id, …).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public._scoped_attempts(p_student UUID, p_subject_ids TEXT[])
RETURNS SETOF public.attempts
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  SELECT *
    FROM public.attempts a
   WHERE a.user_id = p_student
     AND (p_subject_ids IS NULL OR a.subject_id = ANY (p_subject_ids));
$fn$;

REVOKE EXECUTE ON FUNCTION public._scoped_attempts(UUID, TEXT[])
  FROM PUBLIC, anon, authenticated;

-- Un pouls sans matière (donjon, duel, navigation) n'appartient à aucun niveau :
-- il sort du périmètre dès qu'un filtre est demandé. C'est voulu, et c'est
-- précisément ce que `excludedMinutes` rapporte au parent.
CREATE OR REPLACE FUNCTION public._scoped_pulses(p_student UUID, p_subject_ids TEXT[])
RETURNS SETOF public.learning_pulses
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  SELECT *
    FROM public.learning_pulses lp
   WHERE lp.user_id = p_student
     AND (p_subject_ids IS NULL OR lp.subject_id = ANY (p_subject_ids));
$fn$;

REVOKE EXECUTE ON FUNCTION public._scoped_pulses(UUID, TEXT[])
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 2. Les totaux, scopés.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.student_activity_totals(
  p_student UUID,
  p_from TIMESTAMPTZ,
  p_to TIMESTAMPTZ,
  p_tz TEXT,
  p_session_gap INTERVAL,
  p_pass_pct INT,
  p_studied_seconds INT,
  p_studied_pct INT,
  p_subject_ids TEXT[] DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_app_seconds INT := 0;
  v_learning_seconds INT := 0;
  v_lesson_seconds INT := 0;
  v_exercise_seconds INT := 0;
  v_quiz_seconds INT := 0;
  v_recall_seconds INT := 0;
  v_arena_seconds INT := 0;
  v_browse_seconds INT := 0;
  v_active_days INT := 0;
  v_sessions INT := 0;
  v_exercises INT := 0;
  v_passed INT := 0;
  v_correct INT := 0;
  v_questions INT := 0;
  v_avg_score INT := 0;
  v_duration_seconds INT := 0;
  v_lessons_opened INT := 0;
  v_lessons_studied INT := 0;
  v_sessions_started INT := 0;
  v_sessions_completed INT := 0;
  v_tries_to_pass NUMERIC;
BEGIN
  -- Temps mesuré + sessions d'application.
  WITH p AS (
    SELECT
      surface,
      active_seconds,
      occurred_at - LAG(occurred_at) OVER (ORDER BY occurred_at) AS gap
    FROM public._scoped_pulses(p_student, p_subject_ids)
    WHERE user_id = p_student
      AND occurred_at >= p_from
      AND occurred_at < p_to
  )
  SELECT
    COALESCE(SUM(active_seconds), 0)::INT,
    COALESCE(SUM(active_seconds) FILTER (WHERE surface <> 'browse'), 0)::INT,
    COALESCE(SUM(active_seconds) FILTER (WHERE surface = 'lesson'), 0)::INT,
    COALESCE(SUM(active_seconds) FILTER (WHERE surface = 'exercise'), 0)::INT,
    COALESCE(SUM(active_seconds) FILTER (WHERE surface = 'quiz'), 0)::INT,
    COALESCE(SUM(active_seconds) FILTER (WHERE surface = 'recall'), 0)::INT,
    COALESCE(SUM(active_seconds) FILTER (WHERE surface IN ('dungeon', 'duel')), 0)::INT,
    COALESCE(SUM(active_seconds) FILTER (WHERE surface = 'browse'), 0)::INT,
    COUNT(*) FILTER (WHERE gap IS NULL OR gap > p_session_gap)::INT
  INTO
    v_app_seconds, v_learning_seconds, v_lesson_seconds, v_exercise_seconds,
    v_quiz_seconds, v_recall_seconds, v_arena_seconds, v_browse_seconds, v_sessions
  FROM p;

  -- Jours actifs : un jour compte dès qu'il porte du temps mesuré OU une
  -- tentative — l'historique d'avant l'instrumentation reste donc lisible.
  SELECT COUNT(*)::INT INTO v_active_days
  FROM (
    SELECT (occurred_at AT TIME ZONE p_tz)::DATE AS day
    FROM public._scoped_pulses(p_student, p_subject_ids)
    WHERE user_id = p_student AND occurred_at >= p_from AND occurred_at < p_to
    UNION
    SELECT (completed_at AT TIME ZONE p_tz)::DATE
    FROM public._scoped_attempts(p_student, p_subject_ids)
    WHERE user_id = p_student AND completed_at >= p_from AND completed_at < p_to
  ) d;

  -- Exercices.
  SELECT
    COUNT(*)::INT,
    COUNT(*) FILTER (WHERE score_pct >= p_pass_pct)::INT,
    COALESCE(SUM(correct_count), 0)::INT,
    COALESCE(SUM(total_count), 0)::INT,
    COALESCE(ROUND(AVG(score_pct)), 0)::INT,
    COALESCE(SUM(duration_seconds), 0)::INT
  INTO v_exercises, v_passed, v_correct, v_questions, v_avg_score, v_duration_seconds
  FROM public._scoped_attempts(p_student, p_subject_ids)
  WHERE user_id = p_student
    AND completed_at >= p_from
    AND completed_at < p_to;

  -- Cours ouverts vs réellement étudiés (même seuil que le détail).
  SELECT
    COUNT(*)::INT,
    COUNT(*) FILTER (WHERE seconds >= p_studied_seconds AND progress_pct >= p_studied_pct)::INT
  INTO v_lessons_opened, v_lessons_studied
  FROM (
    SELECT
      SUM(active_seconds)::INT AS seconds,
      COALESCE(MAX(progress_pct), 0)::INT AS progress_pct
    FROM public._scoped_pulses(p_student, p_subject_ids)
    WHERE user_id = p_student
      AND surface = 'lesson'
      AND chapter_id IS NOT NULL
      AND occurred_at >= p_from
      AND occurred_at < p_to
    GROUP BY chapter_id, (occurred_at AT TIME ZONE p_tz)::DATE
  ) l;

  -- Exercices commencés vs terminés — « beaucoup de commencés, peu de finis ».
  SELECT
    COUNT(*)::INT,
    COUNT(*) FILTER (WHERE completed_at IS NOT NULL)::INT
  INTO v_sessions_started, v_sessions_completed
  FROM public.exercise_sessions
  WHERE user_id = p_student
    AND started_at >= p_from
    AND started_at < p_to;

  -- Nombre moyen de tentatives avant de réussir, pour les exercices dont la
  -- PREMIÈRE réussite tombe dans la fenêtre.
  WITH first_pass AS (
    SELECT exercise_id, MIN(completed_at) FILTER (WHERE score_pct >= p_pass_pct) AS passed_at
    FROM public._scoped_attempts(p_student, p_subject_ids)
    WHERE user_id = p_student
    GROUP BY exercise_id
  ),
  tries AS (
    SELECT fp.exercise_id, COUNT(a.*)::INT AS n
    FROM first_pass fp
    JOIN public.attempts a
      ON a.exercise_id = fp.exercise_id
     AND a.user_id = p_student
     AND a.completed_at <= fp.passed_at
    WHERE fp.passed_at IS NOT NULL
      AND fp.passed_at >= p_from
      AND fp.passed_at < p_to
    GROUP BY fp.exercise_id
  )
  SELECT ROUND(AVG(n), 1) INTO v_tries_to_pass FROM tries;

  RETURN jsonb_build_object(
    'appMinutes', ROUND(v_app_seconds::NUMERIC / 60)::INT,
    'learningMinutes', ROUND(v_learning_seconds::NUMERIC / 60)::INT,
    'byActivity', jsonb_build_object(
      'lesson', ROUND(v_lesson_seconds::NUMERIC / 60)::INT,
      'exercise', ROUND(v_exercise_seconds::NUMERIC / 60)::INT,
      'quiz', ROUND(v_quiz_seconds::NUMERIC / 60)::INT,
      'recall', ROUND(v_recall_seconds::NUMERIC / 60)::INT,
      'arena', ROUND(v_arena_seconds::NUMERIC / 60)::INT,
      'browse', ROUND(v_browse_seconds::NUMERIC / 60)::INT
    ),
    'activeDays', v_active_days,
    'sessions', v_sessions,
    'exercises', v_exercises,
    'exercisesPassed', v_passed,
    'exercisesFailed', GREATEST(v_exercises - v_passed, 0),
    'correct', v_correct,
    'wrong', GREATEST(v_questions - v_correct, 0),
    'questions', v_questions,
    'avgScore', v_avg_score,
    -- Temps moyen par exercice / par question : ceux-ci viennent de la DURÉE DE
    -- LA TENTATIVE (mesurée par le moteur de score), pas des pouls — les deux
    -- ne sont jamais additionnés, ils ne mesurent pas la même chose.
    'avgSecondsPerExercise', CASE WHEN v_exercises = 0 THEN 0
                                  ELSE ROUND(v_duration_seconds::NUMERIC / v_exercises)::INT END,
    'avgSecondsPerQuestion', CASE WHEN v_questions = 0 THEN 0
                                  ELSE ROUND(v_duration_seconds::NUMERIC / v_questions)::INT END,
    'lessonsOpened', v_lessons_opened,
    'lessonsStudied', v_lessons_studied,
    'exerciseSessionsStarted', v_sessions_started,
    'exerciseSessionsCompleted', v_sessions_completed,
    'avgTriesToPass', COALESCE(v_tries_to_pass, 0)
  );
END;
$fn$;

REVOKE EXECUTE ON FUNCTION public.student_activity_totals(
  UUID, TIMESTAMPTZ, TIMESTAMPTZ, TEXT, INTERVAL, INT, INT, INT, TEXT[])
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 3. Le rapport, scopé.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public._student_daily_report_json(
  p_student UUID,
  p_from DATE,
  p_to DATE,
  p_subject_ids TEXT[] DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  c_tz CONSTANT TEXT := 'Africa/Tunis';
  -- Une nouvelle « session » d'application démarre après ce silence.
  c_session_gap CONSTANT INTERVAL := INTERVAL '30 minutes';
  -- Miroir de PASS_THRESHOLD_PCT (src/shared/constants/gamification.ts).
  c_pass_pct CONSTANT INT := 60;
  -- « Réellement étudié » vs « seulement ouvert » : il faut À LA FOIS du temps
  -- et de la descente dans la page. Deux minutes sur 60 % du cours, c'est le
  -- minimum pour parler de lecture ; en dessous, la page a été ouverte.
  c_studied_seconds CONSTANT INT := 120;
  c_studied_pct CONSTANT INT := 60;
  -- Bornes de charge utile : le tableau de bord affiche des listes, pas un export.
  c_max_days CONSTANT INT := 92;
  c_max_rows CONSTANT INT := 300;

  v_from DATE;
  v_to DATE;
  v_span INT;
  v_prev_from DATE;
  v_from_ts TIMESTAMPTZ;
  v_to_ts TIMESTAMPTZ;
  v_prev_from_ts TIMESTAMPTZ;

  v_student public.profiles;
  v_grade_id UUID;
  v_grade_name TEXT;
  v_excluded_minutes INT := 0;
  v_excluded_exercises INT := 0;
  v_measured_since TIMESTAMPTZ;
  v_days JSONB := '[]'::jsonb;
  v_lessons JSONB := '[]'::jsonb;
  v_exercises JSONB := '[]'::jsonb;
  v_subjects JSONB := '[]'::jsonb;
  v_chapters JSONB := '[]'::jsonb;
  v_totals JSONB;
  v_previous JSONB;
BEGIN
  SELECT * INTO v_student FROM public.profiles WHERE id = p_student;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Student profile not found.';
  END IF;

  -- Normalisation de la période : ordre, longueur maximale, période précédente
  -- de même longueur (c'est elle qui porte « progression sur 7 / 30 jours »).
  v_from := LEAST(p_from, p_to);
  v_to := GREATEST(p_from, p_to);
  IF v_to - v_from + 1 > c_max_days THEN
    v_from := v_to - (c_max_days - 1);
  END IF;
  v_span := v_to - v_from + 1;
  v_prev_from := v_from - v_span;

  -- Bornes absolues : minuit local du premier jour → minuit local du lendemain
  -- du dernier. Comparer des timestamptz évite de recalculer un fuseau par ligne
  -- et laisse les index (user_id, occurred_at) travailler.
  v_from_ts := (v_from::TIMESTAMP AT TIME ZONE c_tz);
  v_to_ts := ((v_to + 1)::TIMESTAMP AT TIME ZONE c_tz);
  v_prev_from_ts := (v_prev_from::TIMESTAMP AT TIME ZONE c_tz);

  -- La classe de l'élève, au sens que le classement « Ma classe » emploie déjà
  -- (décision D-5 : un « Concours 9ème » et un « 9ème » sont des pairs). Un élève
  -- sans classe — parcours libre — n'a rien à filtrer.
  SELECT g.id, g.name_fr INTO v_grade_id, v_grade_name
  FROM public.grades g
  WHERE g.id = v_student.current_grade_id;

  -- Ce que le filtre écarte : révisions d'autres niveaux, extras (matières sans
  -- niveau), et l'activité qu'aucune matière ne porte (donjon, duels, navigation).
  IF p_subject_ids IS NOT NULL THEN
    SELECT
      ROUND(COALESCE(SUM(lp.active_seconds), 0)::NUMERIC / 60)::INT
    INTO v_excluded_minutes
    FROM public.learning_pulses lp
    WHERE lp.user_id = p_student
      AND lp.occurred_at >= v_from_ts
      AND lp.occurred_at < v_to_ts
      AND (lp.subject_id IS NULL OR NOT (lp.subject_id = ANY (p_subject_ids)));

    SELECT COUNT(*)::INT
    INTO v_excluded_exercises
    FROM public.attempts a
    WHERE a.user_id = p_student
      AND a.completed_at >= v_from_ts
      AND a.completed_at < v_to_ts
      AND NOT (a.subject_id = ANY (p_subject_ids));
  END IF;

  SELECT MIN(occurred_at) INTO v_measured_since
  FROM public._scoped_pulses(p_student, p_subject_ids)
  WHERE user_id = p_student;

  -- -------------------------------------------------------------------------
  -- Jour par jour : temps mesuré, plage horaire, sessions, activité.
  -- -------------------------------------------------------------------------
  WITH days AS (
    SELECT generate_series(v_from, v_to, INTERVAL '1 day')::DATE AS day
  ),
  pulses AS (
    SELECT
      (occurred_at AT TIME ZONE c_tz)::DATE AS day,
      occurred_at,
      surface,
      active_seconds,
      occurred_at - LAG(occurred_at) OVER (
        PARTITION BY (occurred_at AT TIME ZONE c_tz)::DATE
        ORDER BY occurred_at
      ) AS gap
    FROM public._scoped_pulses(p_student, p_subject_ids)
    WHERE user_id = p_student
      AND occurred_at >= v_from_ts
      AND occurred_at < v_to_ts
  ),
  pulse_days AS (
    SELECT
      day,
      SUM(active_seconds)::INT AS app_seconds,
      COALESCE(SUM(active_seconds) FILTER (WHERE surface <> 'browse'), 0)::INT AS learning_seconds,
      COALESCE(SUM(active_seconds) FILTER (WHERE surface = 'lesson'), 0)::INT AS lesson_seconds,
      COALESCE(SUM(active_seconds) FILTER (WHERE surface = 'exercise'), 0)::INT AS exercise_seconds,
      COALESCE(SUM(active_seconds) FILTER (WHERE surface = 'quiz'), 0)::INT AS quiz_seconds,
      COALESCE(SUM(active_seconds) FILTER (WHERE surface = 'recall'), 0)::INT AS recall_seconds,
      COALESCE(SUM(active_seconds) FILTER (WHERE surface IN ('dungeon', 'duel')), 0)::INT AS arena_seconds,
      COALESCE(SUM(active_seconds) FILTER (WHERE surface = 'browse'), 0)::INT AS browse_seconds,
      MIN(occurred_at) AS first_at,
      MAX(occurred_at) AS last_at,
      COUNT(*) FILTER (WHERE gap IS NULL OR gap > c_session_gap)::INT AS sessions
    FROM pulses
    GROUP BY day
  ),
  attempt_days AS (
    SELECT
      (completed_at AT TIME ZONE c_tz)::DATE AS day,
      COUNT(*)::INT AS exercises,
      ROUND(AVG(score_pct))::INT AS avg_score,
      SUM(correct_count)::INT AS correct,
      SUM(total_count)::INT AS questions
    FROM public._scoped_attempts(p_student, p_subject_ids)
    WHERE user_id = p_student
      AND completed_at >= v_from_ts
      AND completed_at < v_to_ts
    GROUP BY (completed_at AT TIME ZONE c_tz)::DATE
  ),
  lesson_days AS (
    SELECT
      (occurred_at AT TIME ZONE c_tz)::DATE AS day,
      COUNT(DISTINCT chapter_id)::INT AS chapters_read
    FROM public._scoped_pulses(p_student, p_subject_ids)
    WHERE user_id = p_student
      AND surface = 'lesson'
      AND chapter_id IS NOT NULL
      AND occurred_at >= v_from_ts
      AND occurred_at < v_to_ts
    GROUP BY (occurred_at AT TIME ZONE c_tz)::DATE
  )
  SELECT COALESCE(jsonb_agg(
    jsonb_build_object(
      'date', to_char(d.day, 'YYYY-MM-DD'),
      'appMinutes', ROUND(COALESCE(p.app_seconds, 0)::NUMERIC / 60)::INT,
      'learningMinutes', ROUND(COALESCE(p.learning_seconds, 0)::NUMERIC / 60)::INT,
      -- Minutes par type d'activité — la ventilation demandée par le parent.
      'byActivity', jsonb_build_object(
        'lesson', ROUND(COALESCE(p.lesson_seconds, 0)::NUMERIC / 60)::INT,
        'exercise', ROUND(COALESCE(p.exercise_seconds, 0)::NUMERIC / 60)::INT,
        'quiz', ROUND(COALESCE(p.quiz_seconds, 0)::NUMERIC / 60)::INT,
        'recall', ROUND(COALESCE(p.recall_seconds, 0)::NUMERIC / 60)::INT,
        'arena', ROUND(COALESCE(p.arena_seconds, 0)::NUMERIC / 60)::INT,
        'browse', ROUND(COALESCE(p.browse_seconds, 0)::NUMERIC / 60)::INT
      ),
      -- Heures rendues en heure LOCALE : le client les affiche telles quelles,
      -- il n'a aucune conversion de fuseau à refaire.
      'firstAt', CASE WHEN p.first_at IS NULL THEN NULL
                      ELSE to_char(p.first_at AT TIME ZONE c_tz, 'HH24:MI') END,
      'lastAt', CASE WHEN p.last_at IS NULL THEN NULL
                     ELSE to_char(p.last_at AT TIME ZONE c_tz, 'HH24:MI') END,
      'sessions', COALESCE(p.sessions, 0),
      'exercises', COALESCE(a.exercises, 0),
      'lessonsRead', COALESCE(l.chapters_read, 0),
      -- « Nombre total d'activités réalisées » : un exercice terminé ou un
      -- chapitre ouvert comptent chacun pour une activité.
      'activities', COALESCE(a.exercises, 0) + COALESCE(l.chapters_read, 0),
      'avgScore', COALESCE(a.avg_score, 0),
      'correct', COALESCE(a.correct, 0),
      'questions', COALESCE(a.questions, 0)
    ) ORDER BY d.day
  ), '[]'::jsonb)
  INTO v_days
  FROM days d
  LEFT JOIN pulse_days p ON p.day = d.day
  LEFT JOIN attempt_days a ON a.day = d.day
  LEFT JOIN lesson_days l ON l.day = d.day;

  -- -------------------------------------------------------------------------
  -- Cours consultés — une ligne par (jour, chapitre).
  -- -------------------------------------------------------------------------
  WITH lesson_pulses AS (
    SELECT
      (lp.occurred_at AT TIME ZONE c_tz)::DATE AS day,
      lp.chapter_id,
      lp.occurred_at,
      lp.active_seconds,
      lp.progress_pct,
      lp.occurred_at - LAG(lp.occurred_at) OVER (
        PARTITION BY (lp.occurred_at AT TIME ZONE c_tz)::DATE, lp.chapter_id
        ORDER BY lp.occurred_at
      ) AS gap
    FROM public._scoped_pulses(p_student, p_subject_ids) lp
    WHERE lp.user_id = p_student
      AND lp.surface = 'lesson'
      AND lp.chapter_id IS NOT NULL
      AND lp.occurred_at >= v_from_ts
      AND lp.occurred_at < v_to_ts
  ),
  per_chapter_day AS (
    SELECT
      day,
      chapter_id,
      SUM(active_seconds)::INT AS seconds,
      COALESCE(MAX(progress_pct), 0)::INT AS progress_pct,
      -- « Nombre de consultations » : deux ouvertures séparées de plus de
      -- 30 minutes comptent pour deux, un aller-retour dans la page pour une.
      COUNT(*) FILTER (WHERE gap IS NULL OR gap > c_session_gap)::INT AS views,
      MIN(occurred_at) AS first_at,
      MAX(occurred_at) AS last_at
    FROM lesson_pulses
    GROUP BY day, chapter_id
  ),
  top_lessons AS (
    SELECT * FROM per_chapter_day
    ORDER BY last_at DESC
    LIMIT c_max_rows
  )
  SELECT COALESCE(jsonb_agg(
    jsonb_build_object(
      'date', to_char(tl.day, 'YYYY-MM-DD'),
      'firstAt', to_char(tl.first_at AT TIME ZONE c_tz, 'HH24:MI'),
      'at', to_char(tl.last_at AT TIME ZONE c_tz, 'HH24:MI'),
      'chapterId', tl.chapter_id,
      'chapterTitle', COALESCE(ch.title, ''),
      'subjectId', ch.subject_id,
      'subjectName', COALESCE(sub.name_fr, ''),
      'gradeName', g.name_fr,
      'seconds', tl.seconds,
      'progressPct', tl.progress_pct,
      'views', tl.views,
      -- Le verdict « étudié » est calculé ICI et nulle part ailleurs : le même
      -- seuil sert au détail et aux totaux, ils ne peuvent pas diverger.
      'studied', (tl.seconds >= c_studied_seconds AND tl.progress_pct >= c_studied_pct)
    ) ORDER BY tl.last_at DESC
  ), '[]'::jsonb)
  INTO v_lessons
  FROM top_lessons tl
  LEFT JOIN public.chapters ch ON ch.id = tl.chapter_id
  LEFT JOIN public.subjects sub ON sub.id = ch.subject_id
  LEFT JOIN public.grades g ON g.id = sub.grade_id;

  -- -------------------------------------------------------------------------
  -- Exercices réalisés — une ligne par tentative, avec son rang et l'écart de
  -- score par rapport à la tentative précédente sur le MÊME exercice.
  -- -------------------------------------------------------------------------
  WITH ranked AS (
    SELECT
      a.id,
      a.exercise_id,
      a.completed_at,
      a.duration_seconds,
      a.score_pct,
      a.correct_count,
      a.total_count,
      a.variant,
      ROW_NUMBER() OVER (PARTITION BY a.exercise_id ORDER BY a.completed_at) AS attempt_no,
      LAG(a.score_pct) OVER (PARTITION BY a.exercise_id ORDER BY a.completed_at) AS prev_score
    -- Fenêtre sur TOUT l'historique de l'élève, filtrée ensuite sur la période :
    -- sinon « 3ᵉ tentative » redeviendrait « 1ʳᵉ » dès qu'on regarde une semaine.
    FROM public._scoped_attempts(p_student, p_subject_ids) a
    WHERE a.user_id = p_student
  ),
  top_attempts AS (
    SELECT * FROM ranked
    WHERE completed_at >= v_from_ts
      AND completed_at < v_to_ts
    ORDER BY completed_at DESC
    LIMIT c_max_rows
  )
  SELECT COALESCE(jsonb_agg(
    jsonb_build_object(
      'attemptId', ta.id,
      'date', to_char(ta.completed_at AT TIME ZONE c_tz, 'YYYY-MM-DD'),
      'at', to_char(ta.completed_at AT TIME ZONE c_tz, 'HH24:MI'),
      'exerciseId', ta.exercise_id,
      'exerciseTitle', COALESCE(e.title, ''),
      'mode', COALESCE(e.mode, 'practice'),
      'variant', ta.variant,
      'difficulty', COALESCE(e.difficulty, 0),
      'chapterId', e.chapter_id,
      'chapterTitle', COALESCE(ch.title, ''),
      'subjectId', COALESCE(e.subject_id, ch.subject_id),
      'subjectName', COALESCE(sub.name_fr, ''),
      'gradeName', g.name_fr,
      'durationSeconds', ta.duration_seconds,
      'scorePct', ROUND(ta.score_pct)::INT,
      'correct', ta.correct_count,
      'wrong', GREATEST(ta.total_count - ta.correct_count, 0),
      'total', ta.total_count,
      'attemptNo', ta.attempt_no::INT,
      -- NULL sur la première tentative : « pas de point de comparaison » n'est
      -- pas « aucune évolution ».
      'previousScorePct', CASE WHEN ta.prev_score IS NULL THEN NULL
                               ELSE ROUND(ta.prev_score)::INT END
    ) ORDER BY ta.completed_at DESC
  ), '[]'::jsonb)
  INTO v_exercises
  FROM top_attempts ta
  LEFT JOIN public.exercises e ON e.id = ta.exercise_id
  LEFT JOIN public.chapters ch ON ch.id = e.chapter_id
  LEFT JOIN public.subjects sub ON sub.id = COALESCE(e.subject_id, ch.subject_id)
  LEFT JOIN public.grades g ON g.id = sub.grade_id;

  -- -------------------------------------------------------------------------
  -- Par matière : temps mesuré, cours, exercices, réussite, et l'écart de score
  -- avec la période précédente (la colonne « Progression » du tableau).
  -- -------------------------------------------------------------------------
  -- La matière d'un pouls se retrouve de trois façons : celle que le client a
  -- envoyée, sinon celle de l'exercice, sinon celle du chapitre. Un écran qui
  -- ne connaît que son exercice n'a donc rien à savoir du catalogue.
  WITH subject_time AS (
    SELECT
      COALESCE(lp.subject_id, e.subject_id, ch.subject_id) AS subject_id,
      SUM(lp.active_seconds)::INT AS seconds
    FROM public._scoped_pulses(p_student, p_subject_ids) lp
    LEFT JOIN public.exercises e ON e.id = lp.exercise_id
    LEFT JOIN public.chapters ch ON ch.id = lp.chapter_id
    WHERE lp.user_id = p_student
      AND lp.surface <> 'browse'
      AND lp.occurred_at >= v_from_ts
      AND lp.occurred_at < v_to_ts
      AND COALESCE(lp.subject_id, e.subject_id, ch.subject_id) IS NOT NULL
    GROUP BY COALESCE(lp.subject_id, e.subject_id, ch.subject_id)
  ),
  subject_lessons AS (
    SELECT ch.subject_id, COUNT(DISTINCT lp.chapter_id)::INT AS lessons
    FROM public._scoped_pulses(p_student, p_subject_ids) lp
    JOIN public.chapters ch ON ch.id = lp.chapter_id
    WHERE lp.user_id = p_student
      AND lp.surface = 'lesson'
      AND lp.occurred_at >= v_from_ts
      AND lp.occurred_at < v_to_ts
    GROUP BY ch.subject_id
  ),
  subject_attempts AS (
    SELECT
      subject_id,
      COUNT(*) FILTER (WHERE completed_at >= v_from_ts)::INT AS exercises,
      ROUND(AVG(score_pct) FILTER (WHERE completed_at >= v_from_ts))::INT AS avg_score,
      ROUND(AVG(score_pct) FILTER (WHERE completed_at < v_from_ts))::INT AS prev_avg_score,
      COUNT(*) FILTER (WHERE completed_at < v_from_ts)::INT AS prev_exercises
    FROM public._scoped_attempts(p_student, p_subject_ids)
    WHERE user_id = p_student
      AND completed_at >= v_prev_from_ts
      AND completed_at < v_to_ts
    GROUP BY subject_id
  ),
  rows_subjects AS (
    SELECT
      sub.id,
      sub.name_fr,
      sub.color_token,
      g.name_fr AS grade_name,
      COALESCE(st.seconds, 0) AS seconds,
      COALESCE(sl.lessons, 0) AS lessons,
      COALESCE(sa.exercises, 0) AS exercises,
      COALESCE(sa.avg_score, 0) AS avg_score,
      COALESCE(sa.prev_exercises, 0) AS prev_exercises,
      COALESCE(cov.chapters_total, 0) AS chapters_total,
      COALESCE(cov.chapters_completed, 0) AS chapters_completed,
      CASE WHEN COALESCE(sa.prev_exercises, 0) = 0 THEN NULL
           ELSE sa.avg_score - sa.prev_avg_score END AS score_delta
    FROM public.subjects sub
    LEFT JOIN public.grades g ON g.id = sub.grade_id
    -- Couverture du programme : la MÊME règle que la carte /parcours de l'élève.
    LEFT JOIN LATERAL (
      SELECT pp.chapters_total, pp.chapters_completed
        FROM public.student_parcours_progress(p_student, ARRAY[sub.id]) pp
    ) cov ON TRUE
    LEFT JOIN subject_time st ON st.subject_id = sub.id
    LEFT JOIN subject_lessons sl ON sl.subject_id = sub.id
    LEFT JOIN subject_attempts sa ON sa.subject_id = sub.id
    -- Une matière travaillée la période PRÉCÉDENTE et plus du tout maintenant
    -- doit rester dans la liste : c'est exactement le signal « matière
    -- délaissée ». Sans elle, la matière disparaîtrait au lieu d'alerter.
    WHERE COALESCE(st.seconds, 0) > 0
       OR COALESCE(sl.lessons, 0) > 0
       OR COALESCE(sa.exercises, 0) > 0
       OR COALESCE(sa.prev_exercises, 0) > 0
    ORDER BY COALESCE(st.seconds, 0) DESC, COALESCE(sa.exercises, 0) DESC, sub.name_fr
    LIMIT 60
  )
  SELECT COALESCE(jsonb_agg(
    jsonb_build_object(
      'subjectId', rs.id,
      'name', rs.name_fr,
      'colorToken', rs.color_token,
      'gradeName', rs.grade_name,
      'minutes', ROUND(rs.seconds::NUMERIC / 60)::INT,
      'lessons', rs.lessons,
      'exercises', rs.exercises,
      'previousExercises', rs.prev_exercises,
      'chaptersTotal', rs.chapters_total,
      'chaptersCompleted', rs.chapters_completed,
      'avgScore', rs.avg_score,
      -- NULL (et non 0) quand il n'y a pas de période précédente comparable.
      'scoreDelta', rs.score_delta
    ) ORDER BY rs.seconds DESC, rs.exercises DESC, rs.name_fr
  ), '[]'::jsonb)
  INTO v_subjects
  FROM rows_subjects rs;

  -- -------------------------------------------------------------------------
  -- Par chapitre : la granularité qui rend une recommandation actionnable
  -- (« les fractions restent à 58 % »).
  -- -------------------------------------------------------------------------
  WITH rows_chapters AS (
    SELECT
      ch.id,
      ch.title,
      sub.id AS subject_id,
      sub.name_fr AS subject_name,
      COUNT(a.*)::INT AS exercises,
      ROUND(AVG(a.score_pct))::INT AS avg_score,
      SUM(a.correct_count)::INT AS correct,
      SUM(a.total_count)::INT AS questions
    FROM public._scoped_attempts(p_student, p_subject_ids) a
    JOIN public.exercises e ON e.id = a.exercise_id
    JOIN public.chapters ch ON ch.id = e.chapter_id
    JOIN public.subjects sub ON sub.id = ch.subject_id
    WHERE a.user_id = p_student
      AND a.completed_at >= v_from_ts
      AND a.completed_at < v_to_ts
    GROUP BY ch.id, ch.title, sub.id, sub.name_fr
    ORDER BY ROUND(AVG(a.score_pct)), COUNT(a.*) DESC
    LIMIT 60
  )
  SELECT COALESCE(jsonb_agg(
    jsonb_build_object(
      'chapterId', rc.id,
      'title', rc.title,
      'subjectId', rc.subject_id,
      'subjectName', rc.subject_name,
      'exercises', rc.exercises,
      'avgScore', rc.avg_score,
      'correct', rc.correct,
      'questions', rc.questions
    ) ORDER BY rc.avg_score, rc.exercises DESC
  ), '[]'::jsonb)
  INTO v_chapters
  FROM rows_chapters rc;

  -- -------------------------------------------------------------------------
  -- Totaux de la période, puis les MÊMES totaux sur la période précédente.
  -- -------------------------------------------------------------------------
  v_totals := public.student_activity_totals(
    p_student, v_from_ts, v_to_ts, c_tz, c_session_gap,
    c_pass_pct, c_studied_seconds, c_studied_pct, p_subject_ids
  );
  v_previous := public.student_activity_totals(
    p_student, v_prev_from_ts, v_from_ts, c_tz, c_session_gap,
    c_pass_pct, c_studied_seconds, c_studied_pct, p_subject_ids
  );

  RETURN jsonb_build_object(
    'student', jsonb_build_object(
      'displayName', v_student.display_name,
      'level', v_student.level,
      'currentStreak', v_student.current_streak,
      'longestStreak', v_student.longest_streak,
      'lastActiveDate', v_student.last_active_date
    ),
    'range', jsonb_build_object(
      'from', to_char(v_from, 'YYYY-MM-DD'),
      'to', to_char(v_to, 'YYYY-MM-DD'),
      'days', v_span,
      'timezone', c_tz,
      -- Depuis quand le temps est réellement mesuré : avant cette date, les
      -- durées valent 0 parce que rien ne les enregistrait, pas parce que
      -- l'enfant n'a rien fait. Le tableau de bord doit pouvoir le dire.
      'measuredSince', CASE WHEN v_measured_since IS NULL THEN NULL
                            ELSE to_char(v_measured_since AT TIME ZONE c_tz, 'YYYY-MM-DD') END
    ),
    -- Le périmètre appliqué, et surtout CE QU'IL MET DE CÔTÉ. Un filtre qui
    -- cache sans le dire ferait croire à une baisse d'activité.
    'scope', jsonb_build_object(
      'applied', CASE WHEN p_subject_ids IS NULL THEN 'all' ELSE 'class' END,
      'gradeId', v_grade_id,
      'gradeName', v_grade_name,
      'hasClass', (v_grade_id IS NOT NULL),
      'excludedMinutes', v_excluded_minutes,
      'excludedExercises', v_excluded_exercises
    ),
    'thresholds', jsonb_build_object(
      'passPct', c_pass_pct,
      'studiedSeconds', c_studied_seconds,
      'studiedPct', c_studied_pct,
      'sessionGapMinutes', 30
    ),
    'days', v_days,
    'lessons', v_lessons,
    'exercises', v_exercises,
    'subjects', v_subjects,
    'chapters', v_chapters,
    'totals', v_totals,
    'previous', v_previous
  );
END;
$fn$;

REVOKE EXECUTE ON FUNCTION public._student_daily_report_json(UUID, DATE, DATE, TEXT[])
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 4. Les matières de la classe d'un élève — ce que les enveloppes passent en
--    périmètre quand le parent demande « sa classe ».
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public._student_class_subject_ids(p_student UUID)
RETURNS TEXT[]
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  SELECT CASE
    WHEN p.current_grade_id IS NULL THEN NULL
    ELSE COALESCE(
      (SELECT array_agg(s.id) FROM public.subjects s WHERE s.grade_id = p.current_grade_id),
      ARRAY[]::TEXT[]
    )
  END
    FROM public.profiles p
   WHERE p.id = p_student;
$fn$;

REVOKE EXECUTE ON FUNCTION public._student_class_subject_ids(UUID)
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 5. Les enveloppes reçoivent le périmètre. `p_scope` vaut 'all' (défaut,
--    comportement inchangé) ou 'class'. Un élève sans classe retombe sur 'all' :
--    filtrer sur rien afficherait un tableau vide sans raison lisible.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_student_daily_report(
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
BEGIN
  PERFORM public.assert_can_read_student_activity(p_student);
  RETURN public._student_daily_report_json(
    p_student, p_from, p_to,
    CASE WHEN p_scope = 'class' THEN public._student_class_subject_ids(p_student) ELSE NULL END
  );
END;
$fn$;

REVOKE EXECUTE ON FUNCTION public.get_student_daily_report(UUID, DATE, DATE, TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_student_daily_report(UUID, DATE, DATE, TEXT) TO authenticated;

CREATE OR REPLACE FUNCTION public.get_student_daily_report_by_code(
  p_code TEXT,
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
  v_student UUID;
BEGIN
  v_student := public._student_id_from_alliance_code(p_code);
  RETURN public._student_daily_report_json(
    v_student, p_from, p_to,
    CASE WHEN p_scope = 'class' THEN public._student_class_subject_ids(v_student) ELSE NULL END
  );
END;
$fn$;

REVOKE EXECUTE ON FUNCTION public.get_student_daily_report_by_code(TEXT, DATE, DATE, TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_student_daily_report_by_code(TEXT, DATE, DATE, TEXT)
  TO anon, authenticated;

-- ---------------------------------------------------------------------------
-- 6. Ce qui est retiré, et surtout ce qui ne l'est PAS.
--
-- Les deux fonctions INTERNES à l'ancienne arité disparaissent : elles ne sont
-- appelées que d'ici, et leurs remplaçantes portent une valeur par défaut, donc
-- les appels à l'ancienne arité s'y résolvent sans ambiguïté.
DROP FUNCTION IF EXISTS public._student_daily_report_json(UUID, DATE, DATE);
DROP FUNCTION IF EXISTS public.student_activity_totals(
  UUID, TIMESTAMPTZ, TIMESTAMPTZ, TEXT, INTERVAL, INT, INT, INT);

-- Les deux enveloppes PUBLIQUES à 3 arguments, elles, RESTENT (DoD §7). C'est le
-- client actuellement déployé qui les appelle : les retirer ici casserait la prod
-- pendant tout l'intervalle entre cette migration et le déploiement du nouveau
-- client. Elles se résolvent désormais vers le calcul scopé avec un périmètre
-- nul, donc comportement inchangé. Leur suppression est un lot destructif à part,
-- à livrer une fois le client passé aux 4 arguments.
