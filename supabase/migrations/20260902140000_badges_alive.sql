-- Étude 31 — lot 2 : LES BADGES REDEVIENNENT DÉCERNABLES (US-3, R-13).
--
-- L'ÉTAT AVANT CE LOT. Treize badges sont semés en base ; **quatre** peuvent
-- tomber (`first_quest`, `perfect_score`, `speed_demon`, `streak_7`), et les
-- quatre s'obtiennent la première semaine. Les neuf autres ont un nom, une
-- rareté, une icône, un `rule_key` — et aucune ligne de code ne les décerne. Un
-- élève de six mois a donc exactement la même vitrine qu'un élève de six jours.
--
-- R-13 : **tout badge présent en base est décernable**, sinon il sort de la base.
-- Ce lot tient les deux moitiés de la règle.
--
-- OÙ VIT UNE CONDITION. Dans le finalizer qui POSSÈDE DÉJÀ LE FAIT, jamais dans
-- un balayage périodique : `submit_exercise_attempt` lit déjà le profil d'après
-- récompense (série, niveau) et le score ; `finalize_dungeon_run` compte déjà les
-- étages ; `purchase_shop_item` connaît l'inventaire ; `award_coins` est le seul
-- endroit où le solde MONTE. Un cron qui repasserait derrière serait une seconde
-- source de vérité, donc une divergence à venir.
--
-- ⚠️ ÉCART ASSUMÉ À LA PROPOSITION DE L'ÉTUDE (§4, lot 2) : `rich_kid` (« 500
-- pièces ») était proposé dans `purchase_shop_item`. C'est le seul endroit où le
-- solde BAISSE : un élève qui atteint 500 puis achète ne l'obtiendrait jamais. La
-- condition vit donc dans `award_coins`, qui possède réellement le fait.
--
-- LES TROIS FONCTIONS RÉÉMISES LE SONT PAR SUBSTITUTION depuis leur révision
-- vivante (submit : 20260831130000 · donjon : 20260601190000 · boutique et
-- pièces : 20260610200000 / 20260530130000). Rien n'est retapé : le corps est
-- copié ligne pour ligne, un bloc est inséré à une ancre. C'est la règle que
-- 20260831130000 a posée pour lui-même, et elle vaut ici pour la même raison —
-- une fonction de 570 lignes recopiée à la main perd quelque chose.

-- ===========================================================================
-- 1. Les familles (R-13) et les conditions, dites en clair.
--
--    `family` groupe la collection à l'écran ; `description` cesse de décrire une
--    INTENTION pour décrire la CONDITION EXACTE. « Compléter tous les exercices
--    de maths » était une promesse intenable (le catalogue grandit) : personne ne
--    pouvait l'obtenir, et personne ne pouvait dire pourquoi.
-- ===========================================================================
ALTER TABLE public.badges ADD COLUMN IF NOT EXISTS family TEXT;

UPDATE public.badges SET family = v.family, description = v.description
FROM (VALUES
  ('first_quest',   'debut',    'Terminer son premier exercice'),
  ('level_10',      'debut',    'Atteindre le niveau 10'),
  ('streak_7',      'serie',    'Tenir 7 jours consécutifs'),
  ('streak_30',     'serie',    'Tenir 30 jours consécutifs'),
  ('perfect_score', 'maitrise', 'Obtenir 100 % sur un exercice'),
  ('speed_demon',   'maitrise', 'Terminer un exercice réussi en moins de 60 secondes'),
  ('math_blitz',    'maitrise', 'Obtenir 95 % ou plus sur un exercice de mathématiques'),
  ('math_master',   'maitrise', 'Réussir 10 exercices de mathématiques à 80 % ou plus'),
  ('polyglot',      'maitrise', 'Réussir un exercice dans trois langues de contenu différentes'),
  ('boss_slayer',   'arene',    'Franchir 10 étages de donjon au total'),
  ('collector',     'arene',    'Posséder 5 objets différents'),
  ('rich_kid',      'arene',    'Atteindre 500 pièces')
) AS v(code, family, description)
WHERE public.badges.code = v.code;

-- D-5 : `night_owl` est SUPPRIMÉ, pas réaffecté. Récompenser la pratique nocturne
-- d'un mineur contredit R-4 (jamais de nuit) ; le transformer en « lève-tôt »
-- serait le même signal inversé — aucun badge ne doit juger l'heure à laquelle un
-- enfant travaille. La garde `NOT EXISTS` est là pour la prod : si un élève le
-- portait déjà, on ne lui retire rien (R-14 : un badge ne se dégrade jamais).
DELETE FROM public.badges b
 WHERE b.code = 'night_owl'
   AND NOT EXISTS (SELECT 1 FROM public.student_badges sb WHERE sb.badge_id = b.id);

-- Après le remplissage : la famille devient obligatoire. Un badge semé demain
-- sans famille casse la migration, au lieu de disparaître silencieusement d'une
-- collection groupée par familles.
UPDATE public.badges SET family = 'debut' WHERE family IS NULL;
ALTER TABLE public.badges ALTER COLUMN family SET NOT NULL;

DO $$ BEGIN
  ALTER TABLE public.badges
    ADD CONSTRAINT badges_family_check
    CHECK (family IN ('debut', 'serie', 'maitrise', 'arene', 'saison'));
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

COMMENT ON COLUMN public.badges.family IS
  'Famille de collection (é31 R-13) : debut, serie, maitrise, arene, saison. Chaque badge de la table DOIT être décernable.';

-- ===========================================================================
-- 2. « Une matière de mathématiques », défini UNE fois.
--
--    Deux badges en dépendent ; les laisser porter chacun leur propre `LIKE`
--    garantirait qu'ils divergent. La règle est l'IDENTITÉ de la matière —
--    `math`, `math-6eme`, `math-bac-math` — parce que l'identifiant est la clé
--    que la chaîne de contenu épingle (le renommer casserait une publication),
--    là où `color_token` est décoratif : `iq-training-*` et les donjons de
--    culture générale portent eux aussi `subject-math`.
--    ⚠️ Ce que ça suppose : la convention de nommage du corpus (matière-niveau).
--    Une matière de maths baptisée autrement ne compterait pas — le badge serait
--    plus dur, jamais faux. C'est le sens du compromis.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.badge_is_math_subject(p_subject_id TEXT)
RETURNS BOOLEAN
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT p_subject_id = 'math' OR p_subject_id LIKE 'math-%';
$$;

REVOKE ALL ON FUNCTION public.badge_is_math_subject(TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.badge_is_math_subject(TEXT) TO authenticated;


-- ===========================================================================
-- 3. `submit_exercise_attempt` — cinq badges de plus, au même endroit que les
--    quatre existants. Substituée depuis 20260831130000 : une seule ancre (le
--    bloc `streak_7`), tout le reste identique ligne pour ligne. Aucune écriture
--    n'est déplacée, la branche de rejeu sort toujours avant le premier INSERT :
--    l'anti-triche tient par construction (rejouer ne re-décerne rien, car
--    `award_badge_if_new` est idempotente ET la branche sort avant).
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

-- Signature inchangée, donc les privilèges survivent au CREATE OR REPLACE ;
-- ré-affirmés pour que la migration se suffise à elle-même.
REVOKE EXECUTE ON FUNCTION public.submit_exercise_attempt(uuid, uuid, jsonb) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.submit_exercise_attempt(uuid, uuid, jsonb) TO authenticated;

-- ===========================================================================
-- 4. `finalize_dungeon_run` — `boss_slayer`. Substituée depuis 20260601190000,
--    une seule ancre (le RETURN final). Le badge n'entre PAS dans la réponse :
--    l'écran de fin de donjon n'a pas de vitrine de badges, et inventer un canal
--    pour l'y montrer dépasserait le lot. Il apparaît dans la collection.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.finalize_dungeon_run(
  p_run_id UUID,
  p_duration_seconds INT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_run public.dungeon_runs;
  v_xp_earned INT;
  v_coins_earned INT;
  v_final_status TEXT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_run_id IS NULL THEN
    RAISE EXCEPTION 'Run id is required';
  END IF;

  IF p_duration_seconds IS NULL OR p_duration_seconds < 0 OR p_duration_seconds > 86400 THEN
    RAISE EXCEPTION 'Invalid run duration';
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

  v_xp_earned := v_run.floors_cleared * 15;
  v_coins_earned := (v_run.floors_cleared / 5) * 5;

  IF v_run.rewarded_at IS NULL THEN
    IF v_xp_earned > 0 THEN
      PERFORM public.award_xp(v_user, v_xp_earned);
    END IF;

    IF v_coins_earned > 0 THEN
      PERFORM public.award_coins(v_user, v_coins_earned);
    END IF;

    v_final_status := CASE WHEN v_run.status = 'active' THEN 'completed' ELSE v_run.status END;

    UPDATE public.dungeon_runs
    SET status = v_final_status,
        ended_at = COALESCE(v_run.ended_at, clock_timestamp()),
        duration_seconds = p_duration_seconds,
        rewarded_at = clock_timestamp()
    WHERE id = p_run_id;
  ELSE
    v_final_status := v_run.status;
  END IF;

  -- é31 lot 2 — `boss_slayer`. Le donjon est le seul endroit qui compte des
  -- étages ; le total CUMULÉ (toutes courses confondues) est le fait, pas le
  -- score d'une course — un élève qui tombe au 3ᵉ étage trois soirs de suite a
  -- affronté autant de boss que celui qui en enchaîne dix d'un coup.
  IF (
    SELECT COALESCE(SUM(r.floors_cleared), 0)
    FROM public.dungeon_runs r
    WHERE r.user_id = v_user
  ) >= 10 THEN
    PERFORM public.award_badge_if_new(v_user, 'boss_slayer', '10 dungeon floors cleared');
  END IF;

  RETURN jsonb_build_object(
    'floorsCleared', v_run.floors_cleared,
    'totalCorrect', v_run.total_correct,
    'totalAnswered', v_run.total_answered,
    'xpEarned', v_xp_earned,
    'coinsEarned', v_coins_earned,
    'durationSeconds', p_duration_seconds,
    'status', v_final_status
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.finalize_dungeon_run(uuid, int) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.finalize_dungeon_run(uuid, int) TO authenticated;

-- ===========================================================================
-- 5. `purchase_shop_item` — `collector`. Substituée depuis 20260610200000, une
--    seule ancre (le RETURN final).
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.purchase_shop_item(p_item_code text)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user uuid := auth.uid();
  v_item public.shop_items%ROWTYPE;
  v_existing_id uuid;
  v_remaining int;
  v_units int;
BEGIN
  IF v_user IS NULL THEN RAISE EXCEPTION 'Not authenticated.'; END IF;

  SELECT * INTO v_item FROM public.shop_items
    WHERE code = p_item_code AND is_active = true;
  IF NOT FOUND THEN RAISE EXCEPTION 'Item not available.'; END IF;

  SELECT id INTO v_existing_id FROM public.inventory_items
    WHERE student_user_id = v_user AND shop_item_id = v_item.id;

  IF v_item.item_type = 'skin' AND v_existing_id IS NOT NULL THEN
    RAISE EXCEPTION 'This skin is already in your inventory.';
  END IF;

  -- Charges granted per purchase. Hint consumables advertise their charge count in
  -- the effect payload ({"hints":3} = 3 reveals, {"hintBoost":1} = 1) and each
  -- inventory unit = one reveal (consume_hint decrements quantity). Everything else
  -- grants a single unit. (GAP-014: the payload count used to be ignored.)
  v_units := GREATEST(1, COALESCE(
    NULLIF(v_item.effect_payload ->> 'hints', '')::int,
    NULLIF(v_item.effect_payload ->> 'hintBoost', '')::int,
    1
  ));

  -- Race-safe deduction: only succeeds if the balance is sufficient.
  UPDATE public.profiles
    SET yahia_coins = yahia_coins - v_item.price_coins
    WHERE id = v_user AND yahia_coins >= v_item.price_coins
    RETURNING yahia_coins INTO v_remaining;
  IF v_remaining IS NULL THEN RAISE EXCEPTION 'Insufficient XP Coins.'; END IF;

  IF v_existing_id IS NOT NULL THEN
    UPDATE public.inventory_items SET quantity = quantity + v_units WHERE id = v_existing_id;
  ELSE
    INSERT INTO public.inventory_items (student_user_id, shop_item_id, quantity, is_equipped)
      VALUES (v_user, v_item.id, v_units, false);
  END IF;

  -- é31 lot 2 — `collector` : CINQ OBJETS DIFFÉRENTS, pas cinq exemplaires. La
  -- ligne d'inventaire est unique par (élève, objet), donc les compter suffit.
  IF (
    SELECT COUNT(*) FROM public.inventory_items i WHERE i.student_user_id = v_user
  ) >= 5 THEN
    PERFORM public.award_badge_if_new(v_user, 'collector', '5 different items owned');
  END IF;

  RETURN jsonb_build_object(
    'item_code', v_item.code,
    'remaining_coins', v_remaining,
    'purchased_item_name', v_item.name
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.purchase_shop_item(text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.purchase_shop_item(text) TO authenticated;

-- ===========================================================================
-- 6. `award_coins` — `rich_kid`. Substituée depuis 20260530130000, une seule
--    ancre (le RETURN). Le badge ne remonte pas dans la valeur de retour :
--    `award_coins` rend un profil, pas un événement de jeu.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.award_coins(p_user UUID, p_coins INT)
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  rec public.profiles;
  caller_role TEXT := current_setting('request.jwt.claim.role', true);
BEGIN
  IF p_coins IS NULL OR p_coins <= 0 THEN
    RAISE EXCEPTION 'Invalid coin value';
  END IF;

  -- Allow service role jobs, otherwise enforce self-only updates.
  IF caller_role IS DISTINCT FROM 'service_role' AND auth.uid() IS DISTINCT FROM p_user THEN
    RAISE EXCEPTION 'Not allowed to award coins for another user';
  END IF;

  UPDATE public.profiles
  SET yahia_coins = COALESCE(yahia_coins, 0) + p_coins
  WHERE id = p_user
  RETURNING * INTO rec;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Profile not found';
  END IF;

  -- é31 lot 2 — `rich_kid`. C'est ici, et nulle part ailleurs, que le solde
  -- MONTE : le vérifier à l'achat (proposition de l'étude) le rendrait
  -- inatteignable pour qui atteint 500 puis dépense. Le seuil se lit sur le solde
  -- d'APRÈS crédit, celui que `rec` porte déjà.
  IF COALESCE(rec.yahia_coins, 0) >= 500 THEN
    PERFORM public.award_badge_if_new(p_user, 'rich_kid', '500 coins reached');
  END IF;

  RETURN rec;
END;
$$;

-- ⚠️ PAS DE `GRANT ... TO authenticated` ICI. Le fichier d'où ce corps est copié
-- (20260530130000) en portait un ; 20260606150000 l'a REVOQUÉ — c'était la faille
-- S1, où n'importe quel élève connecté pouvait s'auto-créditer des pièces. Un
-- `CREATE OR REPLACE` ne touche pas aux privilèges : recopier le GRANT du fichier
-- source aurait rouvert la faille en silence. La suite `01_economy_grants` l'a vu
-- en local avant la CI ; le REVOKE est réaffirmé ici pour que l'intention soit
-- écrite à côté du corps, et non deux migrations plus loin.
REVOKE EXECUTE ON FUNCTION public.award_coins(uuid, int) FROM authenticated, anon, public;
