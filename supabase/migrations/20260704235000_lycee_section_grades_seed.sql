-- =========================================================
-- Lycée sections — grade nodes seed (station L0 of docs/lycee-architecture.md)
-- ---------------------------------------------------------
-- From 2ème secondaire the national ladder branches into sections; sections are
-- modelled as GRADE NODES under ecole-tn (docs/lycee-architecture.md §2): the
-- whole product stack ((theme, grade) → parcours, entitlements, onboarding,
-- dashboard scoping) works unchanged on new grade rows.
--
-- This migration is purely ADDITIVE and safe ahead of any dependent code (DoD §7):
--   1) grades.is_selectable flag (default true — no behavior change for existing
--      rows; UI filtering lands later, reading it is optional).
--   2) The legacy FLAT nodes 2eme-sec / 3eme-sec / bac become non-selectable.
--      They are NEVER deleted (a profile may reference them; slugs are identity).
--      Their legacy parcours rows ('ecole-2eme-sec', 'ecole-3eme-sec',
--      'concours-bac' — all coming_soon, seeded by 20260617120000) stay in place;
--      retiring them for real is a later, separate, destructive decision.
--   3) 16 section-grade nodes (display_order 14..29, school order).
--   4) One parcours per new node, all 'coming_soon' (invisible product-wise until
--      content lands and an open_* migration flips them): free 'scolaire' for
--      2ème/3ème sections, PREMIUM 'concours' for the six bac-* sections.
--
-- Idempotent: ON CONFLICT DO NOTHING everywhere; re-running is a no-op.
-- No new table → no new GRANTs needed (grades/parcours grants already baselined).
-- =========================================================

ALTER TABLE public.grades
  ADD COLUMN IF NOT EXISTS is_selectable BOOLEAN NOT NULL DEFAULT true;

UPDATE public.grades
SET is_selectable = false
WHERE theme_id = 'ecole-tn' AND slug IN ('2eme-sec', '3eme-sec', 'bac');

-- 3) Section-grade nodes (cycle 'secondaire'; bac-* are the concours year).
INSERT INTO public.grades (theme_id, slug, name_fr, cycle, is_concours_national, display_order)
VALUES
  ('ecole-tn', '2eme-sec-sciences',     '2ème Sciences',                          'secondaire', false, 14),
  ('ecole-tn', '2eme-sec-lettres',      '2ème Lettres',                           'secondaire', false, 15),
  ('ecole-tn', '2eme-sec-eco-services', '2ème Économie et Services',              'secondaire', false, 16),
  ('ecole-tn', '2eme-sec-info',         '2ème Technologies de l''informatique',   'secondaire', false, 17),
  ('ecole-tn', '3eme-sec-math',         '3ème Mathématiques',                     'secondaire', false, 18),
  ('ecole-tn', '3eme-sec-sciences-exp', '3ème Sciences expérimentales',           'secondaire', false, 19),
  ('ecole-tn', '3eme-sec-lettres',      '3ème Lettres',                           'secondaire', false, 20),
  ('ecole-tn', '3eme-sec-eco-gestion',  '3ème Économie et Gestion',               'secondaire', false, 21),
  ('ecole-tn', '3eme-sec-techniques',   '3ème Sciences techniques',               'secondaire', false, 22),
  ('ecole-tn', '3eme-sec-info',         '3ème Sciences de l''informatique',       'secondaire', false, 23),
  ('ecole-tn', 'bac-math',              'Bac Mathématiques',                      'secondaire', true,  24),
  ('ecole-tn', 'bac-sciences-exp',      'Bac Sciences expérimentales',            'secondaire', true,  25),
  ('ecole-tn', 'bac-lettres',           'Bac Lettres',                            'secondaire', true,  26),
  ('ecole-tn', 'bac-eco-gestion',       'Bac Économie et Gestion',                'secondaire', true,  27),
  ('ecole-tn', 'bac-techniques',        'Bac Sciences techniques',                'secondaire', true,  28),
  ('ecole-tn', 'bac-info',              'Bac Sciences de l''informatique',        'secondaire', true,  29)
ON CONFLICT (theme_id, slug) DO NOTHING;

-- 4a) Free 'scolaire' parcours for the 2ème/3ème section nodes (mirrors the
--     'ecole-<slug>' convention of 20260617120000).
INSERT INTO public.parcours
  (id, name_fr, kind, theme_id, grade_id, is_premium, preview_policy, display_order, icon, color, status)
SELECT 'ecole-' || g.slug, g.name_fr, 'scolaire', 'ecole-tn', g.id,
       false, 'full', g.display_order, 'GraduationCap', 'subject-math', 'coming_soon'
FROM public.grades g
WHERE g.theme_id = 'ecole-tn'
  AND g.slug IN ('2eme-sec-sciences', '2eme-sec-lettres', '2eme-sec-eco-services', '2eme-sec-info',
                 '3eme-sec-math', '3eme-sec-sciences-exp', '3eme-sec-lettres',
                 '3eme-sec-eco-gestion', '3eme-sec-techniques', '3eme-sec-info')
ON CONFLICT (id) DO NOTHING;

-- 4b) PREMIUM 'concours' parcours for the six bac sections (mirrors 'concours-9eme':
--     entitlement-gated d3–4, free preview = comprehension quiz + difficulty-1).
INSERT INTO public.parcours
  (id, name_fr, kind, theme_id, grade_id, is_premium, preview_policy, display_order, icon, color, status)
SELECT 'concours-' || g.slug, 'Préparation ' || g.name_fr, 'concours', 'ecole-tn', g.id,
       true, 'difficulty_1', g.display_order, 'GraduationCap', 'subject-math', 'coming_soon'
FROM public.grades g
WHERE g.theme_id = 'ecole-tn'
  AND g.slug IN ('bac-math', 'bac-sciences-exp', 'bac-lettres',
                 'bac-eco-gestion', 'bac-techniques', 'bac-info')
ON CONFLICT (id) DO NOTHING;
