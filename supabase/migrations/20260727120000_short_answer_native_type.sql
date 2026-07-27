-- Étude 20 lot 7 — le type natif `short_answer` (question libre sans propositions).
--
-- Volet B de l'étude : une question dont la forme naturelle est la PRODUCTION,
-- pas le choix. Elle rejoint le cadre fermé de l'étude 03 sans aucune colonne
-- nouvelle — `answer_key = {"text": …, "mistakes"?: [{"text","tag"}]}` — et son
-- verdict réutilise l'UNIQUE implémentation du « saisie libre » posée au lot 1
-- (`is_accepted_free_answer`) : { canonique } ∪ `accepted_answers`, normalisées.
--
-- Ce que cette migration NE fait PAS, par contrat (stop-points du lot) :
--   * elle ne convertit aucun QCM existant (D-10) — aucune ligne n'est réécrite ;
--   * elle ne touche pas `is_question_recall_eligible` : une `short_answer`
--     n'entre JAMAIS en mode Rappel (elle EST déjà du rappel actif — R-11) ;
--   * elle ne modifie pas la sémantique des cinq types existants ;
--   * elle n'ouvre aucun grant : `answer_key` et `accepted_answers` restent
--     server-only, les fonctions restent REVOKEd.
--
-- Les deux RPCs de soumission sont RECRÉÉES VERBATIM (pattern B1→B3) : leur seul
-- changement est l'appel à `resolve_misconception_tag`, extrait pour que la règle
-- d'appariement des erreurs cesse d'être dupliquée entre elles.

-- ---------------------------------------------------------------------------
-- 1. Le type entre dans le CHECK fermé (étude 03, étendu par phase).
-- ---------------------------------------------------------------------------
ALTER TABLE public.questions
  DROP CONSTRAINT IF EXISTS questions_question_type_check;
ALTER TABLE public.questions
  ADD CONSTRAINT questions_question_type_check
  CHECK (question_type IN ('mcq', 'numeric', 'ordering', 'matching', 'multi', 'short_answer'));

-- La contrainte de forme de clé existante couvre déjà le type : une
-- `short_answer` n'est pas 'mcq', donc elle tombe dans la branche
-- « answer_key IS NOT NULL ». Rien à modifier.

-- ---------------------------------------------------------------------------
-- 2. L'appariement des erreurs, en UNE fonction (R-9).
--
-- Trois variantes, une seule règle :
--   * classique + mcq      → l'option choisie porte son tag (`distractor_tags`) ;
--   * Rappel               → le texte tapé est apparié au texte d'un distracteur ;
--   * short_answer         → le texte tapé est apparié à une ERREUR ATTENDUE
--                            (`answer_key -> 'mistakes'`), le pendant du
--                            distracteur pour une question sans propositions.
-- Une réponse JUSTE ne matche jamais rien (R-4 interdit qu'un membre accepté
-- égale un élément déclaré faux) : le tag reste NULL, ce qui est le comportement
-- voulu. Server-only comme les colonnes qu'elle lit.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.resolve_misconception_tag(
  q public.questions,
  p_choice text,
  p_variant text DEFAULT 'classic'
)
RETURNS text
LANGUAGE sql
STABLE
SET search_path = public
AS $$
  SELECT CASE
    WHEN p_choice IS NULL THEN NULL
    -- Question libre native : apparier le texte tapé aux erreurs attendues.
    WHEN q.question_type = 'short_answer' THEN (
      SELECT m ->> 'tag'
      FROM jsonb_array_elements(
             CASE WHEN jsonb_typeof(q.answer_key -> 'mistakes') = 'array'
                  THEN q.answer_key -> 'mistakes'
                  ELSE '[]'::jsonb END
           ) AS m
      WHERE public.normalize_recall_text(m ->> 'text')
            = public.normalize_recall_text(p_choice)
        AND NULLIF(btrim(coalesce(m ->> 'tag', '')), '') IS NOT NULL
      LIMIT 1
    )
    -- Mode Rappel : l'option n'est pas connue, on apparie le texte au distracteur.
    WHEN p_variant = 'recall' THEN (
      SELECT q.distractor_tags ->> (opt ->> 'id')
      FROM jsonb_array_elements(q.options) AS opt
      WHERE opt ->> 'id' IS DISTINCT FROM q.correct_option
        AND public.normalize_recall_text(opt ->> 'text')
            = public.normalize_recall_text(p_choice)
      LIMIT 1
    )
    -- Classique : le `choice` EST l'id de l'option.
    ELSE q.distractor_tags ->> p_choice
  END;
$$;

REVOKE EXECUTE ON FUNCTION public.resolve_misconception_tag(public.questions, text, text)
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 3. La seam de scoring et la révélation, recréées verbatim + une branche.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.score_answer(q public.questions, p_choice text)
RETURNS boolean
LANGUAGE plpgsql
STABLE
SET search_path = public
AS $$
DECLARE
  v_answer numeric;
  v_value numeric;
  v_tolerance numeric;
BEGIN
  IF p_choice IS NULL THEN
    RETURN false;
  END IF;

  -- 'mcq' fast path: strictly the historical semantics (zero regression, US-4).
  IF q.question_type = 'mcq' OR q.question_type IS NULL THEN
    RETURN q.correct_option = p_choice;
  END IF;

  IF q.question_type = 'numeric' THEN
    IF q.answer_key IS NULL OR NOT (q.answer_key ? 'value') THEN
      RETURN false;
    END IF;
    BEGIN
      -- Accept '-', '.' and ',' (normalized) — US-1. Unparseable input is a
      -- wrong answer, never an exception (a bad payload must not kill a session).
      v_answer := replace(btrim(p_choice), ',', '.')::numeric;
      v_value := (q.answer_key ->> 'value')::numeric;
      v_tolerance := COALESCE((q.answer_key ->> 'tolerance')::numeric, 0);
    EXCEPTION WHEN OTHERS THEN
      RETURN false;
    END;
    RETURN abs(v_answer - v_value) <= v_tolerance;
  END IF;

  -- 'ordering': the submitted id CSV must reproduce the key's EXACT sequence.
  -- All-or-nothing (no partial credit, spec R-2); whitespace-insensitive.
  IF q.question_type = 'ordering' THEN
    IF q.answer_key IS NULL
       OR jsonb_typeof(q.answer_key -> 'order') IS DISTINCT FROM 'array' THEN
      RETURN false;
    END IF;
    BEGIN
      RETURN (
        SELECT COALESCE(array_agg(t.part ORDER BY t.ord), ARRAY[]::text[])
        FROM unnest(string_to_array(replace(p_choice, ' ', ''), ',')) WITH ORDINALITY AS t(part, ord)
        WHERE t.part <> ''
      ) = (
        SELECT COALESCE(array_agg(k.val ORDER BY k.ord), ARRAY[]::text[])
        FROM jsonb_array_elements_text(q.answer_key -> 'order') WITH ORDINALITY AS k(val, ord)
      );
    EXCEPTION WHEN OTHERS THEN
      RETURN false;
    END;
  END IF;

  -- 'matching': the submitted "left:right" pair CSV must equal the key's pair
  -- SET (order-insensitive, duplicates collapse, no partial credit).
  IF q.question_type = 'matching' THEN
    IF q.answer_key IS NULL
       OR jsonb_typeof(q.answer_key -> 'pairs') IS DISTINCT FROM 'array' THEN
      RETURN false;
    END IF;
    BEGIN
      RETURN (
        SELECT COALESCE(array_agg(DISTINCT t.part ORDER BY t.part), ARRAY[]::text[])
        FROM unnest(string_to_array(replace(p_choice, ' ', ''), ',')) AS t(part)
        WHERE t.part <> ''
      ) = (
        SELECT COALESCE(
          array_agg(DISTINCT ((p.pair ->> 0) || ':' || (p.pair ->> 1))
                    ORDER BY ((p.pair ->> 0) || ':' || (p.pair ->> 1))),
          ARRAY[]::text[]
        )
        FROM jsonb_array_elements(q.answer_key -> 'pairs') AS p(pair)
      );
    EXCEPTION WHEN OTHERS THEN
      RETURN false;
    END;
  END IF;

  -- 'multi': the checked option ids as a CSV — SET equality with the key
  -- (order-insensitive, duplicates collapse, no partial credit).
  IF q.question_type = 'multi' THEN
    IF q.answer_key IS NULL
       OR jsonb_typeof(q.answer_key -> 'correct') IS DISTINCT FROM 'array' THEN
      RETURN false;
    END IF;
    BEGIN
      RETURN (
        SELECT COALESCE(array_agg(DISTINCT t.part ORDER BY t.part), ARRAY[]::text[])
        FROM unnest(string_to_array(replace(p_choice, ' ', ''), ',')) AS t(part)
        WHERE t.part <> ''
      ) = (
        SELECT COALESCE(array_agg(DISTINCT k.val ORDER BY k.val), ARRAY[]::text[])
        FROM jsonb_array_elements_text(q.answer_key -> 'correct') AS k(val)
      );
    EXCEPTION WHEN OTHERS THEN
      RETURN false;
    END;
  END IF;

  -- 'short_answer' (étude 20 R-11): free typed text, scored by MEMBERSHIP in
  -- { canonical } ∪ accepted_answers — the single implementation shared with
  -- the Recall mode (`is_accepted_free_answer`, lot 1). A malformed key scores
  -- false and never raises (posture étude 03).
  IF q.question_type = 'short_answer' THEN
    IF q.answer_key IS NULL OR NOT (q.answer_key ? 'text') THEN
      RETURN false;
    END IF;
    RETURN COALESCE(public.is_accepted_free_answer(q, p_choice), false);
  END IF;

  -- Unknown / future types: score false, never crash (R-3).
  RETURN false;
END;
$$;

-- Server-side only (unchanged posture): no client answer-key oracle.
REVOKE EXECUTE ON FUNCTION public.score_answer(public.questions, text) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- Canonical answer display — 'multi' serializes as the sorted id CSV.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.answer_key_display(q public.questions)
RETURNS text
LANGUAGE sql
STABLE
SET search_path = public
AS $$
  SELECT CASE q.question_type
    WHEN 'numeric' THEN q.answer_key ->> 'value'
    WHEN 'ordering' THEN
      CASE WHEN jsonb_typeof(q.answer_key -> 'order') = 'array' THEN (
        SELECT string_agg(k.val, ',' ORDER BY k.ord)
        FROM jsonb_array_elements_text(q.answer_key -> 'order') WITH ORDINALITY AS k(val, ord)
      ) END
    WHEN 'matching' THEN
      CASE WHEN jsonb_typeof(q.answer_key -> 'pairs') = 'array' THEN (
        SELECT string_agg((p.pair ->> 0) || ':' || (p.pair ->> 1), ',' ORDER BY p.ord)
        FROM jsonb_array_elements(q.answer_key -> 'pairs') WITH ORDINALITY AS p(pair, ord)
      ) END
    WHEN 'multi' THEN
      CASE WHEN jsonb_typeof(q.answer_key -> 'correct') = 'array' THEN (
        SELECT string_agg(k.val, ',' ORDER BY k.val)
        FROM jsonb_array_elements_text(q.answer_key -> 'correct') AS k(val)
      ) END
    -- 'short_answer' (étude 20 R-11): the canonical text IS the display value.
    WHEN 'short_answer' THEN q.answer_key ->> 'text'
    ELSE q.correct_option
  END;
$$;

REVOKE EXECUTE ON FUNCTION public.answer_key_display(public.questions) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 4. Les deux RPCs de soumission, recréées VERBATIM — seul l'appariement du tag
--    passe par la fonction extraite ci-dessus.
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
  -- resolved server-side by `resolve_misconception_tag` (étude 20 lot 7) : la
  -- règle des trois variantes — option choisie (classique), texte tapé apparié
  -- à un distracteur (Rappel), texte tapé apparié à une erreur attendue
  -- (short_answer) — vit désormais dans UNE fonction, plus dupliquée entre les
  -- deux RPCs. Unanswered questions produce no row. Rewards/gates UNTOUCHED.
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
    public.resolve_misconception_tag(q, a.choice, v_variant),
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

  ELSIF NOT v_too_fast THEN
    -- R-19 (etude 22) — LA BOUCLE SM-2 SE REFERME.
    --
    -- Jusqu'ici rien ne cloturait jamais une revision : les trois echeances etaient inserees
    -- a l'echec, puis restaient 'pending' pour toujours. Un eleve qui refaisait l'exercice et
    -- le reussissait continuait de voir la revision « due » sur son tableau de bord, sans
    -- aucun moyen de la faire disparaitre. La boucle etait ecrite, jamais fermee.
    --
    -- Condition : reussite (>= 60 %) ET non precipitee (>= 4 s/question). On n'exige
    -- deliberement PAS v_eligible : celui-ci ajoute « strictement meilleur que le precedent
    -- record », ce qui est un critere anti-farm pour l'XP, pas une definition de la reussite.
    -- Un eleve deja monte a 90 % qui repasse a 70 % a bel et bien reussi sa revision.
    --
    -- Aucun filtre sur la variante, par symetrie exacte avec l'insertion ci-dessus, qui n'en
    -- pose pas non plus : un Rappel reussi ferme donc aussi le cycle qu'un Rappel rate a ouvert.
    -- Un echec ulterieur rouvre normalement un cycle — la garde « aucune ligne pending » de
    -- l'insertion le permet, puisque les lignes cloturees ne sont plus 'pending'.
    UPDATE public.spaced_repetition_schedule
       SET status = 'completed',
           completed_at = clock_timestamp(),
           retry_score_pct = ROUND(v_score_pct)::INT,
           updated_at = clock_timestamp()
     WHERE user_id = v_user_id
       AND exercise_id = p_exercise_id
       AND status = 'pending';
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
    public.resolve_misconception_tag(v_question, p_choice, 'classic'),
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
