-- =========================================================
-- Étude 02 — examen blanc (lots 1-2).
-- ---------------------------------------------------------
-- Un mode examen est dangereux de trois façons, et ce fichier attaque les trois.
--
--   1. IL FUIT. Pendant l'épreuve, le payload ne doit porter NI clé de réponse NI
--      explication — sinon l'examen blanc devient un distributeur de corrigés, et
--      la review n'a plus d'objet. C'est la régression la plus facile à introduire
--      (il suffit d'un `SELECT *`) et la plus silencieuse : tout continue de
--      marcher à l'écran.
--
--   2. IL MENT. Le barème porte les coefficients réels du concours. Un scoring qui
--      pondère mal rend une note plausible et fausse — le pire des deux mondes.
--      Le jeu de fixtures est calibré pour qu'une erreur de pondération change le
--      résultat : 1/2 sur une épreuve à 40 points et 1/1 sur une à 10 donnent
--      30/50, soit 12/20. Une moyenne non pondérée donnerait 15/20.
--
--   3. IL SE REJOUE. Une session classée jouée deux fois, ou rendue deux fois,
--      détruit le classement et double la récompense.
--
-- Espace de noms des fixtures : `7e5749…` (réservé aux tests, numéro de ce
-- fichier) pour le contenu, `e9a20000…` pour les comptes, `exam-subj` pour la
-- matière. Aucun n'apparaît dans une migration.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(26);

-- =========================================================
-- 1-9. La surface : RLS armée, et une seule porte d'entrée.
-- =========================================================
SELECT is(
  (SELECT relrowsecurity FROM pg_class WHERE oid = 'public.mock_exams'::regclass),
  true, 'mock_exams : RLS armée');

SELECT is(
  (SELECT relrowsecurity FROM pg_class WHERE oid = 'public.mock_exam_papers'::regclass),
  true, 'mock_exam_papers : RLS armée');

SELECT is(
  (SELECT relrowsecurity FROM pg_class WHERE oid = 'public.mock_exam_sessions'::regclass),
  true, 'mock_exam_sessions : RLS armée');

SELECT is(
  has_table_privilege('anon', 'public.mock_exams', 'SELECT'),
  false, 'anon ne voit aucun examen — le mode vit derrière l''auth');

SELECT is(
  has_table_privilege('authenticated', 'public.mock_exams', 'SELECT'),
  true, 'l''élève connecté lit le catalogue des examens');

SELECT is(
  has_table_privilege('authenticated', 'public.mock_exam_sessions', 'INSERT'),
  false, 'personne n''écrit une session à la main : le seul écrivain est le RPC');

SELECT is(
  has_function_privilege('anon', 'public.start_mock_exam(uuid, text)', 'EXECUTE'),
  false, 'anon ne peut pas ouvrir d''épreuve');

SELECT is(
  has_function_privilege('authenticated', 'public.start_mock_exam(uuid, text)', 'EXECUTE'),
  true, 'l''élève connecté le peut — la garde est dans la fonction, pas dans le GRANT');

SELECT is(
  has_function_privilege('anon', 'public.finish_mock_exam(uuid)', 'EXECUTE'),
  false, 'anon ne rend aucune copie');

-- =========================================================
-- 10. Sans session, la fonction refuse — même appelée en direct.
-- =========================================================
SELECT throws_ok(
  $$SELECT public.start_mock_exam('7e574900-0000-4000-8000-000000000001'::uuid, 'ranked')$$,
  'P0001',
  'Unauthorized',
  'sans auth.uid(), l''ouverture est refusée avant toute lecture');

-- =========================================================
-- Fixtures — deux élèves, une matière, deux épreuves pondérées 40 et 10.
-- =========================================================
INSERT INTO auth.users (id, email) VALUES
  ('e9a20000-0000-4000-8000-00000000000a', 'eleve-a-exam@test.local'),
  ('e9a20000-0000-4000-8000-00000000000b', 'eleve-b-exam@test.local');

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('exam-subj', 'Examen', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('7e574901-0000-4000-8000-000000000001', 'exam-subj', 'Chapitre d''examen');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode, difficulty)
VALUES
  ('7e574902-0000-4000-8000-000000000001', '7e574901-0000-4000-8000-000000000001',
   'exam-subj', 'Épreuve lourde', 'admin', 'practice', 3),
  ('7e574902-0000-4000-8000-000000000002', '7e574901-0000-4000-8000-000000000001',
   'exam-subj', 'Épreuve légère', 'admin', 'practice', 1);

-- L'explication porte un marqueur unique : s'il apparaît dans le payload de
-- passation, c'est que la review a fuité dans l'épreuve.
INSERT INTO public.questions
  (id, exercise_id, prompt, options, correct_option, explanation, question_type, display_order)
VALUES
  ('7e574903-0000-4000-8000-000000000001', '7e574902-0000-4000-8000-000000000001',
   'Question lourde 1', '[{"id":"a","text":"un"},{"id":"b","text":"deux"}]'::jsonb,
   'b', 'EXPLICATION-SECRETE-1', 'mcq', 1),
  ('7e574903-0000-4000-8000-000000000002', '7e574902-0000-4000-8000-000000000001',
   'Question lourde 2', '[{"id":"a","text":"un"},{"id":"b","text":"deux"}]'::jsonb,
   'a', 'EXPLICATION-SECRETE-2', 'mcq', 2),
  ('7e574903-0000-4000-8000-000000000003', '7e574902-0000-4000-8000-000000000002',
   'Question légère 1', '[{"id":"a","text":"un"},{"id":"b","text":"deux"}]'::jsonb,
   'a', 'EXPLICATION-SECRETE-3', 'mcq', 1);

INSERT INTO public.mock_exams
  (id, parcours_id, title_fr, duration_minutes, status, display_order)
VALUES
  ('7e574904-0000-4000-8000-000000000001', 'concours-9eme',
   'Blanc de test', 60, 'published', 99);

INSERT INTO public.mock_exam_papers
  (exam_id, exercise_id, label_fr, points, display_order)
VALUES
  ('7e574904-0000-4000-8000-000000000001', '7e574902-0000-4000-8000-000000000001',
   'Matière lourde', 40, 1),
  ('7e574904-0000-4000-8000-000000000001', '7e574902-0000-4000-8000-000000000002',
   'Matière légère', 10, 2);

-- =========================================================
-- 11-13. La passation ne montre que ce qu'il faut.
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"e9a20000-0000-4000-8000-00000000000a","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT set_config(
  'test.start',
  public.start_mock_exam('7e574904-0000-4000-8000-000000000001'::uuid, 'ranked')::text,
  true);

SELECT is(
  jsonb_array_length(current_setting('test.start')::jsonb -> 'papers'),
  2, 'l''épreuve sert ses deux matières');

SELECT is(
  current_setting('test.start') LIKE '%EXPLICATION-SECRETE%',
  false, 'R-3 : aucune explication ne part avec le sujet');

SELECT is(
  current_setting('test.start') LIKE '%correctOption%'
    OR current_setting('test.start') LIKE '%answer_key%'
    OR current_setting('test.start') LIKE '%correct_option%',
  false, 'R-3 : aucune clé de réponse dans le payload de passation');

-- =========================================================
-- 14. Sauvegarde au fil de l'eau : 2 justes, 1 fausse.
-- =========================================================
SELECT set_config(
  'test.session',
  current_setting('test.start')::jsonb -> 'session' ->> 'id',
  true);

SELECT is(
  (public.save_mock_answers(
     current_setting('test.session')::uuid,
     jsonb_build_object(
       '7e574903-0000-4000-8000-000000000001', 'b',   -- juste
       '7e574903-0000-4000-8000-000000000002', 'b',   -- fausse (clé = a)
       '7e574903-0000-4000-8000-000000000003', 'a'    -- juste
     )
   ) ->> 'answered')::int,
  3, 'les trois réponses sont enregistrées au fil de l''eau');

-- =========================================================
-- 15. La review reste fermée tant que la copie n'est pas rendue.
-- =========================================================
SELECT throws_ok(
  format(
    $$SELECT public.get_mock_exam_review(%L::uuid)$$,
    current_setting('test.session')),
  'P0001',
  'MOCK_EXAM_NOT_FINISHED',
  'R-3 : pas de corrigé avant le rendu');

-- =========================================================
-- 16-19. Le rendu, et surtout LA PONDÉRATION.
-- 1/2 sur 40 points = 20 ; 1/1 sur 10 points = 10 ; total 30/50 = 12/20.
-- Une moyenne non pondérée aurait donné 15/20 — l'écart est le test.
-- =========================================================
SELECT set_config(
  'test.finish',
  public.finish_mock_exam(current_setting('test.session')::uuid)::text,
  true);

SELECT is(
  (current_setting('test.finish')::jsonb ->> 'scorePoints')::numeric,
  30::numeric, 'le score suit les coefficients : 20 + 10, pas une moyenne plate');

SELECT is(
  (current_setting('test.finish')::jsonb ->> 'maxPoints')::int,
  50, 'le barème total est la somme des coefficients');

SELECT is(
  (current_setting('test.finish')::jsonb ->> 'scoreOn20')::numeric,
  12::numeric, 'la note /20 est pondérée — 12, pas 15');

SELECT is(
  (current_setting('test.finish')::jsonb ->> 'xpEarned')::int,
  180, 'la récompense classée suit le score (300 XP × 60 %)');

-- =========================================================
-- 20-21. On ne rejoue pas une session classée.
-- =========================================================
SELECT throws_ok(
  format($$SELECT public.finish_mock_exam(%L::uuid)$$, current_setting('test.session')),
  'P0001',
  'MOCK_EXAM_FINISHED',
  'rendre deux fois est refusé — sinon la récompense double');

SELECT throws_ok(
  $$SELECT public.start_mock_exam('7e574904-0000-4000-8000-000000000001'::uuid, 'ranked')$$,
  'P0001',
  'MOCK_EXAM_ALREADY_RANKED',
  'R-4 : une seule session classée par examen et par élève');

-- =========================================================
-- 22-24. Après le rendu : le corrigé s'ouvre, le rang reste prudent.
-- =========================================================
SELECT is(
  public.get_mock_exam_review(current_setting('test.session')::uuid)::text
    LIKE '%EXPLICATION-SECRETE-1%',
  true, 'la review, elle, porte bien les explications');

SELECT set_config(
  'test.pct',
  public.get_mock_exam_percentile(current_setting('test.session')::uuid)::text,
  true);

SELECT is(
  (current_setting('test.pct')::jsonb ->> 'candidates')::int,
  1, 'le percentile compte les copies classées rendues');

SELECT is(
  current_setting('test.pct')::jsonb ->> 'percentile',
  NULL, 'R-6 : sous 20 candidats, aucun rang n''est affiché');

-- =========================================================
-- 25. R-6 : la copie d'un élève n'est pas lisible par un autre.
-- =========================================================
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"e9a20000-0000-4000-8000-00000000000b","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.mock_exam_sessions
    WHERE user_id = 'e9a20000-0000-4000-8000-00000000000a'),
  0, 'un élève ne voit pas la copie d''un autre');

-- =========================================================
-- 26. La deadline est serveur : après l'heure, on n'écrit plus.
-- =========================================================
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"e9a20000-0000-4000-8000-00000000000a","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT set_config(
  'test.practice',
  public.start_mock_exam('7e574904-0000-4000-8000-000000000001'::uuid, 'practice')
    -> 'session' ->> 'id',
  true);

RESET ROLE;
-- On recule la fenêtre ENTIÈRE, pas la seule deadline : la contrainte
-- `mock_exam_sessions_deadline_after_start` (lot 1) refuse une échéance
-- antérieure au départ, et elle a raison — une session dont la deadline précède
-- le début n'existe pas. Le premier jet de ce test l'ignorait ; la contrainte
-- l'a attrapé en CI.
UPDATE public.mock_exam_sessions
   SET started_at = now() - INTERVAL '2 hours',
       deadline   = now() - INTERVAL '1 minute'
 WHERE id = current_setting('test.practice')::uuid;

SET LOCAL "request.jwt.claims" = '{"sub":"e9a20000-0000-4000-8000-00000000000a","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  format(
    $$SELECT public.save_mock_answers(%L::uuid, '{"7e574903-0000-4000-8000-000000000001":"b"}'::jsonb)$$,
    current_setting('test.practice')),
  'P0001',
  'MOCK_EXAM_DEADLINE_PASSED',
  'R-2 : passé l''heure, plus rien ne s''écrit dans la copie');

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
