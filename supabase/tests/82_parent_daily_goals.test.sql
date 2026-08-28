-- =========================================================
-- Objectif du jour famille — set/get + garde du lien parent-élève + RLS.
-- ---------------------------------------------------------
-- Miroir de 15_parent_weekly_goals.test.sql pour la variante journalière
-- (20260828120000_parent_daily_goal_and_wider_limits.sql). Vérifie en plus
-- le plafond élargi (1-1000) sur les deux mécanismes (hebdo et jour).
-- Everything rolls back at the end.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(12);

-- ---------------------------------------------------------
-- Fixtures (superuser): parent P linked to student S, stranger X.
-- One tiny exercise so S can have a today's attempt.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('f4000000-0000-0000-0000-0000000000aa', 'daily-goal-parent@test.local'),
  ('f4000000-0000-0000-0000-0000000000bb', 'daily-goal-student@test.local'),
  ('f4000000-0000-0000-0000-0000000000cc', 'daily-goal-stranger@test.local');

INSERT INTO public.profiles (id, display_name) VALUES
  ('f4000000-0000-0000-0000-0000000000aa', 'DailyGoalParent'),
  ('f4000000-0000-0000-0000-0000000000bb', 'DailyGoalStudent'),
  ('f4000000-0000-0000-0000-0000000000cc', 'DailyGoalStranger')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.parent_student_links (parent_user_id, student_user_id, relation_label, is_active)
VALUES ('f4000000-0000-0000-0000-0000000000aa', 'f4000000-0000-0000-0000-0000000000bb', 'parent', true);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('daily-goal-subj', 'Daily Goal Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('f5000000-0000-0000-0000-000000000001', 'daily-goal-subj', 'Daily Goal Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title)
VALUES ('f6000000-0000-0000-0000-000000000001',
        'f5000000-0000-0000-0000-000000000001', 'daily-goal-subj', 'Daily Goal Exercise');

-- One attempt by S, completed now → counts toward today.
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned)
VALUES
  ('f4000000-0000-0000-0000-0000000000bb', 'f6000000-0000-0000-0000-000000000001',
   'daily-goal-subj', 4, 5, 80, 120, 50);

-- ---------------------------------------------------------
-- As the linked parent P: set, then update (upsert); wide cap accepted.
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"f4000000-0000-0000-0000-0000000000aa","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.set_parent_daily_goal('f4000000-0000-0000-0000-0000000000bb', 3) ->> 'target')::int, 3,
  'set: a linked parent sets today''s goal');

SELECT is(
  (public.set_parent_daily_goal('f4000000-0000-0000-0000-0000000000bb', 8) ->> 'target')::int, 8,
  'set: setting again the same day UPDATES the goal (upsert)');

SELECT is(
  (public.set_parent_daily_goal('f4000000-0000-0000-0000-0000000000bb', 1000) ->> 'target')::int, 1000,
  'set: the wide cap (1000) is accepted');

SELECT throws_ok(
  $$SELECT public.set_parent_daily_goal('f4000000-0000-0000-0000-0000000000bb', 1001)$$,
  'Invalid daily target (1-1000).',
  'set: target above the wide cap is rejected');

SELECT throws_ok(
  $$SELECT public.set_parent_daily_goal('f4000000-0000-0000-0000-0000000000bb', 0)$$,
  'Invalid daily target (1-1000).',
  'set: target below 1 is rejected');

SELECT is(
  (public.get_family_daily_goal('f4000000-0000-0000-0000-0000000000bb') ->> 'target')::int, 1000,
  'get: the linked parent reads the goal back');

-- Weekly goal now also accepts the wide cap (relaxed by the same migration).
SELECT is(
  (public.set_parent_weekly_goal('f4000000-0000-0000-0000-0000000000bb', 500) ->> 'target')::int, 500,
  'set (weekly): the widened cap (500) is now accepted');

-- ---------------------------------------------------------
-- As the student S: reads goal + live progress; cannot write directly.
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"f4000000-0000-0000-0000-0000000000bb","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.get_family_daily_goal('f4000000-0000-0000-0000-0000000000bb') ->> 'target')::int, 1000,
  'get: the student reads their family daily goal');

SELECT is(
  (public.get_family_daily_goal('f4000000-0000-0000-0000-0000000000bb') ->> 'done')::int, 1,
  'get: progress counts the student''s attempts of today');

SELECT is(
  (SELECT COUNT(*)::int FROM public.parent_daily_goals), 1,
  'RLS: the student sees their goal row via direct SELECT');

SELECT throws_ok(
  $$INSERT INTO public.parent_daily_goals
      (parent_user_id, student_user_id, day, target_exercises)
    VALUES ('f4000000-0000-0000-0000-0000000000bb',
            'f4000000-0000-0000-0000-0000000000bb', CURRENT_DATE, 3)$$,
  'permission denied for table parent_daily_goals',
  'RLS: direct INSERT as authenticated is denied (writes go through the RPC)');

-- ---------------------------------------------------------
-- As the stranger X: no write, no read.
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"f4000000-0000-0000-0000-0000000000cc","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$SELECT public.set_parent_daily_goal('f4000000-0000-0000-0000-0000000000bb', 3)$$,
  'Access denied: you are not linked to this student.',
  'set: an unlinked user cannot set a daily goal for the student');

SELECT * FROM finish();
ROLLBACK;
