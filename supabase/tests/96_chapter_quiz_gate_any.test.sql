-- =========================================================
-- La porte du quiz de compréhension — UNE définition, quatre lecteurs.
-- ---------------------------------------------------------
-- Trois fonctions serveur tiraient « le » quiz d'un chapitre par un `LIMIT 1`
-- SANS `ORDER BY`, quand le client (`quest.server.ts`) débloque dès que
-- N'IMPORTE LEQUEL est passé. Un chapitre à deux quiz suffisait à les faire
-- diverger — et sans qu'aucun test ne tombe, puisqu'un `LIMIT 1` sans ordre rend
-- une ligne parfaitement VALIDE, simplement arbitraire.
--
-- ⚠️ CE QUE CE FICHIER GARDE, ET QUI N'EXISTAIT NULLE PART : le décor à DEUX
-- quiz. C'est le seul décor où l'ancien défaut se voit ; tout le reste de la
-- suite tourne sur des chapitres à quiz unique, où le tirage tombe juste par
-- construction. Un test qui ne peut pas voir la panne qu'il prétend garder n'est
-- pas une garde.
--
-- Tout est annulé à la fin.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(7);

INSERT INTO auth.users (id, email) VALUES
  ('d9000000-0000-0000-0000-0000000000aa', 'twoquiz-student@test.local');

INSERT INTO public.profiles (id, display_name, role) VALUES
  ('d9000000-0000-0000-0000-0000000000aa', 'TwoQuizStudent', 'student')
ON CONFLICT (id) DO UPDATE SET role = EXCLUDED.role;

INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('tq-theme', 'Thème deux quiz', 'book', 'primary', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.grades (id, theme_id, slug, name_fr, display_order)
VALUES ('d9000000-0000-0000-0000-0000000000e9'::uuid, 'tq-theme', 'tq-9', '9ème', 9)
ON CONFLICT (id) DO NOTHING;

-- Une matière SCOLAIRE (gatée) et une matière HORS école (jamais gatée).
INSERT INTO public.subjects (id, theme_id, grade_id, name_fr, attribute, color_token, icon) VALUES
  ('tq-math', 'tq-theme', 'd9000000-0000-0000-0000-0000000000e9'::uuid, 'Maths deux quiz', 'logic', 'primary', 'sigma');
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('tq-extra', 'Extra', 'star', 'primary', false)
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.subjects (id, theme_id, grade_id, name_fr, attribute, color_token, icon) VALUES
  ('tq-culture', 'tq-extra', NULL, 'Culture', 'logic', 'primary', 'globe');

-- CH-1 : une mission réussie, et DEUX quiz dont seul le SECOND est passé.
INSERT INTO public.chapters (id, subject_id, title, display_order) VALUES
  ('d9000000-0000-0000-0000-00000000001a', 'tq-math', 'Deux quiz', 1),
  ('d9000000-0000-0000-0000-00000000001c', 'tq-culture', 'Sans niveau', 1);

INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, display_order) VALUES
  ('d9000000-0000-0000-0000-0000000011a1', 'd9000000-0000-0000-0000-00000000001a', 'tq-math', 'mission', 'practice', 'admin', 1),
  ('d9000000-0000-0000-0000-0000000012a1', 'd9000000-0000-0000-0000-00000000001a', 'tq-math', 'quiz 1', 'quiz', 'admin', 0),
  ('d9000000-0000-0000-0000-0000000012a2', 'd9000000-0000-0000-0000-00000000001a', 'tq-math', 'quiz 2', 'quiz', 'admin', 1),
  ('d9000000-0000-0000-0000-0000000011c1', 'd9000000-0000-0000-0000-00000000001c', 'tq-culture', 'mission', 'practice', 'admin', 1),
  ('d9000000-0000-0000-0000-0000000012c1', 'd9000000-0000-0000-0000-00000000001c', 'tq-culture', 'quiz', 'quiz', 'admin', 0);

INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant) VALUES
  ('d9000000-0000-0000-0000-0000000000aa', 'd9000000-0000-0000-0000-0000000011a1', 'tq-math', 8, 10, 80, 90, 0, 'classic'),
  -- Le SECOND quiz, réussi proprement. Le premier n'est jamais joué.
  ('d9000000-0000-0000-0000-0000000000aa', 'd9000000-0000-0000-0000-0000000012a2', 'tq-math', 10, 10, 100, 120, 0, 'classic'),
  ('d9000000-0000-0000-0000-0000000000aa', 'd9000000-0000-0000-0000-0000000011c1', 'tq-culture', 8, 10, 80, 90, 0, 'classic');

-- ---------------------------------------------------------
-- 1-2. La définition, seule et nommée.
-- ---------------------------------------------------------
SELECT ok(
  public.chapter_quiz_gated('d9000000-0000-0000-0000-00000000001a'),
  'Un chapitre scolaire portant un quiz est gaté'
);

SELECT ok(
  NOT public.chapter_quiz_gated('d9000000-0000-0000-0000-00000000001c'),
  'Une matière SANS niveau n''est jamais gatée — elle n''a pas de théorie à valider, quiz ou pas'
);

-- ---------------------------------------------------------
-- 3. ⭐ LE CŒUR : n'importe LEQUEL des quiz suffit. C'est ce que le hub de
--    l'élève applique depuis toujours ; le serveur s'y aligne enfin.
-- ---------------------------------------------------------
SELECT ok(
  public.chapter_quiz_cleared('d9000000-0000-0000-0000-0000000000aa', 'd9000000-0000-0000-0000-00000000001a'),
  'Le SECOND quiz réussi franchit la porte — un tirage arbitraire pouvait exiger le premier'
);

-- ---------------------------------------------------------
-- 4. Le seuil ne bouge pas d'un point : expédier reste refusé, même sur 2 quiz.
-- ---------------------------------------------------------
UPDATE public.attempts SET duration_seconds = 20
 WHERE exercise_id = 'd9000000-0000-0000-0000-0000000012a2';

SELECT ok(
  NOT public.chapter_quiz_cleared('d9000000-0000-0000-0000-0000000000aa', 'd9000000-0000-0000-0000-00000000001a'),
  'Un quiz expédié (<4 s/question) ne franchit rien, deux quiz ou pas'
);

UPDATE public.attempts SET duration_seconds = 120
 WHERE exercise_id = 'd9000000-0000-0000-0000-0000000012a2';

-- ---------------------------------------------------------
-- 5-6. ⭐ L'ACCORD DES LECTEURS sur le décor à deux quiz — la seule chose qui
--      empêche l'élève, son parent et la console de raconter trois histoires.
-- ---------------------------------------------------------
SELECT is(
  (SELECT chapters_completed FROM public.student_parcours_progress(
     'd9000000-0000-0000-0000-0000000000aa', ARRAY['tq-math'])),
  1,
  'La carte /parcours compte le chapitre : le second quiz vaut le premier'
);

SELECT is(
  (SELECT count(*)::int FROM public.student_chapter_gaps(
     'd9000000-0000-0000-0000-0000000000aa', ARRAY['tq-math'], 99) g
    WHERE g.chapter_id = 'd9000000-0000-0000-0000-00000000001a'),
  0,
  'Et le suivi parental n''y voit plus de lacune — les deux lecteurs sont d''accord'
);

-- ---------------------------------------------------------
-- 7. La définition reste FERMÉE aux clients : elle lit les tentatives d'un
--    élève arbitraire, et c'est une fonction SECURITY DEFINER.
-- ---------------------------------------------------------
SELECT ok(
  NOT has_function_privilege('authenticated', 'public.chapter_quiz_cleared(uuid, uuid)', 'EXECUTE'),
  'chapter_quiz_cleared est REVOKEd de authenticated — un élève ne sonde pas la porte d''un autre'
);

SELECT * FROM finish();
ROLLBACK;
