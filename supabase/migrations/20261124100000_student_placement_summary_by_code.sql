-- Étude 39 lot 5, volet é08 — LES TESTS DE NIVEAU AUSSI PAR LE CODE D'ALLIANCE (`/suivi`).
--
-- CE QUI EXISTAIT. `get_student_placement_summary` (20261120100000) sert le parent CONNECTÉ et
-- lié. Le chemin public au code d'alliance n'en avait aucune enveloppe : un parent qui suit son
-- enfant par `/suivi?code=…` — le lien que l'invitation de l'étude 40 lui envoie — ne voyait
-- jamais ses tests de niveau (constat du propriétaire le 2026-11-24, sur le compte de son fils).
--
-- DÉCISION (propriétaire, 2026-11-24, sur recommandation). Le code donne déjà accès à tout le
-- bilan de l'enfant (`get_student_report_by_code` : scores par matière, chapitres à revoir) ; le
-- dernier test de niveau n'en dit pas plus. La même lecture s'ouvre donc au porteur du code.
--
-- CE QUE CE LOT POSE.
-- * `_student_placement_summary_json(p_student)` : le corps de la lecture, À L'IDENTIQUE,
--   sorti dans un helper interne (REVOKE de tous les rôles clients) — une seule définition de
--   « le dernier test valable », jamais deux.
-- * `get_student_placement_summary` le rappelle après sa garde (sortie inchangée, pgTAP 114).
-- * `get_student_placement_summary_by_code(p_code)` : la borne durable `report_by_code` puis le
--   décodage `_student_id_from_alliance_code` — exactement le patron de
--   `get_student_daily_report_by_code`. Ni réponses, ni jeton, ni percentile, ni correction.
--
-- Migration NON destructive : un helper neuf, une fonction neuve, un corps remplacé sans
-- changement de signature, de droits ni de sortie.

CREATE OR REPLACE FUNCTION public._student_placement_summary_json(p_student UUID)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_tests JSONB;
BEGIN
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

COMMENT ON FUNCTION public._student_placement_summary_json(UUID) IS
  'Étude 39 lot 5 : corps partagé des lectures « tests de niveau » du rapport parent. Interne : aucune garde, jamais exécutable par un rôle client.';

REVOKE EXECUTE ON FUNCTION public._student_placement_summary_json(UUID) FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.get_student_placement_summary(p_student UUID)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  PERFORM public.assert_can_read_student_activity(p_student);
  RETURN public._student_placement_summary_json(p_student);
END;
$$;

CREATE OR REPLACE FUNCTION public.get_student_placement_summary_by_code(p_code TEXT)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- Borne durable (S-1) : la même que les autres lectures au code.
  PERFORM public.enforce_rpc_rate_limit('report_by_code');
  RETURN public._student_placement_summary_json(public._student_id_from_alliance_code(p_code));
END;
$$;

COMMENT ON FUNCTION public.get_student_placement_summary_by_code(TEXT) IS
  'Étude 39 lot 5 : les tests de niveau d''un élève pour le porteur de son code d''alliance (/suivi). Même sortie que get_student_placement_summary.';

REVOKE EXECUTE ON FUNCTION public.get_student_placement_summary_by_code(TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_student_placement_summary_by_code(TEXT) TO anon, authenticated;
