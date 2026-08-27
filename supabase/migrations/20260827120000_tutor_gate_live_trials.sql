-- =========================================================
-- R-1 (é11) — une épreuve ABANDONNÉE n'est pas une épreuve « en cours ».
-- ---------------------------------------------------------
-- LE DÉFAUT QUE CETTE MIGRATION RÉPARE
-- ---------------------------------------------------------
-- `can_use_tutor` refusait le tuteur dès qu'il EXISTAIT une ligne d'épreuve non
-- close. Or aucune des trois ne se referme toute seule :
--
--   * `dungeon_runs.status` ne quitte 'active' que sur une mauvaise réponse
--     (`submit_dungeon_answer`) ou sur `finalize_dungeon_run`. Un onglet fermé,
--     un rafraîchissement, un téléphone verrouillé : la ligne reste 'active'
--     POUR TOUJOURS. Et `start_dungeon_run` en insère une nouvelle sans toucher
--     à la précédente — elles s'accumulent.
--   * `exercise_sessions.completed_at` ne se pose qu'à la soumission. Une quête
--     quittée en route laisse une séance ouverte à vie, et le simple fait de
--     relancer le MÊME exercice en ouvre une seconde par-dessus.
--   * `duels.status` quitte 'active' par le balayage pg_cron d'`expire_duels`,
--     toutes les 5 minutes — donc un duel dont l'échéance est passée bloquait
--     encore, le temps du balayage.
--
-- Conséquence vécue (signalée le 2026-08-27, capture à l'appui) : sur l'écran de
-- CORRECTION d'une quête — là où le Prof est chez lui — « Demander au Prof »
-- répondait « Pas pendant un donjon ! On en parle à la sortie ». Le donjon en
-- question était fini depuis longtemps ; sa ligne, non. Comme la garde du donjon
-- est GLOBALE, elle éteignait d'un coup toutes les surfaces qui passent par
-- cette porte : l'explication d'erreur, le chat de chapitre, la boucle de
-- compréhension et « Entraîne-moi là-dessus » (donc l'entrée de la Forge par le
-- tuteur). Un mode IA « non fonctionnel », sans qu'aucun appel de modèle n'ait
-- jamais été tenté — la porte se fermait à l'étape 1.
--
-- CE QUI CHANGE, ET CE QUI NE CHANGE PAS
-- ---------------------------------------------------------
-- R-1 est une règle d'ANTI-TRICHE : « jamais pendant un donjon, un duel, une
-- séance ». Elle parle de ce que l'élève est en train de JOUER, pas d'une ligne
-- oubliée en base. La question posée par la garde devient donc « cette épreuve
-- est-elle VIVANTE ? » au lieu de « cette ligne existe-t-elle ? » :
--
--   donjon  vivant tant qu'il a bougé il y a moins de 30 min (dernière réponse,
--           ou son départ s'il n'en a aucune) ;
--   duel    vivant tant que sa PROPRE échéance n'est pas passée — `expires_at`
--           est déjà l'autorité, `expire_duels` ne fait que l'entériner ;
--   séance  vivante si c'est la DERNIÈRE séance ouverte sur cet exercice (une
--           plus ancienne a été abandonnée : l'élève en a rouvert une depuis) ET
--           qu'elle a moins de 4 h.
--
-- Les deux bornes disent deux choses différentes, d'où deux valeurs : le donjon
-- mesure une INACTIVITÉ (il horodate chaque réponse), la séance mesure sa DURÉE
-- TOTALE (elle n'horodate que son départ — `question_attempts` n'est écrit qu'à
-- la soumission, il ne renseigne rien pendant). 4 h couvre largement la plus
-- lente des séances ; au-delà, personne ne « joue » encore.
--
-- Ce qui ne change pas : les quatre refus, leurs codes, leur ORDRE, et le fait
-- qu'une épreuve réellement en cours ferme le tuteur PARTOUT. Un donjon vivant
-- bloque toujours une question d'un autre chapitre — c'est la lecture stricte de
-- R-1, et elle est intacte. Reprendre un donjon laissé en plan le rend vivant à
-- nouveau (sa dernière réponse redevient récente), donc la porte se referme.
--
-- Aucune ligne n'est réécrite : cette migration ne touche qu'une fonction. Les
-- courses abandonnées restent en base telles quelles — elles ne mentent plus sur
-- ce que l'élève est en train de faire, c'est tout ce qu'on leur demande.
-- =========================================================

CREATE OR REPLACE FUNCTION public.can_use_tutor(
  p_scope       TEXT,
  p_question_id UUID DEFAULT NULL,
  p_chapter_id  UUID DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  /** Inactivité au-delà de laquelle un donjon commencé est ABANDONNÉ, pas « en cours ». */
  c_idle CONSTANT INTERVAL := '30 minutes';
  /** Durée au-delà de laquelle une séance d'exercice ouverte n'est plus jouée. */
  c_sitting CONSTANT INTERVAL := '4 hours';
  v_completed_at TIMESTAMPTZ;
  v_started_at TIMESTAMPTZ;
BEGIN
  IF v_user IS NULL THEN
    RETURN jsonb_build_object('allowed', false, 'reason', 'NOT_AUTHENTICATED');
  END IF;

  IF p_scope NOT IN ('question', 'chapter') THEN
    RETURN jsonb_build_object('allowed', false, 'reason', 'BAD_SCOPE');
  END IF;

  -- Épreuves notées d'abord : un donjon ou un duel en cours interdit le tuteur
  -- partout, y compris sur une question d'un autre chapitre. C'est la lecture
  -- stricte de R-1 — « jamais pendant un donjon, un duel ».
  --
  -- « En cours » = qui a bougé récemment. Une course dont la dernière réponse
  -- date d'une heure n'est pas jouée : elle a été quittée, et personne ne la
  -- refermera jamais (cf. l'en-tête).
  IF EXISTS (
    SELECT 1 FROM public.dungeon_runs d
     WHERE d.user_id = v_user
       AND d.status = 'active'
       AND COALESCE(
             (SELECT MAX(rq.answered_at)
                FROM public.dungeon_run_questions rq
               WHERE rq.run_id = d.id),
             d.started_at
           ) > now() - c_idle
  ) THEN
    RETURN jsonb_build_object('allowed', false, 'reason', 'ACTIVE_DUNGEON');
  END IF;

  -- `expires_at` est l'autorité du duel, pas `status` : `expire_duels` ne fait
  -- que constater l'échéance toutes les 5 minutes. Lire l'échéance elle-même
  -- supprime cette fenêtre — un duel fini ne bloque pas en attendant le cron.
  IF EXISTS (
    SELECT 1
      FROM public.duel_participants dp
      JOIN public.duels du ON du.id = dp.duel_id
     WHERE dp.user_id = v_user
       AND dp.finished_at IS NULL
       AND du.status = 'active'
       AND du.expires_at > now()
  ) THEN
    RETURN jsonb_build_object('allowed', false, 'reason', 'ACTIVE_DUEL');
  END IF;

  IF p_scope = 'question' THEN
    IF p_question_id IS NULL THEN
      RETURN jsonb_build_object('allowed', false, 'reason', 'BAD_SCOPE');
    END IF;

    -- Une séance d'exercice NON terminée sur l'exercice qui porte la question :
    -- l'élève est encore dedans, il peut encore changer sa réponse. Le tuteur
    -- serait alors une antisèche.
    --
    -- On ne regarde que la séance la PLUS RÉCENTE de cet exercice : une plus
    -- ancienne restée ouverte a forcément été abandonnée, puisque l'élève en a
    -- rouvert une depuis. Sans cette borne, relancer un exercice qu'on avait
    -- quitté en route suffisait à éteindre le Prof sur ses questions, jusqu'à
    -- la fin des temps — sur l'écran de correction du run SUIVANT, pourtant
    -- dûment terminé.
    SELECT s.completed_at, s.started_at
      INTO v_completed_at, v_started_at
      FROM public.exercise_sessions s
     WHERE s.user_id = v_user
       AND s.exercise_id = (
             SELECT q.exercise_id FROM public.questions q WHERE q.id = p_question_id
           )
     ORDER BY s.started_at DESC
     LIMIT 1;

    IF FOUND AND v_completed_at IS NULL AND v_started_at > now() - c_sitting THEN
      RETURN jsonb_build_object('allowed', false, 'reason', 'ACTIVE_SESSION');
    END IF;

    -- ⚠️ `NOT_ATTEMPTED` est la garde qui rend R-16 possible. Tant qu'elle n'est
    -- pas franchie, `get_tutor_question_context` refuse de rendre la clé — donc
    -- le modèle ne peut pas divulguer ce qu'il n'a pas reçu.
    IF NOT EXISTS (
      SELECT 1 FROM public.question_attempts a
       WHERE a.user_id = v_user AND a.question_id = p_question_id
    ) THEN
      RETURN jsonb_build_object('allowed', false, 'reason', 'NOT_ATTEMPTED');
    END IF;

    RETURN jsonb_build_object('allowed', true, 'reason', 'OK');
  END IF;

  -- Portée chapitre (chat, lot 3) : hors de toute séance active, donc les deux
  -- gardes globales ci-dessus suffisent.
  IF p_chapter_id IS NULL THEN
    RETURN jsonb_build_object('allowed', false, 'reason', 'BAD_SCOPE');
  END IF;

  -- Même règle qu'en portée question, exercice par exercice : la dernière
  -- séance de chacun, et elle seule, dit si l'élève y est encore.
  IF EXISTS (
    SELECT 1
      FROM (
        SELECT DISTINCT ON (s.exercise_id) s.completed_at, s.started_at
          FROM public.exercise_sessions s
          JOIN public.exercises e ON e.id = s.exercise_id
         WHERE s.user_id = v_user AND e.chapter_id = p_chapter_id
         ORDER BY s.exercise_id, s.started_at DESC
      ) last_session
     WHERE last_session.completed_at IS NULL
       AND last_session.started_at > now() - c_sitting
  ) THEN
    RETURN jsonb_build_object('allowed', false, 'reason', 'ACTIVE_SESSION');
  END IF;

  RETURN jsonb_build_object('allowed', true, 'reason', 'OK');
END;
$$;

REVOKE EXECUTE ON FUNCTION public.can_use_tutor(TEXT, UUID, UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.can_use_tutor(TEXT, UUID, UUID) TO authenticated;

COMMENT ON FUNCTION public.can_use_tutor(TEXT, UUID, UUID) IS
  'R-1 (é11) — la porte du tuteur. Refuse pendant une épreuve VIVANTE (donjon actif il y a moins de 30 min, duel avant son échéance, dernière séance de l''exercice ouverte depuis moins de 4 h) et avant toute réponse soumise. Une épreuve abandonnée n''est pas une épreuve en cours : aucune des trois lignes ne se referme toute seule (2026-08-27).';
