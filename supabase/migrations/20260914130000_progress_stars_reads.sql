-- ÉTOILES & SCEAUX — LES LECTURES (étude 34, lot 1/5, seconde moitié).
--
-- La migration jumelle `20260914120000` pose la règle et le grand livre. Ici,
-- ce que les écrans liront — et le rebranchement des lecteurs existants, pour
-- qu'il n'y ait pas DEUX vérités sur la progression d'un chapitre.
--
--   * `student_subject_stars`  — l'agrégat par matière (interne) ;
--   * `student_parcours_progress` — REDÉFINIE comme une projection du premier,
--     à signature identique : ses trois appelants ne bougent pas et deviennent
--     MONOTONES par construction ;
--   * `get_subject_progress`  — la charge du hub matière (RPC élève) ;
--   * `get_attempt_progress`  — le delta d'une soumission, pour la célébration
--     (RPC élève, propriétaire de la tentative uniquement) ;
--   * `student_chapter_gaps`  — deux colonnes de plus : la PROCHAINE étoile et
--     ce qui la sépare de l'élève ;
--   * `_daily_report_with_scopes` — l'enveloppe les fait voyager.
--
-- ⚠️ CE QUE CE LOT NE TOUCHE PAS, ET C'EST DÉLIBÉRÉ : `submit_exercise_attempt`
-- (D-4), `award_xp`, la porte du quiz, `resolve_exercise_access`, les RPC de
-- duel / donjon / examen / Rappel, `get_daily_plan`, `admin_engagement_overview`
-- (lot 3) et le moteur de contenu. Aucune UI, aucun badge, aucune récompense.
--
-- ⭐ LE CHANGEMENT DE FOND, EN UNE PHRASE : `chapters_completed` ne se calcule
-- plus sur le contenu du jour, il se LIT dans le grand livre. Il ne peut donc
-- plus baisser quand une campagne ajoute une mission — ce qui est tout l'objet
-- de l'étude 34. La DÉFINITION, elle, ne bouge pas d'un cran : « maîtrisé » =
-- toutes les missions de catalogue réussies, quiz compris (Q-2, arbitrée le
-- 2026-09-14 CONTRE la recommandation de l'architecte, qui proposait de
-- descendre la barre à l'étoile 3). La série de `chapters_per_active` reste
-- donc comparable d'avant à après.

-- ---------------------------------------------------------------------------
-- 1. L'AGRÉGAT PAR MATIÈRE (interne).
--
--    Grand livre pour ce qui est ACQUIS (`chapters_starN`, `seal_*`), vivant
--    pour ce qui reste à faire (`chapters_total`, `chapters_started`) et pour
--    ce qui vient d'arriver (`new_*`). C'est exactement le partage de R-6.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.student_subject_stars(
  p_user UUID,
  p_subject_ids TEXT[] DEFAULT NULL
)
RETURNS TABLE (
  subject_id       TEXT,
  chapters_total   INT,
  chapters_started INT,
  chapters_star1   INT,
  chapters_star2   INT,
  chapters_star3   INT,
  chapters_star4   INT,
  seal_star        SMALLINT,
  seal_at          TIMESTAMPTZ,
  new_chapters     INT,
  new_missions     INT
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  WITH published AS (
    -- Définition INCHANGÉE depuis é22 R-16 : un chapitre compte s'il porte au
    -- moins une mission de catalogue, donc s'il est jouable.
    SELECT c.id AS chapter_id, c.subject_id, c.created_at
      FROM public.chapters c
     WHERE (p_subject_ids IS NULL OR c.subject_id = ANY (p_subject_ids))
       AND EXISTS (
         SELECT 1 FROM public.exercises e
          WHERE e.chapter_id = c.id
            AND e.source = 'admin'
            AND e.mode IS DISTINCT FROM 'quiz'
       )
  ),
  subject_ref AS (
    -- La référence de nouveauté d'une MATIÈRE : son dernier sceau, ou sa
    -- dernière tentative. Même esprit que `chapter_progress_ref`.
    SELECT
      p.subject_id,
      GREATEST(
        (SELECT MAX(sl.reached_at) FROM public.user_subject_seals sl
          WHERE sl.user_id = p_user AND sl.subject_id = p.subject_id),
        (SELECT MAX(a.completed_at) FROM public.attempts a
          WHERE a.user_id = p_user AND a.subject_id = p.subject_id)
      ) AS at
      FROM (SELECT DISTINCT pb.subject_id FROM published pb) p
  ),
  per_chapter AS (
    SELECT
      pb.subject_id,
      pb.chapter_id,
      pb.created_at,
      COALESCE((SELECT MAX(s.star) FROM public.user_chapter_stars s
                 WHERE s.user_id = p_user AND s.chapter_id = pb.chapter_id), 0) AS star,
      EXISTS (SELECT 1 FROM public.attempts a
                JOIN public.exercises e ON e.id = a.exercise_id
               WHERE a.user_id = p_user AND e.chapter_id = pb.chapter_id) AS started,
      (SELECT COALESCE(SUM(r.missions_new), 0)::INT
         FROM public.chapter_star_rungs(p_user, pb.chapter_id) r) AS new_missions
      FROM published pb
  )
  SELECT
    pc.subject_id,
    count(*)::INT,
    count(*) FILTER (WHERE pc.started)::INT,
    count(*) FILTER (WHERE pc.star >= 1)::INT,
    count(*) FILTER (WHERE pc.star >= 2)::INT,
    count(*) FILTER (WHERE pc.star >= 3)::INT,
    count(*) FILTER (WHERE pc.star >= 4)::INT,
    (SELECT MAX(sl.star) FROM public.user_subject_seals sl
      WHERE sl.user_id = p_user AND sl.subject_id = pc.subject_id)::SMALLINT,
    (SELECT sl.reached_at FROM public.user_subject_seals sl
      WHERE sl.user_id = p_user AND sl.subject_id = pc.subject_id
      ORDER BY sl.star DESC LIMIT 1),
    -- Un chapitre NOUVEAU : publié après la référence de la matière, et jamais
    -- touché. Jamais signalé à qui n'a pas de référence (R-7).
    count(*) FILTER (
      WHERE sr.at IS NOT NULL AND pc.created_at > sr.at AND NOT pc.started
    )::INT,
    COALESCE(SUM(pc.new_missions), 0)::INT
    FROM per_chapter pc
    JOIN subject_ref sr ON sr.subject_id = pc.subject_id
   GROUP BY pc.subject_id;
$fn$;

COMMENT ON FUNCTION public.student_subject_stars(UUID, TEXT[]) IS
  'Étude 34 : la progression d''une matière — distribution des étoiles et sceau LUS AU GRAND LIVRE, total et nouveautés calculés sur le contenu vivant. Interne : les enveloppes définer et la RPC self-scopée y accèdent, jamais un client.';

REVOKE ALL ON FUNCTION public.student_subject_stars(UUID, TEXT[]) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 2. `student_parcours_progress` — MÊME SIGNATURE, projection du grand livre.
--
--    Ses trois appelants (`get_user_parcours_progress` pour la carte de
--    l'élève, `_student_report_json` pour le bilan, `_student_daily_report_json`
--    pour le suivi quotidien) ne changent pas d'une ligne et deviennent
--    monotones. « chapitres maîtrisés » = étoile 4 = toutes les missions de
--    catalogue réussies : la définition de é22 R-15, à l'identique.
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
  SELECT s.subject_id, s.chapters_total, s.chapters_star4
    FROM public.student_subject_stars(p_user, p_subject_ids) s;
$fn$;

COMMENT ON FUNCTION public.student_parcours_progress(UUID, TEXT[]) IS
  'Progression d''une matière (é22 R-16) — désormais une projection de student_subject_stars : chapters_completed = chapitres à l''étoile 4, LUS AU GRAND LIVRE. Même définition qu''avant (Q-2 de é34), mais elle ne redescend plus quand du contenu arrive.';

REVOKE EXECUTE ON FUNCTION public.student_parcours_progress(UUID, TEXT[])
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 3. LA CHARGE DU HUB MATIÈRE (RPC élève, self-scopée).
--
--    Elle rend d'un coup : les sceaux, le prochain sceau, l'effort, l'état de
--    chaque chapitre (jauge comprise) et l'état de chaque mission.
--
--    ⭐ `missions` remplace `get_best_scores_by_exercise` POUR CET USAGE, et
--    c'est une correction de fond : cette RPC-là ne filtre PAS la variante
--    (20260603110000), alors que la règle de complétion exige `classic`. Une
--    reprise en Rappel à ≥ 60 % cochait donc au hub une mission que le serveur
--    ne comptait pas — le commentaire de `chapter-completion.ts` affirmait
--    pourtant le contraire. La divergence disparaît par construction.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_subject_progress(p_subject_id TEXT)
RETURNS JSONB
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  WITH agg AS (
    SELECT s.*
      FROM public.student_subject_stars((SELECT auth.uid()), ARRAY[p_subject_id]) s
  ),
  subject_ref AS (
    SELECT GREATEST(
      (SELECT MAX(sl.reached_at) FROM public.user_subject_seals sl
        WHERE sl.user_id = (SELECT auth.uid()) AND sl.subject_id = p_subject_id),
      (SELECT MAX(a.completed_at) FROM public.attempts a
        WHERE a.user_id = (SELECT auth.uid()) AND a.subject_id = p_subject_id)
    ) AS at
  ),
  published AS (
    SELECT c.id AS chapter_id, c.created_at, c.display_order
      FROM public.chapters c
     WHERE c.subject_id = p_subject_id
       AND EXISTS (
         SELECT 1 FROM public.exercises e
          WHERE e.chapter_id = c.id
            AND e.source = 'admin'
            AND e.mode IS DISTINCT FROM 'quiz'
       )
  ),
  chapters AS (
    SELECT
      pb.chapter_id,
      pb.display_order,
      COALESCE((SELECT MAX(s.star) FROM public.user_chapter_stars s
                 WHERE s.user_id = (SELECT auth.uid()) AND s.chapter_id = pb.chapter_id), 0)::SMALLINT AS star,
      public.chapter_star_live((SELECT auth.uid()), pb.chapter_id) AS star_live,
      public.chapter_quiz_gated(pb.chapter_id) AS quiz_gated,
      public.chapter_quiz_cleared((SELECT auth.uid()), pb.chapter_id) AS quiz_cleared,
      (SELECT COALESCE(jsonb_agg(jsonb_build_object(
                'difficulty', r.difficulty,
                'total',      r.missions_total,
                'counted',    r.missions_counted,
                'new',        r.missions_new
              ) ORDER BY r.difficulty), '[]'::jsonb)
         FROM public.chapter_star_rungs((SELECT auth.uid()), pb.chapter_id) r) AS rungs,
      (SELECT COALESCE(SUM(r.missions_new), 0)::INT
         FROM public.chapter_star_rungs((SELECT auth.uid()), pb.chapter_id) r) AS new_missions,
      -- Les missions de la FAMILLE (source = 'parent') : leur propre ligne,
      -- jamais dans une étoile ni dans un sceau (R-2, Q-5 arbitrée). La règle
      -- est prospective : toute source future (élève, IA) suivra la même.
      (SELECT count(*)::INT FROM public.exercises e
        WHERE e.chapter_id = pb.chapter_id AND e.source = 'parent'
          AND e.mode IS DISTINCT FROM 'quiz') AS family_total,
      (SELECT count(*)::INT FROM public.exercises e
        WHERE e.chapter_id = pb.chapter_id AND e.source = 'parent'
          AND e.mode IS DISTINCT FROM 'quiz'
          AND public.mission_is_counted((SELECT auth.uid()), e.id)) AS family_counted,
      -- Un CHAPITRE nouveau : publié après la référence de la matière, et
      -- jamais touché (R-7).
      (
        (SELECT sr.at FROM subject_ref sr) IS NOT NULL
        AND pb.created_at > (SELECT sr.at FROM subject_ref sr)
        AND NOT EXISTS (
          SELECT 1 FROM public.attempts a
            JOIN public.exercises e ON e.id = a.exercise_id
           WHERE a.user_id = (SELECT auth.uid()) AND e.chapter_id = pb.chapter_id
        )
      ) AS is_new
      FROM published pb
  ),
  missions AS (
    SELECT
      e.id AS exercise_id,
      e.chapter_id,
      e.source,
      public.mission_is_counted((SELECT auth.uid()), e.id) AS counted,
      (SELECT MAX(a.score_pct)::INT FROM public.attempts a
        WHERE a.user_id = (SELECT auth.uid()) AND a.exercise_id = e.id
          AND a.variant = 'classic') AS best_classic,
      (
        (SELECT sr.at FROM subject_ref sr) IS NOT NULL
        AND e.created_at > (SELECT sr.at FROM subject_ref sr)
        AND NOT EXISTS (
          SELECT 1 FROM public.attempts a
           WHERE a.user_id = (SELECT auth.uid()) AND a.exercise_id = e.id
        )
      ) AS is_new
      FROM public.exercises e
     WHERE e.subject_id = p_subject_id
       AND e.mode IS DISTINCT FROM 'quiz'
  )
  SELECT jsonb_build_object(
    'subjectId', p_subject_id,
    'seals', COALESCE((
      SELECT jsonb_agg(jsonb_build_object('star', sl.star, 'reachedAt', sl.reached_at) ORDER BY sl.star)
        FROM public.user_subject_seals sl
       WHERE sl.user_id = (SELECT auth.uid()) AND sl.subject_id = p_subject_id
    ), '[]'::jsonb),
    'nextSeal', (
      SELECT CASE
        WHEN COALESCE(a.seal_star, 0) >= 4 THEN NULL
        ELSE jsonb_build_object(
          'star',          COALESCE(a.seal_star, 0) + 1,
          'chaptersReady', CASE COALESCE(a.seal_star, 0)
                             WHEN 0 THEN a.chapters_star1
                             WHEN 1 THEN a.chapters_star2
                             WHEN 2 THEN a.chapters_star3
                             ELSE a.chapters_star4
                           END,
          'chaptersTotal', a.chapters_total,
          'newChapters',   a.new_chapters
        )
      END FROM agg a
    ),
    'effort', jsonb_build_object(
      'missionsCounted', (SELECT count(*)::INT FROM missions m WHERE m.counted AND m.source = 'admin'),
      'xp',              COALESCE((SELECT SUM(a.xp_earned)::INT FROM public.attempts a
                                    WHERE a.user_id = (SELECT auth.uid())
                                      AND a.subject_id = p_subject_id), 0),
      'chaptersStarted',  COALESCE((SELECT a.chapters_started FROM agg a), 0),
      'chaptersMastered', COALESCE((SELECT a.chapters_star4 FROM agg a), 0)
    ),
    'chapters', COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'chapterId',   ch.chapter_id,
        'star',        ch.star,
        'starLive',    ch.star_live,
        'mastered',    ch.star >= 4,
        'isNew',       ch.is_new,
        'quiz',        jsonb_build_object('gated', ch.quiz_gated, 'cleared', ch.quiz_cleared),
        'rungs',       ch.rungs,
        'newMissions', ch.new_missions,
        'family',      jsonb_build_object('total', ch.family_total, 'counted', ch.family_counted)
      ) ORDER BY ch.display_order, ch.chapter_id)
        FROM chapters ch
    ), '[]'::jsonb),
    'missions', COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'exerciseId',  m.exercise_id,
        'chapterId',   m.chapter_id,
        'source',      m.source,
        'counted',     m.counted,
        'bestClassic', m.best_classic,
        'mastered',    COALESCE(m.best_classic, 0) >= 100,
        'isNew',       m.is_new
      ))
        FROM missions m
    ), '[]'::jsonb)
  );
$fn$;

COMMENT ON FUNCTION public.get_subject_progress(TEXT) IS
  'Étude 34 : la charge du hub matière — sceaux, prochain sceau, effort, jauge de chaque chapitre, état de chaque mission. Self-scopée sur auth.uid().';

REVOKE ALL ON FUNCTION public.get_subject_progress(TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_subject_progress(TEXT) TO authenticated;

-- ---------------------------------------------------------------------------
-- 4. LE DELTA D'UNE SOUMISSION (RPC élève) — ce que l'écran de résultat célèbre.
--
--    Lue APRÈS `submit_exercise_attempt`, elle dit ce que CETTE tentative a
--    fait tomber. C'est la contrepartie de D-4 : on ne greffe rien dans la RPC
--    de soumission, on lit le résultat du trigger.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_attempt_progress(p_attempt_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_user    UUID := (SELECT auth.uid());
  v_chapter UUID;
  v_out     JSONB;
BEGIN
  -- Le propriétaire de la tentative, et personne d'autre.
  SELECT e.chapter_id INTO v_chapter
    FROM public.attempts a
    JOIN public.exercises e ON e.id = a.exercise_id
   WHERE a.id = p_attempt_id
     AND a.user_id = v_user;

  IF v_chapter IS NULL THEN
    RETURN NULL;
  END IF;

  SELECT jsonb_build_object(
    'chapterId', v_chapter,
    'starBefore', COALESCE((
      SELECT MAX(s.star) FROM public.user_chapter_stars s
       WHERE s.user_id = v_user AND s.chapter_id = v_chapter
         AND s.attempt_id IS DISTINCT FROM p_attempt_id
    ), 0),
    'starAfter', COALESCE((
      SELECT MAX(s.star) FROM public.user_chapter_stars s
       WHERE s.user_id = v_user AND s.chapter_id = v_chapter
    ), 0),
    'newStars', COALESCE((
      SELECT jsonb_agg(s.star ORDER BY s.star) FROM public.user_chapter_stars s
       WHERE s.user_id = v_user AND s.chapter_id = v_chapter AND s.attempt_id = p_attempt_id
    ), '[]'::jsonb),
    'newSeals', COALESCE((
      SELECT jsonb_agg(jsonb_build_object('subjectId', sl.subject_id, 'star', sl.star) ORDER BY sl.star)
        FROM public.user_subject_seals sl
       WHERE sl.user_id = v_user AND sl.attempt_id = p_attempt_id
    ), '[]'::jsonb),
    'rungs', COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
               'difficulty', r.difficulty,
               'total',      r.missions_total,
               'counted',    r.missions_counted,
               'new',        r.missions_new
             ) ORDER BY r.difficulty)
        FROM public.chapter_star_rungs(v_user, v_chapter) r
    ), '[]'::jsonb)
    -- ⭐ Le lot 4 ajoutera ici `newBadges`, lu dans `student_badges` par
    -- `awarded_reason = 'stars:' || p_attempt_id`. Rien d'autre.
  ) INTO v_out;

  RETURN v_out;
END;
$fn$;

COMMENT ON FUNCTION public.get_attempt_progress(UUID) IS
  'Étude 34 D-4 : ce qu''une soumission vient de faire tomber (étoiles, sceaux, état des crans). Lue par l''écran de résultat, propriétaire de la tentative uniquement.';

REVOKE ALL ON FUNCTION public.get_attempt_progress(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_attempt_progress(UUID) TO authenticated;

-- ---------------------------------------------------------------------------
-- 5. `student_chapter_gaps` — ce qui manque, exprimé en PROCHAINE ÉTOILE.
--
--    La fonction d'arena#987 répondait « pourquoi ce chapitre ne compte pas »
--    en missions manquantes. Elle répond désormais « quelle est la prochaine
--    étoile, et qu'est-ce qui l'en sépare » — deux colonnes additives, le
--    reste ligne pour ligne.
--
--    ⚠️ Le type de retour change, donc DROP puis CREATE : `CREATE OR REPLACE`
--    refuse un `RETURNS TABLE` différent. C'est atomique dans la transaction de
--    la migration — à aucun instant la fonction ne manque à ses appelants — et
--    ce n'est pas une migration destructive au sens du DoD §7 : rien n'est
--    perdu, la fonction est recréée deux lignes plus bas.
--
--    ⭐ `missions_passed` passe à `mission_is_counted` : les deux lecteurs
--    (gaps et progression) appliquent le MÊME prédicat, y compris son volet
--    anti-précipitation. Sans cela le parent lirait « il ne manque rien » sous
--    un chapitre qui n'a pas son étoile — le défaut exact que le pgTAP 95
--    surveille depuis arena#987.
-- ---------------------------------------------------------------------------
DROP FUNCTION IF EXISTS public.student_chapter_gaps(UUID, TEXT[], INT);

CREATE FUNCTION public.student_chapter_gaps(
  p_user UUID,
  p_subject_ids TEXT[] DEFAULT NULL,
  p_per_subject INT DEFAULT 3
)
RETURNS TABLE (
  subject_id       TEXT,
  chapter_id       UUID,
  title            TEXT,
  missions_total   INT,
  missions_passed  INT,
  quiz_gated       BOOLEAN,
  quiz_satisfied   BOOLEAN,
  next_star        SMALLINT,
  missing_for_next INT
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  WITH missions AS (
    SELECT
      c.id AS chapter_id,
      c.subject_id,
      c.title,
      c.display_order,
      e.id AS exercise_id,
      LEAST(GREATEST(e.difficulty, 1), 4)::SMALLINT AS difficulty,
      public.mission_is_counted(p_user, e.id) AS passed
      FROM public.chapters c
      JOIN public.exercises e
        ON e.chapter_id = c.id
       AND e.source = 'admin'
       AND e.mode IS DISTINCT FROM 'quiz'
     WHERE (p_subject_ids IS NULL OR c.subject_id = ANY (p_subject_ids))
  ),
  rolled AS (
    SELECT
      m.subject_id,
      m.chapter_id,
      m.title,
      m.display_order,
      count(*)::INT AS missions_total,
      count(*) FILTER (WHERE m.passed)::INT AS missions_passed,
      public.chapter_quiz_gated(m.chapter_id) AS quiz_gated,
      public.chapter_quiz_cleared(p_user, m.chapter_id) AS quiz_satisfied,
      -- La prochaine étoile se lit sur le GRAND LIVRE : un chapitre dont
      -- l'étoile 2 est acquise vise la 3, même si le contenu a grandi depuis.
      (LEAST(COALESCE((SELECT MAX(s.star) FROM public.user_chapter_stars s
                        WHERE s.user_id = p_user AND s.chapter_id = m.chapter_id), 0), 3) + 1)::SMALLINT AS next_star
      FROM missions m
     GROUP BY m.subject_id, m.chapter_id, m.title, m.display_order
  ),
  distanced AS (
    SELECT
      r.*,
      -- La DISTANCE à la prochaine étoile, en gestes : les missions de
      -- difficulté <= next_star qui ne comptent pas encore, PLUS le quiz s'il
      -- gate et n'est pas franchi. Un chapitre auquel il ne manque que le quiz
      -- est donc à UN geste — et c'est lui qui doit remonter en tête, parce que
      -- personne ne sait aujourd'hui qu'il est dû.
      (
        (SELECT count(*)::INT FROM missions m2
          WHERE m2.chapter_id = r.chapter_id
            AND m2.difficulty <= r.next_star
            AND NOT m2.passed)
        + CASE WHEN r.quiz_gated AND NOT r.quiz_satisfied THEN 1 ELSE 0 END
      ) AS missing_for_next
      FROM rolled r
  ),
  ranked AS (
    SELECT
      d.*,
      row_number() OVER (
        PARTITION BY d.subject_id
        ORDER BY d.missing_for_next ASC,
                 (d.missions_total - d.missions_passed) ASC,
                 d.missions_passed DESC,
                 d.display_order,
                 d.chapter_id
      ) AS rn
      FROM distanced d
     WHERE NOT (d.quiz_satisfied AND d.missions_passed = d.missions_total)
  )
  SELECT
    ranked.subject_id,
    ranked.chapter_id,
    ranked.title,
    ranked.missions_total,
    ranked.missions_passed,
    ranked.quiz_gated,
    ranked.quiz_satisfied,
    ranked.next_star,
    ranked.missing_for_next
    FROM ranked
   WHERE ranked.rn <= GREATEST(p_per_subject, 0)
   ORDER BY ranked.subject_id, ranked.rn;
$fn$;

REVOKE EXECUTE ON FUNCTION public.student_chapter_gaps(UUID, TEXT[], INT)
  FROM PUBLIC, anon, authenticated;

COMMENT ON FUNCTION public.student_chapter_gaps(UUID, TEXT[], INT) IS
  'Ce qui manque à un chapitre pour gagner sa PROCHAINE étoile (étude 34) — mêmes prédicats que student_subject_stars, jamais une seconde définition. Le plus proche du but en premier.';

-- ---------------------------------------------------------------------------
-- 6. L'ENVELOPPE DU SUIVI QUOTIDIEN — les deux colonnes voyagent.
--
--    Corps identique à sa révision vivante (20260904120000), à l'exception des
--    deux clés ajoutées au JSON des lacunes. Le calcul du rapport n'est PAS
--    rouvert : c'est le patron de 20260817160000, et c'est ce qui rend ce lot
--    incapable d'y introduire une régression.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public._daily_report_with_scopes(
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
DECLARE
  v_scope TEXT;
  v_subject_ids TEXT[];
  v_payload JSONB;
  v_scopes JSONB;
  v_applied TEXT;
  v_label TEXT;
  v_gaps JSONB;
BEGIN
  -- « class » est un alias du niveau courant. Le résoudre ici plutôt que de le
  -- laisser tel quel évite une clé qui n'existe dans aucune entrée de la liste —
  -- le sélecteur ne saurait ni la surligner ni la nommer.
  v_scope := p_scope;
  IF v_scope = 'class' THEN
    SELECT 'grade:' || pr.current_grade_id::text INTO v_scope
    FROM public.profiles pr
    WHERE pr.id = p_student AND pr.current_grade_id IS NOT NULL;
    v_scope := COALESCE(v_scope, 'all');
  END IF;

  v_subject_ids := public._scope_subject_ids(p_student, v_scope);
  v_scopes := public._student_activity_scopes(p_student);

  -- Ce qui a VRAIMENT été appliqué : un périmètre qui ne filtre rien s'annonce
  -- « all », sinon le sélecteur afficherait une sélection que les chiffres
  -- démentent.
  v_applied := CASE WHEN v_subject_ids IS NULL THEN 'all' ELSE COALESCE(v_scope, 'all') END;

  SELECT s ->> 'label' INTO v_label
  FROM jsonb_array_elements(v_scopes) s
  WHERE s ->> 'key' = v_applied;

  v_payload := public._student_daily_report_json(p_student, p_from, p_to, v_subject_ids);

  v_payload := jsonb_set(v_payload, '{scope,applied}', to_jsonb(v_applied));
  v_payload := jsonb_set(v_payload, '{scope,label}', COALESCE(to_jsonb(v_label), 'null'::jsonb));

  -- Les lacunes suivent le périmètre choisi : montrer sous une matière filtrée
  -- des chapitres d'une autre serait pire que de ne rien montrer.
  SELECT COALESCE(jsonb_agg(
           jsonb_build_object(
             'subjectId', g.subject_id,
             'chapterId', g.chapter_id,
             'title', g.title,
             'missionsTotal', g.missions_total,
             'missionsPassed', g.missions_passed,
             'quizGated', g.quiz_gated,
             'quizSatisfied', g.quiz_satisfied,
             -- Étude 34 : la prochaine étoile, et ce qui l'en sépare.
             'nextStar', g.next_star,
             'missingForNext', g.missing_for_next
           )
         ), '[]'::jsonb)
    INTO v_gaps
    FROM public.student_chapter_gaps(p_student, v_subject_ids, 3) g;

  RETURN v_payload || jsonb_build_object('scopes', v_scopes, 'chapterGaps', v_gaps);
END;
$fn$;

REVOKE EXECUTE ON FUNCTION public._daily_report_with_scopes(UUID, DATE, DATE, TEXT)
  FROM PUBLIC, anon, authenticated;
