-- =========================================================
-- Ouverture du parcours 2ème année secondaire — section Technologies de
-- l'informatique (seuil R-8). Sur une DB fraîche (toutes les migrations
-- appliquées, y compris 20260731130000_open_ecole_2eme_sec_info_parcours), le
-- parcours `ecole-2eme-sec-info` doit être 'available' et gratuit.
--
-- Le CONTENU qui justifie l'ouverture (`math-2eme-sec-info`, sujet compilé par
-- mutualisation depuis le manuel partagé des deux sections) n'est pas
-- vérifiable ici : depuis l'étude 24 le corpus ne voyage plus en migrations et
-- `db-tests.yml` monte la base avec `supabase db start`, qui n'applique que
-- supabase/migrations/. Ce test porte sur la MIGRATION d'ouverture — il tient
-- donc sur une base vierge. Miroir de
-- 44_open_ecole_2eme_sec_lettres_parcours.test.sql.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(3);

-- 1) La migration d'ouverture a bien fait passer le parcours en 'available'.
SELECT is(
  (SELECT status FROM public.parcours WHERE id = 'ecole-2eme-sec-info'),
  'available',
  'le parcours ecole-2eme-sec-info est ouvert (status = available)'
);

-- 2) C'est un parcours scolaire GRATUIT (invariant de la phase gratuite).
SELECT is(
  (SELECT kind FROM public.parcours WHERE id = 'ecole-2eme-sec-info'),
  'scolaire',
  'ecole-2eme-sec-info est un parcours scolaire'
);

SELECT ok(
  (SELECT NOT is_premium FROM public.parcours WHERE id = 'ecole-2eme-sec-info'),
  'ecole-2eme-sec-info est gratuit (is_premium = false)'
);

SELECT * FROM finish();
ROLLBACK;
