-- =========================================================
-- Ouverture du parcours 7ème année de base (1re année du collège) — seuil R-8.
-- Sur une DB fraîche (toutes les migrations appliquées, y compris
-- 20260729120000_open_ecole_7eme_base_parcours), le parcours `ecole-7eme-base`
-- doit être 'available' et gratuit.
--
-- Le CONTENU qui justifie l'ouverture (54 chapitres sur 6 matières) n'est pas
-- vérifiable ici : depuis l'étude 24 le corpus ne voyage plus en migrations et
-- `db-tests.yml` monte la base avec `supabase db start`, qui n'applique que
-- supabase/migrations/. Ce test porte sur la MIGRATION d'ouverture, pas sur le
-- corpus — il tient donc sur une base vierge. Miroir de
-- 27_open_ecole_1ere_sec_parcours.test.sql.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(3);

-- 1) La migration d'ouverture a bien fait passer le parcours en 'available'.
SELECT is(
  (SELECT status FROM public.parcours WHERE id = 'ecole-7eme-base'),
  'available',
  'le parcours ecole-7eme-base est ouvert (status = available)'
);

-- 2) C'est un parcours scolaire GRATUIT (invariant de la phase gratuite).
SELECT is(
  (SELECT kind FROM public.parcours WHERE id = 'ecole-7eme-base'),
  'scolaire',
  'ecole-7eme-base est un parcours scolaire'
);

SELECT ok(
  (SELECT NOT is_premium FROM public.parcours WHERE id = 'ecole-7eme-base'),
  'ecole-7eme-base est gratuit (is_premium = false)'
);

SELECT * FROM finish();
ROLLBACK;
