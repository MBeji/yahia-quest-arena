-- =========================================================
-- Root themes + Tunisian school grade levels
-- ---------------------------------------------------------
-- Adds TWO parent dimensions ABOVE the existing
--   subjects -> chapters -> exercises -> questions
-- tree, so the catalogue can hold many root *themes*
-- (culture générale, anti-vieillissement, muscler ton cerveau,
-- améliore ton anglais/français/arabe, programme scolaire
-- tunisien) and, under the school theme ONLY, a *grade* ladder
-- from the 1ère année de base to the Baccalauréat.
--
-- Three grades are national-exam years ("concours national"):
-- 6ème, 9ème and Bac — flagged via grades.is_concours_national.
--
-- Design (validated):
--   * subjects keep their TEXT slug id. New grade-scoped subjects
--     use a grade-suffixed slug (e.g. 'math-bac'); the real
--     theme/grade semantics are carried by two additive FKs.
--   * subjects.theme_id  TEXT  -> themes(id)   NOT NULL (post-backfill)
--   * subjects.grade_id  UUID  -> grades(id)   NULL (only school subjects)
--   * Everything below subjects (chapters/exercises/questions and
--     all gameplay: XP, quiz gate, dungeon, leaderboard) is UNTOUCHED.
--
-- Idempotent & additive: safe to re-run.
-- =========================================================

-- 1) Root themes ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.themes (
  id               TEXT PRIMARY KEY,        -- slug: 'ecole-tn', 'culture-generale'…
  name_fr          TEXT NOT NULL,
  description      TEXT,
  icon             TEXT NOT NULL,           -- lucide icon name
  color_token      TEXT NOT NULL,           -- maps to a CSS var like 'subject-math'
  content_language TEXT NOT NULL DEFAULT 'fr'
    CHECK (content_language IN ('ar', 'fr', 'en')),
  has_grades       BOOLEAN NOT NULL DEFAULT false,  -- true only for the school theme (for now)
  display_order    INT NOT NULL DEFAULT 0
);

ALTER TABLE public.themes ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Themes readable by all" ON public.themes;
CREATE POLICY "Themes readable by all" ON public.themes FOR SELECT USING (true);

-- 2) Grade levels (rattached to a theme; only the school theme uses them) --
CREATE TABLE IF NOT EXISTS public.grades (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  theme_id             TEXT NOT NULL REFERENCES public.themes(id) ON DELETE CASCADE,
  slug                 TEXT NOT NULL,       -- '1ere-base','6eme-base','9eme-base','bac'…
  name_fr              TEXT NOT NULL,
  cycle                TEXT,                -- 'primaire' | 'college' | 'secondaire' (UI grouping)
  is_concours_national BOOLEAN NOT NULL DEFAULT false,  -- 6ème, 9ème, Bac
  display_order        INT NOT NULL DEFAULT 0,
  UNIQUE (theme_id, slug)
);

ALTER TABLE public.grades ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Grades readable by all" ON public.grades;
CREATE POLICY "Grades readable by all" ON public.grades FOR SELECT USING (true);

CREATE INDEX IF NOT EXISTS idx_grades_theme_order ON public.grades (theme_id, display_order);

-- 3) subjects: two additive parent FKs ------------------------------------
ALTER TABLE public.subjects ADD COLUMN IF NOT EXISTS theme_id TEXT REFERENCES public.themes(id);
ALTER TABLE public.subjects ADD COLUMN IF NOT EXISTS grade_id UUID REFERENCES public.grades(id);
CREATE INDEX IF NOT EXISTS idx_subjects_theme ON public.subjects (theme_id, display_order);
CREATE INDEX IF NOT EXISTS idx_subjects_grade ON public.subjects (grade_id, display_order);

-- 4) profiles: the student's current school grade (chosen at onboarding) ---
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS current_grade_id UUID REFERENCES public.grades(id);

-- 5) Seed root themes -----------------------------------------------------
INSERT INTO public.themes (id, name_fr, description, icon, color_token, content_language, has_grades, display_order)
VALUES
  ('ecole-tn',            'Programme scolaire tunisien',   'Le programme officiel, de la 1ère année de base au Baccalauréat, avec les années de concours national (6ème, 9ème, Bac).', 'GraduationCap', 'subject-math',    'fr', true,  1),
  ('culture-generale',    'Culture générale',              'Élargis ta culture : histoire, géographie, sciences, arts et actualités.',                                                  'Globe',         'subject-svt',     'fr', false, 2),
  ('muscle-cerveau',      'Muscler ton cerveau',           'Logique, mémoire, calcul mental et énigmes pour entraîner ton cerveau.',                                                    'Brain',         'subject-math',    'fr', false, 3),
  ('anti-vieillissement', 'Programme anti-vieillissement', 'Habitudes, nutrition et exercices cognitifs pour garder un esprit vif plus longtemps.',                                     'HeartPulse',    'subject-svt',     'fr', false, 4),
  ('anglais',             'Améliore ton anglais',          'Perfectionne ton anglais, indépendamment de tout programme scolaire.',                                                       'Languages',     'subject-english', 'en', false, 5),
  ('francais',            'Améliore ton français',         'Perfectionne ton français, indépendamment de tout programme scolaire.',                                                      'Languages',     'subject-french',  'fr', false, 6),
  ('arabe',               'Améliore ton arabe',            'Perfectionne ton arabe, indépendamment de tout programme scolaire.',                                                         'Languages',     'subject-arabic',  'ar', false, 7)
ON CONFLICT (id) DO NOTHING;

-- 6) Seed the Tunisian grade ladder under the school theme ----------------
INSERT INTO public.grades (theme_id, slug, name_fr, cycle, is_concours_national, display_order)
VALUES
  ('ecole-tn', '1ere-base', '1ère année de base',    'primaire',   false,  1),
  ('ecole-tn', '2eme-base', '2ème année de base',    'primaire',   false,  2),
  ('ecole-tn', '3eme-base', '3ème année de base',    'primaire',   false,  3),
  ('ecole-tn', '4eme-base', '4ème année de base',    'primaire',   false,  4),
  ('ecole-tn', '5eme-base', '5ème année de base',    'primaire',   false,  5),
  ('ecole-tn', '6eme-base', '6ème année de base',    'primaire',   true,   6),
  ('ecole-tn', '7eme-base', '7ème année de base',    'college',    false,  7),
  ('ecole-tn', '8eme-base', '8ème année de base',    'college',    false,  8),
  ('ecole-tn', '9eme-base', '9ème année de base',    'college',    true,   9),
  ('ecole-tn', '1ere-sec',  '1ère année secondaire', 'secondaire', false, 10),
  ('ecole-tn', '2eme-sec',  '2ème année secondaire', 'secondaire', false, 11),
  ('ecole-tn', '3eme-sec',  '3ème année secondaire', 'secondaire', false, 12),
  ('ecole-tn', 'bac',       'Baccalauréat',          'secondaire', true,  13)
ON CONFLICT (theme_id, slug) DO NOTHING;

-- 7) Backfill existing subjects -------------------------------------------
-- All current content targets the 9ème année de base, EXCEPT 'fr-mastery',
-- which is explicitly independent of any school program → it belongs to the
-- "Améliore ton français" theme (no grade).
UPDATE public.subjects
   SET theme_id = 'francais', grade_id = NULL
 WHERE id = 'fr-mastery';

UPDATE public.subjects
   SET theme_id = 'ecole-tn',
       grade_id = (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '9eme-base')
 WHERE theme_id IS NULL;

-- 8) Every subject now has a theme → enforce NOT NULL ---------------------
ALTER TABLE public.subjects ALTER COLUMN theme_id SET NOT NULL;
