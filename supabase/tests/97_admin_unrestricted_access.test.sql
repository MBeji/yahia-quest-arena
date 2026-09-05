-- =========================================================
-- Compte admin = compte de TEST : aucune porte de progression (2026-09-05).
-- ---------------------------------------------------------
-- start_exercise_session (SECURITY DEFINER, la seule façon d'ouvrir une quête)
-- pose trois portes de PROGRESSION : l'accès au parcours, le quiz de
-- compréhension du chapitre, le Rappel après un classique à 100 %. Le rôle
-- `admin` (public.is_admin()) les franchit toutes — pour tester le contenu en
-- humain, dans n'importe quel ordre, sans les quiz — et garde les règles de
-- CONTENU (INVALID_VARIANT, RECALL_NOT_ELIGIBLE), qui ne sont pas des portes.
--
-- Décor : une matière SCOLAIRE (9ème → parcours concours-9eme, ré-armé premium
-- comme dans 08) ; un chapitre avec un quiz, une mission ⭐ à trois questions
-- éligibles au Rappel et une mission ⭐⭐⭐ ; un élève TÉMOIN et un admin.
-- Le témoin n'est pas décoratif : une exemption écrite trop large — qui
-- ouvrirait les portes à tout le monde — rendrait les assertions de l'admin
-- vertes sans lui. Les siennes prouvent que les portes n'ont pas bougé.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(10);

-- ---------------------------------------------------------
-- Fixtures (préfixe `ad…`, réservé à cette suite).
-- ---------------------------------------------------------
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id)
VALUES ('adm-subj', 'Admin Access Subject', 'Esprit', 'subject-math', 'Brain', 'ecole-tn',
        (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '9eme-base'));

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('ad100000-0000-0000-0000-000000000001', 'adm-subj', 'Admin Access Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward, difficulty, mode, source)
VALUES
  ('ad200000-0000-0000-0000-000000000001', 'ad100000-0000-0000-0000-000000000001', 'adm-subj', 'AA quiz', 50, 2, 'quiz',     'admin'),
  ('ad200000-0000-0000-0000-000000000002', 'ad100000-0000-0000-0000-000000000001', 'adm-subj', 'AA d1',   50, 1, 'practice', 'admin'),
  ('ad200000-0000-0000-0000-000000000003', 'ad100000-0000-0000-0000-000000000001', 'adm-subj', 'AA d3',   50, 3, 'practice', 'admin');

-- Trois QCM à réponse courte sur la mission ⭐ : éligibles au Rappel (>= 3), donc
-- la variante EXISTE pour elle — seule la porte « classique à 100 % » la ferme.
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES
  ('ad300000-0000-0000-0000-000000000001', 'ad200000-0000-0000-0000-000000000002', 'Capitale de la France ?',
   '[{"id":"a","text":"Paris"},{"id":"b","text":"Berlin"},{"id":"c","text":"Rome"}]'::jsonb, 'a', 1),
  ('ad300000-0000-0000-0000-000000000002', 'ad200000-0000-0000-0000-000000000002', 'Capitale de l Italie ?',
   '[{"id":"a","text":"Rome"},{"id":"b","text":"Madrid"},{"id":"c","text":"Lisbonne"}]'::jsonb, 'a', 2),
  ('ad300000-0000-0000-0000-000000000003', 'ad200000-0000-0000-0000-000000000002', 'Capitale de l Espagne ?',
   '[{"id":"a","text":"Madrid"},{"id":"b","text":"Paris"},{"id":"c","text":"Athenes"}]'::jsonb, 'a', 3);

INSERT INTO auth.users (id, email) VALUES
  ('ad400000-0000-0000-0000-000000000001', 'aa-admin@test.local'),
  ('ad400000-0000-0000-0000-000000000002', 'aa-student@test.local');

-- Profils (handle_new_user peut déjà les avoir créés — défensif). Le rôle admin
-- est posé en superuser, AVANT tout JWT : le trigger anti-escalade laisse passer.
INSERT INTO public.profiles (id, display_name) VALUES
  ('ad400000-0000-0000-0000-000000000001', 'AA Admin'),
  ('ad400000-0000-0000-0000-000000000002', 'AA Student')
ON CONFLICT (id) DO NOTHING;
UPDATE public.profiles SET role = 'admin' WHERE id = 'ad400000-0000-0000-0000-000000000001';

-- Phase gratuite : tout parcours est is_premium=false. On ré-arme celui du décor
-- (défait par le ROLLBACK final) pour que la porte 1 ait quelque chose à refuser.
UPDATE public.parcours SET is_premium = true WHERE id = 'concours-9eme';

-- ---------------------------------------------------------
-- LE TÉMOIN : un élève ordinaire reste devant chacune des trois portes.
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"ad400000-0000-0000-0000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$ SELECT * FROM public.start_exercise_session('ad200000-0000-0000-0000-000000000002') $$,
  'P0001', 'QUIZ_LOCKED',
  'témoin : sans quiz passé, la mission ⭐ reste fermée à un compte ordinaire'
);

-- Quiz passé (>= 80 %, non précipité) : la porte 2 s'ouvre pour lui — mais pas les deux autres.
RESET ROLE;
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned)
VALUES
  ('ad400000-0000-0000-0000-000000000002', 'ad200000-0000-0000-0000-000000000001', 'adm-subj', 5, 5, 90, 120, 40);

SET LOCAL "request.jwt.claims" = '{"sub":"ad400000-0000-0000-0000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$ SELECT * FROM public.start_exercise_session('ad200000-0000-0000-0000-000000000003') $$,
  'P0001', 'PARCOURS_LOCKED',
  'témoin : la mission ⭐⭐⭐ du parcours premium reste derrière le droit d accès'
);

SELECT throws_ok(
  $$ SELECT * FROM public.start_exercise_session('ad200000-0000-0000-0000-000000000002', 'recall') $$,
  'P0001', 'RECALL_LOCKED',
  'témoin : sans classique à 100 %, le Rappel reste fermé'
);

-- ---------------------------------------------------------
-- L'ADMIN : aucune tentative, aucun droit d'accès — et tout s'ouvre.
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"ad400000-0000-0000-0000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT ok(public.is_admin(), 'décor : le compte de test est reconnu par is_admin() sous le rôle authenticated');

SELECT isnt(
  (SELECT s.session_id FROM public.start_exercise_session('ad200000-0000-0000-0000-000000000002') s),
  NULL,
  'admin : la mission ⭐ s ouvre sans avoir passé le quiz du chapitre'
);

SELECT isnt(
  (SELECT s.session_id FROM public.start_exercise_session('ad200000-0000-0000-0000-000000000003') s),
  NULL,
  'admin : la mission ⭐⭐⭐ du parcours premium s ouvre sans droit d accès'
);

SELECT isnt(
  (SELECT s.session_id FROM public.start_exercise_session('ad200000-0000-0000-0000-000000000002', 'recall') s),
  NULL,
  'admin : le Rappel s ouvre sans classique à 100 %'
);

SELECT is(
  (SELECT count(*)::int FROM public.exercise_sessions
    WHERE user_id = 'ad400000-0000-0000-0000-000000000001' AND variant = 'recall'),
  1,
  'admin : la session Rappel est persistée avec sa variante — c est une vraie session, pas un contournement'
);

-- Les règles de CONTENU tiennent : ce ne sont pas des portes de progression.
SELECT throws_ok(
  $$ SELECT * FROM public.start_exercise_session('ad200000-0000-0000-0000-000000000001', 'recall') $$,
  'P0001', 'RECALL_NOT_ELIGIBLE',
  'admin : le Rappel d un quiz reste refusé — le lecteur n aurait rien à jouer'
);

SELECT throws_ok(
  $$ SELECT * FROM public.start_exercise_session('ad200000-0000-0000-0000-000000000002', 'boss') $$,
  'P0001', 'INVALID_VARIANT',
  'admin : une variante inconnue reste refusée'
);

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
