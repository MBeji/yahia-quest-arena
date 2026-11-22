-- =========================================================
-- Bilan et programme du jour — une seule passe sur les chapitres.
-- ---------------------------------------------------------
-- MESURÉ EN PRODUCTION le 2026-11-22, juste après 20261122160000 : `get_study_report`
-- rend en ~205 ms à chaud sur un élève de 9ᵉ (98 chapitres, 896 missions), dont
-- ~130 ms dans `student_study_chapters` — appelée DEUX fois (une pour le bilan, une
-- dans le programme), et dont chaque étage, écrit en CTE simple, était replié par le
-- planificateur : `chapter_quiz_gated` et `chapter_quiz_cleared` (48 ms à elles deux)
-- se réévaluaient à chaque endroit où leur colonne était lue. Or cette lecture part
-- dans la première vague du tableau de bord, à chaque connexion.
--
-- DEUX CORRECTIONS, aucune règle changée :
--
--   1. `student_study_chapters` : ses étages sont `MATERIALIZED` — chaque fonction
--      est évaluée une fois par chapitre. Corps identique à sa révision vivante
--      (20261122160000), à ces quatre mots près.
--
--   2. Les chapitres sont calculés UNE fois par lecture. Le corps du programme
--      passe dans `student_study_plan_from`, qui les reçoit ; `student_study_plan`
--      en devient l'enveloppe (même signature, mêmes résultats — le pgTAP 116 la
--      teste telle quelle) et `get_study_report` passe les siens.
--
-- Le contrat de la RPC ne bouge pas d'une clé. Additive ; aucune donnée écrite.
-- =========================================================

CREATE OR REPLACE FUNCTION public.student_study_chapters(
  p_user UUID,
  p_subject_ids TEXT[],
  p_day DATE
)
RETURNS TABLE (
  subject_id       TEXT,
  chapter_id       UUID,
  title            TEXT,
  chapter_rank     INT,
  chapters_total   INT,
  declared         BOOLEAN,
  seen             BOOLEAN,
  star             SMALLINT,
  started          BOOLEAN,
  missions_total   INT,
  missions_counted INT,
  missions_failed  INT,
  quiz_gated       BOOLEAN,
  quiz_cleared     BOOLEAN,
  next_star        SMALLINT,
  missing_for_next INT,
  status           TEXT
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  WITH tried AS (
    SELECT a.exercise_id
      FROM public.attempts a
     WHERE a.user_id = p_user
     GROUP BY a.exercise_id
  ),
  missions AS (
    SELECT
      c.id AS chapter_id,
      c.subject_id,
      c.title,
      c.display_order,
      LEAST(GREATEST(e.difficulty, 1), 4)::SMALLINT AS difficulty,
      (t.exercise_id IS NOT NULL) AS tried,
      (t.exercise_id IS NOT NULL AND public.mission_is_counted(p_user, e.id)) AS counted
      FROM public.chapters c
      JOIN public.exercises e
        ON e.chapter_id = c.id
       AND e.source = 'admin'
       AND e.mode IS DISTINCT FROM 'quiz'
      LEFT JOIN tried t ON t.exercise_id = e.id
     WHERE c.subject_id = ANY (p_subject_ids)
  ),
  rolled AS MATERIALIZED (
    SELECT
      m.subject_id,
      m.chapter_id,
      m.title,
      m.display_order,
      count(*)::INT AS missions_total,
      count(*) FILTER (WHERE m.counted)::INT AS missions_counted,
      count(*) FILTER (WHERE m.tried AND NOT m.counted)::INT AS missions_failed
      FROM missions m
     GROUP BY m.subject_id, m.chapter_id, m.title, m.display_order
  ),
  ranked AS MATERIALIZED (
    SELECT
      r.*,
      row_number() OVER (PARTITION BY r.subject_id ORDER BY r.display_order, r.chapter_id)::INT AS chapter_rank,
      count(*) OVER (PARTITION BY r.subject_id)::INT AS chapters_total,
      EXISTS (
        SELECT 1
          FROM public.student_class_chapters k
          JOIN public.chapters kc ON kc.id = k.chapter_id
         WHERE k.user_id = p_user AND kc.subject_id = r.subject_id
      ) AS declared,
      EXISTS (
        SELECT 1 FROM public.student_class_chapters k
         WHERE k.user_id = p_user AND k.chapter_id = r.chapter_id
      ) AS marked
      FROM rolled r
  ),
  scoped AS MATERIALIZED (
    SELECT
      k.*,
      -- Déclaré : ce que l'élève a coché, rien d'autre. Sinon : le calendrier.
      CASE
        WHEN k.declared THEN k.marked
        ELSE k.chapter_rank <= GREATEST(1, CEIL(public.school_year_share(p_day) * k.chapters_total)::INT)
      END AS seen,
      COALESCE((SELECT MAX(s.star) FROM public.user_chapter_stars s
                 WHERE s.user_id = p_user AND s.chapter_id = k.chapter_id), 0)::SMALLINT AS star,
      EXISTS (
        SELECT 1
          FROM public.attempts a
          JOIN public.exercises ae ON ae.id = a.exercise_id
         WHERE a.user_id = p_user AND ae.chapter_id = k.chapter_id
      ) AS started,
      public.chapter_quiz_gated(k.chapter_id) AS quiz_gated,
      public.chapter_quiz_cleared(p_user, k.chapter_id) AS quiz_cleared
      FROM ranked k
  ),
  aimed AS MATERIALIZED (
    SELECT s.*, (LEAST(s.star, 3) + 1)::SMALLINT AS next_star
      FROM scoped s
  )
  SELECT
    a.subject_id,
    a.chapter_id,
    a.title,
    a.chapter_rank,
    a.chapters_total,
    a.declared,
    a.seen,
    a.star,
    a.started,
    a.missions_total,
    a.missions_counted,
    a.missions_failed,
    a.quiz_gated,
    a.quiz_cleared,
    a.next_star,
    -- La distance à la prochaine étoile, en gestes — la définition de
    -- `student_chapter_gaps` : les missions de difficulté <= next_star qui ne
    -- comptent pas encore, plus le quiz s'il gate et n'est pas franchi.
    (
      (SELECT count(*)::INT FROM missions m
        WHERE m.chapter_id = a.chapter_id
          AND m.difficulty <= a.next_star
          AND NOT m.counted)
      + CASE WHEN a.quiz_gated AND NOT a.quiz_cleared THEN 1 ELSE 0 END
    ) AS missing_for_next,
    CASE
      WHEN a.star >= 4 THEN 'maitrise'
      WHEN NOT a.started THEN 'non-commence'
      WHEN a.star >= 1 THEN 'acquis'
      WHEN a.missions_failed > 0 THEN 'fragile'
      ELSE 'en-cours'
    END AS status
    FROM aimed a
   ORDER BY a.subject_id, a.chapter_rank;
$fn$;

CREATE OR REPLACE FUNCTION public.student_study_plan_from(
  p_user UUID,
  p_subject_ids TEXT[],
  p_day DATE,
  p_budget_minutes INT,
  p_chapters JSONB
)
RETURNS TABLE (
  step          INT,
  exercise_id   UUID,
  title         TEXT,
  subject_id    TEXT,
  chapter_id    UUID,
  chapter_title TEXT,
  kind          TEXT,
  difficulty    SMALLINT,
  est_minutes   INT
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  WITH allch AS MATERIALIZED (
    SELECT * FROM jsonb_to_recordset(p_chapters) AS c(
      subject_id TEXT, chapter_id UUID, title TEXT, chapter_rank INT, chapters_total INT,
      declared BOOLEAN, seen BOOLEAN, star SMALLINT, started BOOLEAN,
      missions_total INT, missions_counted INT, missions_failed INT,
      quiz_gated BOOLEAN, quiz_cleared BOOLEAN, next_star SMALLINT,
      missing_for_next INT, status TEXT
    )
  ),
  ch AS (
    SELECT * FROM allch c WHERE c.seen AND c.missing_for_next > 0
  ),
  tried AS (
    SELECT
      a.exercise_id,
      bool_or((a.completed_at AT TIME ZONE 'Africa/Tunis')::date = p_day) AS today
      FROM public.attempts a
     WHERE a.user_id = p_user
     GROUP BY a.exercise_id
  ),
  cand AS (
    SELECT
      c.subject_id, c.chapter_id, c.title AS chapter_title, c.chapter_rank, c.started,
      c.missing_for_next,
      q.id AS exercise_id, q.title, 'quiz'::TEXT AS kind,
      LEAST(GREATEST(q.difficulty, 1), 4)::SMALLINT AS difficulty,
      0 AS in_chapter, q.display_order AS ex_order
      FROM ch c
      JOIN LATERAL (
        SELECT e.id, e.title, e.difficulty, e.display_order
          FROM public.exercises e
         WHERE e.chapter_id = c.chapter_id AND e.source = 'admin' AND e.mode = 'quiz'
         ORDER BY e.display_order, e.id
         LIMIT 1
      ) q ON true
     WHERE c.quiz_gated AND NOT c.quiz_cleared
    UNION ALL
    SELECT
      c.subject_id, c.chapter_id, c.title, c.chapter_rank, c.started,
      c.missing_for_next,
      e.id, e.title,
      CASE WHEN t.exercise_id IS NOT NULL THEN 'retry'
           WHEN c.started THEN 'advance'
           ELSE 'start' END,
      LEAST(GREATEST(e.difficulty, 1), 4)::SMALLINT,
      1, e.display_order
      FROM ch c
      JOIN public.exercises e
        ON e.chapter_id = c.chapter_id
       AND e.source = 'admin'
       AND e.mode IS DISTINCT FROM 'quiz'
      LEFT JOIN tried t ON t.exercise_id = e.id
     WHERE LEAST(GREATEST(e.difficulty, 1), 4) <= c.next_star
       AND NOT (t.exercise_id IS NOT NULL AND public.mission_is_counted(p_user, e.id))
  ),
  fresh AS (
    SELECT k.*
      FROM cand k
     WHERE NOT EXISTS (SELECT 1 FROM tried t WHERE t.exercise_id = k.exercise_id AND t.today)
  ),
  in_chapter AS (
    SELECT
      f.*,
      row_number() OVER (
        PARTITION BY f.chapter_id
        ORDER BY (f.kind = 'retry') DESC, f.in_chapter, f.difficulty, f.ex_order, f.exercise_id
      ) AS rn_chapter
      FROM fresh f
  ),
  in_subject AS (
    SELECT
      i.*,
      row_number() OVER (
        PARTITION BY i.subject_id
        ORDER BY (i.kind = 'retry') DESC, (NOT i.started), i.missing_for_next,
                 i.chapter_rank, i.rn_chapter
      ) AS rn_subject
      FROM in_chapter i
     WHERE i.rn_chapter <= 2
  ),
  subject_state AS (
    SELECT
      x.subject_id,
      (SELECT count(DISTINCT a.exercise_id)
         FROM public.attempts a
        WHERE a.user_id = p_user AND a.subject_id = x.subject_id
          AND (a.completed_at AT TIME ZONE 'Africa/Tunis')::date = p_day) AS done_today,
      (SELECT (max(a.completed_at) AT TIME ZONE 'Africa/Tunis')::date
         FROM public.attempts a
        WHERE a.user_id = p_user AND a.subject_id = x.subject_id) AS last_day,
      (SELECT COALESCE(sum(c.missions_counted)::NUMERIC / NULLIF(sum(c.missions_total), 0), 0)
         FROM allch c
        WHERE c.subject_id = x.subject_id AND c.seen) AS coverage
      FROM (SELECT DISTINCT i.subject_id FROM in_subject i) x
  ),
  subject_rank AS (
    SELECT
      s.subject_id,
      row_number() OVER (
        ORDER BY s.done_today, s.last_day NULLS FIRST, s.coverage,
                 array_position(p_subject_ids, s.subject_id), s.subject_id
      ) AS rk
      FROM subject_state s
  ),
  ordered AS (
    SELECT
      i.*,
      row_number() OVER (ORDER BY (r.rk > 3), i.rn_subject, r.rk) AS seq
      FROM in_subject i
      JOIN subject_rank r ON r.subject_id = i.subject_id
     WHERE i.rn_subject <= 3
  ),
  timed AS (
    SELECT o.*, public.study_exercise_minutes(n.questions, o.difficulty) AS est
      FROM ordered o
      CROSS JOIN LATERAL (
        SELECT count(*)::INT AS questions FROM public.questions q WHERE q.exercise_id = o.exercise_id
      ) n
     WHERE n.questions > 0
  ),
  summed AS (
    SELECT
      t.*,
      COALESCE(sum(t.est) OVER (ORDER BY t.seq ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 0) AS est_before
      FROM timed t
  )
  SELECT
    row_number() OVER (ORDER BY s.seq)::INT,
    s.exercise_id,
    s.title,
    s.subject_id,
    s.chapter_id,
    s.chapter_title,
    s.kind,
    s.difficulty,
    s.est
    FROM summed s
   WHERE s.est_before < p_budget_minutes
   ORDER BY s.seq;
$fn$;

COMMENT ON FUNCTION public.student_study_plan_from(UUID, TEXT[], DATE, INT, JSONB) IS
  'Le programme du jour, sur des chapitres DÉJÀ calculés (lignes de student_study_chapters en JSONB) — évite de les recalculer quand le bilan les a en main. Interne.';

REVOKE ALL ON FUNCTION public.student_study_plan_from(UUID, TEXT[], DATE, INT, JSONB)
  FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.student_study_plan(
  p_user UUID,
  p_subject_ids TEXT[],
  p_day DATE,
  p_budget_minutes INT
)
RETURNS TABLE (
  step          INT,
  exercise_id   UUID,
  title         TEXT,
  subject_id    TEXT,
  chapter_id    UUID,
  chapter_title TEXT,
  kind          TEXT,
  difficulty    SMALLINT,
  est_minutes   INT
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  SELECT p.*
    FROM public.student_study_plan_from(
           p_user, p_subject_ids, p_day, p_budget_minutes,
           (SELECT COALESCE(jsonb_agg(to_jsonb(c)), '[]'::jsonb)
              FROM public.student_study_chapters(p_user, p_subject_ids, p_day) c)
         ) p;
$fn$;

REVOKE ALL ON FUNCTION public.student_study_plan(UUID, TEXT[], DATE, INT) FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.get_study_report(
  p_student UUID DEFAULT NULL,
  p_with_chapters BOOLEAN DEFAULT TRUE
)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_user     UUID := auth.uid();
  v_student  UUID := COALESCE(p_student, auth.uid());
  v_day      DATE := public.app_current_day();
  v_target   INT  := public.study_daily_target_minutes();
  v_subjects TEXT[];
  v_done     INT;
  v_week     INT;
  v_days     INT;
  v_parcours TEXT;
  v_json_subjects JSONB;
  v_json_today    JSONB;
  v_json_plan     JSONB;
  v_chapters      JSONB;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;
  IF v_user IS DISTINCT FROM v_student
     AND NOT public.is_admin()
     AND NOT public.is_parent_of_student(v_user, v_student) THEN
    RAISE EXCEPTION 'Access denied';
  END IF;

  SELECT pr.current_parcours_id INTO v_parcours
    FROM public.profiles pr WHERE pr.id = v_student;
  v_subjects := public.study_subject_ids(v_student);

  -- Le temps MESURÉ, hors navigation : la mesure du suivi quotidien parent.
  SELECT
    COALESCE(sum(lp.active_seconds) FILTER (
      WHERE (lp.occurred_at AT TIME ZONE 'Africa/Tunis')::date = v_day), 0)::INT / 60,
    COALESCE(sum(lp.active_seconds), 0)::INT / 60,
    count(DISTINCT (lp.occurred_at AT TIME ZONE 'Africa/Tunis')::date)::INT
    INTO v_done, v_week, v_days
    FROM public.learning_pulses lp
   WHERE lp.user_id = v_student
     AND lp.surface <> 'browse'
     AND lp.occurred_at >= ((v_day - 6)::timestamp AT TIME ZONE 'Africa/Tunis');

  -- L'état des chapitres, calculé UNE fois : le bilan et le programme le lisent tous deux.
  SELECT COALESCE(jsonb_agg(to_jsonb(c)), '[]'::jsonb) INTO v_chapters
    FROM public.student_study_chapters(v_student, v_subjects, v_day) c;

  WITH ch AS MATERIALIZED (
    SELECT * FROM jsonb_to_recordset(v_chapters) AS c(
      subject_id TEXT, chapter_id UUID, title TEXT, chapter_rank INT, chapters_total INT,
      declared BOOLEAN, seen BOOLEAN, star SMALLINT, started BOOLEAN,
      missions_total INT, missions_counted INT, missions_failed INT,
      quiz_gated BOOLEAN, quiz_cleared BOOLEAN, next_star SMALLINT,
      missing_for_next INT, status TEXT
    )
  ),
  agg AS (
    SELECT
      c.subject_id,
      bool_or(c.declared) AS declared,
      max(c.chapters_total) AS chapters_total,
      count(*) FILTER (WHERE c.seen)::INT AS chapters_seen,
      count(*) FILTER (WHERE c.seen AND c.status = 'maitrise')::INT AS seen_mastered,
      count(*) FILTER (WHERE c.seen AND c.status = 'acquis')::INT AS seen_acquired,
      count(*) FILTER (WHERE c.seen AND c.status = 'en-cours')::INT AS seen_in_progress,
      count(*) FILTER (WHERE c.seen AND c.status = 'fragile')::INT AS seen_fragile,
      count(*) FILTER (WHERE c.seen AND c.status = 'non-commence')::INT AS seen_not_started,
      COALESCE(sum(c.missions_total) FILTER (WHERE c.seen), 0)::INT AS missions_seen_total,
      COALESCE(sum(c.missions_counted) FILTER (WHERE c.seen), 0)::INT AS missions_seen_counted,
      CASE WHEN p_with_chapters THEN
        jsonb_agg(jsonb_build_object(
          'id', c.chapter_id,
          'title', c.title,
          'seen', c.seen,
          'status', c.status,
          'star', c.star,
          'missionsTotal', c.missions_total,
          'missionsCounted', c.missions_counted,
          'missionsFailed', c.missions_failed,
          'nextStar', c.next_star,
          'missingForNext', c.missing_for_next
        ) ORDER BY c.chapter_rank)
      END AS chapters
      FROM ch c
     GROUP BY c.subject_id
  ),
  recent AS (
    -- Réussite sur 90 jours, tentatives classiques : assez large pour qu'une
    -- matière délaissée un mois garde un niveau, assez court pour rester actuel.
    SELECT a.subject_id, count(*)::INT AS n, round(avg(a.score_pct)) AS avg_score
      FROM public.attempts a
     WHERE a.user_id = v_student
       AND a.subject_id = ANY (v_subjects)
       AND a.variant = 'classic'
       AND a.completed_at >= ((v_day - 90)::timestamp AT TIME ZONE 'Africa/Tunis')
     GROUP BY a.subject_id
  )
  SELECT COALESCE(jsonb_agg(jsonb_build_object(
           'id', s.id,
           'name', s.name_fr,
           'contentLanguage', s.content_language,
           'declared', g.declared,
           'chaptersTotal', g.chapters_total,
           'chaptersSeen', g.chapters_seen,
           'seenMastered', g.seen_mastered,
           'seenAcquired', g.seen_acquired,
           'seenInProgress', g.seen_in_progress,
           'seenFragile', g.seen_fragile,
           'seenNotStarted', g.seen_not_started,
           'missionsSeenTotal', g.missions_seen_total,
           'missionsSeenCounted', g.missions_seen_counted,
           'recentAttempts', COALESCE(r.n, 0),
           'recentAvgScore', r.avg_score,
           'level', public.study_level(r.avg_score, r.n),
           'lastActiveAt', (SELECT max(a.completed_at) FROM public.attempts a
                             WHERE a.user_id = v_student AND a.subject_id = s.id),
           'exam', (
             SELECT jsonb_build_object(
                      'scorePoints', ms.score_points,
                      'maxPoints', ms.max_points,
                      'finishedAt', ms.finished_at)
               FROM public.mock_exam_sessions ms
               JOIN public.mock_exams me ON me.id = ms.exam_id
              WHERE ms.user_id = v_student
                AND me.subject_id = s.id
                AND ms.finished_at IS NOT NULL
                AND ms.score_points IS NOT NULL
                AND ms.max_points > 0
              ORDER BY ms.finished_at DESC
              LIMIT 1),
           'chapters', g.chapters
         ) ORDER BY array_position(v_subjects, s.id)), '[]'::jsonb)
    INTO v_json_subjects
    FROM agg g
    JOIN public.subjects s ON s.id = g.subject_id
    LEFT JOIN recent r ON r.subject_id = g.subject_id;

  SELECT COALESCE(jsonb_agg(jsonb_build_object(
           'exerciseId', t.exercise_id,
           'title', e.title,
           'subjectId', e.subject_id,
           'chapterTitle', c.title,
           'scorePct', round(t.best)
         ) ORDER BY t.last_at), '[]'::jsonb)
    INTO v_json_today
    FROM (
      SELECT a.exercise_id, max(a.score_pct) AS best, max(a.completed_at) AS last_at
        FROM public.attempts a
       WHERE a.user_id = v_student
         AND (a.completed_at AT TIME ZONE 'Africa/Tunis')::date = v_day
       GROUP BY a.exercise_id
    ) t
    JOIN public.exercises e ON e.id = t.exercise_id
    LEFT JOIN public.chapters c ON c.id = e.chapter_id
   WHERE e.subject_id = ANY (v_subjects);

  SELECT COALESCE(jsonb_agg(jsonb_build_object(
           'exerciseId', p.exercise_id,
           'title', p.title,
           'subjectId', p.subject_id,
           'chapterId', p.chapter_id,
           'chapterTitle', p.chapter_title,
           'kind', p.kind,
           'difficulty', p.difficulty,
           'estMinutes', p.est_minutes
         ) ORDER BY p.step), '[]'::jsonb)
    INTO v_json_plan
    FROM public.student_study_plan_from(
           v_student, v_subjects, v_day, GREATEST(v_target - v_done, 0), v_chapters) p;

  RETURN jsonb_build_object(
    'studentId', v_student,
    'day', v_day,
    'parcoursId', v_parcours,
    'targetMinutes', v_target,
    'doneMinutes', v_done,
    'weekMinutes', v_week,
    'weekActiveDays', v_days,
    'subjects', v_json_subjects,
    'today', v_json_today,
    'plan', v_json_plan
  );
END;
$fn$;

REVOKE ALL ON FUNCTION public.get_study_report(UUID, BOOLEAN) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_study_report(UUID, BOOLEAN) TO authenticated;
