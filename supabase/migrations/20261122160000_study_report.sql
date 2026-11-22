-- =========================================================
-- Bilan et programme du jour — pour chaque élève et pour son parent.
-- ---------------------------------------------------------
-- LE BESOIN (commande du propriétaire, 2026-11-22). Un parent veut, en
-- permanence : où en est son enfant, son niveau dans chaque matière, ce qu'il ne
-- maîtrise pas encore, et un programme de travail quotidien d'au moins trente
-- minutes — « sachant que nous sommes encore au premier trimestre ». L'élève doit
-- lire LE MÊME bilan dès la connexion, et pouvoir cocher, matière par matière,
-- les chapitres déjà faits en classe.
--
-- CE QUI MANQUAIT. Le produit savait recommander UNE action (`resolveNextAction`)
-- et trois révisions échues (`get_daily_plan`) ; aucun des deux ne connaît la
-- classe de l'élève. En novembre, « la prochaine mission du chemin » peut être un
-- chapitre que le professeur n'abordera qu'en mars. Le catalogue ne porte pas de
-- trimestre (journal du 2026-11-18) : la seule source honnête de « ce qui a été
-- vu » est l'élève lui-même — et, tant qu'il n'a rien dit, le calendrier.
--
-- CE QUE CETTE MIGRATION AJOUTE :
--
--   • `student_class_chapters` — les chapitres que l'élève (ou son parent lié) a
--     déclarés « vus en classe ». Une DÉCLARATION, pas un acquis : elle se coche
--     et se décoche, à l'inverse du grand livre des étoiles.
--
--   • `school_year_share` — la part de l'année de cours écoulée. Tant qu'une
--     matière ne porte aucune déclaration, ses chapitres « vus » sont les
--     premiers du programme, à hauteur de cette part (au moins un). Mêmes bornes
--     que `PLACEMENT_SCHOOL_YEAR` (features/placement/placement-scope.ts) ; un
--     test Vitest confronte les deux pour qu'elles ne dérivent pas.
--
--   • `student_study_chapters` (interne) — l'état de chaque chapitre : vu ou non,
--     étoile AU GRAND LIVRE, missions comptées (par `mission_is_counted`, jamais
--     par un prédicat recopié), ce qui manque pour l'étoile suivante.
--
--   • `student_study_plan` (interne) — le programme : des missions des seuls
--     chapitres vus, vers la PROCHAINE étoile, trois matières par jour en
--     alternance, jusqu'à couvrir le temps qui reste à faire.
--
--   • `get_study_report` — la lecture, pour soi, pour son enfant, ou pour l'admin.
--   • `set_class_chapters` — l'écriture, pour soi ou pour son enfant.
--
-- LE PROGRAMME N'EST PAS STOCKÉ. Il se déduit, à chaque lecture, de l'état de
-- l'élève : ce qui a été joué aujourd'hui en sort, le temps réellement passé
-- (`learning_pulses`, hors navigation — la mesure du suivi quotidien) réduit ce
-- qui reste à proposer. Trente minutes sont donc trente minutes MESURÉES : un
-- élève qui expédie ses missions en voit arriver d'autres.
--
-- LE PROGRAMME NE DÉCIDE D'AUCUN ACCÈS : la porte reste `resolve_exercise_access`,
-- au moment de jouer. Additive de bout en bout ; aucune donnée n'est écrite ici.
-- =========================================================

-- ---------------------------------------------------------------------------
-- 1. LA DÉCLARATION — « vu en classe ».
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.student_class_chapters (
  user_id    UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  chapter_id UUID NOT NULL REFERENCES public.chapters(id) ON DELETE CASCADE,
  marked_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, chapter_id)
);

CREATE INDEX IF NOT EXISTS idx_student_class_chapters_chapter
  ON public.student_class_chapters (chapter_id);

COMMENT ON TABLE public.student_class_chapters IS
  'Chapitres déclarés « vus en classe » par l''élève ou son parent lié. Une déclaration (elle se décoche), pas un acquis : elle borne le programme du jour, elle ne donne aucune étoile.';

ALTER TABLE public.student_class_chapters ENABLE ROW LEVEL SECURITY;

-- Patron du grand livre (20260914120000) : le propriétaire, l'admin, un parent
-- lié ACTIF. `auth.uid()` en sous-select scalaire, hissé une fois. Posée sous garde
-- d'existence : la migration reste rejouable sans jamais retirer une politique.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
     WHERE schemaname = 'public'
       AND tablename = 'student_class_chapters'
       AND policyname = 'Class chapters readable by owner, admin or linked parent'
  ) THEN
    CREATE POLICY "Class chapters readable by owner, admin or linked parent"
      ON public.student_class_chapters
      FOR SELECT
      USING (
        user_id = (SELECT auth.uid())
        OR public.is_admin()
        OR EXISTS (
          SELECT 1 FROM public.parent_student_links l
          WHERE l.parent_user_id = (SELECT auth.uid())
            AND l.student_user_id = student_class_chapters.user_id
            AND l.is_active
        )
      );
  END IF;
END
$$;

-- Aucune politique d'écriture : le seul écrivain est `set_class_chapters`.
REVOKE ALL ON public.student_class_chapters FROM anon, authenticated;
GRANT SELECT ON public.student_class_chapters TO authenticated;
GRANT ALL    ON public.student_class_chapters TO service_role;

-- ---------------------------------------------------------------------------
-- 2. LES CONSTANTES — nommées une fois, lues partout.
-- ---------------------------------------------------------------------------

-- La part de l'année de cours écoulée, entre 0 et 1. Du 15 septembre au 31 mai ;
-- de la fin des cours à la rentrée suivante, 1 : le programme est vu.
CREATE OR REPLACE FUNCTION public.school_year_share(p_day DATE)
RETURNS NUMERIC
LANGUAGE sql
IMMUTABLE
SET search_path = public
AS $fn$
  WITH y AS (
    SELECT CASE
             WHEN (EXTRACT(MONTH FROM p_day)::INT, EXTRACT(DAY FROM p_day)::INT) >= (9, 15)
             THEN EXTRACT(YEAR FROM p_day)::INT
             ELSE EXTRACT(YEAR FROM p_day)::INT - 1
           END AS start_year
  ),
  b AS (
    SELECT make_date(y.start_year, 9, 15) AS d_from,
           make_date(y.start_year + 1, 5, 31) AS d_to
      FROM y
  )
  SELECT CASE
           WHEN p_day >= b.d_to THEN 1::NUMERIC
           ELSE LEAST(1, GREATEST(0, (p_day - b.d_from)::NUMERIC / (b.d_to - b.d_from)))
         END
    FROM b;
$fn$;

-- L'objectif quotidien, en minutes. Le plancher demandé par le propriétaire.
CREATE OR REPLACE FUNCTION public.study_daily_target_minutes()
RETURNS INT
LANGUAGE sql
IMMUTABLE
SET search_path = public
AS $fn$
  SELECT 30;
$fn$;

-- La durée ESTIMÉE d'une mission. Calée sur le troisième quartile mesuré en
-- production le 2026-11-22 (secondes par question : 35 en difficulté 1, 33 en 2,
-- 22 en 3, 56 en 4) — le rythme de qui lit la correction, pas de qui clique.
-- Trois minutes au moins : aucune mission ne se « fait » en une minute.
CREATE OR REPLACE FUNCTION public.study_exercise_minutes(p_questions INT, p_difficulty INT)
RETURNS INT
LANGUAGE sql
IMMUTABLE
SET search_path = public
AS $fn$
  SELECT GREATEST(
    3,
    CEIL(GREATEST(p_questions, 0) * (CASE WHEN p_difficulty >= 4 THEN 60 ELSE 35 END) / 60.0)::INT
  );
$fn$;

-- Le niveau d'une matière, lu sur la réussite récente. Les deux seuils existent
-- déjà : 60 est le seuil de réussite d'une mission, 80 celui d'un quiz — et ce
-- sont ceux des « forces / faiblesses » du bilan parent (20260701090000). Moins
-- de trois missions : on ne prétend rien.
CREATE OR REPLACE FUNCTION public.study_level(p_avg_score NUMERIC, p_attempts INT)
RETURNS TEXT
LANGUAGE sql
IMMUTABLE
SET search_path = public
AS $fn$
  SELECT CASE
           WHEN COALESCE(p_attempts, 0) < 3 OR p_avg_score IS NULL THEN 'non-evalue'
           WHEN p_avg_score >= 80 THEN 'solide'
           WHEN p_avg_score >= 60 THEN 'en-progres'
           ELSE 'a-renforcer'
         END;
$fn$;

-- Les matières du parcours actif de l'élève, dans l'ordre du catalogue. La même
-- règle que le tableau de bord (dashboard.server.ts) et que
-- `app_daily_mission_pool` : le thème du parcours, et son niveau s'il en a un.
CREATE OR REPLACE FUNCTION public.study_subject_ids(p_user UUID)
RETURNS TEXT[]
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  SELECT COALESCE(
    (SELECT array_agg(s.id ORDER BY s.display_order, s.id)
       FROM public.profiles pr
       JOIN public.parcours pa ON pa.id = pr.current_parcours_id
       JOIN public.subjects s
         ON s.theme_id = pa.theme_id
        AND CASE WHEN pa.grade_id IS NOT NULL
                 THEN s.grade_id = pa.grade_id
                 ELSE s.grade_id IS NULL END
      WHERE pr.id = p_user),
    ARRAY[]::TEXT[]
  );
$fn$;

-- ---------------------------------------------------------------------------
-- 3. L'ÉTAT DE CHAQUE CHAPITRE (interne).
--
--    Un chapitre « publié » porte au moins une mission de catalogue (définition
--    de `student_subject_stars`). `counted` passe par `mission_is_counted` — le
--    prédicat du grand livre, anti-précipitation comprise — mais seulement sur
--    les missions déjà tentées : une mission jamais jouée ne compte pas, et
--    l'apprendre ne mérite pas une lecture d'index par mission du catalogue.
-- ---------------------------------------------------------------------------
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
  rolled AS (
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
  ranked AS (
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
  scoped AS (
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
  aimed AS (
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

COMMENT ON FUNCTION public.student_study_chapters(UUID, TEXT[], DATE) IS
  'État de chaque chapitre publié pour le bilan : vu en classe (déclaré, sinon estimé au calendrier), étoile au grand livre, missions comptées, distance à la prochaine étoile. Interne.';

-- ---------------------------------------------------------------------------
-- 4. LE PROGRAMME (interne).
--
--    Les candidates : dans les chapitres VUS qui n'ont pas leur prochaine étoile,
--    le quiz s'il reste dû, puis les missions de difficulté <= prochaine étoile
--    qui ne comptent pas encore — jamais une mission déjà jouée aujourd'hui (un
--    échec se reprend le lendemain, pas dans la foulée).
--
--    L'ordre : dans une matière, les reprises d'abord, puis les chapitres
--    commencés (le plus proche de son étoile en tête), puis les chapitres vus
--    jamais ouverts, dans l'ordre du programme ; deux missions au plus par
--    chapitre, trois par matière. Entre matières, celle qu'on n'a pas travaillée
--    aujourd'hui, puis celle qu'on a délaissée le plus longtemps, puis la moins
--    couverte. Les trois premières se partagent le programme en alternance.
-- ---------------------------------------------------------------------------
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
  WITH allch AS MATERIALIZED (
    SELECT * FROM public.student_study_chapters(p_user, p_subject_ids, p_day)
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

COMMENT ON FUNCTION public.student_study_plan(UUID, TEXT[], DATE, INT) IS
  'Le programme du jour : missions des chapitres VUS en classe, vers la prochaine étoile, trois matières en alternance, jusqu''à couvrir le budget en minutes. Déduit de l''état de l''élève, jamais stocké. Interne.';

REVOKE ALL ON FUNCTION public.school_year_share(DATE)                       FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.study_daily_target_minutes()                  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.study_exercise_minutes(INT, INT)              FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.study_level(NUMERIC, INT)                     FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.study_subject_ids(UUID)                       FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.student_study_chapters(UUID, TEXT[], DATE)    FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.student_study_plan(UUID, TEXT[], DATE, INT)   FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 5. LA LECTURE — pour soi, pour son enfant, pour l'admin.
--
--    `assert_can_read_student_activity` refuse l'élève lui-même : ce bilan est
--    justement fait pour qu'il le lise. La garde est donc celle de
--    `get_family_daily_goal` (soi, ou parent lié), plus l'admin.
--
--    `p_with_chapters = false` rend le bilan sans la liste des chapitres : c'est
--    ce que le tableau de bord demande à chaque connexion.
-- ---------------------------------------------------------------------------
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

  WITH ch AS MATERIALIZED (
    SELECT * FROM public.student_study_chapters(v_student, v_subjects, v_day)
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
    FROM public.student_study_plan(v_student, v_subjects, v_day, GREATEST(v_target - v_done, 0)) p;

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

COMMENT ON FUNCTION public.get_study_report(UUID, BOOLEAN) IS
  'Bilan et programme du jour d''un élève : niveau par matière, état des chapitres vus en classe, ce qui a été fait aujourd''hui, ce qui reste à faire pour atteindre l''objectif. Pour soi, pour son enfant (lien actif) ou pour l''admin.';

-- ---------------------------------------------------------------------------
-- 6. L'ÉCRITURE — cocher les chapitres vus d'UNE matière.
--
--    La liste remplace la déclaration de la matière : un seul appel par geste,
--    idempotent, sans course entre deux cases cochées coup sur coup. Une liste
--    vide rend la matière à l'estimation du calendrier.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.set_class_chapters(
  p_subject_id TEXT,
  p_chapter_ids UUID[],
  p_student UUID DEFAULT NULL
)
RETURNS INT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_user    UUID := auth.uid();
  v_student UUID := COALESCE(p_student, auth.uid());
  v_asked   UUID[] := COALESCE(p_chapter_ids, ARRAY[]::UUID[]);
  v_ids     UUID[];
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;
  IF v_user IS DISTINCT FROM v_student
     AND NOT public.is_parent_of_student(v_user, v_student) THEN
    RAISE EXCEPTION 'Access denied';
  END IF;
  IF cardinality(v_asked) > 200 THEN
    RAISE EXCEPTION 'Too many chapters';
  END IF;

  SELECT COALESCE(array_agg(c.id), ARRAY[]::UUID[]) INTO v_ids
    FROM public.chapters c
   WHERE c.subject_id = p_subject_id
     AND c.id = ANY (v_asked);

  IF cardinality(v_ids) <> (SELECT count(DISTINCT x) FROM unnest(v_asked) AS x) THEN
    RAISE EXCEPTION 'Unknown chapter for this subject';
  END IF;

  DELETE FROM public.student_class_chapters k
   USING public.chapters c
   WHERE k.user_id = v_student
     AND c.id = k.chapter_id
     AND c.subject_id = p_subject_id
     AND NOT (k.chapter_id = ANY (v_ids));

  INSERT INTO public.student_class_chapters (user_id, chapter_id)
  SELECT v_student, x
    FROM unnest(v_ids) AS x
  ON CONFLICT (user_id, chapter_id) DO NOTHING;

  RETURN cardinality(v_ids);
END;
$fn$;

REVOKE ALL ON FUNCTION public.set_class_chapters(TEXT, UUID[], UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_class_chapters(TEXT, UUID[], UUID) TO authenticated;

COMMENT ON FUNCTION public.set_class_chapters(TEXT, UUID[], UUID) IS
  'Remplace la déclaration « vus en classe » d''une matière, pour soi ou pour son enfant (lien actif). Une liste vide rend la matière à l''estimation du calendrier.';
