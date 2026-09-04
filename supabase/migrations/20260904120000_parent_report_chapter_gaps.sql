-- Suivi parental — « 3/20 chapitres » cesse d'être un verdict et dit CE QUI MANQUE.
--
-- LE SIGNALEMENT, ET POURQUOI IL COMPTE PLUS QUE D'HABITUDE
-- ---------------------------------------------------------------------------
-- 2026-09-04, le propriétaire : « mon fils a fait tous les cours et tous les
-- exercices de maths 9ème, et j'ai 3/20 chap. » Le chiffre était JUSTE — vérifié
-- en rejouant la chaîne complète sur un Postgres local, trois scénarios contre
-- `student_parcours_progress` :
--
--   * 4 missions réussies sur 6           → 0 chapitre complet
--   * les 6 réussies                      → 1
--   * les 6 réussies, quiz expédié (<4 s/question) → 0
--
-- Le hub de l'élève affichait bien « 4/6 » sur plusieurs chapitres. Rien n'était
-- cassé. Ce qui était cassé, c'est la LISIBILITÉ : « 3/20 chap. » se lit « il a
-- fait 3 chapitres sur 20 » alors que ça veut dire « il en a MAÎTRISÉ 3 » — et le
-- suivi ne disait nulle part ce qu'il fallait faire pour que le 4ᵉ compte.
--
-- ⚠️ L'auteur du produit lui-même a lu ce chiffre de travers. Quand c'est celui
-- qui a écrit la règle qui se trompe en la lisant, ce n'est pas le lecteur qui
-- est en tort — c'est le chiffre. Un parent à qui l'on montre un verdict sans
-- l'action qui le lève ne peut rien en faire, et c'est exactement ce que la
-- Definition of Excellence (étude 26) appelle une expérience incomplète.
--
-- LA PORTE INVISIBLE. Le troisième scénario est le plus dur : un chapitre peut
-- afficher « 6/6 missions » et ne toujours pas compter, parce que le quiz de
-- compréhension a été expédié à moins de 4 s par question. Cette condition
-- n'était écrite NULLE PART — ni côté élève, ni côté parent. Elle l'est ici.
--
-- CE QUE CETTE MIGRATION AJOUTE, ET CE QU'ELLE NE TOUCHE PAS
-- ---------------------------------------------------------------------------
-- AUCUNE RÈGLE NOUVELLE. `student_chapter_gaps` répond à « pourquoi ce chapitre
-- ne compte pas » avec exactement les prédicats de `student_parcours_progress`
-- (20260816200000) — mission de catalogue = `source='admin'` et `mode <> 'quiz'`,
-- réussie = meilleure tentative `variant='classic'` ≥ 60 %, quiz validé = ≥ 80 %
-- ET ≥ 4 s/question. Si l'une des deux fonctions changeait sans l'autre, le
-- parent lirait « il ne manque rien » sous un « 3/20 » : d'où l'assertion pgTAP
-- qui les confronte sur le même décor plutôt qu'une promesse en commentaire.
--
-- ⭐ LA FONCTION DE CALCUL DU RAPPORT N'EST PAS ROUVERTE. C'est le patron posé
-- par 20260817160000 : l'enveloppe ENRICHIT la charge utile (`||`), les 460
-- lignes de `_student_daily_report_json` restent intactes, donc ce lot ne peut
-- pas y introduire de régression. Le périmètre déjà résolu par l'enveloppe est
-- passé tel quel — les lacunes suivent le filtre que le parent a choisi.

-- ---------------------------------------------------------------------------
-- 1. Ce qui manque à un chapitre pour compter.
--
--    Seulement les chapitres PUBLIÉS et NON complets : un chapitre terminé n'a
--    rien à demander, un chapitre sans mission n'est jouable par personne.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.student_chapter_gaps(
  p_user UUID,
  p_subject_ids TEXT[] DEFAULT NULL,
  p_per_subject INT DEFAULT 3
)
RETURNS TABLE (
  subject_id TEXT,
  chapter_id UUID,
  title TEXT,
  missions_total INT,
  missions_passed INT,
  quiz_gated BOOLEAN,
  quiz_satisfied BOOLEAN
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  WITH missions AS (
    -- La mission de catalogue, et son état — mêmes prédicats que
    -- `student_parcours_progress`, pas une reformulation.
    SELECT
      c.id AS chapter_id,
      c.subject_id,
      c.title,
      c.display_order,
      e.id AS exercise_id,
      EXISTS (
        SELECT 1
          FROM public.attempts a
         WHERE a.user_id = p_user
           AND a.exercise_id = e.id
           AND a.variant = 'classic'
           AND a.score_pct >= 60
      ) AS passed
      FROM public.chapters c
      JOIN public.exercises e
        ON e.chapter_id = c.id
       AND e.source = 'admin'
       AND e.mode IS DISTINCT FROM 'quiz'
     WHERE (p_subject_ids IS NULL OR c.subject_id = ANY (p_subject_ids))
  ),
  gated AS (
    SELECT
      c.id AS chapter_id,
      (s.grade_id IS NOT NULL AND q.id IS NOT NULL) AS quiz_gated,
      q.id AS quiz_id
      FROM public.chapters c
      JOIN public.subjects s ON s.id = c.subject_id
      -- ⚠️ `ORDER BY` avant `LIMIT`, là où `student_parcours_progress` s'en
      -- passe : un chapitre à deux quiz y rendrait un quiz ARBITRAIRE, donc une
      -- réponse instable d'un plan à l'autre. Rien n'interdit aujourd'hui deux
      -- quiz dans un chapitre — aucune contrainte, aucun gate de contenu — et le
      -- jour où ça arrive, le parent et l'élève liraient deux verdicts
      -- différents sans que rien ne tombe. Ici l'ordre est déterministe ; la
      -- même correction est due à 20260816200000, elle demande son propre lot
      -- (elle change un résultat, pas seulement un affichage).
      LEFT JOIN LATERAL (
        SELECT e.id
          FROM public.exercises e
         WHERE e.chapter_id = c.id
           AND e.mode = 'quiz'
         ORDER BY e.display_order, e.id
         LIMIT 1
      ) q ON TRUE
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
      g.quiz_gated,
      (
        NOT g.quiz_gated
        OR EXISTS (
          SELECT 1
            FROM public.attempts a
           WHERE a.user_id = p_user
             AND a.exercise_id = g.quiz_id
             AND a.score_pct >= 80
             AND a.duration_seconds >= a.total_count * 4
        )
      ) AS quiz_satisfied
      FROM missions m
      JOIN gated g ON g.chapter_id = m.chapter_id
     GROUP BY m.subject_id, m.chapter_id, m.title, m.display_order, g.quiz_gated, g.quiz_id
  ),
  ranked AS (
    SELECT
      r.*,
      -- « Le plus proche du but » d'abord : c'est ce qui rend la carte
      -- ACTIONNABLE. Un chapitre à qui il ne manque que le quiz vient en tête —
      -- c'est UN geste, et personne ne sait aujourd'hui qu'il est dû.
      row_number() OVER (
        PARTITION BY r.subject_id
        ORDER BY (r.missions_total - r.missions_passed) ASC,
                 r.missions_passed DESC,
                 r.display_order,
                 r.chapter_id
      ) AS rn
      FROM rolled r
     WHERE NOT (r.quiz_satisfied AND r.missions_passed = r.missions_total)
  )
  SELECT
    ranked.subject_id,
    ranked.chapter_id,
    ranked.title,
    ranked.missions_total,
    ranked.missions_passed,
    ranked.quiz_gated,
    ranked.quiz_satisfied
    FROM ranked
   WHERE ranked.rn <= GREATEST(p_per_subject, 0)
   ORDER BY ranked.subject_id, ranked.rn;
$fn$;

-- Interne : seules les enveloppes du rapport (définer) l'appellent. Un élève ne
-- lit jamais les lacunes d'un autre par cette porte.
REVOKE EXECUTE ON FUNCTION public.student_chapter_gaps(UUID, TEXT[], INT)
  FROM PUBLIC, anon, authenticated;

COMMENT ON FUNCTION public.student_chapter_gaps(UUID, TEXT[], INT) IS
  'Ce qui manque à un chapitre publié pour compter comme maîtrisé — mêmes prédicats que student_parcours_progress, jamais une seconde définition. Le plus proche du but en premier.';

-- ---------------------------------------------------------------------------
-- 2. L'enveloppe enrichit. Le calcul du rapport n'est PAS rouvert (patron de
--    20260817160000, et c'est ce qui rend ce lot incapable de régresser dessus).
--
--    Corps identique à sa révision vivante, à l'exception de la dernière ligne.
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
             'quizSatisfied', g.quiz_satisfied
           )
         ), '[]'::jsonb)
    INTO v_gaps
    FROM public.student_chapter_gaps(p_student, v_subject_ids, 3) g;

  RETURN v_payload || jsonb_build_object('scopes', v_scopes, 'chapterGaps', v_gaps);
END;
$fn$;

REVOKE EXECUTE ON FUNCTION public._daily_report_with_scopes(UUID, DATE, DATE, TEXT)
  FROM PUBLIC, anon, authenticated;
