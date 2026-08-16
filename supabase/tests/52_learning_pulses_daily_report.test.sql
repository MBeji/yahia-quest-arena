-- =========================================================
-- Suivi parental « jour par jour » — pouls d'activité + rapport quotidien.
-- ---------------------------------------------------------
-- Vérifie contre un VRAI Postgres, avec le VRAI rôle `authenticated`, les quatre
-- invariants qui font tenir tout le module (docs/suivi-parental-quotidien.md) :
--
--   1. Le temps déclaré ne peut pas dépasser le temps réel écoulé. C'est
--      l'anti-triche du module : sans lui, un client modifié afficherait au
--      parent des heures de travail qui n'ont jamais eu lieu.
--   2. La table de pouls est en écriture RPC uniquement — aucun INSERT direct.
--   3. Le rapport n'est lisible que par un parent EFFECTIVEMENT lié (ou l'admin).
--   4. La correction d'un quiz de compréhension reste masquée, y compris côté
--      parent : rien n'empêche un élève d'ouvrir un compte parent et de s'y lier
--      avec son propre code alliance.
--
-- Tout est annulé à la fin.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(11);

-- ---------------------------------------------------------
-- Fixtures (superuser) : parent P lié à l'élève S, étranger X.
-- Un chapitre, un exercice d'entraînement, un quiz de compréhension.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('f9000000-0000-0000-0000-0000000000aa', 'pulse-parent@test.local'),
  ('f9000000-0000-0000-0000-0000000000bb', 'pulse-student@test.local'),
  ('f9000000-0000-0000-0000-0000000000cc', 'pulse-stranger@test.local');

INSERT INTO public.profiles (id, display_name, role) VALUES
  ('f9000000-0000-0000-0000-0000000000aa', 'PulseParent', 'parent'),
  ('f9000000-0000-0000-0000-0000000000bb', 'PulseStudent', 'student'),
  ('f9000000-0000-0000-0000-0000000000cc', 'PulseStranger', 'parent')
ON CONFLICT (id) DO UPDATE SET role = EXCLUDED.role;

INSERT INTO public.parent_student_links (parent_user_id, student_user_id, relation_label, is_active)
VALUES ('f9000000-0000-0000-0000-0000000000aa', 'f9000000-0000-0000-0000-0000000000bb', 'parent', true);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('pulse-subj', 'Pulse Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('fa000000-0000-0000-0000-000000000001', 'pulse-subj', 'Pulse Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode)
VALUES
  ('fb000000-0000-0000-0000-000000000001',
   'fa000000-0000-0000-0000-000000000001', 'pulse-subj', 'Pulse Practice', 'practice'),
  ('fb000000-0000-0000-0000-000000000002',
   'fa000000-0000-0000-0000-000000000001', 'pulse-subj', 'Pulse Quiz', 'quiz');

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order)
VALUES
  ('fc000000-0000-0000-0000-000000000001', 'fb000000-0000-0000-0000-000000000001',
   'Combien font 1/2 + 1/2 ?', '[{"id":"a","text":"1"},{"id":"b","text":"2/4"}]'::jsonb,
   'a', 'On additionne les numérateurs.', 1),
  ('fc000000-0000-0000-0000-000000000002', 'fb000000-0000-0000-0000-000000000002',
   'Question du quiz', '[{"id":"a","text":"oui"},{"id":"b","text":"non"}]'::jsonb,
   'a', 'Parce que.', 1);

-- Une session terminée + sa tentative, pour chacun des deux exercices.
INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at, completed_at)
VALUES
  ('fd000000-0000-0000-0000-000000000001', 'f9000000-0000-0000-0000-0000000000bb',
   'fb000000-0000-0000-0000-000000000001', now() - INTERVAL '1 hour', now() - INTERVAL '55 minutes'),
  ('fd000000-0000-0000-0000-000000000002', 'f9000000-0000-0000-0000-0000000000bb',
   'fb000000-0000-0000-0000-000000000002', now() - INTERVAL '30 minutes', now() - INTERVAL '28 minutes');

INSERT INTO public.attempts
  (id, user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, completed_at)
VALUES
  ('fe000000-0000-0000-0000-000000000001', 'f9000000-0000-0000-0000-0000000000bb',
   'fb000000-0000-0000-0000-000000000001', 'pulse-subj', 1, 2, 50, 300, 0, now() - INTERVAL '55 minutes'),
  ('fe000000-0000-0000-0000-000000000002', 'f9000000-0000-0000-0000-0000000000bb',
   'fb000000-0000-0000-0000-000000000002', 'pulse-subj', 1, 1, 100, 60, 0, now() - INTERVAL '28 minutes');

INSERT INTO public.question_attempts
  (user_id, question_id, chapter_id, session_id, choice, is_correct, source)
VALUES
  ('f9000000-0000-0000-0000-0000000000bb', 'fc000000-0000-0000-0000-000000000001',
   'fa000000-0000-0000-0000-000000000001', 'fd000000-0000-0000-0000-000000000001', 'b', false, 'exercise'),
  ('f9000000-0000-0000-0000-0000000000bb', 'fc000000-0000-0000-0000-000000000002',
   'fa000000-0000-0000-0000-000000000001', 'fd000000-0000-0000-0000-000000000002', 'a', true, 'quiz');

-- ---------------------------------------------------------
-- L'élève S écrit ses pouls.
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"f9000000-0000-0000-0000-0000000000bb","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- 1. Premier pouls : aucun antécédent, la durée demandée est créditée telle quelle.
SELECT is(
  public.record_learning_pulse(
    'lesson', 60, 'pulse-subj', 'fa000000-0000-0000-0000-000000000001', NULL, 40),
  60,
  'premier pouls : 60 s demandées, 60 s créditées'
);

-- 2. L'INVARIANT : un second pouls immédiat ne peut rien créditer, quelle que
--    soit la durée annoncée — il ne s'est pas écoulé une heure en une milliseconde.
SELECT is(
  public.record_learning_pulse(
    'lesson', 3600, 'pulse-subj', 'fa000000-0000-0000-0000-000000000001', NULL, 90),
  0,
  'anti-triche : 3600 s réclamées dans la foulée créditent 0 s'
);

-- 3. Une seule ligne a donc été écrite.
SELECT is(
  (SELECT COUNT(*)::INT FROM public.learning_pulses
    WHERE user_id = 'f9000000-0000-0000-0000-0000000000bb'),
  1,
  'le pouls refusé n''a laissé aucune ligne'
);

-- 4. Une surface inventée est rejetée.
SELECT throws_ok(
  $$ SELECT public.record_learning_pulse('tiktok', 60) $$,
  'P0001', 'Invalid surface',
  'une surface hors du jeu fermé est refusée'
);

-- 5. Écriture directe impossible : la RPC est la seule porte.
SELECT throws_ok(
  $$ INSERT INTO public.learning_pulses (user_id, surface, active_seconds)
     VALUES ('f9000000-0000-0000-0000-0000000000bb', 'lesson', 60) $$,
  '42501',
  NULL,
  'aucun INSERT direct sur learning_pulses pour authenticated'
);

-- 6. L'élève lit ses propres pouls (RLS).
SELECT is(
  (SELECT COUNT(*)::INT FROM public.learning_pulses),
  1,
  'l''élève lit ses propres pouls'
);

-- ---------------------------------------------------------
-- Un étranger ne voit rien, et ne peut rien demander.
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"f9000000-0000-0000-0000-0000000000cc","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT COUNT(*)::INT FROM public.learning_pulses),
  0,
  'un tiers ne voit aucun pouls (RLS)'
);

SELECT throws_ok(
  $$ SELECT public.get_student_daily_report(
       'f9000000-0000-0000-0000-0000000000bb', CURRENT_DATE, CURRENT_DATE) $$,
  'P0001', 'Access denied: you are not linked to this student.',
  'un parent NON lié ne peut pas lire le rapport quotidien'
);

-- ---------------------------------------------------------
-- Le parent lié P lit le rapport et le détail.
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"f9000000-0000-0000-0000-0000000000aa","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- 9. Le rapport voit bien les deux tentatives du jour.
SELECT is(
  (public.get_student_daily_report(
     'f9000000-0000-0000-0000-0000000000bb', CURRENT_DATE, CURRENT_DATE)
   -> 'totals' ->> 'exercises')::INT,
  2,
  'le rapport du jour compte les deux exercices terminés'
);

-- 10. Sur un exercice d'entraînement, la correction est bien fournie.
SELECT is(
  public.get_student_attempt_detail(
    'f9000000-0000-0000-0000-0000000000bb', 'fe000000-0000-0000-0000-000000000001')
  -> 'questions' -> 0 ->> 'correctOption',
  'a',
  'entraînement : le parent voit la bonne réponse'
);

-- 11. Sur un QUIZ de compréhension, elle ne l'est pas — la garde
--     anti-mémorisation vaut aussi côté parent.
SELECT ok(
  (public.get_student_attempt_detail(
     'f9000000-0000-0000-0000-0000000000bb', 'fe000000-0000-0000-0000-000000000002')
   -> 'questions' -> 0 ->> 'correctOption') IS NULL,
  'quiz : la bonne réponse reste masquée, même pour le parent'
);

SELECT * FROM finish();
ROLLBACK;
