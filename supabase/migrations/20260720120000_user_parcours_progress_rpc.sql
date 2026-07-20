-- Progression par matière (chapitres complétés / chapitres publiés) — étude 22, R-15/R-16.
--
-- POURQUOI CETTE RPC (écart assumé au stop-point « le lot 1 ne touche pas au serveur ») :
-- R-16 fait de cette progression LA métrique officielle — celle que la carte `/parcours`
-- affiche, que le rapport parent (étude 08) et l'examen blanc (étude 02) devront consommer.
-- Elle n'était calculable nulle part : `get_user_subject_stats` n'agrège que des tentatives
-- (count/avg/xp), sans notion de chapitre. La seule voie 100 % client aurait été un fan-out de
-- `getSubject` sur toutes les matières du parcours — or `getSubject` fait `chapters.select("*")`
-- et rapatrie donc le cours complet de chaque chapitre : plusieurs Mo et ~50 requêtes pour
-- afficher un pourcentage, exactement ce que l'audit M4 avait supprimé en créant
-- `get_user_subject_stats`. La règle est donc encodée UNE fois, ici, côté serveur.
--
-- LES DEUX DÉFINITIONS (arbitrées le 2026-07-20) :
--   * chapitre PUBLIÉ   = il porte au moins une mission `source='admin'` hors quiz, donc il est
--     jouable. Un chapitre sans mission ne compte pas au dénominateur — sinon il serait
--     « complété » par vacuité (« toutes ses missions réussies » est vrai quand il n'y en a
--     aucune) et il plafonnerait la progression sous 100 % à jamais.
--   * chapitre COMPLÉTÉ = son quiz de compréhension est passé (si le chapitre est quiz-gaté)
--     ET toutes ses missions `source='admin'` hors quiz sont réussies (>= 60 %).
--
-- FIDÉLITÉ AUX PORTES SERVEUR EXISTANTES — les seuils ne sont pas réinventés ici :
--   * quiz-gaté et « passe qualifiante » (>= 80 % ET >= 4 s/question) sont recopiés à
--     l'identique de `start_exercise_session` (dernière définition : 20260714130000) ;
--   * « réussie » = 60 % (`PASS_THRESHOLD_PCT`), et le filtre `variant = 'classic'` reprend
--     `get_best_scores_by_exercise` — une reprise en mode Rappel ne complète pas un chapitre.
--
-- Self-scopée à l'appelant via (SELECT auth.uid()) — pattern C1. Bornée par `p_subject_ids`
-- (les matières du parcours actif) pour ne jamais balayer les ~60 matières du catalogue.
-- Sert par idx_chapters_subject, idx_exercises_chapter_mode, idx_attempts_user_exercise_variant.

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
AS $$
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
      -- Le quiz ne garde que les matières scolaires (grade_id non nul) et seulement quand un
      -- quiz existe réellement pour le chapitre (tolérant aux chapitres hérités sans quiz).
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
          WHERE a.user_id = (SELECT auth.uid())
            AND a.exercise_id = g.quiz_id
            AND a.score_pct >= 80
            AND a.duration_seconds >= a.total_count * 4
       )
     )
     AND NOT EXISTS (
       -- Il subsiste une mission admin hors quiz jamais réussie en classique.
       SELECT 1
         FROM public.exercises e
        WHERE e.chapter_id = g.chapter_id
          AND e.source = 'admin'
          AND e.mode IS DISTINCT FROM 'quiz'
          AND NOT EXISTS (
            SELECT 1
              FROM public.attempts a2
             WHERE a2.user_id = (SELECT auth.uid())
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
$$;

REVOKE ALL ON FUNCTION public.get_user_parcours_progress(TEXT[]) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_user_parcours_progress(TEXT[]) TO authenticated;
