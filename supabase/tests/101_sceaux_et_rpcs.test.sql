-- =========================================================
-- SCEAUX DE MATIÈRE, LES DEUX RPC ÉLÈVE, ET L'ACCORD DES LECTEURS (étude 34).
-- ---------------------------------------------------------
-- Trois choses, dans cet ordre :
--
--   1. LE SCEAU (R-9, D-5) — il tombe quand TOUS les chapitres publiés portent
--      l'étoile, il se calcule sur le GRAND LIVRE, et un chapitre ajouté
--      ensuite ne le retire pas. Sur le vivant, « 19/20 prêts » retomberait à
--      18/20 après une campagne : la régression qu'on vient de supprimer, un
--      étage plus haut.
--   2. LES DEUX RPC ÉLÈVE — `get_subject_progress` (la charge du hub) et
--      `get_attempt_progress` (le delta que l'écran de résultat célèbre), avec
--      leur garde d'accès : self-scopées, propriétaire uniquement.
--   3. ⭐ L'ACCORD DES LECTEURS — `student_chapter_gaps` et
--      `student_parcours_progress` doivent désigner le MÊME ensemble. C'est
--      l'assertion qu'arena#987 avait posée ; elle est reprise ici parce que
--      les deux fonctions ont changé de source en même temps.
--
-- Décor : une matière, DEUX chapitres, échelle 1·2 chacun.
-- Tout est annulé à la fin.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(17);

INSERT INTO auth.users (id, email) VALUES
  ('ec000000-0000-0000-0000-0000000000aa', 'sceaux@test.local'),
  ('ec000000-0000-0000-0000-0000000000bb', 'sceaux-autre@test.local');

INSERT INTO public.profiles (id, display_name, role) VALUES
  ('ec000000-0000-0000-0000-0000000000aa', 'Sceaux', 'student'),
  ('ec000000-0000-0000-0000-0000000000bb', 'SceauxAutre', 'student')
ON CONFLICT (id) DO UPDATE SET role = EXCLUDED.role;

INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('sc-theme', 'Thème sceaux', 'shield', 'primary', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.grades (id, theme_id, slug, name_fr, display_order)
VALUES ('ec000000-0000-0000-0000-0000000000e9'::uuid, 'sc-theme', 'sc-9', '9ème', 9)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.subjects (id, theme_id, grade_id, name_fr, attribute, color_token, icon)
VALUES ('sc-math', 'sc-theme', 'ec000000-0000-0000-0000-0000000000e9'::uuid,
        'Maths sceaux', 'logic', 'primary', 'sigma');

INSERT INTO public.chapters (id, subject_id, title, display_order) VALUES
  ('ec000000-0000-0000-0000-00000000000a', 'sc-math', 'SC-A', 1),
  ('ec000000-0000-0000-0000-00000000000b', 'sc-math', 'SC-B', 2);

INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, difficulty, display_order) VALUES
  ('ec000000-0000-0000-0000-00000000a001', 'ec000000-0000-0000-0000-00000000000a', 'sc-math', 'A d1', 'practice', 'admin', 1, 1),
  ('ec000000-0000-0000-0000-00000000a002', 'ec000000-0000-0000-0000-00000000000a', 'sc-math', 'A d2', 'practice', 'admin', 2, 2),
  ('ec000000-0000-0000-0000-00000000b001', 'ec000000-0000-0000-0000-00000000000b', 'sc-math', 'B d1', 'practice', 'admin', 1, 1),
  ('ec000000-0000-0000-0000-00000000b002', 'ec000000-0000-0000-0000-00000000000b', 'sc-math', 'B d2', 'practice', 'admin', 2, 2),
  ('ec000000-0000-0000-0000-0000000009a1', 'ec000000-0000-0000-0000-00000000000a', 'sc-math', 'quiz A', 'quiz', 'admin', 1, 0),
  ('ec000000-0000-0000-0000-0000000009b1', 'ec000000-0000-0000-0000-00000000000b', 'sc-math', 'quiz B', 'quiz', 'admin', 1, 0);

-- Les deux quiz, puis le chapitre A entier, puis la seule ⭐ de B.
--
-- ⚠️ UNE INSTRUCTION PAR TENTATIVE, et des dates PASSÉES : un AFTER INSERT FOR
-- EACH ROW sur un INSERT à plusieurs VALUES ne se déclenche qu'une fois toutes
-- les lignes posées (la première tentative verrait les suivantes, ce qui
-- n'arrive jamais en production), et `now()` est l'horloge de la TRANSACTION,
-- donc un contenu ajouté « plus tard » dans le même test porterait la même date.
INSERT INTO public.attempts (id, user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant, completed_at) VALUES
  ('ec000000-0000-0000-0000-00000000aa01', 'ec000000-0000-0000-0000-0000000000aa', 'ec000000-0000-0000-0000-0000000009a1', 'sc-math', 10, 10, 100, 120, 0, 'classic', now() - INTERVAL '5 days');
INSERT INTO public.attempts (id, user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant, completed_at) VALUES
  ('ec000000-0000-0000-0000-00000000aa02', 'ec000000-0000-0000-0000-0000000000aa', 'ec000000-0000-0000-0000-0000000009b1', 'sc-math', 10, 10, 100, 120, 0, 'classic', now() - INTERVAL '4 days');
INSERT INTO public.attempts (id, user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant, completed_at) VALUES
  ('ec000000-0000-0000-0000-00000000aa03', 'ec000000-0000-0000-0000-0000000000aa', 'ec000000-0000-0000-0000-00000000a001', 'sc-math',  6,  6, 100,  60, 0, 'classic', now() - INTERVAL '3 days');
INSERT INTO public.attempts (id, user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant, completed_at) VALUES
  ('ec000000-0000-0000-0000-00000000aa04', 'ec000000-0000-0000-0000-0000000000aa', 'ec000000-0000-0000-0000-00000000a002', 'sc-math',  6,  6, 100,  60, 0, 'classic', now() - INTERVAL '2 days');

-- ---------------------------------------------------------
-- 1-2. Un seul chapitre maîtrisé : aucun sceau. Le sceau est LARGE par
--      construction — c'est ce qui en fait une reconnaissance de matière.
-- ---------------------------------------------------------
SELECT is(
  (SELECT count(*)::INT FROM public.user_subject_seals
    WHERE user_id = 'ec000000-0000-0000-0000-0000000000aa'),
  0,
  'Un chapitre sur deux maîtrisé : aucun sceau — il les faut TOUS'
);

SELECT is(
  (SELECT seal_star FROM public.student_subject_stars(
     'ec000000-0000-0000-0000-0000000000aa', ARRAY['sc-math']))::INT,
  NULL,
  'La matière n''a pas encore de sceau'
);

-- La ⭐ de B : le premier cran de TOUS les chapitres est franchi.
INSERT INTO public.attempts (id, user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant, completed_at) VALUES
  ('ec000000-0000-0000-0000-00000000aa05', 'ec000000-0000-0000-0000-0000000000aa', 'ec000000-0000-0000-0000-00000000b001', 'sc-math', 6, 6, 100, 60, 0, 'classic', now() - INTERVAL '1 day');

-- ---------------------------------------------------------
-- 3-5. ⭐ LE SCEAU ⭐ TOMBE — et lui seul.
-- ---------------------------------------------------------
SELECT is(
  (SELECT MAX(star)::INT FROM public.user_subject_seals
    WHERE user_id = 'ec000000-0000-0000-0000-0000000000aa' AND subject_id = 'sc-math'),
  1,
  'Tous les chapitres à l''étoile 1 ⇒ Sceau ⭐'
);

SELECT is(
  (SELECT chapters_at_reach FROM public.user_subject_seals
    WHERE user_id = 'ec000000-0000-0000-0000-0000000000aa' AND star = 1),
  2,
  'Le sceau retient sur combien de chapitres il a été gagné'
);

SET LOCAL "request.jwt.claims" = '{"sub":"ec000000-0000-0000-0000-0000000000aa","role":"authenticated"}';

SELECT is(
  (SELECT (public.get_subject_progress('sc-math') -> 'nextSeal' ->> 'star')::INT),
  2,
  'Le hub annonce le PROCHAIN sceau : ⭐⭐'
);

-- ---------------------------------------------------------
-- 6-7. ⭐ D-5 : UN CHAPITRE AJOUTÉ NE RETIRE PAS LE SCEAU — il change ce qui
--      reste à faire, pas ce qui est acquis.
-- ---------------------------------------------------------
INSERT INTO public.chapters (id, subject_id, title, display_order, created_at) VALUES
  ('ec000000-0000-0000-0000-00000000000c', 'sc-math', 'SC-C (neuf)', 3, now());
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, difficulty, display_order, created_at) VALUES
  ('ec000000-0000-0000-0000-00000000c001', 'ec000000-0000-0000-0000-00000000000c', 'sc-math', 'C d1', 'practice', 'admin', 1, 1, now());

SELECT is(
  (SELECT MAX(star)::INT FROM public.user_subject_seals
    WHERE user_id = 'ec000000-0000-0000-0000-0000000000aa' AND subject_id = 'sc-math'),
  1,
  '⭐ Le Sceau ⭐ reste acquis après l''ajout d''un chapitre'
);

SELECT results_eq(
  $$SELECT chapters_total, chapters_star1, new_chapters
      FROM public.student_subject_stars('ec000000-0000-0000-0000-0000000000aa', ARRAY['sc-math'])$$,
  $$VALUES (3, 2, 1)$$,
  'Mais le prochain sceau sait compter : 2 chapitres prêts sur 3, dont 1 nouveau'
);

-- ---------------------------------------------------------
-- 8-12. `get_subject_progress` — la charge du hub, self-scopée.
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"ec000000-0000-0000-0000-0000000000aa","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT jsonb_array_length(public.get_subject_progress('sc-math') -> 'chapters')),
  3,
  'Le hub reçoit les trois chapitres publiés'
);

SELECT is(
  (SELECT (ch ->> 'star')::INT
     FROM jsonb_array_elements(public.get_subject_progress('sc-math') -> 'chapters') ch
    WHERE ch ->> 'chapterId' = 'ec000000-0000-0000-0000-00000000000a'),
  4,
  'SC-A y est maîtrisé : quatre étoiles sur une échelle ⭐·⭐⭐ (vacuité, D-3)'
);

SELECT is(
  (SELECT jsonb_array_length(ch -> 'rungs')
     FROM jsonb_array_elements(public.get_subject_progress('sc-math') -> 'chapters') ch
    WHERE ch ->> 'chapterId' = 'ec000000-0000-0000-0000-00000000000a'),
  2,
  'Sa jauge n''a que les DEUX crans que le contenu porte'
);

SELECT is(
  (SELECT (public.get_subject_progress('sc-math') -> 'effort' ->> 'missionsCounted')::INT),
  3,
  'L''effort compte les missions réussies — un compteur qui MONTE, jamais un %'
);

SELECT is(
  (SELECT (public.get_subject_progress('sc-math') -> 'effort' ->> 'chaptersMastered')::INT),
  1,
  'Et le nombre de chapitres maîtrisés, au sens de Q-2 : toutes les missions'
);

-- ---------------------------------------------------------
-- 13-15. `get_attempt_progress` — le delta d'une soumission, et sa garde.
-- ---------------------------------------------------------
SELECT is(
  (SELECT (public.get_attempt_progress('ec000000-0000-0000-0000-00000000aa04') ->> 'starBefore')::INT),
  1,
  'La tentative qui a fini SC-A partait de l''étoile 1…'
);

SELECT is(
  (SELECT (public.get_attempt_progress('ec000000-0000-0000-0000-00000000aa04') ->> 'starAfter')::INT),
  4,
  '…et l''a portée à 4 : c''est ce que l''écran de résultat célèbre'
);

SELECT is(
  (SELECT public.get_attempt_progress('ec000000-0000-0000-0000-00000000aa04') -> 'newStars'),
  '[2, 3, 4]'::jsonb,
  'Trois étoiles sont tombées d''un coup — les crans absents sont franchis avec'
);

-- ---------------------------------------------------------
-- 16. La garde : la tentative d'un AUTRE élève ne se lit pas.
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"ec000000-0000-0000-0000-0000000000bb","role":"authenticated"}';

SELECT is(
  public.get_attempt_progress('ec000000-0000-0000-0000-00000000aa04'),
  NULL,
  'Un autre élève ne lit pas le delta d''une tentative qui n''est pas la sienne'
);

-- ---------------------------------------------------------
-- 17. ⭐ L'ACCORD DES DEUX LECTEURS (l'assertion d'arena#987, reprise).
--     « Aucune lacune » et « chapitre maîtrisé » désignent le même ensemble.
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL "request.jwt.claims" = '';

SELECT is(
  (SELECT chapters_completed FROM public.student_parcours_progress(
     'ec000000-0000-0000-0000-0000000000aa', ARRAY['sc-math'])),
  (SELECT count(*)::INT FROM public.chapters c
    WHERE c.subject_id = 'sc-math'
      AND EXISTS (SELECT 1 FROM public.exercises e
                   WHERE e.chapter_id = c.id AND e.source = 'admin' AND e.mode IS DISTINCT FROM 'quiz')
      AND NOT EXISTS (SELECT 1 FROM public.student_chapter_gaps(
                        'ec000000-0000-0000-0000-0000000000aa', ARRAY['sc-math'], 999) g
                       WHERE g.chapter_id = c.id)),
  'Les chapitres sans lacune sont EXACTEMENT ceux que la carte compte maîtrisés'
);

SELECT * FROM finish();
ROLLBACK;
