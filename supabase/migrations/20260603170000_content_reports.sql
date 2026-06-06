-- =========================================================
-- Content error reports ("Signaler une erreur")
-- ---------------------------------------------------------
-- Any signed-in user can report a suspected mistake in an exercise/question
-- (wrong answer key, typo…). Reports are admin-reviewed. Same security model as
-- beta_access_requests: a user reads/creates only their own rows (RLS); admins
-- list and resolve via SECURITY DEFINER RPCs that check is_admin().
-- =========================================================

CREATE TABLE IF NOT EXISTS public.content_reports (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  exercise_id UUID REFERENCES public.exercises(id) ON DELETE CASCADE,
  question_id UUID REFERENCES public.questions(id) ON DELETE SET NULL,
  message     TEXT NOT NULL,
  status      TEXT NOT NULL DEFAULT 'open'
                CHECK (status IN ('open', 'resolved', 'dismissed')),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  resolved_at TIMESTAMPTZ,
  resolved_by UUID REFERENCES auth.users(id)
);

ALTER TABLE public.content_reports ENABLE ROW LEVEL SECURITY;

CREATE INDEX IF NOT EXISTS idx_content_reports_status_created
  ON public.content_reports (status, created_at DESC);

DROP POLICY IF EXISTS "content reports read own or admin" ON public.content_reports;
CREATE POLICY "content reports read own or admin" ON public.content_reports
  FOR SELECT USING (user_id = auth.uid() OR public.is_admin());

DROP POLICY IF EXISTS "content reports insert own" ON public.content_reports;
CREATE POLICY "content reports insert own" ON public.content_reports
  FOR INSERT WITH CHECK (user_id = auth.uid() AND status = 'open');

GRANT SELECT, INSERT ON public.content_reports TO authenticated;

-- Admin: list reports (open first) with exercise context.
CREATE OR REPLACE FUNCTION public.admin_list_content_reports()
RETURNS TABLE (
  id UUID,
  message TEXT,
  status TEXT,
  created_at TIMESTAMPTZ,
  exercise_id UUID,
  exercise_title TEXT,
  subject_id TEXT,
  question_id UUID
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
    SELECT r.id, r.message, r.status, r.created_at, r.exercise_id,
           e.title, e.subject_id, r.question_id
    FROM public.content_reports r
    LEFT JOIN public.exercises e ON e.id = r.exercise_id
    ORDER BY (r.status = 'open') DESC, r.created_at DESC;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_list_content_reports() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_list_content_reports() TO authenticated;

-- Admin: count of open reports (nav badge).
CREATE OR REPLACE FUNCTION public.admin_open_reports_count()
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
  SELECT count(*) INTO n FROM public.content_reports WHERE status = 'open';
  RETURN n;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_open_reports_count() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_open_reports_count() TO authenticated;

-- Admin: resolve or dismiss a report.
CREATE OR REPLACE FUNCTION public.admin_resolve_content_report(p_report UUID, p_status TEXT)
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

  UPDATE public.content_reports
  SET status = p_status,
      resolved_at = now(),
      resolved_by = auth.uid()
  WHERE id = p_report;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'REPORT_NOT_FOUND';
  END IF;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_resolve_content_report(UUID, TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_resolve_content_report(UUID, TEXT) TO authenticated;
