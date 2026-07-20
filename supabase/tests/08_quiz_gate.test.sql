-- =========================================================
-- Comprehension-quiz gate — the school-program unlock journey.
-- ---------------------------------------------------------
-- start_exercise_session (SECURITY DEFINER, server-authoritative since
-- GAP-021) is the only way to open a quest. For a SCHOOL subject (grade-bound):
--   * the chapter's practice missions are LOCKED until the comprehension quiz
--     is passed with >= 80% AND unrushed (>= 4s/question) — a fast random pass
--     must NOT unlock the chapter;
--   * the quiz itself is always startable (otherwise nothing could unlock);
--   * passing the quiz unlocks difficulty-1 (free preview) but NOT the
--     premium difficulty-3 mission (per-parcours entitlement gate).
-- Complements 06_start_exercise_session (non-school happy path, no gate).
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(6);

-- ---------------------------------------------------------
-- Fixtures: a 9ème (concours-9eme parcours) subject with one chapter holding a
-- quiz + a d1 practice + a d3 practice; two students without entitlements.
-- ---------------------------------------------------------
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id)
VALUES ('qg-subj', 'Quiz Gate Subject', 'Esprit', 'subject-math', 'Brain', 'ecole-tn',
        (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '9eme-base'));

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('f1000000-0000-0000-0000-000000000001', 'qg-subj', 'Quiz Gate Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward, difficulty, mode)
VALUES
  ('f2000000-0000-0000-0000-000000000001', 'f1000000-0000-0000-0000-000000000001', 'qg-subj', 'QG quiz', 50, 2, 'quiz'),
  ('f2000000-0000-0000-0000-000000000002', 'f1000000-0000-0000-0000-000000000001', 'qg-subj', 'QG d1',   50, 1, 'practice'),
  ('f2000000-0000-0000-0000-000000000003', 'f1000000-0000-0000-0000-000000000001', 'qg-subj', 'QG d3',   50, 3, 'practice');

INSERT INTO auth.users (id, email) VALUES
  ('f6666666-6666-6666-6666-666666666666', 'qg-student@test.local'),
  ('f7777777-7777-7777-7777-777777777777', 'qg-rusher@test.local');

-- Free phase (20260711100000) set every parcours to is_premium=false. The last
-- assertion below covers the DORMANT entitlement gate, so re-arm the flag on the
-- parcours under test — inside the transaction, undone by the final ROLLBACK.
-- Without it start_exercise_session allows the d3 mission and never raises
-- PARCOURS_LOCKED. The quiz gate itself is independent of this flag.
UPDATE public.parcours SET is_premium = true WHERE id = 'concours-9eme';

-- ---------------------------------------------------------
-- Student WITHOUT a quiz pass: practice locked, quiz itself open.
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"f6666666-6666-6666-6666-666666666666","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$ SELECT * FROM public.start_exercise_session('f2000000-0000-0000-0000-000000000002') $$,
  'P0001', 'QUIZ_LOCKED',
  'gate: a practice mission is LOCKED before the chapter quiz is passed'
);

SELECT isnt(
  (SELECT s.session_id FROM public.start_exercise_session('f2000000-0000-0000-0000-000000000001') s),
  NULL,
  'gate: the comprehension quiz itself is always startable'
);

-- ---------------------------------------------------------
-- A qualifying pass (>= 80%, unrushed) unlocks the free-preview practice…
-- ---------------------------------------------------------
RESET ROLE;
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned)
VALUES
  ('f6666666-6666-6666-6666-666666666666', 'f2000000-0000-0000-0000-000000000001', 'qg-subj', 5, 5, 90, 120, 40);

SET LOCAL "request.jwt.claims" = '{"sub":"f6666666-6666-6666-6666-666666666666","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT isnt(
  (SELECT s.session_id FROM public.start_exercise_session('f2000000-0000-0000-0000-000000000002') s),
  NULL,
  'unlock: an unrushed >= 80% quiz pass opens the difficulty-1 mission'
);

SELECT is(
  (SELECT count(*)::int FROM public.exercise_sessions
    WHERE user_id = 'f6666666-6666-6666-6666-666666666666'
      AND exercise_id = 'f2000000-0000-0000-0000-000000000002'),
  1,
  'unlock: the opened session is persisted for the student'
);

-- …but the premium difficulty-3 mission stays behind the parcours entitlement.
SELECT throws_ok(
  $$ SELECT * FROM public.start_exercise_session('f2000000-0000-0000-0000-000000000003') $$,
  'P0001', 'PARCOURS_LOCKED',
  'premium: passing the quiz does NOT bypass the per-parcours entitlement gate'
);

-- ---------------------------------------------------------
-- Anti-farm: a RUSHED perfect quiz (< 4s/question) unlocks nothing.
-- ---------------------------------------------------------
RESET ROLE;
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned)
VALUES
  ('f7777777-7777-7777-7777-777777777777', 'f2000000-0000-0000-0000-000000000001', 'qg-subj', 5, 5, 100, 10, 0);

SET LOCAL "request.jwt.claims" = '{"sub":"f7777777-7777-7777-7777-777777777777","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$ SELECT * FROM public.start_exercise_session('f2000000-0000-0000-0000-000000000002') $$,
  'P0001', 'QUIZ_LOCKED',
  'anti-farm: a rushed (10s for 5 questions) perfect quiz does NOT unlock'
);

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
