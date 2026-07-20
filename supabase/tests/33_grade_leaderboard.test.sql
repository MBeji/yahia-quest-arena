-- =========================================================
-- Étude 22, lot 4 (R-23) — classement de la cohorte de CLASSE.
-- ---------------------------------------------------------
--   1. la cohorte est le GRADE, pas le parcours : deux parcours du même grade sont pairs (D-5) ;
--   2. un élève d'un AUTRE grade n'y figure pas ;
--   3. `xp = 0` est exclu (cold-start : jamais de rang sans avoir joué) ;
--   4. la ligne de l'appelant est toujours renvoyée, même hors du top demandé ;
--   5. aucun `user_id` de tiers ne sort — seul `is_me` distingue l'appelant ;
--   6. un élève SANS grade reçoit un retour vide, pas une erreur.
--
-- La fonction est SECURITY DEFINER (la policy SELECT de `profiles` ne laisse voir que son
-- propre profil) : ces tests s'exécutent donc en rôle `authenticated`, comme un vrai appel.
-- Tout est annulé à la fin.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(9);

-- ---------------------------------------------------------
-- Deux grades, et deux parcours DIFFERENTS sur le meme grade (le point de D-5).
-- ---------------------------------------------------------
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('gl-theme', 'GL Theme', 'Brain', 'subject-math', true);

INSERT INTO public.grades (id, theme_id, slug, name_fr, cycle, display_order)
VALUES
  ('9a000000-0000-0000-0000-0000000000a1'::uuid, 'gl-theme', 'gl-neuf', 'GL Neuvieme', 'college', 991),
  ('9a000000-0000-0000-0000-0000000000a2'::uuid, 'gl-theme', 'gl-six', 'GL Sixieme', 'primaire', 992);

-- ---------------------------------------------------------
-- CASE 1 — cohorte de grade : deux parcours, un seul classement.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('9b000000-0000-0000-0000-0000000000b1', 'gl-me@test.local'),
  ('9b000000-0000-0000-0000-0000000000b2', 'gl-peer-concours@test.local'),
  ('9b000000-0000-0000-0000-0000000000b3', 'gl-peer-scolaire@test.local'),
  ('9b000000-0000-0000-0000-0000000000b4', 'gl-autre-grade@test.local'),
  ('9b000000-0000-0000-0000-0000000000b5', 'gl-zero-xp@test.local'),
  ('9b000000-0000-0000-0000-0000000000b6', 'gl-sans-grade@test.local');

-- `handle_new_user` cree deja les profils : on ne fait que poser grade, xp et role.
UPDATE public.profiles SET current_grade_id = '9a000000-0000-0000-0000-0000000000a1'::uuid,
       xp = 500, role = 'student', display_name = 'Moi'
 WHERE id = '9b000000-0000-0000-0000-0000000000b1';
UPDATE public.profiles SET current_grade_id = '9a000000-0000-0000-0000-0000000000a1'::uuid,
       xp = 900, role = 'student', display_name = 'Pair concours'
 WHERE id = '9b000000-0000-0000-0000-0000000000b2';
UPDATE public.profiles SET current_grade_id = '9a000000-0000-0000-0000-0000000000a1'::uuid,
       xp = 100, role = 'student', display_name = 'Pair scolaire'
 WHERE id = '9b000000-0000-0000-0000-0000000000b3';
UPDATE public.profiles SET current_grade_id = '9a000000-0000-0000-0000-0000000000a2'::uuid,
       xp = 9999, role = 'student', display_name = 'Autre grade'
 WHERE id = '9b000000-0000-0000-0000-0000000000b4';
UPDATE public.profiles SET current_grade_id = '9a000000-0000-0000-0000-0000000000a1'::uuid,
       xp = 0, role = 'student', display_name = 'Zero XP'
 WHERE id = '9b000000-0000-0000-0000-0000000000b5';
UPDATE public.profiles SET current_grade_id = NULL,
       xp = 700, role = 'student', display_name = 'Sans grade'
 WHERE id = '9b000000-0000-0000-0000-0000000000b6';

SET LOCAL "request.jwt.claims" = '{"sub":"9b000000-0000-0000-0000-0000000000b1","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.get_grade_leaderboard(50)),
  3,
  'la cohorte reunit les trois eleves du grade ayant de l''XP'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_grade_leaderboard(50) g
    WHERE g.display_name = 'Autre grade'),
  0,
  'D-5 : un eleve d''un AUTRE grade n''entre pas dans la cohorte'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_grade_leaderboard(50) g WHERE g.display_name = 'Zero XP'),
  0,
  'cold-start : un eleve a 0 XP n''est jamais classe'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_grade_leaderboard(50) g
    WHERE g.display_name = 'Sans grade'),
  0,
  'un eleve sans grade n''appartient a aucune cohorte'
);

SELECT is(
  (SELECT g.display_name FROM public.get_grade_leaderboard(50) g ORDER BY g.rank LIMIT 1),
  'Pair concours',
  'le classement est trie par XP decroissante'
);

SELECT is(
  (SELECT g.rank::int FROM public.get_grade_leaderboard(50) g WHERE g.is_me),
  2,
  'l''appelant recoit son rang reel dans la cohorte'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_grade_leaderboard(50) g WHERE g.is_me),
  1,
  'exactement une ligne porte is_me — l''appelant n''est jamais duplique'
);

-- ---------------------------------------------------------
-- CASE 2 — la ligne de l'appelant survit a une limite qui l'exclut du top.
-- Avec p_limit = 1, seul « Pair concours » tient dans le board ; l'appelant (rang 2) doit
-- neanmoins etre renvoye, sinon l'ecran ne pourrait plus afficher « ton rang ».
-- ---------------------------------------------------------
SELECT is(
  (SELECT count(*)::int FROM public.get_grade_leaderboard(1) g WHERE g.is_me),
  1,
  'hors du top demande, la ligne de l''appelant est quand meme renvoyee'
);

RESET ROLE;

-- ---------------------------------------------------------
-- CASE 3 — un eleve sans grade obtient un retour VIDE, pas une erreur.
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"9b000000-0000-0000-0000-0000000000b6","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.get_grade_leaderboard(50)),
  0,
  'sans grade : retour vide — le client masque l''onglet, la RPC ne leve pas'
);

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
