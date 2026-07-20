-- Knowledge graph — étude 07 lot 2 (FableEtudes/07-knowledge-graph-competences #lot-2).
--
-- Per-student mastery on the competency graph seeded by lot 1
-- (`20260712130000_competency_graph_schema.sql`).
--
--   * user_competency_mastery — the (élève, compétence) aggregate, maintained
--     AT WRITE by a lightweight trigger on `question_attempts` (décision D-3,
--     the same posture as `user_misconceptions` in étude 04 A0). Rejected:
--     nightly batch recompute (UX latency), on-the-fly computation (scan).
--
--   * The update rule is an EXPLAINABLE EWMA (BKT-allégé — R-4):
--         m ← m + α·(résultat − m)
--     with résultat = 100 (correct) or 0 (wrong), m initialised at 50 on first
--     contact, and α driven by the question's difficulty tier:
--         d1 → 0.15 · d2 → 0.20 · d3 → 0.25 · d4 → 0.30
--     A harder item moves the estimate more. Décision D-4 makes this function
--     the ONLY thing IRT/BKT would later replace — never the schema.
--
--   * Forgetting is applied AT READ, not by a job (R-4): −1 pt per week of
--     inactivity on that competency, floored at 30. Stored mastery is therefore
--     the raw evidence; `competency_mastery_with_decay()` is the lens. Lot 4's
--     RPCs (get_my_competency_map & co) read through it.
--
-- Constants live in the two helper functions below — R-4 "constantes
-- centralisées": change the curve there, never inline at a call site.
--
-- Reward scales are untouched (stop-point du lot 2).
-- CLAUDE.md gotcha: new tables ship their own explicit GRANTs.

-- ---------------------------------------------------------------------------
-- 1. Centralised constants: the α ladder (R-4).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.competency_mastery_alpha(p_difficulty INT)
RETURNS NUMERIC
LANGUAGE sql
IMMUTABLE
AS $$
  -- d1 0.15 · d2 0.20 · d3 0.25 · d4 0.30 (R-4). Unknown/NULL tiers fall back
  -- to the d2 mid-rate so a mis-tagged exercise still learns, just neutrally.
  SELECT (CASE COALESCE(p_difficulty, 2)
    WHEN 1 THEN 0.15
    WHEN 2 THEN 0.20
    WHEN 3 THEN 0.25
    WHEN 4 THEN 0.30
    ELSE 0.20
  END)::NUMERIC;
$$;

COMMENT ON FUNCTION public.competency_mastery_alpha(INT) IS
  'Étude 07 R-4: EWMA learning rate per difficulty tier (d1 .15 → d4 .30).';

-- ---------------------------------------------------------------------------
-- 2. Centralised constants: the forgetting lens (R-4), applied at READ.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.competency_mastery_with_decay(
  p_mastery NUMERIC,
  p_last_attempt_at TIMESTAMPTZ
)
RETURNS NUMERIC
LANGUAGE sql
STABLE
AS $$
  -- −1 pt per week of inactivity, floored at 30 (R-4). The floor is
  -- LEAST(p_mastery, 30), not a flat 30: decay may never RAISE a mastery that
  -- is already below the floor (a genuinely weak 12 stays 12, it does not
  -- drift up to 30). Continuous (fractional weeks) so the curve has no steps.
  SELECT ROUND(
    GREATEST(
      p_mastery - (EXTRACT(EPOCH FROM (now() - p_last_attempt_at)) / 604800.0),
      LEAST(p_mastery, 30)
    ),
    2
  );
$$;

COMMENT ON FUNCTION public.competency_mastery_with_decay(NUMERIC, TIMESTAMPTZ) IS
  'Étude 07 R-4: read-side forgetting — −1 pt/week idle, floored at 30 (never raises).';

-- ---------------------------------------------------------------------------
-- 3. The aggregate.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.user_competency_mastery (
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  competency_id UUID NOT NULL REFERENCES public.competencies(id) ON DELETE CASCADE,
  mastery NUMERIC NOT NULL DEFAULT 50 CHECK (mastery BETWEEN 0 AND 100),
  attempts INT NOT NULL DEFAULT 0,
  last_attempt_at TIMESTAMPTZ NOT NULL,
  PRIMARY KEY (user_id, competency_id)
);

-- Serves "my weakest competencies first" (US-1, and étude 08's parent report).
CREATE INDEX IF NOT EXISTS idx_user_competency_mastery_user_weakest
  ON public.user_competency_mastery (user_id, mastery ASC);

ALTER TABLE public.user_competency_mastery ENABLE ROW LEVEL SECURITY;

-- Read your own profile; admins read all; an ACTIVE linked parent reads their
-- child's (patron parcours_entitlements). R-6: never another student's data.
-- auth.uid() is wrapped in a scalar subquery so the planner hoists it once
-- (perf posture of 20260630150000 for per-user hot tables).
CREATE POLICY "Mastery readable by owner, admin or linked parent"
  ON public.user_competency_mastery
  FOR SELECT
  USING (
    user_id = (SELECT auth.uid())
    OR public.is_admin()
    OR EXISTS (
      SELECT 1 FROM public.parent_student_links l
      WHERE l.parent_user_id = (SELECT auth.uid())
        AND l.student_user_id = user_competency_mastery.user_id
        AND l.is_active
    )
  );

-- No write policies on purpose: the only writer is the trigger below, which
-- runs inside the SECURITY DEFINER submission RPCs' transaction as the table
-- owner (and therefore bypasses RLS). Client roles get SELECT only.
REVOKE ALL ON public.user_competency_mastery FROM anon, authenticated;
GRANT SELECT ON public.user_competency_mastery TO authenticated;
GRANT ALL ON public.user_competency_mastery TO service_role;

-- ---------------------------------------------------------------------------
-- 4. The write-side aggregate maintainer (D-3).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.record_competency_mastery()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public
AS $$
DECLARE
  v_alpha NUMERIC;
  v_result NUMERIC;
BEGIN
  -- α comes from the difficulty tier of the exercise the question belongs to
  -- (`questions` carries no difficulty column — the authored per-question
  -- difficulty only orders items at compile time).
  SELECT public.competency_mastery_alpha(e.difficulty)
    INTO v_alpha
    FROM public.questions q
    JOIN public.exercises e ON e.id = q.exercise_id
   WHERE q.id = NEW.question_id;

  IF v_alpha IS NULL THEN
    RETURN NULL;  -- question detached from any exercise: nothing to learn from
  END IF;

  v_result := CASE WHEN NEW.is_correct THEN 100 ELSE 0 END;

  -- One upsert per competency the question evaluates (1–3 — R-2). A question
  -- with no mapping yields zero rows: untagged content stays strictly neutral
  -- (R-2), it never creates a mastery row.
  INSERT INTO public.user_competency_mastery AS m
    (user_id, competency_id, mastery, attempts, last_attempt_at)
  SELECT
    NEW.user_id,
    qc.competency_id,
    -- First contact: the 50 baseline is applied here as the EWMA's starting
    -- point, so the very first answer already moves off 50 (R-4).
    ROUND(50 + v_alpha * (v_result - 50), 2),
    1,
    NEW.created_at
  FROM public.question_competencies qc
  WHERE qc.question_id = NEW.question_id
  ON CONFLICT (user_id, competency_id) DO UPDATE SET
    mastery = ROUND(m.mastery + v_alpha * (v_result - m.mastery), 2),
    attempts = m.attempts + 1,
    -- Monotonic: a back-dated replay must not rewind the idle clock.
    last_attempt_at = GREATEST(m.last_attempt_at, EXCLUDED.last_attempt_at);

  RETURN NULL;
END;
$$;

-- Helpers and the maintainer are server-side only. Lot 4's client-facing RPCs
-- are SECURITY DEFINER and call them as owner, so no client EXECUTE is needed.
REVOKE EXECUTE ON FUNCTION public.record_competency_mastery() FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.competency_mastery_alpha(INT) FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.competency_mastery_with_decay(NUMERIC, TIMESTAMPTZ) FROM PUBLIC, anon, authenticated;

-- Fires on EVERY attempt (unlike étude 04's misconception trigger, which is
-- gated on a non-null tag): a CORRECT answer is exactly the evidence that
-- raises mastery, so it must not be filtered out.
DROP TRIGGER IF EXISTS trg_question_attempts_competency_mastery ON public.question_attempts;
CREATE TRIGGER trg_question_attempts_competency_mastery
  AFTER INSERT ON public.question_attempts
  FOR EACH ROW
  EXECUTE FUNCTION public.record_competency_mastery();
