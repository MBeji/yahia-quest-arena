-- =========================================================
-- Bug reports ("Signaler un bug") — beta-phase feedback channel
-- ---------------------------------------------------------
-- The platform shows a "Bêta" badge during the test phase; any signed-in user
-- can report a general problem (broken UI, stuck flow, perf…) from a floating
-- launcher. This is DISTINCT from content_reports (which flags a mistake in a
-- specific exercise/question). Same security model as content_reports /
-- beta_access_requests: a user reads/creates only their own rows (RLS); admins
-- list and resolve via SECURITY DEFINER RPCs that check is_admin().
-- =========================================================

CREATE TABLE IF NOT EXISTS public.bug_reports (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  message     TEXT NOT NULL,
  page        TEXT,
  status      TEXT NOT NULL DEFAULT 'open'
                CHECK (status IN ('open', 'resolved', 'dismissed')),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  resolved_at TIMESTAMPTZ,
  resolved_by UUID REFERENCES auth.users(id)
);

ALTER TABLE public.bug_reports ENABLE ROW LEVEL SECURITY;

CREATE INDEX IF NOT EXISTS idx_bug_reports_status_created
  ON public.bug_reports (status, created_at DESC);

DROP POLICY IF EXISTS "bug reports read own or admin" ON public.bug_reports;
CREATE POLICY "bug reports read own or admin" ON public.bug_reports
  FOR SELECT USING (user_id = auth.uid() OR public.is_admin());

DROP POLICY IF EXISTS "bug reports insert own" ON public.bug_reports;
CREATE POLICY "bug reports insert own" ON public.bug_reports
  FOR INSERT WITH CHECK (user_id = auth.uid() AND status = 'open');

GRANT SELECT, INSERT ON public.bug_reports TO authenticated;

-- Admin: list reports (open first).
CREATE OR REPLACE FUNCTION public.admin_list_bug_reports()
RETURNS TABLE (
  id UUID,
  message TEXT,
  page TEXT,
  status TEXT,
  created_at TIMESTAMPTZ
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
    SELECT r.id, r.message, r.page, r.status, r.created_at
    FROM public.bug_reports r
    ORDER BY (r.status = 'open') DESC, r.created_at DESC;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_list_bug_reports() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_list_bug_reports() TO authenticated;

-- Admin: count of open reports (nav badge).
CREATE OR REPLACE FUNCTION public.admin_open_bugs_count()
RETURNS INTEGER
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE n INTEGER;
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;
  SELECT count(*) INTO n FROM public.bug_reports WHERE status = 'open';
  RETURN n;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_open_bugs_count() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_open_bugs_count() TO authenticated;

-- Admin: resolve or dismiss a report.
CREATE OR REPLACE FUNCTION public.admin_resolve_bug_report(p_report UUID, p_status TEXT)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;
  IF p_status NOT IN ('resolved', 'dismissed') THEN
    RAISE EXCEPTION 'INVALID_STATUS:%', p_status;
  END IF;

  UPDATE public.bug_reports
  SET status = p_status,
      resolved_at = now(),
      resolved_by = auth.uid()
  WHERE id = p_report;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'REPORT_NOT_FOUND';
  END IF;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_resolve_bug_report(UUID, TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_resolve_bug_report(UUID, TEXT) TO authenticated;
