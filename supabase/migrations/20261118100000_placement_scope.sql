-- =========================================================
-- Le test de niveau suit l'AVANCEMENT DU PROGRAMME (étude 39, R-22).
-- ---------------------------------------------------------
-- Constat du 2026-11-18 (propriétaire) : le test tirait ses dix questions sur TOUS les
-- chapitres de l'année. En novembre, un élève de 9ᵉ était noté sur des chapitres du 2ᵉ et du
-- 3ᵉ trimestre : sa note et sa bande mêlaient « pas encore vu » et « vu mais pas acquis ».
--
-- La correction : l'élève dit jusqu'à quel chapitre sa classe est arrivée (l'écran le
-- préremplit d'après le calendrier scolaire, il le corrige). Le test ne tire et ne note que
-- les chapitres VUS ; les suivants sont listés « à venir » dans le bilan, sans compter.
--
--   * `placement_sessions.scope` (JSONB, NULL = toute l'année) : la portée FIGÉE au départ —
--     chapitre atteint, nombre de chapitres vus / testables, chapitres à venir. Figée comme la
--     note (R-13) : un corpus qui bouge après coup ne réécrit pas ce que l'élève a passé.
--   * `placement_chapter_ranks` : les chapitres testables d'une matière, rangés, avec le cumul
--     de questions — UNE définition pour la liste de l'entrée et pour la composition.
--   * `list_placement_chapters` : la liste que l'écran propose. `enough` = le programme
--     jusqu'à ce chapitre porte au moins 5 questions (R-1 : jamais un test tronqué).
--   * `start_placement_session` gagne `p_through_chapter_id` (DEFAULT NULL = toute l'année).
--     Un chapitre trop tôt est ÉLARGI au premier qui porte 5 questions ; le dernier chapitre,
--     ou un chapitre inconnu de la matière, vaut « toute l'année » (un corpus republié entre
--     l'affichage et le clic ne doit pas faire échouer un départ).
--
-- Additive pour le code en place : l'ancienne signature (TEXT, TEXT) est remplacée par une
-- signature qui l'englobe (troisième argument optionnel) — un appel à deux arguments nommés
-- continue de passer. Le DROP évite une surcharge ambiguë pour PostgREST. Les schémas zod du
-- client en place ignorent la clé `scope` qu'ils ne connaissent pas.
--
-- Test : supabase/tests/106_placement_sessions.test.sql (§ « La portée »).
-- =========================================================

ALTER TABLE public.placement_sessions ADD COLUMN IF NOT EXISTS scope JSONB;

COMMENT ON COLUMN public.placement_sessions.scope IS
  'Portée figée au départ (étude 39 R-22) : NULL = toute l''année ; sinon {throughChapterId, throughTitle, chaptersInScope, chaptersTotal, upcoming[]}.';

-- ---------------------------------------------------------------------------
-- 1. Les chapitres TESTABLES d'une matière, dans l'ordre du programme.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.placement_chapter_ranks(p_subject_id TEXT)
RETURNS TABLE (
  chapter_id    UUID,
  title         TEXT,
  display_order INT,
  idx           INT,
  questions     INT,
  cum_questions INT
)
LANGUAGE sql
STABLE
SET search_path = public
AS $$
  WITH per AS (
    SELECT eq.chapter_id, min(eq.chapter_order) AS display_order, count(*)::INT AS questions
      FROM public.placement_eligible_questions(p_subject_id) eq
     GROUP BY eq.chapter_id
  )
  SELECT per.chapter_id,
         c.title,
         per.display_order,
         (row_number() OVER w)::INT,
         per.questions,
         (sum(per.questions) OVER w)::INT
    FROM per
    JOIN public.chapters c ON c.id = per.chapter_id
  WINDOW w AS (ORDER BY per.display_order, per.chapter_id);
$$;

REVOKE EXECUTE ON FUNCTION public.placement_chapter_ranks(TEXT) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 2. L'entrée : « où en es-tu ? » — la liste des chapitres testables d'une matière.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.list_placement_chapters(p_subject_id TEXT)
RETURNS JSONB
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT COALESCE(
    jsonb_agg(
      jsonb_build_object(
        'chapterId', r.chapter_id,
        'title', r.title,
        'displayOrder', r.display_order,
        'questions', r.questions,
        'enough', r.cum_questions >= 5
      ) ORDER BY r.idx
    ),
    '[]'::jsonb
  )
  FROM public.placement_chapter_ranks(p_subject_id) r;
$$;

REVOKE ALL ON FUNCTION public.list_placement_chapters(TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.list_placement_chapters(TEXT) TO anon, authenticated;

-- ---------------------------------------------------------------------------
-- 3. Ouvrir un test — la composition de 20261101100000 §5 (et sa borne de débit de
--    20261112100000), bornée aux chapitres VUS.
-- ---------------------------------------------------------------------------
DROP FUNCTION IF EXISTS public.start_placement_session(TEXT, TEXT);

CREATE OR REPLACE FUNCTION public.start_placement_session(
  p_subject_id TEXT,
  p_audience   TEXT DEFAULT 'student',
  p_through_chapter_id UUID DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user         UUID := (SELECT auth.uid());
  v_items        CONSTANT INT := 10;   -- PLACEMENT_ITEMS (R-1), miroir en constante client
  v_min_items    CONSTANT INT := 5;    -- en deçà, la matière n'est pas testable (R-1)
  v_flood_cap    CONSTANT INT := 120;  -- créations anonymes par minute, toute la plateforme (R-18)
  v_question_ids UUID[];
  v_total_ch     INT;
  v_cut          INT;    -- rang du dernier chapitre VU ; NULL = toute l'année
  v_scope        JSONB;  -- NULL = toute l'année
  v_row          public.placement_sessions%ROWTYPE;
BEGIN
  -- Borne durable (S-1, 20261112100000) : voir public.enforce_rpc_rate_limit.
  PERFORM public.enforce_rpc_rate_limit('placement_start');

  IF p_audience IS NULL OR p_audience NOT IN ('student', 'parent') THEN
    RAISE EXCEPTION 'Invalid audience';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM public.subjects s WHERE s.id = p_subject_id) THEN
    RAISE EXCEPTION 'PLACEMENT_SUBJECT_NOT_FOUND';
  END IF;

  -- La digue (R-18) : seulement pour l'anonyme — un compte est déjà limité par
  -- `check_rate_limit` dans la server fn, et nommé.
  IF v_user IS NULL AND (
       SELECT count(*)
         FROM public.placement_sessions ps
        WHERE ps.user_id IS NULL
          AND ps.started_at > now() - interval '1 minute'
     ) >= v_flood_cap THEN
    RAISE EXCEPTION 'PLACEMENT_BUSY';
  END IF;

  -- La portée (R-22). Le rang demandé est élargi au premier chapitre dont le cumul porte
  -- `v_min_items` questions ; atteindre le dernier chapitre, c'est « toute l'année ».
  SELECT count(*)::INT INTO v_total_ch FROM public.placement_chapter_ranks(p_subject_id);

  IF p_through_chapter_id IS NOT NULL THEN
    SELECT GREATEST(
             r.idx,
             COALESCE((SELECT min(m.idx)
                         FROM public.placement_chapter_ranks(p_subject_id) m
                        WHERE m.cum_questions >= v_min_items), v_total_ch)
           )
      INTO v_cut
      FROM public.placement_chapter_ranks(p_subject_id) r
     WHERE r.chapter_id = p_through_chapter_id;
    IF v_cut >= v_total_ch THEN
      v_cut := NULL;
    END IF;
  END IF;

  IF v_cut IS NOT NULL THEN
    SELECT jsonb_build_object(
             'throughChapterId', t.chapter_id,
             'throughTitle', t.title,
             'chaptersInScope', v_cut,
             'chaptersTotal', v_total_ch,
             'upcoming', (
               SELECT COALESCE(jsonb_agg(jsonb_build_object(
                          'chapterId', u.chapter_id,
                          'title', u.title,
                          'displayOrder', u.display_order
                        ) ORDER BY u.idx), '[]'::jsonb)
                 FROM public.placement_chapter_ranks(p_subject_id) u
                WHERE u.idx > v_cut
             )
           )
      INTO v_scope
      FROM public.placement_chapter_ranks(p_subject_id) t
     WHERE t.idx = v_cut;
  END IF;

  WITH elig AS (
    SELECT eq.*
      FROM public.placement_eligible_questions(p_subject_id) eq
     WHERE v_cut IS NULL
        OR eq.chapter_id IN (
             SELECT r.chapter_id
               FROM public.placement_chapter_ranks(p_subject_id) r
              WHERE r.idx <= v_cut
           )
  ),
  ch AS (
    SELECT chapter_id,
           dense_rank() OVER (ORDER BY min(chapter_order), chapter_id) AS idx,
           count(*)     OVER ()                                         AS cnt
      FROM elig
     GROUP BY chapter_id
  ),
  picked AS (
    SELECT DISTINCT ON (floor((idx - 1) * LEAST(v_items, cnt)::numeric / cnt))
           chapter_id, idx
      FROM ch
     ORDER BY floor((idx - 1) * LEAST(v_items, cnt)::numeric / cnt), idx
  ),
  by_exercise AS (
    -- Le rang d'une question DANS sa mission (aléatoire) : il passe avant tout, pour que la
    -- seconde question d'un chapitre vienne d'une autre mission que la première.
    SELECT el.question_id,
           el.chapter_id,
           el.difficulty,
           p.idx,
           row_number() OVER (PARTITION BY el.chapter_id, el.exercise_id ORDER BY random()) AS ex_rn
      FROM elig el
      JOIN picked p ON p.chapter_id = el.chapter_id
  ),
  ranked AS (
    SELECT question_id,
           idx,
           row_number() OVER (
             PARTITION BY chapter_id
             ORDER BY ex_rn, (difficulty > 2), random()
           ) AS rn
      FROM by_exercise
  ),
  chosen AS (
    SELECT question_id, idx, rn
      FROM ranked
     ORDER BY rn, idx
     LIMIT v_items
  )
  SELECT array_agg(question_id ORDER BY idx, rn)
    INTO v_question_ids
    FROM chosen;

  IF v_question_ids IS NULL OR cardinality(v_question_ids) < v_min_items THEN
    RAISE EXCEPTION 'PLACEMENT_NOT_ENOUGH_QUESTIONS';
  END IF;

  INSERT INTO public.placement_sessions (user_id, subject_id, audience, question_ids, scope)
  VALUES (v_user, p_subject_id, p_audience, v_question_ids, v_scope)
  RETURNING * INTO v_row;

  RETURN jsonb_build_object(
    'id', v_row.id,
    -- R-14 : la SEULE fois où le jeton sort.
    'token', v_row.token,
    'status', v_row.status,
    'audience', v_row.audience,
    'startedAt', v_row.started_at,
    'subject', public.placement_subject_json(v_row.subject_id),
    'scope', v_row.scope,
    'questions', public.placement_questions_json(v_row.question_ids)
  );
END;
$$;

REVOKE ALL ON FUNCTION public.start_placement_session(TEXT, TEXT, UUID) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.start_placement_session(TEXT, TEXT, UUID) TO anon, authenticated;

-- ---------------------------------------------------------------------------
-- 4. Relire un test en cours : il rend sa portée (20261101100000 §8, une clé de plus).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_placement_session(
  p_session_id UUID,
  p_token      UUID DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := (SELECT auth.uid());
  v_row  public.placement_sessions%ROWTYPE;
BEGIN
  SELECT * INTO v_row
    FROM public.placement_sessions
   WHERE id = p_session_id
     AND (
           (p_token IS NOT NULL AND token = p_token)
        OR (v_user IS NOT NULL AND user_id = v_user)
     );
  IF NOT FOUND THEN
    RAISE EXCEPTION 'PLACEMENT_NOT_FOUND';
  END IF;

  IF v_row.status = 'completed' THEN
    RETURN public.placement_bilan_json(v_row, v_user IS NOT NULL AND v_row.user_id = v_user);
  END IF;

  RETURN jsonb_build_object(
    'id', v_row.id,
    'status', v_row.status,
    'audience', v_row.audience,
    'startedAt', v_row.started_at,
    'subject', public.placement_subject_json(v_row.subject_id),
    'scope', v_row.scope,
    'questions', public.placement_questions_json(v_row.question_ids)
  );
END;
$$;

REVOKE ALL ON FUNCTION public.get_placement_session(UUID, UUID) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_placement_session(UUID, UUID) TO anon, authenticated;

-- ---------------------------------------------------------------------------
-- 5. Le bilan rend la portée figée (20261114200000, une clé de plus : `scope`).
-- ---------------------------------------------------------------------------
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
    -- La portée FIGÉE au départ (R-22) : NULL = toute l'année.
    'scope', p_row.scope,
    'insightsLocked', NOT COALESCE(p_full, false)
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.placement_bilan_json(public.placement_sessions, BOOLEAN)
  FROM PUBLIC, anon, authenticated;
