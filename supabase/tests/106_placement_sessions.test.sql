-- =========================================================
-- Étude 39 — LE TEST DE NIVEAU (lot 1) : composition, clé qui ne sort pas, jeton,
-- note figée, valeur du compte, rattachement, percentile, balayage, droits.
-- ---------------------------------------------------------
-- Décor : une matière de SIX chapitres ; dans chacun une mission de palier 1 (deux QCM,
-- clé « a », distracteur « b » étiqueté) et un boss de palier 3 (une question numérique,
-- valeur 42). Le chapitre 1 porte en plus un quiz de compréhension (une porte, jamais une
-- épreuve) et une question ouverte `short_answer` (servie à personne sans juge, é33) : ni
-- l'un ni l'autre ne doivent entrer dans un test. Une seconde matière, mince, n'a que trois
-- questions : elle n'est pas testable.
--
-- Les propriétés qui coûtent si elles tombent :
--   ⭐ aucune clé dans le JSON de départ (R-11) ;
--   ⭐ le jeton est la seule porte d'un test anonyme (R-14) ;
--   ⭐ la note est figée une fois pour toutes (R-13) ;
--   ⭐ l'explication et l'erreur nommée ne vont qu'au propriétaire (D-5) ;
--   ⭐ le rattachement attache une fois, et jamais le test d'un autre (R-16).
--
-- Espace de noms des fixtures : préfixe `f39…`.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(48);

-- ---------------------------------------------------------
-- Décor
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('f3900000-0000-4000-8000-000000000001', 'f39-eleve@test.local'),
  ('f3900000-0000-4000-8000-000000000002', 'f39-autre@test.local');

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id, content_language, display_order)
VALUES
  ('f39-subj', 'F39 Matière', 'Esprit', 'subject-math', 'Brain', 'ecole-tn',
   (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '9eme-base'), 'fr', 900),
  ('f39-thin', 'F39 Mince', 'Esprit', 'subject-math', 'Brain', 'ecole-tn',
   (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '9eme-base'), 'fr', 901);

-- Six chapitres, dans l'ordre du programme ; le premier a un cours.
INSERT INTO public.chapters (id, subject_id, title, display_order, lesson_content)
SELECT ('f3900000-0000-4000-8000-0000000000c' || k)::uuid, 'f39-subj', 'F39 Chapitre ' || k, k,
       CASE WHEN k = 1 THEN 'Un cours.' ELSE NULL END
  FROM generate_series(1, 6) AS k;

-- Par chapitre : une mission de palier 1 (…e1k) et un boss de palier 3 (…e3k).
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, difficulty, display_order)
SELECT ('f3900000-0000-4000-8000-000000000e1' || k)::uuid,
       ('f3900000-0000-4000-8000-0000000000c' || k)::uuid, 'f39-subj',
       'F39 Mission ' || k, 'practice', 'admin', 1, 1
  FROM generate_series(1, 6) AS k
UNION ALL
SELECT ('f3900000-0000-4000-8000-000000000e3' || k)::uuid,
       ('f3900000-0000-4000-8000-0000000000c' || k)::uuid, 'f39-subj',
       'F39 Boss ' || k, 'boss', 'admin', 3, 2
  FROM generate_series(1, 6) AS k;

-- Deux QCM par mission de palier 1 (clé « a », distracteur « b » étiqueté, une explication).
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order, question_type, explanation, distractor_tags)
SELECT ('f3900000-0000-4000-8000-00000000a' || k || '0' || n)::uuid,
       ('f3900000-0000-4000-8000-000000000e1' || k)::uuid,
       'F39 question ' || k || '.' || n,
       '[{"id":"a","text":"juste"},{"id":"b","text":"faux"},{"id":"c","text":"autre"}]'::jsonb,
       'a', n, 'mcq', 'Parce que.', '{"b":"f39.tag.b"}'::jsonb
  FROM generate_series(1, 6) AS k, generate_series(1, 2) AS n;

-- Une question numérique par boss (valeur 42).
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order, question_type, answer_key)
SELECT ('f3900000-0000-4000-8000-00000000b' || k || '01')::uuid,
       ('f3900000-0000-4000-8000-000000000e3' || k)::uuid,
       'F39 combien ' || k || ' ?', '[]'::jsonb, NULL, 1, 'numeric', '{"value": 42}'::jsonb
  FROM generate_series(1, 6) AS k;

-- Chapitre 1 : un quiz de compréhension (porte) et une question ouverte (sans juge).
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, difficulty, display_order)
VALUES ('f3900000-0000-4000-8000-0000000000e9', 'f3900000-0000-4000-8000-0000000000c1', 'f39-subj',
        'F39 Quiz', 'quiz', 'admin', 1, 0);
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES ('f3900000-0000-4000-8000-00000000d901', 'f3900000-0000-4000-8000-0000000000e9', 'F39 quiz q',
        '[{"id":"a","text":"1"},{"id":"b","text":"2"}]'::jsonb, 'a', 1);
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order, question_type, answer_key)
VALUES ('f3900000-0000-4000-8000-00000000d101', 'f3900000-0000-4000-8000-000000000e11', 'F39 ouverte',
        '[]'::jsonb, NULL, 9, 'short_answer', '{"text":"x","accepted":["x"]}'::jsonb);

-- La matière mince : un chapitre, une mission, trois questions.
INSERT INTO public.chapters (id, subject_id, title, display_order)
VALUES ('f3900000-0000-4000-8000-0000000000cf', 'f39-thin', 'F39 Mince ch.', 1);
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, difficulty, display_order)
VALUES ('f3900000-0000-4000-8000-0000000000ef', 'f3900000-0000-4000-8000-0000000000cf', 'f39-thin',
        'F39 Mince mission', 'practice', 'admin', 1, 1);
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
SELECT ('f3900000-0000-4000-8000-00000000f00' || n)::uuid, 'f3900000-0000-4000-8000-0000000000ef',
       'F39 mince ' || n, '[{"id":"a","text":"1"},{"id":"b","text":"2"}]'::jsonb, 'a', n
  FROM generate_series(1, 3) AS n;

-- Le registre des erreurs nommées.
INSERT INTO public.misconceptions (tag, subject, label_fr, label_en, label_ar)
VALUES ('f39.tag.b', 'f39', 'Tu confonds b et a', 'You mix up b and a', 'تخلط بين ب و أ');

-- =========================================================
-- 1. Le départ, SANS compte.
-- =========================================================
SET LOCAL ROLE anon;

CREATE TEMP TABLE f39_start AS
  SELECT public.start_placement_session('f39-subj', 'student') AS j;
-- Les tables de travail changent de rôle avec le test : chaque rôle doit pouvoir les relire.
GRANT SELECT ON f39_start TO PUBLIC;

SELECT is(
  (SELECT jsonb_array_length(j -> 'questions') FROM f39_start),
  10,
  'R-1 : un test fait dix questions'
);

SELECT is(
  (SELECT count(DISTINCT q ->> 'chapterId')::int
     FROM f39_start, jsonb_array_elements(j -> 'questions') AS q),
  6,
  'R-2 : les six chapitres de la matière sont visités'
);

SELECT ok(
  (SELECT (j ? 'token') AND (j ->> 'token') ~ '^[0-9a-f-]{36}$' FROM f39_start),
  'R-14 : le jeton est rendu au départ, et une seule fois'
);

SELECT ok(
  (SELECT j::text !~* 'correct_option|correctOption|answer_key|answerKey|explanation|distractor' FROM f39_start),
  '⭐ R-11 : ni clé, ni explication, ni étiquette dans le JSON de départ'
);

SELECT ok(
  (SELECT bool_and(prev_order IS NULL OR prev_order <= cur_order)
     FROM (
       SELECT (q ->> 'chapterOrder')::int AS cur_order,
              lag((q ->> 'chapterOrder')::int) OVER (ORDER BY ord) AS prev_order
         FROM f39_start, jsonb_array_elements(j -> 'questions') WITH ORDINALITY AS t(q, ord)
     ) s),
  'R-3 : l''ordre de passage est l''ordre du programme'
);

SELECT ok(
  NOT EXISTS (
    SELECT 1 FROM f39_start, jsonb_array_elements(j -> 'questions') AS q
     WHERE (q ->> 'id') IN ('f3900000-0000-4000-8000-00000000d901', 'f3900000-0000-4000-8000-00000000d101')
  ),
  'le quiz de compréhension et la question ouverte ne sont jamais servis'
);

SELECT is(
  (SELECT j -> 'subject' ->> 'gradeSlug' FROM f39_start),
  '9eme-base',
  'le sujet porte sa classe (la page publique du niveau en dépend)'
);

-- L'entrée : seules les matières testables sont proposées ; un lien partagé relit sa matière.
SELECT is(
  (SELECT jsonb_agg(m ->> 'id' ORDER BY m ->> 'id')
     FROM jsonb_array_elements(public.list_placement_subjects('concours-9eme')) AS m
    WHERE m ->> 'id' LIKE 'f39-%'),
  '["f39-subj"]'::jsonb,
  'R-1 : la classe liste la matière testable, et pas la matière mince'
);

SELECT is(
  (SELECT (m ->> 'questions')::int || '/' || (m ->> 'chapters')::int
     FROM jsonb_array_elements(public.list_placement_subjects('concours-9eme')) AS m
    WHERE m ->> 'id' = 'f39-subj'),
  '18/6',
  'la liste compte les questions éligibles (ni quiz, ni ouverte) et les chapitres'
);

SELECT is(
  public.get_placement_subject('f39-thin') ->> 'testable' || ':' || coalesce(public.get_placement_subject('f39-nope')::text, 'null'),
  'false:null',
  'une matière mince se dit non testable ; une matière inconnue rend NULL'
);

SELECT throws_ok(
  $$SELECT public.start_placement_session('f39-thin', 'student')$$,
  'P0001', 'PLACEMENT_NOT_ENOUGH_QUESTIONS',
  'R-1 : une matière à trois questions n''est pas testable — jamais un test tronqué'
);

SELECT throws_ok(
  $$SELECT public.start_placement_session('f39-nope', 'student')$$,
  'P0001', 'PLACEMENT_SUBJECT_NOT_FOUND',
  'une matière inconnue est refusée'
);

SELECT throws_ok(
  $$SELECT public.start_placement_session('f39-subj', 'teacher')$$,
  'P0001', 'Invalid audience',
  'l''audience est fermée : élève ou parent'
);

-- =========================================================
-- 2. Le jeton est la seule porte (R-14).
-- =========================================================
SELECT throws_ok(
  format($$SELECT public.finish_placement_session(%L, %L, '{}'::jsonb, 60)$$,
         (SELECT j ->> 'id' FROM f39_start), '00000000-0000-4000-8000-000000000000'),
  'P0001', 'PLACEMENT_NOT_FOUND',
  '⭐ finir avec un faux jeton est refusé — même message qu''un id inconnu, pas d''oracle'
);

SELECT throws_ok(
  format($$SELECT public.get_placement_session(%L, NULL)$$, (SELECT j ->> 'id' FROM f39_start)),
  'P0001', 'PLACEMENT_NOT_FOUND',
  'relire sans jeton ni compte est refusé'
);

SELECT is(
  (SELECT public.get_placement_session((j ->> 'id')::uuid, (j ->> 'token')::uuid) ->> 'status' FROM f39_start),
  'running',
  'US-8 : un test en cours se relit par son jeton (la reprise)'
);

SELECT ok(
  (SELECT NOT (public.get_placement_session((j ->> 'id')::uuid, (j ->> 'token')::uuid) ? 'token') FROM f39_start),
  'R-14 : la relecture ne rend jamais le jeton une seconde fois'
);

-- =========================================================
-- 3. Les réponses : les sept premières justes, les trois dernières fausses.
--    (Préparées en superutilisateur : le décor lit la clé, le test ne la reçoit pas.)
-- =========================================================
RESET ROLE;

CREATE TEMP TABLE f39_served AS
  SELECT u.ord, q.id, q.question_type, q.correct_option, q.answer_key, e.difficulty, e.chapter_id
    FROM public.placement_sessions s,
         unnest(s.question_ids) WITH ORDINALITY AS u(qid, ord)
    JOIN public.questions q ON q.id = u.qid
    JOIN public.exercises e ON e.id = q.exercise_id
   WHERE s.id = (SELECT (j ->> 'id')::uuid FROM f39_start);
GRANT SELECT ON f39_served TO PUBLIC;

SELECT ok(
  (SELECT bool_and(difficulty <= 2)
     FROM (SELECT DISTINCT ON (chapter_id) difficulty FROM f39_served ORDER BY chapter_id, ord) firsts),
  'R-2 : la première question de chaque chapitre vient d''une mission de palier 1 ou 2'
);

SELECT is(
  (SELECT count(*)::int FROM (SELECT chapter_id FROM f39_served GROUP BY chapter_id HAVING count(*) = 2) d),
  4,
  'six chapitres pour dix questions : quatre chapitres en reçoivent une seconde, d''une autre mission'
);

CREATE TEMP TABLE f39_answers AS
  SELECT jsonb_object_agg(
           id::text,
           CASE WHEN ord <= 7
                THEN CASE WHEN question_type = 'numeric' THEN answer_key ->> 'value' ELSE correct_option END
                ELSE CASE WHEN question_type = 'numeric' THEN '1' ELSE 'b' END
           END
         ) || '{"pas-un-uuid":"x","f3900000-0000-4000-8000-00000000d901":"a"}'::jsonb AS j
    FROM f39_served;
GRANT SELECT ON f39_answers TO PUBLIC;

-- =========================================================
-- 4. La fin, SANS compte : la note, figée ; la bonne réponse se voit ; le reste attend le compte.
-- =========================================================
SET LOCAL ROLE anon;

CREATE TEMP TABLE f39_done AS
  SELECT public.finish_placement_session(
           (SELECT (j ->> 'id')::uuid FROM f39_start),
           (SELECT (j ->> 'token')::uuid FROM f39_start),
           (SELECT j FROM f39_answers),
           120
         ) AS j;
GRANT SELECT ON f39_done TO PUBLIC;

SELECT is(
  (SELECT (j ->> 'correct')::int || '/' || (j ->> 'total')::int FROM f39_done),
  '7/10',
  'sept justes sur dix — une clé étrangère au test ou mal formée est ignorée, jamais fatale'
);

SELECT is(
  (SELECT (j ->> 'scoreOn20')::numeric FROM f39_done),
  14.0,
  'R-5 : la note sur 20 — 7/10 font 14'
);

SELECT is(
  (SELECT j ->> 'band' FROM f39_done),
  'en-route',
  'R-6 : 14/20 est « en bonne voie »'
);

SELECT is(
  (SELECT (j ->> 'tooFast')::boolean FROM f39_done),
  false,
  'R-10 : 120 s pour dix questions n''est pas bâclé'
);

SELECT is(
  (SELECT (j ->> 'insightsLocked')::boolean FROM f39_done),
  true,
  '⭐ D-5 : sans compte, les explications et l''erreur nommée sont annoncées, pas servies'
);

SELECT ok(
  (SELECT bool_and(r -> 'explanation' = 'null'::jsonb AND r -> 'misconception' = 'null'::jsonb AND r ->> 'correctChoice' IS NOT NULL)
     FROM f39_done, jsonb_array_elements(j -> 'review') AS r),
  '⭐ R-11 : la correction anonyme montre la bonne réponse, retient l''explication et l''étiquette'
);

SELECT is(
  (SELECT count(*) FILTER (WHERE (c ->> 'held')::boolean)::int || '/' || count(*)::int
     FROM f39_done, jsonb_array_elements(j -> 'chapters') AS c),
  '3/6',
  'R-7 : trois chapitres tenus (1, 2, 3), trois à revoir'
);

SELECT is(
  (SELECT j -> 'firstToReview' ->> 'chapterId' FROM f39_done),
  'f3900000-0000-4000-8000-0000000000c4',
  'R-8 : par où commencer — le premier chapitre à revoir dans l''ordre du programme'
);

SELECT is(
  (SELECT (j -> 'percentile' ->> 'candidates')::int || ':' || coalesce(j -> 'percentile' ->> 'percentile', 'null') FROM f39_done),
  '1:null',
  'R-9 : un seul participant — pas de percentile'
);

-- La fin est IDEMPOTENTE : un second envoi, avec d'autres réponses, rend le bilan enregistré.
SELECT is(
  (SELECT (public.finish_placement_session(
             (SELECT (j ->> 'id')::uuid FROM f39_start),
             (SELECT (j ->> 'token')::uuid FROM f39_start),
             '{}'::jsonb, 5) ->> 'correct')::int),
  7,
  '⭐ R-13 : un test fini ne se re-note pas — le second envoi rend la note figée'
);

SELECT is(
  (SELECT public.get_placement_session((j ->> 'id')::uuid, (j ->> 'token')::uuid) ->> 'status' FROM f39_start),
  'completed',
  'la relecture par jeton rend le bilan'
);

-- =========================================================
-- 5. Le rattachement (R-16) : une fois, au premier compte, jamais au second.
-- =========================================================
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"f3900000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT public.claim_placement_sessions(ARRAY[(j ->> 'token')::uuid]) -> 'claimed' ->> 0 FROM f39_start),
  (SELECT j ->> 'id' FROM f39_start),
  '⭐ R-16 : le test anonyme de l''appareil est rattaché au compte qui se connecte'
);

SELECT is(
  (SELECT jsonb_array_length(public.claim_placement_sessions(ARRAY[(j ->> 'token')::uuid]) -> 'claimed') FROM f39_start),
  0,
  'R-16 : rattacher deux fois ne fait rien'
);

SELECT is(
  (SELECT jsonb_array_length(public.claim_placement_sessions(ARRAY['00000000-0000-4000-8000-00000000dead'::uuid]) -> 'claimed')),
  0,
  'un jeton inconnu est ignoré, sans erreur'
);

-- Le propriétaire lit TOUT, sans jeton.
CREATE TEMP TABLE f39_owner AS
  SELECT public.get_placement_session((SELECT (j ->> 'id')::uuid FROM f39_start), NULL) AS j;
GRANT SELECT ON f39_owner TO PUBLIC;

SELECT is(
  (SELECT (j ->> 'insightsLocked')::boolean FROM f39_owner),
  false,
  '⭐ R-12 : le propriétaire lit la correction complète, sans rien rejouer'
);

SELECT ok(
  (SELECT bool_and(r ->> 'explanation' = 'Parce que.')
     FROM f39_owner, jsonb_array_elements(j -> 'review') AS r
    WHERE r ->> 'questionType' = 'mcq'),
  'R-12 : l''explication de chaque QCM est servie au propriétaire'
);

SELECT is(
  (SELECT count(*)::int FROM f39_owner, jsonb_array_elements(j -> 'review') AS r
    WHERE r -> 'misconception' ->> 'labelFr' = 'Tu confonds b et a'),
  2,
  'R-12 : les deux QCM manqués sur le distracteur étiqueté portent leur erreur nommée'
);

SELECT is(
  (SELECT jsonb_array_length(public.get_my_placement_overview())),
  1,
  'le Hall : un bilan de départ pour la matière'
);

SELECT is(
  (SELECT public.get_my_placement_overview() -> 0 ->> 'scoreOn20' || ' · ' ||
          jsonb_array_length(public.get_my_placement_overview() -> 0 -> 'chaptersToReview')),
  '14.0 · 3',
  'le Hall : la note et les trois chapitres à revoir'
);

-- L'autre compte ne voit rien de ce test.
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"f3900000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  format($$SELECT public.get_placement_session(%L, NULL)$$, (SELECT j ->> 'id' FROM f39_start)),
  'P0001', 'PLACEMENT_NOT_FOUND',
  '⭐ un autre compte ne lit pas le test — ni par la RPC…'
);

SELECT is(
  (SELECT count(*)::int FROM public.placement_sessions),
  0,
  '… ni par la table (RLS : seules ses lignes)'
);

-- =========================================================
-- 6. Le percentile (R-9) : élèves, non bâclés, à partir de vingt.
-- =========================================================
RESET ROLE;

INSERT INTO public.placement_sessions
  (user_id, subject_id, audience, status, question_ids, started_at, finished_at, duration_seconds, correct_count, total_count)
SELECT NULL, 'f39-subj', 'student', 'completed',
       ARRAY[(SELECT id FROM f39_served ORDER BY ord LIMIT 1)],
       now() - interval '3 minutes', now() - interval '2 minutes', 100, i % 10, 10
  FROM generate_series(1, 24) AS i;
-- Trois parents à 10/10 et deux élèves bâclés à 10/10 : hors du compte.
INSERT INTO public.placement_sessions
  (user_id, subject_id, audience, status, question_ids, started_at, finished_at, duration_seconds, correct_count, total_count)
SELECT NULL, 'f39-subj', aud, 'completed',
       ARRAY[(SELECT id FROM f39_served ORDER BY ord LIMIT 1)],
       now() - interval '3 minutes', now() - interval '2 minutes', dur, 10, 10
  FROM (VALUES ('parent', 100), ('parent', 100), ('parent', 100), ('student', 10), ('student', 10)) AS v(aud, dur);

SET LOCAL "request.jwt.claims" = '{"sub":"f3900000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT (p ->> 'candidates') || ':' || (p ->> 'percentile')
     FROM (SELECT public.get_placement_session((SELECT (j ->> 'id')::uuid FROM f39_start), NULL) -> 'percentile' AS p) s),
  '25:72',
  'R-9 : 25 élèves non bâclés (parents et bâclés exclus) ; 18 sous 7/10 → mieux que 72 %'
);

-- =========================================================
-- 7. Le balayage (R-19).
-- =========================================================
RESET ROLE;

INSERT INTO public.placement_sessions (id, user_id, subject_id, status, question_ids, started_at)
VALUES ('f3900000-0000-4000-8000-00000000aa01', NULL, 'f39-subj', 'running',
        ARRAY['f3900000-0000-4000-8000-00000000a101'::uuid], now() - interval '8 days'),
       ('f3900000-0000-4000-8000-00000000aa02', NULL, 'f39-subj', 'running',
        ARRAY['f3900000-0000-4000-8000-00000000a101'::uuid], now() - interval '1 day'),
       ('f3900000-0000-4000-8000-00000000aa03', 'f3900000-0000-4000-8000-000000000002', 'f39-subj', 'running',
        ARRAY['f3900000-0000-4000-8000-00000000a101'::uuid], now() - interval '8 days');
INSERT INTO public.placement_sessions (id, user_id, subject_id, status, question_ids, started_at, finished_at, correct_count, total_count, duration_seconds)
VALUES ('f3900000-0000-4000-8000-00000000aa04', NULL, 'f39-subj', 'completed',
        ARRAY['f3900000-0000-4000-8000-00000000a101'::uuid], now() - interval '92 days', now() - interval '91 days', 5, 10, 100);

SELECT is(
  public.sweep_placement_sessions(),
  '{"deletedAnonRunning": 1, "deletedAnonCompleted": 1, "abandoned": 1}'::jsonb,
  'R-19 : l''anonyme périmé part, le test de compte abandonné est marqué'
);

SELECT is(
  (SELECT status FROM public.placement_sessions WHERE id = 'f3900000-0000-4000-8000-00000000aa03'),
  'abandoned',
  'R-19 : un test de compte jamais fini depuis sept jours est « abandonné », pas effacé'
);

SELECT ok(
  EXISTS (SELECT 1 FROM public.placement_sessions WHERE id = 'f3900000-0000-4000-8000-00000000aa02'),
  'R-19 : un test anonyme d''hier reste'
);

-- =========================================================
-- 8. La digue (R-18) : 120 créations anonymes dans la minute, et la 121ᵉ attend.
-- =========================================================
INSERT INTO public.placement_sessions (user_id, subject_id, status, question_ids, started_at)
SELECT NULL, 'f39-subj', 'running', ARRAY['f3900000-0000-4000-8000-00000000a101'::uuid], now()
  FROM generate_series(1, 120);

-- Redevenir un VRAI anonyme : le shim lit `auth.uid()` dans les claims, quel que soit le rôle.
SET LOCAL "request.jwt.claims" = '';
SET LOCAL ROLE anon;

SELECT throws_ok(
  $$SELECT public.start_placement_session('f39-subj', 'student')$$,
  'P0001', 'PLACEMENT_BUSY',
  'R-18 : au-delà de 120 départs anonymes par minute, la plateforme refuse'
);

SELECT throws_ok(
  $$SELECT count(*) FROM public.placement_sessions$$,
  '42501', NULL,
  '⭐ l''anonyme ne lit RIEN par la table : son seul accès est le jeton, dans la RPC'
);

-- =========================================================
-- 9. Les droits, nominatifs.
-- =========================================================
RESET ROLE;

SELECT ok(
  has_function_privilege('anon', 'public.start_placement_session(text, text)', 'EXECUTE')
  AND has_function_privilege('anon', 'public.finish_placement_session(uuid, uuid, jsonb, int)', 'EXECUTE')
  AND has_function_privilege('anon', 'public.get_placement_session(uuid, uuid)', 'EXECUTE'),
  'le départ, la fin et la relecture sont ouverts à l''anonyme'
);

SELECT ok(
  NOT has_function_privilege('anon', 'public.claim_placement_sessions(uuid[])', 'EXECUTE')
  AND NOT has_function_privilege('anon', 'public.get_my_placement_overview()', 'EXECUTE')
  AND NOT has_function_privilege('authenticated', 'public.sweep_placement_sessions()', 'EXECUTE')
  AND NOT has_function_privilege('authenticated', 'public.placement_bilan_json(public.placement_sessions, boolean)', 'EXECUTE')
  AND NOT has_function_privilege('authenticated', 'public.placement_band(numeric)', 'EXECUTE'),
  'le rattachement et le Hall exigent un compte ; le balayage et les aides ne sont à aucun rôle client'
);

SELECT * FROM finish();
ROLLBACK;
