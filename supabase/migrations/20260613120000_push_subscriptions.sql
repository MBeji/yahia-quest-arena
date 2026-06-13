-- =========================================================
-- Web push subscriptions (PWA notifications)
-- ---------------------------------------------------------
-- One row per (user, browser/device) push endpoint, so the server can deliver
-- Web Push notifications (v1: streak-at-risk reminder; later: daily objective,
-- weekly parent report). A push endpoint is globally unique to a device.
--
-- Security posture (mirrors the "revoke direct writes, go through RPC" pattern):
--  * RLS is ENABLED with NO policies and NO table grants to anon/authenticated,
--    so the table is unreachable through PostgREST by clients.
--  * Clients write ONLY through the two SECURITY DEFINER RPCs below
--    (save / delete), which key everything off auth.uid().
--  * The cron SENDER reads/prunes rows with the service-role key, which bypasses
--    RLS (see src/features/notifications/notifications.cron.server.ts).
-- =========================================================

CREATE TABLE IF NOT EXISTS public.push_subscriptions (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  endpoint        TEXT NOT NULL UNIQUE,
  p256dh          TEXT NOT NULL,
  auth            TEXT NOT NULL,
  user_agent      TEXT,
  failure_count   INTEGER NOT NULL DEFAULT 0,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_success_at TIMESTAMPTZ
);

ALTER TABLE public.push_subscriptions ENABLE ROW LEVEL SECURITY;

CREATE INDEX IF NOT EXISTS idx_push_subscriptions_user
  ON public.push_subscriptions (user_id);

-- No policies + no grants: clients cannot reach the table directly. All client
-- access flows through the SECURITY DEFINER RPCs below.

-- Upsert the calling user's subscription (idempotent on the unique endpoint).
-- ON CONFLICT reassigns ownership: if a device that was bound to user A is later
-- used by user B, the row is rebound to B (and its failure_count reset), instead
-- of leaking A's row or erroring on the unique endpoint.
CREATE OR REPLACE FUNCTION public.save_push_subscription(
  p_endpoint   TEXT,
  p_p256dh     TEXT,
  p_auth       TEXT,
  p_user_agent TEXT DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  INSERT INTO public.push_subscriptions (user_id, endpoint, p256dh, auth, user_agent)
  VALUES (auth.uid(), p_endpoint, p_p256dh, p_auth, p_user_agent)
  ON CONFLICT (endpoint) DO UPDATE
    SET user_id       = auth.uid(),
        p256dh        = EXCLUDED.p256dh,
        auth          = EXCLUDED.auth,
        user_agent    = EXCLUDED.user_agent,
        failure_count = 0;
END;
$$;

REVOKE ALL ON FUNCTION public.save_push_subscription(TEXT, TEXT, TEXT, TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.save_push_subscription(TEXT, TEXT, TEXT, TEXT) TO authenticated;

-- Remove the calling user's subscription for a given endpoint (unsubscribe).
CREATE OR REPLACE FUNCTION public.delete_push_subscription(p_endpoint TEXT)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;
  DELETE FROM public.push_subscriptions
  WHERE endpoint = p_endpoint AND user_id = auth.uid();
END;
$$;

REVOKE ALL ON FUNCTION public.delete_push_subscription(TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.delete_push_subscription(TEXT) TO authenticated;
