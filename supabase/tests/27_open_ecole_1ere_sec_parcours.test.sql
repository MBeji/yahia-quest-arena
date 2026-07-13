-- =========================================================
-- Ouverture du parcours 1ère année secondaire (tronc commun) — étude 16,
-- vague A, seuil R-8 (« une matière complète ouvre la section »).
-- Sur une DB fraîche (toutes les migrations appliquées, y compris
-- 20260713180000_open_ecole_1ere_sec_parcours), le parcours `ecole-1ere-sec`
-- doit être 'available', gratuit, et adossé à la matière mathématiques complète
-- (16 chapitres). C'est la migration d'ouverture qui rend la classe visible.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(5);

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

-- 3) La matière mathématiques existe et est rattachée au grade 1ere-sec
--    d'ecole-tn (le contenu qui justifie l'ouverture).
SELECT is(
  (SELECT grade_id FROM public.subjects WHERE id = 'math-1ere-sec'),
  (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '1ere-sec'),
  'le sujet math-1ere-sec est rattaché au grade 1ere-sec'
);

-- 4) Les 16 chapitres du manuel officiel sont présents (matière complète).
SELECT is(
  (SELECT COUNT(*)::int FROM public.chapters WHERE subject_id = 'math-1ere-sec'),
  16,
  'math-1ere-sec compte bien 16 chapitres'
);

SELECT * FROM finish();
ROLLBACK;
