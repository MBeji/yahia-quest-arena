-- Extend YahiaAcademy schema for parent/student relationships,
-- theory content, assignments, badges, and virtual economy.

-- -------------------------------------------------------------------
-- Profile enrichment
-- -------------------------------------------------------------------
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS role TEXT NOT NULL DEFAULT 'student',
  ADD COLUMN IF NOT EXISTS yahia_coins INT NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS avatar_slug TEXT;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'profiles_role_check'
  ) THEN
    ALTER TABLE public.profiles
      ADD CONSTRAINT profiles_role_check
      CHECK (role IN ('student', 'parent', 'admin'));
  END IF;
END
$$;

DROP POLICY IF EXISTS "Profiles are viewable by everyone" ON public.profiles;

-- -------------------------------------------------------------------
-- Parent / student links
-- -------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.parent_student_links (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  student_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  relation_label TEXT NOT NULL DEFAULT 'parent',
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT parent_student_links_unique UNIQUE (parent_user_id, student_user_id),
  CONSTRAINT parent_student_links_no_self CHECK (parent_user_id <> student_user_id)
);

ALTER TABLE public.parent_student_links ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Parents and students can view their links"
  ON public.parent_student_links
  FOR SELECT
  USING (auth.uid() = parent_user_id OR auth.uid() = student_user_id);

CREATE POLICY "Parents can create their own links"
  ON public.parent_student_links
  FOR INSERT
  WITH CHECK (auth.uid() = parent_user_id);

CREATE POLICY "Parents can update their own links"
  ON public.parent_student_links
  FOR UPDATE
  USING (auth.uid() = parent_user_id);

CREATE OR REPLACE FUNCTION public.is_parent_of_student(p_parent UUID, p_student UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.parent_student_links
    WHERE parent_user_id = p_parent
      AND student_user_id = p_student
      AND is_active = true
  );
$$;

GRANT EXECUTE ON FUNCTION public.is_parent_of_student(UUID, UUID) TO authenticated;

CREATE POLICY "Users can view own or linked profiles"
  ON public.profiles
  FOR SELECT
  USING (
    auth.uid() = id
    OR EXISTS (
      SELECT 1
      FROM public.parent_student_links l
      WHERE l.is_active = true
        AND (
          (l.parent_user_id = auth.uid() AND l.student_user_id = profiles.id)
          OR (l.student_user_id = auth.uid() AND l.parent_user_id = profiles.id)
        )
    )
  );

-- -------------------------------------------------------------------
-- Theory content
-- -------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.theory_scrolls (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id TEXT NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
  chapter_id UUID NOT NULL REFERENCES public.chapters(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  summary TEXT,
  body_md TEXT NOT NULL,
  estimated_minutes INT NOT NULL DEFAULT 10,
  display_order INT NOT NULL DEFAULT 0,
  source TEXT NOT NULL DEFAULT 'admin',
  created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  target_student_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT theory_scrolls_source_check CHECK (source IN ('admin', 'parent'))
);

ALTER TABLE public.theory_scrolls ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Theory scrolls visible to assigned users"
  ON public.theory_scrolls
  FOR SELECT
  USING (
    auth.role() = 'authenticated'
    AND (
      source = 'admin'
      OR created_by = auth.uid()
      OR target_student_id = auth.uid()
      OR (target_student_id IS NOT NULL AND public.is_parent_of_student(auth.uid(), target_student_id))
    )
  );

CREATE POLICY "Authenticated users can create owned theory scrolls"
  ON public.theory_scrolls
  FOR INSERT
  WITH CHECK (
    auth.uid() = created_by
    AND source = 'parent'
    AND (
      target_student_id IS NULL
      OR target_student_id = auth.uid()
      OR public.is_parent_of_student(auth.uid(), target_student_id)
    )
  );

CREATE POLICY "Creators can update theory scrolls"
  ON public.theory_scrolls
  FOR UPDATE
  USING (auth.uid() = created_by);

-- -------------------------------------------------------------------
-- Practice / boss metadata on existing exercises
-- -------------------------------------------------------------------
ALTER TABLE public.exercises
  ADD COLUMN IF NOT EXISTS mode TEXT NOT NULL DEFAULT 'practice',
  ADD COLUMN IF NOT EXISTS source TEXT NOT NULL DEFAULT 'admin',
  ADD COLUMN IF NOT EXISTS created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS target_student_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  ADD COLUMN IF NOT EXISTS reward_coins INT NOT NULL DEFAULT 0;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'exercises_mode_check'
  ) THEN
    ALTER TABLE public.exercises
      ADD CONSTRAINT exercises_mode_check CHECK (mode IN ('practice', 'boss'));
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'exercises_source_check'
  ) THEN
    ALTER TABLE public.exercises
      ADD CONSTRAINT exercises_source_check CHECK (source IN ('admin', 'parent'));
  END IF;
END
$$;

DROP POLICY IF EXISTS "Exercises readable by all" ON public.exercises;

CREATE POLICY "Exercises visible to assigned users"
  ON public.exercises
  FOR SELECT
  USING (
    auth.role() = 'authenticated'
    AND (
      source = 'admin'
      OR created_by = auth.uid()
      OR target_student_id = auth.uid()
      OR (target_student_id IS NOT NULL AND public.is_parent_of_student(auth.uid(), target_student_id))
    )
  );

CREATE POLICY "Authenticated users can create owned exercises"
  ON public.exercises
  FOR INSERT
  WITH CHECK (
    auth.uid() = created_by
    AND source = 'parent'
    AND (
      target_student_id IS NULL
      OR target_student_id = auth.uid()
      OR public.is_parent_of_student(auth.uid(), target_student_id)
    )
  );

CREATE POLICY "Creators can update own exercises"
  ON public.exercises
  FOR UPDATE
  USING (auth.uid() = created_by AND source = 'parent');

DROP POLICY IF EXISTS "Questions readable by all" ON public.questions;

CREATE POLICY "Questions visible through readable exercises"
  ON public.questions
  FOR SELECT
  USING (
    auth.role() = 'authenticated'
    AND EXISTS (
      SELECT 1
      FROM public.exercises e
      WHERE e.id = questions.exercise_id
        AND (
          e.source = 'admin'
          OR e.created_by = auth.uid()
          OR e.target_student_id = auth.uid()
          OR (e.target_student_id IS NOT NULL AND public.is_parent_of_student(auth.uid(), e.target_student_id))
        )
    )
  );

CREATE POLICY "Exercise creators can create questions"
  ON public.questions
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM public.exercises e
      WHERE e.id = questions.exercise_id
        AND e.created_by = auth.uid()
        AND e.source = 'parent'
    )
  );

CREATE POLICY "Exercise creators can update questions"
  ON public.questions
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1
      FROM public.exercises e
      WHERE e.id = questions.exercise_id
        AND e.created_by = auth.uid()
        AND e.source = 'parent'
    )
  );

-- -------------------------------------------------------------------
-- Parent/admin assignments on top of reusable exercises
-- -------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.exercise_assignments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  exercise_id UUID NOT NULL REFERENCES public.exercises(id) ON DELETE CASCADE,
  student_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  assigned_by_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  due_at TIMESTAMPTZ,
  status TEXT NOT NULL DEFAULT 'assigned',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at TIMESTAMPTZ,
  CONSTRAINT exercise_assignments_status_check CHECK (status IN ('assigned', 'completed', 'expired')),
  CONSTRAINT exercise_assignments_unique UNIQUE (exercise_id, student_user_id, assigned_by_user_id)
);

ALTER TABLE public.exercise_assignments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Assignments visible to assignee or assigning parent"
  ON public.exercise_assignments
  FOR SELECT
  USING (
    auth.uid() = student_user_id
    OR auth.uid() = assigned_by_user_id
    OR public.is_parent_of_student(auth.uid(), student_user_id)
  );

CREATE POLICY "Parents can assign to linked students"
  ON public.exercise_assignments
  FOR INSERT
  WITH CHECK (
    auth.uid() = assigned_by_user_id
    AND (
      student_user_id = auth.uid()
      OR public.is_parent_of_student(auth.uid(), student_user_id)
    )
  );

CREATE POLICY "Assigner can update assignment state"
  ON public.exercise_assignments
  FOR UPDATE
  USING (auth.uid() = assigned_by_user_id OR auth.uid() = student_user_id);

-- -------------------------------------------------------------------
-- Badges and inventory
-- -------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.badges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  description TEXT,
  rarity TEXT NOT NULL DEFAULT 'common',
  icon_name TEXT,
  rule_key TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT badges_rarity_check CHECK (rarity IN ('common', 'rare', 'epic', 'legendary'))
);

ALTER TABLE public.badges ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Badges readable by authenticated users"
  ON public.badges
  FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE TABLE IF NOT EXISTS public.student_badges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  badge_id UUID NOT NULL REFERENCES public.badges(id) ON DELETE CASCADE,
  awarded_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  awarded_reason TEXT,
  awarded_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  CONSTRAINT student_badges_unique UNIQUE (student_user_id, badge_id)
);

ALTER TABLE public.student_badges ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Student badges visible to owner or linked parent"
  ON public.student_badges
  FOR SELECT
  USING (
    auth.uid() = student_user_id
    OR public.is_parent_of_student(auth.uid(), student_user_id)
  );

CREATE POLICY "Students can self-insert earned badges"
  ON public.student_badges
  FOR INSERT
  WITH CHECK (
    auth.uid() = student_user_id
    OR public.is_parent_of_student(auth.uid(), student_user_id)
  );

-- -------------------------------------------------------------------
-- Shop and inventory
-- -------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.shop_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  item_type TEXT NOT NULL,
  description TEXT,
  price_coins INT NOT NULL,
  effect_payload JSONB NOT NULL DEFAULT '{}'::jsonb,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT shop_items_type_check CHECK (item_type IN ('skin', 'potion', 'shield', 'booster')),
  CONSTRAINT shop_items_price_check CHECK (price_coins >= 0)
);

ALTER TABLE public.shop_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Shop items readable by authenticated users"
  ON public.shop_items
  FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE TABLE IF NOT EXISTS public.inventory_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  shop_item_id UUID NOT NULL REFERENCES public.shop_items(id) ON DELETE CASCADE,
  quantity INT NOT NULL DEFAULT 1,
  is_equipped BOOLEAN NOT NULL DEFAULT false,
  acquired_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT inventory_items_quantity_check CHECK (quantity >= 0),
  CONSTRAINT inventory_items_unique UNIQUE (student_user_id, shop_item_id)
);

ALTER TABLE public.inventory_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Inventory visible to owner or linked parent"
  ON public.inventory_items
  FOR SELECT
  USING (
    auth.uid() = student_user_id
    OR public.is_parent_of_student(auth.uid(), student_user_id)
  );

CREATE POLICY "Inventory owned by student or linked parent"
  ON public.inventory_items
  FOR INSERT
  WITH CHECK (
    auth.uid() = student_user_id
    OR public.is_parent_of_student(auth.uid(), student_user_id)
  );

CREATE POLICY "Inventory updates owned by student or linked parent"
  ON public.inventory_items
  FOR UPDATE
  USING (
    auth.uid() = student_user_id
    OR public.is_parent_of_student(auth.uid(), student_user_id)
  );

-- -------------------------------------------------------------------
-- Starter content for badges and shop
-- -------------------------------------------------------------------
INSERT INTO public.badges (code, name, description, rarity, icon_name, rule_key)
VALUES
  ('streak_7', 'Flamme Inebranlable', '7 jours de revision consecutifs.', 'rare', 'flame', 'streak_7'),
  ('boss_slayer', 'Tueur de Boss', 'Un boss de chapitre a ete vaincu.', 'epic', 'swords', 'boss_win'),
  ('math_blitz', 'Foudre de Calcul', 'Score de 95% ou plus en mathematiques.', 'rare', 'zap', 'math_95')
ON CONFLICT (code) DO NOTHING;

INSERT INTO public.shop_items (code, name, item_type, description, price_coins, effect_payload)
VALUES
  ('potion_rappel', 'Potion de Rappel', 'potion', 'Accorde un indice sur une question difficile.', 120, '{"hintBoost":1}'::jsonb),
  ('bouclier_flamme', 'Bouclier de Flamme', 'shield', 'Protege une serie quotidienne pendant un jour.', 250, '{"streakShield":1}'::jsonb),
  ('skin_samourai', 'Skin Samourai Neon', 'skin', 'Transformation cosmetique de l''avatar.', 500, '{"avatarSlug":"samurai-neon"}'::jsonb)
ON CONFLICT (code) DO NOTHING;

CREATE INDEX IF NOT EXISTS idx_parent_student_links_parent ON public.parent_student_links(parent_user_id);
CREATE INDEX IF NOT EXISTS idx_parent_student_links_student ON public.parent_student_links(student_user_id);
CREATE INDEX IF NOT EXISTS idx_theory_scrolls_target_student ON public.theory_scrolls(target_student_id);
CREATE INDEX IF NOT EXISTS idx_exercises_target_student ON public.exercises(target_student_id);
CREATE INDEX IF NOT EXISTS idx_assignments_student ON public.exercise_assignments(student_user_id, status);
CREATE INDEX IF NOT EXISTS idx_student_badges_student ON public.student_badges(student_user_id);
CREATE INDEX IF NOT EXISTS idx_inventory_items_student ON public.inventory_items(student_user_id);