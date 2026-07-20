-- =========================================================
-- Ouverture du parcours 1ère année secondaire (tronc commun) — étude 16,
-- vague A, seuil R-8 (« une matière complète ouvre la section »).
-- Sur une DB fraîche (toutes les migrations appliquées, y compris
-- 20260713180000_open_ecole_1ere_sec_parcours), le parcours `ecole-1ere-sec`
-- doit être 'available' et gratuit. C'est la migration d'ouverture qui rend la
-- classe visible — et c'est tout ce qui se vérifie ici depuis l'étude 24 : la
-- matière et ses 16 chapitres sont du corpus, parti au repo privé (#574).
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(3);

-- 1) La migration d'ouverture a bien fait passer le parcours en 'available'.
SELECT is(
  (SELECT status FROM public.parcours WHERE id = 'ecole-1ere-sec'),
  'available',
  'le parcours ecole-1ere-sec est ouvert (status = available)'
);

-- 2) C'est un parcours scolaire GRATUIT (invariant de la phase gratuite).
SELECT is(
  (SELECT kind FROM public.parcours WHERE id = 'ecole-1ere-sec'),
  'scolaire',
  'ecole-1ere-sec est un parcours scolaire'
);

SELECT ok(
  (SELECT NOT is_premium FROM public.parcours WHERE id = 'ecole-1ere-sec'),
  'ecole-1ere-sec est gratuit (is_premium = false)'
);

-- 3) Le CONTENU qui justifie l'ouverture — rattachement de `math-1ere-sec` au
--    grade 1ere-sec et ses 16 chapitres — n'est plus vérifiable ici : depuis
--    l'étude 24 le corpus ne voyage plus en migrations, et `db-tests.yml` monte
--    la base avec `supabase db start`, qui n'applique que supabase/migrations/.
--    Ces deux assertions sont portées à la Content CI privée (#574). Ce qui
--    reste ci-dessus porte sur la MIGRATION d'ouverture, pas sur le corpus, et
--    tient donc sur une base vierge.

SELECT * FROM finish();
ROLLBACK;
