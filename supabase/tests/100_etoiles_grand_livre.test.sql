-- =========================================================
-- LE GRAND LIVRE — L'INVARIANT QUI FONDE L'ÉTUDE 34 (lot 1).
-- ---------------------------------------------------------
-- ⭐ C'est le KPI-1 de l'étude, et ce fichier EST sa preuve : « aucun statut
-- acquis ne disparaît d'un écran après une application de contenu ».
--
-- Le défaut qu'il ferme, mesuré avant l'étude : la complétion d'un chapitre
-- était recalculée à chaque lecture sur `exercises`. Ajouter une mission
-- dé-complétait le chapitre pour tous ceux qui l'avaient fini ; ajouter un
-- chapitre faisait chuter la matière ; ajouter un quiz refermait la porte
-- rétroactivement ; un élagage effaçait les tentatives. Quatre façons de faire
-- reculer un élève qui n'avait rien fait de mal.
--
-- Le décor est le plus simple possible — une matière, un chapitre, une mission —
-- pour que chaque assertion ne puisse échouer que d'UNE façon. On lui inflige
-- ensuite les quatre événements, dans l'ordre, et on vérifie après chacun que
-- le GRAND LIVRE n'a pas bougé pendant que le VIVANT, lui, redescend.
--
-- Tout est annulé à la fin.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(17);

INSERT INTO auth.users (id, email) VALUES
  ('ea000000-0000-0000-0000-0000000000aa', 'grandlivre@test.local'),
  ('ea000000-0000-0000-0000-0000000000bb', 'grandlivre-autre@test.local');

INSERT INTO public.profiles (id, display_name, role) VALUES
  ('ea000000-0000-0000-0000-0000000000aa', 'GrandLivre', 'student'),
  ('ea000000-0000-0000-0000-0000000000bb', 'GrandLivreAutre', 'student')
ON CONFLICT (id) DO UPDATE SET role = EXCLUDED.role;

INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('gl-theme', 'Thème grand livre', 'book', 'primary', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.grades (id, theme_id, slug, name_fr, display_order)
VALUES ('ea000000-0000-0000-0000-0000000000e9'::uuid, 'gl-theme', 'gl-9', '9ème', 9)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.subjects (id, theme_id, grade_id, name_fr, attribute, color_token, icon)
VALUES ('gl-math', 'gl-theme', 'ea000000-0000-0000-0000-0000000000e9'::uuid,
        'Maths grand livre', 'logic', 'primary', 'sigma');

INSERT INTO public.chapters (id, subject_id, title, display_order) VALUES
  ('ea000000-0000-0000-0000-00000000000a', 'gl-math', 'GL-A', 1);

INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, difficulty, display_order) VALUES
  ('ea000000-0000-0000-0000-00000000a001', 'ea000000-0000-0000-0000-00000000000a', 'gl-math', 'A d1', 'practice', 'admin', 1, 1),
  ('ea000000-0000-0000-0000-0000000009a1', 'ea000000-0000-0000-0000-00000000000a', 'gl-math', 'quiz A', 'quiz', 'admin', 1, 0);

-- L'élève fait tout : quiz posé, puis mission réussie. Le trigger inscrit.
--
-- ⚠️ DEUX INSTRUCTIONS SÉPARÉES, et datées dans le PASSÉ. Deux raisons, toutes
-- deux des propriétés de Postgres qu'un décor de test doit respecter pour rester
-- fidèle à la production :
--   * un AFTER INSERT ... FOR EACH ROW sur un INSERT à plusieurs VALUES ne se
--     déclenche qu'une fois TOUTES les lignes posées — la première tentative
--     « verrait » donc la seconde, ce qui n'arrive jamais en vrai (une
--     soumission = une ligne) ;
--   * `now()` est l'horloge de la TRANSACTION : un contenu ajouté « plus tard »
--     dans le même test porterait exactement la même date, et aucune nouveauté
--     ✨ ne serait détectable.
INSERT INTO public.attempts (id, user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant, completed_at) VALUES
  ('ea000000-0000-0000-0000-00000000aa01', 'ea000000-0000-0000-0000-0000000000aa', 'ea000000-0000-0000-0000-0000000009a1', 'gl-math', 10, 10, 100, 120, 0, 'classic', now() - INTERVAL '3 days');
INSERT INTO public.attempts (id, user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant, completed_at) VALUES
  ('ea000000-0000-0000-0000-00000000aa02', 'ea000000-0000-0000-0000-0000000000aa', 'ea000000-0000-0000-0000-00000000a001', 'gl-math',  6,  6, 100,  60, 0, 'classic', now() - INTERVAL '2 days');

-- ---------------------------------------------------------
-- 1-3. L'état de départ : maîtrisé, inscrit, et daté par sa tentative.
-- ---------------------------------------------------------
SELECT is(
  (SELECT MAX(star)::INT FROM public.user_chapter_stars
    WHERE user_id = 'ea000000-0000-0000-0000-0000000000aa'),
  4,
  'Le trigger a inscrit les quatre étoiles : le chapitre est maîtrisé'
);

SELECT is(
  (SELECT chapters_completed FROM public.student_parcours_progress(
     'ea000000-0000-0000-0000-0000000000aa', ARRAY['gl-math'])),
  1,
  'La carte /parcours et le suivi parental comptent 1 chapitre maîtrisé'
);

SELECT is(
  (SELECT attempt_id FROM public.user_chapter_stars
    WHERE user_id = 'ea000000-0000-0000-0000-0000000000aa' AND star = 4),
  'ea000000-0000-0000-0000-00000000aa02'::uuid,
  'Chaque étoile porte la tentative qui l''a fait tomber — le delta est lisible'
);

-- ---------------------------------------------------------
-- 4-6. ⭐ ÉVÉNEMENT 1 — UNE CAMPAGNE AJOUTE UNE MISSION ⭐⭐⭐.
--      Avant l'étude : le chapitre se dé-complétait pour tout le monde.
-- ---------------------------------------------------------
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, difficulty, display_order, created_at) VALUES
  ('ea000000-0000-0000-0000-00000000a002', 'ea000000-0000-0000-0000-00000000000a', 'gl-math', 'A d3 (neuve)', 'boss', 'admin', 3, 2, now());

SELECT is(
  (SELECT MAX(star)::INT FROM public.user_chapter_stars
    WHERE user_id = 'ea000000-0000-0000-0000-0000000000aa'),
  4,
  '⭐ Le grand livre ne bouge pas : l''élève garde ses quatre étoiles'
);

SELECT is(
  public.chapter_star_live('ea000000-0000-0000-0000-0000000000aa', 'ea000000-0000-0000-0000-00000000000a')::INT,
  2,
  'Le VIVANT, lui, redescend à 2 — le premier cran non franchi est désormais ⭐⭐⭐'
);

SELECT is(
  (SELECT SUM(r.missions_new)::INT FROM public.chapter_star_rungs(
     'ea000000-0000-0000-0000-0000000000aa', 'ea000000-0000-0000-0000-00000000000a') r),
  1,
  'L''écart est NOMMÉ : une nouveauté ✨, pas une régression muette (R-7)'
);

-- ---------------------------------------------------------
-- 7-8. ÉVÉNEMENT 2 — UN CHAPITRE EST AJOUTÉ À LA MATIÈRE.
-- ---------------------------------------------------------
INSERT INTO public.chapters (id, subject_id, title, display_order, created_at) VALUES
  ('ea000000-0000-0000-0000-00000000000b', 'gl-math', 'GL-B (neuf)', 2, now());
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, difficulty, display_order, created_at) VALUES
  ('ea000000-0000-0000-0000-00000000b001', 'ea000000-0000-0000-0000-00000000000b', 'gl-math', 'B d1', 'practice', 'admin', 1, 1, now());

SELECT is(
  (SELECT chapters_completed FROM public.student_parcours_progress(
     'ea000000-0000-0000-0000-0000000000aa', ARRAY['gl-math'])),
  1,
  '⭐ Le NUMÉRATEUR ne baisse pas : le chapitre maîtrisé le reste'
);

SELECT is(
  (SELECT new_chapters FROM public.student_subject_stars(
     'ea000000-0000-0000-0000-0000000000aa', ARRAY['gl-math'])),
  1,
  'Le dénominateur grandit, et le chapitre neuf est annoncé comme tel (✨)'
);

-- ---------------------------------------------------------
-- 9-10. ÉVÉNEMENT 3 — UN SECOND QUIZ ARRIVE. La porte ne se referme pas
--       rétroactivement sur ce qui est déjà acquis.
-- ---------------------------------------------------------
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, difficulty, display_order, created_at) VALUES
  ('ea000000-0000-0000-0000-0000000009a2', 'ea000000-0000-0000-0000-00000000000a', 'gl-math', 'quiz A bis', 'quiz', 'admin', 1, 0, now());

SELECT is(
  (SELECT MAX(star)::INT FROM public.user_chapter_stars
    WHERE user_id = 'ea000000-0000-0000-0000-0000000000aa'),
  4,
  '⭐ Un quiz de plus ne retire aucune étoile'
);

SELECT ok(
  public.chapter_quiz_cleared('ea000000-0000-0000-0000-0000000000aa', 'ea000000-0000-0000-0000-00000000000a'),
  'Et la porte reste franchie : n''importe lequel des quiz suffit (arena#1005, inchangé)'
);

-- ---------------------------------------------------------
-- 11-12. ⭐ ÉVÉNEMENT 4 — LE PIPELINE ÉLAGUE LA MISSION. Ses tentatives
--        partent en CASCADE : avant l'étude, ce que l'élève avait réussi
--        n'existait plus nulle part.
-- ---------------------------------------------------------
DELETE FROM public.exercises WHERE id = 'ea000000-0000-0000-0000-00000000a001';

SELECT is(
  (SELECT MAX(star)::INT FROM public.user_chapter_stars
    WHERE user_id = 'ea000000-0000-0000-0000-0000000000aa'),
  4,
  '⭐ La ligne du grand livre SURVIT à la suppression de la mission'
);

SELECT is(
  (SELECT attempt_id FROM public.user_chapter_stars
    WHERE user_id = 'ea000000-0000-0000-0000-0000000000aa' AND star = 4),
  NULL,
  'Elle perd seulement son justificatif (ON DELETE SET NULL, jamais CASCADE)'
);

-- ---------------------------------------------------------
-- 13. Le grand livre est INSERT-ONLY pour tout le monde sauf le trigger.
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"ea000000-0000-0000-0000-0000000000aa","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$DELETE FROM public.user_chapter_stars WHERE star = 4$$,
  '42501',
  NULL,
  'Un client ne peut pas effacer une étoile : aucun DELETE n''est accordé'
);

SELECT throws_ok(
  $$INSERT INTO public.user_chapter_stars (user_id, chapter_id, star, missions_at_reach)
    VALUES ('ea000000-0000-0000-0000-0000000000aa', 'ea000000-0000-0000-0000-00000000000a', 4, 1)$$,
  '42501',
  NULL,
  'Ni s''en offrir une : le seul écrivain est le trigger'
);

-- ---------------------------------------------------------
-- 14-15. RLS : on lit ses étoiles, jamais celles d'un autre élève.
-- ---------------------------------------------------------
SELECT is(
  (SELECT count(*)::INT FROM public.user_chapter_stars),
  4,
  'L''élève voit ses quatre étoiles'
);

RESET ROLE;
INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant) VALUES
  ('ea000000-0000-0000-0000-0000000000bb', 'ea000000-0000-0000-0000-0000000009a1', 'gl-math', 10, 10, 100, 120, 0, 'classic');
INSERT INTO public.attempts (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, variant) VALUES
  ('ea000000-0000-0000-0000-0000000000bb', 'ea000000-0000-0000-0000-00000000a002', 'gl-math',  6,  6, 100,  60, 0, 'classic');

SET LOCAL "request.jwt.claims" = '{"sub":"ea000000-0000-0000-0000-0000000000aa","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::INT FROM public.user_chapter_stars
    WHERE user_id = 'ea000000-0000-0000-0000-0000000000bb'),
  0,
  'Et rien de celles d''un autre — RLS par propriétaire, admin ou parent lié actif'
);

-- ---------------------------------------------------------
-- 16. `anon` n'a aucun accès : la progression n'existe pas sans compte (R-16).
-- ---------------------------------------------------------
RESET ROLE;
SELECT ok(
  NOT has_table_privilege('anon', 'public.user_chapter_stars', 'SELECT'),
  'anon ne lit pas le grand livre — aucune progression sans compte'
);

SELECT * FROM finish();
ROLLBACK;
