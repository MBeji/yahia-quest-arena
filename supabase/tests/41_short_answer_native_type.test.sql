-- =========================================================
-- Étude 20 — lot 7 : le type natif `short_answer` (question libre).
--
-- Couvre : l'entrée du type dans le CHECK fermé, la branche `score_answer`
-- (verdict par APPARTENANCE — le même helper que le mode Rappel), la
-- révélation `answer_key_display`, et l'appariement des erreurs attendues
-- par `resolve_misconception_tag` (R-9) dans ses trois variantes.
--
-- Ce qui compte ici : une `short_answer` est corrigée comme du texte, pas
-- comme un choix. Une clé malformée doit rendre FAUX sans jamais lever —
-- une session d'élève ne meurt pas sur un contenu mal écrit (posture é03).
--
-- Espace de noms des fixtures : préfixe `5a07a0e4…`, inutilisé ailleurs.
-- =========================================================
BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(28);

-- =========================================================
-- 1. Le type est admis, et l'enum reste FERMÉ.
-- =========================================================
SELECT col_has_check('public', 'questions', 'question_type',
  'question_type porte toujours son CHECK fermé');

-- =========================================================
-- Fixtures.
-- =========================================================
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('etude20-lot7-subj', 'Short Answer Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('5a07a0e4-0001-0000-0000-000000000001', 'etude20-lot7-subj', 'Short Answer Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward, reward_coins, source, mode)
VALUES ('5a07a0e4-0002-0000-0000-000000000001',
        '5a07a0e4-0001-0000-0000-000000000001', 'etude20-lot7-subj',
        'Short Answer Exercise', 100, 20, 'admin', 'practice');

-- Q1 — AR : le cas de production. Canonique « فوق الشجرة », une variante
-- acceptée, et une erreur ATTENDUE taguée (le pendant du distracteur).
INSERT INTO public.questions
  (id, exercise_id, prompt, options, correct_option, question_type, answer_key, accepted_answers, display_order)
VALUES ('5a07a0e4-0003-0000-0000-000000000001', '5a07a0e4-0002-0000-0000-000000000001',
        'أين الطائر ؟', '[]'::jsonb, NULL, 'short_answer',
        '{"text":"فوق الشجرة","mistakes":[{"text":"تحت الشجرة","tag":"ar.espace.sur-sous"}]}'::jsonb,
        '["فوقها"]'::jsonb, 1);

-- Q2 — FR, sans ensemble accepté ni erreurs attendues : la canonique seule.
INSERT INTO public.questions
  (id, exercise_id, prompt, options, correct_option, question_type, answer_key, display_order)
VALUES ('5a07a0e4-0003-0000-0000-000000000002', '5a07a0e4-0002-0000-0000-000000000001',
        'Quelle est la capitale de la France ?', '[]'::jsonb, NULL, 'short_answer',
        '{"text":"Paris"}'::jsonb, 2);

-- Q3 — clé MALFORMÉE : pas de champ `text`. Doit rendre faux, jamais lever.
INSERT INTO public.questions
  (id, exercise_id, prompt, options, correct_option, question_type, answer_key, display_order)
VALUES ('5a07a0e4-0003-0000-0000-000000000003', '5a07a0e4-0002-0000-0000-000000000001',
        'Question à clé cassée ?', '[]'::jsonb, NULL, 'short_answer',
        '{"txet":"oups"}'::jsonb, 3);

-- Q4 — un QCM ordinaire, témoin de non-régression pour le tag classique.
INSERT INTO public.questions
  (id, exercise_id, prompt, options, correct_option, question_type, distractor_tags, display_order)
VALUES ('5a07a0e4-0003-0000-0000-000000000004', '5a07a0e4-0002-0000-0000-000000000001',
        'Combien font 2 + 2 ?',
        '[{"id":"a","text":"4"},{"id":"b","text":"5"},{"id":"c","text":"22"}]'::jsonb,
        'a', 'mcq', '{"c":"math.num.concatenation"}'::jsonb, 4);

-- =========================================================
-- 2. Le verdict (R-3) — appartenance, pas égalité stricte.
-- =========================================================
SELECT is(public.score_answer(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000001'), 'فوق الشجرة'),
  true, 'Q1: la canonique est juste');
SELECT is(public.score_answer(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000001'), 'فوقها'),
  true, 'Q1 (US-1): la variante acceptée est juste');
SELECT is(public.score_answer(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000001'), 'فَوْقَ الشَجَرَةِ'),
  true, 'Q1: la canonique vocalisée est juste (normalisation étude 17)');
SELECT is(public.score_answer(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000001'), 'تحت الشجرة'),
  false, 'Q1 (US-4): une erreur ATTENDUE reste fausse');
SELECT is(public.score_answer(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000001'), 'مرحبا'),
  false, 'Q1: une réponse hors-sujet est fausse');
SELECT is(public.score_answer(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000001'), ''),
  false, 'Q1: une saisie vide est fausse');
SELECT is(public.score_answer(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000001'), '   '),
  false, 'Q1: une saisie blanche est fausse');
SELECT is(public.score_answer(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000001'), NULL),
  false, 'Q1: une saisie NULL est fausse');

SELECT is(public.score_answer(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000002'), 'paris'),
  true, 'Q2: sans ensemble accepté, la canonique seule suffit (casse libre)');
SELECT is(public.score_answer(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000002'), 'Lyon'),
  false, 'Q2: une autre ville est fausse');

-- La clé cassée : faux, et surtout AUCUNE exception (une session ne meurt pas).
SELECT lives_ok(
  $$ SELECT public.score_answer(
       (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000003'), 'oups') $$,
  'Q3: une clé malformée ne lève jamais');
SELECT is(public.score_answer(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000003'), 'oups'),
  false, 'Q3: une clé malformée rend FAUX');

-- =========================================================
-- 3. La révélation à la correction.
-- =========================================================
SELECT is(public.answer_key_display(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000001')),
  'فوق الشجرة', 'answer_key_display rend la canonique, pas tout l''ensemble');
SELECT is(public.answer_key_display(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000002')),
  'Paris', 'answer_key_display rend la canonique française');
SELECT is(public.answer_key_display(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000004')),
  'a', 'non-régression: un mcq rend toujours son correct_option');

-- =========================================================
-- 4. L'appariement des erreurs (R-9) — trois variantes, une fonction.
-- =========================================================
SELECT is(public.resolve_misconception_tag(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000001'), 'تحت الشجرة'),
  'ar.espace.sur-sous', 'short_answer: le texte tapé retrouve son erreur attendue');
SELECT is(public.resolve_misconception_tag(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000001'), 'تَحْتَ الشَجَرَةِ'),
  'ar.espace.sur-sous', 'short_answer: l''appariement passe par la normalisation');
SELECT is(public.resolve_misconception_tag(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000001'), 'فوق الشجرة'),
  NULL, 'short_answer: une réponse JUSTE ne porte aucun tag');
SELECT is(public.resolve_misconception_tag(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000001'), 'شيء آخر'),
  NULL, 'short_answer: une erreur non prévue ne porte aucun tag');
SELECT is(public.resolve_misconception_tag(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000002'), 'Lyon'),
  NULL, 'short_answer sans erreurs attendues: aucun tag, aucune erreur');
SELECT is(public.resolve_misconception_tag(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000004'), 'c'),
  'math.num.concatenation', 'mcq classique: le tag vient de l''option choisie');
SELECT is(public.resolve_misconception_tag(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000004'), 'a'),
  NULL, 'mcq classique: la bonne option ne porte aucun tag');
SELECT is(public.resolve_misconception_tag(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000004'), '22', 'recall'),
  'math.num.concatenation', 'Rappel: le texte tapé retrouve le tag du distracteur');
SELECT is(public.resolve_misconception_tag(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000004'), NULL),
  NULL, 'un choix NULL ne porte aucun tag');

-- =========================================================
-- 5. Le Rappel ignore toujours les questions libres (R-11).
-- =========================================================
SELECT is(public.is_question_recall_eligible(
  (SELECT q FROM public.questions q WHERE q.id = '5a07a0e4-0003-0000-0000-000000000001')),
  false, 'une short_answer n''entre JAMAIS en mode Rappel (elle EST déjà du rappel)');

-- =========================================================
-- 6. Sécurité : aucun oracle client (R-1).
-- =========================================================
SELECT ok(
  NOT has_function_privilege('anon',
    'public.resolve_misconception_tag(public.questions, text, text)', 'EXECUTE'),
  'anon ne peut pas exécuter resolve_misconception_tag');
SELECT ok(
  NOT has_function_privilege('authenticated',
    'public.resolve_misconception_tag(public.questions, text, text)', 'EXECUTE'),
  'authenticated ne peut pas exécuter resolve_misconception_tag');

SELECT * FROM finish();
ROLLBACK;
