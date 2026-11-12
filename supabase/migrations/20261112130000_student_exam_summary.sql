-- Étude 08 — lot 1 : LES EXAMENS BLANCS AU RAPPORT PARENT (US-5).
--
-- CE QUI EXISTAIT. L'examen blanc est livré depuis l'étude 02 : note sur 20,
-- barème aux coefficients du concours, percentile. Rien n'en remontait au
-- parent — l'événement le plus lisible de la scolarité de son enfant était le
-- seul que son rapport ne montrait pas.
--
-- CE QUE CE LOT POSE. Une lecture, `get_student_exam_summary` : les sessions
-- CLASSÉES et rendues de l'élève, avec leur note et leur percentile.
--
-- * **Mêmes règles d'affichage que l'étude 02** : le percentile ne sort qu'à
--   partir de 20 candidats (`minCandidates`) ; en dessous, il vaut NULL et
--   l'écran dit « classement affiché à partir de 20 candidats ». La formule est
--   celle de `get_mock_exam_percentile`, à l'identique — celle-ci juge par
--   `auth.uid() = propriétaire de la session`, un parent ne peut donc pas
--   l'appeler ; le test pgTAP du lot prouve l'égalité des deux lectures.
-- * **Seules les sessions classées** : un entraînement n'entre ni au classement
--   ni ici — c'est une répétition, pas un résultat.
-- * **Accès** : `assert_can_read_student_activity`, la garde du tableau de bord
--   parent (admin, ou parent au lien ACTIF). Rien pour anon, et rien par le
--   chemin public au code alliance : aucune enveloppe `_by_code` n'est créée.
-- * `openExams` compte les examens publiés du parcours courant de l'élève qu'il
--   n'a pas encore rendus : de quoi dire « il y en a un d'ouvert » plutôt que
--   d'afficher une section vide ou de se taire.
--
-- Migration ADDITIVE : une fonction neuve, rien de modifié (les fonctions de
-- l'étude 02 ne bougent pas).

CREATE OR REPLACE FUNCTION public.get_student_exam_summary(p_student UUID)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  -- Le seuil de l'étude 02, le même que `get_mock_exam_percentile`.
  c_min_candidates CONSTANT INT := 20;
  v_exams JSONB;
  v_open INT;
BEGIN
  PERFORM public.assert_can_read_student_activity(p_student);

  SELECT COALESCE(jsonb_agg(x.item ORDER BY x.finished_at DESC), '[]'::jsonb)
    INTO v_exams
    FROM (
      SELECT s.finished_at,
             jsonb_build_object(
               'examId', e.id,
               'titleFr', e.title_fr,
               'titleEn', e.title_en,
               'titleAr', e.title_ar,
               'finishedAt', s.finished_at,
               'scorePoints', s.score_points,
               'maxPoints', s.max_points,
               'scoreOn20', CASE WHEN COALESCE(s.max_points, 0) > 0
                                 THEN ROUND(s.score_points * 20.0 / s.max_points, 2)
                                 ELSE 0 END,
               'candidates', r.candidates,
               'percentile', CASE WHEN r.candidates >= c_min_candidates
                                  THEN ROUND(r.below * 100.0 / r.candidates, 1)
                                  ELSE NULL END
             ) AS item
        FROM public.mock_exam_sessions s
        JOIN public.mock_exams e ON e.id = s.exam_id
        CROSS JOIN LATERAL (
          SELECT count(*)::INT AS candidates,
                 (count(*) FILTER (WHERE o.score_points < s.score_points))::INT AS below
            FROM public.mock_exam_sessions o
           WHERE o.exam_id = s.exam_id
             AND o.kind = 'ranked'
             AND o.finished_at IS NOT NULL
             AND o.score_points IS NOT NULL
        ) r
       WHERE s.user_id = p_student
         AND s.kind = 'ranked'
         AND s.finished_at IS NOT NULL
         AND s.score_points IS NOT NULL
    ) x;

  SELECT count(*)::INT INTO v_open
    FROM public.mock_exams e
    JOIN public.profiles pr ON pr.id = p_student AND pr.current_parcours_id = e.parcours_id
   WHERE e.status = 'published'
     AND NOT EXISTS (
       SELECT 1 FROM public.mock_exam_sessions s
        WHERE s.exam_id = e.id
          AND s.user_id = p_student
          AND s.kind = 'ranked'
          AND s.finished_at IS NOT NULL
     );

  RETURN jsonb_build_object(
    'minCandidates', c_min_candidates,
    'openExams', v_open,
    'exams', v_exams
  );
END;
$$;

COMMENT ON FUNCTION public.get_student_exam_summary(UUID) IS
  'Étude 08 lot 1 (US-5) : examens blancs CLASSÉS et rendus d''un élève — note /20 et percentile (NULL sous 20 candidats, règle é02). Admin ou parent au lien actif (assert_can_read_student_activity).';

REVOKE EXECUTE ON FUNCTION public.get_student_exam_summary(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_student_exam_summary(UUID) TO authenticated;
