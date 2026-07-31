-- Étude 04 — amendement A1.2, lot A1.2a : la correction sait enfin NOMMER l'erreur.
-- Contrat : FableEtudes/04-moteur-adaptatif/ETUDE.md §9 (dépôt de contenu privé).
--
-- Depuis la phase A0 (2026-07-06), chaque soumission capte le distracteur choisi et
-- sa misconception. Ce signal alimente la télémétrie, `get_daily_plan` et la carte
-- de maîtrise — mais il n'est affiché NULLE PART dans la correction de fin de quête,
-- qui continue de ne dire que « la bonne réponse était B ». C'est la troisième des
-- « boucles collectées-jamais-surfacées » de l'étude 26, et ce lot la referme côté
-- serveur : `get_attempt_review` rend désormais, par question,
--
--   * `misconception_tag` — l'id de l'erreur correspondant à l'option CHOISIE, et
--   * `chapter_id`        — de quoi bâtir le lien « revoir le cours ».
--
-- D-A1.2-2 — on rend le tag de l'option choisie, JAMAIS la map. `distractor_tags`
-- ne porte d'entrée que pour les distracteurs : l'option correcte est la seule sans
-- tag (D-1 de la phase A0), donc exposer la map désignerait la bonne réponse par
-- élimination — une fuite de la clé aussi complète que de rendre `correct_option`
-- avant la soumission. Le tag n'est de plus rendu que sur une réponse FAUSSE
-- (R-A1.2-2 : une réussite ne se transforme pas en leçon), verdict lu de la même
-- couture de scoring que le reste de la ligne — un contenu qui taguerait par erreur
-- l'option correcte ne peut donc pas rouvrir la fuite par ce chemin.
--
-- L'appariement lui-même n'est pas réécrit : il passe par `resolve_misconception_tag`
-- (étude 20 lot 7), l'unique implémentation de la règle des trois variantes — option
-- choisie en QCM, texte apparié à un distracteur en Rappel, texte apparié à une erreur
-- attendue en `short_answer`. La correction dit donc exactement ce que la télémétrie a
-- enregistré, par construction et non par ressemblance.
--
-- D-A1.2-3 — la fonction rend un ID, jamais un libellé : la phrase montrée à l'élève
-- vient du registre `content/misconceptions.json`, embarqué au build. Une misconception
-- mal formulée se corrigera dans le registre, sans migration ni retouche de données.
--
-- D-A1.2-6 — ajouter des colonnes à un `RETURNS TABLE` impose DROP + CREATE ; c'est
-- fait dans la même transaction, et la fonction est recréée VERBATIM depuis
-- 20260714130000 hormis les lignes visées. La migration part avant le client qui lit
-- les nouvelles colonnes (DoD §7, additif d'abord) : le lot A1.2b (UI) suit.
--
-- Aucune porte ne bouge : owner-only, session complétée seulement, jamais pour un
-- quiz (anti-mémorisation, R-A1.2-5), Rappel toujours restreint aux questions
-- éligibles. Aucun barème, aucun compteur, aucun `consume_hint` (R-A1.2-4) — ce lot
-- est un affichage, comme A1.1 était un sélecteur.
--
-- ⚠️ Inerte par construction tant que le corpus n'est pas tagué (é07 lot 3 / C4 :
-- `math` et `math-6eme` le sont, le reste non). Une question non taguée rend NULL et
-- la ligne reste rendue telle quelle — R-A1.2-3, le comportement d'aujourd'hui est le
-- plancher. Inerte n'est pas faux.

DROP FUNCTION IF EXISTS public.get_attempt_review(uuid, jsonb);

CREATE FUNCTION public.get_attempt_review(p_session_id uuid, p_answers jsonb DEFAULT NULL)
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
    ORDER BY q.display_order;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.get_attempt_review(uuid, jsonb) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_attempt_review(uuid, jsonb) TO authenticated;
