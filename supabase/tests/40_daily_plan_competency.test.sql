-- =========================================================
-- Étude 07, lot 5 (US-3) — « Révision du jour » compétence-aware.
-- ---------------------------------------------------------
-- `get_daily_plan` ordonnait par retard SM-2, arbitré par les misconceptions du chapitre
-- (pgTAP 35, qui reste la référence de CE comportement). Ce fichier ne le rejoue pas : il
-- prouve les choses que le troisième terme du score peut casser, plus la seule qui
-- compte vraiment aujourd'hui — la NON-RÉGRESSION sur un corpus non taggé.
--
--   0. le DROIT : `authenticated` peut exécuter le helper d'oubli que la fonction appelle ;
--   1. non-régression : contenu taggé mais élève sans maîtrise → le plan d'avant, à l'identique ;
--   2. arbitrage : à retard égal, l'exercice dont une compétence est effondrée passe devant ;
--   3. neutralité du seuil : une maîtrise à 50 (la valeur d'INITIALISATION) ne pousse rien ;
--   4. maillon faible : c'est la PLUS BASSE des compétences de l'exercice qui décide ;
--   5. hiérarchie des termes : le retard domine — 0,5 ne renverse pas un arriéré de 20 jours ;
--   6. l'oubli compte : la maîtrise est lue décayée (R-4), jamais brute ;
--   7. R-6 : la maîtrise d'un AUTRE élève ne déplace rien dans mon plan.
--
-- Chaque cas a son propre élève, et TOUS partagent le même catalogue taggé : c'est ce qui
-- rend le cas 1 concluant (le tagging est là, c'est la maîtrise qui manque).
--
-- Les assertions d'ordre sont construites pour être DISCRIMINANTES : dans chaque cas où le
-- score doit réordonner, l'exercice attendu en tête porte l'id le PLUS GRAND — le tri de
-- départage final étant `final_id`, un plan qui ignorerait le score rendrait l'ordre inverse.
--
-- Les lignes de `user_competency_mastery` sont posées à la main, à rebours de
-- `user_misconceptions` (bâti par son trigger dans le pgTAP 35) : ici l'objet du test est le
-- SÉLECTEUR, pas l'EWMA — le trigger a sa propre suite (pgTAP 36). Poser la maîtrise
-- directement est ce qui rend chaque cas lisible et sans arithmétique cachée.
--
-- La fonction est SECURITY INVOKER : ces tests s'exécutent en rôle `authenticated` avec un JWT
-- posé, donc la RLS des tables lues est dans le périmètre testé. Tout est annulé à la fin.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(8);

-- ---------------------------------------------------------
-- Catalogue : un parcours gratuit en aperçu total — la porte R-3 est déjà couverte par le
-- pgTAP 35, elle n'a rien à mordre ici et ne doit pas brouiller les ordres testés.
-- ---------------------------------------------------------
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('dpq-theme', 'DPQ Theme', 'Brain', 'subject-math', true);

INSERT INTO public.grades (id, theme_id, slug, name_fr, cycle, display_order)
VALUES ('eb000000-0000-0000-0000-0000000000f1'::uuid, 'dpq-theme', 'dpq-free', 'DPQ Free',
        'college', 991);

INSERT INTO public.parcours (id, name_fr, kind, theme_id, grade_id, is_premium, preview_policy, icon, color)
VALUES ('dpq-par-free', 'DPQ Libre', 'concours', 'dpq-theme',
        'eb000000-0000-0000-0000-0000000000f1'::uuid, false, 'full', 'Brain', 'subject-math');

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id)
VALUES ('dpq-subj', 'DPQ Libre', 'Esprit', 'subject-math', 'Brain', 'dpq-theme',
        'eb000000-0000-0000-0000-0000000000f1'::uuid);

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('ec000000-0000-0000-0000-0000000000a1'::uuid, 'dpq-subj', 'Chapitre Q');

-- Sept exercices du MÊME chapitre : aucun terme « misconceptions » ne peut donc départager
-- quoi que ce soit, et tout écart d'ordre vient du seul terme ajouté par ce lot.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, difficulty, display_order, source)
VALUES
  ('ed000000-0000-0000-0000-000000000001'::uuid, 'ec000000-0000-0000-0000-0000000000a1'::uuid,
   'dpq-subj', 'A1 (non taggee)', 'practice', 2, 1, 'admin'),
  ('ed000000-0000-0000-0000-000000000002'::uuid, 'ec000000-0000-0000-0000-0000000000a1'::uuid,
   'dpq-subj', 'A2 (competence 60)', 'practice', 2, 2, 'admin'),
  ('ed000000-0000-0000-0000-000000000003'::uuid, 'ec000000-0000-0000-0000-0000000000a1'::uuid,
   'dpq-subj', 'A3 (competence 50 — initiale)', 'practice', 2, 3, 'admin'),
  ('ed000000-0000-0000-0000-000000000004'::uuid, 'ec000000-0000-0000-0000-0000000000a1'::uuid,
   'dpq-subj', 'A4 (competence effondree)', 'practice', 2, 4, 'admin'),
  ('ed000000-0000-0000-0000-000000000005'::uuid, 'ec000000-0000-0000-0000-0000000000a1'::uuid,
   'dpq-subj', 'A5 (deux competences : 80 et 15)', 'practice', 2, 5, 'admin'),
  ('ed000000-0000-0000-0000-000000000006'::uuid, 'ec000000-0000-0000-0000-0000000000a1'::uuid,
   'dpq-subj', 'A6 (competence 55 laissee 10 semaines)', 'practice', 2, 6, 'admin'),
  ('ed000000-0000-0000-0000-000000000007'::uuid, 'ec000000-0000-0000-0000-0000000000a1'::uuid,
   'dpq-subj', 'A7 (non taggee)', 'practice', 2, 7, 'admin');

-- Une question par exercice — le porteur du tagging (R-2 : la compétence est sur la QUESTION,
-- l'exercice l'hérite par ses questions).
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
SELECT
  ('ee000000-0000-0000-0000-00000000000' || n)::uuid,
  ('ed000000-0000-0000-0000-00000000000' || n)::uuid,
  'Q de A' || n,
  '[{"id":"a","text":"juste"},{"id":"b","text":"faux"}]'::jsonb,
  'a',
  1
FROM generate_series(1, 7) AS g(n);

INSERT INTO public.competencies (id, slug, family, label_fr, label_en, label_ar)
VALUES
  ('ef000000-0000-0000-0000-000000000001'::uuid, 'dpq.q.effondree', 'dpq', 'Effondree', 'Collapsed', 'منهارة'),
  ('ef000000-0000-0000-0000-000000000002'::uuid, 'dpq.q.initiale', 'dpq', 'Initiale', 'Initial', 'أولية'),
  ('ef000000-0000-0000-0000-000000000003'::uuid, 'dpq.q.acquise', 'dpq', 'Acquise', 'Mastered', 'مكتسبة'),
  ('ef000000-0000-0000-0000-000000000004'::uuid, 'dpq.q.fragile', 'dpq', 'Fragile', 'Fragile', 'هشة'),
  ('ef000000-0000-0000-0000-000000000005'::uuid, 'dpq.q.moyenne', 'dpq', 'Moyenne', 'Average', 'متوسطة'),
  ('ef000000-0000-0000-0000-000000000006'::uuid, 'dpq.q.jachere', 'dpq', 'Jachere', 'Idle', 'مهملة');

INSERT INTO public.question_competencies (question_id, competency_id, is_primary)
VALUES
  -- A2 → moyenne (60) ; A3 → initiale (50) ; A4 → effondrée ; A6 → jachère (55, décayée)
  ('ee000000-0000-0000-0000-000000000002'::uuid, 'ef000000-0000-0000-0000-000000000005'::uuid, true),
  ('ee000000-0000-0000-0000-000000000003'::uuid, 'ef000000-0000-0000-0000-000000000002'::uuid, true),
  ('ee000000-0000-0000-0000-000000000004'::uuid, 'ef000000-0000-0000-0000-000000000001'::uuid, true),
  ('ee000000-0000-0000-0000-000000000006'::uuid, 'ef000000-0000-0000-0000-000000000006'::uuid, true),
  -- A5 en porte DEUX (R-2) : une acquise (principale) et une fragile. C'est la fragile qui doit
  -- décider — c'est elle qui fera rater l'élève.
  ('ee000000-0000-0000-0000-000000000005'::uuid, 'ef000000-0000-0000-0000-000000000003'::uuid, true),
  ('ee000000-0000-0000-0000-000000000005'::uuid, 'ef000000-0000-0000-0000-000000000004'::uuid, false);

INSERT INTO auth.users (id, email) VALUES
  ('ea000000-0000-0000-0000-000000000001', 'dpq-u1@test.local'),
  ('ea000000-0000-0000-0000-000000000002', 'dpq-u2@test.local'),
  ('ea000000-0000-0000-0000-000000000003', 'dpq-u3@test.local'),
  ('ea000000-0000-0000-0000-000000000004', 'dpq-u4@test.local'),
  ('ea000000-0000-0000-0000-000000000005', 'dpq-u5@test.local'),
  ('ea000000-0000-0000-0000-000000000006', 'dpq-u6@test.local'),
  ('ea000000-0000-0000-0000-000000000007', 'dpq-u7@test.local');

-- =========================================================
-- CASE 0 — le DROIT d'exécuter le helper d'oubli (la panne que ce lot a dû réparer).
-- `get_daily_plan` est SECURITY INVOKER : elle appelle `competency_mastery_with_decay` avec les
-- droits de l'élève, alors que le lot 2 l'avait révoqué à `authenticated` (« server-side only »,
-- vrai tant que seules les RPC DEFINER du lot 4 l'appelaient). Sans ce droit, TOUT appel au plan
-- lève `permission denied` — y compris le plan d'avant ce lot. On l'assure donc explicitement,
-- pour qu'une révocation future casse ce test plutôt que la « Révision du jour ».
-- =========================================================
SELECT ok(
  has_function_privilege(
    'authenticated',
    'public.competency_mastery_with_decay(numeric, timestamptz)',
    'EXECUTE'
  ),
  'authenticated peut EXECUTER le helper d''oubli — get_daily_plan est INVOKER et l''appelle avec ses droits'
);

-- =========================================================
-- CASE 1 — NON-RÉGRESSION : le contenu est taggé, l'élève n'a aucune maîtrise.
-- C'est l'état RÉEL du corpus pendant toute la campagne de tagging (lot 3) : le terme doit
-- valoir zéro partout, donc l'ordre doit être exactement celui du retard SM-2.
-- =========================================================
INSERT INTO public.spaced_repetition_schedule
  (user_id, exercise_id, subject_id, retry_level, scheduled_for, status)
VALUES
  -- A4 porte la compétence effondrée… mais pas pour CET élève, qui n'a aucune ligne de maîtrise.
  ('ea000000-0000-0000-0000-000000000001', 'ed000000-0000-0000-0000-000000000004'::uuid,
   'dpq-subj', 1, now() - INTERVAL '2 days', 'pending'),
  ('ea000000-0000-0000-0000-000000000001', 'ed000000-0000-0000-0000-000000000001'::uuid,
   'dpq-subj', 1, now() - INTERVAL '20 days', 'pending');

SET LOCAL "request.jwt.claims" = '{"sub":"ea000000-0000-0000-0000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT array_agg(p.exercise_id ORDER BY p.days_overdue DESC) FROM public.get_daily_plan() p),
  ARRAY['ed000000-0000-0000-0000-000000000001'::uuid,
        'ed000000-0000-0000-0000-000000000004'::uuid],
  'R-2 : contenu taggé mais élève sans maîtrise — le plan reste celui du retard SM-2 seul'
);

RESET ROLE;

-- =========================================================
-- CASE 2 — à retard ÉGAL, la compétence effondrée passe devant (US-3).
-- A4 (effondrée à 10) porte l'id le plus grand : sans le score, le départage par id le
-- mettrait DERRIÈRE A1.
-- =========================================================
INSERT INTO public.spaced_repetition_schedule
  (user_id, exercise_id, subject_id, retry_level, scheduled_for, status)
VALUES
  ('ea000000-0000-0000-0000-000000000002', 'ed000000-0000-0000-0000-000000000001'::uuid,
   'dpq-subj', 1, now() - INTERVAL '10 days', 'pending'),
  ('ea000000-0000-0000-0000-000000000002', 'ed000000-0000-0000-0000-000000000004'::uuid,
   'dpq-subj', 1, now() - INTERVAL '10 days', 'pending');

INSERT INTO public.user_competency_mastery (user_id, competency_id, mastery, attempts, last_attempt_at)
VALUES ('ea000000-0000-0000-0000-000000000002', 'ef000000-0000-0000-0000-000000000001'::uuid,
        10, 6, now());

SET LOCAL "request.jwt.claims" = '{"sub":"ea000000-0000-0000-0000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT ARRAY(SELECT p.exercise_id FROM public.get_daily_plan() p)),
  ARRAY['ed000000-0000-0000-0000-000000000004'::uuid,
        'ed000000-0000-0000-0000-000000000001'::uuid],
  'US-3 : a retard egal, l''exercice dont une competence est effondree passe devant'
);

RESET ROLE;

-- =========================================================
-- CASE 3 — une maîtrise à 50 ne pousse rien (RISK-2).
-- 50 est la valeur d'INITIALISATION au premier contact : la traiter comme un diagnostic ferait
-- remonter tout ce qui vient d'être touché une fois.
-- =========================================================
INSERT INTO public.spaced_repetition_schedule
  (user_id, exercise_id, subject_id, retry_level, scheduled_for, status)
VALUES
  ('ea000000-0000-0000-0000-000000000003', 'ed000000-0000-0000-0000-000000000001'::uuid,
   'dpq-subj', 1, now() - INTERVAL '10 days', 'pending'),
  ('ea000000-0000-0000-0000-000000000003', 'ed000000-0000-0000-0000-000000000003'::uuid,
   'dpq-subj', 1, now() - INTERVAL '10 days', 'pending');

INSERT INTO public.user_competency_mastery (user_id, competency_id, mastery, attempts, last_attempt_at)
VALUES ('ea000000-0000-0000-0000-000000000003', 'ef000000-0000-0000-0000-000000000002'::uuid,
        50, 1, now());

SET LOCAL "request.jwt.claims" = '{"sub":"ea000000-0000-0000-0000-000000000003","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT ARRAY(SELECT p.exercise_id FROM public.get_daily_plan() p)),
  ARRAY['ed000000-0000-0000-0000-000000000001'::uuid,
        'ed000000-0000-0000-0000-000000000003'::uuid],
  'la maitrise initiale (50) est neutre : scores egaux, ordre de departage inchange'
);

RESET ROLE;

-- =========================================================
-- CASE 4 — le MAILLON FAIBLE décide (R-2, 1 à 3 compétences par question).
-- A5 porte 80 ET 15 ; A2 porte 60 (donc terme nul). A5 a l'id le plus grand : sans le score,
-- il sortirait second.
-- =========================================================
INSERT INTO public.spaced_repetition_schedule
  (user_id, exercise_id, subject_id, retry_level, scheduled_for, status)
VALUES
  ('ea000000-0000-0000-0000-000000000004', 'ed000000-0000-0000-0000-000000000002'::uuid,
   'dpq-subj', 1, now() - INTERVAL '10 days', 'pending'),
  ('ea000000-0000-0000-0000-000000000004', 'ed000000-0000-0000-0000-000000000005'::uuid,
   'dpq-subj', 1, now() - INTERVAL '10 days', 'pending');

INSERT INTO public.user_competency_mastery (user_id, competency_id, mastery, attempts, last_attempt_at)
VALUES
  ('ea000000-0000-0000-0000-000000000004', 'ef000000-0000-0000-0000-000000000005'::uuid, 60, 4, now()),
  ('ea000000-0000-0000-0000-000000000004', 'ef000000-0000-0000-0000-000000000003'::uuid, 80, 5, now()),
  ('ea000000-0000-0000-0000-000000000004', 'ef000000-0000-0000-0000-000000000004'::uuid, 15, 3, now());

SET LOCAL "request.jwt.claims" = '{"sub":"ea000000-0000-0000-0000-000000000004","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT ARRAY(SELECT p.exercise_id FROM public.get_daily_plan() p)),
  ARRAY['ed000000-0000-0000-0000-000000000005'::uuid,
        'ed000000-0000-0000-0000-000000000002'::uuid],
  'R-2 : c''est la PLUS BASSE des competences de l''exercice qui decide, pas la principale'
);

RESET ROLE;

-- =========================================================
-- CASE 5 — hiérarchie des termes : le retard DOMINE (D-3).
-- A4 est dû du jour avec une compétence à 0 (score 0,5) ; A7 traîne 20 jours sans tagging
-- (20/30 = 0,667). Le retard doit gagner — le facteur 0,5 arbitre, il ne renverse pas.
-- A4 a l'id le plus PETIT : sans le score, il sortirait premier.
-- =========================================================
INSERT INTO public.spaced_repetition_schedule
  (user_id, exercise_id, subject_id, retry_level, scheduled_for, status)
VALUES
  ('ea000000-0000-0000-0000-000000000005', 'ed000000-0000-0000-0000-000000000004'::uuid,
   'dpq-subj', 1, now() - INTERVAL '1 hour', 'pending'),
  ('ea000000-0000-0000-0000-000000000005', 'ed000000-0000-0000-0000-000000000007'::uuid,
   'dpq-subj', 1, now() - INTERVAL '20 days', 'pending');

INSERT INTO public.user_competency_mastery (user_id, competency_id, mastery, attempts, last_attempt_at)
VALUES ('ea000000-0000-0000-0000-000000000005', 'ef000000-0000-0000-0000-000000000001'::uuid,
        0, 8, now());

SET LOCAL "request.jwt.claims" = '{"sub":"ea000000-0000-0000-0000-000000000005","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT ARRAY(SELECT p.exercise_id FROM public.get_daily_plan() p)),
  ARRAY['ed000000-0000-0000-0000-000000000007'::uuid,
        'ed000000-0000-0000-0000-000000000004'::uuid],
  'D-3 : un arriere de 20 jours passe devant une competence a zero due du jour'
);

RESET ROLE;

-- =========================================================
-- CASE 6 — l'OUBLI compte (R-4) : 55 laissé 10 semaines se lit 45, donc sous le seuil.
-- La maîtrise brute (55) ne donnerait aucun terme ; c'est bien `competency_mastery_with_decay`
-- qui est lu. A6 a l'id le plus grand : sans le score, il sortirait second.
-- =========================================================
INSERT INTO public.spaced_repetition_schedule
  (user_id, exercise_id, subject_id, retry_level, scheduled_for, status)
VALUES
  ('ea000000-0000-0000-0000-000000000006', 'ed000000-0000-0000-0000-000000000001'::uuid,
   'dpq-subj', 1, now() - INTERVAL '10 days', 'pending'),
  ('ea000000-0000-0000-0000-000000000006', 'ed000000-0000-0000-0000-000000000006'::uuid,
   'dpq-subj', 1, now() - INTERVAL '10 days', 'pending');

INSERT INTO public.user_competency_mastery (user_id, competency_id, mastery, attempts, last_attempt_at)
VALUES ('ea000000-0000-0000-0000-000000000006', 'ef000000-0000-0000-0000-000000000006'::uuid,
        55, 4, now() - INTERVAL '70 days');

SET LOCAL "request.jwt.claims" = '{"sub":"ea000000-0000-0000-0000-000000000006","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT ARRAY(SELECT p.exercise_id FROM public.get_daily_plan() p)),
  ARRAY['ed000000-0000-0000-0000-000000000006'::uuid,
        'ed000000-0000-0000-0000-000000000001'::uuid],
  'R-4 : la maitrise est lue DECAYEE — 55 laisse 10 semaines vaut 45, donc sous le seuil'
);

RESET ROLE;

-- =========================================================
-- CASE 7 — R-6 : aucune maîtrise d'un autre élève ne déplace mon plan.
-- L'élève 7 a le même arriéré que l'élève 2 sur A1 et A4, mais c'est l'élève 2 qui a la
-- compétence effondrée. Son plan doit donc rester l'ordre de départage.
-- =========================================================
INSERT INTO public.spaced_repetition_schedule
  (user_id, exercise_id, subject_id, retry_level, scheduled_for, status)
VALUES
  ('ea000000-0000-0000-0000-000000000007', 'ed000000-0000-0000-0000-000000000001'::uuid,
   'dpq-subj', 1, now() - INTERVAL '10 days', 'pending'),
  ('ea000000-0000-0000-0000-000000000007', 'ed000000-0000-0000-0000-000000000004'::uuid,
   'dpq-subj', 1, now() - INTERVAL '10 days', 'pending');

SET LOCAL "request.jwt.claims" = '{"sub":"ea000000-0000-0000-0000-000000000007","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT ARRAY(SELECT p.exercise_id FROM public.get_daily_plan() p)),
  ARRAY['ed000000-0000-0000-0000-000000000001'::uuid,
        'ed000000-0000-0000-0000-000000000004'::uuid],
  'R-6 : la competence effondree d''un AUTRE eleve ne reordonne pas mon plan'
);

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
