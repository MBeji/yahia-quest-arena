-- =========================================================
-- Bilan et programme du jour (migration 20261122160000_study_report.sql)
-- ---------------------------------------------------------
-- CE QUE CE FICHIER PROTÈGE :
--   ⭐ le programme ne sort JAMAIS des chapitres vus en classe — c'est toute la
--      commande (« nous sommes encore au premier trimestre ») ;
--   ⭐ « vu » = ce que l'élève a déclaré ; sans déclaration, le calendrier ;
--   ⭐ l'élève lit son bilan, son parent lié aussi, un inconnu jamais ;
--   ⭐ la table ne s'écrit que par `set_class_chapters`, et les fonctions
--      internes ne sont pas des RPC.
--
-- Le décor : un parcours de deux matières.
--   maths    M1..M4 — M1 : une mission comptée (A1), une ratée (A2), un quiz ;
--                     le reste jamais ouvert ;
--   français F1..F2 — jamais ouvert.
-- Chaque chapitre porte trois missions de difficulté 1 et une de difficulté 2,
-- six questions chacune (4 minutes estimées en d1).
--
-- Tout est annulé à la fin.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(43);

INSERT INTO auth.users (id, email) VALUES
  ('e1160000-0000-4000-8000-0000000000a1', 't116-eleve@test.local'),
  ('e1160000-0000-4000-8000-0000000000a2', 't116-parent@test.local'),
  ('e1160000-0000-4000-8000-0000000000a3', 't116-inconnu@test.local');

INSERT INTO public.profiles (id, display_name, role) VALUES
  ('e1160000-0000-4000-8000-0000000000a1', 'T116Eleve', 'student'),
  ('e1160000-0000-4000-8000-0000000000a2', 'T116Parent', 'parent'),
  ('e1160000-0000-4000-8000-0000000000a3', 'T116Inconnu', 'student')
ON CONFLICT (id) DO UPDATE SET role = EXCLUDED.role;

INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('t116-theme', 'Thème 116', 'book', 'primary', true),
       ('t116-autre', 'Autre thème 116', 'book', 'primary', false);

INSERT INTO public.grades (id, theme_id, slug, name_fr, display_order)
VALUES ('e1160000-0000-4000-8000-0000000000e9'::uuid, 't116-theme', 't116-9', '9ème', 9);

INSERT INTO public.parcours (id, theme_id, grade_id, name_fr, name_ar, kind, icon, color, display_order)
VALUES ('t116-parcours', 't116-theme', 'e1160000-0000-4000-8000-0000000000e9'::uuid,
        'Parcours 116', 'مسار 116', 'concours', 'Brain', 'gold', 999);

INSERT INTO public.subjects (id, theme_id, grade_id, name_fr, attribute, color_token, icon, display_order) VALUES
  ('t116-math', 't116-theme', 'e1160000-0000-4000-8000-0000000000e9'::uuid, 'Maths 116', 'logic', 'primary', 'sigma', 1),
  ('t116-fr',   't116-theme', 'e1160000-0000-4000-8000-0000000000e9'::uuid, 'Français 116', 'logic', 'primary', 'book', 2),
  ('t116-hors', 't116-autre', NULL, 'Hors parcours 116', 'logic', 'primary', 'book', 3);

UPDATE public.profiles
   SET current_parcours_id = 't116-parcours'
 WHERE id = 'e1160000-0000-4000-8000-0000000000a1';

INSERT INTO public.chapters (id, subject_id, title, display_order) VALUES
  ('e1160000-0000-4000-8000-0000000000c1', 't116-math', 'M1', 1),
  ('e1160000-0000-4000-8000-0000000000c2', 't116-math', 'M2', 2),
  ('e1160000-0000-4000-8000-0000000000c3', 't116-math', 'M3', 3),
  ('e1160000-0000-4000-8000-0000000000c4', 't116-math', 'M4', 4),
  ('e1160000-0000-4000-8000-0000000000c5', 't116-fr',   'F1', 1),
  ('e1160000-0000-4000-8000-0000000000c6', 't116-fr',   'F2', 2),
  ('e1160000-0000-4000-8000-0000000000c7', 't116-hors', 'H1', 1);

-- Missions : chapitre k, mission i → …00000000<kk><ii>. i = 1..3 en d1, i = 4 en d2.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, difficulty, display_order)
SELECT ('e1160000-0000-4000-8000-00000000' || lpad(k::text, 2, '0') || lpad(i::text, 2, '0'))::uuid,
       ('e1160000-0000-4000-8000-0000000000c' || k)::uuid,
       CASE WHEN k <= 4 THEN 't116-math' WHEN k <= 6 THEN 't116-fr' ELSE 't116-hors' END,
       'mission ' || k || '-' || i, 'practice', 'admin',
       CASE WHEN i = 4 THEN 2 ELSE 1 END, i
  FROM generate_series(1, 7) k, generate_series(1, 4) i;

-- Le quiz de M1.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, difficulty, display_order) VALUES
  ('e1160000-0000-4000-8000-000000000109', 'e1160000-0000-4000-8000-0000000000c1', 't116-math', 'quiz M1', 'quiz', 'admin', 1, 0);

INSERT INTO public.questions (exercise_id, prompt, options, correct_option, display_order, question_type)
SELECT e.id, 'Question ' || q, '[{"id":"a","text":"oui"},{"id":"b","text":"non"}]'::jsonb, 'a', q, 'mcq'
  FROM public.exercises e, generate_series(1, 6) q
 WHERE e.subject_id IN ('t116-math', 't116-fr', 't116-hors');

INSERT INTO public.parent_student_links (parent_user_id, student_user_id, relation_label, is_active)
VALUES ('e1160000-0000-4000-8000-0000000000a2', 'e1160000-0000-4000-8000-0000000000a1', 'parent', true);

-- M1 : A1 comptée (80 %, sans précipitation), A2 ratée. Datées dans le passé,
-- une instruction par tentative (docs/etoiles-et-sceaux.md).
INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant, completed_at)
VALUES ('e1160000-0000-4000-8000-0000000000a1', 'e1160000-0000-4000-8000-000000000101', 't116-math', 8, 10, 80, 90, 0, 'classic', now() - INTERVAL '3 days');
INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant, completed_at)
VALUES ('e1160000-0000-4000-8000-0000000000a1', 'e1160000-0000-4000-8000-000000000102', 't116-math', 4, 10, 40, 90, 0, 'classic', now() - INTERVAL '3 days');

-- ---------------------------------------------------------
-- 1. Les constantes.
-- ---------------------------------------------------------
SELECT is(public.school_year_share(DATE '2026-09-15'), 0::numeric, 'année scolaire : 0 le jour de la rentrée');
SELECT is(public.school_year_share(DATE '2026-07-10'), 1::numeric, 'année scolaire : 1 pendant l''été (programme vu)');
SELECT is(round(public.school_year_share(DATE '2026-11-22'), 4), 0.2636, 'année scolaire : 68 jours sur 258 au 22 novembre');
SELECT ok(
  public.study_exercise_minutes(6, 1) = 4
  AND public.study_exercise_minutes(8, 4) = 8
  AND public.study_exercise_minutes(1, 1) = 3,
  'durée estimée : 35 s par question (60 s en difficulté 4), trois minutes au moins'
);
SELECT ok(
  public.study_level(NULL, 0) = 'non-evalue'
  AND public.study_level(90, 2) = 'non-evalue'
  AND public.study_level(85, 3) = 'solide'
  AND public.study_level(60, 5) = 'en-progres'
  AND public.study_level(59, 5) = 'a-renforcer',
  'niveau : rien sous trois missions, puis les seuils 60 et 80'
);

-- ---------------------------------------------------------
-- 2. Les droits.
-- ---------------------------------------------------------
SELECT ok(
  NOT has_function_privilege('authenticated', 'public.student_study_chapters(uuid,text[],date)', 'EXECUTE')
  AND NOT has_function_privilege('authenticated', 'public.student_study_plan(uuid,text[],date,integer)', 'EXECUTE')
  AND NOT has_function_privilege('authenticated', 'public.student_study_plan_from(uuid,text[],date,integer,jsonb)', 'EXECUTE')
  AND NOT has_function_privilege('authenticated', 'public.study_subject_ids(uuid)', 'EXECUTE'),
  '⭐ les fonctions internes ne sont pas des RPC'
);
SELECT ok(
  has_function_privilege('authenticated', 'public.get_study_report(uuid,boolean)', 'EXECUTE')
  AND has_function_privilege('authenticated', 'public.set_class_chapters(text,uuid[],uuid)', 'EXECUTE')
  AND NOT has_function_privilege('anon', 'public.get_study_report(uuid,boolean)', 'EXECUTE')
  AND NOT has_function_privilege('anon', 'public.set_class_chapters(text,uuid[],uuid)', 'EXECUTE'),
  'les deux RPC : authenticated, jamais anon'
);
SELECT ok(
  has_table_privilege('authenticated', 'public.student_class_chapters', 'SELECT')
  AND NOT has_table_privilege('authenticated', 'public.student_class_chapters', 'INSERT')
  AND NOT has_table_privilege('authenticated', 'public.student_class_chapters', 'DELETE')
  AND NOT has_table_privilege('anon', 'public.student_class_chapters', 'SELECT'),
  '⭐ la table se lit, elle ne s''écrit que par la RPC'
);

-- ---------------------------------------------------------
-- 3. Sans déclaration : le calendrier.
-- ---------------------------------------------------------
SELECT is(
  (SELECT string_agg(c.title, ',' ORDER BY c.chapter_rank)
     FROM public.student_study_chapters('e1160000-0000-4000-8000-0000000000a1',
            ARRAY['t116-math', 't116-fr'], DATE '2026-11-22') c
    WHERE c.seen),
  'F1,M1,M2',
  '⭐ au 22 novembre sans déclaration : 2 chapitres de maths sur 4, 1 de français sur 2'
);
SELECT is(
  (SELECT bool_or(c.declared)
     FROM public.student_study_chapters('e1160000-0000-4000-8000-0000000000a1',
            ARRAY['t116-math', 't116-fr'], DATE '2026-11-22') c),
  false,
  'rien n''est déclaré tant que l''élève n''a rien coché'
);
SELECT is(
  (SELECT count(*)::int
     FROM public.student_study_chapters('e1160000-0000-4000-8000-0000000000a1',
            ARRAY['t116-math'], DATE '2026-07-10') c
    WHERE c.seen),
  4,
  'en été, tout le programme est vu'
);

-- ---------------------------------------------------------
-- 4. L'élève déclare ses chapitres.
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"e1160000-0000-4000-8000-0000000000a1","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  public.set_class_chapters('t116-math', ARRAY[
    'e1160000-0000-4000-8000-0000000000c1',
    'e1160000-0000-4000-8000-0000000000c3']::uuid[]),
  2,
  'l''élève coche M1 et M3'
);
SELECT throws_ok(
  $$SELECT public.set_class_chapters('t116-math', ARRAY['e1160000-0000-4000-8000-0000000000c5']::uuid[])$$,
  'Unknown chapter for this subject',
  'un chapitre d''une autre matière est refusé'
);
SELECT throws_ok(
  $$INSERT INTO public.student_class_chapters (user_id, chapter_id)
    VALUES ('e1160000-0000-4000-8000-0000000000a1', 'e1160000-0000-4000-8000-0000000000c2')$$,
  '42501',
  NULL,
  '⭐ pas d''écriture directe dans la table'
);

RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"e1160000-0000-4000-8000-0000000000a3","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$SELECT public.set_class_chapters('t116-math', ARRAY[]::uuid[], 'e1160000-0000-4000-8000-0000000000a1')$$,
  'Access denied',
  '⭐ un inconnu ne coche pas à la place de l''élève'
);
SELECT throws_ok(
  $$SELECT public.get_study_report('e1160000-0000-4000-8000-0000000000a1')$$,
  'Access denied',
  '⭐ un inconnu ne lit pas le bilan'
);
SELECT is(
  (SELECT count(*)::int FROM public.student_class_chapters),
  0,
  '⭐ RLS : un inconnu ne voit aucune déclaration'
);

RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"e1160000-0000-4000-8000-0000000000a2","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  public.set_class_chapters('t116-fr', ARRAY['e1160000-0000-4000-8000-0000000000c5']::uuid[],
                            'e1160000-0000-4000-8000-0000000000a1'),
  1,
  'le parent lié coche F1 pour son enfant'
);
SELECT is(
  (SELECT count(*)::int FROM public.student_class_chapters),
  3,
  'RLS : le parent lié lit les trois déclarations'
);

RESET ROLE;

-- ---------------------------------------------------------
-- 5. Déclaré : ce qui est coché, rien d'autre — et l'état des chapitres.
-- ---------------------------------------------------------
SELECT is(
  (SELECT string_agg(c.title, ',' ORDER BY c.subject_id, c.chapter_rank)
     FROM public.student_study_chapters('e1160000-0000-4000-8000-0000000000a1',
            ARRAY['t116-math', 't116-fr'], DATE '2026-11-22') c
    WHERE c.seen),
  'F1,M1,M3',
  '⭐ déclaré : M2 n''est plus « vu » alors que le calendrier le donnait'
);
SELECT is(
  (SELECT string_agg(c.title || '=' || c.status, ',' ORDER BY c.chapter_rank)
     FROM public.student_study_chapters('e1160000-0000-4000-8000-0000000000a1',
            ARRAY['t116-math'], DATE '2026-11-22') c),
  'M1=fragile,M2=non-commence,M3=non-commence,M4=non-commence',
  'M1 porte une mission ratée : fragile ; les autres ne sont pas commencés'
);
SELECT is(
  (SELECT c.missions_counted || '/' || c.missions_total || ' ' || c.missions_failed
     FROM public.student_study_chapters('e1160000-0000-4000-8000-0000000000a1',
            ARRAY['t116-math'], DATE '2026-11-22') c
    WHERE c.title = 'M1'),
  '1/4 1',
  'M1 : une mission comptée sur quatre, une ratée'
);

-- ---------------------------------------------------------
-- 6. Le programme.
-- ---------------------------------------------------------
SELECT is(
  (SELECT count(*)::int
     FROM public.student_study_plan('e1160000-0000-4000-8000-0000000000a1',
            ARRAY['t116-math', 't116-fr'], public.app_current_day(), 30) p
     JOIN public.chapters c ON c.id = p.chapter_id
    WHERE c.title NOT IN ('M1', 'M3', 'F1')),
  0,
  '⭐ aucune mission hors des chapitres vus en classe'
);
SELECT is(
  (SELECT string_agg(p.kind, ',' ORDER BY p.step)
     FROM public.student_study_plan('e1160000-0000-4000-8000-0000000000a1',
            ARRAY['t116-math', 't116-fr'], public.app_current_day(), 8) p),
  'start,retry',
  '⭐ budget de 8 minutes : deux missions, une par matière — le français jamais travaillé d''abord, puis la reprise de maths'
);
SELECT is(
  (SELECT count(*)::int
     FROM public.student_study_plan('e1160000-0000-4000-8000-0000000000a1',
            ARRAY['t116-math', 't116-fr'], public.app_current_day(), 30) p
    WHERE p.exercise_id = 'e1160000-0000-4000-8000-000000000101'
       OR p.difficulty > 1),
  0,
  'ni la mission déjà comptée, ni une difficulté au-delà de la prochaine étoile'
);
SELECT is(
  (SELECT count(*)::int
     FROM public.student_study_plan('e1160000-0000-4000-8000-0000000000a1',
            ARRAY['t116-math', 't116-fr'], public.app_current_day(), 0) p),
  0,
  'objectif atteint : le programme se tait'
);

-- Une matière PRIORITAIRE passe devant, chaque jour (migration 20261122180000).
SET LOCAL "request.jwt.claims" = '{"sub":"e1160000-0000-4000-8000-0000000000a1","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT is(
  public.set_study_preferences(NULL, ARRAY['t116-math']) ->> 'focusSubjectIds',
  '["t116-math"]',
  'l''élève choisit les maths comme matière prioritaire'
);
RESET ROLE;
SELECT is(
  (SELECT string_agg(p.kind, ',' ORDER BY p.step)
     FROM public.student_study_plan('e1160000-0000-4000-8000-0000000000a1',
            ARRAY['t116-math', 't116-fr'], public.app_current_day(), 8) p),
  'retry,start',
  '⭐ la matière prioritaire ouvre le programme — avant, le français jamais travaillé passait devant'
);

-- L'élève rejoue A2 aujourd'hui (toujours ratée) et travaille dix minutes.
INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant)
VALUES ('e1160000-0000-4000-8000-0000000000a1', 'e1160000-0000-4000-8000-000000000102', 't116-math', 4, 10, 40, 90, 0, 'classic');
INSERT INTO public.learning_pulses (user_id, surface, active_seconds, occurred_at) VALUES
  ('e1160000-0000-4000-8000-0000000000a1', 'exercise', 300, now()),
  ('e1160000-0000-4000-8000-0000000000a1', 'lesson', 300, now()),
  ('e1160000-0000-4000-8000-0000000000a1', 'browse', 300, now());

SELECT is(
  (SELECT count(*)::int
     FROM public.student_study_plan('e1160000-0000-4000-8000-0000000000a1',
            ARRAY['t116-math', 't116-fr'], public.app_current_day(), 30) p
    WHERE p.exercise_id = 'e1160000-0000-4000-8000-000000000102'),
  0,
  'une mission jouée aujourd''hui ne revient pas le jour même'
);

-- ---------------------------------------------------------
-- 7. La lecture — l'élève, puis son parent.
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"e1160000-0000-4000-8000-0000000000a1","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT (r->>'targetMinutes') || ' ' || (r->>'doneMinutes') || ' ' || jsonb_array_length(r->'subjects')
     FROM public.get_study_report() r),
  '30 10 2',
  '⭐ l''élève lit son bilan : objectif 30, dix minutes mesurées (navigation exclue), deux matières'
);
SELECT is(
  (SELECT (s->>'declared') || ' ' || (s->>'chaptersSeen') || '/' || (s->>'chaptersTotal')
          || ' ' || (s->>'level') || ' ' || jsonb_array_length(s->'chapters')
     FROM public.get_study_report() r, jsonb_array_elements(r->'subjects') s
    WHERE s->>'id' = 't116-math'),
  'true 2/4 a-renforcer 4',
  'maths : déclaré, 2 chapitres vus sur 4, niveau à renforcer (trois missions sous 60 % de moyenne)'
);
SELECT is(
  (SELECT (t->>'exerciseId') || ' ' || (t->>'scorePct')
     FROM public.get_study_report() r, jsonb_array_elements(r->'today') t),
  'e1160000-0000-4000-8000-000000000102 40',
  'ce qui a été fait aujourd''hui figure au bilan'
);

RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"e1160000-0000-4000-8000-0000000000a2","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT (r->>'studentId') || ' ' || jsonb_typeof(r->'subjects'->0->'chapters')
          || ' ' || (jsonb_array_length(r->'plan') > 0)
     FROM public.get_study_report('e1160000-0000-4000-8000-0000000000a1', false) r),
  'e1160000-0000-4000-8000-0000000000a1 null true',
  '⭐ le parent lié lit le même bilan ; sans le détail des chapitres quand on ne le demande pas'
);

RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"e1160000-0000-4000-8000-0000000000a1","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  public.set_class_chapters('t116-math', ARRAY[]::uuid[]),
  0,
  'l''élève décoche tout en maths'
);
SELECT is(
  (SELECT s->>'declared'
     FROM public.get_study_report() r, jsonb_array_elements(r->'subjects') s
    WHERE s->>'id' = 't116-math'),
  'false',
  'une liste vide rend la matière à l''estimation du calendrier'
);

RESET ROLE;

-- ---------------------------------------------------------
-- 8. Les réglages : objectif quotidien et matières prioritaires.
-- ---------------------------------------------------------
SELECT ok(
  has_table_privilege('authenticated', 'public.study_preferences', 'SELECT')
  AND NOT has_table_privilege('authenticated', 'public.study_preferences', 'INSERT')
  AND NOT has_table_privilege('authenticated', 'public.study_preferences', 'UPDATE')
  AND NOT has_function_privilege('authenticated', 'public.study_target_minutes(uuid)', 'EXECUTE')
  AND NOT has_function_privilege('authenticated', 'public.study_focus_subject_ids(uuid)', 'EXECUTE')
  AND has_function_privilege('authenticated', 'public.set_study_preferences(integer,text[],uuid)', 'EXECUTE')
  AND NOT has_function_privilege('anon', 'public.set_study_preferences(integer,text[],uuid)', 'EXECUTE'),
  '⭐ les réglages se lisent, ils ne s''écrivent que par la RPC ; les lectures internes ne sont pas des RPC'
);

SET LOCAL "request.jwt.claims" = '{"sub":"e1160000-0000-4000-8000-0000000000a3","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT throws_ok(
  $$SELECT public.set_study_preferences(60, NULL, 'e1160000-0000-4000-8000-0000000000a1')$$,
  'Access denied',
  '⭐ un inconnu ne règle pas le programme d''un élève'
);
RESET ROLE;

SET LOCAL "request.jwt.claims" = '{"sub":"e1160000-0000-4000-8000-0000000000a1","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT throws_ok(
  $$SELECT public.set_study_preferences(20)$$,
  'Daily minutes out of range',
  '⭐ trente minutes sont un plancher : l''objectif ne descend pas dessous'
);
SELECT throws_ok(
  $$SELECT public.set_study_preferences(NULL, ARRAY['t116-math', 't116-fr', 't116-hors'])$$,
  'Too many focus subjects',
  'deux matières prioritaires au plus'
);
SELECT throws_ok(
  $$SELECT public.set_study_preferences(NULL, ARRAY['t116-hors'])$$,
  'Unknown subject for this parcours',
  'une matière hors du parcours n''est pas prioritaire'
);
SELECT is(
  public.set_study_preferences(45) ->> 'dailyMinutes',
  '45',
  'l''élève monte son objectif à 45 minutes'
);
SELECT is(
  (SELECT (r->>'targetMinutes') || ' '
          || (SELECT string_agg(s->>'id', ',' ORDER BY s->>'id')
                FROM jsonb_array_elements(r->'subjects') s WHERE (s->>'focus')::boolean)
     FROM public.get_study_report(NULL, false) r),
  '45 t116-math',
  '⭐ le bilan porte l''objectif de l''élève et marque sa matière prioritaire'
);
RESET ROLE;

SET LOCAL "request.jwt.claims" = '{"sub":"e1160000-0000-4000-8000-0000000000a2","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT is(
  (SELECT (j->>'dailyMinutes') || ' ' || (j->'focusSubjectIds')::text
     FROM public.set_study_preferences(60, NULL, 'e1160000-0000-4000-8000-0000000000a1') j),
  '60 ["t116-math"]',
  'le parent lié règle l''objectif de son enfant ; un réglage non donné reste inchangé'
);
RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
