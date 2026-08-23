-- Étude 04 — lots A2.1 et A2.2 : « Tes points faibles », côté élève et côté parent.
--
-- CE QUE CES DEUX SURFACES DISENT, ET QUI N'EXISTE NULLE PART AILLEURS
-- ---------------------------------------------------------------------------
-- Le produit sait déjà dire « Fractions : 45 % » — c'est `chapterInsights` du
-- rapport parent, et la carte de compétences côté élève. Il ne sait pas dire
-- « tu additionnes les dénominateurs ». La différence n'est pas cosmétique :
-- un pourcentage par chapitre dit OÙ ça coince, une erreur nommée dit QUOI
-- réviser, et c'est la seule des deux sur laquelle un parent peut agir le soir.
--
-- A2.2 n'est donc PAS un doublon de `chapterInsights` : c'est un axe différent
-- sur la même donnée. Les deux cohabitent dans le rapport.
--
-- LA TENDANCE EST MESURÉE, PAS DÉCLARÉE
-- ---------------------------------------------------------------------------
-- `user_misconceptions` est un agrégat sans histoire : il sait combien de fois
-- au total, pas « est-ce que ça s'arrange ». La tendance se lit donc dans la
-- télémétrie brute (`question_attempts`, qui porte le tag et la date), sur deux
-- fenêtres de 7 jours qui se suivent. Trois valeurs seulement — `improving`,
-- `worsening`, `stable` — et `stable` couvre aussi « pas assez de données » :
-- une flèche inventée sur deux points serait pire qu'une absence de flèche.

-- ---------------------------------------------------------------------------
-- 1. A2.1 — « Tes points faibles » (US-2).
-- ---------------------------------------------------------------------------
-- Rend des FAITS, dans les trois langues, et laisse l'écran choisir : même
-- posture que `get_my_competency_map` (é07 lot 4). Un libellé mis en langue en
-- SQL parlerait une seule langue pour tout le monde.
--
-- `competency` vient du registre et pilote le geste « S'entraîner » — il réutilise
-- `get_exercises_for_competency` (é07 lot 4), comme le bouton de la correction
-- riche (A12/R-A1.2-6). Il n'y a toujours qu'UN chemin de remédiation.
-- Le champ est OPTIONNEL par conception : une confusion de vocabulaire n'a pas
-- de compétence propre, et l'écran doit alors se taire plutôt que de proposer un
-- exercice au hasard.
CREATE OR REPLACE FUNCTION public.get_my_weaknesses(p_limit INT DEFAULT 5)
RETURNS TABLE (
  tag            TEXT,
  label_fr       TEXT,
  label_en       TEXT,
  label_ar       TEXT,
  competency     TEXT,
  occurrences    INT,
  last_seen_at   TIMESTAMPTZ,
  chapter_id     UUID,
  chapter_title  TEXT,
  subject_id     TEXT,
  recent_7d      INT,
  previous_7d    INT,
  trend          TEXT
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  WITH active AS (
    SELECT am.tag, am.occurrences, am.last_seen_at
      FROM public.active_misconceptions((SELECT auth.uid())) am
  ),
  -- Le chapitre où l'erreur se commet LE PLUS. `question_attempts.chapter_id`
  -- est dénormalisé exactement pour ce genre d'agrégation (A0.1).
  home AS (
    SELECT DISTINCT ON (qa.misconception_tag)
           qa.misconception_tag AS tag,
           qa.chapter_id,
           count(*) OVER (PARTITION BY qa.misconception_tag, qa.chapter_id) AS hits
      FROM public.question_attempts qa
      JOIN active a ON a.tag = qa.misconception_tag
     WHERE qa.user_id = (SELECT auth.uid())
       AND qa.created_at >= now() - INTERVAL '30 days'
     ORDER BY qa.misconception_tag, hits DESC, qa.chapter_id
  ),
  -- Deux fenêtres qui se suivent, comptées sur la télémétrie brute : c'est la
  -- seule source qui porte une DATE par occurrence.
  windows AS (
    SELECT a.tag,
           count(*) FILTER (
             WHERE qa.created_at >= now() - INTERVAL '7 days'
           )::INT AS recent_7d,
           count(*) FILTER (
             WHERE qa.created_at >= now() - INTERVAL '14 days'
               AND qa.created_at <  now() - INTERVAL '7 days'
           )::INT AS previous_7d
      FROM active a
      LEFT JOIN public.question_attempts qa
        ON qa.misconception_tag = a.tag
       AND qa.user_id = (SELECT auth.uid())
       AND qa.created_at >= now() - INTERVAL '14 days'
     GROUP BY a.tag
  )
  SELECT a.tag,
         m.label_fr,
         m.label_en,
         m.label_ar,
         m.competency,
         a.occurrences,
         a.last_seen_at,
         h.chapter_id,
         c.title      AS chapter_title,
         c.subject_id,
         COALESCE(w.recent_7d, 0)   AS recent_7d,
         COALESCE(w.previous_7d, 0) AS previous_7d,
         -- « stable » couvre aussi « on ne sait pas encore » : sous trois
         -- occurrences sur les deux fenêtres, aucune direction n'est honnête.
         CASE
           WHEN COALESCE(w.recent_7d, 0) + COALESCE(w.previous_7d, 0) < 3 THEN 'stable'
           WHEN COALESCE(w.recent_7d, 0) <  COALESCE(w.previous_7d, 0) THEN 'improving'
           WHEN COALESCE(w.recent_7d, 0) >  COALESCE(w.previous_7d, 0) THEN 'worsening'
           ELSE 'stable'
         END AS trend
    FROM active a
    -- INNER JOIN, et c'est délibéré : un tag que le vocabulaire ne connaît pas
    -- n'a pas de phrase à montrer à un enfant. On préfère l'omettre que d'afficher
    -- un identifiant technique (R-A1.2-1 : le tag n'est JAMAIS affiché).
    JOIN public.misconceptions m ON m.tag = a.tag
    LEFT JOIN home h ON h.tag = a.tag
    LEFT JOIN public.chapters c ON c.id = h.chapter_id
    LEFT JOIN windows w ON w.tag = a.tag
   ORDER BY a.occurrences DESC, a.last_seen_at DESC
   LIMIT GREATEST(1, LEAST(COALESCE(p_limit, 5), 5));
$$;

COMMENT ON FUNCTION public.get_my_weaknesses(INT) IS
  'Étude 04 A2.1 (US-2) : les erreurs ACTIVES de l''élève, en langage élève et dans les trois langues, avec leur tendance mesurée sur deux fenêtres de 7 jours. Cinq au plus (R-4, même esprit que le plan).';

REVOKE EXECUTE ON FUNCTION public.get_my_weaknesses(INT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_my_weaknesses(INT) TO authenticated;

-- ---------------------------------------------------------------------------
-- 2. A2.2 — les trois erreurs majeures dans le rapport parent (US-3).
-- ---------------------------------------------------------------------------
-- Une fonction dédiée plutôt qu'un CTE de plus dans `_student_report_json` :
-- celle-ci prend l'élève en PARAMÈTRE (le parent n'est pas l'élève, `auth.uid()`
-- y serait faux), et le payload du rapport n'a plus qu'à l'appeler.
--
-- SECURITY DEFINER, et c'est le point sensible : elle lit les erreurs d'un
-- AUTRE utilisateur. Elle est donc REVOKE de `authenticated` et n'est appelable
-- que par `_student_report_json`, qui a déjà vérifié le lien parent-élève. Un
-- parent ne peut pas l'appeler directement sur l'enfant du voisin.
CREATE OR REPLACE FUNCTION public._student_weakness_insights(p_student UUID)
RETURNS JSONB
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  WITH active AS (
    SELECT am.tag, am.occurrences
      FROM public.active_misconceptions(p_student) am
  ),
  windows AS (
    SELECT a.tag,
           count(*) FILTER (WHERE qa.created_at >= now() - INTERVAL '7 days')::INT AS recent_7d,
           count(*) FILTER (
             WHERE qa.created_at >= now() - INTERVAL '14 days'
               AND qa.created_at <  now() - INTERVAL '7 days'
           )::INT AS previous_7d
      FROM active a
      LEFT JOIN public.question_attempts qa
        ON qa.misconception_tag = a.tag
       AND qa.user_id = p_student
       AND qa.created_at >= now() - INTERVAL '14 days'
     GROUP BY a.tag
  )
  SELECT COALESCE(jsonb_agg(x ORDER BY x->>'occurrences' DESC), '[]'::jsonb)
    FROM (
      SELECT jsonb_build_object(
               'tag', a.tag,
               'labelFr', m.label_fr,
               'labelEn', m.label_en,
               'labelAr', m.label_ar,
               'occurrences', a.occurrences,
               'trend', CASE
                          WHEN COALESCE(w.recent_7d, 0) + COALESCE(w.previous_7d, 0) < 3 THEN 'stable'
                          WHEN COALESCE(w.recent_7d, 0) <  COALESCE(w.previous_7d, 0) THEN 'improving'
                          WHEN COALESCE(w.recent_7d, 0) >  COALESCE(w.previous_7d, 0) THEN 'worsening'
                          ELSE 'stable'
                        END
             ) AS x
        FROM active a
        JOIN public.misconceptions m ON m.tag = a.tag
        LEFT JOIN windows w ON w.tag = a.tag
       ORDER BY a.occurrences DESC
       LIMIT 3
    ) t;
$$;

COMMENT ON FUNCTION public._student_weakness_insights(UUID) IS
  'Étude 04 A2.2 (US-3) : les 3 erreurs majeures d''un élève + leur tendance, pour le rapport parent. SECURITY DEFINER et REVOKE de authenticated : le contrôle du lien parent-élève est fait par _student_report_json, son unique appelant.';

REVOKE EXECUTE ON FUNCTION public._student_weakness_insights(UUID) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public._student_weakness_insights(UUID) TO service_role;

-- ---------------------------------------------------------------------------
-- 3. Le payload du rapport parent gagne UNE clé.
-- ---------------------------------------------------------------------------
-- Texte de la révision vivante (`20260818130000`), à une substitution près.
-- La fonction porte la couverture du programme, la comparaison hebdomadaire et
-- les statistiques par matière : la retaper pour ajouter une clé serait le
-- meilleur moyen d'en casser une autre.
--
-- Elle sert les DEUX chemins — parent authentifié et code alliance — parce
-- qu'elle est le point unique de construction du payload. Un parent qui lit le
-- rapport par code voit donc les mêmes erreurs nommées : c'est cohérent avec
-- l'accès au porteur déjà assumé (#753), et aucune correction de quiz n'y fuit.
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
    ),
    -- Étude 04 A2.2 (US-3) : les erreurs NOMMÉES, à côté des chapitres faibles.
    -- Deux axes sur la même donnée : `chapterInsights` dit OÙ ça coince,
    -- celui-ci dit QUOI réviser — et c'est le seul des deux sur lequel un
    -- parent peut agir le soir même.
    'misconceptionInsights', public._student_weakness_insights(p_student)
  );
END;
$fn$;

REVOKE EXECUTE ON FUNCTION public._student_report_json(UUID) FROM PUBLIC, anon, authenticated;
