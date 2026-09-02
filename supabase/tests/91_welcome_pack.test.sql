-- =========================================================
-- Étude 31, lot 6 — L'ACCUEIL (US-9, R-19).
-- ---------------------------------------------------------
-- Constat n° 8 : « le compte naît à ZÉRO ». Trois écrans de choix, aucune
-- question jouée, aucune récompense, et une fin qui renvoie vers un tableau de
-- bord vide.
--
-- Deux propriétés, et la première est celle qui coûte si elle tombe :
--
--   1. ⭐ LA RÉCOMPENSE NE SE VERSE QU'UNE FOIS. Un double clic, un rejeu réseau,
--      un retour arrière du navigateur : trois façons d'appeler deux fois. La
--      garde est un `UPDATE … WHERE welcome_pack_at IS NULL`, donc le second
--      appel ne trouve plus de ligne — et non un `SELECT` suivi d'un `INSERT`,
--      que deux appels simultanés passeraient tous les deux.
--   2. ⭐ LA FIN DE L'ACCUEIL EST UNE ACTION, pas un menu : la même fonction rend
--      la première quête ABORDABLE du parcours choisi (difficulté 1 d'abord),
--      sinon l'accueil peut ouvrir sur un boss.
--
-- Espace de noms des fixtures : préfixe `f31…`.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(9);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id, display_order)
SELECT 'f31-subj', 'F31 Matière', 'Force', 'subject-math', 'Brain', g.theme_id, g.id, 1
  FROM public.grades g LIMIT 1;

INSERT INTO public.chapters (id, subject_id, title, display_order)
VALUES ('f3100000-0000-4000-8000-0000000000c1', 'f31-subj', 'F31 Chapitre', 1);

-- Deux exercices : un BOSS (difficulté 3) déclaré en premier, et une pratique
-- facile. Si l'accueil ouvrait sur le boss, le décor le montrerait.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source, difficulty, display_order)
VALUES
  ('f3100000-0000-4000-8000-0000000000e9', 'f3100000-0000-4000-8000-0000000000c1', 'f31-subj',
   'F31 Boss', 'boss', 'admin', 3, 1),
  ('f3100000-0000-4000-8000-0000000000e1', 'f3100000-0000-4000-8000-0000000000c1', 'f31-subj',
   'F31 Première', 'practice', 'admin', 1, 2);

INSERT INTO auth.users (id, email)
VALUES
  ('f3100000-0000-4000-8000-000000000001', 'f31-eleve@test.local'),
  ('f3100000-0000-4000-8000-000000000002', 'f31-sans-parcours@test.local');

-- L'élève a choisi un parcours (dernier écran de l'accueil).
UPDATE public.profiles
   SET current_parcours_id = (
     SELECT pa.id FROM public.parcours pa
      JOIN public.subjects s ON s.theme_id = pa.theme_id AND s.grade_id = pa.grade_id
     WHERE s.id = 'f31-subj' LIMIT 1
   )
 WHERE id = 'f3100000-0000-4000-8000-000000000001';

SET LOCAL "request.jwt.claims" = '{"sub":"f3100000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- =========================================================
-- 1. Le premier appel verse, et désigne la première quête.
-- =========================================================
CREATE TEMP TABLE f31_first AS SELECT public.claim_welcome_pack() AS j;

SELECT is(
  (SELECT (j->>'granted')::boolean FROM f31_first),
  true,
  'le premier appel VERSE la récompense de bienvenue'
);

SELECT is(
  (SELECT (j->>'coins')::int FROM f31_first),
  30,
  '30 pièces exactement — Q-4, le prix d''un booster : la boutique s''apprend par l''usage'
);

SELECT is(
  (SELECT j->>'firstExerciseId' FROM f31_first),
  'f3100000-0000-4000-8000-0000000000e1',
  '⭐ la première quête est la plus ABORDABLE, pas la première déclarée — l''accueil n''ouvre pas sur un boss'
);

SELECT is(
  (SELECT yahia_coins FROM public.profiles WHERE id = 'f3100000-0000-4000-8000-000000000001'),
  30,
  'le solde a réellement bougé : la récompense passe par `award_coins`, la frappe existante'
);

-- =========================================================
-- 2. ⭐ L'IDEMPOTENCE — trois appels de plus ne donnent rien de plus.
-- =========================================================
SELECT is(
  (SELECT (public.claim_welcome_pack()->>'granted')::boolean),
  false,
  '⭐ le second appel ne verse RIEN — et le dit, pour que l''écran ne fête pas deux fois'
);

SELECT public.claim_welcome_pack();
SELECT public.claim_welcome_pack();

SELECT is(
  (SELECT yahia_coins FROM public.profiles WHERE id = 'f3100000-0000-4000-8000-000000000001'),
  30,
  '⭐ quatre appels, 30 pièces : un double clic ou un rejeu réseau ne double pas la récompense'
);

SELECT ok(
  (SELECT (public.claim_welcome_pack()->>'firstExerciseId') IS NOT NULL),
  'mais la première quête reste désignée à chaque appel — c''est une lecture, pas un cadeau'
);

RESET ROLE;

-- =========================================================
-- 3. Sans parcours choisi : pas de quête à proposer, et la récompense tient.
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"f3100000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT public.claim_welcome_pack()->>'firstExerciseId'),
  NULL,
  'sans parcours, aucune première quête n''est désignée — l''écran retombe sur le tableau de bord'
);

RESET ROLE;

SELECT ok(
  NOT has_function_privilege('anon', 'public.claim_welcome_pack()', 'EXECUTE'),
  'un visiteur anonyme ne peut pas réclamer de pièces'
);

SELECT * FROM finish();
ROLLBACK;
