-- =========================================================
-- Objectif hebdo famille — set/get + garde du lien parent-élève + RLS.
-- ---------------------------------------------------------
-- Asserts the parent weekly goal mechanism against REAL Postgres with the real
-- `authenticated` role:
--   * set_parent_weekly_goal: a LINKED parent sets then updates (upsert) the
--     current-week goal; an unlinked user is rejected; bounds are enforced;
--   * get_family_weekly_goal: the student reads target + live progress (their
--     week's attempts); an unlinked stranger is rejected;
--   * RLS: a stranger reads zero rows; direct INSERT as authenticated fails
--     (writes only via the SECURITY DEFINER RPC).
-- Everything rolls back at the end.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(10);

-- ---------------------------------------------------------
-- Fixtures (superuser): parent P linked to student S, stranger X.
-- One tiny exercise so S can have a this-week attempt.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('f1000000-0000-0000-0000-0000000000aa', 'goal-parent@test.local'),
  ('f1000000-0000-0000-0000-0000000000bb', 'goal-student@test.local'),
  ('f1000000-0000-0000-0000-0000000000cc', 'goal-stranger@test.local');

INSERT INTO public.profiles (id, display_name) VALUES
  ('f1000000-0000-0000-0000-0000000000aa', 'GoalParent'),
  ('f1000000-0000-0000-0000-0000000000bb', 'GoalStudent'),
  ('f1000000-0000-0000-0000-0000000000cc', 'GoalStranger')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.parent_student_links (parent_user_id, student_user_id, relation_label, is_active)
VALUES ('f1000000-0000-0000-0000-0000000000aa', 'f1000000-0000-0000-0000-0000000000bb', 'parent', true);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('goal-subj', 'Goal Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('f2000000-0000-0000-0000-000000000001', 'goal-subj', 'Goal Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title)
VALUES ('f3000000-0000-0000-0000-000000000001',
        'f2000000-0000-0000-0000-000000000001', 'goal-subj', 'Goal Exercise');

-- One attempt by S, completed now → counts toward the current week.
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned)
VALUES
  ('f1000000-0000-0000-0000-0000000000bb', 'f3000000-0000-0000-0000-000000000001',
   'goal-subj', 4, 5, 80, 120, 50);

-- ---------------------------------------------------------
-- As the linked parent P: set, then update (upsert).
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"f1000000-0000-0000-0000-0000000000aa","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.set_parent_weekly_goal('f1000000-0000-0000-0000-0000000000bb', 5) ->> 'target')::int, 5,
  'set: a linked parent sets the current-week goal');

SELECT is(
  (public.set_parent_weekly_goal('f1000000-0000-0000-0000-0000000000bb', 7) ->> 'target')::int, 7,
  'set: setting again the same week UPDATES the goal (upsert)');

SELECT throws_ok(
  $$SELECT public.set_parent_weekly_goal('f1000000-0000-0000-0000-0000000000bb', 0)$$,
  'Invalid weekly target (1-50).',
  'set: target below 1 is rejected');

SELECT is(
  (public.get_family_weekly_goal('f1000000-0000-0000-0000-0000000000bb') ->> 'target')::int, 7,
  'get: the linked parent reads the goal back');

-- ---------------------------------------------------------
-- As the student S: reads goal + live progress; cannot write directly.
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"f1000000-0000-0000-0000-0000000000bb","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.get_family_weekly_goal('f1000000-0000-0000-0000-0000000000bb') ->> 'target')::int, 7,
  'get: the student reads their family goal');

SELECT is(
  (public.get_family_weekly_goal('f1000000-0000-0000-0000-0000000000bb') ->> 'done')::int, 1,
  'get: progress counts the student''s attempts of the current week');

SELECT is(
  (SELECT COUNT(*)::int FROM public.parent_weekly_goals), 1,
  'RLS: the student sees their goal row via direct SELECT');

SELECT throws_ok(
  $$INSERT INTO public.parent_weekly_goals
      (parent_user_id, student_user_id, week_start, target_exercises)
    VALUES ('f1000000-0000-0000-0000-0000000000bb',
            'f1000000-0000-0000-0000-0000000000bb', CURRENT_DATE, 3)$$,
  'permission denied for table parent_weekly_goals',
  'RLS: direct INSERT as authenticated is denied (writes go through the RPC)');

-- ---------------------------------------------------------
-- As the stranger X: no write, no read.
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"f1000000-0000-0000-0000-0000000000cc","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$SELECT public.set_parent_weekly_goal('f1000000-0000-0000-0000-0000000000bb', 3)$$,
  'Access denied: you are not linked to this student.',
  'set: an unlinked user cannot set a goal for the student');

SELECT is(
  (SELECT COUNT(*)::int FROM public.parent_weekly_goals), 0,
  'RLS: a stranger sees zero goal rows');

SELECT * FROM finish();
ROLLBACK;
