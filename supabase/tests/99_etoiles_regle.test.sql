-- =========================================================
-- ÉTOILES DE CHAPITRE — LA RÈGLE (étude 34, lot 1).
-- ---------------------------------------------------------
-- Ce fichier tient R-3 (ce qui COMPTE) et R-4 (ce que ça VAUT), sur les
-- échelles que le corpus porte RÉELLEMENT — comptées le 2026-09-14 sur les
-- 773 chapitres : 1·2·3·3·4 (268 chapitres, l'échelle dominante), 1·2, 3·4 et
-- le cas dégénéré à une seule mission. Une règle d'étoiles qui ne serait
-- vérifiée que sur une échelle complète 1·2·3·4 serait vérifiée sur 5 % du
-- corpus.
--
-- LES SIX DÉCORS, et ce que chacun protège :
--   ST-A  1·2·3·3·4  — l'échelle dominante : l'étoile monte cran par cran
--   ST-B  1·2        — VACUITÉ (D-3) : deux missions réussies = les 4 étoiles
--   ST-C  3·4        — vacuité BORNÉE : sans mission comptée, ZÉRO étoile,
--                      sinon les crans 1 et 2 absents en offriraient deux
--   ST-D  1·2        — le QUIZ expédié ferme tout (é22 R-7, porte inchangée)
--   ST-E  1          — précipitation (R-3) et variante Rappel : aucune ne compte
--   ST-F  1 + parent — la mission de la FAMILLE ne donne jamais d'étoile (R-2)
--
-- Tout est annulé à la fin.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(18);

INSERT INTO auth.users (id, email) VALUES
  ('e4000000-0000-0000-0000-0000000000aa', 'etoiles-eleve@test.local');

INSERT INTO public.profiles (id, display_name, role) VALUES
  ('e4000000-0000-0000-0000-0000000000aa', 'EtoilesEleve', 'student')
ON CONFLICT (id) DO UPDATE SET role = EXCLUDED.role;

-- Une matière SCOLAIRE : c'est le niveau qui rend ses chapitres quiz-gatés.
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('et-theme', 'Thème étoiles', 'star', 'primary', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.grades (id, theme_id, slug, name_fr, display_order)
VALUES ('e4000000-0000-0000-0000-0000000000e9'::uuid, 'et-theme', 'et-9', '9ème', 9)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.subjects (id, theme_id, grade_id, name_fr, attribute, color_token, icon)
VALUES ('et-math', 'et-theme', 'e4000000-0000-0000-0000-0000000000e9'::uuid,
        'Maths étoiles', 'logic', 'primary', 'sigma');

INSERT INTO public.chapters (id, subject_id, title, display_order) VALUES
  ('e4000000-0000-0000-0000-00000000000a', 'et-math', 'ST-A', 1),
  ('e4000000-0000-0000-0000-00000000000b', 'et-math', 'ST-B', 2),
  ('e4000000-0000-0000-0000-00000000000c', 'et-math', 'ST-C', 3),
  ('e4000000-0000-0000-0000-00000000000d', 'et-math', 'ST-D', 4),
  ('e4000000-0000-0000-0000-00000000000e', 'et-math', 'ST-E', 5),
  ('e4000000-0000-0000-0000-00000000000f', 'et-math', 'ST-F', 6);

-- ST-A : l'échelle dominante 1·2·3·3·4.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, difficulty, display_order) VALUES
  ('e4000000-0000-0000-0000-00000000a001', 'e4000000-0000-0000-0000-00000000000a', 'et-math', 'A d1',  'practice',  'admin', 1, 1),
  ('e4000000-0000-0000-0000-00000000a002', 'e4000000-0000-0000-0000-00000000000a', 'et-math', 'A d2',  'practice',  'admin', 2, 2),
  ('e4000000-0000-0000-0000-00000000a003', 'e4000000-0000-0000-0000-00000000000a', 'et-math', 'A d3a', 'boss',      'admin', 3, 3),
  ('e4000000-0000-0000-0000-00000000a004', 'e4000000-0000-0000-0000-00000000000a', 'et-math', 'A d3b', 'boss',      'admin', 3, 4),
  ('e4000000-0000-0000-0000-00000000a005', 'e4000000-0000-0000-0000-00000000000a', 'et-math', 'A d4',  'challenge', 'admin', 4, 5);

-- ST-B : 1·2 seulement — 57 chapitres du corpus n'ont pas de ⭐, 35 pas de ⭐⭐.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, difficulty, display_order) VALUES
  ('e4000000-0000-0000-0000-00000000b001', 'e4000000-0000-0000-0000-00000000000b', 'et-math', 'B d1', 'practice', 'admin', 1, 1),
  ('e4000000-0000-0000-0000-00000000b002', 'e4000000-0000-0000-0000-00000000000b', 'et-math', 'B d2', 'practice', 'admin', 2, 2);

-- ST-C : 3·4 — aucun cran bas. C'est le décor qui justifie la garde.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, difficulty, display_order) VALUES
  ('e4000000-0000-0000-0000-00000000c001', 'e4000000-0000-0000-0000-00000000000c', 'et-math', 'C d3', 'boss',      'admin', 3, 1),
  ('e4000000-0000-0000-0000-00000000c002', 'e4000000-0000-0000-0000-00000000000c', 'et-math', 'C d4', 'challenge', 'admin', 4, 2);

-- ST-D : 1·2, quiz EXPÉDIÉ.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, difficulty, display_order) VALUES
  ('e4000000-0000-0000-0000-00000000d001', 'e4000000-0000-0000-0000-00000000000d', 'et-math', 'D d1', 'practice', 'admin', 1, 1),
  ('e4000000-0000-0000-0000-00000000d002', 'e4000000-0000-0000-0000-00000000000d', 'et-math', 'D d2', 'practice', 'admin', 2, 2);

-- ST-E : une mission, jouée précipitamment puis en Rappel.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, difficulty, display_order) VALUES
  ('e4000000-0000-0000-0000-00000000e001', 'e4000000-0000-0000-0000-00000000000e', 'et-math', 'E d1', 'practice', 'admin', 1, 1);

-- ST-F : une mission de catalogue NON jouée + une mission de la FAMILLE réussie.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, difficulty, display_order) VALUES
  ('e4000000-0000-0000-0000-00000000f001', 'e4000000-0000-0000-0000-00000000000f', 'et-math', 'F d1',     'practice', 'admin',  1, 1),
  ('e4000000-0000-0000-0000-00000000f002', 'e4000000-0000-0000-0000-00000000000f', 'et-math', 'F famille', 'practice', 'parent', 1, 2);

-- Un quiz par chapitre.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, display_order) VALUES
  ('e4000000-0000-0000-0000-0000000009a1', 'e4000000-0000-0000-0000-00000000000a', 'et-math', 'quiz A', 'quiz', 'admin', 0),
  ('e4000000-0000-0000-0000-0000000009b1', 'e4000000-0000-0000-0000-00000000000b', 'et-math', 'quiz B', 'quiz', 'admin', 0),
  ('e4000000-0000-0000-0000-0000000009c1', 'e4000000-0000-0000-0000-00000000000c', 'et-math', 'quiz C', 'quiz', 'admin', 0),
  ('e4000000-0000-0000-0000-0000000009d1', 'e4000000-0000-0000-0000-00000000000d', 'et-math', 'quiz D', 'quiz', 'admin', 0),
  ('e4000000-0000-0000-0000-0000000009e1', 'e4000000-0000-0000-0000-00000000000e', 'et-math', 'quiz E', 'quiz', 'admin', 0),
  ('e4000000-0000-0000-0000-0000000009f1', 'e4000000-0000-0000-0000-00000000000f', 'et-math', 'quiz F', 'quiz', 'admin', 0);

-- Les quiz : A, B, C, E, F passés proprement (10 questions, 120 s) ; D expédié (20 s).
INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant) VALUES
  ('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-0000000009a1', 'et-math', 10, 10, 100, 120, 0, 'classic'),
  ('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-0000000009b1', 'et-math', 10, 10, 100, 120, 0, 'classic'),
  ('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-0000000009c1', 'et-math', 10, 10, 100, 120, 0, 'classic'),
  ('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-0000000009d1', 'et-math', 10, 10, 100,  20, 0, 'classic'),
  ('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-0000000009e1', 'et-math', 10, 10, 100, 120, 0, 'classic'),
  ('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-0000000009f1', 'et-math', 10, 10, 100, 120, 0, 'classic');

-- ---------------------------------------------------------
-- 1-4. ST-A : l'étoile monte cran par cran, jamais plus haut que le cran suivant.
-- ---------------------------------------------------------
SELECT is(
  public.chapter_star_live('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000000a')::INT,
  0,
  'ST-A : quiz passé mais aucune mission jouée ⇒ zéro étoile'
);

-- la ⭐ seule : le premier cran tombe, pas le second
INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant) VALUES
  ('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000a001', 'et-math', 6, 6, 100, 60, 0, 'classic');

SELECT is(
  public.chapter_star_live('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000000a')::INT,
  1,
  'ST-A : la ⭐ réussie ⇒ étoile 1, et pas davantage'
);

-- la ⭐⭐ puis UN SEUL des deux boss : l'étoile 3 attend le second
INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant) VALUES
  ('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000a002', 'et-math', 6, 6, 100, 60, 0, 'classic'),
  ('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000a003', 'et-math', 6, 6, 100, 60, 0, 'classic');

SELECT is(
  public.chapter_star_live('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000000a')::INT,
  2,
  'ST-A : un boss sur deux ne suffit pas — le cran ⭐⭐⭐ se franchit ENTIER'
);

INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant) VALUES
  ('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000a004', 'et-math', 6, 6, 100, 60, 0, 'classic'),
  ('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000a005', 'et-math', 4, 6,  67, 60, 0, 'classic');

SELECT is(
  public.chapter_star_live('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000000a')::INT,
  4,
  'ST-A : les cinq missions comptées ⇒ étoile 4, « maîtrisé » (Q-2)'
);

-- ---------------------------------------------------------
-- 5-6. ⭐ LA VACUITÉ (D-3), dans les deux sens.
-- ---------------------------------------------------------
INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant) VALUES
  ('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000b001', 'et-math', 6, 6, 100, 60, 0, 'classic'),
  ('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000b002', 'et-math', 6, 6, 100, 60, 0, 'classic');

SELECT is(
  public.chapter_star_live('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000000b')::INT,
  4,
  'ST-B : un chapitre ⭐·⭐⭐ entièrement réussi est MAÎTRISÉ — les crans absents sont franchis'
);

SELECT is(
  (SELECT count(*)::INT FROM public.chapter_star_rungs(
     'e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000000b')),
  2,
  'ST-B : sa jauge n''a que DEUX crans — on n''affiche pas un palier qu''aucun contenu ne permet'
);

-- ---------------------------------------------------------
-- 7-8. ⭐ LA VACUITÉ BORNÉE : sans mission comptée, aucune étoile gratuite.
--      C'est le seul endroit où D-3 devait être arrêtée.
-- ---------------------------------------------------------
SELECT is(
  public.chapter_star_live('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000000c')::INT,
  0,
  'ST-C : un chapitre ⭐⭐⭐·⭐⭐⭐⭐ non joué vaut ZÉRO — pas deux étoiles par vacuité'
);

INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant) VALUES
  ('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000c001', 'et-math', 6, 6, 100, 60, 0, 'classic');

SELECT is(
  public.chapter_star_live('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000000c')::INT,
  3,
  'ST-C : le premier boss réussi donne directement l''étoile 3 (les crans 1-2 n''existent pas)'
);

-- ---------------------------------------------------------
-- 9-10. LE QUIZ reste la porte (é22 R-7) : expédié, il ferme tout.
-- ---------------------------------------------------------
INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant) VALUES
  ('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000d001', 'et-math', 6, 6, 100, 60, 0, 'classic'),
  ('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000d002', 'et-math', 6, 6, 100, 60, 0, 'classic');

SELECT is(
  public.chapter_star_live('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000000d')::INT,
  0,
  'ST-D : toutes les missions réussies et le quiz EXPÉDIÉ ⇒ zéro étoile — la porte invisible'
);

UPDATE public.attempts SET duration_seconds = 120
 WHERE exercise_id = 'e4000000-0000-0000-0000-0000000009d1';

SELECT is(
  public.chapter_star_live('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000000d')::INT,
  4,
  'ST-D : le quiz repassé posément ouvre les quatre étoiles d''un coup'
);

-- ---------------------------------------------------------
-- 11-13. R-3 : ce qui NE compte pas — la précipitation, le Rappel, l'échec.
-- ---------------------------------------------------------
INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant) VALUES
  -- 6 questions en 10 s : sous les 4 s/question du moteur.
  ('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000e001', 'et-math', 6, 6, 100, 10, 0, 'classic');

SELECT ok(
  NOT public.mission_is_counted('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000e001'),
  'Une réussite PRÉCIPITÉE ne compte pas (R-3) — même règle que l''XP et que le quiz'
);

INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant) VALUES
  ('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000e001', 'et-math', 6, 6, 100, 600, 0, 'recall');

SELECT ok(
  NOT public.mission_is_counted('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000e001'),
  'Une reprise en RAPPEL ne compte pas non plus — une étoile se gagne en classique'
);

INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant) VALUES
  ('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000e001', 'et-math', 3, 6, 50, 600, 0, 'classic');

SELECT is(
  public.chapter_star_live('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000000e')::INT,
  0,
  'ST-E : précipité + rappel + échec à 50 % ⇒ toujours zéro étoile'
);

-- ---------------------------------------------------------
-- 14-15. R-2 / Q-5 : la mission de la FAMILLE ne donne jamais d'étoile, et
--        n'entre pas non plus au dénominateur.
-- ---------------------------------------------------------
INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant) VALUES
  ('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000f002', 'et-math', 6, 6, 100, 60, 0, 'classic');

SELECT is(
  public.chapter_star_live('e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000000f')::INT,
  0,
  'ST-F : une mission de la FAMILLE réussie ne donne aucune étoile (R-2, Q-5)'
);

SELECT is(
  (SELECT SUM(r.missions_total)::INT FROM public.chapter_star_rungs(
     'e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000000f') r),
  1,
  'ST-F : elle n''entre pas non plus au dénominateur — la jauge ne compte que le catalogue'
);

-- ---------------------------------------------------------
-- 16. Les crans disent l'état, pas seulement le total.
-- ---------------------------------------------------------
SELECT results_eq(
  $$SELECT r.difficulty::INT, r.missions_total, r.missions_counted
      FROM public.chapter_star_rungs(
        'e4000000-0000-0000-0000-0000000000aa', 'e4000000-0000-0000-0000-00000000000a') r$$,
  $$VALUES (1, 1, 1), (2, 1, 1), (3, 2, 2), (4, 1, 1)$$,
  'ST-A : quatre crans (1, 2, 3×2, 4), chacun avec son compte réel'
);

-- ---------------------------------------------------------
-- 17-18. Les fonctions de règle restent FERMÉES aux clients : elles lisent les
--        tentatives d'un élève arbitraire.
-- ---------------------------------------------------------
SELECT ok(
  NOT has_function_privilege('authenticated', 'public.chapter_star_live(uuid, uuid)', 'EXECUTE'),
  'chapter_star_live est REVOKEd de authenticated'
);

SELECT ok(
  NOT has_function_privilege('authenticated', 'public.mission_is_counted(uuid, uuid)', 'EXECUTE'),
  'mission_is_counted aussi — un élève ne sonde pas la progression d''un autre'
);

SELECT * FROM finish();
ROLLBACK;
