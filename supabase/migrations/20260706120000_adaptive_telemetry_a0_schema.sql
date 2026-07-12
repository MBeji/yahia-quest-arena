-- Moteur adaptatif — phase A0 lot A0.1 (FableEtudes/04-moteur-adaptatif #lot-A0.1).
--
-- Telemetry schema ONLY (additive — no RPC touches it yet; capture is lot A0.2):
--
--   * questions.distractor_tags JSONB — per-option misconception tags
--     ({"b": "math.frac.add-denominators", …}), SERVER-ONLY (décision D-1):
--     tagging `options` (sent to the client) would leak the key — the correct
--     option would be the only untagged one. Same column-grant posture as
--     correct_option/answer_key (20260610170000): the SELECT whitelist on
--     questions simply never includes it.
--
--   * question_attempts — append-only per-question telemetry (décision D-2):
--     (user, question, chapter dénormalisé, session, choice, correct, tag
--     résolu à l'insert depuis distractor_tags->choice, source). R-1: never
--     the key, never another user's data. INSERTs happen exclusively inside
--     the SECURITY DEFINER submission RPCs (lot A0.2) — client roles get
--     SELECT only (own rows via RLS), zero write grants.
--     `session_id` is the "contexte session" required by R-1 and feeds the
--     ≥2-sessions threshold of R-2: exercise_sessions.id for
--     exercise/quiz sources, dungeon_runs.id for dungeon (polymorphic — no FK).
--     Rétention : purge > 12 mois par le cron (lot A0.2).
--
--   * user_misconceptions — the per-(user, tag) aggregate, maintained by a
--     lightweight AFTER INSERT trigger so the R-2 threshold check (lot A2.1)
--     never scans the raw telemetry. `sessions_seen` increments only when the
--     tag is first seen in a given session (indexed lookup).
--
-- CLAUDE.md gotcha: new tables ship their own explicit GRANTs.

-- ---------------------------------------------------------------------------
-- 1. distractor_tags — server-only column (D-1, R-1).
-- ---------------------------------------------------------------------------
ALTER TABLE public.questions
  ADD COLUMN IF NOT EXISTS distractor_tags JSONB;

-- No GRANT: the column-level SELECT whitelist on questions (20260610170000,
-- 20260705130000) is untouched, so the tags are invisible to anon/authenticated.
-- Belt-and-braces in case a future migration ever re-grants table-level SELECT:
REVOKE SELECT (distractor_tags) ON public.questions FROM anon, authenticated;

-- ---------------------------------------------------------------------------
-- 2. question_attempts — append-only telemetry.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.question_attempts (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  question_id UUID NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
  chapter_id UUID NOT NULL,                -- dénormalisé pour l'agrégation
  session_id UUID NOT NULL,                -- exercise_sessions.id | dungeon_runs.id (R-1/R-2)
  choice TEXT NOT NULL,
  is_correct BOOLEAN NOT NULL,
  misconception_tag TEXT,                  -- résolu à l'insert depuis distractor_tags->choice
  source TEXT NOT NULL CHECK (source IN ('exercise', 'quiz', 'dungeon', 'exam')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_question_attempts_user_recent
  ON public.question_attempts (user_id, created_at DESC);
-- Serves both the tag aggregation and the trigger's "already seen in this
-- session?" lookup (leading (user_id, misconception_tag) prefix per the study).
CREATE INDEX IF NOT EXISTS idx_question_attempts_user_tag
  ON public.question_attempts (user_id, misconception_tag, session_id)
  WHERE misconception_tag IS NOT NULL;

ALTER TABLE public.question_attempts ENABLE ROW LEVEL SECURITY;

-- Owner (and admin triage) read their own telemetry; NO write policies — the
-- only writers are the SECURITY DEFINER RPCs (table owner bypasses RLS).
CREATE POLICY "Users read own question attempts" ON public.question_attempts
  FOR SELECT USING (user_id = (SELECT auth.uid()) OR public.is_admin());

-- End-state grants on every stack (cloud default privileges may differ from
-- the fresh local stack): SELECT only for the client; writes stay RPC-only.
REVOKE ALL ON public.question_attempts FROM anon, authenticated;
GRANT SELECT ON public.question_attempts TO authenticated;
GRANT ALL ON public.question_attempts TO service_role;

-- ---------------------------------------------------------------------------
-- 3. user_misconceptions — trigger-maintained aggregate.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.user_misconceptions (
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  tag TEXT NOT NULL,
  occurrences INT NOT NULL DEFAULT 0,
  last_seen_at TIMESTAMPTZ NOT NULL,
  sessions_seen INT NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id, tag)
);

ALTER TABLE public.user_misconceptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users read own misconceptions" ON public.user_misconceptions
  FOR SELECT USING (user_id = (SELECT auth.uid()) OR public.is_admin());

REVOKE ALL ON public.user_misconceptions FROM anon, authenticated;
GRANT SELECT ON public.user_misconceptions TO authenticated;
GRANT ALL ON public.user_misconceptions TO service_role;

-- The aggregate writer. Runs inside the telemetry INSERT's transaction with
-- the inserter's privileges — i.e. the SECURITY DEFINER RPCs' owner, which
-- bypasses RLS on the aggregate; client roles cannot reach it directly.
CREATE OR REPLACE FUNCTION public.record_user_misconception()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public
AS $$
DECLARE
  v_new_session boolean;
BEGIN
  -- First time this (user, tag) shows up in this session? (indexed lookup)
  -- `id < NEW.id`, not `id <> NEW.id`: an AFTER ROW trigger on a multi-row
  -- INSERT (the RPCs insert a session's answers in one statement) sees ALL the
  -- statement's rows, so `<>` would make same-statement duplicates cancel each
  -- other out; identity ids are monotonic, so "strictly earlier" is exact.
  SELECT NOT EXISTS (
    SELECT 1
    FROM public.question_attempts qa
    WHERE qa.user_id = NEW.user_id
      AND qa.misconception_tag = NEW.misconception_tag
      AND qa.session_id = NEW.session_id
      AND qa.id < NEW.id
  ) INTO v_new_session;

  INSERT INTO public.user_misconceptions AS um
    (user_id, tag, occurrences, last_seen_at, sessions_seen)
  VALUES
    (NEW.user_id, NEW.misconception_tag, 1, NEW.created_at,
     CASE WHEN v_new_session THEN 1 ELSE 0 END)
  ON CONFLICT (user_id, tag) DO UPDATE SET
    occurrences   = um.occurrences + 1,
    last_seen_at  = GREATEST(um.last_seen_at, EXCLUDED.last_seen_at),
    sessions_seen = um.sessions_seen + (CASE WHEN v_new_session THEN 1 ELSE 0 END);

  RETURN NULL;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.record_user_misconception() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS trg_question_attempts_misconception ON public.question_attempts;
CREATE TRIGGER trg_question_attempts_misconception
  AFTER INSERT ON public.question_attempts
  FOR EACH ROW
  WHEN (NEW.misconception_tag IS NOT NULL)
  EXECUTE FUNCTION public.record_user_misconception();
