-- =========================================================
-- Étude 17 — Rappel actif · lot 1 (FableEtudes/17-rappel-actif#lot-1).
-- Fondations SQL pures : normalisation R-4, éligibilité R-2 (a)–(i), scorer,
-- et l'invariant de sécurité R-1 (aucune des trois fonctions n'est exécutable
-- par un client — pas d'oracle de réponse).
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(38);

-- ---------------------------------------------------------
-- Colonnes `variant` — présentes, défaut 'classic', contrainte fermée.
-- ---------------------------------------------------------
-- (couvertes indirectement par les migrations de scoring du lot 2 ; ici on se
--  concentre sur les fonctions pures, cœur du mode.)

-- =========================================================
-- 1. Normalisation (R-4) — table-driven.
-- =========================================================
SELECT is(public.normalize_recall_text('Élève'), 'eleve',
  'FR: accents dépliés et casse abaissée');
SELECT is(public.normalize_recall_text('sœur'), 'soeur',
  'FR: la ligature œ est pliée en oe (NFKC ne la décompose pas)');
SELECT is(public.normalize_recall_text('sœur'), public.normalize_recall_text('soeur'),
  'FR: sœur et soeur se normalisent identiquement');
SELECT is(public.normalize_recall_text('مَدْرَسَةٌ'), 'مدرسه',
  'AR: tashkeel supprimé et ة (ta marbuta) pliée en ه');
SELECT is(public.normalize_recall_text('أحمد'), public.normalize_recall_text('احمد'),
  'AR: أ (alef hamza) plié en ا');
SELECT is(public.normalize_recall_text('٤٢'), '42',
  'AR: chiffres arabes-indics convertis en occidentaux');
SELECT is(public.normalize_recall_text('3,14'), '3.14',
  'nombres: la virgule décimale devient un point');
SELECT is(public.normalize_recall_text('1 000'), '1000',
  'nombres: les groupes de chiffres séparés par un espace sont joints');
SELECT is(public.normalize_recall_text('50 %'), '50',
  'ponctuation: le % est rendu insignifiant (50 % ≡ 50)');
SELECT is(public.normalize_recall_text('45°'), '45',
  'ponctuation: le ° est rendu insignifiant (45° ≡ 45)');
SELECT is(public.normalize_recall_text('grand-père'), 'grandpere',
  'FR: trait d''union et accent normalisés');
SELECT is(public.normalize_recall_text('grand père'), 'grandpere',
  'segmentation: grand père ≡ grand-père ≡ grandpère');
SELECT is(public.normalize_recall_text('PARIS'), 'paris',
  'casse: mise en minuscules');
SELECT is(public.normalize_recall_text('   '), '',
  'vide: une saisie blanche se normalise en chaîne vide');
SELECT is(public.normalize_recall_text('π'), '',
  'charset: un caractère hors clavier (grec) est supprimé');
SELECT is(public.normalize_recall_text('etc.'), 'etc',
  'points: un point final (non intercalé) est supprimé');
SELECT is(public.normalize_recall_text('3.14'), '3.14',
  'points: un point intercalé entre deux chiffres est conservé');
SELECT is(public.normalize_recall_text('25 cm'), '25cm',
  'unités: 25 cm ≡ 25cm (espaces supprimés)');

-- =========================================================
-- Fixtures contenu pour l'éligibilité et le scorer.
-- =========================================================
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('recall-subj', 'Recall Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('e1000000-0000-0000-0000-000000000001', 'recall-subj', 'Recall Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward, reward_coins, source, mode)
VALUES ('e2000000-0000-0000-0000-000000000001',
        'e1000000-0000-0000-0000-000000000001', 'recall-subj',
        'Recall Exercise', 100, 20, 'admin', 'practice');

-- E1 — éligible (réponse courte, énoncé auto-suffisant).
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES ('e3000000-0000-0000-0000-000000000001', 'e2000000-0000-0000-0000-000000000001',
        'Capitale de la France ?',
        '[{"id":"a","text":"Paris"},{"id":"b","text":"Lyon"},{"id":"c","text":"Marseille"},{"id":"d","text":"Nice"}]'::jsonb,
        'a', 1);

-- E2 — (b) seulement 2 options.
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES ('e3000000-0000-0000-0000-000000000002', 'e2000000-0000-0000-0000-000000000001',
        'Vrai ou faux ?',
        '[{"id":"a","text":"Vrai"},{"id":"b","text":"Faux"}]'::jsonb,
        'a', 2);

-- E3 — (c) réponse > 6 mots.
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES ('e3000000-0000-0000-0000-000000000003', 'e2000000-0000-0000-0000-000000000001',
        'Compter ?',
        '[{"id":"a","text":"un deux trois quatre cinq six sept"},{"id":"b","text":"huit"},{"id":"c","text":"neuf"}]'::jsonb,
        'a', 3);

-- E4 — (c) réponse > 60 caractères.
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES ('e3000000-0000-0000-0000-000000000004', 'e2000000-0000-0000-0000-000000000001',
        'Long ?',
        '[{"id":"a","text":"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"},{"id":"b","text":"court"},{"id":"c","text":"bref"}]'::jsonb,
        'a', 4);

-- E5 — (d) contenu riche (URL).
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES ('e3000000-0000-0000-0000-000000000005', 'e2000000-0000-0000-0000-000000000001',
        'Site ?',
        '[{"id":"a","text":"http://x.test"},{"id":"b","text":"un"},{"id":"c","text":"deux"}]'::jsonb,
        'a', 5);

-- E6 — (e) symbole mathématique de structure.
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES ('e3000000-0000-0000-0000-000000000006', 'e2000000-0000-0000-0000-000000000001',
        'Solution ?',
        '[{"id":"a","text":"x = 5"},{"id":"b","text":"six"},{"id":"c","text":"sept"}]'::jsonb,
        'a', 6);

-- E7 — (f) marqueur composite (slash).
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES ('e3000000-0000-0000-0000-000000000007', 'e2000000-0000-0000-0000-000000000001',
        'Fraction ?',
        '[{"id":"a","text":"3/4"},{"id":"b","text":"deux"},{"id":"c","text":"trois"}]'::jsonb,
        'a', 7);

-- E8 — (g) énoncé dépendant des options.
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES ('e3000000-0000-0000-0000-000000000008', 'e2000000-0000-0000-0000-000000000001',
        'Laquelle de ces villes est la capitale ?',
        '[{"id":"a","text":"Paris"},{"id":"b","text":"Lyon"},{"id":"c","text":"Nice"}]'::jsonb,
        'a', 8);

-- E9 — (h) collision : la bonne réponse normalisée égale un distracteur normalisé.
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES ('e3000000-0000-0000-0000-000000000009', 'e2000000-0000-0000-0000-000000000001',
        'Combien ?',
        '[{"id":"a","text":"Deux"},{"id":"b","text":"deux"},{"id":"c","text":"trois"}]'::jsonb,
        'a', 9);

-- E10 — (i) réponse qui se normalise en vide (charset hors clavier).
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES ('e3000000-0000-0000-0000-00000000000a', 'e2000000-0000-0000-0000-000000000001',
        'Constante ?',
        '[{"id":"a","text":"π"},{"id":"b","text":"un"},{"id":"c","text":"deux"}]'::jsonb,
        'a', 10);

-- E11 — non-mcq (numeric) : jamais éligible.
INSERT INTO public.questions (id, exercise_id, prompt, options, question_type, answer_key, display_order)
VALUES ('e3000000-0000-0000-0000-00000000000b', 'e2000000-0000-0000-0000-000000000001',
        'Combien font 6×7 ?', '[]'::jsonb, 'numeric', '{"value": 42}'::jsonb, 11);

-- E12 — éligible en arabe.
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES ('e3000000-0000-0000-0000-00000000000c', 'e2000000-0000-0000-0000-000000000001',
        'عاصمة فرنسا؟',
        '[{"id":"a","text":"باريس"},{"id":"b","text":"لندن"},{"id":"c","text":"روما"}]'::jsonb,
        'a', 12);

-- =========================================================
-- 2. Éligibilité (R-2 a–i).
-- =========================================================
SELECT is(public.is_question_recall_eligible(
  (SELECT q FROM public.questions q WHERE q.id = 'e3000000-0000-0000-0000-000000000001')),
  true, 'E1: QCM à réponse courte auto-suffisant est éligible');
SELECT is(public.is_question_recall_eligible(
  (SELECT q FROM public.questions q WHERE q.id = 'e3000000-0000-0000-0000-000000000002')),
  false, 'E2 (b): moins de 3 options → inéligible');
SELECT is(public.is_question_recall_eligible(
  (SELECT q FROM public.questions q WHERE q.id = 'e3000000-0000-0000-0000-000000000003')),
  false, 'E3 (c): réponse de plus de 6 mots → inéligible');
SELECT is(public.is_question_recall_eligible(
  (SELECT q FROM public.questions q WHERE q.id = 'e3000000-0000-0000-0000-000000000004')),
  false, 'E4 (c): réponse de plus de 60 caractères → inéligible');
SELECT is(public.is_question_recall_eligible(
  (SELECT q FROM public.questions q WHERE q.id = 'e3000000-0000-0000-0000-000000000005')),
  false, 'E5 (d): contenu riche (URL) → inéligible');
SELECT is(public.is_question_recall_eligible(
  (SELECT q FROM public.questions q WHERE q.id = 'e3000000-0000-0000-0000-000000000006')),
  false, 'E6 (e): symbole mathématique de structure → inéligible');
SELECT is(public.is_question_recall_eligible(
  (SELECT q FROM public.questions q WHERE q.id = 'e3000000-0000-0000-0000-000000000007')),
  false, 'E7 (f): marqueur composite (slash) → inéligible');
SELECT is(public.is_question_recall_eligible(
  (SELECT q FROM public.questions q WHERE q.id = 'e3000000-0000-0000-0000-000000000008')),
  false, 'E8 (g): énoncé dépendant des options → inéligible');
SELECT is(public.is_question_recall_eligible(
  (SELECT q FROM public.questions q WHERE q.id = 'e3000000-0000-0000-0000-000000000009')),
  false, 'E9 (h): collision réponse/distracteur normalisés → inéligible');
SELECT is(public.is_question_recall_eligible(
  (SELECT q FROM public.questions q WHERE q.id = 'e3000000-0000-0000-0000-00000000000a')),
  false, 'E10 (i): réponse au charset hors clavier → inéligible');
SELECT is(public.is_question_recall_eligible(
  (SELECT q FROM public.questions q WHERE q.id = 'e3000000-0000-0000-0000-00000000000b')),
  false, 'E11 (a): une question non-mcq (numeric) → inéligible');
SELECT is(public.is_question_recall_eligible(
  (SELECT q FROM public.questions q WHERE q.id = 'e3000000-0000-0000-0000-00000000000c')),
  true, 'E12: QCM arabe à réponse courte est éligible');

-- =========================================================
-- 3. Scoring Rappel (R-4) — comparaison normalisée stricte, tout-ou-rien.
-- =========================================================
SELECT is(public.score_recall_answer(
  (SELECT q FROM public.questions q WHERE q.id = 'e3000000-0000-0000-0000-000000000001'), 'Paris'),
  true, 'scorer: la bonne réponse exacte score vrai');
SELECT is(public.score_recall_answer(
  (SELECT q FROM public.questions q WHERE q.id = 'e3000000-0000-0000-0000-000000000001'), '  paris '),
  true, 'scorer: casse et espaces sont normalisés');
SELECT is(public.score_recall_answer(
  (SELECT q FROM public.questions q WHERE q.id = 'e3000000-0000-0000-0000-000000000001'), 'Lyon'),
  false, 'scorer: une mauvaise réponse score faux');
SELECT is(public.score_recall_answer(
  (SELECT q FROM public.questions q WHERE q.id = 'e3000000-0000-0000-0000-000000000001'), ''),
  false, 'scorer: une réponse vide score faux');
SELECT is(public.score_recall_answer(
  (SELECT q FROM public.questions q WHERE q.id = 'e3000000-0000-0000-0000-000000000001'), NULL),
  false, 'scorer: une réponse NULL score faux');

-- =========================================================
-- 4. R-1 — aucune des trois fonctions n'est exécutable par un client.
-- =========================================================
SELECT is(
  has_function_privilege('anon', 'public.normalize_recall_text(text)', 'EXECUTE')
    OR has_function_privilege('authenticated', 'public.normalize_recall_text(text)', 'EXECUTE'),
  false, 'R-1: normalize_recall_text n''est pas exécutable par le client');
SELECT is(
  has_function_privilege('anon', 'public.is_question_recall_eligible(public.questions)', 'EXECUTE')
    OR has_function_privilege('authenticated', 'public.is_question_recall_eligible(public.questions)', 'EXECUTE'),
  false, 'R-1: is_question_recall_eligible n''est pas exécutable par le client');
SELECT is(
  has_function_privilege('anon', 'public.score_recall_answer(public.questions, text)', 'EXECUTE')
    OR has_function_privilege('authenticated', 'public.score_recall_answer(public.questions, text)', 'EXECUTE'),
  false, 'R-1: score_recall_answer n''est pas exécutable par le client (pas d''oracle)');

SELECT * FROM finish();
ROLLBACK;
