-- =========================================================
-- UNE RÉPONSE CORRIGÉE EST DÉFINITIVE (20260929120000) — la triche au F5.
-- ---------------------------------------------------------
-- Le geste signalé par un parent : cocher au hasard, lire la bonne réponse que
-- le retour immédiat affiche, recharger la page, redonner la bonne réponse — et
-- la voir comptée juste. Ce fichier rejoue ce geste contre le vrai SQL, et
-- chacune de ses variantes :
--
--   1. la correction FIGE la réponse : une seconde demande reçoit le verdict de
--      la première, pas celui du nouveau choix ;
--   2. le rechargement REPREND la même partie au lieu d'en ouvrir une vierge ;
--   3. la note porte sur la réponse figée, quoi que le payload envoie — même en
--      écrivant l'identifiant de la question autrement ;
--   4. attendre que la reprise expire ne sert à rien : la partie neuve HÉRITE ;
--   5. une partie RENDUE remet l'héritage à zéro (le rejeu reste permis) ;
--   6. rien n'est figé là où rien n'est montré (quiz, Rappel, autre exercice) ;
--   7. les portes : propriétaire seul, session ouverte seule, aucune écriture
--      client, l'outil du barème hors de portée ;
--   8. le compte de test (rôle admin) n'est pas verrouillé : il rejoue à volonté.
--
-- Espace de noms des fixtures : préfixe `7e57a1…`, réservé à cette suite.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(30);

-- ---------------------------------------------------------
-- Décor : un thème isolé (aucun parcours → accès libre), une matière sans
-- classe (aucune porte de quiz), une mission de 4 questions (bonne réponse 'a')
-- et un quiz de compréhension d'une question.
-- ---------------------------------------------------------
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades, display_order)
VALUES ('reveal-theme', 'Reveal Test', 'Brain', 'subject-math', false, 999);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('reveal-subj', 'Reveal Subject', 'Esprit', 'subject-math', 'Brain', 'reveal-theme');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('7e57a101-0000-0000-0000-000000000001', 'reveal-subj', 'Reveal Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward, reward_coins, mode)
VALUES
  ('7e57a102-0000-0000-0000-000000000001', '7e57a101-0000-0000-0000-000000000001',
   'reveal-subj', 'Reveal Mission', 100, 20, 'practice'),
  ('7e57a102-0000-0000-0000-000000000002', '7e57a101-0000-0000-0000-000000000001',
   'reveal-subj', 'Reveal Quiz', 50, 10, 'quiz');

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order, explanation)
SELECT
  ('7e57a103-0000-0000-0000-00000000000' || g)::uuid,
  '7e57a102-0000-0000-0000-000000000001',
  'Q' || g,
  '[{"id":"a","text":"right"},{"id":"b","text":"wrong"},{"id":"c","text":"x"},{"id":"d","text":"y"}]'::jsonb,
  'a',
  g,
  'Parce que.'
FROM generate_series(1, 4) AS g;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES ('7e57a103-0000-0000-0000-000000000009', '7e57a102-0000-0000-0000-000000000002', 'QZ',
        '[{"id":"a","text":"right"},{"id":"b","text":"wrong"}]'::jsonb, 'a', 1);

INSERT INTO auth.users (id, email) VALUES
  ('7e57a104-0000-0000-0000-000000000001', 'reveal-a@test.local'),
  ('7e57a104-0000-0000-0000-000000000002', 'reveal-b@test.local'),
  ('7e57a104-0000-0000-0000-000000000003', 'reveal-admin@test.local');

-- Le compte de test : le rôle admin est posé en superuser, AVANT tout JWT (le
-- trigger anti-escalade laisse passer), comme dans le pgTAP 97.
INSERT INTO public.profiles (id, display_name)
VALUES ('7e57a104-0000-0000-0000-000000000003', 'Reveal Admin')
ON CONFLICT (id) DO NOTHING;
UPDATE public.profiles SET role = 'admin' WHERE id = '7e57a104-0000-0000-0000-000000000003';

-- =========================================================
-- ÉLÈVE A — le geste du parent, pas à pas.
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"7e57a104-0000-0000-0000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT set_config('test.s1', (
  SELECT s.session_id::text
    FROM public.start_exercise_session('7e57a102-0000-0000-0000-000000000001') s
), true);

-- Il coche au hasard : 'b'. La correction le lui dit, et montre 'a'.
SELECT results_eq(
  $$ SELECT choice, is_correct, correct_option, explanation
       FROM public.reveal_session_answer(current_setting('test.s1')::uuid,
                                         '7e57a103-0000-0000-0000-000000000001', 'b') $$,
  $$ VALUES ('b'::text, false, 'a'::text, 'Parce que.'::text) $$,
  '1. la correction rend le verdict de la réponse donnée, bonne réponse et explication comprises'
);

-- Il redemande avec 'a', qu'il vient de lire : le verdict reste celui de 'b'.
SELECT results_eq(
  $$ SELECT choice, is_correct
       FROM public.reveal_session_answer(current_setting('test.s1')::uuid,
                                         '7e57a103-0000-0000-0000-000000000001', 'a') $$,
  $$ VALUES ('b'::text, false) $$,
  '1. une seconde correction de la même question rend la réponse FIGÉE et son verdict, pas le nouveau choix'
);

SELECT results_eq(
  $$ SELECT choice FROM public.exercise_session_reveals
      WHERE session_id = current_setting('test.s1')::uuid $$,
  $$ VALUES ('b'::text) $$,
  '1. une seule ligne figée pour la question, sur la première réponse'
);

-- Il appuie sur F5 : le lecteur redemande une session.
SELECT is(
  (SELECT s.session_id::text
     FROM public.start_exercise_session('7e57a102-0000-0000-0000-000000000001') s),
  current_setting('test.s1'),
  '2. recharger la page REPREND la partie où une correction a été montrée'
);

SELECT is(
  (SELECT count(*)::int FROM public.exercise_sessions
    WHERE user_id = '7e57a104-0000-0000-0000-000000000001'
      AND exercise_id = '7e57a102-0000-0000-0000-000000000001'),
  1,
  '2. aucune partie vierge n''a été ouverte à côté'
);

-- Il redonne 'a' partout, la réponse lue comprise.
SELECT set_config('test.submit_a', (
  SELECT public.submit_exercise_attempt(
    current_setting('test.s1')::uuid,
    '7e57a102-0000-0000-0000-000000000001',
    '[{"questionId":"7e57a103-0000-0000-0000-000000000001","choice":"a"},
      {"questionId":"7e57a103-0000-0000-0000-000000000002","choice":"a"},
      {"questionId":"7e57a103-0000-0000-0000-000000000003","choice":"a"},
      {"questionId":"7e57a103-0000-0000-0000-000000000004","choice":"a"}]'::jsonb
  )::text
), true);

SELECT is(
  (current_setting('test.submit_a')::jsonb ->> 'correct')::int,
  3,
  '3. la note compte la question corrigée sur sa réponse figée (b), pas sur celle du payload (a)'
);

SELECT results_eq(
  $$ SELECT choice, is_correct FROM public.question_attempts
      WHERE session_id = current_setting('test.s1')::uuid
        AND question_id = '7e57a103-0000-0000-0000-000000000001' $$,
  $$ VALUES ('b'::text, false) $$,
  '3. la télémétrie par question voit la MÊME réponse que la note'
);

-- Partie rendue : la correction complète a été vue, le rejeu reste permis.
SELECT isnt(
  (SELECT s.session_id::text
     FROM public.start_exercise_session('7e57a102-0000-0000-0000-000000000001') s),
  current_setting('test.s1'),
  '5. après une partie rendue, rejouer ouvre une partie neuve'
);

SELECT is(
  (SELECT count(*)::int FROM public.exercise_session_reveals r
     JOIN public.exercise_sessions s ON s.id = r.session_id
    WHERE s.user_id = '7e57a104-0000-0000-0000-000000000001'
      AND s.completed_at IS NULL),
  0,
  '5. la partie neuve n''hérite de rien : une partie rendue remet l''héritage à zéro'
);

SELECT throws_ok(
  $$ SELECT * FROM public.reveal_session_answer(current_setting('test.s1')::uuid,
                                                '7e57a103-0000-0000-0000-000000000002', 'b') $$,
  'P0001', 'This quest session is already completed.',
  '7. une partie rendue ne se corrige plus'
);

-- ---------------------------------------------------------
-- 6. Rien n'est figé là où rien n'est montré.
-- ---------------------------------------------------------
SELECT set_config('test.s_open', (
  SELECT s.session_id::text
    FROM public.start_exercise_session('7e57a102-0000-0000-0000-000000000001') s
), true);

SELECT is(
  (SELECT count(*)::int FROM public.reveal_session_answer(
     current_setting('test.s_open')::uuid, '7e57a103-0000-0000-0000-000000000009', 'b')),
  0,
  '6. une question d''un AUTRE exercice ne se corrige pas dans cette partie'
);

SELECT set_config('test.s_quiz', (
  SELECT s.session_id::text
    FROM public.start_exercise_session('7e57a102-0000-0000-0000-000000000002') s
), true);

SELECT is(
  (SELECT count(*)::int FROM public.reveal_session_answer(
     current_setting('test.s_quiz')::uuid, '7e57a103-0000-0000-0000-000000000009', 'b')),
  0,
  '6. le quiz de compréhension ne rend aucun verdict en cours de partie'
);

SELECT is(
  (SELECT count(*)::int FROM public.exercise_session_reveals
    WHERE session_id IN (current_setting('test.s_open')::uuid, current_setting('test.s_quiz')::uuid)),
  0,
  '6. et rien n''est figé là où rien n''a été montré'
);

-- Une partie en Rappel (posée en superuser : sa porte a son propre pgTAP, le 29).
RESET ROLE;
INSERT INTO public.exercise_sessions (id, user_id, exercise_id, variant)
VALUES ('7e57a105-0000-0000-0000-000000000001', '7e57a104-0000-0000-0000-000000000001',
        '7e57a102-0000-0000-0000-000000000001', 'recall');
SET LOCAL "request.jwt.claims" = '{"sub":"7e57a104-0000-0000-0000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.reveal_session_answer(
     '7e57a105-0000-0000-0000-000000000001', '7e57a103-0000-0000-0000-000000000001', 'b')),
  0,
  '6. le Rappel ne rend aucun verdict immédiat, donc ne fige rien'
);

-- =========================================================
-- ÉLÈVE B — attendre que la reprise expire.
-- =========================================================
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"7e57a104-0000-0000-0000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT set_config('test.b1', (
  SELECT s.session_id::text
    FROM public.start_exercise_session('7e57a102-0000-0000-0000-000000000001') s
), true);

SELECT results_eq(
  $$ SELECT choice, is_correct
       FROM public.reveal_session_answer(current_setting('test.b1')::uuid,
                                         '7e57a103-0000-0000-0000-000000000002', 'c') $$,
  $$ VALUES ('c'::text, false) $$,
  '4. décor : B voit la correction de la question 2 sur une mauvaise réponse'
);

-- 7. Les portes, pendant que B a une partie ouverte.
SELECT throws_ok(
  $$ SELECT * FROM public.reveal_session_answer(current_setting('test.s_open')::uuid,
                                                '7e57a103-0000-0000-0000-000000000001', 'a') $$,
  'P0001', 'Invalid quest session.',
  '7. la partie d''un autre élève ne se corrige pas'
);

SELECT is(
  (SELECT count(*)::int FROM public.exercise_session_reveals),
  1,
  '7. RLS : un élève ne lit que ses propres réponses figées'
);

SELECT throws_ok(
  $$ INSERT INTO public.exercise_session_reveals (session_id, question_id, user_id, choice)
     VALUES (current_setting('test.b1')::uuid, '7e57a103-0000-0000-0000-000000000003',
             '7e57a104-0000-0000-0000-000000000002', 'a') $$,
  '42501', NULL,
  '7. aucune écriture client : figer passe par la seule RPC'
);

SELECT throws_ok(
  $$ SELECT public.apply_session_reveals(current_setting('test.b1')::uuid, '[]'::jsonb) $$,
  '42501', NULL,
  '7. l''outil du barème n''est pas exécutable par un client'
);

-- Trois heures passent (on vieillit la partie en superuser).
RESET ROLE;
UPDATE public.exercise_sessions
   SET started_at = clock_timestamp() - INTERVAL '3 hours'
 WHERE id = current_setting('test.b1')::uuid;
UPDATE public.exercise_session_reveals
   SET revealed_at = clock_timestamp() - INTERVAL '3 hours'
 WHERE session_id = current_setting('test.b1')::uuid;
SET LOCAL "request.jwt.claims" = '{"sub":"7e57a104-0000-0000-0000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT set_config('test.b2', (
  SELECT s.session_id::text
    FROM public.start_exercise_session('7e57a102-0000-0000-0000-000000000001') s
), true);

SELECT isnt(
  current_setting('test.b2'),
  current_setting('test.b1'),
  '4. au-delà de deux heures, la partie n''est plus reprise : une partie neuve s''ouvre'
);

SELECT results_eq(
  $$ SELECT question_id, choice FROM public.exercise_session_reveals
      WHERE session_id = current_setting('test.b2')::uuid $$,
  $$ VALUES ('7e57a103-0000-0000-0000-000000000002'::uuid, 'c'::text) $$,
  '4. … mais elle HÉRITE de la correction déjà vue'
);

SELECT results_eq(
  $$ SELECT choice, is_correct
       FROM public.reveal_session_answer(current_setting('test.b2')::uuid,
                                         '7e57a103-0000-0000-0000-000000000002', 'a') $$,
  $$ VALUES ('c'::text, false) $$,
  '4. la question héritée se corrige sur sa réponse figée'
);

-- Le payload écrit la question 2 en MAJUSCULES pour glisser 'a' à côté de 'c'.
SELECT set_config('test.submit_b', (
  SELECT public.submit_exercise_attempt(
    current_setting('test.b2')::uuid,
    '7e57a102-0000-0000-0000-000000000001',
    '[{"questionId":"7e57a103-0000-0000-0000-000000000001","choice":"a"},
      {"questionId":"7E57A103-0000-0000-0000-000000000002","choice":"a"},
      {"questionId":"7e57a103-0000-0000-0000-000000000003","choice":"a"},
      {"questionId":"7e57a103-0000-0000-0000-000000000004","choice":"a"}]'::jsonb
  )::text
), true);

SELECT is(
  (current_setting('test.submit_b')::jsonb ->> 'correct')::int,
  3,
  '3. écrire l''identifiant autrement ne fait pas passer une seconde réponse : la figée compte'
);

-- La partie rendue (b2) remet l'héritage à zéro — la partie abandonnée (b1) avec.
SELECT set_config('test.b3', (
  SELECT s.session_id::text
    FROM public.start_exercise_session('7e57a102-0000-0000-0000-000000000001') s
), true);

SELECT is(
  (SELECT count(*)::int FROM public.exercise_session_reveals
    WHERE session_id = current_setting('test.b3')::uuid),
  0,
  '5. après une partie rendue, même une partie abandonnée plus ancienne ne lègue plus rien'
);

-- Le payload OMET une question corrigée : elle est notée quand même, sur sa réponse figée.
SELECT results_eq(
  $$ SELECT choice, is_correct
       FROM public.reveal_session_answer(current_setting('test.b3')::uuid,
                                         '7e57a103-0000-0000-0000-000000000004', 'a') $$,
  $$ VALUES ('a'::text, true) $$,
  '1. décor : une bonne réponse, figée elle aussi'
);

SELECT is(
  (public.submit_exercise_attempt(
     current_setting('test.b3')::uuid,
     '7e57a102-0000-0000-0000-000000000001',
     '[{"questionId":"7e57a103-0000-0000-0000-000000000001","choice":"b"}]'::jsonb
   ) ->> 'correct')::int,
  1,
  '3. une question corrigée omise du payload reste notée sur sa réponse figée'
);

-- =========================================================
-- COMPTE DE TEST (admin) — rien n'est figé, il rejoue à volonté.
-- =========================================================
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"7e57a104-0000-0000-0000-000000000003","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT set_config('test.admin_s', (
  SELECT s.session_id::text
    FROM public.start_exercise_session('7e57a102-0000-0000-0000-000000000001') s
), true);

SELECT results_eq(
  $$ SELECT choice, is_correct
       FROM public.reveal_session_answer(current_setting('test.admin_s')::uuid,
                                         '7e57a103-0000-0000-0000-000000000001', 'b') $$,
  $$ VALUES ('b'::text, false) $$,
  '8. le compte de test voit le verdict de sa réponse'
);

SELECT results_eq(
  $$ SELECT choice, is_correct
       FROM public.reveal_session_answer(current_setting('test.admin_s')::uuid,
                                         '7e57a103-0000-0000-0000-000000000001', 'a') $$,
  $$ VALUES ('a'::text, true) $$,
  '8. … et peut se reprendre : la seconde réponse compte, aucune n''est figée'
);

SELECT is(
  (SELECT count(*)::int FROM public.exercise_session_reveals
    WHERE session_id = current_setting('test.admin_s')::uuid),
  0,
  '8. rien n''est enregistré pour le compte de test'
);

RESET ROLE;

SELECT ok(
  NOT has_function_privilege('anon', 'public.reveal_session_answer(uuid, uuid, text)', 'EXECUTE'),
  '7. la correction qui fige n''est pas exécutable sans compte'
);

SELECT * FROM finish();
ROLLBACK;
