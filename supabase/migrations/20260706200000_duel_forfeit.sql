-- Duels — forfeit/close an active duel on demand (étude 05 follow-up).
-- ---------------------------------------------------------------------------
-- Without this, a participant is stuck in an active duel until the 24h expiry —
-- and once the opponent no-shows on enough duels, they hit the DUEL_MAX_ACTIVE
-- cap (3) and can no longer start new ones (match_duel raises). forfeit_duel
-- lets a participant end their own active duel now; fair settlement is delegated
-- to finalize_duel (whoever FINISHED wins — a lone finisher wins by forfait; a
-- caller who hasn't finished simply gets nothing). Idempotent via finalize_duel.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.forfeit_duel(p_duel UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  -- Only a participant of an ACTIVE duel may close it.
  PERFORM 1
    FROM public.duel_participants p
    JOIN public.duels d ON d.id = p.duel_id
    WHERE p.duel_id = p_duel AND p.user_id = v_user AND d.status = 'active';
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Not a participant of an active duel.';
  END IF;

  -- Expire it now, then settle (finalize_duel marks it expired and pays the
  -- finishers; non-finishers get nothing). Drop any stale queue row too.
  UPDATE public.duels SET expires_at = now() WHERE id = p_duel AND status = 'active';
  PERFORM public.finalize_duel(p_duel);
  DELETE FROM public.duel_queue WHERE user_id = v_user;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.forfeit_duel(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.forfeit_duel(UUID) TO authenticated;
