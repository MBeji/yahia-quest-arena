-- =========================================================
-- Harden push_subscriptions to the RPC-only access model (S9).
-- ---------------------------------------------------------
-- 20260613120000_push_subscriptions.sql enables RLS with NO policies and routes
-- every client operation through the SECURITY DEFINER RPCs
-- save_push_subscription / delete_push_subscription. It never revoked the table
-- privileges that Supabase's default-privileges grant to anon/authenticated when
-- a table is created, so push_subscriptions carried INERT (RLS already denied
-- them) but convention-breaking direct grants — flagged by
-- supabase/tests/09_push_subscriptions.test.sql (S9a) and by CLAUDE.md's rule
-- that every new table migration must control its own grants.
--
-- Revoke them from the client roles. RLS (enabled, no policy) already blocked all
-- direct access, so this is a no-op at runtime; it just makes the RPC-only model
-- explicit and consistent with the rest of the schema. service_role (the cron
-- sender that saves/prunes subscriptions) is intentionally untouched, as are the
-- two RPC EXECUTE grants.
-- =========================================================

REVOKE ALL ON public.push_subscriptions FROM anon, authenticated;
