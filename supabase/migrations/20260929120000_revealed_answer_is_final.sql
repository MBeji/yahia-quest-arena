-- UNE RÉPONSE CORRIGÉE EST DÉFINITIVE — la triche au rechargement (F5).
--
-- LE DÉFAUT (signalé par un parent le 2026-09-29)
-- ---------------------------------------------------------------------------
-- Le retour immédiat (levier 01) corrige chaque question pendant la partie et
-- montre la bonne réponse. Le verrou qui rendait cela compatible avec le score
-- final vivait dans le NAVIGATEUR (`answeredQuestionRef`) : un rechargement
-- l'effaçait. L'élève cochait au hasard, lisait la bonne réponse, appuyait sur
-- F5 — `start_exercise_session` ouvrait une session NEUVE, le brouillon local le
-- replaçait sur la même question (la réponse corrigée n'y entre qu'à
-- « Continuer ») — et il redonnait la bonne réponse, que `submit_exercise_attempt`
-- notait juste. Question après question : 100 % sans rien savoir, et avec eux
-- les XP, les étoiles, les sceaux et le suivi parental.
--
-- L'en-tête d'`ExercisePlayer` disait déjà que ce verrou n'était pas une garantie
-- contre un client modifié. Il n'en était pas une non plus contre la touche F5.
--
-- CE QUE CETTE MIGRATION CHANGE — le verrou passe au serveur
-- ---------------------------------------------------------------------------
-- 1. `exercise_session_reveals` retient, par session et par question, la réponse
--    sur laquelle un verdict a été MONTRÉ. Première correction gagnante, en
--    insertion seule (clé primaire + ON CONFLICT DO NOTHING).
-- 2. `reveal_session_answer` remplace `check_answers` dans le lecteur connecté :
--    elle fige la réponse AVANT de la corriger, et corrige la réponse FIGÉE — une
--    seconde demande avec un autre choix reçoit le verdict du premier, et le
--    choix figé avec lui.
-- 3. `start_exercise_session` REPREND la partie inachevée où une correction a été
--    montrée il y a moins de deux heures, au lieu d'en ouvrir une vierge ; au-delà,
--    la partie neuve HÉRITE des corrections des parties abandonnées depuis la
--    dernière partie rendue.
-- 4. `submit_exercise_attempt` note chaque question corrigée sur sa réponse figée
--    (`apply_session_reveals`), quoi que le client envoie — ou omette.
--
-- CE QUI NE CHANGE PAS
-- ---------------------------------------------------------------------------
-- - Rejouer une mission APRÈS l'avoir rendue reste permis : la correction complète
--   de fin de partie est un choix pédagogique, et l'anti-farm (XP sur progrès
--   seulement, >= 4 s/question) garde ses règles. Une partie rendue remet
--   l'héritage à zéro.
-- - Le quiz de compréhension et le Rappel ne montrent aucun verdict en cours de
--   partie : rien n'y est figé, `reveal_session_answer` n'y rend aucune ligne.
-- - `check_answers` reste ouverte : le registre public `/exercice` n'enregistre
--   aucun score, il n'y a rien à y protéger.
-- - Aucune écriture client : la table n'est lisible que par son propriétaire (pour
--   reprendre sa partie) et n'est écrite que par les fonctions SECURITY DEFINER.
-- - Le compte de test (rôle `admin`) n'est pas concerné : rien n'est figé pour lui, il
--   rejoue une question à volonté (voir `reveal_session_answer`).
--
-- ADDITIVE : une table, deux fonctions neuves, deux CREATE OR REPLACE à signature
-- inchangée. Un client antérieur (qui corrige par `check_answers`) ne fige rien,
-- exactement comme avant : le déploiement n'a pas d'ordre imposé.
--
-- pgTAP : 100_revealed_answer_is_final.test.sql.

-- ---------------------------------------------------------------------------
-- 1. LE REGISTRE — une ligne par question corrigée pendant une partie.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.exercise_session_reveals (
  session_id  UUID NOT NULL REFERENCES public.exercise_sessions(id) ON DELETE CASCADE,
  question_id UUID NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
  -- Recopié de la session : la policy de lecture, l'export du compte (dérivé des
  -- FK vers auth.users, pgTAP 85) et son effacement le lisent sans jointure.
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  -- La réponse sur laquelle le verdict a été montré. Même borne que le zod des
  -- server fns (`MAX_CHOICE_LENGTH`).
  choice      TEXT NOT NULL CHECK (char_length(choice) BETWEEN 1 AND 512),
  revealed_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
  PRIMARY KEY (session_id, question_id)
);

COMMENT ON TABLE public.exercise_session_reveals IS
  'Réponses dont la correction a été montrée pendant une partie (retour immédiat) : figées, première correction gagnante. Lues par start_exercise_session (reprise, héritage) et submit_exercise_attempt (barème). 20260929120000.';

-- L'effacement d'un compte et le retrait d'une question par la publication du
-- contenu balaient la table par ces deux colonnes (ON DELETE CASCADE).
CREATE INDEX IF NOT EXISTS idx_exercise_session_reveals_user
  ON public.exercise_session_reveals (user_id);
CREATE INDEX IF NOT EXISTS idx_exercise_session_reveals_question
  ON public.exercise_session_reveals (question_id);

ALTER TABLE public.exercise_session_reveals ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users select own session reveals" ON public.exercise_session_reveals;
CREATE POLICY "Users select own session reveals"
  ON public.exercise_session_reveals
  FOR SELECT
  USING ((SELECT auth.uid()) = user_id);

-- Lecture seule pour l'élève (sa propre partie, pour la reprendre) ; aucune
-- écriture client. Les GRANT ne sont jamais implicites sur une stack fraîche.
REVOKE ALL ON public.exercise_session_reveals FROM PUBLIC, anon, authenticated;
GRANT SELECT ON public.exercise_session_reveals TO authenticated;
GRANT ALL    ON public.exercise_session_reveals TO service_role;


-- ---------------------------------------------------------------------------
-- 2. LA CORRECTION QUI FIGE — `reveal_session_answer`.
--
-- Le verdict vient toujours de `check_answers` (une seule définition de « juste »,
-- et le même périmètre : catalogue admin, jamais un quiz), mais il porte sur la
-- réponse FIGÉE de la session, pas sur celle que le client vient d'envoyer.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.reveal_session_answer(
  p_session_id UUID,
  p_question_id UUID,
  p_choice TEXT
)
RETURNS TABLE (
  question_id UUID,
  choice TEXT,
  is_correct BOOLEAN,
  correct_option TEXT,
  explanation TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user    UUID := auth.uid();
  v_session public.exercise_sessions;
  v_locked  TEXT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_choice IS NULL OR btrim(p_choice) = '' THEN
    RAISE EXCEPTION 'Choice is required';
  END IF;

  -- Le MÊME verrou de ligne que `submit_exercise_attempt` : une correction et la
  -- soumission d'une même partie ne s'entrelacent jamais — la note voit toutes
  -- les corrections montrées avant elle, et aucune ne se glisse après.
  SELECT *
    INTO v_session
    FROM public.exercise_sessions s
   WHERE s.id = p_session_id
     AND s.user_id = v_user
   FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Invalid quest session.';
  END IF;

  IF v_session.completed_at IS NOT NULL THEN
    RAISE EXCEPTION 'This quest session is already completed.';
  END IF;

  -- Rien n'est montré hors du périmètre de `check_answers` (catalogue admin, jamais
  -- un quiz de compréhension) ni en Rappel (réponse libre, sans retour immédiat) :
  -- rien n'est donc figé, et le lecteur enchaîne sans verdict, comme avant.
  IF v_session.variant IS DISTINCT FROM 'classic' OR NOT EXISTS (
    SELECT 1
      FROM public.questions q
      JOIN public.exercises e ON e.id = q.exercise_id
     WHERE q.id = p_question_id
       AND q.exercise_id = v_session.exercise_id
       AND e.source = 'admin'
       AND e.mode IS DISTINCT FROM 'quiz'
  ) THEN
    RETURN;
  END IF;

  IF public.is_admin() THEN
    -- Le compte de test (rôle admin) rejoue à volonté : rien n'est figé pour lui, la
    -- correction porte sur la réponse envoyée. Même esprit que `v_unrestricted` dans
    -- `start_exercise_session` — le rôle admin est l'outil du test humain, pas un
    -- compte d'usage, et ce verrou est une porte de PROGRESSION.
    v_locked := p_choice;
  ELSE
    -- Figer AVANT de corriger. `ON CONSTRAINT` plutôt qu'une liste de colonnes :
    -- `question_id` et `choice` sont aussi les noms des colonnes rendues (42702).
    INSERT INTO public.exercise_session_reveals (session_id, question_id, user_id, choice)
    VALUES (p_session_id, p_question_id, v_user, p_choice)
    ON CONFLICT ON CONSTRAINT exercise_session_reveals_pkey DO NOTHING;

    SELECT r.choice
      INTO v_locked
      FROM public.exercise_session_reveals r
     WHERE r.session_id = p_session_id
       AND r.question_id = p_question_id;
  END IF;

  -- Le verdict de la réponse FIGÉE, rendu avec elle : un client qui demandait
  -- autre chose (second onglet, rejeu d'une requête) l'apprend et l'affiche.
  RETURN QUERY
    SELECT c.question_id, v_locked, c.is_correct, c.correct_option, c.explanation
      FROM public.check_answers(
        v_session.exercise_id,
        jsonb_build_array(jsonb_build_object('questionId', p_question_id, 'choice', v_locked))
      ) AS c;
END;
$$;

COMMENT ON FUNCTION public.reveal_session_answer(UUID, UUID, TEXT) IS
  'Retour immédiat du lecteur connecté : fige la réponse de la question dans la session (première correction gagnante), puis rend le verdict de la réponse figée. Aucune ligne hors du périmètre de check_answers ni en Rappel. 20260929120000.';

REVOKE ALL ON FUNCTION public.reveal_session_answer(UUID, UUID, TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.reveal_session_answer(UUID, UUID, TEXT) TO authenticated;


-- ---------------------------------------------------------------------------
-- 3. LE BARÈME DES RÉPONSES FIGÉES — `apply_session_reveals`.
--
-- Rend les réponses d'une partie, une par question, où chaque réponse figée
-- remplace celle du payload — ou s'y ajoute si le payload l'omet. La sortie est
-- canonique (UUID normalisés, sans doublon) : écrire l'identifiant d'une question
-- autrement ne fait pas passer une seconde réponse à côté de la réponse figée.
-- Outil interne du barème : aucun rôle client ne l'exécute.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.apply_session_reveals(p_session_id UUID, p_answers JSONB)
RETURNS JSONB
LANGUAGE sql
STABLE
SET search_path = public
AS $$
  SELECT COALESCE(
           jsonb_agg(jsonb_build_object('questionId', m.question_id, 'choice', m.choice)),
           '[]'::jsonb
         )
    FROM (
      SELECT DISTINCT ON (a.question_id) a.question_id, a.choice
        FROM (
          SELECT r.question_id, r.choice, 0 AS precedence
            FROM public.exercise_session_reveals r
           WHERE r.session_id = p_session_id
          UNION ALL
          SELECT NULLIF(elem ->> 'questionId', '')::uuid, elem ->> 'choice', 1
            FROM jsonb_array_elements(COALESCE(p_answers, '[]'::jsonb)) AS elem
        ) a
       WHERE a.question_id IS NOT NULL
       ORDER BY a.question_id, a.precedence
    ) m;
$$;

COMMENT ON FUNCTION public.apply_session_reveals(UUID, JSONB) IS
  'Barème : les réponses de la partie, où chaque réponse figée par reveal_session_answer l''emporte sur le payload. Interne à submit_exercise_attempt. 20260929120000.';

REVOKE ALL ON FUNCTION public.apply_session_reveals(UUID, JSONB) FROM PUBLIC, anon, authenticated;


-- ---------------------------------------------------------------------------
-- 4. LA PORTE D'ENTRÉE — `start_exercise_session`, réémise par substitution
--    depuis 20260906160000 : corps identique hors la déclaration de deux
--    variables et le bloc final (reprise, puis héritage).
-- ---------------------------------------------------------------------------
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
  v_eligible_count INT;
  -- Compte de test : le rôle `admin` n'est pas un compte d'usage, c'est l'outil du
  -- test humain — aucune porte de PROGRESSION ne s'applique à lui (voir l'en-tête).
  v_unrestricted   BOOLEAN := public.is_admin();
  -- La session ouverte par cet appel (quand aucune n'est reprise).
  v_new_id         UUID;
  v_new_started    TIMESTAMPTZ;
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

  IF v_allowed IS DISTINCT FROM true AND NOT v_unrestricted THEN
    IF v_reason = 'PARCOURS_COMING_SOON' THEN
      RAISE EXCEPTION 'PARCOURS_COMING_SOON';
    ELSE
      RAISE EXCEPTION 'PARCOURS_LOCKED';
    END IF;
  END IF;

  -- 2) COMPREHENSION-QUIZ gate — UNE définition, celle des trois lecteurs de
  --    progression (`chapter_quiz_cleared`, 20260905130000). Elle porte le seuil
  --    (>= 80 % ET >= 4 s/question, inchangé), accepte N'IMPORTE LEQUEL des quiz du
  --    chapitre, et rend vrai quand le chapitre n'est pas gaté — donc elle couvre
  --    aussi, sans branche, le chapitre sans quiz que l'ancien code traitait à part.
  --
  --    `v_grade IS NOT NULL` RESTE, et ce n'est pas une redondance oubliée : il vient
  --    de la matière de l'EXERCICE (`exercises.subject_id`), là où `chapter_quiz_gated`
  --    lit celle du CHAPITRE (`chapters.subject_id`). Aucune contrainte n'aligne ces
  --    deux colonnes — elles sont dénormalisées indépendamment. Le garder rend le
  --    changement strictement à sens unique : sur une ligne incohérente, l'élève peut
  --    passer là où il était bloqué, jamais l'inverse. Le doute profite à l'élève.
  IF v_grade IS NOT NULL AND v_mode IS DISTINCT FROM 'quiz' AND v_chapter IS NOT NULL
     AND NOT v_unrestricted
     AND NOT public.chapter_quiz_cleared(v_user, v_chapter) THEN
    RAISE EXCEPTION 'QUIZ_LOCKED';
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

    IF NOT v_unrestricted AND NOT EXISTS (
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

  -- 4) REPRISE (20260929120000) — APRÈS les portes : un élève qui a perdu l'accès ne
  --    reprend rien. Une partie inachevée de cet exercice, dans cette variante, où
  --    une correction a été montrée il y a moins de deux heures, est RENDUE au lieu
  --    d'être remplacée : recharger la page ne rouvre pas une partie vierge. Deux
  --    heures, la fenêtre du brouillon local (`DRAFT_MAX_AGE_MS`) : au-delà, la
  --    partie n'est plus « en cours », et sa durée ne gonflerait que le temps
  --    d'étude que lit le suivi parental.
  RETURN QUERY
    SELECT es.id, es.started_at
      FROM public.exercise_sessions es
     WHERE es.user_id = v_user
       AND es.exercise_id = p_exercise_id
       AND es.variant = p_variant
       AND es.completed_at IS NULL
       AND EXISTS (
         SELECT 1
           FROM public.exercise_session_reveals r
          WHERE r.session_id = es.id
            AND r.revealed_at > clock_timestamp() - INTERVAL '2 hours'
       )
     ORDER BY es.started_at DESC
     LIMIT 1;
  IF FOUND THEN
    RETURN;
  END IF;

  -- Gates passed -> create the session as the owner. Columns in the RETURNING list
  -- are table-qualified so they bind to exercise_sessions columns, not to the
  -- same-named OUT parameters (was SQLSTATE 42702: ambiguous reference).
  INSERT INTO public.exercise_sessions AS es (user_id, exercise_id, variant)
  VALUES (v_user, p_exercise_id, p_variant)
  RETURNING es.id, es.started_at INTO v_new_id, v_new_started;

  -- 5) HÉRITAGE (20260929120000) — la partie neuve reçoit les corrections déjà
  --    montrées dans les parties ABANDONNÉES depuis la dernière partie rendue :
  --    attendre que la reprise expire ne rend pas une réponse vue à nouveau
  --    jouable. La plus ancienne correction d'une question l'emporte. Une partie
  --    RENDUE remet le compteur à zéro — l'élève y a vu la correction complète, et
  --    rejouer après l'avoir lue reste permis, comme avant.
  INSERT INTO public.exercise_session_reveals (session_id, question_id, user_id, choice, revealed_at)
  SELECT DISTINCT ON (r.question_id)
         v_new_id, r.question_id, v_user, r.choice, r.revealed_at
    FROM public.exercise_session_reveals r
    JOIN public.exercise_sessions s ON s.id = r.session_id
   WHERE s.user_id = v_user
     AND s.exercise_id = p_exercise_id
     AND s.variant = p_variant
     AND s.completed_at IS NULL
     AND r.revealed_at > COALESCE((
       SELECT max(done.completed_at)
         FROM public.exercise_sessions done
        WHERE done.user_id = v_user
          AND done.exercise_id = p_exercise_id
          AND done.variant = p_variant
     ), '-infinity'::timestamptz)
   ORDER BY r.question_id, r.revealed_at;

  RETURN QUERY SELECT v_new_id, v_new_started;
END;
$$;

REVOKE ALL ON FUNCTION public.start_exercise_session(uuid, text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.start_exercise_session(uuid, text) TO authenticated;


-- ---------------------------------------------------------------------------
-- 5. LE BARÈME — `submit_exercise_attempt`, réémise par substitution depuis
--    20260913120000 : corps identique hors UNE affectation de `p_answers`.
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

  -- UNE RÉPONSE CORRIGÉE EST DÉFINITIVE (20260929120000) — la seule ligne ajoutée
  -- à cette fonction. Toute question dont le verdict a été montré pendant la
  -- partie est notée sur la réponse figée à ce moment-là, quelle que soit celle
  -- que le payload porte (ou même s'il l'omet). Placée APRÈS la branche de rejeu,
  -- qui n'écrit rien, et AVANT les trois lecteurs de `p_answers` : la note, la
  -- télémétrie et le verdict du Rappel voient le MÊME ensemble.
  p_answers := public.apply_session_reveals(p_session_id, p_answers);

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
