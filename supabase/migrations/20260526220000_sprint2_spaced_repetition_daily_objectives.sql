-- =========================================================
-- Sprint 2: Spaced Repetition, Daily Objectives, Weekly Quests
-- =========================================================

-- 1. SPACED REPETITION SCHEDULE
-- Tracks when exercises should be retried based on 1d, 3d, 7d intervals
CREATE TABLE IF NOT EXISTS public.spaced_repetition_schedule (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  exercise_id UUID NOT NULL REFERENCES public.exercises(id) ON DELETE CASCADE,
  subject_id UUID NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
  failed_attempt_id UUID REFERENCES public.attempts(id) ON DELETE SET NULL,
  
  -- Retry levels: 0 = initial, 1 = 1 day, 2 = 3 days, 3 = 7 days
  retry_level INT NOT NULL DEFAULT 0,
  
  -- When this retry should be available
  scheduled_for TIMESTAMPTZ NOT NULL,
  
  -- When user completed this retry (NULL if not done yet)
  completed_at TIMESTAMPTZ,
  
  -- Score on the retry attempt
  retry_score_pct INT,
  
  -- Status: pending, completed, expired
  status TEXT NOT NULL DEFAULT 'pending',
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.spaced_repetition_schedule ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own spaced repetition schedule"
  ON public.spaced_repetition_schedule
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE INDEX idx_spaced_rep_user_exercise ON public.spaced_repetition_schedule(user_id, exercise_id);
CREATE INDEX idx_spaced_rep_scheduled_for ON public.spaced_repetition_schedule(user_id, scheduled_for);

-- 2. DAILY OBJECTIVES
-- Track student daily goals and progress
CREATE TABLE IF NOT EXISTS public.daily_objectives (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- Daily objective type: '10_min', '15_min', '3_exercises'
  objective_type TEXT NOT NULL,
  
  -- Target: duration in minutes or exercise count
  target_value INT NOT NULL,
  
  -- Current progress
  current_value INT NOT NULL DEFAULT 0,
  
  -- When this objective started (beginning of day, UTC)
  objective_date DATE NOT NULL,
  
  -- XP reward for completing the objective
  xp_reward INT NOT NULL DEFAULT 50,
  
  -- Coin reward
  coin_reward INT NOT NULL DEFAULT 10,
  
  -- Status: active, completed, skipped
  status TEXT NOT NULL DEFAULT 'active',
  
  -- When completed
  completed_at TIMESTAMPTZ,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.daily_objectives ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own daily objectives"
  ON public.daily_objectives
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE INDEX idx_daily_objectives_user_date ON public.daily_objectives(user_id, objective_date);

-- 3. WEEKLY QUESTS
-- Track weekly challenges (complete chapter, beat bosses, maintain streak)
CREATE TABLE IF NOT EXISTS public.weekly_quests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- Quest type: 'complete_chapter', 'beat_2_bosses', 'maintain_streak_5'
  quest_type TEXT NOT NULL,
  
  -- Associated subject (for chapter completion quests)
  subject_id UUID REFERENCES public.subjects(id) ON DELETE SET NULL,
  
  -- Target value (e.g., 2 for beat_2_bosses)
  target_value INT NOT NULL,
  
  -- Current progress
  current_value INT NOT NULL DEFAULT 0,
  
  -- Week start (Monday)
  week_start_date DATE NOT NULL,
  
  -- XP reward
  xp_reward INT NOT NULL DEFAULT 100,
  
  -- Coin reward
  coin_reward INT NOT NULL DEFAULT 25,
  
  -- Status: active, completed, failed
  status TEXT NOT NULL DEFAULT 'active',
  
  -- When completed
  completed_at TIMESTAMPTZ,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.weekly_quests ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own weekly quests"
  ON public.weekly_quests
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE INDEX idx_weekly_quests_user_week ON public.weekly_quests(user_id, week_start_date);

-- 4. DIFFICULTY ADAPTATION METRICS
-- Track per-subject performance to adapt difficulty
CREATE TABLE IF NOT EXISTS public.difficulty_adaptation (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  subject_id UUID NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
  
  -- Average score for this subject (0-100)
  avg_score INT NOT NULL DEFAULT 0,
  
  -- Difficulty level: 1 (easy), 2 (medium), 3 (hard), 4 (extreme)
  current_difficulty_level INT NOT NULL DEFAULT 1,
  
  -- Exercises attempted in subject
  total_attempts INT NOT NULL DEFAULT 0,
  
  -- Recent performance (last 10 attempts) for trend
  recent_avg_score INT NOT NULL DEFAULT 0,
  
  -- When to increase difficulty (if avg > 75%)
  -- When to decrease difficulty (if avg < 40%)
  last_adjusted_at TIMESTAMPTZ,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.difficulty_adaptation ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own difficulty adaptation"
  ON public.difficulty_adaptation
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE INDEX idx_difficulty_adaptation_user_subject ON public.difficulty_adaptation(user_id, subject_id);

-- 5. Add fields to profiles for Sprint 2
ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS total_time_minutes INT NOT NULL DEFAULT 0,
ADD COLUMN IF NOT EXISTS weekly_objectives_completed INT NOT NULL DEFAULT 0,
ADD COLUMN IF NOT EXISTS bosses_defeated INT NOT NULL DEFAULT 0;

-- Create view for daily objective summary
CREATE OR REPLACE VIEW daily_objective_summary AS
SELECT 
  user_id,
  objective_date,
  COUNT(*) as total_objectives,
  SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed_objectives,
  SUM(CASE WHEN status = 'completed' THEN xp_reward ELSE 0 END) as xp_earned
FROM public.daily_objectives
GROUP BY user_id, objective_date;

-- Create view for weekly quest summary
CREATE OR REPLACE VIEW weekly_quest_summary AS
SELECT 
  user_id,
  week_start_date,
  COUNT(*) as total_quests,
  SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed_quests,
  SUM(CASE WHEN status = 'completed' THEN xp_reward ELSE 0 END) as xp_earned
FROM public.weekly_quests
GROUP BY user_id, week_start_date;
