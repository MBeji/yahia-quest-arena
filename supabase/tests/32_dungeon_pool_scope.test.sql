-- =========================================================
-- Étude 22, lot 5 (R-25) — le donjon est scopé au parcours actif.
-- ---------------------------------------------------------
-- Le pool était le catalogue ENTIER, filtré sur la seule difficulté : un élève de primaire
-- pouvait recevoir des questions de bac en pleine arène. On prouve ici le scope, ses deux
-- replis de profondeur, et les deux exclusions.
--
--   1. classe fournie (>= 60 questions éligibles) → `grade`, et rien hors de la classe ;
--   2. classe mince mais cycle fourni (>= 30)     → `cycle`, et rien hors du cycle ;
--   3. les deux minces                            → `all` (comportement historique) ;
--   4. aucun parcours actif                       → `all` ;
--   5. ni quiz ni mission `source='parent'` ne sont jamais tirés.
--
-- Le point 5 n'est pas cosmétique : la fonction est SECURITY DEFINER et contourne donc la RLS
-- de `exercises`, laquelle réserve les missions familiales à leur auteur, à l'élève ciblé et à
-- son parent. Sans ce filtre, le devoir qu'un parent écrit pour son enfant peut atterrir dans
-- le donjon d'un inconnu.
--
-- Toutes les runs démarrent à l'étage 1 → `v_max_difficulty` = 1 : les fixtures jouables sont
-- donc toutes en difficulté 1. Tout est annulé à la fin.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(8);

-- ---------------------------------------------------------
-- Deux classes du MÊME cycle (collège) + une classe d'un autre cycle (primaire),
-- pour distinguer un repli « cycle » d'un repli « catalogue ».
-- ---------------------------------------------------------
-- Thème DÉDIÉ : la base de test applique toutes les migrations, corpus compris. Sans thème
-- propre, le cycle « college » de nos fixtures engloberait les vraies 7ème/8ème/9ème et leurs
-- milliers de questions — les seuils 60/30 seraient franchis pour de mauvaises raisons.
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('dj-theme', 'DJ Theme', 'Brain', 'subject-math', true);

INSERT INTO public.grades (id, theme_id, slug, name_fr, cycle, display_order)
VALUES
  ('d0000000-0000-0000-0000-0000000a0001'::uuid, 'dj-theme', 'dj-riche', 'DJ Riche', 'college', 901),
  ('d0000000-0000-0000-0000-0000000a0002'::uuid, 'dj-theme', 'dj-voisin', 'DJ Voisin', 'college', 902),
  ('d0000000-0000-0000-0000-0000000a0003'::uuid, 'dj-theme', 'dj-pauvre', 'DJ Pauvre', 'primaire', 903);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id)
VALUES
  ('dj-riche',  'DJ Riche',  'Esprit', 'subject-math', 'Brain', 'dj-theme', 'd0000000-0000-0000-0000-0000000a0001'::uuid),
  ('dj-voisin', 'DJ Voisin', 'Esprit', 'subject-math', 'Brain', 'dj-theme', 'd0000000-0000-0000-0000-0000000a0002'::uuid),
  ('dj-pauvre', 'DJ Pauvre', 'Esprit', 'subject-math', 'Brain', 'dj-theme', 'd0000000-0000-0000-0000-0000000a0003'::uuid);

INSERT INTO public.chapters (id, subject_id, title)
VALUES
  ('d1000000-0000-0000-0000-0000000000c1', 'dj-riche',  'Ch riche'),
  ('d1000000-0000-0000-0000-0000000000c2', 'dj-voisin', 'Ch voisin'),
  ('d1000000-0000-0000-0000-0000000000c3', 'dj-pauvre', 'Ch pauvre');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, mode, source)
VALUES
  ('d2000000-0000-0000-0000-0000000000e1', 'd1000000-0000-0000-0000-0000000000c1', 'dj-riche',  'Ex riche',  1, 'practice', 'admin'),
  ('d2000000-0000-0000-0000-0000000000e2', 'd1000000-0000-0000-0000-0000000000c2', 'dj-voisin', 'Ex voisin', 1, 'practice', 'admin'),
  ('d2000000-0000-0000-0000-0000000000e3', 'd1000000-0000-0000-0000-0000000000c3', 'dj-pauvre', 'Ex pauvre', 1, 'practice', 'admin');

-- Classe riche : 80 questions (>= 60 → pool `grade`).
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, display_order)
SELECT 'd2000000-0000-0000-0000-0000000000e1', 'Riche ' || g,
       '[{"id":"a","text":"a"},{"id":"b","text":"b"}]'::jsonb, 'a', g
FROM generate_series(1, 80) AS g;

-- Classe voisine du même cycle : 40 questions. Seule, elle ne suffirait pas ; c'est elle qui
-- fera basculer un parcours pauvre du même cycle en `cycle`.
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, display_order)
SELECT 'd2000000-0000-0000-0000-0000000000e2', 'Voisin ' || g,
       '[{"id":"a","text":"a"},{"id":"b","text":"b"}]'::jsonb, 'a', g
FROM generate_series(1, 40) AS g;

-- Classe pauvre, cycle primaire, seule de son cycle ici : 5 questions → ni 60 ni 30.
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, display_order)
SELECT 'd2000000-0000-0000-0000-0000000000e3', 'Pauvre ' || g,
       '[{"id":"a","text":"a"},{"id":"b","text":"b"}]'::jsonb, 'a', g
FROM generate_series(1, 5) AS g;

INSERT INTO public.parcours (id, name_fr, kind, theme_id, grade_id)
VALUES
  ('dj-parcours-riche',  'DJ Riche',  'libre', 'dj-theme', 'd0000000-0000-0000-0000-0000000a0001'::uuid),
  ('dj-parcours-voisin', 'DJ Voisin', 'libre', 'dj-theme', 'd0000000-0000-0000-0000-0000000a0002'::uuid),
  ('dj-parcours-pauvre', 'DJ Pauvre', 'libre', 'dj-theme', 'd0000000-0000-0000-0000-0000000a0003'::uuid);

-- =========================================================
-- CASE 1 — classe fournie → pool `grade`, et strictement la classe.
-- =========================================================
INSERT INTO auth.users (id, email) VALUES ('d3333333-0000-0000-0000-000000000001', 'dj-grade@test.local');
INSERT INTO public.profiles (id, display_name, current_parcours_id)
VALUES ('d3333333-0000-0000-0000-000000000001', 'Riche', 'dj-parcours-riche')
ON CONFLICT (id) DO UPDATE SET current_parcours_id = EXCLUDED.current_parcours_id;

INSERT INTO public.dungeon_runs (id, user_id, current_floor, status)
VALUES ('d4000000-0000-0000-0000-000000000001', 'd3333333-0000-0000-0000-000000000001', 1, 'active');

SET LOCAL "request.jwt.claims" = '{"sub":"d3333333-0000-0000-0000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT set_config(
  'test.grade_payload',
  public.get_dungeon_questions('d4000000-0000-0000-0000-000000000001', 5)::text,
  true
);

SELECT is(
  current_setting('test.grade_payload')::jsonb ->> 'poolScope',
  'grade',
  'R-25 : une classe fournie (>= 60 questions éligibles) sert son propre pool'
);

SELECT is(
  (SELECT count(*)::int FROM jsonb_array_elements(current_setting('test.grade_payload')::jsonb -> 'questions')),
  5,
  'le lot demandé est bien servi en entier'
);

SELECT is(
  (SELECT count(DISTINCT elem -> 'exercises' ->> 'subject_id')::int
     FROM jsonb_array_elements(current_setting('test.grade_payload')::jsonb -> 'questions') AS elem
    WHERE elem -> 'exercises' ->> 'subject_id' <> 'dj-riche'),
  0,
  'R-25 : aucune question ne vient d''une autre classe que celle du parcours actif'
);

RESET ROLE;

-- =========================================================
-- CASE 2 — classe mince, cycle fourni → repli `cycle`.
-- La classe « voisin » n'a que 40 questions (< 60), mais son cycle (collège) en totalise
-- 120 avec la classe riche (>= 30).
-- =========================================================
INSERT INTO auth.users (id, email) VALUES ('d3333333-0000-0000-0000-000000000002', 'dj-cycle@test.local');
INSERT INTO public.profiles (id, display_name, current_parcours_id)
VALUES ('d3333333-0000-0000-0000-000000000002', 'Voisin', 'dj-parcours-voisin')
ON CONFLICT (id) DO UPDATE SET current_parcours_id = EXCLUDED.current_parcours_id;

INSERT INTO public.dungeon_runs (id, user_id, current_floor, status)
VALUES ('d4000000-0000-0000-0000-000000000002', 'd3333333-0000-0000-0000-000000000002', 1, 'active');

SET LOCAL "request.jwt.claims" = '{"sub":"d3333333-0000-0000-0000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT set_config(
  'test.cycle_payload',
  public.get_dungeon_questions('d4000000-0000-0000-0000-000000000002', 5)::text,
  true
);

SELECT is(
  current_setting('test.cycle_payload')::jsonb ->> 'poolScope',
  'cycle',
  'R-25 : sous 60 questions, on élargit au cycle plutôt que de servir une arène famélique'
);

SELECT is(
  (SELECT count(*)::int
     FROM jsonb_array_elements(current_setting('test.cycle_payload')::jsonb -> 'questions') AS elem
    WHERE elem -> 'exercises' ->> 'subject_id' NOT IN ('dj-riche', 'dj-voisin')),
  0,
  'R-25 : le repli cycle reste DANS le cycle — jamais une classe du primaire'
);

RESET ROLE;

-- =========================================================
-- CASE 3 — classe ET cycle minces → repli `all` (comportement historique).
-- =========================================================
INSERT INTO auth.users (id, email) VALUES ('d3333333-0000-0000-0000-000000000003', 'dj-all@test.local');
INSERT INTO public.profiles (id, display_name, current_parcours_id)
VALUES ('d3333333-0000-0000-0000-000000000003', 'Pauvre', 'dj-parcours-pauvre')
ON CONFLICT (id) DO UPDATE SET current_parcours_id = EXCLUDED.current_parcours_id;

INSERT INTO public.dungeon_runs (id, user_id, current_floor, status)
VALUES ('d4000000-0000-0000-0000-000000000003', 'd3333333-0000-0000-0000-000000000003', 1, 'active');

SET LOCAL "request.jwt.claims" = '{"sub":"d3333333-0000-0000-0000-000000000003","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  public.get_dungeon_questions('d4000000-0000-0000-0000-000000000003', 5) ->> 'poolScope',
  'all',
  'R-25 : classe et cycle trop minces → catalogue entier, jamais une arène vide'
);

RESET ROLE;

-- =========================================================
-- CASE 4 — aucun parcours actif → `all`.
-- =========================================================
INSERT INTO auth.users (id, email) VALUES ('d3333333-0000-0000-0000-000000000004', 'dj-noparcours@test.local');
INSERT INTO public.profiles (id, display_name, current_parcours_id)
VALUES ('d3333333-0000-0000-0000-000000000004', 'Sans parcours', NULL)
ON CONFLICT (id) DO UPDATE SET current_parcours_id = NULL;

INSERT INTO public.dungeon_runs (id, user_id, current_floor, status)
VALUES ('d4000000-0000-0000-0000-000000000004', 'd3333333-0000-0000-0000-000000000004', 1, 'active');

SET LOCAL "request.jwt.claims" = '{"sub":"d3333333-0000-0000-0000-000000000004","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  public.get_dungeon_questions('d4000000-0000-0000-0000-000000000004', 5) ->> 'poolScope',
  'all',
  'un élève sans parcours actif garde le catalogue entier — le scope ne devient pas un verrou'
);

RESET ROLE;

-- =========================================================
-- CASE 5 — le quiz et la mission familiale sortent du COMPTAGE, donc du pool.
--
-- Tester l'exclusion sur un tirage aléatoire serait flaky : sur un pool de 179 items, l'absence
-- de deux questions dans un lot de 5 ne prouve rien. On la teste donc là où elle est
-- DÉTERMINISTE — le compteur de scope. La classe `dj-limite` porte 59 questions admin
-- non-quiz, 10 questions de quiz et 10 questions de mission familiale :
--   * exclusions appliquées  → 59 < 60 → repli sur le cycle collège (179 >= 30) → `cycle` ;
--   * exclusions défaillantes → 79 >= 60 → `grade`.
-- L'assertion discrimine donc exactement le comportement visé.
-- =========================================================
INSERT INTO public.grades (id, theme_id, slug, name_fr, cycle, display_order)
VALUES ('d0000000-0000-0000-0000-0000000a0004'::uuid, 'dj-theme', 'dj-limite', 'DJ Limite', 'college', 904);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id)
VALUES ('dj-limite', 'DJ Limite', 'Esprit', 'subject-math', 'Brain', 'dj-theme',
        'd0000000-0000-0000-0000-0000000a0004'::uuid);

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('d1000000-0000-0000-0000-0000000000c4', 'dj-limite', 'Ch limite');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, mode, source, target_student_id)
VALUES
  ('d2000000-0000-0000-0000-0000000000e4', 'd1000000-0000-0000-0000-0000000000c4', 'dj-limite', 'Ex limite', 1, 'practice', 'admin', NULL),
  ('d2000000-0000-0000-0000-0000000000q1', 'd1000000-0000-0000-0000-0000000000c4', 'dj-limite', 'Quiz limite', 1, 'quiz', 'admin', NULL),
  ('d2000000-0000-0000-0000-0000000000p1', 'd1000000-0000-0000-0000-0000000000c4', 'dj-limite', 'Devoir de maman', 1, 'practice', 'parent',
   'd3333333-0000-0000-0000-000000000001');

-- 59 admin non-quiz : un cran SOUS le seuil de 60.
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, display_order)
SELECT 'd2000000-0000-0000-0000-0000000000e4', 'Limite ' || g,
       '[{"id":"a","text":"a"},{"id":"b","text":"b"}]'::jsonb, 'a', g
FROM generate_series(1, 59) AS g;

-- 10 + 10 items qui NE DOIVENT PAS compter. S'ils comptaient, le total ferait 79.
INSERT INTO public.questions (exercise_id, prompt, options, correct_option, display_order)
SELECT 'd2000000-0000-0000-0000-0000000000q1', 'Quiz ' || g,
       '[{"id":"a","text":"a"},{"id":"b","text":"b"}]'::jsonb, 'a', g
FROM generate_series(1, 10) AS g;

INSERT INTO public.questions (exercise_id, prompt, options, correct_option, display_order)
SELECT 'd2000000-0000-0000-0000-0000000000p1', 'Familial ' || g,
       '[{"id":"a","text":"a"},{"id":"b","text":"b"}]'::jsonb, 'a', g
FROM generate_series(1, 10) AS g;

INSERT INTO public.parcours (id, name_fr, kind, theme_id, grade_id)
VALUES ('dj-parcours-limite', 'DJ Limite', 'libre', 'dj-theme', 'd0000000-0000-0000-0000-0000000a0004'::uuid);

INSERT INTO auth.users (id, email) VALUES ('d3333333-0000-0000-0000-000000000005', 'dj-exclusions@test.local');
INSERT INTO public.profiles (id, display_name, current_parcours_id)
VALUES ('d3333333-0000-0000-0000-000000000005', 'Limite', 'dj-parcours-limite')
ON CONFLICT (id) DO UPDATE SET current_parcours_id = EXCLUDED.current_parcours_id;

INSERT INTO public.dungeon_runs (id, user_id, current_floor, status)
VALUES ('d4000000-0000-0000-0000-000000000005', 'd3333333-0000-0000-0000-000000000005', 1, 'active');

SET LOCAL "request.jwt.claims" = '{"sub":"d3333333-0000-0000-0000-000000000005","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  public.get_dungeon_questions('d4000000-0000-0000-0000-000000000005', 5) ->> 'poolScope',
  'cycle',
  'quiz et missions familiales sortent du comptage : 59 admin < 60, donc repli cycle (sinon 79 aurait donné grade)'
);

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
