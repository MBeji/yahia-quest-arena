-- Étude 15 lot 10 (D-8 c) — persist the chosen role at signup, fixing the parent
-- role bug on the email-confirmation path.
--
-- Bug: a visitor who picks « Parent » at signup only had that role applied by the
-- authenticated `bootstrapProfile` server fn (via `set_profile_role`). When email
-- confirmation is required there is NO session at signup, so bootstrap never runs —
-- `handle_new_user` created the profile with the DEFAULT 'student' role, and the
-- parent never reached the family surfaces. The role choice was silently lost.
--
-- Fix (additive, CREATE OR REPLACE): `handle_new_user` now reads the role from the
-- signUp metadata (`raw_user_meta_data->>'role'`, which the client sets alongside
-- display_name) and lands it on the fresh profile row. Only 'student' | 'parent' are
-- ever accepted (anything else — incl. 'admin' — falls back to 'student'); admin
-- stays out-of-band. Since this may write a NON-default role, the function authorises
-- the write past `prevent_role_escalation` with the SAME per-transaction GUC that
-- `set_profile_role` uses (`app.allow_role_change`) — a definer-only flag a PostgREST
-- request can never set. The display_name 80-char bound (finding #9) is preserved, and
-- CREATE OR REPLACE keeps the existing REVOKEs on the function.
--
-- Backward-compatible: signups without a role in metadata (older clients) still land
-- the default 'student', exactly as before. Safe to apply ahead of the client change.

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_role text := CASE
    WHEN NEW.raw_user_meta_data->>'role' IN ('student', 'parent')
      THEN NEW.raw_user_meta_data->>'role'
    ELSE 'student'
  END;
BEGIN
  -- Authorise the (possibly non-default) role write for THIS transaction only,
  -- the sanctioned definer path also used by set_profile_role. Never 'admin'.
  PERFORM set_config('app.allow_role_change', 'on', true);

  INSERT INTO public.profiles (id, display_name, role)
  VALUES (
    NEW.id,
    left(
      COALESCE(NEW.raw_user_meta_data->>'display_name', split_part(NEW.email, '@', 1), 'Aspirant'),
      80
    ),
    v_role
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;
