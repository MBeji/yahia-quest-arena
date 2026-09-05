-- =========================================================
-- Suivi parental — CE QUI MANQUE à un chapitre pour compter.
-- ---------------------------------------------------------
-- Signalement du 2026-09-04 : « mon fils a fait tous les exercices de maths
-- 9ème et j'ai 3/20 chap. ». Le chiffre était JUSTE — ses chapitres étaient à
-- « 4/6 missions ». Ce qui manquait, c'était le RECOURS : le suivi donnait un
-- verdict sans jamais dire quel geste le lèverait.
--
-- ⚠️ CE QUE CE FICHIER PROTÈGE AVANT TOUT — l'accord des DEUX définitions.
-- `student_chapter_gaps` répond « pourquoi ce chapitre ne compte pas » et
-- `student_parcours_progress` produit le « 3/20 ». Si l'une dérivait sans
-- l'autre, le parent lirait « il ne manque rien » sous un « 3/20 », ce qui est
-- pire que le silence d'aujourd'hui. L'assertion 6 les confronte sur le MÊME
-- décor plutôt que de s'en remettre à un commentaire.
--
-- Les trois formes de blocage, chacune avec son décor :
--   CH-A — 6 missions, 4 réussies, quiz passé proprement  → il manque 2 missions
--   CH-B — 3 missions toutes réussies, quiz EXPÉDIÉ       → il ne manque QUE le quiz
--   CH-C — 2 missions toutes réussies, quiz passé          → complet, donc absent
--
-- Tout est annulé à la fin.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(8);

INSERT INTO auth.users (id, email) VALUES
  ('c9000000-0000-0000-0000-0000000000aa', 'gaps-student@test.local');

INSERT INTO public.profiles (id, display_name, role) VALUES
  ('c9000000-0000-0000-0000-0000000000aa', 'GapsStudent', 'student')
ON CONFLICT (id) DO UPDATE SET role = EXCLUDED.role;

-- Une matière SCOLAIRE (elle porte un niveau) : c'est ce qui rend ses chapitres
-- quiz-gatés. Sans niveau, le quiz ne bloquerait rien et CH-B serait complet.
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('gaps-theme', 'Thème lacunes', 'book', 'primary', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.grades (id, theme_id, slug, name_fr, display_order)
VALUES ('c9000000-0000-0000-0000-0000000000e9'::uuid, 'gaps-theme', 'gaps-9', '9ème', 9)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.subjects (id, theme_id, grade_id, name_fr, attribute, color_token, icon)
VALUES ('gaps-math', 'gaps-theme', 'c9000000-0000-0000-0000-0000000000e9'::uuid,
        'Maths lacunes', 'logic', 'primary', 'sigma');

INSERT INTO public.chapters (id, subject_id, title, display_order) VALUES
  ('c9000000-0000-0000-0000-00000000000a', 'gaps-math', 'CH-A', 1),
  ('c9000000-0000-0000-0000-00000000000b', 'gaps-math', 'CH-B', 2),
  ('c9000000-0000-0000-0000-00000000000c', 'gaps-math', 'CH-C', 3);

-- Missions de catalogue.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, display_order)
SELECT ('c9000000-0000-0000-0000-0000000001' || lpad(i::text, 2, '0'))::uuid,
       'c9000000-0000-0000-0000-00000000000a', 'gaps-math', 'A' || i, 'practice', 'admin', i
  FROM generate_series(1, 6) i;
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, display_order)
SELECT ('c9000000-0000-0000-0000-0000000002' || lpad(i::text, 2, '0'))::uuid,
       'c9000000-0000-0000-0000-00000000000b', 'gaps-math', 'B' || i, 'practice', 'admin', i
  FROM generate_series(1, 3) i;
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, display_order)
SELECT ('c9000000-0000-0000-0000-0000000003' || lpad(i::text, 2, '0'))::uuid,
       'c9000000-0000-0000-0000-00000000000c', 'gaps-math', 'C' || i, 'practice', 'admin', i
  FROM generate_series(1, 2) i;

-- Un quiz de compréhension par chapitre.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, display_order) VALUES
  ('c9000000-0000-0000-0000-0000000009a1', 'c9000000-0000-0000-0000-00000000000a', 'gaps-math', 'quiz A', 'quiz', 'admin', 0),
  ('c9000000-0000-0000-0000-0000000009b1', 'c9000000-0000-0000-0000-00000000000b', 'gaps-math', 'quiz B', 'quiz', 'admin', 0),
  ('c9000000-0000-0000-0000-0000000009c1', 'c9000000-0000-0000-0000-00000000000c', 'gaps-math', 'quiz C', 'quiz', 'admin', 0);

-- CH-A : 4 missions sur 6. CH-B et CH-C : toutes.
INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant)
SELECT 'c9000000-0000-0000-0000-0000000000aa',
       ('c9000000-0000-0000-0000-0000000001' || lpad(i::text, 2, '0'))::uuid,
       'gaps-math', 8, 10, 80, 90, 0, 'classic'
  FROM generate_series(1, 4) i;
INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant)
SELECT 'c9000000-0000-0000-0000-0000000000aa',
       ('c9000000-0000-0000-0000-0000000002' || lpad(i::text, 2, '0'))::uuid,
       'gaps-math', 8, 10, 80, 90, 0, 'classic'
  FROM generate_series(1, 3) i;
INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant)
SELECT 'c9000000-0000-0000-0000-0000000000aa',
       ('c9000000-0000-0000-0000-0000000003' || lpad(i::text, 2, '0'))::uuid,
       'gaps-math', 8, 10, 80, 90, 0, 'classic'
  FROM generate_series(1, 2) i;

-- Les quiz : A et C passés proprement (10 questions, 120 s), B EXPÉDIÉ (20 s).
INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant) VALUES
  ('c9000000-0000-0000-0000-0000000000aa', 'c9000000-0000-0000-0000-0000000009a1', 'gaps-math', 10, 10, 100, 120, 0, 'classic'),
  ('c9000000-0000-0000-0000-0000000000aa', 'c9000000-0000-0000-0000-0000000009b1', 'gaps-math', 10, 10, 100, 20, 0, 'classic'),
  ('c9000000-0000-0000-0000-0000000000aa', 'c9000000-0000-0000-0000-0000000009c1', 'gaps-math', 10, 10, 100, 120, 0, 'classic');

-- ---------------------------------------------------------
-- 1-2. Un chapitre COMPLET n'a rien à demander.
-- ---------------------------------------------------------
SELECT is(
  (SELECT count(*)::int FROM public.student_chapter_gaps(
     'c9000000-0000-0000-0000-0000000000aa', ARRAY['gaps-math'], 99)),
  2,
  'Deux chapitres incomplets sur trois — CH-C, maîtrisé, ne figure pas dans les lacunes'
);

SELECT is(
  (SELECT count(*)::int FROM public.student_chapter_gaps(
     'c9000000-0000-0000-0000-0000000000aa', ARRAY['gaps-math'], 99) g
    WHERE g.title = 'CH-C'),
  0,
  'CH-C est absent nommément'
);

-- ---------------------------------------------------------
-- 3-4. Les missions manquantes sont comptées, pas devinées.
-- ---------------------------------------------------------
SELECT is(
  (SELECT g.missions_passed || '/' || g.missions_total
     FROM public.student_chapter_gaps('c9000000-0000-0000-0000-0000000000aa', ARRAY['gaps-math'], 99) g
    WHERE g.title = 'CH-A'),
  '4/6',
  'CH-A rend « 4/6 » — exactement ce que le hub de l''élève affiche'
);

SELECT ok(
  (SELECT g.quiz_satisfied
     FROM public.student_chapter_gaps('c9000000-0000-0000-0000-0000000000aa', ARRAY['gaps-math'], 99) g
    WHERE g.title = 'CH-A'),
  'CH-A ne bloque QUE sur ses missions : son quiz est validé'
);

-- ---------------------------------------------------------
-- 5. ⚠️ LA PORTE INVISIBLE : 3/3 missions et le chapitre ne compte toujours pas,
--    parce que le quiz a été expédié (10 questions en 20 s, soit 2 s/question).
--    Aucun écran ne le disait avant ce lot.
-- ---------------------------------------------------------
SELECT results_eq(
  $$SELECT g.missions_passed, g.missions_total, g.quiz_gated, g.quiz_satisfied
      FROM public.student_chapter_gaps('c9000000-0000-0000-0000-0000000000aa', ARRAY['gaps-math'], 99) g
     WHERE g.title = 'CH-B'$$,
  $$VALUES (3, 3, true, false)$$,
  'CH-B : toutes ses missions réussies, et il manque le quiz — non pas raté, EXPÉDIÉ'
);

-- ---------------------------------------------------------
-- 6. ⭐ L'ACCORD DES DEUX DÉFINITIONS. « Aucune lacune » et « chapitre complet »
--    doivent désigner le même ensemble. C'est l'assertion qui empêche que le
--    parent lise « il ne manque rien » sous un « 3/20 ».
-- ---------------------------------------------------------
SELECT is(
  (SELECT chapters_completed FROM public.student_parcours_progress(
     'c9000000-0000-0000-0000-0000000000aa', ARRAY['gaps-math'])),
  (SELECT count(*)::int FROM public.chapters c
    WHERE c.subject_id = 'gaps-math'
      AND EXISTS (SELECT 1 FROM public.exercises e
                   WHERE e.chapter_id = c.id AND e.source = 'admin' AND e.mode IS DISTINCT FROM 'quiz')
      AND NOT EXISTS (SELECT 1 FROM public.student_chapter_gaps(
                        'c9000000-0000-0000-0000-0000000000aa', ARRAY['gaps-math'], 999) g
                       WHERE g.chapter_id = c.id)),
  'Les chapitres sans lacune sont EXACTEMENT ceux que la carte /parcours compte'
);

-- ---------------------------------------------------------
-- 7. Le plus proche du but en premier — c'est ce qui rend la carte actionnable.
--    CH-B est à UN geste, CH-A à deux missions.
-- ---------------------------------------------------------
SELECT is(
  (SELECT string_agg(g.title, ',' ORDER BY g.title)
     FROM (SELECT * FROM public.student_chapter_gaps(
             'c9000000-0000-0000-0000-0000000000aa', ARRAY['gaps-math'], 1)) g),
  'CH-B',
  'Borné à un par matière, c''est le chapitre le plus proche du but qui sort'
);

-- ---------------------------------------------------------
-- 8. La fonction est INTERNE : un élève ne lit pas les lacunes d'un autre.
-- ---------------------------------------------------------
SELECT ok(
  NOT has_function_privilege('authenticated', 'public.student_chapter_gaps(uuid, text[], int)', 'EXECUTE'),
  'student_chapter_gaps est REVOKEd de authenticated — seules les enveloppes définer y accèdent'
);

SELECT * FROM finish();
ROLLBACK;
