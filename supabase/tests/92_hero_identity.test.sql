-- =========================================================
-- Étude 31, lot 7 — L'IDENTITÉ DU HÉROS (US-11, R-22).
-- ---------------------------------------------------------
-- Constat n° 10 : « l'investissement identitaire est PAUVRE ». `avatar_tier` est
-- calculé à chaque gain d'XP et rendu nulle part ; `hero_class` est du FRANÇAIS
-- NON ACCENTUÉ stocké en base, affiché tel quel dans les trois langues ; il n'y a
-- ni titre, ni cadre — et donc aucun puits pour les pièces (é09 `sink_ratio`).
--
-- Deux propriétés portent le lot :
--
--   1. ⭐ LA MIGRATION NE PERD AUCUNE CLASSE. Sept libellés deviennent sept codes,
--      et `award_xp` écrit les codes ensuite. Si la conversion ratait un libellé,
--      la contrainte le renverrait au socle : un élève de niveau 40 se
--      réveillerait « novice ». C'est le seul défaut irréversible du lot.
--   2. ⭐ TROIS EMPLACEMENTS SÉPARÉS. Équiper un cadre ne doit pas déséquiper
--      l'avatar — l'erreur exacte qu'une seule liste d'équipés produirait.
--
-- Espace de noms des fixtures : préfixe `d31c…`.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(13);

INSERT INTO auth.users (id, email)
VALUES ('d31c0000-0000-4000-8000-000000000001', 'd31c-heros@test.local');

-- =========================================================
-- 1. ⭐ La classe est un CODE, et la contrainte le tient.
-- =========================================================
SELECT is(
  (SELECT hero_class FROM public.profiles WHERE id = 'd31c0000-0000-4000-8000-000000000001'),
  'novice',
  'un compte neuf naît « novice » — le défaut de colonne est un code, plus un libellé'
);

SELECT throws_ok(
  $$ UPDATE public.profiles SET hero_class = 'Guerrier des Equations'
      WHERE id = 'd31c0000-0000-4000-8000-000000000001' $$,
  '23514',
  NULL,
  '⭐ le français stocké est REFUSÉ par la base — la panne ne peut pas revenir par une écriture'
);

-- `award_xp` écrit les codes, et les paliers ne bougent pas d'un niveau.
SET LOCAL "request.jwt.claims" = '{"sub":"d31c0000-0000-4000-8000-000000000001","role":"authenticated"}';
SELECT public.award_xp('d31c0000-0000-4000-8000-000000000001', 1200);   -- niveau 7

SELECT is(
  (SELECT hero_class FROM public.profiles WHERE id = 'd31c0000-0000-4000-8000-000000000001'),
  'aspirant',
  'au niveau 7, `award_xp` écrit le code `aspirant` — le seuil (6) est inchangé'
);

SELECT public.award_xp('d31c0000-0000-4000-8000-000000000001', 9000);   -- niveau 51

SELECT is(
  (SELECT hero_class FROM public.profiles WHERE id = 'd31c0000-0000-4000-8000-000000000001'),
  's_rank',
  'et `s_rank` au niveau 50 — le sommet reste le sommet'
);

SELECT is(
  (SELECT avatar_tier FROM public.profiles WHERE id = 'd31c0000-0000-4000-8000-000000000001'),
  6,
  'le palier d''avatar est plafonné à 6 — c''est ce nombre que l''écran affiche désormais'
);

-- =========================================================
-- 2. Les objets cosmétiques et leurs prix (registre §3.9).
-- =========================================================
SELECT is(
  (SELECT COUNT(*)::int FROM public.shop_items WHERE item_type IN ('frame', 'title')),
  6,
  'trois cadres et trois titres sont en boutique'
);

SELECT ok(
  (SELECT bool_and(price_coins BETWEEN 80 AND 500) FROM public.shop_items
    WHERE item_type IN ('frame', 'title')),
  'leurs prix restent dans la fourchette des skins existants (80-500) — aucune valeur inventée hors registre'
);

-- =========================================================
-- 3. ⭐ TROIS EMPLACEMENTS SÉPARÉS.
-- =========================================================
UPDATE public.profiles SET yahia_coins = 2000
 WHERE id = 'd31c0000-0000-4000-8000-000000000001';

SET LOCAL "request.jwt.claims" = '{"sub":"d31c0000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT public.purchase_shop_item('skin_ninja');
SELECT public.purchase_shop_item('frame_gold');
SELECT public.purchase_shop_item('title_sharp');
SELECT public.equip_cosmetic('skin_ninja');
SELECT public.equip_cosmetic('frame_gold');
SELECT public.equip_cosmetic('title_sharp');
RESET ROLE;

SELECT is(
  (SELECT avatar_slug FROM public.profiles WHERE id = 'd31c0000-0000-4000-8000-000000000001'),
  'ninja',
  '⭐ l''avatar reste équipé après un cadre ET un titre — trois emplacements, pas une seule liste'
);

SELECT is(
  (SELECT frame_slug FROM public.profiles WHERE id = 'd31c0000-0000-4000-8000-000000000001'),
  'gold',
  'le cadre est posé'
);

SELECT is(
  (SELECT title_code FROM public.profiles WHERE id = 'd31c0000-0000-4000-8000-000000000001'),
  'sharp',
  'le titre aussi'
);

-- Changer de cadre déséquipe l'ancien CADRE, et rien d'autre.
SET LOCAL "request.jwt.claims" = '{"sub":"d31c0000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT public.purchase_shop_item('frame_neon');
SELECT public.equip_cosmetic('frame_neon');
RESET ROLE;

SELECT is(
  (SELECT COUNT(*)::int FROM public.inventory_items inv
     JOIN public.shop_items si ON si.id = inv.shop_item_id
    WHERE inv.student_user_id = 'd31c0000-0000-4000-8000-000000000001'
      AND inv.is_equipped AND si.item_type = 'frame'),
  1,
  'un seul cadre équipé à la fois'
);

SELECT is(
  (SELECT COUNT(*)::int FROM public.inventory_items inv
     JOIN public.shop_items si ON si.id = inv.shop_item_id
    WHERE inv.student_user_id = 'd31c0000-0000-4000-8000-000000000001'
      AND inv.is_equipped AND si.item_type IN ('skin', 'title')),
  2,
  '⭐ et l''avatar comme le titre sont TOUJOURS équipés — changer de cadre ne les touche pas'
);

-- =========================================================
-- 4. ⭐ LA GARDE STRUCTURELLE — plus AUCUNE fonction n'écrit un libellé.
--
--    `award_duel_rewards` recopie la courbe de niveau d'`award_xp` (duplication
--    antérieure à ce lot) et écrivait donc, lui aussi, du français : la
--    contrainte posée par le lot faisait échouer CHAQUE récompense de duel. La
--    suite l'a montré en local avant la CI ; cette assertion-ci empêche qu'un
--    troisième écrivain réapparaisse en silence.
-- =========================================================
SELECT is(
  (SELECT COUNT(*)::int
     FROM pg_proc p
     JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.prosrc LIKE '%hero_class =%'
      AND (p.prosrc LIKE '%''Candidat Civil''%'
        OR p.prosrc LIKE '%''S-Rank Legend''%'
        OR p.prosrc LIKE '%''Guerrier des Equations''%'
        OR p.prosrc LIKE '%''Aspirant Academicien''%'
        OR p.prosrc LIKE '%''Maitre des Langues''%'
        OR p.prosrc LIKE '%''Elite du Concours''%')),
  0,
  '⭐ aucune fonction n''écrit plus un LIBELLÉ de classe — la contrainte les refuserait toutes'
);

SELECT * FROM finish();
ROLLBACK;
