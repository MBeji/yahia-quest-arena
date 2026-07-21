-- Knowledge graph — étude 07 lot 4 (FableEtudes/07-knowledge-graph-competences #lot-4).
--
-- Les trois lectures qui rendent le graphe (lot 1) et la maîtrise (lot 2) VISIBLES :
--
--   * get_my_competency_map(family)  — US-1 : ma carte de compétences, oubli appliqué,
--     plus le signal de tendance ;
--   * get_competency_blockers(comp)  — R-5 : « ce qui te bloque », les prérequis faibles
--     remontés dans le DAG, bornés en profondeur ;
--   * get_exercises_for_competency(comp) — US-2 : les exercices EXISTANTS qui l'évaluent,
--     passés par la porte d'accès (R-3).
--
-- SÉCURITÉ. Les deux premières sont **SECURITY DEFINER** — à rebours de `get_daily_plan`
-- (INVOKER) — parce qu'elles appellent `competency_mastery_with_decay()`, délibérément rendue
-- non-exécutable côté client au lot 2 (l'oubli est un détail d'implémentation du socle, pas une
-- API). Elles ne prennent JAMAIS d'identifiant d'élève en paramètre : le périmètre est
-- `(SELECT auth.uid())`, en dur, dans chaque requête (R-6). Sans session, `auth.uid()` est NULL,
-- le filtre ne rend rien et la fonction renvoie vide au lieu de lever. `get_exercises_for_competency`
-- reste INVOKER : elle ne lit que le catalogue (public) et délègue l'accès à
-- `resolve_exercise_access`, exactement comme `get_daily_plan`.
--
-- TENDANCE (US-1). Le modèle de données ne garde qu'une maîtrise COURANTE, pas d'historique.
-- La carte ne peut donc pas afficher un delta de maîtrise sur 14 jours. Elle renvoie à la place
-- `recent_result` : la réussite moyenne (0–100) des 14 derniers jours sur les questions de la
-- compétence, depuis `question_attempts`. Le client compose la flèche ▲▼ en comparant ce fait à
-- la maîtrise (même posture « le serveur rend des faits, l'UI les met en langue ») — sans table
-- d'historique. NULL quand rien n'a été joué sur la période.

-- ---------------------------------------------------------------------------
-- 1. get_my_competency_map — US-1 (maîtrise + oubli + tendance), par famille.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_my_competency_map(p_subject_family TEXT DEFAULT NULL)
RETURNS TABLE (
  competency_id UUID,
  slug          TEXT,
  family        TEXT,
  domain        TEXT,
  label_fr      TEXT,
  label_en      TEXT,
  label_ar      TEXT,
  mastery       NUMERIC,   -- oubli appliqué (R-4)
  attempts      INT,
  recent_result NUMERIC    -- réussite moyenne 14 j (0–100), NULL si rien joué
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT
    c.id,
    c.slug,
    c.family,
    -- Le domaine est le 2ᵉ segment de l'id (`math.geo.thales-direct` → `geo`) : la carte se
    -- groupe par domaine sans table supplémentaire (D-1, l'id EST la structure).
    split_part(c.slug, '.', 2) AS domain,
    c.label_fr,
    c.label_en,
    c.label_ar,
    public.competency_mastery_with_decay(m.mastery, m.last_attempt_at) AS mastery,
    m.attempts,
    rec.recent_result
  FROM public.user_competency_mastery m
  JOIN public.competencies c ON c.id = m.competency_id
  LEFT JOIN LATERAL (
    SELECT ROUND(AVG(CASE WHEN qa.is_correct THEN 100 ELSE 0 END), 2) AS recent_result
      FROM public.question_attempts qa
      JOIN public.question_competencies qc ON qc.question_id = qa.question_id
     WHERE qa.user_id = (SELECT auth.uid())
       AND qc.competency_id = m.competency_id
       AND qa.created_at >= now() - INTERVAL '14 days'
  ) rec ON true
  WHERE m.user_id = (SELECT auth.uid())
    AND (p_subject_family IS NULL OR c.family = p_subject_family)
  ORDER BY c.family, domain, mastery ASC, c.slug;
$$;

-- ---------------------------------------------------------------------------
-- 2. get_competency_blockers — R-5 : les prérequis faibles qui expliquent l'échec.
-- ---------------------------------------------------------------------------
-- On ne l'appelle que pour une compétence en échec (m<50, décidé côté appelant) ; ici on
-- remonte ses prérequis dans le DAG jusqu'à la profondeur 3 et on ne garde que les FAIBLES
-- (maîtrise, oubli compris, < 60), triés par (profondeur, maîtrise), trois au plus.
--
-- Un prérequis JAMAIS travaillé (aucune ligne de maîtrise) n'est PAS remonté : on n'accuse pas
-- une compétence faute de preuve (RISK-2 — ne jamais présenter le 50 par défaut comme un score).
-- La borne de profondeur protège même si un cycle échappait au lint du lot 1 (R-3).
CREATE OR REPLACE FUNCTION public.get_competency_blockers(p_competency TEXT)
RETURNS TABLE (
  competency_id UUID,
  slug          TEXT,
  label_fr      TEXT,
  label_en      TEXT,
  label_ar      TEXT,
  mastery       NUMERIC,
  depth         INT
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  WITH RECURSIVE root AS (
    SELECT id FROM public.competencies WHERE slug = p_competency
  ),
  walk AS (
    -- Profondeur 1 : les prérequis directs de la compétence en échec.
    SELECT cp.prereq_id AS comp_id, 1 AS depth
      FROM public.competency_prereqs cp
      JOIN root r ON r.id = cp.competency_id
    UNION ALL
    -- Profondeurs 2–3 : les prérequis des prérequis, bornés (protège d'un cycle éventuel).
    SELECT cp.prereq_id, w.depth + 1
      FROM walk w
      JOIN public.competency_prereqs cp ON cp.competency_id = w.comp_id
     WHERE w.depth < 3
  ),
  -- Le même prérequis peut être atteint par plusieurs chemins : on garde sa profondeur MINIMALE.
  nearest AS (
    SELECT comp_id, min(depth) AS depth
      FROM walk
     GROUP BY comp_id
  )
  SELECT
    c.id,
    c.slug,
    c.label_fr,
    c.label_en,
    c.label_ar,
    public.competency_mastery_with_decay(m.mastery, m.last_attempt_at) AS mastery,
    n.depth
  FROM nearest n
  JOIN public.competencies c ON c.id = n.comp_id
  -- INNER JOIN : sans preuve de maîtrise (jamais tenté), le prérequis n'est pas un blocage.
  JOIN public.user_competency_mastery m
    ON m.competency_id = n.comp_id AND m.user_id = (SELECT auth.uid())
  WHERE public.competency_mastery_with_decay(m.mastery, m.last_attempt_at) < 60
  ORDER BY n.depth, mastery ASC, c.slug
  LIMIT 3;
$$;

-- ---------------------------------------------------------------------------
-- 3. get_exercises_for_competency — US-2 : s'entraîner, accès respecté (R-3).
-- ---------------------------------------------------------------------------
-- Les exercices EXISTANTS qui évaluent la compétence, chacun passé par l'unique arbitre d'accès
-- `resolve_exercise_access` (jamais recopié — R-3, comme `get_daily_plan`). Le quiz de
-- compréhension est la porte du chapitre, pas un entraînement : il est exclu. INVOKER : la
-- fonction ne lit que le catalogue public et la porte lit `auth.uid()` elle-même.
CREATE OR REPLACE FUNCTION public.get_exercises_for_competency(p_competency TEXT)
RETURNS TABLE (
  exercise_id    UUID,
  chapter_id     UUID,
  subject_id     TEXT,
  exercise_title TEXT,
  difficulty     INT
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  SELECT DISTINCT ON (e.id)
    e.id, e.chapter_id, e.subject_id, e.title, e.difficulty
  FROM public.competencies c
  JOIN public.question_competencies qc ON qc.competency_id = c.id
  JOIN public.questions q ON q.id = qc.question_id
  JOIN public.exercises e ON e.id = q.exercise_id
  CROSS JOIN LATERAL public.resolve_exercise_access(e.id) acc
  WHERE c.slug = p_competency
    AND e.source = 'admin'
    AND e.mode IS DISTINCT FROM 'quiz'
    AND acc.allowed
  ORDER BY e.id, e.difficulty, e.display_order;
$$;

-- ---------------------------------------------------------------------------
-- Grants: nominatives, réservées à l'élève connecté ; rien pour anon.
-- (DEFINER ou INVOKER, le client doit pouvoir EXÉCUTER ; le périmètre est interne.)
-- ---------------------------------------------------------------------------
REVOKE ALL ON FUNCTION public.get_my_competency_map(TEXT) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.get_competency_blockers(TEXT) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.get_exercises_for_competency(TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_my_competency_map(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_competency_blockers(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_exercises_for_competency(TEXT) TO authenticated;
