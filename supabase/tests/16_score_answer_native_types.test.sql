-- =========================================================
-- Native question types (B1) — score_answer seam invariants.
-- ---------------------------------------------------------
-- Étude FableEtudes/03-types-questions-natifs #lot-B1.1 ;
-- spec normative docs/interactive-question-types.md.
--
--   1. 'mcq' fast path: strictly the historical string-equality semantics —
--      old rows (no question_type written) score IDENTICALLY (US-4 regression);
--   2. 'numeric': abs(x − value) <= tolerance (default 0), comma normalized,
--      unparseable input scores false and never raises (US-1 / R-3);
--   3. not-yet-shipped types (ordering — phase B2) score false, never crash;
--   4. key-shape integrity: non-mcq requires answer_key, type list is closed;
--   5. R-1: answer_key is column-masked from clients, question_type readable,
--      score_answer not client-executable (no answer-key oracle);
--   6. end-to-end: submit_exercise_attempt / check_answers / score_quiz /
--      get_attempt_review / submit_dungeon_answer all score through the seam.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(26);

-- ---------------------------------------------------------
-- Shared content fixtures.
-- ---------------------------------------------------------
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('natv-subj', 'Native Types Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('d1000000-0000-0000-0000-000000000001', 'natv-subj', 'Native Types Chapter');

-- Mixed admin practice exercise: 1 legacy mcq (no question_type written) +
-- 1 numeric with tolerance. xp 100, coins 20.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward, reward_coins, source, mode)
VALUES ('d2000000-0000-0000-0000-000000000001',
        'd1000000-0000-0000-0000-000000000001', 'natv-subj',
        'Mixed Exercise', 100, 20, 'admin', 'practice');

-- Legacy-shape insert: question_type defaults to 'mcq'.
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order)
VALUES ('d3000000-0000-0000-0000-000000000001',
        'd2000000-0000-0000-0000-000000000001',
        'MCQ: 2+2 ?',
        '[{"id":"a","text":"4"},{"id":"b","text":"5"}]'::jsonb,
        'a', 'Because 4.', 1);

INSERT INTO public.questions (id, exercise_id, prompt, options, question_type, answer_key, explanation, display_order)
VALUES ('d3000000-0000-0000-0000-000000000002',
        'd2000000-0000-0000-0000-000000000001',
        'Numeric: pi ~ ?',
        '[]'::jsonb,
        'numeric', '{"value": 3.14, "tolerance": 0.01}'::jsonb,
        'Pi rounded.', 2);

-- Numeric question with DEFAULT tolerance (0) on its own quiz exercise.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode)
VALUES ('d2000000-0000-0000-0000-000000000002',
        'd1000000-0000-0000-0000-000000000001', 'natv-subj',
        'Numeric Quiz', 'admin', 'quiz');

INSERT INTO public.questions (id, exercise_id, prompt, options, question_type, answer_key, display_order)
VALUES ('d3000000-0000-0000-0000-000000000003',
        'd2000000-0000-0000-0000-000000000002',
        'Numeric: 6*7 ?', '[]'::jsonb,
        'numeric', '{"value": 42}'::jsonb, 1);

-- A future-phase (B2) ordering row: must be storable but score false for now.
INSERT INTO public.questions (id, exercise_id, prompt, options, question_type, answer_key, display_order)
VALUES ('d3000000-0000-0000-0000-000000000004',
        'd2000000-0000-0000-0000-000000000001',
        'Ordering: steps', '[{"id":"a","text":"x"},{"id":"b","text":"y"}]'::jsonb,
        'ordering', '{"order": ["b", "a"]}'::jsonb, 3);

-- =========================================================
-- 1–2. mcq fast path (regression, US-4).
-- =========================================================
SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'd3000000-0000-0000-0000-000000000001'), 'a'),
  true,
  'mcq: the historical correct choice still scores true'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'd3000000-0000-0000-0000-000000000001'), 'b'),
  false,
  'mcq: a wrong choice still scores false'
);

-- =========================================================
-- 3–9. numeric semantics (US-1).
-- =========================================================
SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'd3000000-0000-0000-0000-000000000003'), '42'),
  true,
  'numeric: exact match with default tolerance 0 scores true'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'd3000000-0000-0000-0000-000000000003'), '42.001'),
  false,
  'numeric: default tolerance is STRICTLY 0 (42.001 is wrong)'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'd3000000-0000-0000-0000-000000000002'), '3,15'),
  true,
  'numeric: decimal COMMA is normalized and 3,15 is within tolerance 0.01 of 3.14'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'd3000000-0000-0000-0000-000000000002'), '3.16'),
  false,
  'numeric: 3.16 falls outside tolerance 0.01 of 3.14'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'd3000000-0000-0000-0000-000000000003'), '  42  '),
  true,
  'numeric: surrounding whitespace is trimmed'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'd3000000-0000-0000-0000-000000000003'), 'abc'),
  false,
  'numeric: unparseable input scores false (no exception — R-3)'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'd3000000-0000-0000-0000-000000000003'), NULL),
  false,
  'numeric: a NULL choice scores false'
);

-- =========================================================
-- 10. future-phase types never crash (R-3).
-- =========================================================
SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'd3000000-0000-0000-0000-000000000004'), 'b,a'),
  false,
  'ordering (phase B2, not shipped): scores false instead of crashing'
);

-- =========================================================
-- 11–12. key-shape integrity constraints.
-- =========================================================
SELECT throws_ok(
  $$ INSERT INTO public.questions (exercise_id, prompt, options, question_type)
     VALUES ('d2000000-0000-0000-0000-000000000001', 'bad', '[]'::jsonb, 'numeric') $$,
  '23514',
  NULL,
  'a non-mcq question WITHOUT answer_key is rejected (check constraint)'
);

SELECT throws_ok(
  $$ INSERT INTO public.questions (exercise_id, prompt, options, correct_option, question_type)
     VALUES ('d2000000-0000-0000-0000-000000000001', 'bad', '[]'::jsonb, 'a', 'essay') $$,
  '23514',
  NULL,
  'an unknown question_type is rejected (closed Tier-B type list)'
);

-- =========================================================
-- 13–15. R-1 — the key never reaches clients.
-- =========================================================
SELECT is(
  has_column_privilege('anon', 'public.questions', 'answer_key', 'SELECT'),
  false,
  'R-1: anon canNOT select questions.answer_key'
);

SELECT is(
  has_column_privilege('authenticated', 'public.questions', 'answer_key', 'SELECT'),
  false,
  'R-1: authenticated canNOT select questions.answer_key'
);

SELECT is(
  has_column_privilege('authenticated', 'public.questions', 'question_type', 'SELECT')
    AND has_column_privilege('anon', 'public.questions', 'question_type', 'SELECT'),
  true,
  'question_type IS client-readable (the renderer needs it)'
);

SELECT is(
  has_function_privilege('anon', 'public.score_answer(public.questions, text)', 'EXECUTE')
    OR has_function_privilege('authenticated', 'public.score_answer(public.questions, text)', 'EXECUTE'),
  false,
  'R-1: score_answer is not client-executable (no answer-key oracle)'
);

-- =========================================================
-- 17–18. End-to-end: submit_exercise_attempt scores through the seam.
-- (mixed exercise has 3 questions: mcq + numeric + ordering.)
-- =========================================================
INSERT INTO auth.users (id, email)
VALUES ('f6666666-6666-6666-6666-666666666666', 'native-good@test.local');

INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('a6000000-0000-0000-0000-000000000001',
        'f6666666-6666-6666-6666-666666666666',
        'd2000000-0000-0000-0000-000000000001',
        clock_timestamp() - INTERVAL '120 seconds');

SET LOCAL "request.jwt.claims" = '{"sub":"f6666666-6666-6666-6666-666666666666","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT set_config(
  'test.mixed_result',
  public.submit_exercise_attempt(
    'a6000000-0000-0000-0000-000000000001',
    'd2000000-0000-0000-0000-000000000001',
    '[{"questionId":"d3000000-0000-0000-0000-000000000001","choice":"a"},
      {"questionId":"d3000000-0000-0000-0000-000000000002","choice":"3,15"},
      {"questionId":"d3000000-0000-0000-0000-000000000004","choice":"b,a"}]'::jsonb
  )::text,
  true
);

SELECT is(
  (current_setting('test.mixed_result')::jsonb ->> 'correct')::int,
  2,
  'submit_exercise_attempt: mcq + numeric (comma, in-tolerance) both count correct'
);

SELECT is(
  (current_setting('test.mixed_result')::jsonb ->> 'total')::int,
  3,
  'submit_exercise_attempt: the unshipped ordering row still counts in the total'
);

RESET ROLE;

-- =========================================================
-- 19. get_attempt_review reveals the numeric canonical value (owner, completed).
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"f6666666-6666-6666-6666-666666666666","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT r.correct_option FROM public.get_attempt_review('a6000000-0000-0000-0000-000000000001') r
    WHERE r.question_id = 'd3000000-0000-0000-0000-000000000002'),
  '3.14',
  'get_attempt_review: a numeric question reveals answer_key value as the correction'
);

-- The review scores through the same seam as the submit RPC (B1.2): an
-- in-tolerance numeric answer is CORRECT in the review, not a string mismatch.
SELECT is(
  (SELECT r.is_correct FROM public.get_attempt_review(
     'a6000000-0000-0000-0000-000000000001',
     '[{"questionId":"d3000000-0000-0000-0000-000000000002","choice":"3,15"}]'::jsonb) r
    WHERE r.question_id = 'd3000000-0000-0000-0000-000000000002'),
  true,
  'get_attempt_review: an in-tolerance numeric answer is scored correct in the review'
);

SELECT is(
  (SELECT r.is_correct FROM public.get_attempt_review('a6000000-0000-0000-0000-000000000001') r
    WHERE r.question_id = 'd3000000-0000-0000-0000-000000000002'),
  NULL::boolean,
  'get_attempt_review: the legacy call shape (no answers) leaves is_correct NULL'
);

RESET ROLE;

-- =========================================================
-- 20–21. check_answers (anon practice) scores numeric + reveals the value.
-- =========================================================
SET LOCAL ROLE anon;

SELECT is(
  (SELECT c.is_correct FROM public.check_answers(
     'd2000000-0000-0000-0000-000000000001',
     '[{"questionId":"d3000000-0000-0000-0000-000000000002","choice":"3.15"}]'::jsonb) c),
  true,
  'check_answers: anon numeric practice answer within tolerance is correct'
);

SELECT is(
  (SELECT c.correct_option FROM public.check_answers(
     'd2000000-0000-0000-0000-000000000001',
     '[{"questionId":"d3000000-0000-0000-0000-000000000002","choice":"9"}]'::jsonb) c),
  '3.14',
  'check_answers: the numeric correction reveals the canonical value'
);

-- =========================================================
-- 22–23. score_quiz counts numeric answers (aggregate only).
-- =========================================================
SELECT is(
  (SELECT s.correct FROM public.score_quiz(
     'd2000000-0000-0000-0000-000000000002',
     '[{"questionId":"d3000000-0000-0000-0000-000000000003","choice":"42"}]'::jsonb) s),
  1,
  'score_quiz: an exact numeric answer counts as correct'
);

SELECT is(
  (SELECT s.correct FROM public.score_quiz(
     'd2000000-0000-0000-0000-000000000002',
     '[{"questionId":"d3000000-0000-0000-0000-000000000003","choice":"41.9"}]'::jsonb) s),
  0,
  'score_quiz: an out-of-tolerance numeric answer counts as wrong'
);

RESET ROLE;

-- =========================================================
-- 24. submit_dungeon_answer scores numeric through the seam.
-- =========================================================
INSERT INTO auth.users (id, email)
VALUES ('f7777777-7777-7777-7777-777777777777', 'native-dungeon@test.local');

INSERT INTO public.dungeon_runs (id, user_id, current_floor, status)
VALUES ('d4000000-0000-0000-0000-000000000001',
        'f7777777-7777-7777-7777-777777777777', 1, 'active');

INSERT INTO public.dungeon_run_questions (run_id, question_id, assigned_floor)
VALUES ('d4000000-0000-0000-0000-000000000001',
        'd3000000-0000-0000-0000-000000000003', 1);

SET LOCAL "request.jwt.claims" = '{"sub":"f7777777-7777-7777-7777-777777777777","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.submit_dungeon_answer(
     'd4000000-0000-0000-0000-000000000001',
     'd3000000-0000-0000-0000-000000000003',
     '42') ->> 'isCorrect')::boolean,
  true,
  'submit_dungeon_answer: a correct numeric answer clears the floor'
);

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
