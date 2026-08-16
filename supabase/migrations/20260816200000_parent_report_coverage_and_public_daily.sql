-- Suivi parental — couverture du programme, matières désambiguïsées, et le
-- tableau de bord quotidien ouvert au rapport public par code alliance.
--
-- TROIS CHOSES, ET LEUR POURQUOI
-- ---------------------------------------------------------------------------
-- 1. « Mathématiques » apparaissait QUATRE FOIS dans le bilan, sans rien pour les
--    distinguer. Les matières sont propres à un niveau (`math-6`, `math-9`…) et
--    l'affichage ne montrait que `name_fr`. Le niveau existe (`subjects.grade_id`),
--    il n'était simplement jamais remonté. Il l'est maintenant, partout.
--
-- 2. COUVERTURE DU PROGRAMME par matière. Aucune règle nouvelle : on réutilise
--    celle qui fait déjà autorité pour la carte /parcours et le hub matière
--    (`get_user_parcours_progress`, 20260720120000, et son miroir client
--    `src/shared/lib/chapter-completion.ts`). Cette migration l'EXTRAIT dans
--    `student_parcours_progress(p_user, …)` et rebranche la RPC existante dessus :
--    une seule définition, deux appelants. Le commentaire du lot 22 exigeait que
--    les deux restent d'accord — le plus sûr est qu'ils soient le même code.
--
-- 3. LE RAPPORT QUOTIDIEN PASSE AU CHEMIN PUBLIC (décision produit, 2026-08-16).
--    Le parent qui ouvre `/suivi` avec le code alliance voit désormais le même
--    tableau de bord que le parent connecté, détail des réponses compris. C'est un
--    accès AU PORTEUR assumé, comme le bilan depuis 20260708120000 : quiconque
--    détient le code voit tout. Le code fait 122 bits aléatoires et c'est l'élève
--    qui le transmet.
--    ⚠️ UNE SEULE CHOSE RESTE MASQUÉE, et ce n'est pas de la confidentialité : la
--    correction d'un quiz de compréhension. C'est l'anti-mémorisation du verrou de
--    chapitre — un élève ouvrirait sinon la correction de son propre quiz avec son
--    propre code, et repasserait le verrou de tête.
--
-- FORME : on suit le patron déjà en place pour le bilan (20260708120000) —
-- un calcul PUR interne, sans aucun contrôle d'accès, et deux enveloppes qui
-- décident qui a le droit. Les corps de calcul sont ceux de 20260816180100,
-- inchangés à l'exception des ajouts de couverture.

-- ---------------------------------------------------------------------------
-- 1. La progression d'une matière, ouverte à un élève tiers.
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
  gated AS (
    SELECT
      p.chapter_id,
      (s.grade_id IS NOT NULL AND q.id IS NOT NULL) AS quiz_gated,
      q.id AS quiz_id
      FROM published p
      JOIN public.subjects s ON s.id = p.subject_id
      LEFT JOIN LATERAL (
        SELECT e.id
          FROM public.exercises e
         WHERE e.chapter_id = p.chapter_id
           AND e.mode = 'quiz'
         LIMIT 1
      ) q ON TRUE
  ),
  completed AS (
    SELECT g.chapter_id
      FROM gated g
     WHERE (
       NOT g.quiz_gated
       OR EXISTS (
         SELECT 1
           FROM public.attempts a
          WHERE a.user_id = p_user
            AND a.exercise_id = g.quiz_id
            AND a.score_pct >= 80
            AND a.duration_seconds >= a.total_count * 4
       )
     )
     AND NOT EXISTS (
       SELECT 1
         FROM public.exercises e
        WHERE e.chapter_id = g.chapter_id
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

-- Interne : seules les fonctions du rapport (définer) l'appellent.
REVOKE EXECUTE ON FUNCTION public.student_parcours_progress(UUID, TEXT[])
  FROM PUBLIC, anon, authenticated;

-- La RPC de l'élève délègue désormais — une seule définition de « chapitre terminé ».
CREATE OR REPLACE FUNCTION public.get_user_parcours_progress(p_subject_ids TEXT[] DEFAULT NULL)
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
  SELECT * FROM public.student_parcours_progress((SELECT auth.uid()), p_subject_ids);
$fn$;

REVOKE ALL ON FUNCTION public.get_user_parcours_progress(TEXT[]) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_user_parcours_progress(TEXT[]) TO authenticated;

-- ---------------------------------------------------------------------------
-- 2. Le décodage du code alliance — extrait pour être partagé par les trois
--    enveloppes publiques au lieu d'être recopié dans chacune.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public._student_id_from_alliance_code(p_code TEXT)
RETURNS UUID
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_hex TEXT;
  v_student UUID;
  v_role TEXT;
BEGIN
  v_hex := lower(regexp_replace(p_code, '[^a-fA-F0-9]', '', 'g'));
  IF v_hex !~ '^[0-9a-f]{32}$' THEN
    RAISE EXCEPTION 'Invalid student alliance code.';
  END IF;
  v_student := (
    substr(v_hex, 1, 8) || '-' || substr(v_hex, 9, 4) || '-' || substr(v_hex, 13, 4)
    || '-' || substr(v_hex, 17, 4) || '-' || substr(v_hex, 21, 12)
  )::uuid;

  SELECT role INTO v_role FROM public.profiles WHERE id = v_student;
  IF v_role IS NULL THEN
    RAISE EXCEPTION 'Student not found.';
  END IF;
  IF v_role IS DISTINCT FROM 'student' THEN
    RAISE EXCEPTION 'This code does not belong to a student account.';
  END IF;

  RETURN v_student;
END;
$fn$;

REVOKE EXECUTE ON FUNCTION public._student_id_from_alliance_code(TEXT)
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 3. Le rapport quotidien — calcul PUR (aucun contrôle d'accès).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public._student_daily_report_json(
  p_student UUID,
  p_from DATE,
  p_to DATE
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
$fn$;

REVOKE EXECUTE ON FUNCTION public._student_daily_report_json(UUID, DATE, DATE)
  FROM PUBLIC, anon, authenticated;

-- Enveloppe authentifiée — contrôles inchangés.
CREATE OR REPLACE FUNCTION public.get_student_daily_report(
  p_student UUID,
  p_from DATE,
  p_to DATE
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
BEGIN
  PERFORM public.assert_can_read_student_activity(p_student);
  RETURN public._student_daily_report_json(p_student, p_from, p_to);
END;
$fn$;

REVOKE EXECUTE ON FUNCTION public.get_student_daily_report(UUID, DATE, DATE) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_student_daily_report(UUID, DATE, DATE) TO authenticated;

-- Enveloppe publique par code alliance.
CREATE OR REPLACE FUNCTION public.get_student_daily_report_by_code(
  p_code TEXT,
  p_from DATE,
  p_to DATE
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
BEGIN
  RETURN public._student_daily_report_json(
    public._student_id_from_alliance_code(p_code), p_from, p_to
  );
END;
$fn$;

REVOKE EXECUTE ON FUNCTION public.get_student_daily_report_by_code(TEXT, DATE, DATE) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_student_daily_report_by_code(TEXT, DATE, DATE)
  TO anon, authenticated;

-- ---------------------------------------------------------------------------
-- 4. Le détail d'une tentative — calcul PUR, puis les deux enveloppes.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public._student_attempt_detail_json(
  p_student UUID,
  p_attempt UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
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
$fn$;

REVOKE EXECUTE ON FUNCTION public._student_attempt_detail_json(UUID, UUID)
  FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.get_student_attempt_detail(
  p_student UUID,
  p_attempt UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
BEGIN
  PERFORM public.assert_can_read_student_activity(p_student);
  RETURN public._student_attempt_detail_json(p_student, p_attempt);
END;
$fn$;

REVOKE EXECUTE ON FUNCTION public.get_student_attempt_detail(UUID, UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_student_attempt_detail(UUID, UUID) TO authenticated;

CREATE OR REPLACE FUNCTION public.get_student_attempt_detail_by_code(
  p_code TEXT,
  p_attempt UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
BEGIN
  RETURN public._student_attempt_detail_json(
    public._student_id_from_alliance_code(p_code), p_attempt
  );
END;
$fn$;

REVOKE EXECUTE ON FUNCTION public.get_student_attempt_detail_by_code(TEXT, UUID) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_student_attempt_detail_by_code(TEXT, UUID)
  TO anon, authenticated;

-- ---------------------------------------------------------------------------
-- 5. Le BILAN reçoit le niveau et la couverture.
--    Même corps qu'en 20260708120000, aux seuls ajouts près dans subjectStats.
-- ---------------------------------------------------------------------------
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
    LEFT JOIN LATERAL (
      SELECT pp.chapters_total, pp.chapters_completed
        FROM public.student_parcours_progress(p_student, ARRAY[sub.id]) pp
    ) cov ON TRUE
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
