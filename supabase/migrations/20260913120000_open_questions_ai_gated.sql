-- Étude 33 lot 1 — LA PORTE DES QUESTIONS OUVERTES.
--
-- L'ARBITRAGE (propriétaire, 2026-09-13)
-- ---------------------------------------------------------------------------
-- « Les exercices ouverts ne doivent être proposés que si l'utilisateur a le
-- mode IA activé, et la réponse est vérifiée via IA. »
--
-- Une question OUVERTE (`short_answer`, étude 20 volet B) n'offre aucune
-- proposition : l'élève TAPE sa réponse. Le verdict était jusqu'ici un test
-- d'appartenance déterministe — { canonique } ∪ `accepted_answers`, normalisées
-- (é20 R-7 : « zéro IA au runtime »). Ce test est juste quand il accepte, et
-- MUET quand il refuse : une formulation correcte que personne n'avait prévue
-- est comptée fausse, et l'enfant n'a aucun recours. C'est le prix qu'é20
-- assumait, avec la boucle « refus contesté » (lot 6, jamais livrée) pour
-- amortisseur.
--
-- Cet arbitrage retourne le contrat : plutôt que de servir une question libre à
-- tout le monde avec un correcteur qui peut se tromper contre l'élève, on ne la
-- sert QU'À qui dispose d'un correcteur capable de juger une formulation
-- imprévue. Le déterministe reste le plancher (lot 2) ; l'IA ne peut que
-- RENVERSER un refus, jamais une acceptation.
--
-- CE QUE CE LOT FAIT, ET SEULEMENT CELA
-- ---------------------------------------------------------------------------
--   * `can_play_open_questions(élève)` — la porte, une fois, en un endroit ;
--   * `is_question_in_play(question, porte)` — son application, lisible au point
--     d'usage ;
--   * les huit fonctions qui SERVENT ou QUI COMPTENT des questions, recréées
--     VERBATIM avec la seule ligne de garde ajoutée (patron B1→B3).
--
-- ⚠️ POURQUOI LE DÉNOMINATEUR AUSSI, ET PAS SEULEMENT LE SERVICE. Retirer une
-- question de l'écran sans la retirer du compte est PIRE que ne rien faire :
-- `submit_exercise_attempt` compte `FROM questions WHERE exercise_id = …`, donc
-- une `short_answer` jamais servie serait restée dans le total, sans réponse,
-- donc fausse. Une mission de 9 questions se serait jouée sur 8 et notée sur 9.
-- Service, télémétrie, correction et score comptent le MÊME ensemble, ou la
-- porte est un bug de notation.
--
-- LES TROIS SURFACES QUI EXCLUENT SANS CONDITION, ET POURQUOI
-- ---------------------------------------------------------------------------
-- Donjon, duel et bac blanc ne prennent PAS la porte par élève : ils écartent
-- `short_answer` de leur tirage, point.
--
--   * le DUEL fige un jeu de questions PARTAGÉ par les deux adversaires (é05
--     R-2). Une porte par élève y produirait soit un jeu inéquitable, soit une
--     question qu'un seul des deux peut voir ;
--   * le DONJON et le BAC BLANC sont CHRONOMÉTRÉS. Un aller-retour vers un
--     modèle au milieu d'un compte à rebours n'est pas une lenteur : c'est du
--     temps d'épreuve pris à l'élève, et il ne serait pris qu'à ceux qui
--     répondent d'une façon imprévue.
--
-- Ces trois-là gardent donc la propriété qu'ils avaient AVANT le corpus
-- `short_answer` : des questions à propositions, corrigées instantanément. Le
-- pilote d'é20 lot 8 (119 questions, math 9ᵉ, une par mission) vit dans le
-- lecteur de quête — c'est là, et là seulement, que la porte s'ouvre.

-- ---------------------------------------------------------------------------
-- 1. Le vocabulaire fermé s'ouvre à la surface `open_answer`.
--
--    Miroir de `AI_FEATURES` (`src/shared/constants/ai.ts`). Sans cette ligne,
--    `log_ai_usage` refuserait à l'écriture l'appel que le lot 2 émet — et
--    c'est le comportement voulu : la comptabilité est la référence.
-- ---------------------------------------------------------------------------
ALTER TABLE public.ai_usage_events
  DROP CONSTRAINT IF EXISTS ai_usage_events_feature_check;
ALTER TABLE public.ai_usage_events
  ADD CONSTRAINT ai_usage_events_feature_check CHECK (feature IN (
    'verify',          -- vérification de clé (US-2)
    'explain',         -- explication personnalisée (é11 lot 1)
    'reformulate',     -- reformulation (é11 lot 1)
    'chat',            -- chat cadré (é11 lot 3)
    'check',           -- boucle de compréhension (é11 lot 4)
    'forge',           -- génération d'un quiz (é29 lot 4)
    'forge_solve',     -- double résolution d'un candidat (é29 lot 4)
    'open_answer',     -- arbitrage d'une réponse libre refusée (é33)
    'exercise_gen',    -- exercices ciblés par le tuteur (é11 lot 5)
    'digest_student',  -- bilan hebdomadaire élève (é11 lot 6)
    'digest_parent'    -- bilan hebdomadaire parent (é11 lot 6)
  ));

-- ---------------------------------------------------------------------------
-- 2. LA PORTE — une fonction, un endroit, deux lecteurs (le SQL et le TS).
--
-- Elle réutilise `resolve_ai_access` plutôt que de recopier ses six étapes :
-- kill-switch de données, ligne d'activation, lien famille toujours vivant,
-- suspension admin, crédential actif. Une seconde implémentation de ces cinq
-- règles divergerait — ce dépôt l'a vu trois fois ailleurs.
--
-- ⚠️ L'ÉNERGIE NE FERME PAS LA PORTE. `resolve_ai_access` refuse avec
-- `AI_ENERGY_SPENT` quand le quota de gestes IA du jour est épuisé ; on
-- l'accepte ici comme une porte OUVERTE, à dessein. L'énergie est une mécanique
-- de jeu quotidienne (é11 R-12) : la traiter comme une extinction ferait
-- DISPARAÎTRE des questions au milieu d'une après-midi de révisions, et
-- changerait la note d'une même mission selon l'heure. Le mode est allumé ou il
-- ne l'est pas. Sans énergie, l'arbitrage du lot 2 ne part simplement pas, et le
-- verdict déterministe — qui reste le plancher — tranche seul.
--
-- ⚠️ ELLE NE CONNAÎT QUE LE CHEMIN FAMILLE, et c'est délibéré. `resolve_ai_access`
-- rend `allowed = false, payer = 'platform'` pour un élève sans ligne famille ;
-- c'est Node qui décide ensuite si NOTRE clé prend le relais. Cette porte-ci ne
-- suit donc PAS le repli plateforme : poser `AI_PLATFORM_API_KEY` ouvrirait sinon
-- un type de question à tout le parc par une variable d'environnement. Le miroir
-- côté TS est `PLATFORM_NEVER_OPENS` (`src/features/ai/ai-access.server.ts`) —
-- les deux disent la même chose, et le test de parité le vérifie.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.can_play_open_questions(p_student UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_allowed BOOLEAN;
  v_reason  TEXT;
BEGIN
  -- Anonyme : aucun mode IA possible, donc aucune question ouverte. C'est ce
  -- qui ferme le catalogue public (`/exercice`) sans une ligne de plus.
  IF p_student IS NULL THEN
    RETURN false;
  END IF;

  SELECT a.allowed, a.reason
    INTO v_allowed, v_reason
    FROM public.resolve_ai_access(p_student, 'open_answer') a;

  RETURN COALESCE(v_allowed, false) OR v_reason = 'AI_ENERGY_SPENT';
END;
$$;

COMMENT ON FUNCTION public.can_play_open_questions(UUID) IS
  'Étude 33 : le mode IA de CET élève sert-il les questions ouvertes (short_answer) ? '
  'Chemin famille uniquement ; l''énergie épuisée ne ferme pas la porte.';

-- Aucun secret : un élève a le droit de savoir si son propre mode est allumé,
-- et l''UI le lit pour filtrer ce qu''elle affiche. Anonyme reste dehors — la
-- fonction lui répondrait `false` de toute façon, autant ne pas l''exposer.
REVOKE EXECUTE ON FUNCTION public.can_play_open_questions(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.can_play_open_questions(UUID) TO authenticated;

-- ---------------------------------------------------------------------------
-- 3. SON APPLICATION — « cette question est-elle en jeu ? »
--
-- Elle prend la porte DÉJÀ RÉSOLUE plutôt que l'identifiant de l'élève : dans
-- `submit_exercise_attempt` elle est évaluée une fois par question, et
-- `resolve_ai_access` est une descente de six tables. Résoudre la porte une fois
-- par transaction, puis la passer, garde le coût constant.
--
-- IMMUTABLE : elle ne lit rien, elle combine deux valeurs qu'on lui donne.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.is_question_in_play(
  q public.questions,
  p_open_ok BOOLEAN
)
RETURNS BOOLEAN
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT q.question_type IS DISTINCT FROM 'short_answer' OR COALESCE(p_open_ok, false);
$$;

COMMENT ON FUNCTION public.is_question_in_play(public.questions, BOOLEAN) IS
  'Étude 33 : une question ouverte n''est en jeu que derrière can_play_open_questions. '
  'Tous les autres types passent toujours.';


-- ---------------------------------------------------------------------------
-- 4. LE LECTEUR DE QUÊTE — service, score, télémétrie et correction.
--
-- `submit_exercise_attempt` recréée VERBATIM (patron B1→B3) : la SEULE
-- différence est `v_open_ok`, résolu une fois après l'authentification, puis
-- appliqué aux deux ensembles qui comptent — le dénominateur du score, et les
-- lignes de `question_attempts`. Rien d'autre n'a bougé.
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
  -- La tentative DÉJÀ enregistrée pour cette session, relue en cas de rejeu.
  v_replay public.attempts;
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
  -- Prime de rapidité du mode BOSS uniquement (>= 1, jamais un malus).
  v_boss_speed_factor NUMERIC := 1;
  v_boss_par_seconds INT := 0;
  v_prev_best NUMERIC := -1;
  v_too_fast BOOLEAN := false;
  v_eligible BOOLEAN := false;
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
  -- Étude 33 : les questions OUVERTES ne sont en jeu que si le mode IA les sert.
  v_open_ok BOOLEAN := false;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  -- La porte des questions ouvertes, résolue UNE fois pour toute la
  -- transaction : le dénominateur, la télémétrie et la correction doivent
  -- compter le MÊME ensemble de questions, sinon un élève perd des points sur
  -- une question qui ne lui a jamais été servie.
  v_open_ok := public.can_play_open_questions(v_user_id);

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

  -- ===========================================================================
  -- REJEU D'UNE SESSION DÉJÀ RENDUE — lecture pure, aucune écriture.
  --
  -- CE QUI SE PASSAIT AVANT. Cette branche levait, et c'était la bonne garde
  -- anti-triche : sans elle, rejouer une soumission re-créditait XP, pièces et
  -- badges. Mais elle punissait aussi le cas HONNÊTE, et c'est celui-là qui se
  -- voyait en production : la soumission ABOUTIT, sa réponse se perd en route
  -- (réseau coupé au retour, onglet fermé, jeton refusé sur le trajet retour),
  -- et le rejeu — celui de 'outbox.ts', ou l'élève qui reclique — se voyait
  -- répondre « déjà terminée ». Son travail était enregistré ; il ne le savait
  -- pas, et n'avait plus aucun moyen de voir son score.
  --
  -- CE QUI CHANGE. On rend la tentative DÉJÀ écrite, au lieu de lever. La
  -- propriété anti-triche est intacte, et par construction plutôt que par
  -- promesse : cette branche sort AVANT le moindre INSERT/UPDATE, ne touche ni
  -- award_xp, ni award_coins, ni award_badge_if_new. Rejouer dix fois produit
  -- toujours exactement une ligne dans 'attempts'.
  --
  -- LES CHAMPS DE RÉCOMPENSE SONT NEUTRALISÉS, PAS RELUS. Pièces, badges,
  -- potion, bouclier et prime de rapidité ne sont pas stockés sur la tentative,
  -- et surtout ils ont déjà été crédités : le profil rendu ci-dessous en porte
  -- l'effet. Les ré-annoncer ferait rejouer les animations d'un gain qui n'a pas
  -- lieu deux fois. Le drapeau 'replayed' le dit au client, qui s'en sert pour
  -- ne pas refêter un score déjà fêté.
  -- ===========================================================================
  IF v_session.completed_at IS NOT NULL THEN
    SELECT *
      INTO v_replay
      FROM public.attempts
     WHERE session_id = p_session_id
       AND user_id = v_user_id
     ORDER BY completed_at DESC
     LIMIT 1;

    -- Session close SANS tentative rattachée : elle est antérieure à la colonne
    -- 'attempts.session_id' (20260816170000) et à son backfill. On ne sait pas
    -- quoi rendre, donc l'ancien refus reste le seul énoncé vrai.
    IF NOT FOUND THEN
      RAISE EXCEPTION 'This quest session is already completed.';
    END IF;

    SELECT *
      INTO v_profile
      FROM public.profiles
     WHERE id = v_user_id;

    RETURN jsonb_build_object(
      'correct', v_replay.correct_count,
      'total', v_replay.total_count,
      'scorePct', v_replay.score_pct,
      'xpEarned', v_replay.xp_earned,
      'durationSeconds', v_replay.duration_seconds,
      'variant', COALESCE(v_replay.variant, 'classic'),
      'profile', to_jsonb(v_profile),
      'coinsEarned', 0,
      'unlockedBadges', '[]'::jsonb,
      'potionApplied', NULL,
      'retryShieldUsed', false,
      'speedBonus', 1,
      'tooFast', false,
      'improved', false,
      'perQuestion', NULL,
      'replayed', true
    );
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
    AND (v_variant = 'classic' OR public.is_question_recall_eligible(q))
    AND public.is_question_in_play(q, v_open_ok);

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
    AND (v_variant = 'classic' OR public.is_question_recall_eligible(q))
    AND public.is_question_in_play(q, v_open_ok);

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
    -- Prime de rapidité, mode BOSS SEULEMENT. Le chronomètre du combat est
    -- ouvert (il n'interrompt plus personne, cf. PR #742) : il note. Ici il
    -- note aussi les XP, mais uniquement là où la vitesse EST le sujet.
    --
    -- Ce n'est PAS le facteur de vitesse global purgé le 2026-06-04
    -- (20260604220000_harden_scoring_anti_rush.sql) : celui-là s'appliquait à
    -- TOUS les modes et descendait jusqu'à 0.5, donc punissait la lenteur et
    -- récompensait le bâclage. Celui-ci est borné à [1, 1.5] — jamais un
    -- malus — et n'est atteint qu'APRÈS les trois portes d'effort (pas trop
    -- vite : >= 4 s/question, >= 60 %, meilleur que le précédent record), qui
    -- restent la vraie digue anti-bâclage.
    --
    -- Le temps de référence budgète la lecture des corrections en plus de la
    -- réflexion (BOSS_XP_PAR_SECONDS_PER_QUESTION côté client) : la durée
    -- mesurée ici court de bout en bout de la session, écrans de correction
    -- compris. Prime pleine sous le temps de référence, décroissance linéaire,
    -- nulle à partir du double.
    IF v_exercise.mode = 'boss' THEN
      v_boss_par_seconds := GREATEST(1, v_total_count * 35);
      v_boss_speed_factor := LEAST(1.5, GREATEST(1.0,
        1 + 0.5 * (((2 * v_boss_par_seconds) - v_duration_seconds)::NUMERIC
                     / v_boss_par_seconds::NUMERIC)
      ));
    END IF;

    -- Recall is harder, so it pays RECALL_XP_MULTIPLIER (1.5) more (R-5); coins are
    -- unchanged. Multiply before rounding (xp_reward × score/100 × mult).
    v_xp_earned := ROUND(
      COALESCE(v_exercise.xp_reward, 0) * (v_score_pct / 100)
        * (CASE WHEN v_variant = 'recall' THEN 1.5 ELSE 1 END)
        * v_boss_speed_factor
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

  -- LA SEULE MODIFICATION DE CETTE FONCTION : la tentative retient la session
  -- qu'on vient de valider (verrou pris plus haut, appartenance et exercice
  -- vérifiés). Sans elle, relier une tentative à ses réponses question par
  -- question exigeait de deviner la session par proximité temporelle.
  INSERT INTO public.attempts (
    user_id,
    exercise_id,
    subject_id,
    correct_count,
    total_count,
    score_pct,
    duration_seconds,
    xp_earned,
    variant,
    session_id
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
    v_variant,
    p_session_id
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

  -- é31 lot 2 — LES CINQ CONDITIONS QUI MANQUAIENT ICI. `v_profile` vient d'être
  -- relu APRÈS `award_xp` : la série et le niveau sont ceux d'après cette
  -- tentative, donc le badge tombe le jour où il est mérité, pas le lendemain.
  IF COALESCE(v_profile.current_streak, 0) >= 30 THEN
    v_badge := public.award_badge_if_new(v_user_id, 'streak_30', '30 consecutive days of studying');
    IF v_badge IS NOT NULL THEN
      v_unlocked_badges := v_unlocked_badges || jsonb_build_array(v_badge);
    END IF;
  END IF;

  IF COALESCE(v_profile.level, 1) >= 10 THEN
    v_badge := public.award_badge_if_new(v_user_id, 'level_10', 'Reached level 10');
    IF v_badge IS NOT NULL THEN
      v_unlocked_badges := v_unlocked_badges || jsonb_build_array(v_badge);
    END IF;
  END IF;

  IF public.badge_is_math_subject(v_exercise.subject_id) THEN
    -- `math_blitz` porte déjà son seuil dans son rule_key (`math_95`).
    IF v_score_pct >= 95 THEN
      v_badge := public.award_badge_if_new(v_user_id, 'math_blitz', 'Scored 95%+ on a maths exercise');
      IF v_badge IS NOT NULL THEN
        v_unlocked_badges := v_unlocked_badges || jsonb_build_array(v_badge);
      END IF;
    END IF;

    -- Dix exercices DISTINCTS : rejouer dix fois le même n'est pas de la maîtrise.
    IF (
      SELECT COUNT(DISTINCT a.exercise_id)
      FROM public.attempts a
      WHERE a.user_id = v_user_id
        AND a.score_pct >= 80
        AND public.badge_is_math_subject(a.subject_id)
    ) >= 10 THEN
      v_badge := public.award_badge_if_new(v_user_id, 'math_master', '10 maths exercises passed at 80%+');
      IF v_badge IS NOT NULL THEN
        v_unlocked_badges := v_unlocked_badges || jsonb_build_array(v_badge);
      END IF;
    END IF;
  END IF;

  -- Polyglotte : trois LANGUES DE CONTENU différentes réussies. `content_language`
  -- porte une contrainte CHECK (ar/fr/en), donc la règle ne dépend d'aucune
  -- convention d'auteur — contrairement à « trois matières de langues », qui
  -- demanderait de deviner ce qu'est une matière de langue.
  IF (
    SELECT COUNT(DISTINCT s.content_language)
    FROM public.attempts a
    JOIN public.subjects s ON s.id = a.subject_id
    WHERE a.user_id = v_user_id
      AND a.score_pct >= 60
  ) >= 3 THEN
    v_badge := public.award_badge_if_new(v_user_id, 'polyglot', 'Passed an exercise in three content languages');
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

  -- é31 lot 3 — LES MISSIONS DU JOUR. Une tentative peut en nourrir plusieurs :
  -- chacune est réclamée par le FAIT qui vient de se produire, jamais par le
  -- type de la mission — c'est ce qui rend le pool extensible sans toucher ici.
  PERFORM public.bump_daily_mission(v_user_id, 'exercises_n', v_today);

  IF v_score_pct >= 90 THEN
    PERFORM public.bump_daily_mission(v_user_id, 'score_90', v_today);
  END IF;

  IF v_variant = 'recall' THEN
    PERFORM public.bump_daily_mission(v_user_id, 'recall_one', v_today);
  END IF;

  -- Une révision due VIENT d'être close par cette tentative (le bloc SM-2
  -- ci-dessus l'a passée à `completed`) : la mission de révision la suit.
  IF EXISTS (
    SELECT 1 FROM public.spaced_repetition_schedule s
     WHERE s.user_id = v_user_id AND s.exercise_id = p_exercise_id
       AND s.status = 'completed' AND s.completed_at >= clock_timestamp() - INTERVAL '5 seconds'
  ) THEN
    PERFORM public.bump_daily_mission(v_user_id, 'review_due', v_today);
  END IF;

  -- « Dans ton parcours » : la matière de l'exercice appartient au parcours actif.
  IF EXISTS (
    SELECT 1
      FROM public.profiles pr
      JOIN public.parcours pa ON pa.id = pr.current_parcours_id
      JOIN public.subjects s ON s.theme_id = pa.theme_id
       AND (pa.grade_id IS NULL OR s.grade_id = pa.grade_id)
     WHERE pr.id = v_user_id AND s.id = v_exercise.subject_id
  ) THEN
    PERFORM public.bump_daily_mission(v_user_id, 'subject_focus', v_today);

    -- « Avancer le chapitre » : une PREMIÈRE réussite sur cet exercice. Un rejeu
    -- d'un exercice déjà réussi n'avance rien — `v_prev_best` porte le meilleur
    -- score d'avant cette tentative.
    IF v_score_pct >= 60 AND v_prev_best < 60 THEN
      PERFORM public.bump_daily_mission(v_user_id, 'chapter_step', v_today);
    END IF;
  END IF;

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
    -- Prime de rapidité effectivement appliquée (1 = aucune, hors mode boss).
    'speedBonus', v_boss_speed_factor,
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

REVOKE EXECUTE ON FUNCTION public.submit_exercise_attempt(uuid, uuid, jsonb) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.submit_exercise_attempt(uuid, uuid, jsonb) TO authenticated;


-- ---------------------------------------------------------------------------
-- 5. Le quiz de compréhension du catalogue PUBLIC — le dénominateur, surtout.
--
-- `score_quiz` est appelable par `anon`. `auth.uid()` y vaut NULL, la porte
-- répond `false`, et une `short_answer` sort du total : un visiteur non
-- connecté ne peut donc pas être noté sur une question qu'on ne lui a pas
-- montrée.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.score_quiz(p_exercise_id uuid, p_answers jsonb)
RETURNS TABLE (correct integer, total integer)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_source text;
  v_mode text;
  -- Anonyme ⇒ `auth.uid()` NULL ⇒ false : le catalogue public ne sert jamais
  -- une question ouverte, il ne peut donc pas en compter une.
  v_open_ok boolean := public.can_play_open_questions(auth.uid());
BEGIN
  IF p_answers IS NULL OR jsonb_typeof(p_answers) <> 'array' THEN
    RETURN QUERY SELECT 0, 0;
    RETURN;
  END IF;

  SELECT e.source, e.mode
    INTO v_source, v_mode
    FROM public.exercises e
    WHERE e.id = p_exercise_id;

  -- Only the public (admin) catalogue's comprehension quiz is scorable here.
  IF v_source IS DISTINCT FROM 'admin' OR v_mode IS DISTINCT FROM 'quiz' THEN
    RETURN QUERY SELECT 0, 0;
    RETURN;
  END IF;

  RETURN QUERY
    SELECT
      (
        SELECT count(*)
          FROM jsonb_array_elements(p_answers) AS a(elem)
          JOIN public.questions q
            ON q.id = nullif(a.elem ->> 'questionId', '')::uuid
         WHERE q.exercise_id = p_exercise_id
           AND public.is_question_in_play(q, v_open_ok)
           AND public.score_answer(q, a.elem ->> 'choice')
      )::integer AS correct,
      (
        SELECT count(*)
          FROM public.questions q
         WHERE q.exercise_id = p_exercise_id
           AND public.is_question_in_play(q, v_open_ok)
      )::integer AS total;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.score_quiz(uuid, jsonb) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.score_quiz(uuid, jsonb) TO anon, authenticated;


-- ---------------------------------------------------------------------------
-- 6. La correction de fin de mission — le même ensemble que le score.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_attempt_review(p_session_id uuid, p_answers jsonb DEFAULT NULL)
RETURNS TABLE (
  question_id uuid,
  prompt text,
  correct_option text,
  explanation text,
  is_correct boolean,
  misconception_tag text,
  chapter_id uuid
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
  v_chapter uuid;
  -- Étude 33 : les questions OUVERTES ne sont en jeu que si le mode IA les sert.
  v_open_ok BOOLEAN := false;
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

  -- The chapter travels with the review so the client can offer « revoir le cours »
  -- without a second round-trip (D-A1.2-4: the link targets the chapter, the anchor
  -- is an optional refinement of the registry). NULL for a chapter-less exercise —
  -- the client then simply has no link to draw (R-A1.2-3).
  SELECT e.mode, e.chapter_id INTO v_mode, v_chapter
    FROM public.exercises e WHERE e.id = v_exercise;
  IF v_mode = 'quiz' THEN
    RETURN;
  END IF;

  v_variant := COALESCE(v_variant, 'classic');

  -- Le MÊME ensemble que celui qu'a noté `submit_exercise_attempt` : une
  -- correction qui listerait une question hors jeu contredirait le score.
  v_open_ok := public.can_play_open_questions(v_user);

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
      v.is_correct,
      -- D-A1.2-2: the tag of the CHOSEN option only, and only when that choice was
      -- wrong. `IS DISTINCT FROM false` also covers the unscored call shape
      -- (p_answers absent -> verdict NULL -> no tag), where there is no choice to
      -- name in the first place.
      CASE
        WHEN v.is_correct IS DISTINCT FROM false THEN NULL
        ELSE public.resolve_misconception_tag(q, a.choice, v_variant)
      END,
      v_chapter
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
    -- Scored through the same seam as the submit RPC, so the review can never
    -- contradict the score. NULL when no answers were given (legacy call shape).
    -- Computed once in a LATERAL because both `is_correct` and the tag gate read it.
    CROSS JOIN LATERAL (
      SELECT CASE
        WHEN p_answers IS NULL THEN NULL
        WHEN v_variant = 'recall' THEN public.score_recall_answer(q, a.choice)
        ELSE public.score_answer(q, a.choice)
      END AS is_correct
    ) v
    WHERE q.exercise_id = v_exercise
      AND (v_variant = 'classic' OR public.is_question_recall_eligible(q))
      AND public.is_question_in_play(q, v_open_ok)
    ORDER BY q.display_order;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.get_attempt_review(uuid, jsonb) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_attempt_review(uuid, jsonb) TO authenticated;


-- ---------------------------------------------------------------------------
-- 7. Le DONJON — exclusion inconditionnelle (chronomètre, cf. en-tête).
--
-- Les deux comptages de cadrage de pool sont gardés EUX AUSSI : sans cela, le
-- pool serait jugé assez fourni sur des questions que le tirage écarte ensuite,
-- et le donjon se rabattrait sur un périmètre plus large qu'il ne fallait.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_dungeon_questions(
  p_run_id UUID,
  p_batch_size INT DEFAULT 5
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_run public.dungeon_runs;
  v_max_difficulty INT;
  v_questions JSONB := '[]'::jsonb;
  v_theme TEXT;
  v_grade UUID;
  v_cycle TEXT;
  v_cycle_grades UUID[];
  v_pool_scope TEXT := 'all';
  v_available INT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_run_id IS NULL THEN
    RAISE EXCEPTION 'Run id is required';
  END IF;

  IF p_batch_size IS NULL OR p_batch_size < 1 OR p_batch_size > 20 THEN
    RAISE EXCEPTION 'Invalid batch size';
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

  v_max_difficulty := LEAST(3, CEIL(v_run.current_floor::NUMERIC / 5.0)::INT);

  -- Le parcours actif est résolu SERVEUR (comme match_duel) : le client ne peut pas
  -- réclamer un autre pool que le sien.
  SELECT pa.theme_id, pa.grade_id
    INTO v_theme, v_grade
    FROM public.profiles pr
    JOIN public.parcours pa ON pa.id = pr.current_parcours_id
   WHERE pr.id = v_user;

  IF v_theme IS NOT NULL AND v_grade IS NOT NULL THEN
    SELECT count(*)
      INTO v_available
      FROM public.questions q
      JOIN public.exercises e ON e.id = q.exercise_id
      JOIN public.subjects s ON s.id = e.subject_id
     WHERE e.difficulty <= v_max_difficulty
       AND e.mode IS DISTINCT FROM 'quiz'
       AND e.source = 'admin'
       AND q.question_type <> 'short_answer'
       AND s.theme_id = v_theme
       AND s.grade_id = v_grade
       AND NOT EXISTS (
         SELECT 1
           FROM public.dungeon_run_questions rq
          WHERE rq.run_id = p_run_id
            AND rq.question_id = q.id
       );

    IF v_available >= 60 THEN
      v_pool_scope := 'grade';
    ELSE
      -- Repli d'un cran : les classes du même cycle, dans le même thème.
      SELECT g.cycle INTO v_cycle FROM public.grades g WHERE g.id = v_grade;

      IF v_cycle IS NOT NULL THEN
        SELECT array_agg(g.id)
          INTO v_cycle_grades
          FROM public.grades g
         WHERE g.theme_id = v_theme
           AND g.cycle = v_cycle;

        SELECT count(*)
          INTO v_available
          FROM public.questions q
          JOIN public.exercises e ON e.id = q.exercise_id
          JOIN public.subjects s ON s.id = e.subject_id
         WHERE e.difficulty <= v_max_difficulty
           AND e.mode IS DISTINCT FROM 'quiz'
           AND e.source = 'admin'
           AND q.question_type <> 'short_answer'
           AND s.theme_id = v_theme
           AND s.grade_id = ANY (v_cycle_grades)
           AND NOT EXISTS (
             SELECT 1
               FROM public.dungeon_run_questions rq
              WHERE rq.run_id = p_run_id
                AND rq.question_id = q.id
           );

        IF v_available >= 30 THEN
          v_pool_scope := 'cycle';
        END IF;
      END IF;
    END IF;
  END IF;

  WITH inserted AS (
    INSERT INTO public.dungeon_run_questions (run_id, question_id, assigned_floor)
    SELECT p_run_id, c.id, v_run.current_floor + row_number() OVER (ORDER BY c.id) - 1
    FROM (
      SELECT q.id
      FROM public.questions q
      JOIN public.exercises e ON e.id = q.exercise_id
      JOIN public.subjects s ON s.id = e.subject_id
      WHERE e.difficulty <= v_max_difficulty
        AND e.mode IS DISTINCT FROM 'quiz'
        AND e.source = 'admin'
        AND q.question_type <> 'short_answer'
        AND NOT EXISTS (
          SELECT 1
          FROM public.dungeon_run_questions rq
          WHERE rq.run_id = p_run_id
            AND rq.question_id = q.id
        )
        AND (
          v_pool_scope = 'all'
          OR (v_pool_scope = 'grade' AND s.theme_id = v_theme AND s.grade_id = v_grade)
          OR (v_pool_scope = 'cycle' AND s.theme_id = v_theme
              AND s.grade_id = ANY (v_cycle_grades))
        )
      ORDER BY random()
      LIMIT p_batch_size
    ) c
    ON CONFLICT DO NOTHING
    RETURNING question_id, assigned_floor
  )
  SELECT COALESCE(jsonb_agg(
    jsonb_build_object(
      'id', q.id,
      'prompt', q.prompt,
      'options', q.options,
      'question_type', q.question_type,
      'explanation', q.explanation,
      'assignedFloor', ins.assigned_floor,
      'exercises', jsonb_build_object(
        'difficulty', e.difficulty,
        'subject_id', s.id,
        'subjects', jsonb_build_object(
          'name_fr', s.name_fr,
          'color_token', s.color_token,
          'icon', s.icon
        )
      )
    )
    ORDER BY ins.assigned_floor
  ), '[]'::jsonb)
  INTO v_questions
  FROM inserted ins
  JOIN public.questions q ON q.id = ins.question_id
  JOIN public.exercises e ON e.id = q.exercise_id
  JOIN public.subjects s ON s.id = e.subject_id;

  RETURN jsonb_build_object(
    'currentFloor', v_run.current_floor,
    'poolScope', v_pool_scope,
    'questions', v_questions
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.get_dungeon_questions(uuid, int) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_dungeon_questions(uuid, int) TO authenticated;


-- ---------------------------------------------------------------------------
-- 8. Le DUEL — exclusion inconditionnelle (jeu partagé, cf. en-tête).
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
      -- R-2 (jeu FIGÉ et IDENTIQUE pour les deux) : une question ouverte ne
      -- peut pas entrer ici. Elle dépend d'une porte PAR ÉLÈVE, et deux
      -- adversaires n'ont aucune raison d'avoir la même — le duel cesserait
      -- d'être équitable, ou l'un des deux jouerait une question que l'autre
      -- ne voit pas.
      AND q.question_type <> 'short_answer'
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
-- 9. Le BAC BLANC — exclusion inconditionnelle, aux TROIS endroits.
--
-- Le sujet servi, le barème et la correction lisent chacun leur propre requête
-- sur `questions`. Les trois doivent écarter le même ensemble : n'en corriger
-- que deux donnerait une épreuve notée sur des questions absentes du sujet.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.start_mock_exam(p_exam_id UUID, p_kind TEXT DEFAULT 'ranked')
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user    UUID := (SELECT auth.uid());
  v_exam    public.mock_exams%ROWTYPE;
  v_session public.mock_exam_sessions%ROWTYPE;
  v_papers  INT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_kind IS NULL OR p_kind NOT IN ('ranked', 'practice') THEN
    RAISE EXCEPTION 'Invalid session kind';
  END IF;

  SELECT * INTO v_exam
    FROM public.mock_exams
   WHERE id = p_exam_id AND status = 'published';
  IF NOT FOUND THEN
    RAISE EXCEPTION 'MOCK_EXAM_NOT_FOUND';
  END IF;

  -- Une application de contenu peut avoir emporté les épreuves (CASCADE, lot 1) :
  -- mieux vaut refuser franchement que servir une coquille vide chronométrée.
  SELECT count(*) INTO v_papers
    FROM public.mock_exam_papers WHERE exam_id = p_exam_id;
  IF v_papers = 0 THEN
    RAISE EXCEPTION 'MOCK_EXAM_EMPTY';
  END IF;

  SELECT * INTO v_session
    FROM public.mock_exam_sessions
   WHERE exam_id = p_exam_id AND user_id = v_user AND kind = p_kind
   ORDER BY started_at DESC
   LIMIT 1
     FOR UPDATE;

  IF FOUND THEN
    IF v_session.finished_at IS NOT NULL THEN
      -- R-4 : la classée est jouée une fois. La reprise passe par `practice`,
      -- que le client demande explicitement.
      IF p_kind = 'ranked' THEN
        RAISE EXCEPTION 'MOCK_EXAM_ALREADY_RANKED';
      END IF;
      v_session := NULL;                    -- un entraînement fini : on en rouvre un
    ELSIF p_kind = 'practice' AND now() >= v_session.deadline THEN
      v_session := NULL;                    -- entraînement périmé : idem
    END IF;
    -- Une CLASSÉE non finie est reprise telle quelle, même après la deadline :
    -- le client la trouvera expirée et la rendra (auto-rendu R-2), ce qui vaut
    -- mieux que de lui interdire l'accès à sa propre copie.
  END IF;

  IF v_session.id IS NULL THEN
    BEGIN
      INSERT INTO public.mock_exam_sessions (exam_id, user_id, kind, deadline)
      VALUES (
        p_exam_id, v_user, p_kind,
        now() + make_interval(mins => v_exam.duration_minutes)
      )
      RETURNING * INTO v_session;
    EXCEPTION WHEN unique_violation THEN
      -- Deux onglets ont cliqué en même temps : l'index partiel a tranché,
      -- on sert la session gagnante au lieu de renvoyer une erreur.
      SELECT * INTO v_session
        FROM public.mock_exam_sessions
       WHERE exam_id = p_exam_id AND user_id = v_user AND kind = p_kind
       ORDER BY started_at DESC
       LIMIT 1;
    END;
  END IF;

  RETURN jsonb_build_object(
    'session', jsonb_build_object(
      'id', v_session.id,
      'kind', v_session.kind,
      'startedAt', v_session.started_at,
      'deadline', v_session.deadline,
      'finishedAt', v_session.finished_at,
      'answers', v_session.answers
    ),
    'serverNow', now(),
    'exam', jsonb_build_object(
      'id', v_exam.id,
      'parcoursId', v_exam.parcours_id,
      'titleFr', v_exam.title_fr,
      'titleEn', v_exam.title_en,
      'titleAr', v_exam.title_ar,
      'durationMinutes', v_exam.duration_minutes
    ),
    -- R-3 : ni clé, ni explication. Le JSON est construit champ par champ
    -- précisément pour qu'un ajout de colonne ne puisse pas en faire fuir une.
    'papers', COALESCE((
      SELECT jsonb_agg(
               jsonb_build_object(
                 'exerciseId', pp.exercise_id,
                 'labelFr', pp.label_fr,
                 'labelEn', pp.label_en,
                 'labelAr', pp.label_ar,
                 'points', pp.points,
                 'subjectId', ex.subject_id,
                 'questions', COALESCE((
                   SELECT jsonb_agg(
                            jsonb_build_object(
                              'id', q.id,
                              'prompt', q.prompt,
                              'options', q.options,
                              'questionType', q.question_type
                            ) ORDER BY q.display_order, q.id
                          )
                     FROM public.questions q
                    WHERE q.exercise_id = pp.exercise_id
                      AND q.question_type <> 'short_answer'
                 ), '[]'::jsonb)
               ) ORDER BY pp.display_order
             )
        FROM public.mock_exam_papers pp
        JOIN public.exercises ex ON ex.id = pp.exercise_id
       WHERE pp.exam_id = p_exam_id
    ), '[]'::jsonb)
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.finish_mock_exam(p_session_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user      UUID := (SELECT auth.uid());
  v_session   public.mock_exam_sessions%ROWTYPE;
  v_breakdown JSONB;
  v_score     NUMERIC := 0;
  v_max       INT     := 0;
  v_pct       NUMERIC := 0;
  v_xp        INT     := 0;
  v_coins     INT     := 0;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT * INTO v_session
    FROM public.mock_exam_sessions
   WHERE id = p_session_id AND user_id = v_user
     FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'MOCK_EXAM_SESSION_NOT_FOUND';
  END IF;
  IF v_session.finished_at IS NOT NULL THEN
    RAISE EXCEPTION 'MOCK_EXAM_FINISHED';
  END IF;

  -- Une épreuve sans réponse enregistrée vaut zéro, elle ne « plante » pas :
  -- `score_answer(q, NULL)` renvoie false par contrat (20260727120000).
  WITH per_paper AS (
    SELECT
      pp.exercise_id,
      pp.label_fr,
      pp.label_en,
      pp.label_ar,
      pp.points,
      pp.display_order,
      count(q.id)::INT AS total,
      count(*) FILTER (
        WHERE public.score_answer(q, v_session.answers ->> q.id::text)
      )::INT AS correct
    FROM public.mock_exam_papers pp
    JOIN public.questions q ON q.exercise_id = pp.exercise_id
                           AND q.question_type <> 'short_answer'
   WHERE pp.exam_id = v_session.exam_id
   GROUP BY pp.exercise_id, pp.label_fr, pp.label_en, pp.label_ar,
            pp.points, pp.display_order
  )
  SELECT
    COALESCE(sum(points * correct::NUMERIC / NULLIF(total, 0)), 0),
    COALESCE(sum(points), 0)::INT,
    COALESCE(
      jsonb_agg(
        jsonb_build_object(
          'exerciseId', exercise_id,
          'labelFr', label_fr,
          'labelEn', label_en,
          'labelAr', label_ar,
          'points', points,
          'correct', correct,
          'total', total,
          'earned', ROUND(points * correct::NUMERIC / NULLIF(total, 0), 2)
        ) ORDER BY display_order
      ),
      '[]'::jsonb
    )
    INTO v_score, v_max, v_breakdown
    FROM per_paper;

  v_pct := CASE WHEN v_max > 0 THEN ROUND(v_score * 100.0 / v_max, 1) ELSE 0 END;

  UPDATE public.mock_exam_sessions
     SET finished_at  = LEAST(now(), deadline),   -- R-2 : rendre en retard tronque
         score_points = ROUND(v_score, 2),
         max_points   = v_max
   WHERE id = p_session_id
   RETURNING * INTO v_session;

  -- R-5 : versé UNE fois, sur la session classée seulement. `award_xp` porte déjà
  -- le passage de niveau et les badges ; on ne recopie pas cette logique ici.
  IF v_session.kind = 'ranked' THEN
    v_xp    := GREATEST(0, ROUND(300 * v_pct / 100.0)::INT);
    v_coins := GREATEST(0, ROUND(60 * v_pct / 100.0)::INT);
    IF v_xp > 0 THEN
      PERFORM public.award_xp(v_user, v_xp);
    END IF;
    IF v_coins > 0 THEN
      UPDATE public.profiles
         SET yahia_coins = yahia_coins + v_coins
       WHERE id = v_user;
    END IF;
  END IF;

  RETURN jsonb_build_object(
    'sessionId', v_session.id,
    'kind', v_session.kind,
    'finishedAt', v_session.finished_at,
    'scorePoints', v_session.score_points,
    'maxPoints', v_session.max_points,
    'scorePct', v_pct,
    -- La seule échelle que l'élève et le parent savent lire.
    'scoreOn20', CASE WHEN v_max > 0 THEN ROUND(v_score * 20.0 / v_max, 2) ELSE 0 END,
    'xpEarned', v_xp,
    'coinsEarned', v_coins,
    'papers', v_breakdown
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.get_mock_exam_review(p_session_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user    UUID := (SELECT auth.uid());
  v_session public.mock_exam_sessions%ROWTYPE;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT * INTO v_session
    FROM public.mock_exam_sessions
   WHERE id = p_session_id AND user_id = v_user;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'MOCK_EXAM_SESSION_NOT_FOUND';
  END IF;
  IF v_session.finished_at IS NULL THEN
    RAISE EXCEPTION 'MOCK_EXAM_NOT_FINISHED';
  END IF;

  RETURN COALESCE((
    SELECT jsonb_agg(
             jsonb_build_object(
               'exerciseId', pp.exercise_id,
               'labelFr', pp.label_fr,
               'labelEn', pp.label_en,
               'labelAr', pp.label_ar,
               'questions', COALESCE((
                 SELECT jsonb_agg(
                          jsonb_build_object(
                            'questionId', q.id,
                            'prompt', q.prompt,
                            'options', q.options,
                            'questionType', q.question_type,
                            'selectedChoice', v_session.answers ->> q.id::text,
                            'isCorrect', public.score_answer(q, v_session.answers ->> q.id::text),
                            'correctChoice', public.answer_key_display(q),
                            'explanation', q.explanation
                          ) ORDER BY q.display_order, q.id
                        )
                   FROM public.questions q
                  WHERE q.exercise_id = pp.exercise_id
                    AND q.question_type <> 'short_answer'
               ), '[]'::jsonb)
             ) ORDER BY pp.display_order
           )
      FROM public.mock_exam_papers pp
     WHERE pp.exam_id = v_session.exam_id
  ), '[]'::jsonb);
END;
$$;

REVOKE ALL ON FUNCTION public.start_mock_exam(UUID, TEXT) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.finish_mock_exam(UUID) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.get_mock_exam_review(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.start_mock_exam(UUID, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.finish_mock_exam(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_mock_exam_review(UUID) TO authenticated;
