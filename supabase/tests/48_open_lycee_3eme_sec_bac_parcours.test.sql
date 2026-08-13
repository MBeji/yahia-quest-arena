-- =========================================================
-- Ouverture des 11 parcours du lycée restés `coming_soon` (seuil R-8) : les six
-- sections de 3ème année secondaire et les cinq sections du Bac encore fermées.
-- Sur une DB fraîche (toutes les migrations appliquées, y compris
-- 20260813120000_open_lycee_3eme_sec_bac_parcours), ces onze parcours doivent
-- être 'available' ET gratuits.
--
-- Le CONTENU qui justifie l'ouverture n'est pas vérifiable ici : depuis
-- l'étude 24 le corpus ne voyage plus en migrations et `db-tests.yml` monte la
-- base avec `supabase db start`, qui n'applique que supabase/migrations/. Ce
-- test porte sur la MIGRATION d'ouverture — il tient donc sur une base vierge.
-- Miroir de 46_open_ecole_2eme_sec_info_parcours.test.sql, généralisé aux onze.
--
-- Le deuxième bloc est le plus important : ces cinq `concours-bac-*` ont été
-- semés `is_premium = true` (20260704235000) et remis à false par la bascule de
-- phase gratuite (20260711100000). L'ordre de ces deux migrations est ce qui
-- fait qu'ouvrir la classe ne rouvre pas une porte premium — un test qui ne
-- vérifierait que le statut laisserait cette régression passer sans bruit.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(4);

-- 1) Les onze parcours sont ouverts.
SELECT is(
  (SELECT COUNT(*)::INT FROM public.parcours
   WHERE status = 'available'
     AND id IN (
       'ecole-3eme-sec-math', 'ecole-3eme-sec-sciences-exp', 'ecole-3eme-sec-lettres',
       'ecole-3eme-sec-eco-gestion', 'ecole-3eme-sec-techniques', 'ecole-3eme-sec-info',
       'concours-bac-sciences-exp', 'concours-bac-lettres', 'concours-bac-eco-gestion',
       'concours-bac-techniques', 'concours-bac-info'
     )),
  11,
  'les 11 parcours du lycée sont ouverts (status = available)'
);

-- 2) Aucun d'entre eux n'est premium — invariant de la phase gratuite. Les cinq
--    bac étaient premium au seed ; la bascule 20260711100000 doit les avoir
--    corrigés AVANT que cette ouverture ne les rende visibles.
SELECT is(
  (SELECT COUNT(*)::INT FROM public.parcours
   WHERE is_premium
     AND id IN (
       'ecole-3eme-sec-math', 'ecole-3eme-sec-sciences-exp', 'ecole-3eme-sec-lettres',
       'ecole-3eme-sec-eco-gestion', 'ecole-3eme-sec-techniques', 'ecole-3eme-sec-info',
       'concours-bac-sciences-exp', 'concours-bac-lettres', 'concours-bac-eco-gestion',
       'concours-bac-techniques', 'concours-bac-info'
     )),
  0,
  'aucun des 11 parcours ouverts n''est premium (phase gratuite)'
);

-- 3) Les six sections de 3ème sec restent des parcours `scolaire`.
SELECT is(
  (SELECT COUNT(*)::INT FROM public.parcours
   WHERE kind = 'scolaire'
     AND id IN (
       'ecole-3eme-sec-math', 'ecole-3eme-sec-sciences-exp', 'ecole-3eme-sec-lettres',
       'ecole-3eme-sec-eco-gestion', 'ecole-3eme-sec-techniques', 'ecole-3eme-sec-info'
     )),
  6,
  'les six sections de 3ème sec sont des parcours scolaire'
);

-- 4) Les cinq sections du Bac restent des parcours `concours`.
SELECT is(
  (SELECT COUNT(*)::INT FROM public.parcours
   WHERE kind = 'concours'
     AND id IN (
       'concours-bac-sciences-exp', 'concours-bac-lettres', 'concours-bac-eco-gestion',
       'concours-bac-techniques', 'concours-bac-info'
     )),
  5,
  'les cinq sections du Bac ouvertes sont des parcours concours'
);

SELECT * FROM finish();
ROLLBACK;
