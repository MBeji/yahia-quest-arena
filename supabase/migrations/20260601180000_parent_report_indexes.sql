-- Additional indexes for parent reporting query paths.

CREATE INDEX IF NOT EXISTS idx_attempts_user_completed_at
  ON public.attempts(user_id, completed_at DESC);

CREATE INDEX IF NOT EXISTS idx_attempts_user_subject_completed_at
  ON public.attempts(user_id, subject_id, completed_at DESC);
