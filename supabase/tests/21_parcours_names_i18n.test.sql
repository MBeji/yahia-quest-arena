-- =========================================================
-- Noms de parcours localisés (étude 15, lot 3) — sur une DB fraîche, chaque
-- parcours seedé porte ses trois noms (name_fr toujours ; name_en/name_ar
-- peuplés par 20260711120000_parcours_names_i18n.sql).
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(4);

SELECT is(
  (SELECT COUNT(*)::int FROM public.parcours WHERE name_fr IS NULL OR name_fr = ''),
  0,
  'every parcours has a French name'
);

SELECT is(
  (SELECT COUNT(*)::int FROM public.parcours WHERE name_en IS NULL OR name_en = ''),
  0,
  'every seeded parcours has an English name'
);

SELECT is(
  (SELECT COUNT(*)::int FROM public.parcours WHERE name_ar IS NULL OR name_ar = ''),
  0,
  'every seeded parcours has an Arabic name'
);

-- Spot-check one row end to end (id → the three names).
SELECT results_eq(
  $$ SELECT name_en, name_ar FROM public.parcours WHERE id = 'concours-9eme' $$,
  $$ VALUES ('9th-grade national exam prep'::text, 'الإعداد لمناظرة التاسعة أساسي'::text) $$,
  'concours-9eme carries its localized names'
);

SELECT * FROM finish();
ROLLBACK;
