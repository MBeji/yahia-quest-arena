-- Étude 39 — le test de niveau : le bilan de départ, partageable, sans compte comme avec.
--
-- POURQUOI MAINTENANT. Le projet n'a aucun canal d'acquisition (STATUS.md §1bis, KPI-1 à
-- zéro depuis le 2026-06-13) et son tunnel « sans compte → compte » (étude 38) n'a pas
-- d'appât : l'invitation promet de garder une progression à quelqu'un qui n'a encore rien à
-- garder. Ce lot pose la chose à garder — dix questions d'une matière, un bilan par chapitre,
-- une note sur 20 que l'on partage — et la rend possible SANS compte, pour que le compte
-- vienne après, avec le bilan. C'est aussi le bilan d'entrée que l'étude 30 avait différé
-- (lot 7) : mêmes noms (`placement_sessions`, la source `placement`), forme NON adaptative
-- (composé d'avance, un chapitre par question), parce que dix matières sur onze n'ont pas de
-- graphe de compétences et qu'un test partagé doit être comparable. Contrat : étude 39 (privé).
--
-- CE QUE CE FICHIER TIENT
--
--   R-11  La clé ne sort JAMAIS avant la fin : `start_placement_session` construit son JSON
--         champ par champ (patron é02) — ni `correct_option`, ni `answer_key`, ni
--         `explanation`, ni `distractor_tags`. Après la fin, la bonne réponse se voit (comme
--         `check_answers`), et l'explication + l'erreur nommée ne vont qu'au PROPRIÉTAIRE
--         (`user_id = auth.uid()`) : c'est la valeur du compte, annoncée à l'écran, jamais
--         une rétention muette.
--   R-13  Ce qu'un test a produit est enregistré, jamais recalculé : score et verdicts par
--         question sont figés dans `result` à la fin (patron du grand livre é34). Une question
--         qui quitte le corpus ensuite quitte la correction affichée, pas la note.
--   R-14  Un test anonyme n'a QU'UN JETON (`token`, 128 bits aléatoires), rendu une fois à la
--         création ; le lire ou le finir l'exige. Il ne porte aucune identité, il ne va jamais
--         dans une URL. Patron du code d'alliance de `/suivi` (accès au porteur assumé).
--   R-16  Le rattachement : `claim_placement_sessions` attache les tests `user_id IS NULL`
--         d'un appareil au compte qui vient de se connecter — idempotent, borné à 10 jetons,
--         jamais deux fois le même test.
--   R-18  La digue : au-delà de 120 créations ANONYMES par minute sur toute la plateforme,
--         `start_placement_session` refuse (`PLACEMENT_BUSY`). Le débit par adresse et par
--         compte est tenu par les server fns ; ceci arrête ce qu'un robot distribué passerait.
--   R-19  Rétention : un test anonyme non fini part après 7 jours, un test anonyme fini
--         après 90 ; un test de compte vit avec le compte (FK ON DELETE CASCADE), part dans
--         `export_user_data` (dérivé des FK — rien à déclarer) et dans la suppression.
--
-- CE QUI N'EST PAS ICI, à dessein (étude 39 D-6). Aucune ligne de `question_attempts`, donc
-- aucun mouvement de `user_misconceptions`, de `user_competency_mastery` ni des croyances :
-- é30 R-13 exige que les croyances d'un bilan portent `source = 'placement'` et ne comptent
-- que pour 1, ce que les trois triggers actuels ne savent pas faire. Les réponses sont GARDÉES
-- dans `result.questions` : le lot 4 les rejouera dans le modèle sans rien redemander à
-- l'élève. L'élargissement du CHECK de `question_attempts.source` partira avec lui.
--
-- ORDRE DE LIVRAISON (DoD §7) : migration ADDITIVE, aucune signature existante modifiée.

-- ---------------------------------------------------------------------------
-- 1. La table.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.placement_sessions (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  -- R-14 : la preuve de propriété d'un test anonyme. UNIQUE pour que le rattachement
  -- par jeton soit sans ambiguïté.
  token            UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),
  -- NULL = anonyme. Posé à la création pour un connecté, au rattachement sinon.
  user_id          UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  subject_id       TEXT NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
  -- Auto-déclaré ; n'ouvre aucun droit, change la suite proposée, sort du percentile.
  audience         TEXT NOT NULL DEFAULT 'student' CHECK (audience IN ('student', 'parent')),
  status           TEXT NOT NULL DEFAULT 'running'
                   CHECK (status IN ('running', 'completed', 'abandoned')),
  -- L'ordre de passage (R-3 : l'ordre du programme). Pas de FK : une question qui quitte le
  -- corpus ne doit pas rendre un bilan illisible (R-13).
  question_ids     UUID[] NOT NULL,
  -- `{questionId: choice}`, écrit à la fin, filtré sur `question_ids`.
  answers          JSONB NOT NULL DEFAULT '{}'::jsonb,
  started_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  finished_at      TIMESTAMPTZ,
  duration_seconds INT CHECK (duration_seconds >= 0),
  correct_count    INT,
  total_count      INT,
  -- Le SNAPSHOT (R-13) : `questions[{questionId, chapterId, choice, isCorrect}]` et
  -- `chapters[{chapterId, title, displayOrder, correct, total, hasLesson}]`.
  result           JSONB,
  -- R-16 : rattaché à un compte après coup (NULL pour un test né connecté ou encore anonyme).
  claimed_at       TIMESTAMPTZ,
  CONSTRAINT placement_sessions_finished_consistent CHECK (
    (status = 'completed') = (finished_at IS NOT NULL)
  )
);

COMMENT ON TABLE public.placement_sessions IS
  'Étude 39 : un test de niveau (dix questions d''une matière). user_id NULL = anonyme, lisible par son seul jeton.';
COMMENT ON COLUMN public.placement_sessions.token IS
  'Étude 39 R-14 : la preuve de propriété d''un test anonyme, rendue une fois, jamais dans une URL.';

-- Le Hall : le dernier bilan par matière d'un compte.
CREATE INDEX IF NOT EXISTS idx_placement_sessions_user_recent
  ON public.placement_sessions (user_id, finished_at DESC)
  WHERE user_id IS NOT NULL;
-- Le percentile (D-7), calculé à la lecture sur les tests finis d'une matière.
CREATE INDEX IF NOT EXISTS idx_placement_sessions_percentile
  ON public.placement_sessions (subject_id, correct_count)
  WHERE status = 'completed';
-- Le balayage (R-19) et la digue (R-18) lisent les anonymes par date.
CREATE INDEX IF NOT EXISTS idx_placement_sessions_anon_started
  ON public.placement_sessions (started_at)
  WHERE user_id IS NULL;

-- RLS : le propriétaire lit ses lignes (le Hall passe par une RPC, mais une lecture directe
-- doit rester possible et juste). Aucune politique d'ÉCRITURE : les seuls écrivains sont les
-- RPC SECURITY DEFINER ci-dessous. L'anonyme ne lit RIEN par la table — son accès est le
-- jeton, dans la RPC. AGENTS.md : une table neuve porte ses propres grants.
ALTER TABLE public.placement_sessions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Own placement sessions readable by owner" ON public.placement_sessions;
CREATE POLICY "Own placement sessions readable by owner"
  ON public.placement_sessions
  FOR SELECT TO authenticated
  USING (user_id = (SELECT auth.uid()) OR public.is_admin());

REVOKE ALL ON public.placement_sessions FROM anon, authenticated;
GRANT SELECT ON public.placement_sessions TO authenticated;
GRANT ALL ON public.placement_sessions TO service_role;

-- ---------------------------------------------------------------------------
-- 2. La bande de niveau (R-6) — UNE table de vérité, en SQL. Le client en porte un miroir
--    d'affichage (`src/shared/constants/placement.ts`) ; la valeur voyage dans le bilan.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.placement_band(p_score_on_20 NUMERIC)
RETURNS TEXT
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT CASE
    WHEN p_score_on_20 IS NULL THEN 'reprendre'
    WHEN p_score_on_20 >= 16 THEN 'solide'
    WHEN p_score_on_20 >= 12 THEN 'en-route'
    WHEN p_score_on_20 >= 8  THEN 'consolider'
    ELSE 'reprendre'
  END;
$$;

REVOKE EXECUTE ON FUNCTION public.placement_band(NUMERIC) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 3. Le sujet d'un test, en JSON — partagé par le départ, la reprise et le bilan.
--    `parcoursId` : la page publique de la classe (`/niveau/$parcoursId`) ; la première
--    disponible sur le couple (thème, classe), ou NULL pour une matière libre sans parcours.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.placement_subject_json(p_subject_id TEXT)
RETURNS JSONB
LANGUAGE sql
STABLE
SET search_path = public
AS $$
  SELECT jsonb_build_object(
           'id', s.id,
           'nameFr', s.name_fr,
           'contentLanguage', s.content_language,
           'gradeNameFr', g.name_fr,
           'gradeSlug', g.slug,
           'parcoursId', (
             SELECT p.id
               FROM public.parcours p
              WHERE p.theme_id = s.theme_id
                AND p.grade_id IS NOT DISTINCT FROM s.grade_id
                AND p.status = 'available'
              ORDER BY p.display_order, p.id
              LIMIT 1
           )
         )
    FROM public.subjects s
    LEFT JOIN public.grades g ON g.id = s.grade_id
   WHERE s.id = p_subject_id;
$$;

REVOKE EXECUTE ON FUNCTION public.placement_subject_json(TEXT) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 4. Les questions servies, en JSON — R-11 : prompt, options, type, chapitre. RIEN d'autre.
--    Construit champ par champ, précisément pour qu'un ajout de colonne à `questions` ne
--    puisse pas en faire fuir une.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.placement_questions_json(p_question_ids UUID[])
RETURNS JSONB
LANGUAGE sql
STABLE
SET search_path = public
AS $$
  SELECT COALESCE(
    jsonb_agg(
      jsonb_build_object(
        'id', q.id,
        'chapterId', c.id,
        'chapterTitle', c.title,
        'chapterOrder', c.display_order,
        'prompt', q.prompt,
        'options', CASE WHEN jsonb_typeof(q.options) = 'array' THEN q.options ELSE '[]'::jsonb END,
        'questionType', COALESCE(q.question_type, 'mcq')
      ) ORDER BY u.ord
    ),
    '[]'::jsonb
  )
  FROM unnest(p_question_ids) WITH ORDINALITY AS u(qid, ord)
  JOIN public.questions q ON q.id = u.qid
  JOIN public.exercises e ON e.id = q.exercise_id
  JOIN public.chapters  c ON c.id = e.chapter_id;
$$;

REVOKE EXECUTE ON FUNCTION public.placement_questions_json(UUID[]) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 4bis. Les questions ÉLIGIBLES d'une matière — UNE définition, lue par la composition et par
--       les listes de l'entrée. Les missions publiées (`source = 'admin'`, `mode <> 'quiz'` : le
--       quiz de compréhension est une porte, pas une épreuve), `mcq` ou `numeric` seulement
--       (les planches allongent, `multi` brouille la note, `short_answer` exige un juge — é33),
--       avec un énoncé, des options et une clé : une question mal formée ne tombe pas sur un
--       élève.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.placement_eligible_questions(p_subject_id TEXT)
RETURNS TABLE (
  question_id   UUID,
  exercise_id   UUID,
  difficulty    INT,
  chapter_id    UUID,
  chapter_order INT
)
LANGUAGE sql
STABLE
SET search_path = public
AS $$
  SELECT q.id, e.id, e.difficulty, c.id, c.display_order
    FROM public.questions q
    JOIN public.exercises e ON e.id = q.exercise_id
    JOIN public.chapters  c ON c.id = e.chapter_id
   WHERE e.subject_id = p_subject_id
     AND e.source = 'admin'
     AND e.mode <> 'quiz'
     AND COALESCE(q.question_type, 'mcq') IN ('mcq', 'numeric')
     AND length(btrim(q.prompt)) > 0
     AND (
           (COALESCE(q.question_type, 'mcq') = 'mcq'
            AND jsonb_typeof(q.options) = 'array'
            AND jsonb_array_length(q.options) >= 2
            AND q.correct_option IS NOT NULL)
        OR (q.question_type = 'numeric'
            AND q.answer_key IS NOT NULL
            AND q.answer_key ? 'value')
     );
$$;

REVOKE EXECUTE ON FUNCTION public.placement_eligible_questions(TEXT) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 4ter. L'entrée : les matières TESTABLES d'une classe (≥ 5 questions éligibles — jamais un
--       test tronqué, R-1), et une matière seule pour un lien partagé (`?matiere=`).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.list_placement_subjects(p_parcours_id TEXT)
RETURNS JSONB
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT COALESCE(
    jsonb_agg(
      jsonb_build_object(
        'id', s.id,
        'nameFr', s.name_fr,
        'contentLanguage', s.content_language,
        'chapters', st.chapters,
        'questions', st.questions
      ) ORDER BY s.display_order, s.id
    ),
    '[]'::jsonb
  )
  FROM public.parcours p
  JOIN public.subjects s
    ON s.theme_id = p.theme_id
   AND s.grade_id IS NOT DISTINCT FROM p.grade_id
  CROSS JOIN LATERAL (
    SELECT count(*)::INT AS questions, count(DISTINCT eq.chapter_id)::INT AS chapters
      FROM public.placement_eligible_questions(s.id) eq
  ) st
  WHERE p.id = p_parcours_id
    AND st.questions >= 5;
$$;

CREATE OR REPLACE FUNCTION public.get_placement_subject(p_subject_id TEXT)
RETURNS JSONB
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT public.placement_subject_json(s.id)
         || jsonb_build_object(
              'testable', st.questions >= 5,
              'questions', st.questions,
              'chapters', st.chapters
            )
    FROM public.subjects s
    CROSS JOIN LATERAL (
      SELECT count(*)::INT AS questions, count(DISTINCT eq.chapter_id)::INT AS chapters
        FROM public.placement_eligible_questions(s.id) eq
    ) st
   WHERE s.id = p_subject_id;
$$;

-- ---------------------------------------------------------------------------
-- 5. Ouvrir un test (R-1, R-2, R-3, R-18).
--
-- LA COMPOSITION, en une CTE, déterministe à l'aléa près :
--   elig    — les questions éligibles de la matière (`placement_eligible_questions`, 4bis) ;
--   ch      — les chapitres qui en ont, rangés dans l'ordre du programme ;
--   picked  — N chapitres ÉQUIDISTANTS : le chapitre de rang r va dans le seau
--             floor((r−1) × N / nombre), un chapitre par seau (le premier) — sur une matière
--             à vingt chapitres, le test visite le 1, le 3, le 5… et non les dix premiers ;
--   ranked  — dans chaque chapitre retenu, les questions ordonnées : missions distinctes
--             d'abord, palier 1-2 avant boss (le test cherche OÙ COMMENCER, pas à départager
--             des champions), puis l'aléa ;
--   le tirage prend d'abord la première question de chaque chapitre (rn = 1), puis complète
--   en seconde question quand la matière a moins de N chapitres ; l'ORDRE DE PASSAGE est
--   celui du programme (chapitre, puis rang).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.start_placement_session(
  p_subject_id TEXT,
  p_audience   TEXT DEFAULT 'student'
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
  v_row          public.placement_sessions%ROWTYPE;
BEGIN
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

  WITH elig AS (
    SELECT * FROM public.placement_eligible_questions(p_subject_id)
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

  INSERT INTO public.placement_sessions (user_id, subject_id, audience, question_ids)
  VALUES (v_user, p_subject_id, p_audience, v_question_ids)
  RETURNING * INTO v_row;

  RETURN jsonb_build_object(
    'id', v_row.id,
    -- R-14 : la SEULE fois où le jeton sort.
    'token', v_row.token,
    'status', v_row.status,
    'audience', v_row.audience,
    'startedAt', v_row.started_at,
    'subject', public.placement_subject_json(v_row.subject_id),
    'questions', public.placement_questions_json(v_row.question_ids)
  );
END;
$$;

-- ---------------------------------------------------------------------------
-- 6. Le bilan d'un test FINI, en JSON (étude 39 §3.4) — partagé par la fin et la relecture.
--    `p_full` : le propriétaire lit l'explication et l'erreur nommée ; l'anonyme reçoit
--    `insightsLocked = true`, et l'écran le dit (R-11, D-5).
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
    'insightsLocked', NOT p_full
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.placement_bilan_json(public.placement_sessions, BOOLEAN)
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 7. Finir un test : noter, FIGER, rendre le bilan. Idempotent : un test déjà fini rend son
--    bilan enregistré (un double envoi, un rafraîchissement ne re-notent rien).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.finish_placement_session(
  p_session_id       UUID,
  p_token            UUID  DEFAULT NULL,
  p_answers          JSONB DEFAULT '{}'::jsonb,
  p_duration_seconds INT   DEFAULT 0
)
-- `p_token` peut être NULL pour le PROPRIÉTAIRE connecté (il a pu perdre la mémoire de son
-- appareil) : la propriété vaut alors preuve, comme pour la relecture. Pour un test anonyme, le
-- jeton reste la seule porte (R-14).
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user      UUID := (SELECT auth.uid());
  v_row       public.placement_sessions%ROWTYPE;
  v_clean     JSONB;
  v_questions JSONB;
  v_chapters  JSONB;
  v_correct   INT;
  v_total     INT;
BEGIN
  -- Un seul message pour « id inconnu » et « jeton faux » : pas d'oracle sur l'existence.
  SELECT * INTO v_row
    FROM public.placement_sessions
   WHERE id = p_session_id
     AND (
           (p_token IS NOT NULL AND token = p_token)
        OR (v_user IS NOT NULL AND user_id = v_user)
     )
     FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'PLACEMENT_NOT_FOUND';
  END IF;

  IF v_row.status = 'completed' THEN
    RETURN public.placement_bilan_json(v_row, v_user IS NOT NULL AND v_row.user_id = v_user);
  END IF;

  -- Les réponses sont FILTRÉES, jamais rejetées en bloc : une clé étrangère au test ou une
  -- valeur hors bornes est ignorée, le reste compte (patron `save_mock_answers`).
  IF p_answers IS NULL OR jsonb_typeof(p_answers) <> 'object' THEN
    p_answers := '{}'::jsonb;
  END IF;
  SELECT COALESCE(jsonb_object_agg(kv.key, kv.value), '{}'::jsonb)
    INTO v_clean
    FROM jsonb_each_text(p_answers) AS kv(key, value)
   WHERE length(kv.value) BETWEEN 1 AND 512
     -- Comparé en TEXTE : une clé qui n'est pas un UUID est ignorée, jamais castée (un
     -- payload bricolé ne doit pas lever au milieu d'une fin de test).
     AND kv.key IN (SELECT qid::text FROM unnest(v_row.question_ids) AS qid);

  -- Le jugement : `score_answer`, le seul juge du projet. Une question sans réponse vaut
  -- faux (`score_answer(q, NULL)` rend false par contrat), une question disparue ne compte
  -- plus (le dénominateur est ce qui existe encore à l'instant de la note).
  WITH played AS (
    SELECT u.qid, u.ord
      FROM unnest(v_row.question_ids) WITH ORDINALITY AS u(qid, ord)
  ),
  scored AS (
    SELECT p.ord,
           q.id                           AS question_id,
           c.id                           AS chapter_id,
           c.title                        AS chapter_title,
           c.display_order                AS chapter_order,
           (c.lesson_content IS NOT NULL AND length(btrim(c.lesson_content)) > 0) AS has_lesson,
           v_clean ->> q.id::text         AS choice,
           public.score_answer(q, v_clean ->> q.id::text) AS ok
      FROM played p
      JOIN public.questions q ON q.id = p.qid
      JOIN public.exercises e ON e.id = q.exercise_id
      JOIN public.chapters  c ON c.id = e.chapter_id
  ),
  per_chapter AS (
    SELECT chapter_id, min(chapter_title) AS title, min(chapter_order) AS display_order,
           bool_or(has_lesson) AS has_lesson,
           count(*) FILTER (WHERE ok)::INT AS correct,
           count(*)::INT AS total
      FROM scored
     GROUP BY chapter_id
  )
  SELECT
    (SELECT COALESCE(jsonb_agg(jsonb_build_object(
               'questionId', s.question_id,
               'chapterId', s.chapter_id,
               'choice', s.choice,
               'isCorrect', s.ok
             ) ORDER BY s.ord), '[]'::jsonb) FROM scored s),
    (SELECT COALESCE(jsonb_agg(jsonb_build_object(
               'chapterId', pc.chapter_id,
               'title', pc.title,
               'displayOrder', pc.display_order,
               'correct', pc.correct,
               'total', pc.total,
               'held', pc.correct = pc.total,
               'hasLesson', pc.has_lesson
             ) ORDER BY pc.display_order, pc.chapter_id), '[]'::jsonb) FROM per_chapter pc),
    (SELECT count(*) FILTER (WHERE s.ok)::INT FROM scored s),
    (SELECT count(*)::INT FROM scored s)
    INTO v_questions, v_chapters, v_correct, v_total;

  UPDATE public.placement_sessions
     SET status           = 'completed',
         finished_at      = now(),
         duration_seconds = GREATEST(0, COALESCE(p_duration_seconds, 0)),
         answers          = v_clean,
         correct_count    = v_correct,
         total_count      = v_total,
         result           = jsonb_build_object('questions', v_questions, 'chapters', v_chapters)
   WHERE id = v_row.id
   RETURNING * INTO v_row;

  RETURN public.placement_bilan_json(v_row, v_user IS NOT NULL AND v_row.user_id = v_user);
END;
$$;

-- ---------------------------------------------------------------------------
-- 8. Relire un test : par jeton (l'appareil) ou par propriété (le compte). Un test en cours
--    rend ses questions pour la reprise (US-8) — sans le jeton, qui ne sort qu'une fois.
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
    'questions', public.placement_questions_json(v_row.question_ids)
  );
END;
$$;

-- ---------------------------------------------------------------------------
-- 9. Rattacher les tests d'un appareil au compte qui vient de se connecter (R-16).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.claim_placement_sessions(p_tokens UUID[])
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user    UUID := (SELECT auth.uid());
  v_claimed UUID[];
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;
  IF p_tokens IS NULL OR cardinality(p_tokens) = 0 THEN
    RETURN jsonb_build_object('claimed', '[]'::jsonb);
  END IF;

  -- Borné à dix : la mémoire d'appareil n'en garde que cinq, le reste serait un balayage.
  WITH done AS (
    UPDATE public.placement_sessions
       SET user_id = v_user,
           claimed_at = now()
     WHERE token = ANY (p_tokens[1:10])
       AND user_id IS NULL
    RETURNING id
  )
  SELECT COALESCE(array_agg(id), ARRAY[]::uuid[]) INTO v_claimed FROM done;

  RETURN jsonb_build_object('claimed', to_jsonb(v_claimed));
END;
$$;

-- ---------------------------------------------------------------------------
-- 10. Le Hall : le dernier bilan fini, non bâclé, par matière (R-10, R-17).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_my_placement_overview()
RETURNS JSONB
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  WITH mine AS (
    SELECT DISTINCT ON (s.subject_id) s.*
      FROM public.placement_sessions s
     WHERE s.user_id = (SELECT auth.uid())
       AND s.status = 'completed'
       AND s.total_count > 0
       AND COALESCE(s.duration_seconds, 0) >= s.total_count * 4
     ORDER BY s.subject_id, s.finished_at DESC
  )
  SELECT COALESCE(
    jsonb_agg(
      jsonb_build_object(
        'sessionId', m.id,
        'subjectId', m.subject_id,
        'subjectNameFr', sub.name_fr,
        'contentLanguage', sub.content_language,
        'scoreOn20', ROUND(20.0 * m.correct_count / m.total_count, 1),
        'band', public.placement_band(ROUND(20.0 * m.correct_count / m.total_count, 1)),
        'finishedAt', m.finished_at,
        'chaptersToReview', COALESCE((
          SELECT jsonb_agg(jsonb_build_object('chapterId', ch ->> 'chapterId', 'title', ch ->> 'title')
                           ORDER BY (ch ->> 'displayOrder')::int, ch ->> 'chapterId')
            FROM jsonb_array_elements(COALESCE(m.result -> 'chapters', '[]'::jsonb)) AS ch
           WHERE (ch ->> 'held')::boolean IS NOT TRUE
        ), '[]'::jsonb)
      ) ORDER BY m.finished_at DESC
    ),
    '[]'::jsonb
  )
  FROM mine m
  JOIN public.subjects sub ON sub.id = m.subject_id;
$$;

-- ---------------------------------------------------------------------------
-- 11. Le balayage (R-19). Appelé par pg_cron ; aucun rôle client ne peut l'exécuter.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.sweep_placement_sessions()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_deleted_running   INT;
  v_deleted_completed INT;
  v_abandoned         INT;
BEGIN
  DELETE FROM public.placement_sessions
   WHERE user_id IS NULL AND status = 'running' AND started_at < now() - interval '7 days';
  GET DIAGNOSTICS v_deleted_running = ROW_COUNT;

  DELETE FROM public.placement_sessions
   WHERE user_id IS NULL AND status = 'completed' AND finished_at < now() - interval '90 days';
  GET DIAGNOSTICS v_deleted_completed = ROW_COUNT;

  UPDATE public.placement_sessions
     SET status = 'abandoned'
   WHERE user_id IS NOT NULL AND status = 'running' AND started_at < now() - interval '7 days';
  GET DIAGNOSTICS v_abandoned = ROW_COUNT;

  RETURN jsonb_build_object(
    'deletedAnonRunning', v_deleted_running,
    'deletedAnonCompleted', v_deleted_completed,
    'abandoned', v_abandoned
  );
END;
$$;

-- ---------------------------------------------------------------------------
-- 12. Droits — nominatifs. Le départ, la fin et la relecture sont PUBLICS (l'anonyme passe le
--     test) ; le rattachement et le Hall exigent un compte ; le balayage n'appartient à aucun
--     rôle client.
-- ---------------------------------------------------------------------------
REVOKE ALL ON FUNCTION public.list_placement_subjects(TEXT) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.get_placement_subject(TEXT) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.start_placement_session(TEXT, TEXT) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.finish_placement_session(UUID, UUID, JSONB, INT) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.get_placement_session(UUID, UUID) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.claim_placement_sessions(UUID[]) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.get_my_placement_overview() FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.sweep_placement_sessions() FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public.list_placement_subjects(TEXT) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.get_placement_subject(TEXT) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.start_placement_session(TEXT, TEXT) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.finish_placement_session(UUID, UUID, JSONB, INT) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.get_placement_session(UUID, UUID) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.claim_placement_sessions(UUID[]) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_my_placement_overview() TO authenticated;

-- ---------------------------------------------------------------------------
-- 13. Le balayage quotidien, par pg_cron — enveloppé pour que la migration passe là où
--     l'extension manque (base locale, projet TEST), motif des vues matérialisées.
-- ---------------------------------------------------------------------------
DO $$
BEGIN
  CREATE EXTENSION IF NOT EXISTS pg_cron;

  PERFORM cron.unschedule(jobid)
  FROM cron.job
  WHERE jobname = 'sweep-placement-sessions';

  PERFORM cron.schedule(
    'sweep-placement-sessions',
    '17 3 * * *',
    $cron$SELECT public.sweep_placement_sessions();$cron$
  );
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE
    'pg_cron unavailable (%). placement_sessions will not be swept until pg_cron is enabled and the cron.schedule(...) block is re-run.',
    SQLERRM;
END $$;
