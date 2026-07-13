-- Security hardening (public-surface audit 2026-07, finding #9) — bound the
-- pre-authentication display_name write.
--
-- `handle_new_user` runs on auth signup and stores
-- `raw_user_meta_data->>'display_name'` verbatim. That metadata is
-- attacker-controlled and, on the email-confirmation-pending path, is written
-- WITHOUT passing through the validated `bootstrapProfile` server fn (which caps
-- the name at 80 chars). Align the trigger with that validated path by truncating
-- to 80 characters, so no unbounded string is persisted from an unauthenticated
-- request. Additive (CREATE OR REPLACE) — safe to apply before/independent of
-- code; existing REVOKEs on the function are preserved by CREATE OR REPLACE.

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, display_name)
  VALUES (
    NEW.id,
    left(
      COALESCE(NEW.raw_user_meta_data->>'display_name', split_part(NEW.email, '@', 1), 'Aspirant'),
      80
    )
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;
