-- =========================================================
-- Parcours as a first-class, sellable entity + per-parcours entitlements
-- ---------------------------------------------------------
-- MUST BE APPLIED TO THE DB *BEFORE* THE CODE THAT DEPENDS ON IT IS DEPLOYED
-- (see CLAUDE.md §7). This migration is purely additive and idempotent: it
-- creates new tables/columns/RPCs and seeds rows, but NOTHING in the running app
-- reads them yet, so applying it is safe and behaviour-neutral on its own.
--
-- WHY ------------------------------------------------------------------------
-- The product is restructured around two families of *parcours* (tracks):
--   * PREMIUM "Concours" parcours (paid): the Tunisian national-exam prep —
--     `concours-9eme` (live) and `concours-6eme` (coming soon, no content yet).
--   * FREE "Exploration" parcours: culture générale, muscler ton cerveau (QI),
--     and the language tracks (anglais / français / arabe) — free for now, but
--     the entitlement model below is GENERIC so any parcours can flip premium.
--
-- A parcours is resolvable from a subject's (theme_id, grade_id) pair, so the
-- existing subjects are NEVER re-tagged:
--   * a concours parcours = (theme 'ecole-tn', a national-exam grade), and
--   * a free parcours      = a standalone non-school theme (grade_id NULL).
--
-- Access (enforced in a later migration's resolver + the server gate) replaces
-- the old all-or-nothing subscription + global "difficulty >= 3" paywall:
--   free parcours       -> always open
--   premium parcours    -> open when the user (or an active linked parent — the
--                          "family pack") holds a live entitlement, OR the
--                          exercise is in the FREE PREVIEW (difficulty 1 / the
--                          chapter comprehension quiz). preview_policy drives it.
--
-- Entitlements are provisioned out-of-band (manual, no Stripe) by an admin, or
-- granted to a beta tester; writes go only through the SECURITY DEFINER admin
-- RPCs below — clients can never self-grant.
-- =========================================================


-- =========================================================
-- 1) The `parcours` catalogue table (TEXT slug id, like `themes`)
-- =========================================================
CREATE TABLE IF NOT EXISTS public.parcours (
  id             TEXT PRIMARY KEY,                 -- slug: 'concours-9eme', 'culture-generale'…
  name_fr        TEXT NOT NULL,
  name_en        TEXT,                             -- nullable: themes/grades are monolingual today; defer to i18n
  name_ar        TEXT,
  kind           TEXT NOT NULL CHECK (kind IN ('concours', 'libre')),
  theme_id       TEXT NOT NULL REFERENCES public.themes(id) ON DELETE CASCADE,
  grade_id       UUID REFERENCES public.grades(id) ON DELETE CASCADE,  -- NULL for 'libre' parcours
  is_premium     BOOLEAN NOT NULL DEFAULT false,
  -- How much of a PREMIUM parcours is free without an entitlement:
  --   'none'        -> nothing (hard paywall on entry)
  --   'difficulty_1'-> difficulty-1 missions + the chapter comprehension quiz
  --   'full'        -> everything free (used by 'libre' parcours; is_premium=false also short-circuits)
  preview_policy TEXT NOT NULL DEFAULT 'difficulty_1'
                 CHECK (preview_policy IN ('none', 'difficulty_1', 'full')),
  display_order  INT NOT NULL DEFAULT 0,
  icon           TEXT NOT NULL,                    -- lucide icon name (mirrors themes.icon)
  color          TEXT NOT NULL,                    -- color token (mirrors themes.color_token)
  status         TEXT NOT NULL DEFAULT 'available'
                 CHECK (status IN ('available', 'coming_soon'))
);

-- A (theme_id, grade_id) pair maps to AT MOST ONE parcours, so a subject
-- resolves to its parcours unambiguously. COALESCE folds the NULL grade (libre).
CREATE UNIQUE INDEX IF NOT EXISTS uq_parcours_theme_grade
  ON public.parcours (theme_id, COALESCE(grade_id::text, '_'));
CREATE INDEX IF NOT EXISTS idx_parcours_order ON public.parcours (display_order);

ALTER TABLE public.parcours ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Parcours readable by all" ON public.parcours;
CREATE POLICY "Parcours readable by all" ON public.parcours FOR SELECT USING (true);

-- Catalogue rows are seed/admin-managed; no client writes (defence in depth on
-- top of RLS). SELECT stays open (public catalogue, also used on the landing).
REVOKE INSERT, UPDATE, DELETE ON public.parcours FROM authenticated, anon;
GRANT SELECT ON public.parcours TO anon, authenticated;


-- =========================================================
-- 2) The generic `parcours_entitlements` table (per-product access)
-- =========================================================
CREATE TABLE IF NOT EXISTS public.parcours_entitlements (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  parcours_id TEXT NOT NULL REFERENCES public.parcours(id) ON DELETE CASCADE,
  source      TEXT NOT NULL CHECK (source IN ('purchase', 'beta', 'gift', 'family')),
  granted_by  UUID REFERENCES auth.users(id),     -- admin/parent actor; NULL for system backfill
  granted_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  expires_at  TIMESTAMPTZ,                         -- NULL = perpetual
  revoked_at  TIMESTAMPTZ                          -- soft revoke; NULL = live
);

-- At most ONE live grant per (user, parcours). A revoked row frees the slot.
CREATE UNIQUE INDEX IF NOT EXISTS uq_live_entitlement
  ON public.parcours_entitlements (user_id, parcours_id) WHERE revoked_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_entitlement_live
  ON public.parcours_entitlements (user_id, parcours_id) WHERE revoked_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_entitlement_expiry ON public.parcours_entitlements (expires_at);

ALTER TABLE public.parcours_entitlements ENABLE ROW LEVEL SECURITY;

-- Read your own grants; admins read all; an active linked parent reads their
-- child's grants (family-pack visibility). Reuses the parent_student_links model.
DROP POLICY IF EXISTS "Entitlements readable by owner, admin or linked parent"
  ON public.parcours_entitlements;
CREATE POLICY "Entitlements readable by owner, admin or linked parent"
  ON public.parcours_entitlements
  FOR SELECT
  USING (
    user_id = auth.uid()
    OR public.is_admin()
    OR EXISTS (
      SELECT 1 FROM public.parent_student_links l
      WHERE l.parent_user_id = auth.uid()
        AND l.student_user_id = parcours_entitlements.user_id
        AND l.is_active
    )
  );

-- No client writes whatsoever — all grants/revokes go through the SECURITY
-- DEFINER admin RPCs below (which run as table owner and bypass RLS).
REVOKE INSERT, UPDATE, DELETE ON public.parcours_entitlements FROM authenticated, anon;
REVOKE ALL ON public.parcours_entitlements FROM anon;
GRANT SELECT ON public.parcours_entitlements TO authenticated;


-- =========================================================
-- 3) profiles.current_parcours_id — the student's active/primary track
-- ---------------------------------------------------------
-- Written ONLY by the `set_current_parcours` SECURITY DEFINER RPC below (which
-- runs as table owner), so — unlike `current_grade_id` — it deliberately needs
-- NO `authenticated` column grant. This sidesteps the column-grant trap from
-- 20260606150000_security_p0_hardening.sql (a granted-but-forgotten column makes
-- a direct PostgREST write silently no-op): there is simply no direct write path.
-- =========================================================
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS current_parcours_id TEXT REFERENCES public.parcours(id) ON DELETE SET NULL;


-- =========================================================
-- 4) Resolver + entitlement-check helpers
-- =========================================================

-- Resolve the parcours a (theme_id, grade_id) pair belongs to. `IS NOT DISTINCT
-- FROM` matches the NULL grade of 'libre' parcours. STABLE, no auth needed.
CREATE OR REPLACE FUNCTION public.resolve_subject_parcours(p_theme TEXT, p_grade UUID)
RETURNS TEXT
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT id
  FROM public.parcours
  WHERE theme_id = p_theme
    AND grade_id IS NOT DISTINCT FROM p_grade
  LIMIT 1;
$$;

REVOKE ALL ON FUNCTION public.resolve_subject_parcours(TEXT, UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.resolve_subject_parcours(TEXT, UUID) TO authenticated;

-- Does `p_user` have access to `p_parcours`? True when:
--   * the parcours is FREE (not premium), OR
--   * the user holds a live (non-revoked, non-expired) grant, OR
--   * an ACTIVE LINKED PARENT holds a live grant (the family pack — one parent
--     purchase covers their actively-linked children).
-- A missing/unknown parcours returns false (fail closed on the premium path).
CREATE OR REPLACE FUNCTION public.has_parcours_entitlement(p_user UUID, p_parcours TEXT)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT
    COALESCE((SELECT NOT is_premium FROM public.parcours WHERE id = p_parcours), false)
    OR EXISTS (
      SELECT 1
      FROM public.parcours_entitlements e
      WHERE e.parcours_id = p_parcours
        AND e.revoked_at IS NULL
        AND (e.expires_at IS NULL OR e.expires_at > now())
        AND (
          e.user_id = p_user
          OR EXISTS (
            SELECT 1 FROM public.parent_student_links l
            WHERE l.student_user_id = p_user
              AND l.parent_user_id = e.user_id
              AND l.is_active
          )
        )
    );
$$;

REVOKE ALL ON FUNCTION public.has_parcours_entitlement(UUID, TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.has_parcours_entitlement(UUID, TEXT) TO authenticated;

-- Convenience: same check addressed by subject id (joins subject -> parcours).
CREATE OR REPLACE FUNCTION public.has_parcours_entitlement_for_subject(p_user UUID, p_subject TEXT)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT public.has_parcours_entitlement(
    p_user,
    (SELECT public.resolve_subject_parcours(s.theme_id, s.grade_id)
       FROM public.subjects s WHERE s.id = p_subject)
  );
$$;

REVOKE ALL ON FUNCTION public.has_parcours_entitlement_for_subject(UUID, TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.has_parcours_entitlement_for_subject(UUID, TEXT) TO authenticated;


-- =========================================================
-- 5) set_current_parcours — the sanctioned onboarding write
-- ---------------------------------------------------------
-- Self-scoped. Sets the caller's current_parcours_id and, for a 'concours'
-- parcours, atomically syncs current_grade_id to that parcours' grade (a 'libre'
-- parcours clears the grade). A 'coming_soon' parcours is selectable on purpose
-- (a 6ème family gets a home; only its *content* is gated elsewhere).
-- =========================================================
CREATE OR REPLACE FUNCTION public.set_current_parcours(p_parcours TEXT)
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  rec public.profiles;
  v_uid UUID := auth.uid();
  v_grade UUID;
  v_exists BOOLEAN;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  SELECT grade_id, true INTO v_grade, v_exists
  FROM public.parcours WHERE id = p_parcours;

  IF NOT COALESCE(v_exists, false) THEN
    RAISE EXCEPTION 'UNKNOWN_PARCOURS:%', p_parcours;
  END IF;

  -- v_grade is NULL for 'libre' parcours -> clears the school grade.
  UPDATE public.profiles
  SET current_parcours_id = p_parcours,
      current_grade_id = v_grade
  WHERE id = v_uid
  RETURNING * INTO rec;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'USER_NOT_FOUND';
  END IF;

  RETURN rec;
END;
$$;

REVOKE ALL ON FUNCTION public.set_current_parcours(TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_current_parcours(TEXT) TO authenticated;


-- =========================================================
-- 6) Admin grant / revoke / list RPCs (is_admin()-guarded)
-- =========================================================

-- Grant (or extend) a live entitlement. Upserts against the live-grant slot:
-- an existing live row is updated in place, otherwise a new row is inserted.
CREATE OR REPLACE FUNCTION public.admin_grant_parcours(
  p_user UUID,
  p_parcours TEXT,
  p_source TEXT DEFAULT 'purchase',
  p_expires_at TIMESTAMPTZ DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_source IS NULL OR p_source NOT IN ('purchase', 'beta', 'gift', 'family') THEN
    RAISE EXCEPTION 'INVALID_SOURCE:%', p_source;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM public.parcours WHERE id = p_parcours) THEN
    RAISE EXCEPTION 'UNKNOWN_PARCOURS:%', p_parcours;
  END IF;

  UPDATE public.parcours_entitlements
  SET expires_at = p_expires_at,
      source = p_source,
      granted_by = auth.uid(),
      granted_at = now()
  WHERE user_id = p_user
    AND parcours_id = p_parcours
    AND revoked_at IS NULL;

  IF NOT FOUND THEN
    INSERT INTO public.parcours_entitlements (user_id, parcours_id, source, granted_by, expires_at)
    VALUES (p_user, p_parcours, p_source, auth.uid(), p_expires_at);
  END IF;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_grant_parcours(UUID, TEXT, TEXT, TIMESTAMPTZ) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_grant_parcours(UUID, TEXT, TEXT, TIMESTAMPTZ) TO authenticated;

-- Soft-revoke the live grant for (user, parcours).
CREATE OR REPLACE FUNCTION public.admin_revoke_parcours(p_user UUID, p_parcours TEXT)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  UPDATE public.parcours_entitlements
  SET revoked_at = now()
  WHERE user_id = p_user
    AND parcours_id = p_parcours
    AND revoked_at IS NULL;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_revoke_parcours(UUID, TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_revoke_parcours(UUID, TEXT) TO authenticated;

-- List all live entitlements (admin dashboard).
CREATE OR REPLACE FUNCTION public.admin_list_parcours_entitlements()
RETURNS TABLE (
  user_id UUID,
  display_name TEXT,
  email TEXT,
  parcours_id TEXT,
  parcours_name TEXT,
  source TEXT,
  granted_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ,
  is_active BOOLEAN
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  RETURN QUERY
  SELECT
    e.user_id,
    p.display_name,
    u.email::text,
    e.parcours_id,
    par.name_fr,
    e.source,
    e.granted_at,
    e.expires_at,
    (e.expires_at IS NULL OR e.expires_at > now())
  FROM public.parcours_entitlements e
  JOIN public.profiles p ON p.id = e.user_id
  LEFT JOIN auth.users u ON u.id = e.user_id
  JOIN public.parcours par ON par.id = e.parcours_id
  WHERE e.revoked_at IS NULL
  ORDER BY p.display_name, par.display_order;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_list_parcours_entitlements() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_list_parcours_entitlements() TO authenticated;


-- =========================================================
-- 7) Seed the parcours catalogue (2 concours + 6 free, one per non-school theme)
-- ---------------------------------------------------------
-- Concours grade UUIDs are resolved by subselect on grades.slug (never
-- hard-coded), consistent with the content pipeline.
-- =========================================================
INSERT INTO public.parcours
  (id, name_fr, kind, theme_id, grade_id, is_premium, preview_policy, display_order, icon, color, status)
VALUES
  ('concours-9eme', 'Préparation Concours 9ème', 'concours', 'ecole-tn',
     (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '9eme-base'),
     true, 'difficulty_1', 1, 'GraduationCap', 'subject-math', 'available'),
  ('concours-6eme', 'Préparation Concours 6ème', 'concours', 'ecole-tn',
     (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '6eme-base'),
     true, 'difficulty_1', 2, 'GraduationCap', 'subject-math', 'coming_soon')
ON CONFLICT (id) DO NOTHING;

-- Free parcours: one per non-school theme (id = theme id), inheriting the theme's
-- name/icon/color. is_premium=false + preview_policy='full' => entirely free.
INSERT INTO public.parcours
  (id, name_fr, kind, theme_id, grade_id, is_premium, preview_policy, display_order, icon, color, status)
SELECT t.id, t.name_fr, 'libre', t.id, NULL, false, 'full', t.display_order + 10, t.icon, t.color_token, 'available'
FROM public.themes t
WHERE t.has_grades = false
ON CONFLICT (id) DO NOTHING;


-- =========================================================
-- 8) fr-mastery ("Maîtrise du français") joins the FREE 'francais' parcours.
-- ---------------------------------------------------------
-- It was the lone is_premium subject under the now-free 'francais' parcours;
-- flip it off so a free parcours is genuinely free. (subjects.is_premium is kept
-- on the table but is no longer read by the gate once the resolver lands.)
-- =========================================================
UPDATE public.subjects SET is_premium = false WHERE id = 'fr-mastery';
