-- =========================================================
-- Public stateless quiz SCORING (anon gate parity) — public.score_quiz
-- ---------------------------------------------------------
-- An ANONYMOUS caller can SCORE the comprehension quiz (aggregate correct/total
-- only) so they can self-validate and unlock a chapter's exercises client-side —
-- mirroring the connected gate — but the answer key stays secret (no per-question
-- correctness, no correct_option, no explanation). Only admin mode='quiz'
-- exercises are scorable; practice/boss and parent content yield (0, 0). Asserted
-- under a REAL `SET LOCAL ROLE anon` (SECURITY DEFINER + granted to anon).
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(5);

INSERT INTO auth.users (id, email) VALUES
  ('33333333-3333-3333-3333-333333333333', 'score-parent@test.local');

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('score-subj', 'Score Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('dddddddd-0000-0000-0000-000000000001', 'score-subj', 'Score Chapter');

-- Admin comprehension quiz + three questions (correct answers: a, b, c).
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode)
VALUES ('dddddddd-0000-0000-0000-0000000000e1',
        'dddddddd-0000-0000-0000-000000000001', 'score-subj', 'Quiz', 'admin', 'quiz');
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option)
VALUES
  ('dddddddd-0000-0000-0000-0000000000f1', 'dddddddd-0000-0000-0000-0000000000e1',
   'Q1', '[{"id":"a"},{"id":"b"},{"id":"c"}]'::jsonb, 'a'),
  ('dddddddd-0000-0000-0000-0000000000f2', 'dddddddd-0000-0000-0000-0000000000e1',
   'Q2', '[{"id":"a"},{"id":"b"},{"id":"c"}]'::jsonb, 'b'),
  ('dddddddd-0000-0000-0000-0000000000f3', 'dddddddd-0000-0000-0000-0000000000e1',
   'Q3', '[{"id":"a"},{"id":"b"},{"id":"c"}]'::jsonb, 'c');

-- Admin practice exercise (must NOT be scorable here — only quizzes are).
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode)
VALUES ('dddddddd-0000-0000-0000-0000000000e2',
        'dddddddd-0000-0000-0000-000000000001', 'score-subj', 'Practice', 'admin', 'practice');
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option)
VALUES ('dddddddd-0000-0000-0000-0000000000f4', 'dddddddd-0000-0000-0000-0000000000e2',
        'QP', '[{"id":"a"}]'::jsonb, 'a');

-- Parent-authored quiz (must stay private even though mode='quiz').
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode, created_by)
VALUES ('dddddddd-0000-0000-0000-0000000000e3',
        'dddddddd-0000-0000-0000-000000000001', 'score-subj', 'Parent quiz', 'parent', 'quiz',
        '33333333-3333-3333-3333-333333333333');
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option)
VALUES ('dddddddd-0000-0000-0000-0000000000f5', 'dddddddd-0000-0000-0000-0000000000e3',
        'QPZ', '[{"id":"a"}]'::jsonb, 'a');

-- Become the anonymous visitor.
SET LOCAL ROLE anon;

SELECT is(
  (SELECT correct FROM public.score_quiz(
     'dddddddd-0000-0000-0000-0000000000e1',
     '[{"questionId":"dddddddd-0000-0000-0000-0000000000f1","choice":"a"},
       {"questionId":"dddddddd-0000-0000-0000-0000000000f2","choice":"b"},
       {"questionId":"dddddddd-0000-0000-0000-0000000000f3","choice":"c"}]'::jsonb)),
  3,
  'anon score_quiz counts every correct answer'
);

SELECT is(
  (SELECT total FROM public.score_quiz(
     'dddddddd-0000-0000-0000-0000000000e1',
     '[{"questionId":"dddddddd-0000-0000-0000-0000000000f1","choice":"a"}]'::jsonb)),
  3,
  'anon score_quiz total is the quiz full question count (unanswered = wrong)'
);

SELECT is(
  (SELECT correct FROM public.score_quiz(
     'dddddddd-0000-0000-0000-0000000000e1',
     '[{"questionId":"dddddddd-0000-0000-0000-0000000000f1","choice":"b"},
       {"questionId":"dddddddd-0000-0000-0000-0000000000f2","choice":"b"}]'::jsonb)),
  1,
  'anon score_quiz counts only the matching answers'
);

SELECT is(
  (SELECT total FROM public.score_quiz(
     'dddddddd-0000-0000-0000-0000000000e2',
     '[{"questionId":"dddddddd-0000-0000-0000-0000000000f4","choice":"a"}]'::jsonb)),
  0,
  'anon score_quiz refuses a practice exercise (returns 0, 0)'
);

SELECT is(
  (SELECT total FROM public.score_quiz(
     'dddddddd-0000-0000-0000-0000000000e3',
     '[{"questionId":"dddddddd-0000-0000-0000-0000000000f5","choice":"a"}]'::jsonb)),
  0,
  'anon score_quiz refuses parent-authored content (returns 0, 0)'
);

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
