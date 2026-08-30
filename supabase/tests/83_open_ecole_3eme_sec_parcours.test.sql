-- =========================================================
-- Ouverture des six parcours de 3ème année secondaire — étude 16, seuil R-8
-- (« la première tranche complète ouvre la classe »).
--
-- Sur une DB fraîche (toutes les migrations appliquées, y compris
-- 20260831120000_open_ecole_3eme_sec_parcours), les six parcours `ecole-3eme-sec-*`
-- doivent être 'available', scolaires et gratuits — et chacun adossé à son sujet
-- d'anglais compilé.
--
-- La particularité que ce test atteste : l'anglais de 3ème année est AUTHORED UNE FOIS
-- et compilé en six sujets (`compileTo`, étude 16 D-4). Les six sujets doivent donc
-- exister, être rattachés chacun à SON grade, et porter le MÊME nombre de chapitres (9 au moment de l écriture).
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(6);

-- 1) Les six parcours sont ouverts.
SELECT is(
  (SELECT COUNT(*)::int FROM public.parcours
   WHERE id LIKE 'ecole-3eme-sec-%' AND status = 'available'),
  6,
  'les six parcours ecole-3eme-sec-* sont ouverts (status = available)'
);

-- 2) Aucun n'est resté en coming_soon.
SELECT is(
  (SELECT COUNT(*)::int FROM public.parcours
   WHERE id LIKE 'ecole-3eme-sec-%' AND status = 'coming_soon'),
  0,
  'aucun parcours de 3ème sec ne reste en coming_soon'
);

-- 3) Ce sont des parcours scolaires GRATUITS (invariant de la phase gratuite).
SELECT is(
  (SELECT COUNT(*)::int FROM public.parcours
   WHERE id LIKE 'ecole-3eme-sec-%' AND kind = 'scolaire' AND NOT is_premium),
  6,
  'les six parcours sont scolaires et gratuits (is_premium = false)'
);

-- 4) Les six sujets d'anglais compilés existent.
SELECT is(
  (SELECT COUNT(*)::int FROM public.subjects WHERE id LIKE 'english-3eme-sec-%'),
  6,
  'les six sujets english-3eme-sec-* existent en base'
);

-- 5) Chacun est rattaché à SON grade — c'est ce que compileTo doit garantir.
SELECT is(
  (SELECT COUNT(*)::int
   FROM public.subjects s
   JOIN public.grades g ON g.id = s.grade_id
   WHERE s.id = 'english-' || g.slug
     AND g.theme_id = 'ecole-tn'
     AND g.slug LIKE '3eme-sec-%'),
  6,
  'chaque sujet compilé est rattaché au grade que son id nomme'
);

-- 6) Les six portent le même chapitrage : c'est le même dossier compilé six fois.
--    (Le nombre exact grandit au fil des tranches ; ce qui doit tenir, c'est l'égalité.)
SELECT is(
  (SELECT COUNT(DISTINCT n)::int FROM (
     SELECT COUNT(*) AS n
     FROM public.chapters c
     WHERE c.subject_id LIKE 'english-3eme-sec-%'
     GROUP BY c.subject_id
   ) AS counts),
  1,
  'les six sujets compilés portent exactement le même nombre de chapitres'
);

SELECT * FROM finish();
ROLLBACK;
