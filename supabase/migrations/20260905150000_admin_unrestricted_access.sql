-- LE COMPTE ADMIN EST UN COMPTE DE TEST — aucune porte de progression ne s'applique à lui.
--
-- LE BESOIN (2026-09-05, demande du propriétaire)
-- ---------------------------------------------------------------------------
-- Pour tester le contenu « en humain », le compte admin doit pouvoir ouvrir
-- N'IMPORTE QUELLE mission et n'importe quelle question, dans n'importe quel
-- ordre, SANS passer les quiz de compréhension. Ce n'est pas un compte d'usage :
-- il ne suit pas le chemin de l'élève, il le vérifie.
--
-- Or `start_exercise_session` — la seule façon d'ouvrir une quête depuis GAP-021 —
-- pose trois portes de PROGRESSION à tout compte connecté :
--   1) l'accès au parcours (`resolve_exercise_access` : premium dormant, « bientôt ») ;
--   2) le quiz de compréhension du chapitre (matières scolaires) ;
--   3) le Rappel, ouvert seulement après un classique à 100 % (étude 17, R-3).
-- Le compte admin les franchit toutes trois. Il garde en revanche les règles de
-- CONTENU, qui ne sont pas des restrictions mais des définitions : une variante
-- inconnue reste `INVALID_VARIANT`, et le Rappel d'un quiz, d'une mission
-- familiale ou d'une mission à moins de 3 questions éligibles reste
-- `RECALL_NOT_ELIGIBLE` — le lecteur n'aurait rien à jouer.
--
-- POURQUOI ICI, ET UNE SEULE FOIS. `public.is_admin()` est déjà LA définition du
-- rôle (RLS des consoles, RPC `admin_*`). Les server fns TypeScript (`getSubject`,
-- `getChapterLesson`, `getExercise`) l'appellent pour AFFICHER le hub et le
-- lecteur ouverts ; c'est cette RPC qui DÉCIDE. Un compte ordinaire ne voit
-- strictement rien changer : chaque `RAISE` ne gagne qu'un `AND NOT v_unrestricted`.
--
-- RÉÉMISE PAR SUBSTITUTION depuis sa révision vivante (20260714130000) — corps
-- identique ligne pour ligne hors la déclaration et les trois ancres. C'est la
-- règle de docs/agents/pieges-du-code.md : recopier une révision plus ancienne
-- effacerait la branche Rappel. Constat au passage, laissé tel quel parce que
-- hors du sujet de ce lot : la porte 2 choisit encore « le » quiz du chapitre par
-- un `LIMIT 1` sans ordre, le tirage que 20260905130000 a retiré des trois
-- lecteurs de progression (`chapter_quiz_cleared`).
--
-- Le pgTAP 97 tient le décor : l'élève témoin reste devant `QUIZ_LOCKED`, l'admin
-- ouvre la mission sans quiz, la mission premium sans droit, le Rappel sans 100 %.

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

      IF NOT v_passed AND NOT v_unrestricted THEN
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
