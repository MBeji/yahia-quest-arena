-- =========================================================
-- Ouverture du parcours Baccalauréat — section Sciences de l'informatique (seuil R-8).
-- Sur une DB fraîche (toutes les migrations appliquées, dont
-- 20260817150300_open_bac_info_parcours), le parcours
-- `concours-bac-info` doit être 'available' ET entièrement gratuit.
--
-- Les DEUX assertions de gratuité comptent autant que celle d'ouverture : le
-- seed 20260704235000 a créé ce parcours en premium ('difficulty_1'), et une
-- ouverture qui oublierait de le libérer n'exposerait que l'aperçu — quiz et
-- missions de difficulté 1 —, la révision ⭐⭐ et le boss ⭐⭐⭐ restant
-- verrouillés derrière un entitlement que personne ne vend. Ce test échoue si
-- l'une des deux moitiés de la migration est perdue.
--
-- Le CONTENU qui justifie l'ouverture (`french-bac-info` 7/7 et
-- `english-bac-info`) n'est pas vérifiable ici : depuis l'étude 24 le corpus
-- ne voyage plus en migrations et `db-tests.yml` monte la base avec
-- `supabase db start`, qui n'applique que supabase/migrations/. Ce test porte
-- sur la MIGRATION d'ouverture — il tient donc sur une base vierge.
-- Miroir de 46_open_ecole_2eme_sec_info_parcours.test.sql.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(4);

-- 1) Le parcours est ouvert.
SELECT is(
  (SELECT status FROM public.parcours WHERE id = 'concours-bac-info'),
  'available',
  'le parcours concours-bac-info est ouvert (status = available)'
);

-- 2) Il reste un parcours de type concours : seule la barrière est en pause.
SELECT is(
  (SELECT kind FROM public.parcours WHERE id = 'concours-bac-info'),
  'concours',
  'concours-bac-info reste un parcours concours'
);

-- 3) Il est gratuit — sinon l'ouverture n'exposerait que l'aperçu.
SELECT ok(
  (SELECT NOT is_premium FROM public.parcours WHERE id = 'concours-bac-info'),
  'concours-bac-info est gratuit (is_premium = false)'
);

-- 4) Et sans restriction d'aperçu, cohérent avec les autres parcours gratuits.
SELECT is(
  (SELECT preview_policy FROM public.parcours WHERE id = 'concours-bac-info'),
  'full',
  'concours-bac-info expose tout le contenu (preview_policy = full)'
);

SELECT * FROM finish();
ROLLBACK;
