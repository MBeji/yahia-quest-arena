-- Suivi parental « jour par jour » — lot 2 : les FAITS.
--
-- Deux RPC, aucune règle de jugement.
--   * get_student_daily_report(élève, du, au) — tout ce qui est MESURÉ : le temps
--     (depuis learning_pulses), les cours consultés, les exercices réalisés, les
--     agrégats par matière et par chapitre, et la période précédente de même
--     longueur pour la progression.
--   * get_student_attempt_detail(élève, tentative) — le détail question par
--     question d'une tentative : ce que l'enfant a répondu.
--
-- Les INDICES (engagement, efficacité, alertes) ne sont volontairement PAS
-- calculés ici : ce sont des règles produit qui vont bouger, qui doivent être
-- explicables au parent facteur par facteur, et qui méritent des tests unitaires
-- lisibles. Ils vivent en TypeScript pur dans
-- `src/features/parent-report/insights/`. Cette migration ne renvoie que des
-- faits — c'est aussi ce qui rendra une couche d'insights IA possible plus tard
-- sans retoucher le SQL.
--
-- FUSEAU HORAIRE
-- ---------------------------------------------------------------------------
-- Un tableau de bord QUOTIDIEN ne peut pas découper les journées en UTC : une
-- révision de 22 h 30 à Tunis (UTC+1) tomberait le lendemain, et « heure de
-- première connexion » serait fausse d'une heure. Tout le découpage se fait donc
-- en heure locale tunisienne. Le pays n'observe plus l'heure d'été depuis 2009,
-- mais on passe quand même par le fuseau nommé (et non un décalage fixe) pour ne
-- pas figer une décision politique dans du SQL.
--
-- ACCÈS
-- ---------------------------------------------------------------------------
-- Mêmes règles que `get_student_report` : admin, ou parent EFFECTIVEMENT lié à
-- l'élève. Rien de tout ceci n'est exposé au chemin public par code alliance
-- (`get_student_report_by_code`) : le code est une capacité au porteur, et
-- l'activité minute par minute d'un mineur — a fortiori ses réponses — n'a rien
-- à faire derrière un simple code partageable.
--
-- ⚠️ AMENDÉ LE JOUR MÊME — ne pas lire le paragraphe ci-dessus comme l'état
-- courant. `20260816200000_parent_report_coverage_and_public_daily.sql` (§3) a
-- renversé cette règle sur décision produit : le rapport quotidien ET le détail
-- des tentatives SONT exposés au chemin public par code alliance, par les
-- enveloppes `get_student_daily_report_by_code` /
-- `get_student_attempt_detail_by_code`. Le pourquoi est dans l'en-tête de cette
-- migration-là et dans `docs/suivi-parental-quotidien.md`. (Note ajoutée après
-- coup ; le SQL de ce fichier, appliqué en prod, n'a pas bougé.)

-- ---------------------------------------------------------------------------
-- 1. Garde d'accès partagée par les deux RPC.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.assert_can_read_student_activity(p_student UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_role TEXT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT role INTO v_role FROM public.profiles WHERE id = v_user;

  IF v_role IS DISTINCT FROM 'admin' AND v_role IS DISTINCT FROM 'parent' THEN
    RAISE EXCEPTION 'Access denied.';
  END IF;

  IF v_role = 'parent' AND NOT public.is_parent_of_student(v_user, p_student) THEN
    RAISE EXCEPTION 'Access denied: you are not linked to this student.';
  END IF;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.assert_can_read_student_activity(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.assert_can_read_student_activity(UUID) TO authenticated;

-- ---------------------------------------------------------------------------
-- 2. Les totaux d'une fenêtre — extraits pour être appelés DEUX fois (période
--    courante et période précédente) sans dupliquer une ligne d'agrégat.
--    Fonction interne : aucun rôle client ne peut l'exécuter, seule
--    get_student_daily_report l'appelle (et a déjà vérifié l'accès).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.student_activity_totals(
  p_student UUID,
  p_from TIMESTAMPTZ,
  p_to TIMESTAMPTZ,
  p_tz TEXT,
  p_session_gap INTERVAL,
  p_pass_pct INT,
  p_studied_seconds INT,
  p_studied_pct INT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
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
    FROM public.learning_pulses
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
    FROM public.learning_pulses
    WHERE user_id = p_student AND occurred_at >= p_from AND occurred_at < p_to
    UNION
    SELECT (completed_at AT TIME ZONE p_tz)::DATE
    FROM public.attempts
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
  FROM public.attempts
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
    FROM public.learning_pulses
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
    FROM public.attempts
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
$$;

REVOKE EXECUTE ON FUNCTION
  public.student_activity_totals(UUID, TIMESTAMPTZ, TIMESTAMPTZ, TEXT, INTERVAL, INT, INT, INT)
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 3. Le rapport quotidien.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_student_daily_report(
  p_student UUID,
  p_from DATE,
  p_to DATE
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
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
  v_measured_since TIMESTAMPTZ;
  v_days JSONB := '[]'::jsonb;
  v_lessons JSONB := '[]'::jsonb;
  v_exercises JSONB := '[]'::jsonb;
  v_subjects JSONB := '[]'::jsonb;
  v_chapters JSONB := '[]'::jsonb;
  v_totals JSONB;
  v_previous JSONB;
BEGIN
  PERFORM public.assert_can_read_student_activity(p_student);

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

  SELECT MIN(occurred_at) INTO v_measured_since
  FROM public.learning_pulses
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
    FROM public.learning_pulses
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
    FROM public.attempts
    WHERE user_id = p_student
      AND completed_at >= v_from_ts
      AND completed_at < v_to_ts
    GROUP BY (completed_at AT TIME ZONE c_tz)::DATE
  ),
  lesson_days AS (
    SELECT
      (occurred_at AT TIME ZONE c_tz)::DATE AS day,
      COUNT(DISTINCT chapter_id)::INT AS chapters_read
    FROM public.learning_pulses
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
    FROM public.learning_pulses lp
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
    FROM public.attempts a
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
    FROM public.learning_pulses lp
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
    FROM public.learning_pulses lp
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
    FROM public.attempts
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
      CASE WHEN COALESCE(sa.prev_exercises, 0) = 0 THEN NULL
           ELSE sa.avg_score - sa.prev_avg_score END AS score_delta
    FROM public.subjects sub
    LEFT JOIN public.grades g ON g.id = sub.grade_id
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
    FROM public.attempts a
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
    c_pass_pct, c_studied_seconds, c_studied_pct
  );
  v_previous := public.student_activity_totals(
    p_student, v_prev_from_ts, v_from_ts, c_tz, c_session_gap,
    c_pass_pct, c_studied_seconds, c_studied_pct
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
$$;

REVOKE EXECUTE ON FUNCTION public.get_student_daily_report(UUID, DATE, DATE) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_student_daily_report(UUID, DATE, DATE) TO authenticated;

-- ---------------------------------------------------------------------------
-- 4. Le détail d'une tentative — ce que l'enfant a répondu, question par question.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_student_attempt_detail(
  p_student UUID,
  p_attempt UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  c_tz CONSTANT TEXT := 'Africa/Tunis';
  v_attempt public.attempts;
  v_exercise public.exercises;
  v_chapter public.chapters;
  v_subject public.subjects;
  v_session UUID;
  v_is_quiz BOOLEAN;
  v_questions JSONB := '[]'::jsonb;
BEGIN
  PERFORM public.assert_can_read_student_activity(p_student);

  SELECT * INTO v_attempt
  FROM public.attempts
  WHERE id = p_attempt AND user_id = p_student;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Attempt not found.';
  END IF;

  SELECT * INTO v_exercise FROM public.exercises WHERE id = v_attempt.exercise_id;
  SELECT * INTO v_chapter FROM public.chapters WHERE id = v_exercise.chapter_id;
  SELECT * INTO v_subject FROM public.subjects
  WHERE id = COALESCE(v_exercise.subject_id, v_chapter.subject_id);

  -- Un quiz de compréhension ne révèle JAMAIS sa correction (garde
  -- anti-mémorisation de 20260610170000). La règle vaut aussi côté parent :
  -- rien n'empêche un élève d'ouvrir un compte parent et de s'y lier avec son
  -- propre code alliance. Le parent voit donc ce que l'enfant a répondu et si
  -- c'était juste, mais pas la bonne réponse ni l'explication.
  v_is_quiz := COALESCE(v_exercise.mode, '') = 'quiz';

  -- `attempts.session_id` (20260816170000) est la bonne source — mais la colonne
  -- est encore NULL partout : son écrivain et son backfill arrivent dans une
  -- livraison séparée. Tant qu'elle l'est, on retombe sur la session TERMINÉE du
  -- même couple (élève, exercice) la plus proche dans le temps : les deux
  -- écritures ont lieu dans la même transaction, à quelques millisecondes l'une
  -- de l'autre. Ce repli est exactement celui que le COMMENT de la colonne
  -- annonce ; il devient inerte tout seul, ligne par ligne, à mesure que la
  -- colonne se remplit — aucun code à retoucher ici.
  v_session := v_attempt.session_id;

  IF v_session IS NULL THEN
    SELECT s.id INTO v_session
    FROM public.exercise_sessions s
    WHERE s.user_id = p_student
      AND s.exercise_id = v_attempt.exercise_id
      AND s.completed_at IS NOT NULL
    ORDER BY ABS(EXTRACT(EPOCH FROM (s.completed_at - v_attempt.completed_at)))
    LIMIT 1;
  END IF;

  IF v_session IS NOT NULL THEN
    SELECT COALESCE(jsonb_agg(
      jsonb_build_object(
        'questionId', q.id,
        'order', q.display_order,
        'prompt', q.prompt,
        'questionType', q.question_type,
        'options', q.options,
        'answer', qa.choice,
        'isCorrect', qa.is_correct,
        'correctOption', CASE WHEN v_is_quiz THEN NULL ELSE q.correct_option END,
        'explanation', CASE WHEN v_is_quiz THEN NULL ELSE q.explanation END
      ) ORDER BY q.display_order
    ), '[]'::jsonb)
    INTO v_questions
    FROM public.question_attempts qa
    JOIN public.questions q ON q.id = qa.question_id
    WHERE qa.session_id = v_session
      AND qa.user_id = p_student;
  END IF;

  RETURN jsonb_build_object(
    'attemptId', v_attempt.id,
    'exerciseId', v_attempt.exercise_id,
    'exerciseTitle', COALESCE(v_exercise.title, ''),
    'mode', COALESCE(v_exercise.mode, 'practice'),
    'difficulty', COALESCE(v_exercise.difficulty, 0),
    'chapterId', v_exercise.chapter_id,
    'chapterTitle', COALESCE(v_chapter.title, ''),
    'subjectName', COALESCE(v_subject.name_fr, ''),
    'contentLanguage', COALESCE(v_subject.content_language, 'fr'),
    'completedAt', to_char(v_attempt.completed_at AT TIME ZONE c_tz, 'YYYY-MM-DD HH24:MI'),
    'durationSeconds', v_attempt.duration_seconds,
    'scorePct', ROUND(v_attempt.score_pct)::INT,
    'correct', v_attempt.correct_count,
    'total', v_attempt.total_count,
    -- Le client doit pouvoir DIRE pourquoi la correction est absente, au lieu
    -- d'afficher une liste vide sans explication.
    'reviewHidden', v_is_quiz,
    'questions', v_questions
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.get_student_attempt_detail(UUID, UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_student_attempt_detail(UUID, UUID) TO authenticated;
