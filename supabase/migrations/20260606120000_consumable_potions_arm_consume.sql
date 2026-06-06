-- =========================================================
-- Consumable potions: arm -> next quest -> consume
-- ---------------------------------------------------------
-- Wires up the XP/coin multiplier potions (item_type 'potion' with an
-- xpMultiplier / coinMultiplier effect_payload). Model:
--   1. The student ARMS one consumable from inventory (is_active = true).
--      Only ONE consumable can be armed at a time (no stacking this iteration).
--   2. The armed potion applies to the NEXT completed quest that actually earns
--      a reward, then is consumed (quantity -1, row deleted at 0).
--   3. Anti-cheat invariant: the multiplier ONLY applies when the attempt is
--      already XP-eligible under the existing hardened rules (not too fast,
--      score >= 60%, beats previous best). If the attempt earns 0 XP, the
--      potion is NOT consumed and no multiplier is applied — no farming, no
--      wasted potions.
-- Idempotent: ADD COLUMN IF NOT EXISTS, CREATE OR REPLACE.
-- (Hint potions like potion_rappel are out of scope; only multiplier potions.)
-- =========================================================

-- ----- Armed-consumable state -----
-- Skins keep using is_equipped; consumables use is_active for "armed".
ALTER TABLE public.inventory_items
  ADD COLUMN IF NOT EXISTS is_active boolean NOT NULL DEFAULT false;

-- ----- Arm a consumable potion (one armed at a time) -----
-- Validates the caller owns >= 1 of that consumable potion, sets that row
-- is_active = true and clears is_active on the user's other rows. Rejects
-- non-potion / non-owned items.
CREATE OR REPLACE FUNCTION public.activate_inventory_item(p_item_code text)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user uuid := auth.uid();
  v_inv_id uuid;
  v_item_name text;
  v_item_type text;
  v_quantity int;
  v_effect jsonb;
BEGIN
  IF v_user IS NULL THEN RAISE EXCEPTION 'Not authenticated.'; END IF;

  SELECT inv.id, inv.quantity, si.name, si.item_type, si.effect_payload
    INTO v_inv_id, v_quantity, v_item_name, v_item_type, v_effect
    FROM public.inventory_items inv
    JOIN public.shop_items si ON si.id = inv.shop_item_id
    WHERE inv.student_user_id = v_user AND si.code = p_item_code;
  IF v_inv_id IS NULL THEN RAISE EXCEPTION 'Item not found in inventory.'; END IF;
  IF v_item_type <> 'potion' THEN RAISE EXCEPTION 'Only consumable potions can be activated.'; END IF;
  IF COALESCE(v_quantity, 0) < 1 THEN RAISE EXCEPTION 'You do not own this potion.'; END IF;
  -- Only multiplier potions are armable in this iteration (hint potions are out of scope).
  IF NOT (v_effect ? 'xpMultiplier' OR v_effect ? 'coinMultiplier') THEN
    RAISE EXCEPTION 'This potion cannot be activated yet.';
  END IF;

  -- One armed at a time: clear all of the user's rows, then arm this one.
  UPDATE public.inventory_items
    SET is_active = (id = v_inv_id)
    WHERE student_user_id = v_user;

  RETURN jsonb_build_object(
    'item_code', p_item_code,
    'item_name', v_item_name,
    'is_active', true
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.activate_inventory_item(text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.activate_inventory_item(text) TO authenticated;

-- ----- Re-define submit_exercise_attempt with the potion step -----
-- Copy of the hardened body (20260604220000) plus: when v_eligible, look up the
-- user's armed potion(s), multiply v_xp_earned / v_coins_earned BEFORE the award
-- calls, consume the inventory row (quantity -1, delete at 0, clear is_active),
-- and surface the applied multipliers in the response. Everything else (badges,
-- adaptation, streak, daily/weekly, response shape) is identical.
CREATE OR REPLACE FUNCTION public.submit_exercise_attempt(
  p_session_id UUID,
  p_exercise_id UUID,
  p_answers JSONB
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_session public.exercise_sessions;
  v_exercise RECORD;
  v_attempt_id UUID;
  v_profile public.profiles;
  v_unlocked_badges JSONB := '[]'::jsonb;
  v_badge JSONB;
  v_today DATE := (clock_timestamp() AT TIME ZONE 'UTC')::date;
  v_week_start DATE := date_trunc('week', clock_timestamp() AT TIME ZONE 'UTC')::date;
  v_correct_count INT := 0;
  v_total_count INT := 0;
  v_duration_seconds INT := 0;
  v_xp_earned INT := 0;
  v_coins_earned INT := 0;
  v_score_pct NUMERIC := 0;
  v_speed_factor NUMERIC := 1;
  v_prev_best NUMERIC := -1;
  v_too_fast BOOLEAN := false;
  v_eligible BOOLEAN := false;
  v_attempt_count INT := 0;
  v_recent_avg INT := 0;
  v_overall_avg INT := 0;
  v_new_difficulty INT := 1;
  v_adaptation RECORD;
  -- Potion (armed consumable) state.
  v_potion RECORD;
  v_xp_multiplier INT := 1;
  v_coin_multiplier INT := 1;
  v_potion_applied JSONB := NULL;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_session_id IS NULL OR p_exercise_id IS NULL THEN
    RAISE EXCEPTION 'Session and exercise are required';
  END IF;

  IF jsonb_typeof(p_answers) IS DISTINCT FROM 'array' THEN
    RAISE EXCEPTION 'Answers must be an array';
  END IF;

  IF jsonb_array_length(p_answers) < 1 OR jsonb_array_length(p_answers) > 100 THEN
    RAISE EXCEPTION 'Answers payload is out of bounds';
  END IF;

  SELECT *
  INTO v_session
  FROM public.exercise_sessions
  WHERE id = p_session_id
    AND user_id = v_user_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Invalid quest session.';
  END IF;

  IF v_session.exercise_id <> p_exercise_id THEN
    RAISE EXCEPTION 'Invalid quest session.';
  END IF;

  IF v_session.completed_at IS NOT NULL THEN
    RAISE EXCEPTION 'This quest session is already completed.';
  END IF;

  SELECT id, subject_id, xp_reward, reward_coins, mode
  INTO v_exercise
  FROM public.exercises
  WHERE id = p_exercise_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Exercise not found';
  END IF;

  WITH normalized_answers AS (
    SELECT DISTINCT ON (a.question_id)
      a.question_id,
      a.choice
    FROM (
      SELECT
        NULLIF(elem->>'questionId', '')::UUID AS question_id,
        elem->>'choice' AS choice
      FROM jsonb_array_elements(p_answers) AS elem
    ) a
    WHERE a.question_id IS NOT NULL
    ORDER BY a.question_id
  )
  SELECT
    COUNT(*)::INT,
    COALESCE(SUM(CASE WHEN q.correct_option = a.choice THEN 1 ELSE 0 END), 0)::INT
  INTO v_total_count, v_correct_count
  FROM public.questions q
  LEFT JOIN normalized_answers a ON a.question_id = q.id
  WHERE q.exercise_id = p_exercise_id;

  IF v_total_count <= 0 THEN
    RAISE EXCEPTION 'Exercise has no questions';
  END IF;

  v_score_pct := (v_correct_count::NUMERIC / v_total_count::NUMERIC) * 100;
  v_duration_seconds := GREATEST(
    1,
    ROUND(EXTRACT(EPOCH FROM (clock_timestamp() - v_session.started_at)))::INT
  );
  -- Anti-effortless-XP hardening. The old speed BONUS (which rewarded rushing)
  -- is removed. XP/coins are granted ONLY when all three effort gates pass:
  --   * not too fast : >= 4s per question (random reading is impossible below that),
  --   * not random   : score >= 60% (at/below ~25% chance for 4-option QCM earns 0),
  --   * an improvement: beats the user's previous best on this exercise (anti-farm).
  -- XP is then purely score-proportional (no speed multiplier).
  SELECT COALESCE(MAX(score_pct), -1)
  INTO v_prev_best
  FROM public.attempts
  WHERE user_id = v_user_id AND exercise_id = p_exercise_id;

  v_too_fast := v_duration_seconds < (v_total_count * 4);
  v_eligible := (NOT v_too_fast) AND (v_score_pct >= 60) AND (v_score_pct > v_prev_best);

  IF v_eligible THEN
    v_xp_earned := ROUND(COALESCE(v_exercise.xp_reward, 0) * (v_score_pct / 100));
    v_coins_earned := COALESCE(v_exercise.reward_coins, 0);

    -- Potion step (anti-cheat: only on an already-eligible, reward-earning attempt).
    -- Look up the user's armed consumable potion. With one-armed-at-a-time there
    -- is at most one, but we resolve xp/coin multipliers independently in case a
    -- future iteration allows a combined potion.
    SELECT inv.id, si.code, si.name, si.effect_payload
      INTO v_potion
      FROM public.inventory_items inv
      JOIN public.shop_items si ON si.id = inv.shop_item_id
      WHERE inv.student_user_id = v_user_id
        AND inv.is_active = true
        AND inv.quantity >= 1
        AND si.item_type = 'potion'
        AND (si.effect_payload ? 'xpMultiplier' OR si.effect_payload ? 'coinMultiplier')
      ORDER BY inv.acquired_at ASC
      LIMIT 1
      -- Lock ONLY the inventory row (never the shared shop_items catalog) so two
      -- concurrent submissions can't both read+apply the same armed potion: the
      -- second submit blocks here, then re-checks and finds the potion gone.
      FOR UPDATE OF inv;

    IF FOUND THEN
      v_xp_multiplier := GREATEST(1, COALESCE((v_potion.effect_payload ->> 'xpMultiplier')::INT, 1));
      v_coin_multiplier := GREATEST(1, COALESCE((v_potion.effect_payload ->> 'coinMultiplier')::INT, 1));

      v_xp_earned := v_xp_earned * v_xp_multiplier;
      v_coins_earned := v_coins_earned * v_coin_multiplier;

      -- Consume the potion: -1 quantity, delete at 0, clear armed flag.
      UPDATE public.inventory_items
        SET quantity = quantity - 1,
            is_active = false
        WHERE id = v_potion.id;
      DELETE FROM public.inventory_items
        WHERE id = v_potion.id AND quantity <= 0;

      v_potion_applied := jsonb_build_object(
        'itemCode', v_potion.code,
        'itemName', v_potion.name,
        'xpMultiplier', v_xp_multiplier,
        'coinMultiplier', v_coin_multiplier
      );
    END IF;
  ELSE
    v_xp_earned := 0;
    v_coins_earned := 0;
  END IF;

  INSERT INTO public.attempts (
    user_id,
    exercise_id,
    subject_id,
    correct_count,
    total_count,
    score_pct,
    duration_seconds,
    xp_earned
  )
  VALUES (
    v_user_id,
    p_exercise_id,
    v_exercise.subject_id,
    v_correct_count,
    v_total_count,
    v_score_pct,
    v_duration_seconds,
    v_xp_earned
  )
  RETURNING id INTO v_attempt_id;

  UPDATE public.exercise_sessions
  SET completed_at = clock_timestamp()
  WHERE id = p_session_id;

  PERFORM public.award_xp(v_user_id, v_xp_earned);

  IF v_coins_earned > 0 THEN
    PERFORM public.award_coins(v_user_id, v_coins_earned);
  END IF;

  SELECT *
  INTO v_profile
  FROM public.profiles
  WHERE id = v_user_id;

  SELECT COUNT(*)::INT
  INTO v_attempt_count
  FROM public.attempts
  WHERE user_id = v_user_id;

  IF v_attempt_count = 1 THEN
    v_badge := public.award_badge_if_new(v_user_id, 'first_quest', 'First quest completed');
    IF v_badge IS NOT NULL THEN
      v_unlocked_badges := v_unlocked_badges || jsonb_build_array(v_badge);
    END IF;
  END IF;

  IF v_score_pct = 100 THEN
    v_badge := public.award_badge_if_new(v_user_id, 'perfect_score', 'Perfect score: 100%');
    IF v_badge IS NOT NULL THEN
      v_unlocked_badges := v_unlocked_badges || jsonb_build_array(v_badge);
    END IF;
  END IF;

  IF v_duration_seconds < 60 AND v_score_pct >= 60 THEN
    v_badge := public.award_badge_if_new(v_user_id, 'speed_demon', 'Quest completed in under 60s');
    IF v_badge IS NOT NULL THEN
      v_unlocked_badges := v_unlocked_badges || jsonb_build_array(v_badge);
    END IF;
  END IF;

  IF COALESCE(v_profile.current_streak, 0) >= 7 THEN
    v_badge := public.award_badge_if_new(v_user_id, 'streak_7', '7 consecutive days of studying');
    IF v_badge IS NOT NULL THEN
      v_unlocked_badges := v_unlocked_badges || jsonb_build_array(v_badge);
    END IF;
  END IF;

  IF v_score_pct < 60 THEN
    IF NOT EXISTS (
      SELECT 1
      FROM public.spaced_repetition_schedule s
      WHERE s.user_id = v_user_id
        AND s.exercise_id = p_exercise_id
        AND s.status = 'pending'
    ) THEN
      INSERT INTO public.spaced_repetition_schedule (
        user_id,
        exercise_id,
        subject_id,
        failed_attempt_id,
        retry_level,
        scheduled_for,
        status
      )
      VALUES
        (v_user_id, p_exercise_id, v_exercise.subject_id, v_attempt_id, 1, clock_timestamp() + INTERVAL '1 day', 'pending'),
        (v_user_id, p_exercise_id, v_exercise.subject_id, v_attempt_id, 2, clock_timestamp() + INTERVAL '3 days', 'pending'),
        (v_user_id, p_exercise_id, v_exercise.subject_id, v_attempt_id, 3, clock_timestamp() + INTERVAL '7 days', 'pending');
    END IF;
  END IF;

  SELECT *
  INTO v_adaptation
  FROM public.difficulty_adaptation
  WHERE user_id = v_user_id
    AND subject_id = v_exercise.subject_id;

  IF NOT FOUND THEN
    INSERT INTO public.difficulty_adaptation (
      user_id,
      subject_id,
      avg_score,
      recent_avg_score,
      total_attempts,
      current_difficulty_level
    )
    VALUES (
      v_user_id,
      v_exercise.subject_id,
      ROUND(v_score_pct),
      ROUND(v_score_pct),
      1,
      1
    );
  ELSE
    SELECT COALESCE(ROUND(AVG(score_pct))::INT, ROUND(v_score_pct)::INT)
    INTO v_recent_avg
    FROM (
      SELECT score_pct
      FROM public.attempts
      WHERE user_id = v_user_id
        AND subject_id = v_exercise.subject_id
      ORDER BY completed_at DESC
      LIMIT 10
    ) recent_attempts;

    v_overall_avg := ROUND(
      ((v_adaptation.avg_score * v_adaptation.total_attempts) + v_score_pct)
      / (v_adaptation.total_attempts + 1)
    );

    v_new_difficulty := v_adaptation.current_difficulty_level;
    IF v_recent_avg > 75 AND v_new_difficulty < 4 THEN
      v_new_difficulty := v_new_difficulty + 1;
    ELSIF v_recent_avg < 40 AND v_new_difficulty > 1 THEN
      v_new_difficulty := v_new_difficulty - 1;
    END IF;

    UPDATE public.difficulty_adaptation
    SET avg_score = v_overall_avg,
        recent_avg_score = v_recent_avg,
        total_attempts = total_attempts + 1,
        current_difficulty_level = v_new_difficulty,
        updated_at = clock_timestamp()
    WHERE id = v_adaptation.id;
  END IF;

  UPDATE public.daily_objectives
  SET current_value = current_value + 1,
      status = CASE WHEN current_value + 1 >= target_value THEN 'completed' ELSE 'active' END,
      completed_at = CASE
        WHEN current_value + 1 >= target_value AND completed_at IS NULL THEN clock_timestamp()
        ELSE completed_at
      END
  WHERE user_id = v_user_id
    AND objective_type = '3_exercises'
    AND objective_date = v_today;

  IF v_score_pct >= 60 AND v_exercise.mode = 'boss' THEN
    UPDATE public.weekly_quests
    SET current_value = current_value + 1,
        status = CASE WHEN current_value + 1 >= target_value THEN 'completed' ELSE 'active' END,
        completed_at = CASE
          WHEN current_value + 1 >= target_value AND completed_at IS NULL THEN clock_timestamp()
          ELSE completed_at
        END
    WHERE user_id = v_user_id
      AND quest_type = 'beat_2_bosses'
      AND week_start_date = v_week_start;
  END IF;

  SELECT *
  INTO v_profile
  FROM public.profiles
  WHERE id = v_user_id;

  RETURN jsonb_build_object(
    'correct', v_correct_count,
    'total', v_total_count,
    'scorePct', v_score_pct,
    'xpEarned', v_xp_earned,
    'coinsEarned', v_coins_earned,
    'durationSeconds', v_duration_seconds,
    'tooFast', v_too_fast,
    'improved', (v_score_pct > v_prev_best),
    'profile', to_jsonb(v_profile),
    'unlockedBadges', v_unlocked_badges,
    'potionApplied', v_potion_applied
  );
END;
$$;
