-- =========================================================
-- Nouvelle rubrique des extras : « Éducation islamique » (التربية الإسلامية)
-- ---------------------------------------------------------
-- MUST BE APPLIED TO THE DB *BEFORE* LE CORPUS QUI S'Y RATTACHE (AGENTS.md §7) :
-- la sous-rubrique فقه est un `subjects` du dépôt privé dont la FK pointe sur
-- `themes.id = 'education-islamique'`. Sans cette migration, le SQL de contenu
-- échoue sur la FK. Purement additive et idempotente.
--
-- Forme : thème AUTONOME (pas de grades — la rubrique est indépendante du
-- programme scolaire) + UN parcours `libre`, gratuit, qui le porte dans le menu
-- « Extras » (`/extras` ne rend que `kind = 'libre'`). Mêmes gabarits que le
-- seed d'origine (20260608120000) et que le thème IB (20260617130000).
--
-- Le parcours naît `coming_soon` : la carte s'affiche, non navigable, tant que
-- le corpus n'est pas appliqué en prod — un thème sans matière mènerait à une
-- page vide. Une migration ultérieure le bascule en `available`.
-- =========================================================

-- 1) Le thème racine -------------------------------------------------------
INSERT INTO public.themes
  (id, name_fr, description, icon, color_token, content_language, has_grades, display_order)
VALUES
  ('education-islamique', 'Éducation islamique',
   'Les fondamentaux de la pratique et des valeurs, expliqués simplement : le fiqh malikite d''après « La Risâla » d''Ibn Abî Zayd al-Qayrawânî, les actes du culte et les règles de vie.',
   'MoonStar', 'subject-arabic', 'ar', false, 9)
ON CONFLICT (id) DO NOTHING;

-- 2) Le parcours libre qui porte le thème dans les extras ------------------
INSERT INTO public.parcours
  (id, name_fr, name_en, name_ar, kind, theme_id, grade_id,
   is_premium, preview_policy, display_order, icon, color, status)
VALUES
  ('education-islamique', 'Éducation islamique', 'Islamic education', 'التربية الإسلامية',
   'libre', 'education-islamique', NULL,
   false, 'full', 19, 'MoonStar', 'subject-arabic', 'coming_soon')
ON CONFLICT (id) DO NOTHING;
