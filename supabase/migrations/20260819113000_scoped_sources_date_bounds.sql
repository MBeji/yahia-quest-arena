-- Suivi parental — les bornes de date entrent DANS les sources scopées.
--
-- POURQUOI DES PARAMÈTRES ET PAS UN PRÉDICAT
-- ---------------------------------------------------------------------------
-- `_scoped_attempts` / `_scoped_pulses` sont `SECURITY DEFINER` **et** portent un
-- `SET search_path` ; chacune de ces deux propriétés suffit à faire refuser
-- l'inlining d'une fonction SQL à retour ensembliste
-- (`inline_set_returning_function`, prosecdef / proconfig). Le prédicat de date
-- que pose l'appelant reste donc en `Filter:` AU-DESSUS du `Function Scan` : la
-- fonction matérialise tout l'historique de l'élève, puis on jette. Un paramètre,
-- lui, entre dans le plan interne — et `idx_attempts_user_completed_at` retravaille.
--
-- On ne retire NI le `SECURITY DEFINER` (ces fonctions lisent les données d'un
-- élève tiers pour son parent) NI le `SET search_path` (protection contre le
-- détournement de recherche de schéma). Gagner l'inlining en sacrifiant l'un des
-- deux serait une régression de sécurité.
--
-- CE QUE ÇA CHANGE, MESURÉ SUR LA PROD LE 2026-08-19
-- ---------------------------------------------------------------------------
-- Les 10 lectures scopées du corps de `_student_daily_report_json`, rejouées à
-- l'identique en une requête, sur l'élève le plus chargé (163 tentatives) :
--
--   telles qu'écrites (10 Function Scan) ......... 731 buffers · 4,9 ms
--   historique matérialisé une fois (2 scans) .... 686 buffers · 3,0 ms
--   bornes poussées dans la source (ce lot) ...... 334 buffers · 3,0 ms
--
-- Aujourd'hui le gain est modeste — `attempts` fait 8 pages, il n'y a presque
-- rien à économiser, et c'est écrit noir sur blanc dans docs/performance-audit.md
-- § 0-bis. Ce que ce lot supprime, c'est la PENTE : le rapport fait 22 appels
-- scopés, dont 18 sont logiquement bornés à la fenêtre et relisaient pourtant
-- tout l'historique, soit ~18·N/34 buffers jetés (N = tentatives de l'élève).
-- ~90 buffers à N=163, ~1 060 à N≈2 000, et au-delà de la couverture du
-- programme à N≈7 000. Après ce lot, ces 18 appels suivent la FENÊTRE, plus
-- l'historique.
--
-- Les 4 autres appels ont réellement besoin de tout l'historique et le déclarent
-- avec les sentinelles `-infinity` / `infinity` : `measuredSince` (depuis quand
-- le temps est mesuré), `ranked` (la numérotation des tentatives — sinon
-- « 3ᵉ tentative » redeviendrait « 1ʳᵉ » dès qu'on regarde une semaine), et
-- `first_pass` dans `student_activity_totals`, qui compte double puisqu'elle est
-- appelée deux fois. `attempts.completed_at` et `learning_pulses.occurred_at`
-- sont `NOT NULL`, donc `>= '-infinity' AND < 'infinity'` est strictement
-- équivalent à l'absence de prédicat — vérifié aussi côté données : zéro ligne à
-- timestamp infini dans les deux tables.
--
-- POURQUOI LES PRÉDICATS DE L'APPELANT RESTENT EN PLACE
-- ---------------------------------------------------------------------------
-- Chaque CTE garde son `WHERE … >= v_from_ts AND … < v_to_ts`, désormais
-- redondant avec l'argument. C'est délibéré, et c'est ce qui rend ce lot sûr :
-- **le filtrage qui décide du résultat n'a pas bougé d'une ligne**. L'argument
-- n'est qu'une optimisation ; s'il était mal choisi sur un site, la requête
-- rendrait moins de lignes — jamais des lignes fausses — et le prédicat resté en
-- place le rendrait visible. Chaque CTE reste aussi lisible seule.
--
-- ÉGALITÉ PROUVÉE AVANT LIVRAISON
-- ---------------------------------------------------------------------------
-- Sur les données de PROD, `EXCEPT ALL` dans les deux sens entre l'ancienne
-- forme (appel non borné + prédicat de l'appelant) et la nouvelle (appel borné),
-- sur 24 combinaisons — 4 élèves × 2 périmètres (« tout » / « sa classe ») ×
-- 3 jeux de bornes dont les sentinelles —, 1 005 lignes comparées :
-- **0 écart, dans les deux sens, pour les tentatives comme pour les pouls.**
--
-- Et 24 empreintes `md5` de la charge utile complète de
-- `_student_daily_report_json`, prises AVANT sur des fenêtres passées (juin,
-- juillet, 1er-15 août — elles ne peuvent plus bouger) : global
-- `833c06aebd9caf6d69dd16889515a789`, à recomparer une fois la migration
-- appliquée.
--
-- CE QUI N'EST PAS TOUCHÉ, ET POURQUOI
-- ---------------------------------------------------------------------------
-- 1. Le `LEFT JOIN LATERAL` de couverture de `rows_subjects`. Il est sain :
--    `loops=5` sur 30 jours, `loops=10` sur 92 — mesuré le 2026-08-19, conforme
--    à #769, et bien sous le seuil de bascule de ~23 appels. C'est pourtant LUI
--    le poste dominant du rapport (1 818 buffers sur 30 jours, 3 346 sur 92) :
--    le coût du bilan quotidien suit le nombre de MATIÈRES, pas l'historique.
-- 2. `src/shared/integrations/supabase/types.ts` décrit encore les signatures à
--    deux arguments. Le fichier est généré et le hook `guard-generated` en
--    interdit l'édition à la main ; aucun code de `src/` n'appelle ces deux
--    fonctions (elles sont REVOKE pour anon et authenticated), donc rien ne
--    casse. La dérive se résorbera au prochain `supabase gen types`.
--
-- 3. Les `COMMENT ON FUNCTION` posés hier par `20260819093000` disparaissent
--    avec les signatures à deux arguments qu'ils décrivaient. Ce lot les
--    remplace sur les nouvelles signatures — et leur contenu change, puisque la
--    phrase « chaque appel rend TOUT l'historique » n'est justement plus vraie.
--
-- Migration SQL pure : aucun code applicatif ne change, la charge utile JSON est
-- identique au champ près. Corps repris à l'identique de la révision vivante
-- (20260817120000, md5 `ed8effd2…` pour le rapport, `9ff81a95…` pour les
-- totaux) ; seuls les 16 sites d'appel sont réécrits, par script — jamais
-- recopiés à la main, et chaque borne relue contre la CTE qui la porte.
-- ---------------------------------------------------------------------------
-- 1. Les deux sources scopées, désormais BORNÉES. Les bornes sont des
--    paramètres, pas des prédicats de l'appelant : c'est la seule façon de les
--    faire entrer dans le plan interne, puisque l'inlining est refusé.
--    Pas de valeur par défaut — chaque site déclare son intention, et un site
--    qui veut tout l'historique le dit avec les sentinelles.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public._scoped_attempts(
  p_student UUID,
  p_subject_ids TEXT[],
  p_from TIMESTAMPTZ,
  p_to TIMESTAMPTZ
)
RETURNS SETOF public.attempts
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  SELECT *
    FROM public.attempts a
   WHERE a.user_id = p_student
     AND (p_subject_ids IS NULL OR a.subject_id = ANY (p_subject_ids))
     AND a.completed_at >= p_from
     AND a.completed_at < p_to;
$fn$;

REVOKE EXECUTE ON FUNCTION public._scoped_attempts(UUID, TEXT[], TIMESTAMPTZ, TIMESTAMPTZ)
  FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public._scoped_pulses(
  p_student UUID,
  p_subject_ids TEXT[],
  p_from TIMESTAMPTZ,
  p_to TIMESTAMPTZ
)
RETURNS SETOF public.learning_pulses
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  SELECT *
    FROM public.learning_pulses lp
   WHERE lp.user_id = p_student
     AND (p_subject_ids IS NULL OR lp.subject_id = ANY (p_subject_ids))
     AND lp.occurred_at >= p_from
     AND lp.occurred_at < p_to;
$fn$;

REVOKE EXECUTE ON FUNCTION public._scoped_pulses(UUID, TEXT[], TIMESTAMPTZ, TIMESTAMPTZ)
  FROM PUBLIC, anon, authenticated;

COMMENT ON FUNCTION public._scoped_attempts(UUID, TEXT[], TIMESTAMPTZ, TIMESTAMPTZ) IS
$c$Tentatives d'un élève, restreintes à un périmètre de matières (NULL = aucun
filtre) ET à une fenêtre [p_from, p_to). Les bornes sont des PARAMÈTRES parce que
SECURITY DEFINER + SET search_path interdisent l'inlining : un prédicat posé par
l'appelant resterait en Filter au-dessus du Function Scan. Historique complet :
passer '-infinity' / 'infinity' — completed_at est NOT NULL, donc c'est
strictement équivalent à l'absence de prédicat.$c$;

COMMENT ON FUNCTION public._scoped_pulses(UUID, TEXT[], TIMESTAMPTZ, TIMESTAMPTZ) IS
$c$Pouls d'apprentissage d'un élève, restreints à un périmètre de matières
(NULL = aucun filtre) ET à une fenêtre [p_from, p_to). Un pouls sans matière —
donjon, duel, navigation — n'appartient à aucun niveau et sort du périmètre dès
qu'un filtre est demandé : c'est ce que `excludedMinutes` rapporte au parent.
Mêmes bornes-paramètres et mêmes sentinelles que _scoped_attempts.$c$;

-- ---------------------------------------------------------------------------
-- 2. Les totaux, avec les bornes passées à la source.
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
    FROM public._scoped_pulses(p_student, p_subject_ids, p_from, p_to)
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
    FROM public._scoped_pulses(p_student, p_subject_ids, p_from, p_to)
    WHERE user_id = p_student AND occurred_at >= p_from AND occurred_at < p_to
    UNION
    SELECT (completed_at AT TIME ZONE p_tz)::DATE
    FROM public._scoped_attempts(p_student, p_subject_ids, p_from, p_to)
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
  FROM public._scoped_attempts(p_student, p_subject_ids, p_from, p_to)
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
    FROM public._scoped_pulses(p_student, p_subject_ids, p_from, p_to)
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
    FROM public._scoped_attempts(p_student, p_subject_ids, '-infinity'::TIMESTAMPTZ, 'infinity'::TIMESTAMPTZ)
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
-- 3. Le rapport quotidien, idem.
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
  FROM public._scoped_pulses(p_student, p_subject_ids, '-infinity'::TIMESTAMPTZ, 'infinity'::TIMESTAMPTZ)
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
    FROM public._scoped_pulses(p_student, p_subject_ids, v_from_ts, v_to_ts)
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
    FROM public._scoped_attempts(p_student, p_subject_ids, v_from_ts, v_to_ts)
    WHERE user_id = p_student
      AND completed_at >= v_from_ts
      AND completed_at < v_to_ts
    GROUP BY (completed_at AT TIME ZONE c_tz)::DATE
  ),
  lesson_days AS (
    SELECT
      (occurred_at AT TIME ZONE c_tz)::DATE AS day,
      COUNT(DISTINCT chapter_id)::INT AS chapters_read
    FROM public._scoped_pulses(p_student, p_subject_ids, v_from_ts, v_to_ts)
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
    FROM public._scoped_pulses(p_student, p_subject_ids, v_from_ts, v_to_ts) lp
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
    FROM public._scoped_attempts(p_student, p_subject_ids, '-infinity'::TIMESTAMPTZ, 'infinity'::TIMESTAMPTZ) a
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
    FROM public._scoped_pulses(p_student, p_subject_ids, v_from_ts, v_to_ts) lp
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
    FROM public._scoped_pulses(p_student, p_subject_ids, v_from_ts, v_to_ts) lp
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
    FROM public._scoped_attempts(p_student, p_subject_ids, v_prev_from_ts, v_to_ts)
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
    FROM public._scoped_attempts(p_student, p_subject_ids, v_from_ts, v_to_ts) a
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
-- 4. Les versions à deux arguments disparaissent. Elles ne sont appelées que
--    par les deux fonctions ci-dessus, redéfinies dans CETTE migration et dans
--    la même transaction : il n'existe aucun instant où un appelant chercherait
--    une fonction absente. Les laisser créerait pire que du code mort — un appel
--    à deux arguments deviendrait AMBIGU si l'on donnait un jour des valeurs
--    par défaut aux bornes.
-- ---------------------------------------------------------------------------
DROP FUNCTION IF EXISTS public._scoped_attempts(UUID, TEXT[]);
DROP FUNCTION IF EXISTS public._scoped_pulses(UUID, TEXT[]);
