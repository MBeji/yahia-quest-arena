-- Secure quest flow by tracking session start time on the server.

CREATE TABLE IF NOT EXISTS public.exercise_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  exercise_id UUID NOT NULL REFERENCES public.exercises(id) ON DELETE CASCADE,
  started_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.exercise_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users select own exercise sessions"
  ON public.exercise_sessions
  FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users insert own exercise sessions"
  ON public.exercise_sessions
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users update own exercise sessions"
  ON public.exercise_sessions
  FOR UPDATE
  USING (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS idx_exercise_sessions_user_exercise
  ON public.exercise_sessions(user_id, exercise_id, started_at DESC);