-- =========================================================
-- Bilan et programme du jour — matières prioritaires et objectif réglable.
-- ---------------------------------------------------------
-- LE BESOIN (commande du propriétaire, 2026-11-22). « Je veux aussi lever son
-- niveau en arabe et en français surtout », et un programme d'« au minimum
-- 30 minutes par jour ». La première version alternait les matières par
-- délaissement : l'arabe et le français n'y revenaient donc pas chaque jour, et
-- l'objectif était figé à son plancher.
--
-- CE QUE CETTE MIGRATION AJOUTE :
--
--   • `study_preferences` — par élève : l'objectif quotidien (30 à 120 minutes ;
--     30 est un PLANCHER, il ne se descend pas) et jusqu'à DEUX matières
--     prioritaires. Deux, pas davantage : au-delà, « prioritaire » ne veut plus
--     rien dire, et le programme garde une troisième place pour l'alternance.
--
--   • `set_study_preferences` — l'élève pour lui-même, ou son parent lié.
--     Une matière prioritaire doit appartenir au parcours de l'élève.
--
--   • le programme sert les matières prioritaires EN PREMIER, chaque jour ;
--     `get_study_report` lit l'objectif de l'élève et marque ses matières
--     (`focus`). Corps identiques à leur révision vivante (20261122170000), à ces
--     lignes près.
--
-- Additive ; aucune donnée écrite : sans préférence, tout se comporte comme avant.
-- =========================================================

CREATE TABLE IF NOT EXISTS public.study_preferences (
  user_id           UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  daily_minutes     INT NOT NULL DEFAULT 30,
  focus_subject_ids TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT study_preferences_daily_minutes_range CHECK (daily_minutes BETWEEN 30 AND 120),
  CONSTRAINT study_preferences_focus_max CHECK (cardinality(focus_subject_ids) <= 2)
);

COMMENT ON TABLE public.study_preferences IS
  'Réglages du programme du jour d''un élève : objectif quotidien en minutes (plancher 30) et jusqu''à deux matières prioritaires. Écrits par l''élève ou son parent lié, via set_study_preferences.';

ALTER TABLE public.study_preferences ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
     WHERE schemaname = 'public'
       AND tablename = 'study_preferences'
       AND policyname = 'Study preferences readable by owner, admin or linked parent'
  ) THEN
    CREATE POLICY "Study preferences readable by owner, admin or linked parent"
      ON public.study_preferences
      FOR SELECT
      USING (
        user_id = (SELECT auth.uid())
        OR public.is_admin()
        OR EXISTS (
          SELECT 1 FROM public.parent_student_links l
          WHERE l.parent_user_id = (SELECT auth.uid())
            AND l.student_user_id = study_preferences.user_id
            AND l.is_active
        )
      );
  END IF;
END
$$;

REVOKE ALL ON public.study_preferences FROM anon, authenticated;
GRANT SELECT ON public.study_preferences TO authenticated;
GRANT ALL    ON public.study_preferences TO service_role;

-- L'objectif de l'élève : le sien s'il en a posé un, sinon le plancher.
CREATE OR REPLACE FUNCTION public.study_target_minutes(p_user UUID)
RETURNS INT
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  SELECT COALESCE(
    (SELECT p.daily_minutes FROM public.study_preferences p WHERE p.user_id = p_user),
    public.study_daily_target_minutes()
  );
$fn$;

-- Ses matières prioritaires — vide quand il n'en a pas choisi.
CREATE OR REPLACE FUNCTION public.study_focus_subject_ids(p_user UUID)
RETURNS TEXT[]
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  SELECT COALESCE(
    (SELECT p.focus_subject_ids FROM public.study_preferences p WHERE p.user_id = p_user),
    ARRAY[]::TEXT[]
  );
$fn$;

REVOKE ALL ON FUNCTION public.study_target_minutes(UUID)    FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.study_focus_subject_ids(UUID) FROM PUBLIC, anon, authenticated;

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
        -- Les matières PRIORITAIRES d'abord, qu'elles aient été travaillées aujourd'hui ou
        -- non : c'est ce qui les fait revenir chaque jour. Le reste alterne comme avant.
        ORDER BY (NOT (s.subject_id = ANY (public.study_focus_subject_ids(p_user)))),
                 s.done_today, s.last_day NULLS FIRST, s.coverage,
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

REVOKE ALL ON FUNCTION public.student_study_plan_from(UUID, TEXT[], DATE, INT, JSONB)
  FROM PUBLIC, anon, authenticated;

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
  v_target   INT;
  v_focus    TEXT[];
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
  v_target   := public.study_target_minutes(v_student);
  v_focus    := public.study_focus_subject_ids(v_student);

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
           'focus', s.id = ANY (v_focus),
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

-- ---------------------------------------------------------------------------
-- L'écriture. `NULL` = ne pas toucher à ce réglage : on règle l'objectif sans
-- redonner les matières, et inversement.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.set_study_preferences(
  p_daily_minutes INT DEFAULT NULL,
  p_focus_subject_ids TEXT[] DEFAULT NULL,
  p_student UUID DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_user    UUID := auth.uid();
  v_student UUID := COALESCE(p_student, auth.uid());
  v_focus   TEXT[];
  v_row     public.study_preferences%ROWTYPE;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;
  IF v_user IS DISTINCT FROM v_student
     AND NOT public.is_parent_of_student(v_user, v_student) THEN
    RAISE EXCEPTION 'Access denied';
  END IF;
  IF p_daily_minutes IS NOT NULL AND p_daily_minutes NOT BETWEEN 30 AND 120 THEN
    RAISE EXCEPTION 'Daily minutes out of range';
  END IF;

  IF p_focus_subject_ids IS NOT NULL THEN
    SELECT COALESCE(array_agg(DISTINCT x), ARRAY[]::TEXT[]) INTO v_focus
      FROM unnest(p_focus_subject_ids) AS x;
    IF cardinality(v_focus) > 2 THEN
      RAISE EXCEPTION 'Too many focus subjects';
    END IF;
    IF NOT (v_focus <@ public.study_subject_ids(v_student)) THEN
      RAISE EXCEPTION 'Unknown subject for this parcours';
    END IF;
  END IF;

  INSERT INTO public.study_preferences (user_id, daily_minutes, focus_subject_ids)
  VALUES (
    v_student,
    COALESCE(p_daily_minutes, public.study_daily_target_minutes()),
    COALESCE(v_focus, ARRAY[]::TEXT[])
  )
  ON CONFLICT (user_id) DO UPDATE
     SET daily_minutes     = COALESCE(p_daily_minutes, public.study_preferences.daily_minutes),
         focus_subject_ids = COALESCE(v_focus, public.study_preferences.focus_subject_ids),
         updated_at        = now()
  RETURNING * INTO v_row;

  RETURN jsonb_build_object(
    'dailyMinutes', v_row.daily_minutes,
    'focusSubjectIds', to_jsonb(v_row.focus_subject_ids)
  );
END;
$fn$;

REVOKE ALL ON FUNCTION public.set_study_preferences(INT, TEXT[], UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_study_preferences(INT, TEXT[], UUID) TO authenticated;

COMMENT ON FUNCTION public.set_study_preferences(INT, TEXT[], UUID) IS
  'Règle l''objectif quotidien (30 à 120 minutes) et les matières prioritaires (deux au plus, du parcours de l''élève), pour soi ou pour son enfant (lien actif). NULL laisse un réglage inchangé.';
