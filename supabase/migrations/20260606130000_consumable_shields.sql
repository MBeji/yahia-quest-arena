-- =========================================================
-- Consumable shields: retry shield + streak shield (step 2)
-- ---------------------------------------------------------
-- Builds on step 1 (20260606120000) which wired the XP/coin potions.
-- This migration makes the two SHIELD consumables actually do something:
--
--   * Retry shield  (item_type 'shield', effect {"retries":1}, e.g. shield_retry):
--       "refaire sans pénalité, le meilleur des deux scores compte".
--       When the student FAILS an exercise (<60%) with a retry shield ARMED, we
--       SUPPRESS the failure penalty (skip spaced-repetition scheduling), CONSUME
--       the shield, and surface retryShieldUsed=true so the UI can nudge a replay.
--       "Best of two" needs no special code — the existing best-score eligibility
--       gate (score > previous best) already keeps the higher score.
--       Anti-waste: the shield is consumed ONLY on an actual failure where it
--       suppresses a penalty. A pass leaves it armed for a future failure.
--
--   * Streak shield (item_type 'shield', effect {"streakShield":1}, e.g.
--       bouclier_flamme): passive. The first time the student is active after
--       missing EXACTLY one day, the shield is consumed to preserve the streak
--       instead of resetting it. Larger gaps (>= 2 missed days) cannot be saved
--       by a single shield → reset to 1 and the shield is NOT consumed (anti-waste).
--
-- Two-slot arming model (activate_inventory_item):
--   * "next-quest" slot (one at a time): items whose effect has xpMultiplier /
--     coinMultiplier / retries (potions + retry shield). Arming one clears only the
--     other next-quest rows.
--   * "passive" slot (independent): items whose effect has streakShield. Arming it
--     clears only other passive rows — so a passive streak shield is never disarmed
--     by arming a next-quest item, and vice-versa.
--
-- Idempotent: CREATE OR REPLACE only (the is_active column already exists from
-- step 1). All other logic in both RPCs is byte-for-byte identical to the current
-- definitions (potion step, badges, adaptation, daily/weekly, response shape;
-- level curve, hero class, tier).
-- =========================================================

-- ----- Arm a consumable (two-slot model) -----
-- next-quest slot: xpMultiplier / coinMultiplier / retries (potions + retry shield).
-- passive slot:    streakShield (streak shield).
-- Arming an item clears only the OTHER rows in the SAME slot, leaving the other
-- slot untouched. Rejects items that are not armable.
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
  v_is_next_quest boolean;
  v_is_passive boolean;
  v_slot text;
BEGIN
  IF v_user IS NULL THEN RAISE EXCEPTION 'Not authenticated.'; END IF;

  SELECT inv.id, inv.quantity, si.name, si.item_type, si.effect_payload
    INTO v_inv_id, v_quantity, v_item_name, v_item_type, v_effect
    FROM public.inventory_items inv
    JOIN public.shop_items si ON si.id = inv.shop_item_id
    WHERE inv.student_user_id = v_user AND si.code = p_item_code;
  IF v_inv_id IS NULL THEN RAISE EXCEPTION 'Item not found in inventory.'; END IF;
  IF v_item_type NOT IN ('potion', 'shield') THEN
    RAISE EXCEPTION 'This item cannot be activated.';
  END IF;
  IF COALESCE(v_quantity, 0) < 1 THEN RAISE EXCEPTION 'You do not own this item.'; END IF;

  -- Derive the arming slot from the effect payload.
  --   next-quest: multiplier potions + retry shield (applied on the next quest).
  --   passive:    streak shield (protects a missed day automatically in award_xp).
  v_is_next_quest := (v_effect ? 'xpMultiplier' OR v_effect ? 'coinMultiplier' OR v_effect ? 'retries');
  v_is_passive := (v_effect ? 'streakShield');

  IF NOT (v_is_next_quest OR v_is_passive) THEN
    RAISE EXCEPTION 'This item cannot be activated yet.';
  END IF;

  v_slot := CASE WHEN v_is_passive THEN 'passive' ELSE 'next-quest' END;

  -- Arm this row and clear only the OTHER armed rows in the SAME slot. Rows in the
  -- other slot keep their is_active state, so the two slots are independent.
  UPDATE public.inventory_items inv
    SET is_active = (inv.id = v_inv_id)
    FROM public.shop_items si
    WHERE inv.shop_item_id = si.id
      AND inv.student_user_id = v_user
      AND (
        inv.id = v_inv_id
        OR (
          inv.is_active = true
          AND (
            CASE
              WHEN si.effect_payload ? 'streakShield' THEN 'passive'
              ELSE 'next-quest'
            END
          ) = v_slot
        )
      );

  RETURN jsonb_build_object(
    'item_code', p_item_code,
    'item_name', v_item_name,
    'slot', v_slot,
    'is_active', true
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.activate_inventory_item(text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.activate_inventory_item(text) TO authenticated;

-- ----- Re-define submit_exercise_attempt with the retry-shield step -----
-- Copy of the step-1 body (20260606120000) — the potion step is untouched — plus:
-- in the v_score_pct < 60 (failure) branch, before scheduling spaced repetition,
-- look up an armed retry shield. If found, SUPPRESS the schedule, CONSUME the
-- shield, and set retryShieldUsed = true in the response. Everything else is
-- identical.
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
  -- Retry-shield (armed consumable) state.
  v_retry_shield RECORD;
  v_retry_shield_used BOOLEAN := false;
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
    -- Retry-shield step (anti-waste: only on an actual failure that would otherwise
    -- incur a penalty). If the user has an armed retry shield, SUPPRESS the
    -- spaced-repetition penalty and CONSUME the shield. "Best of two" falls out of
    -- the existing best-score eligibility gate when they replay.
    SELECT inv.id, si.code, si.name
      INTO v_retry_shield
      FROM public.inventory_items inv
      JOIN public.shop_items si ON si.id = inv.shop_item_id
      WHERE inv.student_user_id = v_user_id
        AND inv.is_active = true
        AND inv.quantity >= 1
        AND si.item_type = 'shield'
        AND (si.effect_payload ? 'retries')
      ORDER BY inv.acquired_at ASC
      LIMIT 1
      -- Lock ONLY the inventory row (never the shared shop_items catalog) — same
      -- concurrency reasoning as the potion step above.
      FOR UPDATE OF inv;

    IF FOUND THEN
      -- Consume the shield: -1 quantity, delete at 0, clear armed flag.
      UPDATE public.inventory_items
        SET quantity = quantity - 1,
            is_active = false
        WHERE id = v_retry_shield.id;
      DELETE FROM public.inventory_items
        WHERE id = v_retry_shield.id AND quantity <= 0;

      v_retry_shield_used := true;
      -- Penalty suppressed: skip the spaced-repetition scheduling entirely.
    ELSIF NOT EXISTS (
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
    'potionApplied', v_potion_applied,
    'retryShieldUsed', v_retry_shield_used
  );
END;
$$;

-- ----- Re-define award_xp with the streak-shield branch -----
-- Copy of the current body (20260530123000) plus: in the gap (reset) branch, if
-- the gap is EXACTLY one missed day (last_active_date = today - 2 days) AND the
-- user has an armed streak shield, preserve the streak (today still counts) and
-- consume the shield. Larger gaps reset to 1 and do NOT consume (anti-waste).
-- The shield lookup is defensive so a missing shield never breaks award_xp.
CREATE OR REPLACE FUNCTION public.award_xp(p_user UUID, p_xp INT)
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  rec public.profiles;
  today DATE := CURRENT_DATE;
  new_streak INT;
  new_level INT;
  new_class TEXT;
  new_tier INT;
  caller_role TEXT := current_setting('request.jwt.claim.role', true);
  v_streak_shield_id uuid;
BEGIN
  IF p_xp IS NULL OR p_xp < 0 THEN
    RAISE EXCEPTION 'Invalid xp value';
  END IF;

  -- Allow service role jobs, otherwise enforce self-only updates.
  IF caller_role IS DISTINCT FROM 'service_role' AND auth.uid() IS DISTINCT FROM p_user THEN
    RAISE EXCEPTION 'Not allowed to award XP for another user';
  END IF;

  SELECT * INTO rec FROM public.profiles WHERE id = p_user FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Profile not found';
  END IF;

  -- Streak logic
  IF rec.last_active_date IS NULL THEN
    new_streak := 1;
  ELSIF rec.last_active_date = today THEN
    new_streak := rec.current_streak;
  ELSIF rec.last_active_date = today - INTERVAL '1 day' THEN
    new_streak := rec.current_streak + 1;
  ELSIF rec.last_active_date = today - INTERVAL '2 days' THEN
    -- Exactly one missed day: a single armed streak shield can save the streak.
    -- Defensive lookup (LIMIT 1, locked) so a missing shield never breaks award_xp.
    SELECT inv.id
      INTO v_streak_shield_id
      FROM public.inventory_items inv
      JOIN public.shop_items si ON si.id = inv.shop_item_id
      WHERE inv.student_user_id = p_user
        AND inv.is_active = true
        AND inv.quantity >= 1
        AND si.item_type = 'shield'
        AND (si.effect_payload ? 'streakShield')
      ORDER BY inv.acquired_at ASC
      LIMIT 1
      FOR UPDATE OF inv;

    IF v_streak_shield_id IS NOT NULL THEN
      -- Preserve the streak (today still counts) and consume the shield.
      new_streak := rec.current_streak + 1;
      UPDATE public.inventory_items
        SET quantity = quantity - 1,
            is_active = false
        WHERE id = v_streak_shield_id;
      DELETE FROM public.inventory_items
        WHERE id = v_streak_shield_id AND quantity <= 0;
    ELSE
      new_streak := 1;
    END IF;
  ELSE
    -- Gap of >= 2 missed days: one shield can't save it → reset, do NOT consume.
    new_streak := 1;
  END IF;

  -- Level curve: each level = 200 xp
  new_level := GREATEST(1, ((rec.xp + p_xp) / 200) + 1);

  -- Hero class progression
  new_class := CASE
    WHEN new_level >= 50 THEN 'S-Rank Legend'
    WHEN new_level >= 31 THEN 'Elite du Concours'
    WHEN new_level >= 21 THEN 'Maitre des Langues'
    WHEN new_level >= 11 THEN 'Guerrier des Equations'
    WHEN new_level >= 6 THEN 'Aspirant Academicien'
    ELSE 'Candidat Civil'
  END;

  new_tier := LEAST(6, GREATEST(1, (new_level / 8) + 1));

  UPDATE public.profiles
  SET
    xp = xp + p_xp,
    level = new_level,
    hero_class = new_class,
    avatar_tier = new_tier,
    current_streak = new_streak,
    longest_streak = GREATEST(longest_streak, new_streak),
    last_active_date = today
  WHERE id = p_user
  RETURNING * INTO rec;

  RETURN rec;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.award_xp(uuid, int) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.award_xp(uuid, int) TO authenticated;
