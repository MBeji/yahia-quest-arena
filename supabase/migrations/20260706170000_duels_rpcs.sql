-- Duels temps réel & ligues — lot 2 (FableEtudes/05-duels-ligues #lot-2).
--
-- Server-authoritative game logic (stop-point du lot : AUCUNE UI). Five RPCs +
-- a controlled reward helper + the expiry sweep, all SECURITY DEFINER with the
-- Dungeon posture (scoring is 100% server-side, the answer key never reaches the
-- client before the duel is finished — R-3/R-6, D-4):
--
--   * award_duel_rewards(user, xp, coins) — the ONLY reward path (D-5): mirrors
--     award_xp's level/class/tier curve but WITHOUT its self-only guard (it must
--     credit BOTH players from finalize_duel) and WITHOUT streak side-effects;
--     REVOKE'd from clients (only finalize_duel calls it).
--   * match_duel() — enqueue the caller on their active parcours, then pair the
--     two oldest compatible entries atomically (FOR UPDATE SKIP LOCKED, D-2),
--     freezing a shared question set (R-2) drawn from the parcours pool.
--   * submit_duel_answer(duel, question, choice) — ordered answer, server-timed
--     (R-5 too_fast → counted wrong), no key echoed until the duel is finished
--     (R-6); finalizes when both players are done.
--   * finalize_duel(duel) — decide winner, credit rewards under the daily cap
--     (R-7) / participation floor (R-8), flip status.
--   * get_duel_state(duel) — participant-only snapshot: own progress, opponent's
--     answered COUNT only (never their answers/score-in-progress), full review
--     only once finished.
--   * expire_duels() — the cron sweep for duels past expires_at (R-9).
--
-- Constants below mirror src/shared/constants/gamification.ts (DUEL_*), same
-- discipline as the Dungeon RPCs. Q-1 (barème) and Q-4 (open to all parcours,
-- no premium gate) are resolved in the study §7.

-- ---------------------------------------------------------------------------
-- 0. Reward-accounting column (additive): which duels already paid a player,
--    so the daily rewarded-duel cap (R-7) can be counted cheaply.
-- ---------------------------------------------------------------------------
ALTER TABLE public.duel_participants
  ADD COLUMN IF NOT EXISTS rewarded_at TIMESTAMPTZ;

-- ---------------------------------------------------------------------------
-- 1. award_duel_rewards — the controlled reward variant (D-5).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.award_duel_rewards(p_user UUID, p_xp INT, p_coins INT)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_profile public.profiles;
  v_level INT;
  v_class TEXT;
  v_tier INT;
BEGIN
  IF p_xp IS NULL OR p_xp < 0 OR p_coins IS NULL OR p_coins < 0 THEN
    RAISE EXCEPTION 'Invalid duel reward';
  END IF;

  SELECT * INTO v_profile FROM public.profiles WHERE id = p_user FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Profile not found';
  END IF;

  -- Same level curve as award_xp (200 XP/level); no streak side-effects — the
  -- streak system is owned by the exercise/quiz path.
  v_level := GREATEST(1, ((v_profile.xp + p_xp) / 200) + 1);
  v_class := CASE
    WHEN v_level >= 50 THEN 'S-Rank Legend'
    WHEN v_level >= 31 THEN 'Elite du Concours'
    WHEN v_level >= 21 THEN 'Maitre des Langues'
    WHEN v_level >= 11 THEN 'Guerrier des Equations'
    WHEN v_level >= 6 THEN 'Aspirant Academicien'
    ELSE 'Candidat Civil'
  END;
  v_tier := LEAST(6, GREATEST(1, (v_level / 8) + 1));

  UPDATE public.profiles
  SET xp = xp + p_xp,
      yahia_coins = yahia_coins + p_coins,
      level = v_level,
      hero_class = v_class,
      avatar_tier = v_tier
  WHERE id = p_user;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.award_duel_rewards(UUID, INT, INT) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 2. match_duel — enqueue + atomic pairing (D-2).
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

-- ---------------------------------------------------------------------------
-- 3. finalize_duel — decide the winner and credit rewards (R-7/R-8).
--    Idempotent: only acts on an 'active' duel. Called by the last submit (both
--    finished) or by expire_duels. Runs as owner, so it may award both players.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.finalize_duel(p_duel UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_duel public.duels;
  v_new_status TEXT;
  p RECORD;
  v_rewarded_today INT;
  v_xp INT;
  v_coins INT;
  v_win_xp CONSTANT INT := 60;  v_win_coins CONSTANT INT := 12;   -- DUEL_REWARDS.win
  v_draw_xp CONSTANT INT := 40; v_draw_coins CONSTANT INT := 8;   -- DUEL_REWARDS.draw
  v_loss_xp CONSTANT INT := 20; v_loss_coins CONSTANT INT := 4;   -- DUEL_REWARDS.loss
  v_all_finished BOOLEAN;
  v_top_score INT;
BEGIN
  SELECT * INTO v_duel FROM public.duels WHERE id = p_duel FOR UPDATE;
  IF NOT FOUND OR v_duel.status <> 'active' THEN
    RETURN;  -- unknown or already finalized (idempotent)
  END IF;

  -- Determine the new status: both finished → finished; else, if past expiry →
  -- expired; otherwise not ready (defensive no-op).
  SELECT bool_and(finished_at IS NOT NULL) INTO v_all_finished
    FROM public.duel_participants WHERE duel_id = p_duel;
  IF v_all_finished THEN
    v_new_status := 'finished';
  ELSIF now() >= v_duel.expires_at THEN
    v_new_status := 'expired';
  ELSE
    RETURN;
  END IF;

  -- The winning score = the max among players who FINISHED (an unfinished player
  -- in an expired duel cannot win). A unique finished top score wins; a tie among
  -- finishers is a draw; a lone finisher wins by forfait.
  SELECT max(score) INTO v_top_score
    FROM public.duel_participants
    WHERE duel_id = p_duel AND finished_at IS NOT NULL;

  FOR p IN
    SELECT * FROM public.duel_participants WHERE duel_id = p_duel
  LOOP
    -- Outcome → reward tier.
    IF p.finished_at IS NULL THEN
      v_xp := 0; v_coins := 0;                       -- did not finish (expired): nothing
    ELSIF p.score = v_top_score AND (
            SELECT count(*) FROM public.duel_participants
            WHERE duel_id = p_duel AND finished_at IS NOT NULL AND score = v_top_score
          ) = 1 THEN
      v_xp := v_win_xp; v_coins := v_win_coins;       -- unique top finisher: win/forfait
    ELSIF p.score = v_top_score THEN
      v_xp := v_draw_xp; v_coins := v_draw_coins;     -- tied top finishers: draw
    ELSE
      v_xp := v_loss_xp; v_coins := v_loss_coins;     -- finished but lower: participation
    END IF;

    -- Daily cap (R-7): count this player's already-rewarded duels today.
    IF v_xp > 0 THEN
      SELECT count(*) INTO v_rewarded_today
        FROM public.duel_participants
        WHERE user_id = p.user_id
          AND rewarded_at >= date_trunc('day', now());
      IF v_rewarded_today < 5 THEN  -- DUEL_MAX_REWARDED_PER_DAY
        PERFORM public.award_duel_rewards(p.user_id, v_xp, v_coins);
        UPDATE public.duel_participants
          SET rewarded_at = now()
          WHERE duel_id = p_duel AND user_id = p.user_id;
      END IF;
    END IF;
  END LOOP;

  UPDATE public.duels SET status = v_new_status WHERE id = p_duel;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.finalize_duel(UUID) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 4. submit_duel_answer — ordered, server-timed scoring (R-3/R-5/R-6).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.submit_duel_answer(
  p_duel UUID,
  p_question UUID,
  p_choice TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_duel public.duels;
  v_me public.duel_participants;
  v_answered INT;
  v_next INT;
  v_total INT;
  v_expected UUID;
  v_question public.questions;
  v_prev TIMESTAMPTZ;
  v_too_fast BOOLEAN := false;
  v_is_correct BOOLEAN;
  v_both_done BOOLEAN;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;
  IF p_duel IS NULL OR p_question IS NULL OR p_choice IS NULL OR btrim(p_choice) = '' THEN
    RAISE EXCEPTION 'Duel, question and choice are required';
  END IF;

  SELECT * INTO v_duel FROM public.duels WHERE id = p_duel FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Invalid duel.';
  END IF;
  IF v_duel.status <> 'active' THEN
    RAISE EXCEPTION 'Duel is not active.';
  END IF;
  IF now() >= v_duel.expires_at THEN
    RAISE EXCEPTION 'Duel has expired.';
  END IF;

  SELECT * INTO v_me FROM public.duel_participants
    WHERE duel_id = p_duel AND user_id = v_user FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'You are not a participant in this duel.';
  END IF;
  IF v_me.finished_at IS NOT NULL THEN
    RAISE EXCEPTION 'You have already finished this duel.';
  END IF;

  v_total := array_length(v_duel.question_ids, 1);
  v_answered := COALESCE(array_length(v_me.answers_submitted_at, 1), 0);
  v_next := v_answered + 1;
  v_expected := v_duel.question_ids[v_next];

  -- Questions are answered strictly in the frozen order (R-2). A mismatch is a
  -- replay / out-of-order attempt.
  IF p_question IS DISTINCT FROM v_expected THEN
    RAISE EXCEPTION 'Unexpected question (answer them in order).';
  END IF;

  SELECT * INTO v_question FROM public.questions WHERE id = p_question;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Question not found.';
  END IF;

  -- R-5 anti-cheat timing: seconds since the previous answer (or since the duel
  -- was created, for the first). Below the floor → too fast → counted wrong.
  v_prev := CASE WHEN v_answered = 0 THEN v_duel.created_at
                 ELSE v_me.answers_submitted_at[v_answered] END;
  v_too_fast := EXTRACT(EPOCH FROM (clock_timestamp() - v_prev)) < 4;  -- MIN_SECONDS_PER_QUESTION
  v_is_correct := (NOT v_too_fast) AND public.score_answer(v_question, p_choice);

  UPDATE public.duel_participants
  SET answers_submitted_at = answers_submitted_at || clock_timestamp(),
      score = score + CASE WHEN v_is_correct THEN 1 ELSE 0 END,
      finished_at = CASE WHEN v_next >= v_total THEN clock_timestamp() ELSE finished_at END
  WHERE duel_id = p_duel AND user_id = v_user;

  -- If both players are now finished, settle the duel immediately.
  IF v_next >= v_total THEN
    SELECT bool_and(finished_at IS NOT NULL) INTO v_both_done
      FROM public.duel_participants WHERE duel_id = p_duel;
    IF v_both_done THEN
      PERFORM public.finalize_duel(p_duel);
    END IF;
  END IF;

  -- R-6: never echo the key/explanation mid-duel. Only progress is returned;
  -- the correction comes from get_duel_state once the duel is finished.
  RETURN jsonb_build_object(
    'answered', v_next,
    'total', v_total,
    'finished', (v_next >= v_total),
    'tooFast', v_too_fast
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.submit_duel_answer(UUID, UUID, TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.submit_duel_answer(UUID, UUID, TEXT) TO authenticated;

-- ---------------------------------------------------------------------------
-- 5. get_duel_state — participant-only snapshot (R-6 review gate).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_duel_state(p_duel UUID)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_duel public.duels;
  v_total INT;
  v_me_answered INT;
  v_me_score INT;
  v_opp_answered INT;
  v_opp_finished BOOLEAN;
  v_review JSONB := NULL;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT * INTO v_duel FROM public.duels WHERE id = p_duel;
  IF NOT FOUND OR NOT public.is_duel_participant(p_duel, v_user) THEN
    RAISE EXCEPTION 'Duel not found.';  -- fail closed for non-participants
  END IF;

  v_total := array_length(v_duel.question_ids, 1);

  SELECT COALESCE(array_length(answers_submitted_at, 1), 0), score
    INTO v_me_answered, v_me_score
    FROM public.duel_participants WHERE duel_id = p_duel AND user_id = v_user;

  -- Opponent: ONLY the answered count + finished flag (R-3: never their answers
  -- or their live score).
  SELECT COALESCE(array_length(answers_submitted_at, 1), 0), (finished_at IS NOT NULL)
    INTO v_opp_answered, v_opp_finished
    FROM public.duel_participants WHERE duel_id = p_duel AND user_id <> v_user;

  -- Review (prompts + correct choice + explanation + both scores) ONLY once the
  -- duel is settled (R-6).
  IF v_duel.status IN ('finished', 'expired') THEN
    SELECT jsonb_agg(jsonb_build_object(
             'questionId', q.id,
             'prompt', q.prompt,
             'correctChoice', public.answer_key_display(q),
             'explanation', q.explanation
           ) ORDER BY ord)
      INTO v_review
      FROM unnest(v_duel.question_ids) WITH ORDINALITY AS ids(qid, ord)
      JOIN public.questions q ON q.id = ids.qid;
  END IF;

  RETURN jsonb_build_object(
    'duelId', v_duel.id,
    'status', v_duel.status,
    'total', v_total,
    'myAnswered', v_me_answered,
    'myScore', v_me_score,
    'opponentAnswered', v_opp_answered,
    'opponentFinished', v_opp_finished,
    'review', v_review
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.get_duel_state(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_duel_state(UUID) TO authenticated;

-- ---------------------------------------------------------------------------
-- 6. expire_duels — the cron sweep (R-9). Finalizes every active duel past its
--    deadline; finalize_duel decides forfait/no-result. Runs as owner.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.expire_duels()
RETURNS INT
LANGUAGE plpgsql
SET search_path = public
AS $$
DECLARE
  v_id UUID;
  v_count INT := 0;
BEGIN
  FOR v_id IN
    SELECT id FROM public.duels WHERE status = 'active' AND expires_at < now()
  LOOP
    PERFORM public.finalize_duel(v_id);
    v_count := v_count + 1;
  END LOOP;
  RETURN v_count;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.expire_duels() FROM PUBLIC, anon, authenticated;

-- Sweep every 5 minutes via pg_cron. Wrapped so the migration still succeeds if
-- pg_cron is not enabled yet (same defensive pattern as the leaderboard refresh
-- and the telemetry purge): the functions above already landed.
DO $$
BEGIN
  CREATE EXTENSION IF NOT EXISTS pg_cron;

  PERFORM cron.unschedule(jobid) FROM cron.job WHERE jobname = 'expire-duels';

  PERFORM cron.schedule(
    'expire-duels',
    '*/5 * * * *',
    $cron$SELECT public.expire_duels();$cron$
  );
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE
    'pg_cron unavailable (%). Duels work but expired ones will NOT auto-finalize. Enable pg_cron in Supabase -> Database -> Extensions, then re-run just the cron.schedule(...) block.',
    SQLERRM;
END $$;
