-- Duels — resume-not-pile-up fix (étude 05 follow-up).
-- ---------------------------------------------------------------------------
-- Bug observed in prod: when two players search at the same time, match_duel
-- returns the new duel id ONLY to the second arriver (who navigates in). The
-- first (waiting) player keeps polling match_duel, which re-enqueues them and
-- returns NULL — so they are never pulled into the duel they were just paired
-- into. Each poll round recreates a duel, stacking "Duels en cours" up to the
-- DUEL_MAX_ACTIVE cap (3), after which every match attempt raises and the hub
-- spins on "Recherche d'un adversaire…" forever.
--
-- Fix (server, authoritative): before queuing/pairing, if the caller already
-- has an ACTIVE duel they have NOT finished, return it. The waiting player's
-- next poll then returns that duel id and the client navigates in; a player can
-- hold at most ONE unfinished-active duel via matchmaking, so the pile-up (and
-- the resulting silent cap failure) can no longer happen. A player who has
-- finished THEIR side of an active duel (finished_at set, opponent still
-- playing) is not short-circuited and may start another — the R-10 cap still
-- guards that path. Idempotent (CREATE OR REPLACE); no schema change.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.match_duel()
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_parcours TEXT;
  v_grade UUID;
  v_theme TEXT;
  v_active INT;
  v_existing UUID;
  v_opponent UUID;
  v_questions UUID[];
  v_duel_id UUID;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  -- The caller duels on their ACTIVE parcours (server-resolved — R-1 can't be
  -- spoofed by the client).
  SELECT current_parcours_id, current_grade_id
    INTO v_parcours, v_grade
    FROM public.profiles WHERE id = v_user;
  IF v_parcours IS NULL THEN
    RAISE EXCEPTION 'No active parcours: pick a track before dueling.';
  END IF;

  -- Resume, never pile up: if the caller already has an ACTIVE duel they have
  -- not finished, send them straight back to it instead of matchmaking a new
  -- one. This pulls a just-paired waiting player into their duel on the next
  -- poll and caps unfinished-active duels at one per player (see file header).
  SELECT p.duel_id INTO v_existing
    FROM public.duel_participants p
    JOIN public.duels d ON d.id = p.duel_id
    WHERE p.user_id = v_user
      AND d.status = 'active'
      AND p.finished_at IS NULL
    ORDER BY d.created_at DESC
    LIMIT 1;
  IF v_existing IS NOT NULL THEN
    DELETE FROM public.duel_queue WHERE user_id = v_user;  -- drop any stale queue row
    RETURN v_existing;
  END IF;

  -- R-10: cap on simultaneously-active duels.
  SELECT count(*) INTO v_active
    FROM public.duel_participants p
    JOIN public.duels d ON d.id = p.duel_id
    WHERE p.user_id = v_user AND d.status = 'active';
  IF v_active >= 3 THEN  -- DUEL_MAX_ACTIVE
    RAISE EXCEPTION 'Too many active duels (max 3).';
  END IF;

  -- Upsert the caller into the queue (R-10: PK user_id → at most one entry).
  INSERT INTO public.duel_queue (user_id, parcours_id, grade_id)
  VALUES (v_user, v_parcours, v_grade)
  ON CONFLICT (user_id) DO UPDATE SET parcours_id = EXCLUDED.parcours_id,
                                      grade_id = EXCLUDED.grade_id;

  -- Try to pair the two oldest compatible entries (same parcours). SKIP LOCKED
  -- makes two concurrent callers cooperate instead of both grabbing the same row
  -- (D-2 / RISK-4): each locks a disjoint pair or one gets nothing.
  SELECT user_id INTO v_opponent
    FROM public.duel_queue
    WHERE parcours_id = v_parcours AND user_id <> v_user
    ORDER BY enqueued_at
    FOR UPDATE SKIP LOCKED
    LIMIT 1;

  IF v_opponent IS NULL THEN
    RETURN NULL;  -- still waiting for an opponent
  END IF;

  -- Lock the caller's own row too, so a concurrent match_duel for the opponent
  -- can't also pair us.
  PERFORM 1 FROM public.duel_queue WHERE user_id = v_user FOR UPDATE SKIP LOCKED;

  -- Freeze the shared question set (R-2) from the parcours pool: questions of
  -- non-quiz exercises whose subject is in the parcours' (theme, grade).
  SELECT theme_id INTO v_theme FROM public.parcours WHERE id = v_parcours;
  SELECT array_agg(qid) INTO v_questions FROM (
    SELECT q.id AS qid
    FROM public.questions q
    JOIN public.exercises e ON e.id = q.exercise_id
    JOIN public.subjects s ON s.id = e.subject_id
    WHERE s.theme_id = v_theme
      AND s.grade_id IS NOT DISTINCT FROM v_grade
      AND e.mode <> 'quiz'
    ORDER BY random()
    LIMIT 5  -- DUEL_QUESTION_COUNT
  ) pool;

  -- No pool → cannot form a fair duel; leave both queued (return NULL).
  IF v_questions IS NULL OR array_length(v_questions, 1) IS NULL THEN
    RETURN NULL;
  END IF;

  INSERT INTO public.duels (parcours_id, question_ids, status, expires_at)
  VALUES (v_parcours, v_questions, 'active', now() + INTERVAL '24 hours')  -- DUEL_EXPIRY_HOURS
  RETURNING id INTO v_duel_id;

  INSERT INTO public.duel_participants (duel_id, user_id) VALUES
    (v_duel_id, v_user), (v_duel_id, v_opponent);

  DELETE FROM public.duel_queue WHERE user_id IN (v_user, v_opponent);

  RETURN v_duel_id;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.match_duel() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.match_duel() TO authenticated;
