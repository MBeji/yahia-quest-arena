-- Moteur adaptatif — phase A0 lot A0.2 (FableEtudes/04-moteur-adaptatif #lot-A0.2).
--
-- Telemetry CAPTURE (décision D-2) + retention purge. The two submission RPCs
-- are re-created VERBATIM from their latest definitions with ONLY an additive
-- question_attempts INSERT in the same transaction — no client round-trip, not
-- falsifiable. NO reward barème / anti-farm gate / badge / consumable logic is
-- touched (stop-point du lot ; la matrice pgTAP de régression existante doit
-- rester verte à l'identique) :
--   * submit_exercise_attempt — verbatim from 20260705130000 ; ajouts :
--     chapter_id dans le SELECT exercice + l'INSERT télémétrie (une ligne par
--     question RÉPONDUE ; source 'quiz' pour un exercice mode quiz, sinon
--     'exercise' ; misconception_tag = distractor_tags->>choice, résolu
--     server-side — R-1 : la clé ne transite jamais).
--   * submit_dungeon_answer — verbatim from 20260705190000 ; ajout : une ligne
--     de télémétrie par réponse, source 'dungeon', session = run id.
--   * purge_question_attempts() — retention: deletes raw telemetry older than
--     12 months (Q-3: the aggregates in user_misconceptions remain), scheduled
--     daily via pg_cron (same defensive wrapper as the leaderboard refreshes).

-- ---------------------------------------------------------------------------
-- 1. submit_exercise_attempt — telemetry capture added (rewards untouched).
-- ---------------------------------------------------------------------------
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

  SELECT id, chapter_id, subject_id, xp_reward, reward_coins, mode
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
    COALESCE(SUM(CASE WHEN public.score_answer(q, a.choice) THEN 1 ELSE 0 END), 0)::INT
  INTO v_total_count, v_correct_count
  FROM public.questions q
  LEFT JOIN normalized_answers a ON a.question_id = q.id
  WHERE q.exercise_id = p_exercise_id;

  IF v_total_count <= 0 THEN
    RAISE EXCEPTION 'Exercise has no questions';
  END IF;

  -- Telemetry (étude 04 A0.2, D-2/R-1): one append-only question_attempts row
  -- per ANSWERED question, in this same transaction. The misconception tag is
  -- resolved server-side from the server-only distractor_tags map (a correct
  -- choice has no entry there → NULL). Unanswered questions produce no row —
  -- there is no chosen option to diagnose. Rewards/gates above are UNTOUCHED.
  INSERT INTO public.question_attempts
    (user_id, question_id, chapter_id, session_id, choice, is_correct, misconception_tag, source)
  SELECT
    v_user_id,
    q.id,
    v_exercise.chapter_id,
    p_session_id,
    a.choice,
    public.score_answer(q, a.choice),
    q.distractor_tags ->> a.choice,
    CASE WHEN v_exercise.mode = 'quiz' THEN 'quiz' ELSE 'exercise' END
  FROM (
    SELECT DISTINCT ON (x.question_id)
      x.question_id,
      x.choice
    FROM (
      SELECT
        NULLIF(elem->>'questionId', '')::UUID AS question_id,
        elem->>'choice' AS choice
      FROM jsonb_array_elements(p_answers) AS elem
    ) x
    WHERE x.question_id IS NOT NULL
    ORDER BY x.question_id
  ) a
  JOIN public.questions q ON q.id = a.question_id
  WHERE q.exercise_id = p_exercise_id
    AND a.choice IS NOT NULL;

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

  -- First-quest badge: this is the user's first attempt iff no OTHER attempt
  -- exists. EXISTS short-circuits at the first row (served by
  -- idx_attempts_user_exercise / idx_attempts_user) instead of COUNT-ing the
  -- user's entire lifetime history on every submit. (perf audit H3)
  IF NOT EXISTS (
    SELECT 1 FROM public.attempts
    WHERE user_id = v_user_id AND id <> v_attempt_id
  ) THEN
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

-- Signature is unchanged, so privileges persist across CREATE OR REPLACE;
-- re-assert them to keep the migration self-contained.
REVOKE EXECUTE ON FUNCTION public.submit_exercise_attempt(uuid, uuid, jsonb) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.submit_exercise_attempt(uuid, uuid, jsonb) TO authenticated;

-- ---------------------------------------------------------------------------
-- 2. submit_dungeon_answer — telemetry capture added (run logic untouched).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.submit_dungeon_answer(
  p_run_id UUID,
  p_question_id UUID,
  p_choice TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_run public.dungeon_runs;
  v_run_question public.dungeon_run_questions;
  v_question public.questions;
  v_is_correct BOOLEAN;
  v_next_floor INT;
  v_floors_cleared INT;
  v_total_correct INT;
  v_total_answered INT;
  v_status TEXT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_run_id IS NULL OR p_question_id IS NULL THEN
    RAISE EXCEPTION 'Run and question are required';
  END IF;

  IF p_choice IS NULL OR btrim(p_choice) = '' THEN
    RAISE EXCEPTION 'Choice is required';
  END IF;

  SELECT *
  INTO v_run
  FROM public.dungeon_runs
  WHERE id = p_run_id
    AND user_id = v_user
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Invalid dungeon run.';
  END IF;

  IF v_run.status <> 'active' THEN
    RAISE EXCEPTION 'Dungeon run is not active.';
  END IF;

  SELECT *
  INTO v_run_question
  FROM public.dungeon_run_questions
  WHERE run_id = p_run_id
    AND question_id = p_question_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Question is not assigned to this run.';
  END IF;

  IF v_run_question.answered_at IS NOT NULL THEN
    RAISE EXCEPTION 'This dungeon question is already answered.';
  END IF;

  IF v_run_question.assigned_floor <> v_run.current_floor THEN
    RAISE EXCEPTION 'Invalid floor progression.';
  END IF;

  SELECT *
  INTO v_question
  FROM public.questions
  WHERE id = p_question_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Question not found.';
  END IF;

  v_is_correct := public.score_answer(v_question, p_choice);

  UPDATE public.dungeon_run_questions
  SET answered_at = clock_timestamp(),
      selected_choice = p_choice,
      is_correct = v_is_correct
  WHERE id = v_run_question.id;

  -- Telemetry (étude 04 A0.2, D-2/R-1) — same transaction, source 'dungeon',
  -- session context = the run id. Tag resolved from the server-only map.
  INSERT INTO public.question_attempts
    (user_id, question_id, chapter_id, session_id, choice, is_correct, misconception_tag, source)
  SELECT
    v_user,
    v_question.id,
    e.chapter_id,
    p_run_id,
    p_choice,
    v_is_correct,
    v_question.distractor_tags ->> p_choice,
    'dungeon'
  FROM public.exercises e
  WHERE e.id = v_question.exercise_id;

  IF v_is_correct THEN
    v_next_floor := v_run.current_floor + 1;
    v_floors_cleared := v_run.floors_cleared + 1;
    v_total_correct := v_run.total_correct + 1;
    v_total_answered := v_run.total_answered + 1;
    v_status := 'active';

    UPDATE public.dungeon_runs
    SET current_floor = v_next_floor,
        floors_cleared = v_floors_cleared,
        total_correct = v_total_correct,
        total_answered = v_total_answered
    WHERE id = p_run_id;
  ELSE
    v_next_floor := v_run.current_floor;
    v_floors_cleared := v_run.floors_cleared;
    v_total_correct := v_run.total_correct;
    v_total_answered := v_run.total_answered + 1;
    v_status := 'failed';

    UPDATE public.dungeon_runs
    SET status = 'failed',
        ended_at = clock_timestamp(),
        total_answered = v_total_answered
    WHERE id = p_run_id;
  END IF;

  RETURN jsonb_build_object(
    'isCorrect', v_is_correct,
    'nextFloor', v_next_floor,
    'floorsCleared', v_floors_cleared,
    'totalCorrect', v_total_correct,
    'totalAnswered', v_total_answered,
    'runStatus', v_status,
    'questionId', v_question.id,
    'prompt', v_question.prompt,
    'correctChoice', public.answer_key_display(v_question),
    'explanation', v_question.explanation
  );
END;
$$;

-- Signature unchanged; re-assert privileges (self-contained migration).
REVOKE EXECUTE ON FUNCTION public.submit_dungeon_answer(uuid, uuid, text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.submit_dungeon_answer(uuid, uuid, text) TO authenticated;

-- ---------------------------------------------------------------------------
-- 3. Retention purge — raw telemetry > 12 months (aggregates are kept).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.purge_question_attempts()
RETURNS INT
LANGUAGE plpgsql
SET search_path = public
AS $$
DECLARE
  v_deleted INT;
BEGIN
  DELETE FROM public.question_attempts
  WHERE created_at < now() - INTERVAL '12 months';
  GET DIAGNOSTICS v_deleted = ROW_COUNT;
  RETURN v_deleted;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.purge_question_attempts() FROM PUBLIC, anon, authenticated;

-- Daily purge via pg_cron. Wrapped so the migration still succeeds if pg_cron
-- is not enabled yet (same pattern as the materialized-leaderboard refreshes):
-- the RPCs + purge function above already landed; only the schedule defers.
DO $$
BEGIN
  CREATE EXTENSION IF NOT EXISTS pg_cron;

  PERFORM cron.unschedule(jobid)
  FROM cron.job
  WHERE jobname = 'purge-question-attempts';

  PERFORM cron.schedule(
    'purge-question-attempts',
    '17 3 * * *',
    $cron$SELECT public.purge_question_attempts();$cron$
  );
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE
    'pg_cron unavailable (%). Telemetry works but old question_attempts rows will NOT auto-purge. Enable pg_cron in Supabase -> Database -> Extensions, then re-run just the cron.schedule(...) block.',
    SQLERRM;
END $$;
