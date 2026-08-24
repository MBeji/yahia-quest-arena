-- =========================================================
-- Étude 11 lot 5 — « Entraîne-moi sur ma faiblesse » (US-11, US-12, Q-8).
-- ---------------------------------------------------------
-- Quatre choses à prouver, et la troisième est celle qui coûte de l'argent :
--
--   1. La SÉLECTION vise juste : elle ne resert jamais la question sur laquelle
--      l'erreur vient d'être commise, elle ne sort pas des chapitres où
--      l'erreur a été commise, et elle respecte `resolve_exercise_access`.
--   2. Le REPLI élargit le SUJET, jamais le PÉRIMÈTRE : même chapitre,
--      difficulté voisine — et il ne compte jamais dans `fresh_count`.
--   3. La PORTE Q-8 s'ouvre des DEUX côtés du seuil. Un seuil testé d'un seul
--      côté ne prouve rien : une fonction qui rendrait toujours `true`
--      passerait la moitié des tests et ferait générer un quiz payant à chaque
--      clic. On teste donc 2 fraîches ⇒ vrai ET 3 fraîches ⇒ faux.
--   4. R-15 : sans session, la sélection rend VIDE au lieu de lever — elle
--      appelle `resolve_exercise_access`, qui fait `RAISE EXCEPTION` quand
--      `auth.uid()` est NULL.
--
-- ⚠️ Fixtures recopiées de `67_weaknesses.test.sql` et `35_daily_plan.test.sql`,
-- tous deux verts. Les CHECK réels, jamais devinés : `exercises.source` vaut
-- 'admin' ou 'parent' (pas 'authored' — c'est ce qui a coûté un tour de CI à
-- #817), `exercises.mode` ∈ ('practice','boss','quiz','challenge'),
-- `question_attempts.source` ∈ ('exercise','quiz','dungeon','exam').
--
-- Préfixe d'UUID `7ac70000-` : libre, vérifié contre les 71 fichiers voisins
-- (66 prend d7…, 67 prend e4…). Une collision ferait rougir `db:check-chain`.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(15);

-- ---------------------------------------------------------
-- Décor. Deux parcours : l'un libre, l'autre premium SANS aperçu — la porte
-- d'accès n'a rien à mordre en phase gratuite (tout est `is_premium = false`),
-- on lui fabrique donc de quoi refuser.
-- ---------------------------------------------------------
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('tp-theme', 'TP Theme', 'Brain', 'subject-math', true);

INSERT INTO public.grades (id, theme_id, slug, name_fr, cycle, display_order)
VALUES
  ('7ac70000-0000-4000-8000-0000000000f1'::uuid, 'tp-theme', 'tp-free', 'TP Libre',   'college', 971),
  ('7ac70000-0000-4000-8000-0000000000f2'::uuid, 'tp-theme', 'tp-prem', 'TP Premium', 'college', 972);

INSERT INTO public.parcours (id, name_fr, kind, theme_id, grade_id, is_premium, preview_policy, icon, color)
VALUES
  ('tp-par-free', 'TP Libre', 'concours', 'tp-theme',
   '7ac70000-0000-4000-8000-0000000000f1'::uuid, false, 'full', 'Brain', 'subject-math'),
  -- `none` : aucun aperçu, donc tout exercice de ce parcours est REFUSÉ.
  ('tp-par-prem', 'TP Premium', 'concours', 'tp-theme',
   '7ac70000-0000-4000-8000-0000000000f2'::uuid, true, 'none', 'Brain', 'subject-math');

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id)
VALUES
  ('tp-subj',      'TP Maths',   'Esprit', 'subject-math', 'Brain', 'tp-theme',
   '7ac70000-0000-4000-8000-0000000000f1'::uuid),
  ('tp-subj-prem', 'TP Premium', 'Esprit', 'subject-math', 'Brain', 'tp-theme',
   '7ac70000-0000-4000-8000-0000000000f2'::uuid);

-- C1 : le chapitre où l'erreur est commise (le périmètre de la sélection).
-- C3 : un chapitre voisin, taggé pareil, où l'élève ne s'est JAMAIS trompé.
-- CP : un chapitre premium, taggé pareil, verrouillé par la porte d'accès.
INSERT INTO public.chapters (id, subject_id, title)
VALUES
  ('7ac70000-0000-4000-8000-0000000000c1'::uuid, 'tp-subj',      'TP Chapitre ciblé'),
  ('7ac70000-0000-4000-8000-0000000000c3'::uuid, 'tp-subj',      'TP Chapitre voisin'),
  ('7ac70000-0000-4000-8000-0000000000c4'::uuid, 'tp-subj-prem', 'TP Chapitre premium');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, difficulty, display_order, source)
VALUES
  ('7ac70000-0000-4000-8000-0000000000e1'::uuid, '7ac70000-0000-4000-8000-0000000000c1'::uuid,
   'tp-subj', 'TP Ex 1', 'practice', 1, 1, 'admin'),
  ('7ac70000-0000-4000-8000-0000000000e2'::uuid, '7ac70000-0000-4000-8000-0000000000c1'::uuid,
   'tp-subj', 'TP Ex 2', 'practice', 1, 2, 'admin'),
  -- E3 ne porte AUCUNE question taggée : c'est le vivier du REPLI.
  ('7ac70000-0000-4000-8000-0000000000e3'::uuid, '7ac70000-0000-4000-8000-0000000000c1'::uuid,
   'tp-subj', 'TP Ex 3', 'practice', 1, 3, 'admin'),
  ('7ac70000-0000-4000-8000-0000000000e4'::uuid, '7ac70000-0000-4000-8000-0000000000c3'::uuid,
   'tp-subj', 'TP Ex voisin', 'practice', 1, 1, 'admin'),
  ('7ac70000-0000-4000-8000-0000000000e5'::uuid, '7ac70000-0000-4000-8000-0000000000c4'::uuid,
   'tp-subj-prem', 'TP Ex premium', 'practice', 1, 1, 'admin');

-- `distractor_tags` est une MAP {option_id: tag} — le tag se cherche dans les
-- VALEURS. Une fixture en TABLEAU rendrait le test vert sur une fonction
-- fausse (ou l'inverse) : c'est la forme réelle du corpus qui décide.
INSERT INTO public.questions
  (id, exercise_id, prompt, options, correct_option, explanation, display_order, distractor_tags)
VALUES
  -- Q1 : LA question d'origine — celle où l'erreur vient d'être commise.
  ('7ac70000-0000-4000-8000-0000000000a1'::uuid, '7ac70000-0000-4000-8000-0000000000e1'::uuid,
   'TP Q1', '[{"id":"a","text":"3/4"},{"id":"b","text":"3/12"}]'::jsonb, 'a', 'Explication Q1', 1,
   '{"b":"tp.tag"}'::jsonb),
  ('7ac70000-0000-4000-8000-0000000000a2'::uuid, '7ac70000-0000-4000-8000-0000000000e1'::uuid,
   'TP Q2', '[{"id":"a","text":"5/7"},{"id":"b","text":"5/14"}]'::jsonb, 'a', 'Explication Q2', 2,
   '{"b":"tp.tag"}'::jsonb),
  ('7ac70000-0000-4000-8000-0000000000a3'::uuid, '7ac70000-0000-4000-8000-0000000000e2'::uuid,
   'TP Q3', '[{"id":"a","text":"2/5"},{"id":"b","text":"2/10"}]'::jsonb, 'a', 'Explication Q3', 1,
   '{"b":"tp.tag"}'::jsonb),
  -- Q5 : PAS taggée, même chapitre, difficulté voisine ⇒ candidate au repli.
  ('7ac70000-0000-4000-8000-0000000000a5'::uuid, '7ac70000-0000-4000-8000-0000000000e3'::uuid,
   'TP Q5', '[{"id":"a","text":"1/3"},{"id":"b","text":"1/6"}]'::jsonb, 'a', 'Explication Q5', 1,
   NULL),
  -- QO : taggée, mais dans un chapitre où l'élève ne s'est jamais trompé.
  ('7ac70000-0000-4000-8000-0000000000a6'::uuid, '7ac70000-0000-4000-8000-0000000000e4'::uuid,
   'TP QO', '[{"id":"a","text":"4/9"},{"id":"b","text":"4/18"}]'::jsonb, 'a', 'Explication QO', 1,
   '{"b":"tp.tag"}'::jsonb),
  -- QP : taggée, dans le bon esprit, mais derrière un parcours verrouillé.
  ('7ac70000-0000-4000-8000-0000000000a7'::uuid, '7ac70000-0000-4000-8000-0000000000e5'::uuid,
   'TP QP', '[{"id":"a","text":"6/11"},{"id":"b","text":"6/22"}]'::jsonb, 'a', 'Explication QP', 1,
   '{"b":"tp.tag"}'::jsonb);

INSERT INTO auth.users (id, email)
VALUES ('7ac70000-0000-4000-8000-000000000001', 'tp-eleve@test.local');

-- L'erreur commise sur Q1, dans C1, il y a deux jours. Elle fait DEUX choses :
-- elle ouvre le périmètre (C1), et elle rend Q1 « vue récemment » — donc
-- inéligible. C'est la même ligne qui arme la sélection et qui exclut son
-- point de départ, et c'est voulu.
INSERT INTO public.question_attempts
  (user_id, question_id, chapter_id, session_id, choice, is_correct, source, misconception_tag, created_at)
VALUES
  ('7ac70000-0000-4000-8000-000000000001'::uuid,
   '7ac70000-0000-4000-8000-0000000000a1'::uuid,
   '7ac70000-0000-4000-8000-0000000000c1'::uuid,
   gen_random_uuid(), 'b', false, 'exercise', 'tp.tag', now() - INTERVAL '2 days');

SET LOCAL request.jwt.claims = '{"sub":"7ac70000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- =========================================================
-- 1. La sélection ciblée (US-11).
-- =========================================================
SELECT is(
  (SELECT DISTINCT t.fresh_count FROM public.get_targeted_exercises('tp.tag', NULL, 3) t),
  2,
  'US-11 ⭐ : deux questions fraîches sur l''erreur — Q2 et Q3. Ni Q1 (déjà vue), ni QO (hors périmètre), ni QP (verrouillée)'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_targeted_exercises('tp.tag', NULL, 3) t
    WHERE t.question_id = '7ac70000-0000-4000-8000-0000000000a1'::uuid),
  0,
  'US-11 ⭐ : la question d''ORIGINE ne revient jamais — la fenêtre de fraîcheur l''exclut par construction'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_targeted_exercises('tp.tag', NULL, 3) t
    WHERE t.chapter_id = '7ac70000-0000-4000-8000-0000000000c4'::uuid),
  0,
  'R-3 ⭐ : un exercice derrière un parcours verrouillé n''apparaît pas, même taggé juste — resolve_exercise_access est l''unique arbitre'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_targeted_exercises('tp.tag', NULL, 3) t
    WHERE t.chapter_id = '7ac70000-0000-4000-8000-0000000000c3'::uuid),
  0,
  'US-11 : le chapitre voisin, taggé pareil mais jamais raté, reste hors du périmètre — on ré-entraîne là où l''élève se trompe'
);

-- =========================================================
-- 2. Le repli : même chapitre, difficulté voisine.
-- =========================================================
SELECT is(
  (SELECT count(*)::int FROM public.get_targeted_exercises('tp.tag', NULL, 3) t WHERE t.is_fallback),
  1,
  'US-11 : deux fraîches pour trois demandées ⇒ le repli complète, et il est ANNONCÉ comme tel'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_targeted_exercises('tp.tag', NULL, 3) t
    WHERE t.chapter_id <> '7ac70000-0000-4000-8000-0000000000c1'::uuid),
  0,
  'US-11 ⭐ : le repli élargit le SUJET, jamais le PÉRIMÈTRE — tout sort du chapitre ciblé'
);

SELECT is(
  (SELECT t.question_id FROM public.get_targeted_exercises('tp.tag', NULL, 3) t WHERE t.is_fallback),
  '7ac70000-0000-4000-8000-0000000000a5'::uuid,
  'US-11 : le repli est bien la question NON taggée du même chapitre (Q5), à difficulté voisine'
);

SELECT is(
  (SELECT count(DISTINCT t.exercise_id)::int FROM public.get_targeted_exercises('tp.tag', NULL, 3) t),
  (SELECT count(*)::int FROM public.get_targeted_exercises('tp.tag', NULL, 3) t),
  'US-11 : une DESTINATION par ligne — sans le DISTINCT ON, un exercice à trois questions taggées enverrait trois fois au même endroit'
);

-- =========================================================
-- 3. Q-8 — la porte de la génération, des DEUX côtés du seuil.
-- =========================================================
SELECT ok(
  public.tutor_practice_needs_generation('tp.tag'),
  'Q-8 ⭐ : deux fraîches (< 3) ⇒ la génération est autorisée — c''est le seul cas où la Forge sert'
);

SELECT ok(
  public.tutor_practice_needs_generation('tp.tag-inconnu'),
  'Q-8 : zéro matière ouvre AUSSI la génération — « aucune question » est le cas le plus fort de « moins de trois », pas une exception à traiter à part'
);

-- La troisième question fraîche : elle fait basculer le seuil, et elle seule.
SET LOCAL ROLE postgres;
INSERT INTO public.questions
  (id, exercise_id, prompt, options, correct_option, explanation, display_order, distractor_tags)
VALUES
  ('7ac70000-0000-4000-8000-0000000000a4'::uuid, '7ac70000-0000-4000-8000-0000000000e2'::uuid,
   'TP Q4', '[{"id":"a","text":"7/8"},{"id":"b","text":"7/16"}]'::jsonb, 'a', 'Explication Q4', 2,
   '{"b":"tp.tag"}'::jsonb);
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT DISTINCT t.fresh_count FROM public.get_targeted_exercises('tp.tag', NULL, 3) t),
  3,
  'Q-8 : la troisième question fraîche est comptée'
);

SELECT ok(
  NOT public.tutor_practice_needs_generation('tp.tag'),
  'Q-8 ⭐ : trois fraîches ⇒ la génération est REFUSÉE. Le stock d''abord, toujours — un seuil testé d''un seul côté laisserait passer une fonction qui dit toujours oui'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_targeted_exercises('tp.tag', NULL, 3) t WHERE t.is_fallback),
  0,
  'US-11 : le stock suffit ⇒ plus aucun repli. Le repli n''est pas un complément permanent, c''est un bouche-trou'
);

-- =========================================================
-- 4. R-15 (pas d'exception) et les droits.
-- =========================================================
-- Sans session, `resolve_exercise_access` LÈVE. La sélection doit malgré tout
-- rendre un ÉTAT — ici, zéro ligne. Si la garde n'était qu'un prédicat du
-- WHERE, cette assertion tomberait en ERREUR au lieu d'échouer proprement.
RESET ROLE;
SET LOCAL "request.jwt.claims" = '';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.get_targeted_exercises('tp.tag', NULL, 3)),
  0,
  'R-15 ⭐ : sans session, la sélection rend VIDE — elle ne laisse pas remonter le RAISE de la porte d''accès'
);

RESET ROLE;
SET LOCAL ROLE anon;

SELECT ok(
  NOT has_function_privilege('anon', 'public.get_targeted_exercises(text,text,int)', 'EXECUTE')
  AND NOT has_function_privilege('anon', 'public.tutor_practice_needs_generation(text)', 'EXECUTE'),
  'Grants ⭐ : anon n''exécute NI la sélection NI la porte de génération — sinon un visiteur ferait forger des quiz payants'
);

SELECT * FROM finish();
ROLLBACK;
