-- ===========================================================================
-- Étude 17 — Rappel actif : rendre la disponibilité du mode Rappel LISIBLE par
-- les visiteurs anonymes (override de R-9, arbitré par Mohamed le 2026-07-15).
--
-- Objectif produit : la mission « Rappel » de chaque QCM éligible doit être
-- DÉCOUVRABLE dans le hub matière, même déconnecté — affichée verrouillée avec
-- son explication (« connecte-toi et finis la mission à 100 % »). L'éligibilité
-- est purement dérivée du contenu (aucune donnée de compte), donc calculable
-- sans session ; le déblocage (unlocked) et le meilleur score restent des
-- concepts de compte → naturellement false / null pour l'anonyme.
--
-- CREATE OR REPLACE verbatim de 20260714130000 SANS le garde « Unauthorized » :
-- avec auth.uid() NULL, l'EXISTS (attempts.user_id = NULL) ne matche rien
-- (unlocked = false) et le MAX renvoie NULL (best_recall_pct = NULL). On ajoute
-- le GRANT au rôle anon. Idempotente, additive.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.get_recall_availability(p_subject_id text)
RETURNS TABLE (
  exercise_id uuid,
  eligible_count int,
  unlocked boolean,
  best_recall_pct numeric
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user uuid := auth.uid();
BEGIN
  IF p_subject_id IS NULL THEN
    RAISE EXCEPTION 'Subject id is required';
  END IF;

  RETURN QUERY
    SELECT
      e.id,
      (SELECT COUNT(*)::int
         FROM public.questions q
        WHERE q.exercise_id = e.id
          AND public.is_question_recall_eligible(q)),
      EXISTS (
        SELECT 1
          FROM public.attempts a
         WHERE a.user_id = v_user
           AND a.exercise_id = e.id
           AND a.variant = 'classic'
           AND a.score_pct = 100
           AND a.duration_seconds >= a.total_count * 4
      ),
      (SELECT MAX(a.score_pct)
         FROM public.attempts a
        WHERE a.user_id = v_user
          AND a.exercise_id = e.id
          AND a.variant = 'recall')
    FROM public.exercises e
    WHERE e.subject_id = p_subject_id
      AND e.source = 'admin'
      AND e.mode IS DISTINCT FROM 'quiz';
END;
$$;

REVOKE ALL ON FUNCTION public.get_recall_availability(text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_recall_availability(text) TO anon, authenticated;
