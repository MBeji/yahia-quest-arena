-- =========================================================
-- Le bilan du test de niveau ne rend plus jamais `insightsLocked: null` (étude 39).
-- ---------------------------------------------------------
-- Constat du 2026-11-14 (journal Vercel, production) : `placement.get: shape` —
-- « insightsLocked: expected boolean, received null ». L'écran affichait alors
-- « Impossible de charger ce bilan », puis le bilan au clic sur « Réessayer ».
--
-- La cause : les trois appelants passent `p_full := v_user IS NOT NULL AND
-- v_row.user_id = v_user`. Au retour d'inscription, l'élève est connecté mais son
-- test n'est pas encore rattaché (user_id IS NULL) : la comparaison vaut NULL,
-- `NOT p_full` aussi, et le schéma serveur (z.boolean()) refuse la réponse. Le clic
-- sur « Réessayer » arrivait après le rattachement : user_id posé, p_full = true.
--
-- La correction, à la source et pour les trois appelants (fin, fin rejouée,
-- relecture) : `NOT COALESCE(p_full, false)`. Un p_full inconnu vaut « pas le
-- propriétaire », ce que font déjà les deux `CASE WHEN p_full` du corps (NULL n'y est
-- pas vrai). Seule la ligne `insightsLocked` change ; le reste est recopié tel quel
-- de 20261101100000_placement_sessions.sql §6.
--
-- Additive : CREATE OR REPLACE, même signature, aucun code à retirer.
-- Test : supabase/tests/106_placement_sessions.test.sql (« connecté mais pas encore
-- rattaché »).
-- =========================================================

CREATE OR REPLACE FUNCTION public.placement_bilan_json(
  p_row  public.placement_sessions,
  p_full BOOLEAN
)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SET search_path = public
AS $$
DECLARE
  v_total      INT     := COALESCE(p_row.total_count, 0);
  v_correct    INT     := COALESCE(p_row.correct_count, 0);
  v_score      NUMERIC := CASE WHEN COALESCE(p_row.total_count, 0) > 0
                               THEN ROUND(20.0 * p_row.correct_count / p_row.total_count, 1)
                               ELSE 0 END;
  v_too_fast   BOOLEAN := COALESCE(p_row.duration_seconds, 0) < COALESCE(p_row.total_count, 0) * 4;
  v_candidates INT     := 0;
  v_below      INT     := 0;
  v_chapters   JSONB   := COALESCE(p_row.result -> 'chapters', '[]'::jsonb);
  v_first      JSONB;
  v_review     JSONB;
BEGIN
  -- R-9 : le percentile se compte sur les ÉLÈVES, non bâclés, de la même matière ; affiché à
  -- partir de 20 (seuil de é02, miroir client `PLACEMENT_MIN_CANDIDATES`).
  SELECT count(*)::INT,
         count(*) FILTER (
           WHERE s.correct_count::numeric / NULLIF(s.total_count, 0)
                 < v_correct::numeric / NULLIF(v_total, 0)
         )::INT
    INTO v_candidates, v_below
    FROM public.placement_sessions s
   WHERE s.subject_id = p_row.subject_id
     AND s.status = 'completed'
     AND s.audience = 'student'
     AND s.total_count > 0
     AND COALESCE(s.duration_seconds, 0) >= s.total_count * 4;

  -- R-8 : par où commencer — le premier chapitre non tenu, dans l'ordre du programme.
  SELECT jsonb_build_object('chapterId', ch ->> 'chapterId', 'title', ch ->> 'title')
    INTO v_first
    FROM jsonb_array_elements(v_chapters) AS ch
   WHERE (ch ->> 'held')::boolean IS NOT TRUE
   ORDER BY (ch ->> 'displayOrder')::int, ch ->> 'chapterId'
   LIMIT 1;

  -- La correction : les verdicts FIGÉS du snapshot (R-13), les textes relus sur le corpus.
  -- Une question disparue ne rend rien ici — elle est restée dans la note.
  SELECT COALESCE(
           jsonb_agg(
             jsonb_build_object(
               'questionId', q.id,
               'chapterId', snap.elem ->> 'chapterId',
               'prompt', q.prompt,
               'options', CASE WHEN jsonb_typeof(q.options) = 'array' THEN q.options ELSE '[]'::jsonb END,
               'questionType', COALESCE(q.question_type, 'mcq'),
               'selectedChoice', snap.elem ->> 'choice',
               'isCorrect', (snap.elem ->> 'isCorrect')::boolean,
               'correctChoice', public.answer_key_display(q),
               'explanation', CASE WHEN p_full THEN q.explanation ELSE NULL END,
               'misconception', CASE
                 WHEN p_full AND (snap.elem ->> 'isCorrect')::boolean IS NOT TRUE
                      AND snap.elem ->> 'choice' IS NOT NULL THEN (
                   SELECT jsonb_build_object(
                            'tag', m.tag,
                            'labelFr', m.label_fr,
                            'labelEn', m.label_en,
                            'labelAr', m.label_ar
                          )
                     FROM public.misconceptions m
                    WHERE m.tag = public.resolve_misconception_tag(q, snap.elem ->> 'choice', 'classic')
                 )
                 ELSE NULL
               END
             ) ORDER BY snap.ord
           ),
           '[]'::jsonb
         )
    INTO v_review
    FROM jsonb_array_elements(COALESCE(p_row.result -> 'questions', '[]'::jsonb))
         WITH ORDINALITY AS snap(elem, ord)
    JOIN public.questions q ON q.id = nullif(snap.elem ->> 'questionId', '')::uuid;

  RETURN jsonb_build_object(
    'id', p_row.id,
    'status', p_row.status,
    'audience', p_row.audience,
    'startedAt', p_row.started_at,
    'finishedAt', p_row.finished_at,
    'subject', public.placement_subject_json(p_row.subject_id),
    'correct', v_correct,
    'total', v_total,
    'scoreOn20', v_score,
    'band', public.placement_band(v_score),
    'durationSeconds', COALESCE(p_row.duration_seconds, 0),
    'tooFast', v_too_fast,
    'chapters', v_chapters,
    'firstToReview', v_first,
    'percentile', jsonb_build_object(
      'candidates', v_candidates,
      'minCandidates', 20,
      'percentile', CASE WHEN v_candidates >= 20
                         THEN ROUND(v_below * 100.0 / v_candidates, 0)
                         ELSE NULL END
    ),
    'review', v_review,
    'insightsLocked', NOT COALESCE(p_full, false)
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.placement_bilan_json(public.placement_sessions, BOOLEAN)
  FROM PUBLIC, anon, authenticated;
