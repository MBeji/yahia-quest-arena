-- =========================================================
-- Knowledge graph — les 3 RPC de lecture (étude 07, lot 4 : US-1, US-2, R-5, R-6).
-- ---------------------------------------------------------
--   get_my_competency_map        — ce que voit l'élève : sa maîtrise (oubli appliqué),
--     ses tentatives, sa réussite récente ; groupée par famille/domaine ; JAMAIS celle
--     d'un autre (R-6) ; filtrable par famille.
--   get_competency_blockers      — R-5 : les prérequis faibles, remontés dans le DAG,
--     bornés en profondeur 3, seuil < 60, jamais un prérequis sans preuve, max 3.
--   get_exercises_for_competency — US-2 : les exercices existants qui l'évaluent, passés
--     par la porte d'accès (R-3), quiz exclu.
--
-- Les deux premières sont SECURITY DEFINER mais scopées `auth.uid()` : on les exécute donc
-- sous un vrai rôle `authenticated` avec JWT, pour prouver que le périmètre est le caller et
-- non le definer. Fixtures créées DANS la transaction — zéro dépendance au corpus (#574).
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(19);

-- Ce fichier PRÉ-POSE la maîtrise pour tester la LECTURE (get_my_competency_map). Or les
-- question_attempts qu'on insère pour recent_result déclenchent le trigger EWMA du lot 2, qui
-- récrirait la maîtrise posée. On le désactive donc le temps du montage (la transaction est
-- annulée à la fin ; le trigger a sa propre suite, 36_competency_mastery).
ALTER TABLE public.question_attempts DISABLE TRIGGER trg_question_attempts_competency_mastery;

-- ---------------------------------------------------------
-- Élèves.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('ce000000-0000-0000-0000-0000000000a1', 'cm-u1@test.local'),
  ('ce000000-0000-0000-0000-0000000000a2', 'cm-u2@test.local');

-- ---------------------------------------------------------
-- Le graphe de compétences (famille 'test').
--   Carte : test.frac.add (fort), test.geo.angles (faible) — deux domaines.
--   Blocages : target ← p1weak ← p2 ← p3 ← p4 (profondeur 4, pour tester la borne),
--              target ← p1strong (fort, pas un blocage), target ← p1untried (aucune preuve).
-- ---------------------------------------------------------
INSERT INTO public.competencies (id, slug, family, label_fr, label_en, label_ar) VALUES
  ('ce100000-0000-0000-0000-000000000001', 'test.frac.add', 'test', 'Fractions', 'Fractions', 'كسور'),
  ('ce100000-0000-0000-0000-000000000002', 'test.geo.angles',  'test', 'Géométrie', 'Geometry', 'هندسة'),
  ('ce100000-0000-0000-0000-000000000010', 'test.blk.target',    'test', 'Cible', 'Target', 'هدف'),
  ('ce100000-0000-0000-0000-000000000011', 'test.blk.p1weak',    'test', 'P1 faible', 'P1 weak', 'مـ1 ضعيف'),
  ('ce100000-0000-0000-0000-000000000012', 'test.blk.p1strong',  'test', 'P1 fort', 'P1 strong', 'مـ1 قوي'),
  ('ce100000-0000-0000-0000-000000000013', 'test.blk.p1untried', 'test', 'P1 vierge', 'P1 untried', 'مـ1 دون محاولة'),
  ('ce100000-0000-0000-0000-000000000014', 'test.blk.p2',        'test', 'P2', 'P2', 'مـ2'),
  ('ce100000-0000-0000-0000-000000000015', 'test.blk.p3',        'test', 'P3', 'P3', 'مـ3'),
  ('ce100000-0000-0000-0000-000000000016', 'test.blk.p4',        'test', 'P4', 'P4', 'مـ4');

INSERT INTO public.competency_prereqs (competency_id, prereq_id) VALUES
  ('ce100000-0000-0000-0000-000000000010', 'ce100000-0000-0000-0000-000000000011'), -- target ← p1weak (d1)
  ('ce100000-0000-0000-0000-000000000010', 'ce100000-0000-0000-0000-000000000012'), -- target ← p1strong (d1)
  ('ce100000-0000-0000-0000-000000000010', 'ce100000-0000-0000-0000-000000000013'), -- target ← p1untried (d1)
  ('ce100000-0000-0000-0000-000000000011', 'ce100000-0000-0000-0000-000000000014'), -- p1weak ← p2 (d2)
  ('ce100000-0000-0000-0000-000000000014', 'ce100000-0000-0000-0000-000000000015'), -- p2 ← p3 (d3)
  ('ce100000-0000-0000-0000-000000000015', 'ce100000-0000-0000-0000-000000000016'); -- p3 ← p4 (d4, hors borne)

-- ---------------------------------------------------------
-- Maîtrises. u1 : la carte + la chaîne de blocages. u2 : une seule, pour l'isolation R-6.
-- test.geo.angles est daté d'il y a 4 semaines avec mastery 80 → oubli attendu 80 − 4 = 76.
-- ---------------------------------------------------------
INSERT INTO public.user_competency_mastery (user_id, competency_id, mastery, attempts, last_attempt_at) VALUES
  ('ce000000-0000-0000-0000-0000000000a1', 'ce100000-0000-0000-0000-000000000001', 90, 10, now()),
  ('ce000000-0000-0000-0000-0000000000a1', 'ce100000-0000-0000-0000-000000000002', 80, 3, now() - INTERVAL '4 weeks'),
  ('ce000000-0000-0000-0000-0000000000a1', 'ce100000-0000-0000-0000-000000000010', 40, 8, now()),
  ('ce000000-0000-0000-0000-0000000000a1', 'ce100000-0000-0000-0000-000000000011', 40, 6, now()),  -- p1weak
  ('ce000000-0000-0000-0000-0000000000a1', 'ce100000-0000-0000-0000-000000000012', 80, 6, now()),  -- p1strong (>60)
  ('ce000000-0000-0000-0000-0000000000a1', 'ce100000-0000-0000-0000-000000000014', 30, 6, now()),  -- p2
  ('ce000000-0000-0000-0000-0000000000a1', 'ce100000-0000-0000-0000-000000000015', 20, 6, now()),  -- p3
  ('ce000000-0000-0000-0000-0000000000a1', 'ce100000-0000-0000-0000-000000000016', 10, 6, now()),  -- p4 (hors borne)
  ('ce000000-0000-0000-0000-0000000000a2', 'ce100000-0000-0000-0000-000000000001', 15, 9, now());  -- u2, R-6

-- ---------------------------------------------------------
-- Catalogue pour get_exercises_for_competency : un sujet gratuit (E1 pratique + Equiz),
-- un sujet premium non déverrouillé (E2 d3, verrouillé par la porte R-3). Tous taggés
-- test.frac.add. Réutilise le patron premium de 34_daily_plan.
-- ---------------------------------------------------------
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('cm-theme', 'CM Theme', 'Brain', 'subject-math', true);
INSERT INTO public.grades (id, theme_id, slug, name_fr, cycle, display_order) VALUES
  ('ce200000-0000-0000-0000-0000000000f1', 'cm-theme', 'cm-free', 'CM Free', 'college', 971),
  ('ce200000-0000-0000-0000-0000000000f2', 'cm-theme', 'cm-prem', 'CM Prem', 'college', 972);
INSERT INTO public.parcours (id, name_fr, kind, theme_id, grade_id, is_premium, preview_policy, icon, color) VALUES
  ('cm-par-free', 'CM Libre', 'concours', 'cm-theme', 'ce200000-0000-0000-0000-0000000000f1', false, 'full', 'Brain', 'subject-math'),
  ('cm-par-prem', 'CM Premium', 'concours', 'cm-theme', 'ce200000-0000-0000-0000-0000000000f2', true, 'difficulty_1', 'Brain', 'subject-math');
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id) VALUES
  ('cm-subj-free', 'CM Libre', 'Esprit', 'subject-math', 'Brain', 'cm-theme', 'ce200000-0000-0000-0000-0000000000f1'),
  ('cm-subj-prem', 'CM Premium', 'Esprit', 'subject-math', 'Brain', 'cm-theme', 'ce200000-0000-0000-0000-0000000000f2');
INSERT INTO public.chapters (id, subject_id, title) VALUES
  ('ce300000-0000-0000-0000-000000000001', 'cm-subj-free', 'CM Chapitre libre'),
  ('ce300000-0000-0000-0000-000000000002', 'cm-subj-prem', 'CM Chapitre premium');
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, difficulty, display_order, source) VALUES
  ('ce400000-0000-0000-0000-000000000001', 'ce300000-0000-0000-0000-000000000001', 'cm-subj-free', 'E1 (accessible)', 'practice', 2, 1, 'admin'),
  ('ce400000-0000-0000-0000-0000000000c1', 'ce300000-0000-0000-0000-000000000001', 'cm-subj-free', 'Quiz (porte)', 'quiz', 1, 0, 'admin'),
  ('ce400000-0000-0000-0000-000000000002', 'ce300000-0000-0000-0000-000000000002', 'cm-subj-prem', 'E2 (verrouille d3)', 'practice', 3, 1, 'admin');
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order) VALUES
  ('ce500000-0000-0000-0000-000000000001', 'ce400000-0000-0000-0000-000000000001', 'q E1', '[{"id":"a","text":"1"},{"id":"b","text":"2"}]'::jsonb, 'a', 1),
  ('ce500000-0000-0000-0000-0000000000c1', 'ce400000-0000-0000-0000-0000000000c1', 'q Quiz', '[{"id":"a","text":"1"},{"id":"b","text":"2"}]'::jsonb, 'a', 1),
  ('ce500000-0000-0000-0000-000000000002', 'ce400000-0000-0000-0000-000000000002', 'q E2', '[{"id":"a","text":"1"},{"id":"b","text":"2"}]'::jsonb, 'a', 1),
  -- une question de test.geo.angles, pour recent_result (jouée dans les 14 jours).
  ('ce500000-0000-0000-0000-000000000009', 'ce400000-0000-0000-0000-000000000001', 'q geo', '[{"id":"a","text":"1"},{"id":"b","text":"2"}]'::jsonb, 'a', 2);
INSERT INTO public.question_competencies (question_id, competency_id, is_primary) VALUES
  ('ce500000-0000-0000-0000-000000000001', 'ce100000-0000-0000-0000-000000000001', true),
  ('ce500000-0000-0000-0000-0000000000c1', 'ce100000-0000-0000-0000-000000000001', true),
  ('ce500000-0000-0000-0000-000000000002', 'ce100000-0000-0000-0000-000000000001', true),
  ('ce500000-0000-0000-0000-000000000009', 'ce100000-0000-0000-0000-000000000002', true);

-- recent_result de test.geo.angles : 2 bonnes / 1 mauvaise dans les 14 j = 66.67.
INSERT INTO public.question_attempts
  (user_id, question_id, chapter_id, session_id, choice, is_correct, source, created_at)
VALUES
  ('ce000000-0000-0000-0000-0000000000a1', 'ce500000-0000-0000-0000-000000000009', 'ce300000-0000-0000-0000-000000000001', 'ce600000-0000-0000-0000-000000000001', 'a', true,  'exercise', now() - INTERVAL '2 days'),
  ('ce000000-0000-0000-0000-0000000000a1', 'ce500000-0000-0000-0000-000000000009', 'ce300000-0000-0000-0000-000000000001', 'ce600000-0000-0000-0000-000000000001', 'a', true,  'exercise', now() - INTERVAL '3 days'),
  ('ce000000-0000-0000-0000-0000000000a1', 'ce500000-0000-0000-0000-000000000009', 'ce300000-0000-0000-0000-000000000001', 'ce600000-0000-0000-0000-000000000001', 'b', false, 'exercise', now() - INTERVAL '4 days'),
  -- hors fenêtre 14 j : ne doit PAS compter.
  ('ce000000-0000-0000-0000-0000000000a1', 'ce500000-0000-0000-0000-000000000009', 'ce300000-0000-0000-0000-000000000001', 'ce600000-0000-0000-0000-000000000001', 'b', false, 'exercise', now() - INTERVAL '30 days');

-- =========================================================
-- CASE A — get_my_competency_map (US-1), sous le rôle de u1.
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"ce000000-0000-0000-0000-0000000000a1","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.get_my_competency_map()),
  8,
  'map: rend les 8 compétences de u1 (jamais celle de u2 — R-6)'
);

SELECT is(
  (SELECT mastery FROM public.get_my_competency_map() WHERE slug = 'test.geo.angles'),
  76.00::NUMERIC,
  'map: l''oubli est appliqué à la lecture (80 il y a 4 semaines → 76)'
);

SELECT is(
  (SELECT domain FROM public.get_my_competency_map() WHERE slug = 'test.geo.angles'),
  'geo',
  'map: le domaine est le 2e segment de l''id (groupement de la carte)'
);

SELECT is(
  (SELECT attempts FROM public.get_my_competency_map() WHERE slug = 'test.geo.angles'),
  3,
  'map: expose attempts (le client affiche « en cours d''évaluation » sous 5 — Q-2)'
);

SELECT is(
  (SELECT recent_result FROM public.get_my_competency_map() WHERE slug = 'test.geo.angles'),
  66.67::NUMERIC,
  'map: recent_result = réussite moyenne des 14 j (2/3), le hors-fenêtre exclu'
);

SELECT is(
  (SELECT recent_result FROM public.get_my_competency_map() WHERE slug = 'test.frac.add'),
  NULL,
  'map: recent_result est NULL quand rien n''a été joué sur 14 j'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_my_competency_map('nope')),
  0,
  'map: le filtre famille exclut ce qui n''en est pas'
);

SELECT is_empty(
  $$ SELECT 1 FROM public.get_my_competency_map() WHERE mastery = 15 $$,
  'map: u1 ne voit jamais la maîtrise de u2 (R-6)'
);

-- =========================================================
-- CASE B — get_competency_blockers (R-5), sous le rôle de u1.
-- =========================================================
SELECT is(
  (SELECT array_agg(slug ORDER BY depth, mastery) FROM public.get_competency_blockers('test.blk.target')),
  ARRAY['test.blk.p1weak', 'test.blk.p2', 'test.blk.p3'],
  'blockers: prérequis faibles remontés, triés par (profondeur, maîtrise), max 3'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_competency_blockers('test.blk.target')
     WHERE slug = 'test.blk.p4'),
  0,
  'blockers: la profondeur est bornée à 3 (p4 à la profondeur 4 est hors champ, protège d''un cycle)'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_competency_blockers('test.blk.target')
     WHERE slug = 'test.blk.p1strong'),
  0,
  'blockers: un prérequis maîtrisé (>= 60) n''est pas un blocage'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_competency_blockers('test.blk.target')
     WHERE slug = 'test.blk.p1untried'),
  0,
  'blockers: un prérequis jamais tenté (aucune preuve) n''est pas accusé (RISK-2)'
);

SELECT is(
  (SELECT depth FROM public.get_competency_blockers('test.blk.target') WHERE slug = 'test.blk.p1weak'),
  1,
  'blockers: la profondeur est rendue (prérequis direct = 1)'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_competency_blockers('test.blk.p1untried')),
  0,
  'blockers: une compétence sans prérequis ne renvoie rien'
);

-- =========================================================
-- CASE C — get_exercises_for_competency (US-2 / R-3), sous le rôle de u1.
-- =========================================================
SELECT is(
  (SELECT array_agg(exercise_id) FROM public.get_exercises_for_competency('test.frac.add')),
  ARRAY['ce400000-0000-0000-0000-000000000001'::uuid],
  'exercises: rend l''exercice accessible qui évalue la compétence'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_exercises_for_competency('test.frac.add')
     WHERE exercise_id = 'ce400000-0000-0000-0000-0000000000c1'::uuid),
  0,
  'exercises: le quiz de compréhension (porte du chapitre) est exclu'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_exercises_for_competency('test.frac.add')
     WHERE exercise_id = 'ce400000-0000-0000-0000-000000000002'::uuid),
  0,
  'exercises: R-3 — l''exercice d''un parcours premium non déverrouillé est écarté par la porte'
);

RESET ROLE;

-- =========================================================
-- CASE D — droits d'exécution.
-- =========================================================
SELECT ok(
  has_function_privilege('authenticated', 'public.get_my_competency_map(text)', 'EXECUTE')
    AND has_function_privilege('authenticated', 'public.get_competency_blockers(text)', 'EXECUTE')
    AND has_function_privilege('authenticated', 'public.get_exercises_for_competency(text)', 'EXECUTE'),
  'authenticated peut appeler les trois RPC'
);

SELECT ok(
  NOT has_function_privilege('anon', 'public.get_my_competency_map(text)', 'EXECUTE')
    AND NOT has_function_privilege('anon', 'public.get_competency_blockers(text)', 'EXECUTE')
    AND NOT has_function_privilege('anon', 'public.get_exercises_for_competency(text)', 'EXECUTE'),
  'anon ne peut appeler aucune des trois — ce sont des vues nominatives'
);

SELECT * FROM finish();
ROLLBACK;
