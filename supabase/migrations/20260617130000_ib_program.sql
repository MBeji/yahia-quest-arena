-- =========================================================
-- IB — International Baccalaureate program (coming soon, votable)
-- ---------------------------------------------------------
-- MUST BE APPLIED TO THE DB *BEFORE* THE CODE THAT DEPENDS ON IT IS DEPLOYED
-- (see CLAUDE.md §7). Purely additive and idempotent.
--
-- The redesigned "Découvrir" hub presents 5 root programs; IB is the new one,
-- empty for now. It is a standalone theme (no grades) with a single FREE parcours
-- in `coming_soon` status, so it surfaces in `getParcours` and is votable through
-- the existing `toggle_parcours_interest` RPC (which only allows coming_soon
-- parcours). No new tables: the interest mechanism is reused as-is.
-- =========================================================

-- 1) The IB root theme (mirrors the standalone themes seeded in 20260605120000).
INSERT INTO public.themes
  (id, name_fr, description, icon, color_token, content_language, has_grades, display_order)
VALUES
  ('ib', 'IB — International Baccalaureate',
   'Le programme international (International Baccalaureate). En cours de construction — dis-nous s''il t''intéresse.',
   'Award', 'subject-english', 'en', false, 8)
ON CONFLICT (id) DO NOTHING;

-- 2) The IB parcours — FREE, coming_soon (no content yet → votable, not enterable).
--    Mirrors the free-parcours seed shape from 20260608120000_parcours_entity.sql.
INSERT INTO public.parcours
  (id, name_fr, kind, theme_id, grade_id, is_premium, preview_policy, display_order, icon, color, status)
VALUES
  ('ib', 'IB — International Baccalaureate', 'libre', 'ib', NULL,
   false, 'full', 18, 'Award', 'subject-english', 'coming_soon')
ON CONFLICT (id) DO NOTHING;
