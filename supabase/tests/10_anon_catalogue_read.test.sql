-- =========================================================
-- Public-first (C8 / L0.2) — the ANONYMOUS role can read the ADMIN catalogue
-- (exercises + their questions) but NOT parent-authored content, and the answer
-- key stays masked at the column level.
-- ---------------------------------------------------------
-- Asserted under a REAL `SET LOCAL ROLE anon` so RLS + column grants are actually
-- enforced (both are bypassed for the table owner / superuser).
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(5);

-- ---------------------------------------------------------
-- Fixtures (seeded as superuser, RLS bypassed): one admin exercise + question
-- (public catalogue) and one parent-authored exercise + question (private).
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('11111111-1111-1111-1111-111111111111', 'anon-parent@test.local');

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('anon-subj', 'Anon Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('aaaaaaaa-0000-0000-0000-000000000001', 'anon-subj', 'Anon Chapter');

-- Admin catalogue exercise + question (should be anon-readable).
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source)
VALUES ('aaaaaaaa-0000-0000-0000-0000000000a1',
        'aaaaaaaa-0000-0000-0000-000000000001', 'anon-subj', 'Admin Exercise', 'admin');

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option)
VALUES ('aaaaaaaa-0000-0000-0000-0000000000b1',
        'aaaaaaaa-0000-0000-0000-0000000000a1',
        'Admin question?',
        '[{"id":"a","text":"x"},{"id":"b","text":"y"}]'::jsonb, 'a');

-- Parent-authored exercise + question (must stay private from anon).
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, created_by)
VALUES ('aaaaaaaa-0000-0000-0000-0000000000a2',
        'aaaaaaaa-0000-0000-0000-000000000001', 'anon-subj', 'Parent Exercise', 'parent',
        '11111111-1111-1111-1111-111111111111');

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option)
VALUES ('aaaaaaaa-0000-0000-0000-0000000000b2',
        'aaaaaaaa-0000-0000-0000-0000000000a2',
        'Parent question?',
        '[{"id":"a","text":"x"}]'::jsonb, 'a');

-- Become the anonymous visitor.
SET LOCAL ROLE anon;

SELECT is(
  (SELECT count(*)::int FROM public.exercises
     WHERE id = 'aaaaaaaa-0000-0000-0000-0000000000a1'),
  1,
  'anon CAN read an admin catalogue exercise'
);

SELECT is_empty(
  $$ SELECT 1 FROM public.exercises
       WHERE id = 'aaaaaaaa-0000-0000-0000-0000000000a2' $$,
  'anon canNOT read a parent-authored exercise'
);

SELECT is(
  (SELECT count(*)::int FROM public.questions
     WHERE exercise_id = 'aaaaaaaa-0000-0000-0000-0000000000a1'),
  1,
  'anon CAN read questions of an admin exercise'
);

SELECT is_empty(
  $$ SELECT 1 FROM public.questions
       WHERE exercise_id = 'aaaaaaaa-0000-0000-0000-0000000000a2' $$,
  'anon canNOT read questions of a parent-authored exercise'
);

-- The answer key stays masked at the COLUMN level for anon (20260610170000):
-- selecting correct_option is rejected before RLS row-filtering even applies.
SELECT throws_ok(
  $$ SELECT correct_option FROM public.questions
       WHERE exercise_id = 'aaaaaaaa-0000-0000-0000-0000000000a1' $$,
  '42501',
  NULL,
  'anon canNOT read questions.correct_option (column masked)'
);

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
