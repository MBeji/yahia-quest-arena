-- =========================================================
-- Ouverture du parcours 2ème année secondaire — section Économie et Services
-- (seuil R-8). Sur une DB fraîche (toutes les migrations appliquées, y compris
-- 20260830140000_open_ecole_2eme_sec_eco_services_parcours), le parcours
-- `ecole-2eme-sec-eco-services` doit être 'available' et gratuit.
--
-- Le CONTENU qui justifie l'ouverture (`english-2eme-sec-eco-services`, sujet
-- compilé par mutualisation depuis le Student's Book commun aux quatre
-- sections) n'est pas vérifiable ici : depuis l'étude 24 le corpus ne voyage
-- plus en migrations et `db-tests.yml` monte la base avec `supabase db start`,
-- qui n'applique que supabase/migrations/. Ce test porte sur la MIGRATION
-- d'ouverture — il tient donc sur une base vierge. Miroir de
-- 46_open_ecole_2eme_sec_info_parcours.test.sql.
--
-- Avec ce parcours, les QUATRE sections de 2ème sec sont ouvertes : le test le
-- dit explicitement, pour qu'une régression sur l'une des trois autres se voie
-- ici aussi.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(4);

-- 1) La migration d'ouverture a bien fait passer le parcours en 'available'.
SELECT is(
  (SELECT status FROM public.parcours WHERE id = 'ecole-2eme-sec-eco-services'),
  'available',
  'le parcours ecole-2eme-sec-eco-services est ouvert (status = available)'
);

-- 2) C'est un parcours scolaire GRATUIT (invariant de la phase gratuite).
SELECT is(
  (SELECT kind FROM public.parcours WHERE id = 'ecole-2eme-sec-eco-services'),
  'scolaire',
  'ecole-2eme-sec-eco-services est un parcours scolaire'
);

SELECT ok(
  (SELECT NOT is_premium FROM public.parcours WHERE id = 'ecole-2eme-sec-eco-services'),
  'ecole-2eme-sec-eco-services est gratuit (is_premium = false)'
);

-- 3) La série des quatre sections de 2ème sec est complète.
SELECT is(
  (SELECT count(*)::int
     FROM public.parcours
    WHERE id IN ('ecole-2eme-sec-sciences', 'ecole-2eme-sec-lettres',
                 'ecole-2eme-sec-eco-services', 'ecole-2eme-sec-info')
      AND status = 'available'),
  4,
  'les 4 sections de 2eme sec sont ouvertes'
);

SELECT * FROM finish();
ROLLBACK;
