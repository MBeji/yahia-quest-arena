
REVOKE EXECUTE ON FUNCTION public.handle_new_user() FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.award_xp(uuid, int) FROM PUBLIC, anon, authenticated;
