-- =========================================================
-- Full Tunisian school ladder as parcours + "interest" votes
-- ---------------------------------------------------------
-- MUST BE APPLIED TO THE DB *BEFORE* THE CODE THAT DEPENDS ON IT IS DEPLOYED
-- (see CLAUDE.md §7). Purely additive and idempotent.
--
-- WHY ------------------------------------------------------------------------
-- The catalogue only exposed 2 school parcours (concours-9eme available,
-- concours-6eme coming_soon) even though `grades` already holds the full ladder
-- (1ère année de base → Baccalauréat, 13 levels). The other 11 classes were
-- invisible. We now seed one parcours per remaining grade, all marked
-- `coming_soon` ("en construction"), and let a signed-in user register *interest*
-- in a coming-soon parcours so the team can prioritise the most-requested class.
--
-- The 3 national-exam years stay/become premium `concours` parcours (6ème, 9ème,
-- Bac); the 10 regular years are free `scolaire` parcours. A coming_soon parcours
-- is selectable on purpose (a family gets a home) — only its *content* is absent.
--
-- Interest votes reuse the `beta_access_requests` security shape: RLS table read
-- by owner/admin only, NO direct client writes (all writes go through a
-- SECURITY DEFINER toggle RPC), plus a PII-free aggregate-count RPC that powers
-- both the public "X intéressé·e·s" card badge and the admin priority ranking.
-- =========================================================


-- =========================================================
-- 1) Widen parcours.kind to allow a regular school-year track ('scolaire')
-- ---------------------------------------------------------
-- 'concours' = premium national-exam prep, 'libre' = free standalone theme,
-- 'scolaire' = a regular (non-exam) school year. Drop the inline CHECK by its
-- discovered name (robust to auto-naming), then re-add the widened one.
-- =========================================================
DO $$
DECLARE c text;
BEGIN
  SELECT conname INTO c
  FROM pg_constraint
  WHERE conrelid = 'public.parcours'::regclass
    AND contype = 'c'
    AND pg_get_constraintdef(oid) ILIKE '%kind%';
  IF c IS NOT NULL THEN
    EXECUTE format('ALTER TABLE public.parcours DROP CONSTRAINT %I', c);
  END IF;
  ALTER TABLE public.parcours
    ADD CONSTRAINT parcours_kind_check
    CHECK (kind IN ('concours', 'libre', 'scolaire'));
END $$;


-- =========================================================
-- 2) Seed one parcours per remaining school grade
-- ---------------------------------------------------------
-- grade_id is resolved by subselect on grades.slug (never hard-coded), exactly
-- like the existing concours seed. The unique (theme_id, grade_id) index already
-- guards against a duplicate parcours per grade; ON CONFLICT (id) makes re-runs
-- safe. Baccalauréat = a national-exam year -> premium concours, coming_soon.
-- =========================================================
INSERT INTO public.parcours
  (id, name_fr, kind, theme_id, grade_id, is_premium, preview_policy, display_order, icon, color, status)
SELECT 'concours-bac', 'Préparation Concours Bac', 'concours', 'ecole-tn', g.id,
       true, 'difficulty_1', g.display_order, 'GraduationCap', 'subject-math', 'coming_soon'
FROM public.grades g
WHERE g.theme_id = 'ecole-tn' AND g.slug = 'bac'
ON CONFLICT (id) DO NOTHING;

-- The 10 regular years (primaire/collège/secondaire, excluding the 6ème/9ème/Bac
-- exam years already covered): free `scolaire` parcours, all coming_soon. Reuses
-- the grade's own name_fr + display_order so the catalogue reads in school order.
INSERT INTO public.parcours
  (id, name_fr, kind, theme_id, grade_id, is_premium, preview_policy, display_order, icon, color, status)
SELECT 'ecole-' || g.slug, g.name_fr, 'scolaire', 'ecole-tn', g.id,
       false, 'full', g.display_order, 'GraduationCap', 'subject-math', 'coming_soon'
FROM public.grades g
WHERE g.theme_id = 'ecole-tn'
  AND g.slug IN ('1ere-base', '2eme-base', '3eme-base', '4eme-base', '5eme-base',
                 '7eme-base', '8eme-base', '1ere-sec', '2eme-sec', '3eme-sec')
ON CONFLICT (id) DO NOTHING;


-- =========================================================
-- 3) parcours_interest — one "interest" vote per (user, parcours)
-- ---------------------------------------------------------
-- Mirrors the beta_access_requests security model: RLS-scoped reads, no direct
-- client writes (REVOKE), writes only through the toggle RPC below.
-- =========================================================
CREATE TABLE IF NOT EXISTS public.parcours_interest (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  parcours_id TEXT NOT NULL REFERENCES public.parcours(id) ON DELETE CASCADE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, parcours_id)          -- one vote per user per parcours (toggle)
);

ALTER TABLE public.parcours_interest ENABLE ROW LEVEL SECURITY;

-- Ranking/lookup by parcours.
CREATE INDEX IF NOT EXISTS idx_parcours_interest_parcours
  ON public.parcours_interest (parcours_id);

-- Read your own votes (drives the toggle state); admins read all (ranking).
DROP POLICY IF EXISTS "interest read own or admin" ON public.parcours_interest;
CREATE POLICY "interest read own or admin" ON public.parcours_interest
  FOR SELECT USING (user_id = auth.uid() OR public.is_admin());

-- No direct client writes — the toggle goes through the SECURITY DEFINER RPC.
-- Explicit grants required (CLAUDE.md "New tables need EXPLICIT grants").
REVOKE INSERT, UPDATE, DELETE ON public.parcours_interest FROM authenticated, anon;
REVOKE ALL ON public.parcours_interest FROM anon;
GRANT SELECT ON public.parcours_interest TO authenticated;


-- =========================================================
-- 4) toggle_parcours_interest — add/remove the caller's vote (coming_soon only)
-- ---------------------------------------------------------
-- Self-scoped. Returns the NEW state (true = interested, false = removed). Only
-- allowed on a `coming_soon` parcours (voting prioritises not-yet-built classes).
-- =========================================================
CREATE OR REPLACE FUNCTION public.toggle_parcours_interest(p_parcours TEXT)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_uid    UUID := auth.uid();
  v_status TEXT;
  v_deleted INT;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  SELECT status INTO v_status FROM public.parcours WHERE id = p_parcours;
  IF v_status IS NULL THEN
    RAISE EXCEPTION 'UNKNOWN_PARCOURS:%', p_parcours;
  END IF;
  IF v_status <> 'coming_soon' THEN
    RAISE EXCEPTION 'PARCOURS_NOT_COMING_SOON:%', p_parcours;
  END IF;

  DELETE FROM public.parcours_interest
  WHERE user_id = v_uid AND parcours_id = p_parcours;
  GET DIAGNOSTICS v_deleted = ROW_COUNT;
  IF v_deleted > 0 THEN
    RETURN false;                        -- toggled OFF
  END IF;

  INSERT INTO public.parcours_interest (user_id, parcours_id)
  VALUES (v_uid, p_parcours)
  ON CONFLICT (user_id, parcours_id) DO NOTHING;
  RETURN true;                           -- toggled ON
END;
$$;

REVOKE ALL ON FUNCTION public.toggle_parcours_interest(TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.toggle_parcours_interest(TEXT) TO authenticated;


-- =========================================================
-- 5) parcours_interest_counts — aggregate, PII-free ranking
-- ---------------------------------------------------------
-- One row per coming_soon parcours with its live vote count, busiest first.
-- SECURITY DEFINER so it can aggregate past RLS, but returns NO user identity —
-- safe to expose to any authenticated user (the public "X intéressé·e·s" badge)
-- and reused by the admin priority ranking.
-- =========================================================
CREATE OR REPLACE FUNCTION public.parcours_interest_counts()
RETURNS TABLE (parcours_id TEXT, name_fr TEXT, interest_count BIGINT)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT p.id, p.name_fr, count(i.id)
  FROM public.parcours p
  LEFT JOIN public.parcours_interest i ON i.parcours_id = p.id
  WHERE p.status = 'coming_soon'
  GROUP BY p.id, p.name_fr
  ORDER BY count(i.id) DESC, p.display_order;
$$;

REVOKE ALL ON FUNCTION public.parcours_interest_counts() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.parcours_interest_counts() TO authenticated;
