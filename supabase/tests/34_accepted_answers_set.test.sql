-- =========================================================
-- Étude 20 — Réponses acceptées · lot 1 (socle du scoring ensembliste).
--
-- Couvre : la colonne server-only `questions.accepted_answers`, le helper
-- unique `is_accepted_free_answer` (R-3, D-9), la délégation de
-- `score_recall_answer` (non-régression étude 17), l'invariant de sécurité
-- R-1/RISK-5 (ni la colonne ni le helper n'atteignent le client) et le cadrage
-- du type `content_reports.recall_false_negative` (Q-3).
--
-- La §2 est la moitié SQL du corpus de parité TS↔SQL (RISK-2) : les mêmes
-- lignes sont jouées côté TS par `src/shared/content/__tests__/free-answer.test.ts`,
-- qui vérifie EN PLUS que chaque entrée figure bien dans CE fichier — une
-- divergence de normalisation entre le gate QA et le scoring ne peut donc pas
-- passer inaperçue.
--
-- Espace de noms des fixtures : préfixe `7e572034…`, inutilisé ailleurs (les
-- lignes de contenu HÉRITÉES survivent sur une base fraîche depuis que les
-- migrations générées ont quitté le repo public — étude 24 lot 4).
-- =========================================================
BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(52);

-- =========================================================
-- 1. La colonne — additive, server-only, forme contrainte.
-- =========================================================
SELECT has_column('public', 'questions', 'accepted_answers',
  'colonne accepted_answers présente sur public.questions');
SELECT col_not_null('public', 'questions', 'accepted_answers',
  'accepted_answers est NOT NULL (jamais de NULL à interpréter au scoring)');

-- =========================================================
-- 2. Parité TS↔SQL de la normalisation (RISK-2) — corpus partagé.
--    Miroir exact de PARITY_CORPUS (src/shared/content/free-answer.ts).
-- =========================================================
SELECT is(public.normalize_recall_text('Élève'), 'eleve',
  'parité: FR accents dépliés, casse abaissée');
SELECT is(public.normalize_recall_text('sœur'), 'soeur',
  'parité: FR ligature œ pliée (NFKC ne la décompose pas)');
SELECT is(public.normalize_recall_text('L''Afrique'), 'lafrique',
  'parité: FR apostrophe supprimée (variante avec article)');
SELECT is(public.normalize_recall_text('Le Conseil de sécurité'), 'leconseildesecurite',
  'parité: FR espaces supprimés');
SELECT is(public.normalize_recall_text('They''re'), 'theyre',
  'parité: EN apostrophe de contraction supprimée');
SELECT is(public.normalize_recall_text('cannot have'), 'cannothave',
  'parité: EN multi-mots joint');
SELECT is(public.normalize_recall_text('مَدْرَسَةٌ'), 'مدرسه',
  'parité: AR tashkeel supprimé, ة pliée en ه');
SELECT is(public.normalize_recall_text('النبات الأخضر'), 'النباتالاخضر',
  'parité: AR أ plié en ا, espaces supprimés');
SELECT is(public.normalize_recall_text('فوق الشجرة'), 'فوقالشجره',
  'parité: AR locution positionnelle (le cas constaté en production)');
SELECT is(public.normalize_recall_text('٤٢'), '42',
  'parité: chiffres arabes-indics convertis');
SELECT is(public.normalize_recall_text('3,14'), '3.14',
  'parité: virgule décimale en point, point intercalé conservé');
SELECT is(public.normalize_recall_text('1 000'), '1000',
  'parité: groupes de chiffres joints');
SELECT is(public.normalize_recall_text('50 %'), '50',
  'parité: le % est rendu insignifiant');
SELECT is(public.normalize_recall_text('etc.'), 'etc',
  'parité: point final (non intercalé) supprimé');
SELECT is(public.normalize_recall_text('π'), '',
  'parité: caractère hors clavier supprimé');

-- =========================================================
-- Fixtures.
-- =========================================================
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('etude20-subj', 'Accepted Answers Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('7e572034-0001-0000-0000-000000000001', 'etude20-subj', 'Accepted Answers Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward, reward_coins, source, mode)
VALUES ('7e572034-0002-0000-0000-000000000001',
        '7e572034-0001-0000-0000-000000000001', 'etude20-subj',
        'Accepted Answers Exercise', 100, 20, 'admin', 'practice');

-- Q1 — FR, canonique « Afrique », deux variantes acceptées (article + synonyme).
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order, accepted_answers)
VALUES ('7e572034-0003-0000-0000-000000000001', '7e572034-0002-0000-0000-000000000001',
        'Sur quel continent se trouve le Sahara ?',
        '[{"id":"a","text":"Afrique"},{"id":"b","text":"Asie"},{"id":"c","text":"Europe"},{"id":"d","text":"Océanie"}]'::jsonb,
        'a', 1,
        '["l''Afrique", "le continent africain"]'::jsonb);

-- Q2 — AR, canonique « فوقها », variante positionnelle (le faux négatif constaté).
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order, accepted_answers)
VALUES ('7e572034-0003-0000-0000-000000000002', '7e572034-0002-0000-0000-000000000001',
        'أين الطائر ؟',
        '[{"id":"a","text":"فوقها"},{"id":"b","text":"تحت الشجرة"},{"id":"c","text":"بجانب الشجرة"}]'::jsonb,
        'a', 2,
        '["فوق الشجرة"]'::jsonb);

-- Q3 — ensemble VIDE : le comportement doit rester celui de l'étude 17.
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order, accepted_answers)
VALUES ('7e572034-0003-0000-0000-000000000003', '7e572034-0002-0000-0000-000000000001',
        'Capitale de la France ?',
        '[{"id":"a","text":"Paris"},{"id":"b","text":"Lyon"},{"id":"c","text":"Nice"}]'::jsonb,
        'a', 3, '[]'::jsonb);

-- Q4 — clé MALFORMÉE : correct_option ne désigne aucune option existante.
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES ('7e572034-0003-0000-0000-000000000004', '7e572034-0002-0000-0000-000000000001',
        'Question à clé cassée ?',
        '[{"id":"a","text":"Paris"},{"id":"b","text":"Lyon"},{"id":"c","text":"Nice"}]'::jsonb,
        'zz', 4);

-- Q5 — colonne OMISE à l'insertion : sert à prouver le DEFAULT.
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES ('7e572034-0003-0000-0000-000000000005', '7e572034-0002-0000-0000-000000000001',
        'Question sans ensemble ?',
        '[{"id":"a","text":"Rome"},{"id":"b","text":"Oslo"},{"id":"c","text":"Kiev"}]'::jsonb,
        'a', 5);

SELECT is(
  (SELECT accepted_answers FROM public.questions WHERE id = '7e572034-0003-0000-0000-000000000005'),
  '[]'::jsonb,
  'DEFAULT: une question insérée sans ensemble reçoit [] (zéro backfill)');

SELECT throws_ok(
  $$ INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order, accepted_answers)
     VALUES ('7e572034-0003-0000-0000-0000000000ff', '7e572034-0002-0000-0000-000000000001',
             'Forme invalide ?',
             '[{"id":"a","text":"A"},{"id":"b","text":"B"},{"id":"c","text":"C"}]'::jsonb,
             'a', 99, '"pas un tableau"'::jsonb) $$,
  '23514', NULL,
  'CHECK: accepted_answers refuse une valeur qui n''est pas un tableau JSON');

-- =========================================================
-- 3. Le verdict ensembliste (R-3) — table-driven.
-- =========================================================
-- Q1 — la canonique reste toujours acceptée (R-2), sans figurer dans l'ensemble.
SELECT is(public.is_accepted_free_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000001'), 'Afrique'),
  true, 'Q1: la réponse canonique est acceptée');
SELECT is(public.is_accepted_free_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000001'), '  AFRIQUE '),
  true, 'Q1: la canonique en casse/espaces différents est acceptée');
SELECT is(public.is_accepted_free_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000001'), 'l''Afrique'),
  true, 'Q1: la variante avec article est acceptée (US-1)');
SELECT is(public.is_accepted_free_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000001'), 'L''AFRIQUE'),
  true, 'Q1: la variante avec article, en majuscules, est acceptée');
SELECT is(public.is_accepted_free_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000001'), 'le continent africain'),
  true, 'Q1: la paraphrase listée est acceptée');
SELECT is(public.is_accepted_free_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000001'), 'Le Continent Africain'),
  true, 'Q1: la paraphrase listée, casse libre, est acceptée');
-- US-4 — une vraie erreur reste une erreur.
SELECT is(public.is_accepted_free_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000001'), 'Asie'),
  false, 'Q1 (US-4): un distracteur reste FAUX');
SELECT is(public.is_accepted_free_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000001'), 'Bonjour'),
  false, 'Q1 (US-4): une réponse hors-sujet reste FAUSSE');
SELECT is(public.is_accepted_free_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000001'), ''),
  false, 'Q1: une saisie vide est fausse');
SELECT is(public.is_accepted_free_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000001'), '   '),
  false, 'Q1: une saisie blanche est fausse');
SELECT is(public.is_accepted_free_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000001'), NULL),
  false, 'Q1: une saisie NULL est fausse');

-- Q2 — l'arabe (US-2) : le cas exact refusé en production le 2026-07-15.
SELECT is(public.is_accepted_free_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000002'), 'فوقها'),
  true, 'Q2: la canonique arabe est acceptée');
SELECT is(public.is_accepted_free_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000002'), 'فوق الشجرة'),
  true, 'Q2 (US-1): « فوق الشجرة » est ENFIN acceptée là où « فوقها » était attendue');
SELECT is(public.is_accepted_free_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000002'), 'فَوْقَ الشَجَرَةِ'),
  true, 'Q2: la même variante vocalisée (tashkeel) est acceptée');
SELECT is(public.is_accepted_free_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000002'), 'فوقالشجرة'),
  true, 'Q2: la même variante sans espace est acceptée');
SELECT is(public.is_accepted_free_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000002'), 'تحت الشجرة'),
  false, 'Q2 (US-4): le distracteur « sous l''arbre » reste FAUX');

-- Q3 — ensemble vide : non-régression stricte de l'étude 17.
SELECT is(public.is_accepted_free_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000003'), 'Paris'),
  true, 'Q3: ensemble [] — la canonique passe (étude 17 à l''identique)');
SELECT is(public.is_accepted_free_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000003'), 'Lyon'),
  false, 'Q3: ensemble [] — un distracteur reste faux (étude 17 à l''identique)');

-- Q4 — clé malformée : FAUX, jamais une exception (posture étude 03).
SELECT is(public.is_accepted_free_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000004'), 'Paris'),
  false, 'Q4: clé malformée (option introuvable) — verdict faux, sans exception');
SELECT is(public.is_accepted_free_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000004'), 'π'),
  false, 'Q4: clé malformée + saisie se normalisant en vide — reste FAUX (pas de faux positif)');

-- Délégation : `score_recall_answer` doit rendre exactement le même verdict.
SELECT is(public.score_recall_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000001'), 'l''Afrique'),
  true, 'délégation: score_recall_answer accepte la variante listée');
SELECT is(public.score_recall_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000001'), 'Asie'),
  false, 'délégation: score_recall_answer refuse un distracteur');
SELECT is(public.score_recall_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000003'), 'Paris'),
  true, 'délégation: ensemble [] — verdict identique à l''étude 17');
SELECT is(public.score_recall_answer(
  (SELECT q FROM public.questions q WHERE q.id = '7e572034-0003-0000-0000-000000000001'), NULL),
  false, 'délégation: score_recall_answer ne rend jamais NULL (COALESCE)');

-- =========================================================
-- 4. R-1 / RISK-5 — ni la colonne ni le helper n'atteignent le client.
-- =========================================================
SELECT is(
  has_column_privilege('anon', 'public.questions', 'accepted_answers', 'SELECT'),
  false, 'R-1: anon ne peut pas lire questions.accepted_answers');
SELECT is(
  has_column_privilege('authenticated', 'public.questions', 'accepted_answers', 'SELECT'),
  false, 'R-1: authenticated ne peut pas lire questions.accepted_answers');
-- Garde-fou : la révocation ci-dessus ne doit pas avoir emporté le catalogue.
SELECT is(
  has_column_privilege('authenticated', 'public.questions', 'options', 'SELECT'),
  true, 'sanity: la whitelist client (options) est intacte');
SELECT is(
  has_function_privilege('anon', 'public.is_accepted_free_answer(public.questions, text)', 'EXECUTE')
    OR has_function_privilege('authenticated', 'public.is_accepted_free_answer(public.questions, text)', 'EXECUTE'),
  false, 'R-1: is_accepted_free_answer n''est pas exécutable par le client (pas d''oracle)');
SELECT is(
  has_function_privilege('anon', 'public.score_recall_answer(public.questions, text)', 'EXECUTE')
    OR has_function_privilege('authenticated', 'public.score_recall_answer(public.questions, text)', 'EXECUTE'),
  false, 'R-1: score_recall_answer reste non exécutable après recréation (non-régression étude 17)');

-- =========================================================
-- 5. « Refus contesté » — cadrage du type seulement (Q-3, lot 6 pour la file).
-- =========================================================
SELECT has_column('public', 'content_reports', 'kind',
  'colonne kind présente sur content_reports (discriminant du signalement)');

INSERT INTO auth.users (id, email)
VALUES ('7e572034-0004-0000-0000-000000000001', 'etude20@test.local');

INSERT INTO public.content_reports (id, user_id, question_id, message)
VALUES ('7e572034-0005-0000-0000-000000000001', '7e572034-0004-0000-0000-000000000001',
        '7e572034-0003-0000-0000-000000000001', 'Signalement historique, sans kind explicite.');

SELECT is(
  (SELECT kind FROM public.content_reports WHERE id = '7e572034-0005-0000-0000-000000000001'),
  'content_error',
  'DEFAULT: un signalement existant reste un content_error (zéro backfill)');

INSERT INTO public.content_reports (id, user_id, question_id, message, kind)
VALUES ('7e572034-0005-0000-0000-000000000002', '7e572034-0004-0000-0000-000000000001',
        '7e572034-0003-0000-0000-000000000001', 'Ma réponse était juste !', 'recall_false_negative');

SELECT is(
  (SELECT kind FROM public.content_reports WHERE id = '7e572034-0005-0000-0000-000000000002'),
  'recall_false_negative',
  'Q-3: le type recall_false_negative est accepté dès le lot 1 (US-5)');

SELECT throws_ok(
  $$ INSERT INTO public.content_reports (id, user_id, message, kind)
     VALUES ('7e572034-0005-0000-0000-0000000000ff', '7e572034-0004-0000-0000-000000000001',
             'Type inventé.', 'pas_un_type') $$,
  '23514', NULL,
  'CHECK: content_reports.kind est un enum FERMÉ');

SELECT * FROM finish();
ROLLBACK;
