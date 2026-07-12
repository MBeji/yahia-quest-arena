-- =========================================================
-- Moteur adaptatif A0 — telemetry CAPTURE (étude 04, lot A0.2).
-- ---------------------------------------------------------
--   1. submit_exercise_attempt writes one question_attempts row per ANSWERED
--      question in the same transaction: tag resolved server-side from
--      distractor_tags->>choice (NULL for a correct choice), source
--      'exercise'/'quiz' per exercise mode, session context = the quest session;
--   2. rewards REGRESSION: the barème is byte-identical (xp/coins/gates
--      untouched by the capture — stop-point du lot) ;
--   3. the aggregate trigger fires end-to-end through the real RPC;
--   4. submit_dungeon_answer captures source='dungeon' with the run as session;
--   5. purge_question_attempts deletes only rows older than 12 months and
--      stays non-client-executable.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(15);

-- ---------------------------------------------------------
-- Fixtures. One 5-question practice exercise (xp 100 / coins 20, key 'a',
-- option 'b' tagged) + a 1-question quiz-mode exercise + a dungeon run.
-- ---------------------------------------------------------
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('a02-subj', 'A0 Capture Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('c0200000-0000-0000-0000-000000000001', 'a02-subj', 'A0 Capture Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward, reward_coins, mode)
VALUES ('c0200000-0000-0000-0000-000000000010',
        'c0200000-0000-0000-0000-000000000001', 'a02-subj',
        'A0 Capture Exercise', 100, 20, 'practice'),
       ('c0200000-0000-0000-0000-000000000020',
        'c0200000-0000-0000-0000-000000000001', 'a02-subj',
        'A0 Capture Quiz', 0, 0, 'quiz');

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order, distractor_tags)
SELECT
  ('c0300000-0000-0000-0000-00000000000' || g)::uuid,
  'c0200000-0000-0000-0000-000000000010',
  'Q' || g,
  '[{"id":"a","text":"right"},{"id":"b","text":"wrong"},{"id":"c","text":"x"},{"id":"d","text":"y"}]'::jsonb,
  'a',
  g,
  '{"b": "math.frac.add-denominators"}'::jsonb
FROM generate_series(1, 5) AS g;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order, distractor_tags)
VALUES ('c0300000-0000-0000-0000-000000000009',
        'c0200000-0000-0000-0000-000000000020',
        'QZ', '[{"id":"a","text":"right"},{"id":"b","text":"wrong"}]'::jsonb,
        'a', 1, '{"b": "math.quiz.trap"}'::jsonb);

INSERT INTO auth.users (id, email)
VALUES ('f6666666-6666-6666-6666-666666666666', 'capture@test.local');

INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('c0400000-0000-0000-0000-000000000001',
        'f6666666-6666-6666-6666-666666666666',
        'c0200000-0000-0000-0000-000000000010',
        clock_timestamp() - INTERVAL '120 seconds'),
       ('c0400000-0000-0000-0000-000000000002',
        'f6666666-6666-6666-6666-666666666666',
        'c0200000-0000-0000-0000-000000000020',
        clock_timestamp() - INTERVAL '120 seconds');

-- =========================================================
-- 1–8. Exercise submit: 3 correct + 1 tagged wrong + 1 unanswered.
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"f6666666-6666-6666-6666-666666666666","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT set_config(
  'test.capture_result',
  public.submit_exercise_attempt(
    'c0400000-0000-0000-0000-000000000001',
    'c0200000-0000-0000-0000-000000000010',
    '[{"questionId":"c0300000-0000-0000-0000-000000000001","choice":"a"},
      {"questionId":"c0300000-0000-0000-0000-000000000002","choice":"a"},
      {"questionId":"c0300000-0000-0000-0000-000000000003","choice":"a"},
      {"questionId":"c0300000-0000-0000-0000-000000000004","choice":"b"}]'::jsonb
  )::text,
  true
);

-- Rewards regression (stop-point): 3/5 correct = 60% — eligible, unrushed,
-- first attempt → xp = round(100 × 0.60) = 60, full coins = 20. Any drift here
-- means the capture touched the barème.
SELECT is(
  (current_setting('test.capture_result')::jsonb ->> 'scorePct')::numeric,
  60::numeric,
  'regression: score is 3/5 = 60% (unanswered counts wrong, unchanged)'
);

SELECT is(
  (current_setting('test.capture_result')::jsonb ->> 'xpEarned')::int,
  60,
  'regression: xp stays score-proportional (round(100 × 0.60) = 60)'
);

SELECT is(
  (current_setting('test.capture_result')::jsonb ->> 'coinsEarned')::int,
  20,
  'regression: full coins on an eligible attempt (20)'
);

RESET ROLE;

SELECT is(
  (SELECT count(*)::int FROM public.question_attempts
     WHERE user_id = 'f6666666-6666-6666-6666-666666666666'
       AND session_id = 'c0400000-0000-0000-0000-000000000001'),
  4,
  'capture: one telemetry row per ANSWERED question (4, not 5)'
);

SELECT is(
  (SELECT misconception_tag FROM public.question_attempts
     WHERE session_id = 'c0400000-0000-0000-0000-000000000001'
       AND question_id = 'c0300000-0000-0000-0000-000000000004'),
  'math.frac.add-denominators',
  'capture: the wrong choice resolves its misconception tag server-side'
);

SELECT is(
  (SELECT count(*)::int FROM public.question_attempts
     WHERE session_id = 'c0400000-0000-0000-0000-000000000001'
       AND is_correct AND misconception_tag IS NULL),
  3,
  'capture: correct choices carry NO tag (nothing to diagnose)'
);

SELECT is(
  (SELECT count(*)::int FROM public.question_attempts
     WHERE session_id = 'c0400000-0000-0000-0000-000000000001'
       AND source = 'exercise'),
  4,
  'capture: a practice exercise records source = exercise'
);

SELECT is(
  (SELECT occurrences || '/' || sessions_seen FROM public.user_misconceptions
     WHERE user_id = 'f6666666-6666-6666-6666-666666666666'
       AND tag = 'math.frac.add-denominators'),
  '1/1',
  'capture: the aggregate trigger fires end-to-end through the real RPC'
);

-- =========================================================
-- 9. Quiz-mode exercise records source = 'quiz'.
-- =========================================================
SET LOCAL ROLE authenticated;

SELECT public.submit_exercise_attempt(
  'c0400000-0000-0000-0000-000000000002',
  'c0200000-0000-0000-0000-000000000020',
  '[{"questionId":"c0300000-0000-0000-0000-000000000009","choice":"b"}]'::jsonb
);

RESET ROLE;

SELECT is(
  (SELECT source FROM public.question_attempts
     WHERE session_id = 'c0400000-0000-0000-0000-000000000002'),
  'quiz',
  'capture: a quiz-mode exercise records source = quiz'
);

-- =========================================================
-- 10–12. Dungeon answer records source = 'dungeon', session = run id.
-- =========================================================
INSERT INTO public.dungeon_runs (id, user_id, status, current_floor)
VALUES ('c0500000-0000-0000-0000-000000000001',
        'f6666666-6666-6666-6666-666666666666', 'active', 1);

INSERT INTO public.dungeon_run_questions (run_id, question_id, assigned_floor)
VALUES ('c0500000-0000-0000-0000-000000000001',
        'c0300000-0000-0000-0000-000000000005', 1);

SET LOCAL ROLE authenticated;

SELECT set_config(
  'test.dungeon_result',
  public.submit_dungeon_answer(
    'c0500000-0000-0000-0000-000000000001',
    'c0300000-0000-0000-0000-000000000005',
    'b'
  )::text,
  true
);

RESET ROLE;

SELECT is(
  (current_setting('test.dungeon_result')::jsonb ->> 'isCorrect')::boolean,
  false,
  'regression: the dungeon wrong-answer path is unchanged (run fails)'
);

SELECT is(
  (SELECT source || '/' || misconception_tag FROM public.question_attempts
     WHERE session_id = 'c0500000-0000-0000-0000-000000000001'),
  'dungeon/math.frac.add-denominators',
  'capture: a dungeon answer records source = dungeon with its resolved tag'
);

SELECT is(
  (SELECT count(*)::int FROM public.question_attempts
     WHERE user_id = 'f6666666-6666-6666-6666-666666666666'),
  6,
  'capture: total telemetry = 4 exercise + 1 quiz + 1 dungeon rows'
);

-- =========================================================
-- 13–15. Retention purge: only rows older than 12 months are deleted.
-- =========================================================
INSERT INTO public.question_attempts
  (user_id, question_id, chapter_id, session_id, choice, is_correct, misconception_tag, source, created_at)
VALUES
  ('f6666666-6666-6666-6666-666666666666', 'c0300000-0000-0000-0000-000000000001',
   'c0200000-0000-0000-0000-000000000001', 'c0400000-0000-0000-0000-000000000099',
   'b', false, 'math.frac.add-denominators', 'exercise', now() - INTERVAL '13 months');

SELECT is(
  public.purge_question_attempts(),
  1,
  'purge: exactly the >12-months-old row is deleted'
);

SELECT is(
  (SELECT count(*)::int FROM public.question_attempts
     WHERE user_id = 'f6666666-6666-6666-6666-666666666666'),
  6,
  'purge: recent telemetry is untouched'
);

SELECT is(
  has_function_privilege('anon', 'public.purge_question_attempts()', 'EXECUTE')
    OR has_function_privilege('authenticated', 'public.purge_question_attempts()', 'EXECUTE'),
  false,
  'purge: the purge function stays non-client-executable'
);

SELECT * FROM finish();
ROLLBACK;
