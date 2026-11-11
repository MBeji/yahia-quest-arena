-- Le QUATRIÈME lecteur du quiz de chapitre — la porte, celle qui décide vraiment.
--
-- LE DÉFAUT (issue #1005)
-- ---------------------------------------------------------------------------
-- 20260905130000 s'intitulait « une définition, QUATRE lecteurs » et n'en a réémis
-- que trois : `student_parcours_progress`, `student_chapter_gaps` et
-- `admin_engagement_overview`. Le quatrième — `start_exercise_session`, la seule
-- façon d'ouvrir une quête depuis GAP-021 — choisissait encore « le » quiz du
-- chapitre par un `LIMIT 1` SANS `ORDER BY`, puis exigeait une réussite sur CE
-- quiz-là. Le constat avait été laissé par écrit dans l'en-tête de 20260905150000,
-- hors du sujet de ce lot-là.
--
-- ⚠️ ET C'EST PIRE DEPUIS QUE LES TROIS AUTRES SONT CORRIGÉS. Avant, les quatre
-- tiraient arbitrairement : ils pouvaient diverger, sans qu'une surface contredise
-- systématiquement une autre. Maintenant les trois lecteurs acceptent n'importe
-- quel quiz réussi et la porte en exige un seul, tiré au hasard. Sur un chapitre à
-- DEUX quiz, l'élève qui a passé le second lit « chapitre débloqué » sur son hub,
-- « chapitre compté » sur /parcours, « aucune lacune » chez son parent — et reçoit
-- `QUIZ_LOCKED` au clic. Être bloqué est mauvais ; être bloqué APRÈS avoir été
-- invité à entrer est la forme la plus coûteuse du même défaut.
--
-- Rien n'interdit deux quiz dans un chapitre : ni contrainte de base, ni gate de
-- contenu. Le défaut est donc LATENT tant qu'aucun chapitre n'en porte deux — et
-- invisible le jour où l'un en portera, puisqu'un `LIMIT 1` sans ordre rend une
-- ligne parfaitement VALIDE, simplement arbitraire.
--
-- CE QUE CETTE MIGRATION CHANGE
-- ---------------------------------------------------------------------------
-- La porte 2 appelle `chapter_quiz_cleared(élève, chapitre)` — la définition déjà
-- posée par 20260905130000, seuils inchangés (>= 80 % ET >= 4 s/question). Le
-- tirage disparaît : il n'a pas lieu d'être, c'est le client qui avait raison.
--
-- ⚠️ CHANGEMENT DE RÉSULTAT, STRICTEMENT DANS UN SENS. La nouvelle condition est
-- plus faible que l'ancienne : un chapitre peut s'ouvrir là où il ne s'ouvrait
-- pas, et AUCUN élève ne peut être bloqué là où il passait. Le garde `v_grade IS
-- NOT NULL` est conservé exprès pour que ce soit vrai même sur une ligne
-- dénormalisée incohérente (voir le commentaire au point 2).
--
-- Les deux variables du tirage (`v_quiz_id`, `v_passed`) ne servaient qu'à lui :
-- elles sortent de la déclaration avec le bloc.
--
-- RÉÉMISE PAR SUBSTITUTION depuis sa révision vivante (20260905150000) — corps
-- identique ligne pour ligne hors les trois ancres, chacune vérifiée présente UNE
-- seule fois à la génération. Recopier une révision plus ancienne effacerait le
-- contournement du compte de test (`v_unrestricted`), livré la veille.
--
-- Le pgTAP 96 gagne le décor qui manquait : la porte confrontée aux trois lecteurs
-- sur le chapitre à DEUX quiz, le seul où la panne se voit.

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
