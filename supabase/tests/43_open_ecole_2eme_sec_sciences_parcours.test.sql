-- =========================================================
-- Ouverture du parcours 2ème année secondaire — section Sciences (seuil R-8).
-- Sur une DB fraîche (toutes les migrations appliquées, y compris
-- 20260730120000_open_ecole_2eme_sec_sciences_parcours), le parcours
-- `ecole-2eme-sec-sciences` doit être 'available' et gratuit.
--
-- Le CONTENU qui justifie l'ouverture (la première tranche de
-- `math-2eme-sec-sciences`) n'est pas vérifiable ici : depuis l'étude 24 le
-- corpus ne voyage plus en migrations et `db-tests.yml` monte la base avec
-- `supabase db start`, qui n'applique que supabase/migrations/. Ce test porte
-- sur la MIGRATION d'ouverture — il tient donc sur une base vierge. Miroir de
-- 27_open_ecole_1ere_sec_parcours.test.sql.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(3);

-- 1) La migration d'ouverture a bien fait passer le parcours en 'available'.
SELECT is(
  (SELECT status FROM public.parcours WHERE id = 'ecole-2eme-sec-sciences'),
  'available',
  'le parcours ecole-2eme-sec-sciences est ouvert (status = available)'
);

-- 2) C'est un parcours scolaire GRATUIT (invariant de la phase gratuite).
SELECT is(
  (SELECT kind FROM public.parcours WHERE id = 'ecole-2eme-sec-sciences'),
  'scolaire',
  'ecole-2eme-sec-sciences est un parcours scolaire'
);

SELECT ok(
  (SELECT NOT is_premium FROM public.parcours WHERE id = 'ecole-2eme-sec-sciences'),
  'ecole-2eme-sec-sciences est gratuit (is_premium = false)'
);

SELECT * FROM finish();
ROLLBACK;
