-- Étude 39 — lot 5, volet « le bilan au rapport parent » (é08) : LES TESTS DE NIVEAU DE
-- L'ENFANT, VUS PAR SON PARENT.
--
-- CE QUI EXISTAIT. Le test de niveau (é39, lots 1-3) fige une note sur 20, une bande et un
-- verdict par chapitre dans `placement_sessions`. Le compte de l'élève les lit au Hall
-- (`get_my_placement_overview`) ; le parent lié n'en voyait rien — alors que c'est
-- précisément la photographie « où en est-il ? » que son rapport cherche à donner.
--
-- CE QUE CE LOT POSE. Une lecture, `get_student_placement_summary` : le dernier test FINI
-- de l'élève par matière, avec sa note, sa bande, ce qui tient, ce qui est à revoir et la
-- portée figée (é39 R-22).
--
-- * **Les règles du Hall, à l'identique** : test fini, non vide, non bâclé (au moins quatre
--   secondes par question — R-17), le plus récent par matière. Le parent lit ce que son
--   enfant lit, ni plus, ni moins.
-- * **Seuls les tests passés EN ÉLÈVE** (`audience = 'student'`) : un test pris « en
--   parent » sur l'appareil de l'enfant puis rattaché à son compte ne dit rien de son niveau.
-- * **Pas de percentile, pas de correction** : le rapport parent est un repère, pas un
--   classement (é08 R-5) ; et les explications, les erreurs nommées et les réponses restent
--   au seul propriétaire (é39 R-11, D-5). Seuls des titres de chapitres sortent du snapshot.
-- * **Accès** : `assert_can_read_student_activity`, la garde du tableau de bord parent
--   (admin, ou parent au lien ACTIF). Rien pour anon, et rien par le chemin public au code
--   alliance : aucune enveloppe `_by_code` n'est créée (même frontière que les examens blancs,
--   `get_student_exam_summary`).
--
-- Migration ADDITIVE : une fonction neuve, rien de modifié.

CREATE OR REPLACE FUNCTION public.get_student_placement_summary(p_student UUID)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_tests JSONB;
BEGIN
  PERFORM public.assert_can_read_student_activity(p_student);

  WITH latest AS (
    SELECT DISTINCT ON (s.subject_id) s.*
      FROM public.placement_sessions s
     WHERE s.user_id = p_student
       AND s.audience = 'student'
       AND s.status = 'completed'
       AND s.total_count > 0
       AND COALESCE(s.duration_seconds, 0) >= s.total_count * 4
     ORDER BY s.subject_id, s.finished_at DESC
  )
  SELECT COALESCE(
           jsonb_agg(
             jsonb_build_object(
               'sessionId', l.id,
               'subjectId', l.subject_id,
               'subjectNameFr', sub.name_fr,
               'gradeNameFr', g.name_fr,
               'finishedAt', l.finished_at,
               'correct', l.correct_count,
               'total', l.total_count,
               'scoreOn20', ROUND(20.0 * l.correct_count / l.total_count, 1),
               'band', public.placement_band(ROUND(20.0 * l.correct_count / l.total_count, 1)),
               'chaptersHeld', COALESCE((
                 SELECT jsonb_agg(ch ->> 'title'
                                  ORDER BY (ch ->> 'displayOrder')::int, ch ->> 'chapterId')
                   FROM jsonb_array_elements(COALESCE(l.result -> 'chapters', '[]'::jsonb)) AS ch
                  WHERE (ch ->> 'held')::boolean IS TRUE
               ), '[]'::jsonb),
               'chaptersToReview', COALESCE((
                 SELECT jsonb_agg(ch ->> 'title'
                                  ORDER BY (ch ->> 'displayOrder')::int, ch ->> 'chapterId')
                   FROM jsonb_array_elements(COALESCE(l.result -> 'chapters', '[]'::jsonb)) AS ch
                  WHERE (ch ->> 'held')::boolean IS NOT TRUE
               ), '[]'::jsonb),
               -- La portée FIGÉE au départ (R-22) ; NULL = toute l'année. Seuls le chapitre
               -- atteint et les deux comptes sortent — pas la liste des chapitres à venir.
               'scope', CASE WHEN l.scope IS NULL THEN NULL ELSE jsonb_build_object(
                          'throughTitle', l.scope ->> 'throughTitle',
                          'chaptersInScope', (l.scope ->> 'chaptersInScope')::int,
                          'chaptersTotal', (l.scope ->> 'chaptersTotal')::int
                        ) END
             ) ORDER BY l.finished_at DESC
           ),
           '[]'::jsonb
         )
    INTO v_tests
    FROM latest l
    JOIN public.subjects sub ON sub.id = l.subject_id
    LEFT JOIN public.grades g ON g.id = sub.grade_id;

  RETURN jsonb_build_object('tests', v_tests);
END;
$$;

COMMENT ON FUNCTION public.get_student_placement_summary(UUID) IS
  'Étude 39 lot 5 (é08) : dernier test de niveau fini, non bâclé, passé en élève, par matière — note /20, bande, chapitres tenus et à revoir, portée. Admin ou parent au lien actif (assert_can_read_student_activity).';

REVOKE EXECUTE ON FUNCTION public.get_student_placement_summary(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_student_placement_summary(UUID) TO authenticated;
