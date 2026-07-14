-- =========================================================
-- Étude 17 — Rappel actif · lot 2 (FableEtudes/17-rappel-actif#lot-2).
-- RPCs variant-aware : garanties end-to-end du mode « Rappel ».
-- ---------------------------------------------------------
--   * get_recall_questions : questions jouables, éligibles seulement, ordonnées,
--     JAMAIS d'options/clé (R-1) ;
--   * get_recall_availability : compteur éligible + déblocage (R-3) + meilleur Rappel ;
--   * start_exercise_session : porte R-3 (INVALID_VARIANT / RECALL_NOT_ELIGIBLE
--     quiz|non-admin|<3 éligibles / RECALL_LOCKED) APRÈS les portes existantes,
--     puis déblocage après un 100 % classique non précipité ;
--   * submit_exercise_attempt : scoring Rappel en saisie libre normalisée, XP ×1,5
--     (R-5), anti-farm scopé par variante (R-6), misconception typée par texte (R-7),
--     retour variant + perQuestion (D-4) ;
--   * get_attempt_review : en Rappel, la correction révèle le TEXTE de la bonne option ;
--   * get_best_scores_by_exercise : n'expose que le meilleur score CLASSIQUE (R-6) ;
--   * non-régression classique : la variante par défaut 'classic' laisse tout inchangé.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(26);

-- ---------------------------------------------------------
-- Fixtures. Sujet SANS grade (thème sans note d'école) -> la porte quiz ne
-- s'applique pas et resolve_exercise_access retourne "unmapped -> allowed",
-- ce qui isole la porte R-3 que l'on teste.
-- ---------------------------------------------------------
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('rcl-subj', 'Recall Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('c1000000-0000-0000-0000-0000000000c1', 'rcl-subj', 'Recall Chapter');

-- E1 : exercice admin d'entraînement, 3 questions ÉLIGIBLES (réponses courtes,
-- un mot, typables). xp 100, coins 20.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward, reward_coins, source, mode)
VALUES ('e1000000-0000-0000-0000-0000000000e1',
        'c1000000-0000-0000-0000-0000000000c1', 'rcl-subj',
        'Capitales', 100, 20, 'admin', 'practice');

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, distractor_tags, explanation, display_order)
VALUES ('a1000000-0000-0000-0000-000000000001',
        'e1000000-0000-0000-0000-0000000000e1',
        'Capitale de la France ?',
        '[{"id":"a","text":"Paris"},{"id":"b","text":"Berlin"},{"id":"c","text":"Rome"}]'::jsonb,
        'a', '{"b":"geo.france.berlin"}'::jsonb, 'Paris.', 1);

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order)
VALUES ('a1000000-0000-0000-0000-000000000002',
        'e1000000-0000-0000-0000-0000000000e1',
        'Capitale de l Italie ?',
        '[{"id":"a","text":"Rome"},{"id":"b","text":"Madrid"},{"id":"c","text":"Lisbonne"}]'::jsonb,
        'a', 'Rome.', 2);

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order)
VALUES ('a1000000-0000-0000-0000-000000000003',
        'e1000000-0000-0000-0000-0000000000e1',
        'Capitale de l Espagne ?',
        '[{"id":"a","text":"Madrid"},{"id":"b","text":"Paris"},{"id":"c","text":"Athenes"}]'::jsonb,
        'a', 'Madrid.', 3);

-- E2 : exercice QUIZ admin (recall interdit sur un quiz — R-3).
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode)
VALUES ('e2000000-0000-0000-0000-0000000000e2',
        'c1000000-0000-0000-0000-0000000000c1', 'rcl-subj', 'Quiz', 'admin', 'quiz');
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES ('a2000000-0000-0000-0000-000000000001',
        'e2000000-0000-0000-0000-0000000000e2', 'Capitale du Portugal ?',
        '[{"id":"a","text":"Lisbonne"},{"id":"b","text":"Porto"},{"id":"c","text":"Faro"}]'::jsonb,
        'a', 1);

-- E3 : admin practice mais SEULEMENT 2 questions éligibles (< 3 -> recall interdit).
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode)
VALUES ('e3000000-0000-0000-0000-0000000000e3',
        'c1000000-0000-0000-0000-0000000000c1', 'rcl-subj', 'Trop peu', 'admin', 'practice');
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES ('a3000000-0000-0000-0000-000000000001',
        'e3000000-0000-0000-0000-0000000000e3', 'Capitale du Maroc ?',
        '[{"id":"a","text":"Rabat"},{"id":"b","text":"Fes"},{"id":"c","text":"Tanger"}]'::jsonb, 'a', 1),
       ('a3000000-0000-0000-0000-000000000002',
        'e3000000-0000-0000-0000-0000000000e3', 'Capitale de la Tunisie ?',
        '[{"id":"a","text":"Tunis"},{"id":"b","text":"Sfax"},{"id":"c","text":"Sousse"}]'::jsonb, 'a', 2);

-- E4 : contenu PARENT (non-admin) avec 3 questions éligibles -> seul le source disqualifie.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode)
VALUES ('e4000000-0000-0000-0000-0000000000e4',
        'c1000000-0000-0000-0000-0000000000c1', 'rcl-subj', 'Parent', 'parent', 'practice');
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES ('a4000000-0000-0000-0000-000000000001',
        'e4000000-0000-0000-0000-0000000000e4', 'Capitale de l Egypte ?',
        '[{"id":"a","text":"Le Caire"},{"id":"b","text":"Alexandrie"},{"id":"c","text":"Gizeh"}]'::jsonb, 'a', 1),
       ('a4000000-0000-0000-0000-000000000002',
        'e4000000-0000-0000-0000-0000000000e4', 'Capitale du Japon ?',
        '[{"id":"a","text":"Tokyo"},{"id":"b","text":"Osaka"},{"id":"c","text":"Kyoto"}]'::jsonb, 'a', 2),
       ('a4000000-0000-0000-0000-000000000003',
        'e4000000-0000-0000-0000-0000000000e4', 'Capitale de la Grece ?',
        '[{"id":"a","text":"Athenes"},{"id":"b","text":"Sparte"},{"id":"c","text":"Corinthe"}]'::jsonb, 'a', 3);

-- E5 : sert au test de scoping par variante de get_best_scores_by_exercise.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode)
VALUES ('e5000000-0000-0000-0000-0000000000e5',
        'c1000000-0000-0000-0000-0000000000c1', 'rcl-subj', 'Scoping', 'admin', 'practice');

INSERT INTO auth.users (id, email)
VALUES ('f1111111-1111-1111-1111-111111111111', 'recall@test.local');

-- =========================================================
-- 1–2. get_recall_questions : les 3 éligibles, ordonnées, sans jamais d'options.
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"f1111111-1111-1111-1111-111111111111","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.get_recall_questions('e1000000-0000-0000-0000-0000000000e1')),
  3,
  'get_recall_questions: renvoie les 3 questions éligibles de l''exercice admin'
);

SELECT is(
  (SELECT prompt FROM public.get_recall_questions('e1000000-0000-0000-0000-0000000000e1')
    ORDER BY display_order LIMIT 1),
  'Capitale de la France ?',
  'get_recall_questions: triées par display_order'
);

-- =========================================================
-- 3–5. get_recall_availability AVANT tout classique 100 % : verrouillé, best NULL.
-- =========================================================
SELECT is(
  (SELECT eligible_count FROM public.get_recall_availability('rcl-subj')
    WHERE exercise_id = 'e1000000-0000-0000-0000-0000000000e1'),
  3,
  'get_recall_availability: 3 questions éligibles pour E1'
);

SELECT is(
  (SELECT unlocked FROM public.get_recall_availability('rcl-subj')
    WHERE exercise_id = 'e1000000-0000-0000-0000-0000000000e1'),
  false,
  'get_recall_availability: E1 verrouillé tant que le classique n''est pas maîtrisé (R-3)'
);

SELECT is(
  (SELECT best_recall_pct FROM public.get_recall_availability('rcl-subj')
    WHERE exercise_id = 'e1000000-0000-0000-0000-0000000000e1'),
  NULL::numeric,
  'get_recall_availability: aucun meilleur score Rappel avant la première session'
);

-- =========================================================
-- 6–10. start_exercise_session : porte R-3 (variante fermée + éligibilité + verrou).
-- =========================================================
SELECT throws_ok(
  $$ SELECT public.start_exercise_session('e1000000-0000-0000-0000-0000000000e1', 'bogus') $$,
  'P0001', 'INVALID_VARIANT',
  'start_exercise_session: une variante hors liste est rejetée (INVALID_VARIANT)'
);

SELECT throws_ok(
  $$ SELECT public.start_exercise_session('e1000000-0000-0000-0000-0000000000e1', 'recall') $$,
  'P0001', 'RECALL_LOCKED',
  'start_exercise_session: Rappel verrouillé sans un classique 100 % non précipité (R-3)'
);

SELECT throws_ok(
  $$ SELECT public.start_exercise_session('e2000000-0000-0000-0000-0000000000e2', 'recall') $$,
  'P0001', 'RECALL_NOT_ELIGIBLE',
  'start_exercise_session: Rappel interdit sur un exercice quiz (R-3)'
);

SELECT throws_ok(
  $$ SELECT public.start_exercise_session('e3000000-0000-0000-0000-0000000000e3', 'recall') $$,
  'P0001', 'RECALL_NOT_ELIGIBLE',
  'start_exercise_session: Rappel interdit avec moins de 3 questions éligibles (R-3)'
);

SELECT throws_ok(
  $$ SELECT public.start_exercise_session('e4000000-0000-0000-0000-0000000000e4', 'recall') $$,
  'P0001', 'RECALL_NOT_ELIGIBLE',
  'start_exercise_session: Rappel interdit sur un contenu non-admin (R-3)'
);

RESET ROLE;

-- ---------------------------------------------------------
-- Créer le classique 100 % NON précipité qui débloque le Rappel (R-3). Session
-- insérée avec started_at dans le passé pour contrôler la durée (>= 3*4 = 12 s).
-- ---------------------------------------------------------
INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at, variant)
VALUES ('50000000-0000-0000-0000-0000000000c1',
        'f1111111-1111-1111-1111-111111111111',
        'e1000000-0000-0000-0000-0000000000e1',
        clock_timestamp() - INTERVAL '120 seconds', 'classic');

SET LOCAL "request.jwt.claims" = '{"sub":"f1111111-1111-1111-1111-111111111111","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT set_config('test.classic',
  public.submit_exercise_attempt(
    '50000000-0000-0000-0000-0000000000c1',
    'e1000000-0000-0000-0000-0000000000e1',
    '[{"questionId":"a1000000-0000-0000-0000-000000000001","choice":"a"},
      {"questionId":"a1000000-0000-0000-0000-000000000002","choice":"a"},
      {"questionId":"a1000000-0000-0000-0000-000000000003","choice":"a"}]'::jsonb
  )::text, true);

-- =========================================================
-- 11–12. Après le classique 100 % : E1 déverrouillé, start recall réussit.
-- =========================================================
SELECT is(
  (SELECT unlocked FROM public.get_recall_availability('rcl-subj')
    WHERE exercise_id = 'e1000000-0000-0000-0000-0000000000e1'),
  true,
  'get_recall_availability: E1 déverrouillé après un classique 100 % non précipité (R-3)'
);

SELECT isnt(
  (SELECT session_id FROM public.start_exercise_session('e1000000-0000-0000-0000-0000000000e1', 'recall')),
  NULL,
  'start_exercise_session: le Rappel démarre une fois débloqué'
);

RESET ROLE;

-- ---------------------------------------------------------
-- Session Rappel A : saisie libre normalisée (casse/espaces), 3/3.
-- ---------------------------------------------------------
INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at, variant)
VALUES ('50000000-0000-0000-0000-0000000000a1',
        'f1111111-1111-1111-1111-111111111111',
        'e1000000-0000-0000-0000-0000000000e1',
        clock_timestamp() - INTERVAL '120 seconds', 'recall');

SET LOCAL "request.jwt.claims" = '{"sub":"f1111111-1111-1111-1111-111111111111","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT set_config('test.recallA',
  public.submit_exercise_attempt(
    '50000000-0000-0000-0000-0000000000a1',
    'e1000000-0000-0000-0000-0000000000e1',
    '[{"questionId":"a1000000-0000-0000-0000-000000000001","choice":"Paris"},
      {"questionId":"a1000000-0000-0000-0000-000000000002","choice":"rome"},
      {"questionId":"a1000000-0000-0000-0000-000000000003","choice":"  madrid "}]'::jsonb
  )::text, true);

-- =========================================================
-- 13–17. Scoring Rappel + R-5 (XP ×1,5) + R-6 (anti-farm scopé) + perQuestion (D-4).
-- =========================================================
SELECT is(
  (current_setting('test.recallA')::jsonb ->> 'correct')::int, 3,
  'submit(recall): 3/3 en saisie libre (normalisation casse + espaces)'
);

SELECT is(
  (current_setting('test.recallA')::jsonb ->> 'total')::int, 3,
  'submit(recall): total = nombre de questions ÉLIGIBLES'
);

SELECT is(
  current_setting('test.recallA')::jsonb ->> 'variant', 'recall',
  'submit(recall): la réponse porte la variante lue depuis la session (D-1)'
);

-- R-5 (×1,5) ET R-6 : un classique 100 % existe déjà ; si l'anti-farm n'était pas
-- scopé par variante, v_prev_best serait 100 et 100 n'améliore pas -> 0 XP.
-- xpEarned = ROUND(100 * 1.0 * 1.5) = 150 prouve les DEUX.
SELECT is(
  (current_setting('test.recallA')::jsonb ->> 'xpEarned')::int, 150,
  'submit(recall): XP = base ×1,5 (R-5) et anti-farm scopé par variante (R-6)'
);

SELECT is(
  jsonb_array_length(current_setting('test.recallA')::jsonb -> 'perQuestion'), 3,
  'submit(recall): perQuestion renvoie un verdict par question éligible (D-4)'
);

-- =========================================================
-- 18. get_recall_availability après le Rappel : meilleur score Rappel = 100.
-- =========================================================
SELECT is(
  (SELECT best_recall_pct FROM public.get_recall_availability('rcl-subj')
    WHERE exercise_id = 'e1000000-0000-0000-0000-0000000000e1'),
  100::numeric,
  'get_recall_availability: best_recall_pct reflète le meilleur score Rappel'
);

-- =========================================================
-- 19–21. get_attempt_review (Rappel) : révèle le TEXTE de la bonne option, éligibles seuls.
-- =========================================================
SELECT is(
  (SELECT r.correct_option FROM public.get_attempt_review('50000000-0000-0000-0000-0000000000a1') r
    WHERE r.question_id = 'a1000000-0000-0000-0000-000000000001'),
  'Paris',
  'get_attempt_review(recall): la correction révèle le TEXTE de la bonne option (pas l''id)'
);

SELECT is(
  (SELECT r.is_correct FROM public.get_attempt_review(
     '50000000-0000-0000-0000-0000000000a1',
     '[{"questionId":"a1000000-0000-0000-0000-000000000001","choice":"paris"}]'::jsonb) r
    WHERE r.question_id = 'a1000000-0000-0000-0000-000000000001'),
  true,
  'get_attempt_review(recall): une saisie normalisée correcte est scorée vraie'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_attempt_review('50000000-0000-0000-0000-0000000000a1')),
  3,
  'get_attempt_review(recall): ne renvoie que les questions éligibles'
);

RESET ROLE;

-- ---------------------------------------------------------
-- Session Rappel B : une réponse tapée = le TEXTE d'un distracteur -> R-7.
-- ---------------------------------------------------------
INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at, variant)
VALUES ('50000000-0000-0000-0000-0000000000b1',
        'f1111111-1111-1111-1111-111111111111',
        'e1000000-0000-0000-0000-0000000000e1',
        clock_timestamp() - INTERVAL '120 seconds', 'recall');

SET LOCAL "request.jwt.claims" = '{"sub":"f1111111-1111-1111-1111-111111111111","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT set_config('test.recallB',
  public.submit_exercise_attempt(
    '50000000-0000-0000-0000-0000000000b1',
    'e1000000-0000-0000-0000-0000000000e1',
    '[{"questionId":"a1000000-0000-0000-0000-000000000001","choice":"Berlin"},
      {"questionId":"a1000000-0000-0000-0000-000000000002","choice":"rome"},
      {"questionId":"a1000000-0000-0000-0000-000000000003","choice":"madrid"}]'::jsonb
  )::text, true);

RESET ROLE;

-- =========================================================
-- 22–23. R-7 : la télémétrie résout le tag du distracteur par appariement de texte.
-- =========================================================
SELECT is(
  (SELECT qa.misconception_tag FROM public.question_attempts qa
    WHERE qa.session_id = '50000000-0000-0000-0000-0000000000b1'
      AND qa.question_id = 'a1000000-0000-0000-0000-000000000001'),
  'geo.france.berlin',
  'submit(recall): misconception_tag résolu depuis le distracteur tapé (R-7)'
);

SELECT is(
  (SELECT qa.is_correct FROM public.question_attempts qa
    WHERE qa.session_id = '50000000-0000-0000-0000-0000000000b1'
      AND qa.question_id = 'a1000000-0000-0000-0000-000000000001'),
  false,
  'submit(recall): une réponse = distracteur est fausse'
);

-- =========================================================
-- 24. Non-régression classique : get_attempt_review révèle l'ID (answer_key_display).
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"f1111111-1111-1111-1111-111111111111","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT r.correct_option FROM public.get_attempt_review('50000000-0000-0000-0000-0000000000c1') r
    WHERE r.question_id = 'a1000000-0000-0000-0000-000000000001'),
  'a',
  'get_attempt_review(classic): révèle l''id canonique (answer_key_display) — inchangé'
);

RESET ROLE;

-- =========================================================
-- 25–26. Scoping par variante : get_best_scores n'expose que le CLASSIQUE (R-6),
-- get_recall_availability n'expose que le Rappel. Attempts insérés directement.
-- =========================================================
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant)
VALUES
  ('f1111111-1111-1111-1111-111111111111', 'e5000000-0000-0000-0000-0000000000e5', 'rcl-subj', 7, 10, 70, 90, 0, 'classic'),
  ('f1111111-1111-1111-1111-111111111111', 'e5000000-0000-0000-0000-0000000000e5', 'rcl-subj', 9, 10, 90, 90, 0, 'recall');

SET LOCAL "request.jwt.claims" = '{"sub":"f1111111-1111-1111-1111-111111111111","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT best_score FROM public.get_best_scores_by_exercise('rcl-subj')
    WHERE exercise_id = 'e5000000-0000-0000-0000-0000000000e5'),
  70,
  'get_best_scores_by_exercise: n''expose que le meilleur score CLASSIQUE (R-6)'
);

SELECT is(
  (SELECT best_recall_pct FROM public.get_recall_availability('rcl-subj')
    WHERE exercise_id = 'e5000000-0000-0000-0000-0000000000e5'),
  90::numeric,
  'get_recall_availability: best_recall_pct n''expose que le meilleur score Rappel'
);

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
