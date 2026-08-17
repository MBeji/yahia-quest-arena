-- =========================================================
-- Suivi parental — couverture du programme + rapport quotidien PAR CODE.
-- ---------------------------------------------------------
-- Ce que ce fichier protège, contre un vrai Postgres et avec les vrais rôles :
--
--   1. La couverture d'une matière est celle de la carte /parcours de l'élève,
--      pas une deuxième règle inventée pour le parent. La RPC de l'élève et
--      celle du rapport doivent rendre EXACTEMENT le même compte — c'est tout
--      l'intérêt de les avoir fondues en une seule fonction.
--   2. Le rapport quotidien s'ouvre au porteur du code alliance, en ANONYME
--      (décision produit du 2026-08-16).
--   3. La correction d'un quiz de compréhension reste masquée sur ce chemin.
--      Ce n'est pas de la confidentialité : c'est l'anti-mémorisation du verrou
--      de chapitre. Un élève ouvrirait sinon son propre quiz avec son code.
--   4. Un code invalide, ou le code d'un compte qui n'est pas élève, est refusé.
--
-- Tout est annulé à la fin.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(9);

-- ---------------------------------------------------------
-- Fixtures : un élève, un parent, un chapitre à DEUX missions de catalogue
-- (une réussie, une non) — donc un chapitre publié et NON terminé.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('fc000000-0000-0000-0000-0000000000aa', 'cov-student@test.local'),
  ('fc000000-0000-0000-0000-0000000000bb', 'cov-parent@test.local');

INSERT INTO public.profiles (id, display_name, role) VALUES
  ('fc000000-0000-0000-0000-0000000000aa', 'CovStudent', 'student'),
  ('fc000000-0000-0000-0000-0000000000bb', 'CovParent', 'parent')
ON CONFLICT (id) DO UPDATE SET role = EXCLUDED.role;

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('cov-subj', 'Couverture Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('fd000000-0000-0000-0000-000000000001', 'cov-subj', 'Chapitre Couverture');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source)
VALUES
  ('fe000000-0000-0000-0000-000000000001',
   'fd000000-0000-0000-0000-000000000001', 'cov-subj', 'Mission A', 'practice', 'admin'),
  ('fe000000-0000-0000-0000-000000000002',
   'fd000000-0000-0000-0000-000000000001', 'cov-subj', 'Mission B', 'practice', 'admin'),
  ('fe000000-0000-0000-0000-000000000003',
   'fd000000-0000-0000-0000-000000000001', 'cov-subj', 'Quiz Couverture', 'quiz', 'admin');

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation)
VALUES
  ('ff000000-0000-0000-0000-000000000001', 'fe000000-0000-0000-0000-000000000001',
   'Question A', '[{"id":"a","text":"oui"},{"id":"b","text":"non"}]'::jsonb, 'a', 'Parce que A.'),
  ('ff000000-0000-0000-0000-000000000003', 'fe000000-0000-0000-0000-000000000003',
   'Question Quiz', '[{"id":"a","text":"oui"}]'::jsonb, 'a', 'Parce que quiz.');

-- Mission A réussie ; Mission B jamais tentée → chapitre publié, NON terminé.
INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at, completed_at)
VALUES
  ('fa000000-0000-0000-0000-000000000001', 'fc000000-0000-0000-0000-0000000000aa',
   'fe000000-0000-0000-0000-000000000001', now() - INTERVAL '1 hour', now() - INTERVAL '58 minutes'),
  ('fa000000-0000-0000-0000-000000000003', 'fc000000-0000-0000-0000-0000000000aa',
   'fe000000-0000-0000-0000-000000000003', now() - INTERVAL '30 minutes', now() - INTERVAL '29 minutes');

INSERT INTO public.attempts
  (id, user_id, exercise_id, subject_id, correct_count, total_count, score_pct,
   duration_seconds, xp_earned, session_id, completed_at)
VALUES
  ('fb000000-0000-0000-0000-000000000001', 'fc000000-0000-0000-0000-0000000000aa',
   'fe000000-0000-0000-0000-000000000001', 'cov-subj', 9, 10, 90, 300, 0,
   'fa000000-0000-0000-0000-000000000001', now() - INTERVAL '58 minutes'),
  ('fb000000-0000-0000-0000-000000000003', 'fc000000-0000-0000-0000-0000000000aa',
   'fe000000-0000-0000-0000-000000000003', 'cov-subj', 1, 1, 100, 60, 0,
   'fa000000-0000-0000-0000-000000000003', now() - INTERVAL '29 minutes');

INSERT INTO public.question_attempts
  (user_id, question_id, chapter_id, session_id, choice, is_correct, source)
VALUES
  ('fc000000-0000-0000-0000-0000000000aa', 'ff000000-0000-0000-0000-000000000001',
   'fd000000-0000-0000-0000-000000000001', 'fa000000-0000-0000-0000-000000000001', 'b', false, 'exercise'),
  ('fc000000-0000-0000-0000-0000000000aa', 'ff000000-0000-0000-0000-000000000003',
   'fd000000-0000-0000-0000-000000000001', 'fa000000-0000-0000-0000-000000000003', 'a', true, 'quiz');

-- ---------------------------------------------------------
-- 1–2. La couverture : UNE règle, deux appelants.
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"fc000000-0000-0000-0000-0000000000aa","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT chapters_total FROM public.get_user_parcours_progress(ARRAY['cov-subj'])),
  1,
  'un chapitre portant des missions de catalogue est PUBLIÉ (dénominateur)'
);

SELECT is(
  (SELECT chapters_completed FROM public.get_user_parcours_progress(ARRAY['cov-subj'])),
  0,
  'une mission de catalogue jamais réussie empêche le chapitre d''être terminé'
);

-- ---------------------------------------------------------
-- 3–7. Le chemin PUBLIC : anonyme, avec le seul code alliance.
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL "request.jwt.claims" = '';
SET LOCAL ROLE anon;

SELECT is(
  (public.get_student_daily_report_by_code(
     'fc0000000000000000000000000000aa', CURRENT_DATE, CURRENT_DATE)
   -> 'totals' ->> 'exercises')::INT,
  2,
  'anon : le rapport quotidien s''ouvre avec le seul code alliance'
);

SELECT is(
  (SELECT s ->> 'gradeName'
     FROM jsonb_array_elements(
       public.get_student_daily_report_by_code(
         'fc0000000000000000000000000000aa', CURRENT_DATE, CURRENT_DATE) -> 'subjects') s
    WHERE s ->> 'subjectId' = 'cov-subj'),
  NULL,
  'le niveau voyage dans la charge utile (NULL ici : matière hors grade)'
);

SELECT is(
  (SELECT (s ->> 'chaptersTotal')::INT
     FROM jsonb_array_elements(
       public.get_student_daily_report_by_code(
         'fc0000000000000000000000000000aa', CURRENT_DATE, CURRENT_DATE) -> 'subjects') s
    WHERE s ->> 'subjectId' = 'cov-subj'),
  1,
  'la couverture du programme accompagne chaque matière du rapport'
);

-- Entraînement : la correction est fournie.
SELECT is(
  public.get_student_attempt_detail_by_code(
    'fc0000000000000000000000000000aa', 'fb000000-0000-0000-0000-000000000001')
  -> 'questions' -> 0 ->> 'correctOption',
  'a',
  'anon : sur un entraînement, la bonne réponse est fournie'
);

-- Quiz : elle ne l'est pas, MÊME par code.
SELECT ok(
  (public.get_student_attempt_detail_by_code(
     'fc0000000000000000000000000000aa', 'fb000000-0000-0000-0000-000000000003')
   -> 'questions' -> 0 ->> 'correctOption') IS NULL,
  'quiz : la correction reste masquée sur le chemin public (anti-mémorisation)'
);

-- ---------------------------------------------------------
-- 8–9. Les codes qui ne doivent pas passer.
-- ---------------------------------------------------------
SELECT throws_ok(
  $$ SELECT public.get_student_daily_report_by_code('pas-un-code', CURRENT_DATE, CURRENT_DATE) $$,
  'P0001', 'Invalid student alliance code.',
  'un code mal formé est refusé'
);

SELECT throws_ok(
  $$ SELECT public.get_student_daily_report_by_code(
       'fc0000000000000000000000000000bb', CURRENT_DATE, CURRENT_DATE) $$,
  'P0001', 'This code does not belong to a student account.',
  'le code d''un compte NON élève est refusé'
);

SELECT * FROM finish();
ROLLBACK;
