-- =========================================================
-- Public stateless answer-checking (C8 / L0.3) — public.check_answers
-- ---------------------------------------------------------
-- An ANONYMOUS caller gets a correction for admin practice/boss exercises
-- (incl. the revealed correct option), but NEVER for comprehension quizzes
-- (gate stays secret) nor for parent-authored content. Asserted under a REAL
-- `SET LOCAL ROLE anon` (the function is SECURITY DEFINER + granted to anon).
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(5);

INSERT INTO auth.users (id, email) VALUES
  ('22222222-2222-2222-2222-222222222222', 'chk-parent@test.local');

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('chk-subj', 'Check Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('cccccccc-0000-0000-0000-000000000001', 'chk-subj', 'Check Chapter');

-- Admin practice exercise + two questions (correct answers: a, b).
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode)
VALUES ('cccccccc-0000-0000-0000-0000000000e1',
        'cccccccc-0000-0000-0000-000000000001', 'chk-subj', 'Practice', 'admin', 'practice');
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation)
VALUES
  ('cccccccc-0000-0000-0000-0000000000f1', 'cccccccc-0000-0000-0000-0000000000e1',
   'Q1', '[{"id":"a"},{"id":"b"}]'::jsonb, 'a', 'Because a.'),
  ('cccccccc-0000-0000-0000-0000000000f2', 'cccccccc-0000-0000-0000-0000000000e1',
   'Q2', '[{"id":"a"},{"id":"b"}]'::jsonb, 'b', 'Because b.');

-- Admin comprehension quiz + question (must stay secret).
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode)
VALUES ('cccccccc-0000-0000-0000-0000000000e2',
        'cccccccc-0000-0000-0000-000000000001', 'chk-subj', 'Quiz', 'admin', 'quiz');
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option)
VALUES ('cccccccc-0000-0000-0000-0000000000f3', 'cccccccc-0000-0000-0000-0000000000e2',
        'QZ', '[{"id":"a"}]'::jsonb, 'a');

-- Parent-authored exercise + question (must stay private).
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode, created_by)
VALUES ('cccccccc-0000-0000-0000-0000000000e3',
        'cccccccc-0000-0000-0000-000000000001', 'chk-subj', 'Parent', 'parent', 'practice',
        '22222222-2222-2222-2222-222222222222');
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option)
VALUES ('cccccccc-0000-0000-0000-0000000000f4', 'cccccccc-0000-0000-0000-0000000000e3',
        'QP', '[{"id":"a"}]'::jsonb, 'a');

-- Become the anonymous visitor.
SET LOCAL ROLE anon;

SELECT is(
  (SELECT count(*)::int FROM public.check_answers(
     'cccccccc-0000-0000-0000-0000000000e1',
     '[{"questionId":"cccccccc-0000-0000-0000-0000000000f1","choice":"a"},
       {"questionId":"cccccccc-0000-0000-0000-0000000000f2","choice":"x"}]'::jsonb)),
  2,
  'anon check_answers returns one correction row per answered practice question'
);

SELECT is(
  (SELECT is_correct FROM public.check_answers(
     'cccccccc-0000-0000-0000-0000000000e1',
     '[{"questionId":"cccccccc-0000-0000-0000-0000000000f1","choice":"a"}]'::jsonb)),
  true,
  'anon check_answers marks the right choice as correct'
);

SELECT is(
  (SELECT correct_option FROM public.check_answers(
     'cccccccc-0000-0000-0000-0000000000e1',
     '[{"questionId":"cccccccc-0000-0000-0000-0000000000f2","choice":"x"}]'::jsonb)),
  'b',
  'anon check_answers reveals the correct option for a wrong practice answer'
);

SELECT is_empty(
  $$ SELECT 1 FROM public.check_answers(
       'cccccccc-0000-0000-0000-0000000000e2',
       '[{"questionId":"cccccccc-0000-0000-0000-0000000000f3","choice":"a"}]'::jsonb) $$,
  'anon check_answers reveals NOTHING for a comprehension quiz (gate stays secret)'
);

SELECT is_empty(
  $$ SELECT 1 FROM public.check_answers(
       'cccccccc-0000-0000-0000-0000000000e3',
       '[{"questionId":"cccccccc-0000-0000-0000-0000000000f4","choice":"a"}]'::jsonb) $$,
  'anon check_answers reveals nothing for parent-authored content'
);

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
