-- =========================================================
-- resolve_exercise_access — the single server-authoritative access gate
-- ---------------------------------------------------------
-- MUST BE APPLIED BEFORE the code that calls it deploys (CLAUDE.md §7). Additive
-- and idempotent. Still behaviour-neutral on its own: the app does not call this
-- until the gate-switch code ships (next increment). Depends on the parcours +
-- entitlements objects from 20260608120000.
--
-- Given an exercise, resolves its parcours via subject -> (theme_id, grade_id)
-- and decides access in ONE place, replacing the old global "difficulty >= 3"
-- paywall and the per-subject is_premium gate:
--
--   free parcours / unmapped subject -> allowed
--   premium parcours                 -> allowed when the caller (or an active
--                                       linked parent) holds a live entitlement,
--                                       OR the exercise is in the FREE PREVIEW.
--   FREE PREVIEW (preview_policy='difficulty_1') = the chapter comprehension
--   quiz (mode='quiz') + every difficulty-1 mission, so a prospect can taste a
--   chapter end-to-end (read the lesson, pass the quiz, do the easy missions)
--   before paying. difficulty >= 2 practice/boss stay gated.
--
-- The comprehension-quiz gate (school subjects) is a SEPARATE concern, still
-- enforced in startExerciseSession — this resolver only governs the paywall.
-- =========================================================

-- Speeds up the subject -> parcours resolution join.
CREATE INDEX IF NOT EXISTS idx_subjects_theme_grade ON public.subjects (theme_id, grade_id);

CREATE OR REPLACE FUNCTION public.resolve_exercise_access(p_exercise UUID)
RETURNS TABLE (
  parcours_id     TEXT,
  parcours_name   TEXT,
  is_premium      BOOLEAN,
  has_entitlement BOOLEAN,
  is_preview      BOOLEAN,
  allowed         BOOLEAN,
  reason          TEXT
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user           UUID := auth.uid();
  v_mode           TEXT;
  v_difficulty     INT;
  v_parcours_id    TEXT;
  v_parcours_name  TEXT;
  v_is_premium     BOOLEAN;
  v_preview_policy TEXT;
  v_status         TEXT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  -- Exercise + its resolved parcours. LEFT JOIN: an unmapped subject leaves the
  -- parcours columns NULL (v_parcours_id IS NULL detects "no parcours"). Each
  -- target is a scalar — plpgsql forbids mixing scalars with a composite/row
  -- variable in a single SELECT ... INTO list.
  SELECT e.mode, e.difficulty,
         par.id, par.name_fr, par.is_premium, par.preview_policy, par.status
    INTO v_mode, v_difficulty,
         v_parcours_id, v_parcours_name, v_is_premium, v_preview_policy, v_status
  FROM public.exercises e
  JOIN public.subjects s ON s.id = e.subject_id
  LEFT JOIN public.parcours par
    ON par.theme_id = s.theme_id
   AND par.grade_id IS NOT DISTINCT FROM s.grade_id
  WHERE e.id = p_exercise;

  -- Unmapped subject or a free parcours -> always allowed.
  IF v_parcours_id IS NULL OR v_is_premium = false THEN
    parcours_id     := v_parcours_id;
    parcours_name   := v_parcours_name;
    is_premium      := COALESCE(v_is_premium, false);
    has_entitlement := true;
    is_preview      := false;
    allowed         := true;
    reason          := '';
    RETURN NEXT;
    RETURN;
  END IF;

  -- Premium parcours.
  parcours_id   := v_parcours_id;
  parcours_name := v_parcours_name;
  is_premium    := true;

  has_entitlement := public.has_parcours_entitlement(v_user, v_parcours_id);

  is_preview := CASE v_preview_policy
    WHEN 'full'         THEN true
    WHEN 'difficulty_1' THEN (v_mode = 'quiz' OR COALESCE(v_difficulty, 0) <= 1)
    ELSE false  -- 'none'
  END;

  allowed := has_entitlement OR is_preview;

  IF allowed THEN
    reason := '';
  ELSIF v_status = 'coming_soon' THEN
    reason := 'PARCOURS_COMING_SOON';
  ELSE
    reason := 'PARCOURS_LOCKED';
  END IF;

  RETURN NEXT;
END;
$$;

REVOKE ALL ON FUNCTION public.resolve_exercise_access(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.resolve_exercise_access(UUID) TO authenticated;
