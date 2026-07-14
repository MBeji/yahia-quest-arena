-- Étude 17 — Rappel actif · lot 2 (FableEtudes/17-rappel-actif#lot-2).
-- RPCs variant-aware : le mode « Rappel » existe désormais en base, aucune UI encore.
-- DB-only : ne toucher AUCUN fichier `src/`. Le défaut `'classic'` (lot 1) garantit que le
-- code déployé continue de fonctionner à l'identique — la régression classique est prouvée
-- par la matrice pgTAP existante (04/06/08/16/19/20), qui doit rester verte.
--
-- Pattern imposé (spec §3, précédent télémétrie A0 20260706130000) : RECRÉER VERBATIM la
-- dernière définition de chaque RPC et n'ajouter QUE la branche Rappel. Aucune signature
-- existante ne casse ; `score_answer` (étude 03) et le scorer Rappel `score_recall_answer`
-- (lot 1) ne sont pas modifiés (D-3).
--
--   * start_exercise_session — verbatim de 20260612090000, nouvelle signature
--     (p_variant text DEFAULT 'classic') : DROP de l'ancienne + CREATE, grants réappliqués.
--     Branche Rappel APRÈS les portes actuelles (accès parcours + quiz gate).
--   * submit_exercise_attempt — verbatim de 20260706130000 ; la variante est lue depuis la
--     session (jamais un argument client) ; scoring/anti-farm/XP/télémétrie branchés.
--   * get_attempt_review — verbatim de 20260705190000 ; en Rappel, questions éligibles
--     seulement et correct_option = TEXTE de la bonne option (le client n'a pas les options).
--   * get_recall_questions / get_recall_availability — nouvelles (STABLE DEFINER, GRANT
--     authenticated) : les questions jouables et l'état des chips du hub, sans jamais
--     exposer `options`/`correct_option` (R-1).
--   * get_best_scores_by_exercise — verbatim de 20260603110000 + WHERE variant='classic'
--     (affichage hub inchangé, R-6).

-- ===========================================================================
-- 1. start_exercise_session — nouvelle signature (variant), branche Rappel (R-3).
-- ===========================================================================
-- La signature change (ajout d'un paramètre) : on supprime explicitement l'ancienne
-- signature à 1 argument pour éviter une surcharge, puis on recrée. Le défaut 'classic'
-- garde l'appel TS existant (à 1 argument) valide.
DROP FUNCTION IF EXISTS public.start_exercise_session(uuid);

CREATE OR REPLACE FUNCTION public.start_exercise_session(
  p_exercise_id UUID,
  p_variant TEXT DEFAULT 'classic'
)
RETURNS TABLE (session_id UUID, started_at TIMESTAMPTZ)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user           UUID := auth.uid();
  v_mode           TEXT;
  v_chapter        UUID;
  v_grade          UUID;
  v_source         TEXT;
  v_allowed        BOOLEAN;
  v_reason         TEXT;
  v_quiz_id        UUID;
  v_passed         BOOLEAN;
  v_eligible_count INT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  -- Variante fermée (R-4 / spec §3). Validée tôt : sans effet pour le défaut 'classic'.
  IF p_variant IS NULL OR p_variant NOT IN ('classic', 'recall') THEN
    RAISE EXCEPTION 'INVALID_VARIANT';
  END IF;

  -- Exercise + its subject's grade. School subjects bind to a grade; non-school
  -- themes (culture-générale, muscle-cerveau/IQ, language tracks) leave grade_id
  -- NULL -> they have no theory to validate, so the quiz gate never applies.
  SELECT e.mode, e.chapter_id, s.grade_id, e.source
    INTO v_mode, v_chapter, v_grade, v_source
    FROM public.exercises e
    JOIN public.subjects s ON s.id = e.subject_id
   WHERE e.id = p_exercise_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Exercise not found';
  END IF;

  -- 1) PREMIUM gate. resolve_exercise_access returns exactly one row; fail closed:
  --    any not-allowed outcome blocks, and the reason picks the localized message.
  SELECT ra.allowed, ra.reason
    INTO v_allowed, v_reason
    FROM public.resolve_exercise_access(p_exercise_id) ra;

  IF v_allowed IS DISTINCT FROM true THEN
    IF v_reason = 'PARCOURS_COMING_SOON' THEN
      RAISE EXCEPTION 'PARCOURS_COMING_SOON';
    ELSE
      RAISE EXCEPTION 'PARCOURS_LOCKED';
    END IF;
  END IF;

  -- 2) COMPREHENSION-QUIZ gate — school subjects only, non-quiz exercises only, and
  --    only when a quiz actually exists for the chapter (graceful for legacy
  --    chapters without one).
  IF v_grade IS NOT NULL AND v_mode IS DISTINCT FROM 'quiz' AND v_chapter IS NOT NULL THEN
    SELECT e.id
      INTO v_quiz_id
      FROM public.exercises e
     WHERE e.chapter_id = v_chapter AND e.mode = 'quiz'
     LIMIT 1;

    IF v_quiz_id IS NOT NULL THEN
      -- A qualifying pass: >= 80% AND not rushed (>= 4s/question), so a fast random
      -- pass cannot unlock the chapter without comprehension.
      SELECT EXISTS (
        SELECT 1
          FROM public.attempts a
         WHERE a.user_id = v_user
           AND a.exercise_id = v_quiz_id
           AND a.score_pct >= 80
           AND a.duration_seconds >= a.total_count * 4
      ) INTO v_passed;

      IF NOT v_passed THEN
        RAISE EXCEPTION 'QUIZ_LOCKED';
      END IF;
    END IF;
  END IF;

  -- 3) RECALL gate (R-3) — APRÈS les portes ci-dessus. La variante Rappel n'existe que
  --    pour un exercice admin non-quiz avec >= 3 questions éligibles, et seulement une
  --    fois le classique validé à 100 % sans précipitation (anti-rush 4 s/question).
  IF p_variant = 'recall' THEN
    IF v_mode = 'quiz' OR v_source IS DISTINCT FROM 'admin' THEN
      RAISE EXCEPTION 'RECALL_NOT_ELIGIBLE';
    END IF;

    SELECT COUNT(*)
      INTO v_eligible_count
      FROM public.questions q
     WHERE q.exercise_id = p_exercise_id
       AND public.is_question_recall_eligible(q);

    IF v_eligible_count < 3 THEN
      RAISE EXCEPTION 'RECALL_NOT_ELIGIBLE';
    END IF;

    IF NOT EXISTS (
      SELECT 1
        FROM public.attempts a
       WHERE a.user_id = v_user
         AND a.exercise_id = p_exercise_id
         AND a.variant = 'classic'
         AND a.score_pct = 100
         AND a.duration_seconds >= a.total_count * 4
    ) THEN
      RAISE EXCEPTION 'RECALL_LOCKED';
    END IF;
  END IF;

  -- Gates passed -> create the session as the owner and return it. Columns in the
  -- RETURNING list are table-qualified so they bind to exercise_sessions columns,
  -- not to the same-named OUT parameters (was SQLSTATE 42702: ambiguous reference).
  RETURN QUERY
    INSERT INTO public.exercise_sessions AS es (user_id, exercise_id, variant)
    VALUES (v_user, p_exercise_id, p_variant)
    RETURNING es.id, es.started_at;
END;
$$;

REVOKE ALL ON FUNCTION public.start_exercise_session(uuid, text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.start_exercise_session(uuid, text) TO authenticated;

-- ===========================================================================
-- 2. submit_exercise_attempt — signature INCHANGÉE ; la variante est lue depuis
--    la session (jamais un argument client). Branches Rappel : scoring éligible +
--    score_recall_answer, anti-farm/best scopé par variant (R-6), XP ×1,5 (R-5),
--    télémétrie à misconception typée par texte (R-7), retour + variant/perQuestion (D-4).
-- ===========================================================================
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
  -- Recall variant (étude 17) — read from the session, never a client argument.
  v_variant TEXT := 'classic';
  v_per_question JSONB := NULL;
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

  -- The scoring/reward mode is an attribute of the SESSION (D-1) — an attacker
  -- cannot request a variant via the answers payload.
  v_variant := COALESCE(v_session.variant, 'classic');

  SELECT id, chapter_id, subject_id, xp_reward, reward_coins, mode
  INTO v_exercise
  FROM public.exercises
  WHERE id = p_exercise_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Exercise not found';
  END IF;

  -- Scoring. In 'recall' the play set is RESTRICTED to eligible questions and the
  -- typed free-text answer is scored by score_recall_answer (normalized, all-or-nothing);
  -- in 'classic' the whole set is scored by score_answer (unchanged, D-3).
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
    COALESCE(SUM(
      CASE
        WHEN (CASE WHEN v_variant = 'recall'
                   THEN public.score_recall_answer(q, a.choice)
                   ELSE public.score_answer(q, a.choice) END)
        THEN 1 ELSE 0 END
    ), 0)::INT
  INTO v_total_count, v_correct_count
  FROM public.questions q
  LEFT JOIN normalized_answers a ON a.question_id = q.id
  WHERE q.exercise_id = p_exercise_id
    AND (v_variant = 'classic' OR public.is_question_recall_eligible(q));

  IF v_total_count <= 0 THEN
    RAISE EXCEPTION 'Exercise has no questions';
  END IF;

  -- Telemetry (étude 04 A0.2, D-2/R-1): one append-only question_attempts row
  -- per ANSWERED question, in this same transaction. The misconception tag is
  -- resolved server-side from the server-only distractor_tags map (a correct
  -- choice has no entry there → NULL). In 'recall' the chosen option is unknown
  -- (free text), so the tag is resolved by matching the typed answer's normalized
  -- form to a distractor's — same map, never leaked (R-7). Unanswered questions
  -- produce no row. Rewards/gates below are UNTOUCHED.
  INSERT INTO public.question_attempts
    (user_id, question_id, chapter_id, session_id, choice, is_correct, misconception_tag, source)
  SELECT
    v_user_id,
    q.id,
    v_exercise.chapter_id,
    p_session_id,
    a.choice,
    CASE WHEN v_variant = 'recall'
         THEN public.score_recall_answer(q, a.choice)
         ELSE public.score_answer(q, a.choice) END,
    CASE WHEN v_variant = 'recall'
         THEN (
           SELECT q.distractor_tags ->> (opt ->> 'id')
           FROM jsonb_array_elements(q.options) AS opt
           WHERE opt ->> 'id' IS DISTINCT FROM q.correct_option
             AND public.normalize_recall_text(opt ->> 'text')
                 = public.normalize_recall_text(a.choice)
           LIMIT 1
         )
         ELSE q.distractor_tags ->> a.choice END,
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
    AND a.choice IS NOT NULL
    AND (v_variant = 'classic' OR public.is_question_recall_eligible(q));

  -- Recall review payload (D-4): the RPC that SCORED returns the per-question
  -- verdicts so the TS never re-implements normalization. Eligible questions only,
  -- in display order; an unanswered eligible question scores false.
  IF v_variant = 'recall' THEN
    SELECT COALESCE(jsonb_agg(
             jsonb_build_object(
               'questionId', q.id,
               'isCorrect', public.score_recall_answer(q, a.choice)
             ) ORDER BY q.display_order
           ), '[]'::jsonb)
      INTO v_per_question
      FROM public.questions q
      LEFT JOIN (
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
      ) a ON a.question_id = q.id
     WHERE q.exercise_id = p_exercise_id
       AND public.is_question_recall_eligible(q);
  END IF;

  v_score_pct := (v_correct_count::NUMERIC / v_total_count::NUMERIC) * 100;
  v_duration_seconds := GREATEST(
    1,
    ROUND(EXTRACT(EPOCH FROM (clock_timestamp() - v_session.started_at)))::INT
  );
  -- Anti-effortless-XP hardening (unchanged): XP/coins only when all three effort
  -- gates pass — not too fast (>= 4s/question), not random (>= 60%), and an
  -- improvement over the user's previous best ON THIS VARIANT (R-6: recall and
  -- classic keep separate bests, so a 100% classic never starves the first recall
  -- session of its XP, and vice-versa).
  SELECT COALESCE(MAX(score_pct), -1)
  INTO v_prev_best
  FROM public.attempts
  WHERE user_id = v_user_id
    AND exercise_id = p_exercise_id
    AND variant = v_variant;

  v_too_fast := v_duration_seconds < (v_total_count * 4);
  v_eligible := (NOT v_too_fast) AND (v_score_pct >= 60) AND (v_score_pct > v_prev_best);

  IF v_eligible THEN
    -- Recall is harder, so it pays RECALL_XP_MULTIPLIER (1.5) more (R-5); coins are
    -- unchanged. Multiply before rounding (xp_reward × score/100 × mult).
    v_xp_earned := ROUND(
      COALESCE(v_exercise.xp_reward, 0) * (v_score_pct / 100)
        * (CASE WHEN v_variant = 'recall' THEN 1.5 ELSE 1 END)
    );
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
    xp_earned,
    variant
  )
  VALUES (
    v_user_id,
    p_exercise_id,
    v_exercise.subject_id,
    v_correct_count,
    v_total_count,
    v_score_pct,
    v_duration_seconds,
    v_xp_earned,
    v_variant
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
    'retryShieldUsed', v_retry_shield_used,
    'variant', v_variant,
    -- Per-question verdicts for the recall review (D-4); NULL in classic.
    'perQuestion', v_per_question
  );
END;
$$;

-- Signature is unchanged, so privileges persist across CREATE OR REPLACE;
-- re-assert them to keep the migration self-contained.
REVOKE EXECUTE ON FUNCTION public.submit_exercise_attempt(uuid, uuid, jsonb) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.submit_exercise_attempt(uuid, uuid, jsonb) TO authenticated;

-- ===========================================================================
-- 3. get_attempt_review — verbatim de 20260705190000 ; branche Rappel : questions
--    éligibles seulement, correct_option = TEXTE de la bonne option (le client n'a
--    pas les `options` pour mapper l'id), scoring via score_recall_answer.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.get_attempt_review(p_session_id uuid, p_answers jsonb DEFAULT NULL)
RETURNS TABLE (
  question_id uuid,
  prompt text,
  correct_option text,
  explanation text,
  is_correct boolean
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user uuid := auth.uid();
  v_owner uuid;
  v_exercise uuid;
  v_completed timestamptz;
  v_mode text;
  v_variant text;
BEGIN
  -- A malformed answers payload never breaks the review: treat it as absent.
  IF p_answers IS NOT NULL AND jsonb_typeof(p_answers) <> 'array' THEN
    p_answers := NULL;
  END IF;

  SELECT s.user_id, s.exercise_id, s.completed_at, s.variant
    INTO v_owner, v_exercise, v_completed, v_variant
    FROM public.exercise_sessions s
    WHERE s.id = p_session_id;

  -- Only the owner, only after the attempt has been submitted, may see the
  -- correction. Comprehension quizzes never reveal it (anti-memorisation of the gate).
  IF v_owner IS NULL OR v_owner IS DISTINCT FROM v_user THEN
    RETURN;
  END IF;
  IF v_completed IS NULL THEN
    RETURN;
  END IF;

  SELECT e.mode INTO v_mode FROM public.exercises e WHERE e.id = v_exercise;
  IF v_mode = 'quiz' THEN
    RETURN;
  END IF;

  v_variant := COALESCE(v_variant, 'classic');

  RETURN QUERY
    SELECT
      q.id,
      q.prompt,
      -- Classic: canonical answer in the same wire format as `choice`
      -- (answer_key_display). Recall: the TEXT of the correct option, since the
      -- client never received the options to map an id back to its label.
      CASE
        WHEN v_variant = 'recall' THEN (
          SELECT opt ->> 'text'
          FROM jsonb_array_elements(q.options) AS opt
          WHERE opt ->> 'id' = q.correct_option
          LIMIT 1
        )
        ELSE public.answer_key_display(q)
      END,
      q.explanation,
      -- Scored through the same seam as the submit RPC, so the review can never
      -- contradict the score. NULL when no answers were given (legacy call shape).
      CASE
        WHEN p_answers IS NULL THEN NULL
        WHEN v_variant = 'recall' THEN public.score_recall_answer(q, a.choice)
        ELSE public.score_answer(q, a.choice)
      END
    FROM public.questions q
    LEFT JOIN (
      SELECT DISTINCT ON (ans.question_id)
        ans.question_id,
        ans.choice
      FROM (
        SELECT
          nullif(elem ->> 'questionId', '')::uuid AS question_id,
          elem ->> 'choice' AS choice
        FROM jsonb_array_elements(COALESCE(p_answers, '[]'::jsonb)) AS elem
      ) ans
      WHERE ans.question_id IS NOT NULL
      ORDER BY ans.question_id
    ) a ON a.question_id = q.id
    WHERE q.exercise_id = v_exercise
      AND (v_variant = 'classic' OR public.is_question_recall_eligible(q))
    ORDER BY q.display_order;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.get_attempt_review(uuid, jsonb) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_attempt_review(uuid, jsonb) TO authenticated;

-- ===========================================================================
-- 4. get_recall_questions — nouvelle. Les questions jouables en Rappel : le prompt
--    seul, JAMAIS les `options` ni `correct_option` (R-1). Mêmes contrôles d'accès
--    que getExercise (exercice admin, non-quiz).
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.get_recall_questions(p_exercise_id uuid)
RETURNS TABLE (id uuid, prompt text, display_order int)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user uuid := auth.uid();
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  RETURN QUERY
    SELECT q.id, q.prompt, q.display_order
    FROM public.questions q
    JOIN public.exercises e ON e.id = q.exercise_id
    WHERE q.exercise_id = p_exercise_id
      AND e.source = 'admin'
      AND e.mode IS DISTINCT FROM 'quiz'
      AND public.is_question_recall_eligible(q)
    ORDER BY q.display_order;
END;
$$;

REVOKE ALL ON FUNCTION public.get_recall_questions(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_recall_questions(uuid) TO authenticated;

-- ===========================================================================
-- 5. get_recall_availability — nouvelle. Un seul aller-retour pour les chips du hub :
--    par exercice non-quiz du sujet, le nombre de questions éligibles, l'état de
--    déblocage (R-3) et le meilleur score Rappel.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.get_recall_availability(p_subject_id text)
RETURNS TABLE (
  exercise_id uuid,
  eligible_count int,
  unlocked boolean,
  best_recall_pct numeric
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user uuid := auth.uid();
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_subject_id IS NULL THEN
    RAISE EXCEPTION 'Subject id is required';
  END IF;

  RETURN QUERY
    SELECT
      e.id,
      (SELECT COUNT(*)::int
         FROM public.questions q
        WHERE q.exercise_id = e.id
          AND public.is_question_recall_eligible(q)),
      EXISTS (
        SELECT 1
          FROM public.attempts a
         WHERE a.user_id = v_user
           AND a.exercise_id = e.id
           AND a.variant = 'classic'
           AND a.score_pct = 100
           AND a.duration_seconds >= a.total_count * 4
      ),
      (SELECT MAX(a.score_pct)
         FROM public.attempts a
        WHERE a.user_id = v_user
          AND a.exercise_id = e.id
          AND a.variant = 'recall')
    FROM public.exercises e
    WHERE e.subject_id = p_subject_id
      AND e.source = 'admin'
      AND e.mode IS DISTINCT FROM 'quiz';
END;
$$;

REVOKE ALL ON FUNCTION public.get_recall_availability(text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_recall_availability(text) TO authenticated;

-- ===========================================================================
-- 6. get_best_scores_by_exercise — verbatim de 20260603110000 + WHERE variant='classic'
--    (le hub n'affiche que le meilleur score classique — R-6 ; le meilleur Rappel
--    passe par get_recall_availability).
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.get_best_scores_by_exercise(p_subject TEXT)
RETURNS TABLE(exercise_id UUID, best_score INT)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_subject IS NULL THEN
    RAISE EXCEPTION 'Subject id is required';
  END IF;

  RETURN QUERY
  SELECT a.exercise_id, MAX(a.score_pct)::INT AS best_score
  FROM public.attempts a
  WHERE a.user_id = v_user
    AND a.subject_id = p_subject
    AND a.variant = 'classic'
  GROUP BY a.exercise_id;
END;
$$;

REVOKE ALL ON FUNCTION public.get_best_scores_by_exercise(text) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.get_best_scores_by_exercise(text) FROM anon;
GRANT EXECUTE ON FUNCTION public.get_best_scores_by_exercise(text) TO authenticated;
