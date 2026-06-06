-- =========================================================
-- Beta tester free premium access requests
-- ---------------------------------------------------------
-- A user can request free premium access as a beta tester. The request is
-- stored with a pending status; an admin approves/rejects it. On approval the
-- user's premium is unlocked automatically (subscription_expires_at in the
-- future), reusing the same gate as paid subscriptions.
--
-- Security: only the requester can read/insert their own row (RLS); only an
-- admin can list all requests and review them (SECURITY DEFINER RPCs that check
-- is_admin()). The premium grant is done inside the review RPC — the client
-- never has the power to grant premium (mirrors admin_set_subscription).
-- =========================================================

-- 1) Allow a 'beta' subscription type (free premium granted to beta testers).
DO $$
DECLARE c text;
BEGIN
  SELECT conname INTO c
  FROM pg_constraint
  WHERE conrelid = 'public.profiles'::regclass
    AND contype = 'c'
    AND pg_get_constraintdef(oid) ILIKE '%subscription_type%';
  IF c IS NOT NULL THEN
    EXECUTE format('ALTER TABLE public.profiles DROP CONSTRAINT %I', c);
  END IF;
  ALTER TABLE public.profiles
    ADD CONSTRAINT profiles_subscription_type_check
    CHECK (subscription_type IN ('monthly', 'quarterly', 'annual', 'beta'));
END $$;

-- 2) Requests table.
CREATE TABLE IF NOT EXISTS public.beta_access_requests (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name        TEXT NOT NULL,
  email       TEXT NOT NULL,
  motivation  TEXT,
  status      TEXT NOT NULL DEFAULT 'pending'
                CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  reviewed_at TIMESTAMPTZ,
  reviewed_by UUID REFERENCES auth.users(id)
);

ALTER TABLE public.beta_access_requests ENABLE ROW LEVEL SECURITY;

-- At most one pending request per user.
CREATE UNIQUE INDEX IF NOT EXISTS uq_beta_pending_per_user
  ON public.beta_access_requests (user_id)
  WHERE status = 'pending';

CREATE INDEX IF NOT EXISTS idx_beta_requests_status_created
  ON public.beta_access_requests (status, created_at DESC);

-- RLS: a user reads/creates only their own request; admins read everything.
DROP POLICY IF EXISTS "beta read own or admin" ON public.beta_access_requests;
CREATE POLICY "beta read own or admin" ON public.beta_access_requests
  FOR SELECT USING (user_id = auth.uid() OR public.is_admin());

DROP POLICY IF EXISTS "beta insert own pending" ON public.beta_access_requests;
CREATE POLICY "beta insert own pending" ON public.beta_access_requests
  FOR INSERT WITH CHECK (user_id = auth.uid() AND status = 'pending');

-- No UPDATE/DELETE for authenticated — reviewing goes through the admin RPC.
GRANT SELECT, INSERT ON public.beta_access_requests TO authenticated;

-- 3) Admin: list all requests (pending first).
CREATE OR REPLACE FUNCTION public.admin_list_beta_requests()
RETURNS TABLE (
  id UUID,
  user_id UUID,
  name TEXT,
  email TEXT,
  motivation TEXT,
  status TEXT,
  created_at TIMESTAMPTZ,
  reviewed_at TIMESTAMPTZ
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
    SELECT b.id, b.user_id, b.name, b.email, b.motivation, b.status, b.created_at, b.reviewed_at
    FROM public.beta_access_requests b
    ORDER BY (b.status = 'pending') DESC, b.created_at DESC;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_list_beta_requests() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_list_beta_requests() TO authenticated;

-- 4) Admin: count of pending requests (for the nav badge).
CREATE OR REPLACE FUNCTION public.admin_pending_beta_count()
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
  SELECT count(*) INTO n FROM public.beta_access_requests WHERE status = 'pending';
  RETURN n;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_pending_beta_count() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_pending_beta_count() TO authenticated;

-- 5) Admin: approve/reject. On approval, grant 3 months of free premium
--    (keep the interval in sync with BETA_ACCESS_MONTHS in constants).
CREATE OR REPLACE FUNCTION public.admin_review_beta_request(p_request UUID, p_approve BOOLEAN)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID;
  v_status TEXT;
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT user_id, status INTO v_user, v_status
  FROM public.beta_access_requests
  WHERE id = p_request;

  IF v_user IS NULL THEN
    RAISE EXCEPTION 'REQUEST_NOT_FOUND';
  END IF;
  IF v_status <> 'pending' THEN
    RAISE EXCEPTION 'ALREADY_REVIEWED';
  END IF;

  UPDATE public.beta_access_requests
  SET status = CASE WHEN p_approve THEN 'approved' ELSE 'rejected' END,
      reviewed_at = now(),
      reviewed_by = auth.uid()
  WHERE id = p_request;

  IF p_approve THEN
    UPDATE public.profiles
    SET subscription_type = 'beta',
        subscription_activated_at = now(),
        subscription_expires_at = now() + INTERVAL '3 months'
    WHERE id = v_user;
  END IF;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_review_beta_request(UUID, BOOLEAN) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_review_beta_request(UUID, BOOLEAN) TO authenticated;
