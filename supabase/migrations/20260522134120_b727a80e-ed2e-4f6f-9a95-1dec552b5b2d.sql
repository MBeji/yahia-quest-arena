
-- =========================================================
-- YahiaAcademy v1 schema
-- =========================================================

-- 1. Profiles (linked to auth.users)
CREATE TABLE public.profiles (
  id UUID NOT NULL PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT NOT NULL DEFAULT 'Aspirant',
  hero_class TEXT NOT NULL DEFAULT 'Novice',
  avatar_tier INT NOT NULL DEFAULT 1,
  xp INT NOT NULL DEFAULT 0,
  level INT NOT NULL DEFAULT 1,
  current_streak INT NOT NULL DEFAULT 0,
  longest_streak INT NOT NULL DEFAULT 0,
  last_active_date DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Profiles are viewable by everyone"
  ON public.profiles FOR SELECT USING (true);

CREATE POLICY "Users can insert own profile"
  ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- 2. Subjects
CREATE TABLE public.subjects (
  id TEXT PRIMARY KEY,
  name_fr TEXT NOT NULL,
  description TEXT,
  attribute TEXT NOT NULL,           -- Force / Esprit / Observation / Agilite / Sagesse
  color_token TEXT NOT NULL,         -- maps to CSS var like 'subject-math'
  icon TEXT NOT NULL,                -- lucide icon name
  display_order INT NOT NULL DEFAULT 0
);

ALTER TABLE public.subjects ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Subjects readable by all" ON public.subjects FOR SELECT USING (true);

-- 3. Chapters
CREATE TABLE public.chapters (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id TEXT NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  display_order INT NOT NULL DEFAULT 0
);

ALTER TABLE public.chapters ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Chapters readable by all" ON public.chapters FOR SELECT USING (true);

-- 4. Exercises (quests)
CREATE TABLE public.exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  chapter_id UUID NOT NULL REFERENCES public.chapters(id) ON DELETE CASCADE,
  subject_id TEXT NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  difficulty INT NOT NULL DEFAULT 1,   -- 1=easy 2=med 3=hard
  xp_reward INT NOT NULL DEFAULT 50,
  display_order INT NOT NULL DEFAULT 0
);

ALTER TABLE public.exercises ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Exercises readable by all" ON public.exercises FOR SELECT USING (true);

-- 5. Questions (QCM)
CREATE TABLE public.questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  exercise_id UUID NOT NULL REFERENCES public.exercises(id) ON DELETE CASCADE,
  prompt TEXT NOT NULL,
  options JSONB NOT NULL,         -- [{id:"a",text:"..."},...]
  correct_option TEXT NOT NULL,
  explanation TEXT,
  display_order INT NOT NULL DEFAULT 0
);

ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Questions readable by all" ON public.questions FOR SELECT USING (true);

-- 6. Attempts
CREATE TABLE public.attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  exercise_id UUID NOT NULL REFERENCES public.exercises(id) ON DELETE CASCADE,
  subject_id TEXT NOT NULL REFERENCES public.subjects(id),
  correct_count INT NOT NULL,
  total_count INT NOT NULL,
  score_pct NUMERIC NOT NULL,
  duration_seconds INT NOT NULL,
  xp_earned INT NOT NULL,
  completed_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.attempts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users select own attempts" ON public.attempts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users insert own attempts" ON public.attempts FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE INDEX idx_attempts_user ON public.attempts(user_id);
CREATE INDEX idx_attempts_subject ON public.attempts(user_id, subject_id);

-- 7. Trigger: auto-create profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, display_name)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'display_name', split_part(NEW.email, '@', 1), 'Aspirant')
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 8. Award XP + streak update function
CREATE OR REPLACE FUNCTION public.award_xp(p_user UUID, p_xp INT)
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  rec public.profiles;
  today DATE := CURRENT_DATE;
  new_streak INT;
  new_level INT;
  new_class TEXT;
  new_tier INT;
BEGIN
  SELECT * INTO rec FROM public.profiles WHERE id = p_user FOR UPDATE;
  IF NOT FOUND THEN RAISE EXCEPTION 'Profile not found'; END IF;

  -- Streak logic
  IF rec.last_active_date IS NULL THEN
    new_streak := 1;
  ELSIF rec.last_active_date = today THEN
    new_streak := rec.current_streak;
  ELSIF rec.last_active_date = today - INTERVAL '1 day' THEN
    new_streak := rec.current_streak + 1;
  ELSE
    new_streak := 1;
  END IF;

  -- Level curve: each level = 200 xp
  new_level := GREATEST(1, ((rec.xp + p_xp) / 200) + 1);

  -- Hero class progression
  new_class := CASE
    WHEN new_level >= 50 THEN 'S-Rank Legend'
    WHEN new_level >= 31 THEN 'Elite du Concours'
    WHEN new_level >= 21 THEN 'Maitre des Langues'
    WHEN new_level >= 11 THEN 'Guerrier des Equations'
    WHEN new_level >= 6  THEN 'Aspirant Academicien'
    ELSE 'Candidat Civil'
  END;

  new_tier := LEAST(6, GREATEST(1, (new_level / 8) + 1));

  UPDATE public.profiles SET
    xp = xp + p_xp,
    level = new_level,
    hero_class = new_class,
    avatar_tier = new_tier,
    current_streak = new_streak,
    longest_streak = GREATEST(longest_streak, new_streak),
    last_active_date = today
  WHERE id = p_user
  RETURNING * INTO rec;

  RETURN rec;
END;
$$;
