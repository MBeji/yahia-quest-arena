-- =========================================================
-- Core scoring — submit_exercise_attempt invariants.
-- ---------------------------------------------------------
-- Exercises the real atomic scoring RPC end-to-end as an `authenticated` user:
--   1. a correct, unrushed, improving attempt awards score-proportional XP +
--      full coins and updates the profile;
--   2. the anti-rush gate (duration < 4s/question) yields ZERO reward;
--   3. a <60% fail schedules spaced-repetition retries;
--   4. an ARMED retry shield SUPPRESSES that spaced-rep penalty and is consumed.
--
-- Reward math (20260604220000_harden_scoring_anti_rush + consumables):
--   eligible := NOT tooFast AND score >= 60 AND score > prev_best
--   xp       := round(xp_reward * score/100)   (no speed multiplier)
--   coins    := reward_coins (full) when eligible, else 0
-- We backdate exercise_sessions.started_at so duration clears the 4s/question
-- gate for the "good" attempt and stays under it for the "too fast" case.
--
-- Each case uses a distinct user + exercise so prev_best / streak state never
-- bleed across assertions; everything rolls back at the end.
-- =========================================================

BEGIN;
-- pgTAP is normally pre-installed by `supabase test db`; create it defensively
-- so the file is self-contained when run via psql too. Idempotent.
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(10);

-- ---------------------------------------------------------
-- Shared content fixtures (owned by superuser; RLS not yet in play).
-- One 5-question exercise: xp_reward 100, reward_coins 20. correct option 'a'.
-- ---------------------------------------------------------
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('score-subj', 'Scoring Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('e1000000-0000-0000-0000-000000000001', 'score-subj', 'Scoring Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward, reward_coins, mode)
VALUES ('e2000000-0000-0000-0000-000000000001',
        'e1000000-0000-0000-0000-000000000001', 'score-subj',
        'Scoring Exercise', 100, 20, 'practice');

-- 5 QCM questions, correct answer 'a' for all.
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
SELECT
  ('e3000000-0000-0000-0000-00000000000' || g)::uuid,
  'e2000000-0000-0000-0000-000000000001',
  'Q' || g,
  '[{"id":"a","text":"right"},{"id":"b","text":"wrong"},{"id":"c","text":"x"},{"id":"d","text":"y"}]'::jsonb,
  'a',
  g
FROM generate_series(1, 5) AS g;

-- Helper answer payloads: all-correct (5x 'a') and all-wrong (5x 'b').
-- Built once as text we splice into each rpc call.

-- =========================================================
-- CASE 1 — correct + unrushed + improving → full reward.
-- =========================================================
INSERT INTO auth.users (id, email)
VALUES ('f1111111-1111-1111-1111-111111111111', 'score-good@test.local');

INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('a1000000-0000-0000-0000-000000000001',
        'f1111111-1111-1111-1111-111111111111',
        'e2000000-0000-0000-0000-000000000001',
        -- 5 questions * 4s = 20s gate; 120s ago clears it comfortably.
        clock_timestamp() - INTERVAL '120 seconds');

SET LOCAL "request.jwt.claims" = '{"sub":"f1111111-1111-1111-1111-111111111111","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (
    SELECT (public.submit_exercise_attempt(
      'a1000000-0000-0000-0000-000000000001',
      'e2000000-0000-0000-0000-000000000001',
      '[{"questionId":"e3000000-0000-0000-0000-000000000001","choice":"a"},
        {"questionId":"e3000000-0000-0000-0000-000000000002","choice":"a"},
        {"questionId":"e3000000-0000-0000-0000-000000000003","choice":"a"},
        {"questionId":"e3000000-0000-0000-0000-000000000004","choice":"a"},
        {"questionId":"e3000000-0000-0000-0000-000000000005","choice":"a"}]'::jsonb
    ) ->> 'xpEarned')::int
  ),
  100,  -- round(100 * 100/100) = 100
  'correct unrushed attempt awards full score-proportional XP (100)'
);

-- Re-run is impossible (session completed); read back the awarded coins from the
-- profile and the recorded attempt instead.
SELECT is(
  (SELECT yahia_coins FROM public.profiles
     WHERE id = 'f1111111-1111-1111-1111-111111111111'),
  20,
  'correct attempt awards full coins (reward_coins = 20)'
);

SELECT is(
  (SELECT xp FROM public.profiles
     WHERE id = 'f1111111-1111-1111-1111-111111111111'),
  100,
  'profile XP reflects the awarded XP (100)'
);

SELECT is(
  (SELECT score_pct::int FROM public.attempts
     WHERE user_id = 'f1111111-1111-1111-1111-111111111111'),
  100,
  'a correct attempt records score_pct = 100'
);

RESET ROLE;

-- =========================================================
-- CASE 2 — anti-rush: a perfect score submitted too fast earns ZERO.
-- =========================================================
INSERT INTO auth.users (id, email)
VALUES ('f2222222-2222-2222-2222-222222222222', 'score-fast@test.local');

INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('a2000000-0000-0000-0000-000000000002',
        'f2222222-2222-2222-2222-222222222222',
        'e2000000-0000-0000-0000-000000000001',
        -- Only 2s ago: well under the 5*4 = 20s gate → tooFast.
        clock_timestamp() - INTERVAL '2 seconds');

SET LOCAL "request.jwt.claims" = '{"sub":"f2222222-2222-2222-2222-222222222222","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- The RPC mutates state (completes the session), so it can only be called once.
-- Stash its JSON result in a transaction-local custom GUC (namespaced GUCs are
-- settable by any role) so we can make two separate pgTAP assertions on it.
SELECT set_config(
  'test.fast_result',
  public.submit_exercise_attempt(
    'a2000000-0000-0000-0000-000000000002',
    'e2000000-0000-0000-0000-000000000001',
    '[{"questionId":"e3000000-0000-0000-0000-000000000001","choice":"a"},
      {"questionId":"e3000000-0000-0000-0000-000000000002","choice":"a"},
      {"questionId":"e3000000-0000-0000-0000-000000000003","choice":"a"},
      {"questionId":"e3000000-0000-0000-0000-000000000004","choice":"a"},
      {"questionId":"e3000000-0000-0000-0000-000000000005","choice":"a"}]'::jsonb
  )::text,
  true  -- is_local: cleared at transaction end
);

SELECT is(
  (current_setting('test.fast_result')::jsonb ->> 'tooFast')::boolean,
  true,
  'anti-rush: a sub-4s/question submission is flagged tooFast'
);

SELECT is(
  (current_setting('test.fast_result')::jsonb ->> 'xpEarned')::int,
  0,
  'anti-rush: a too-fast (even perfect) attempt earns ZERO XP'
);

SELECT is(
  (SELECT xp FROM public.profiles
     WHERE id = 'f2222222-2222-2222-2222-222222222222'),
  0,
  'anti-rush: the rushed user gains no XP on their profile'
);

RESET ROLE;

-- =========================================================
-- CASE 3 — a <60% fail schedules spaced-repetition retries.
-- =========================================================
INSERT INTO auth.users (id, email)
VALUES ('f3333333-3333-3333-3333-333333333333', 'score-fail@test.local');

INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('a3000000-0000-0000-0000-000000000003',
        'f3333333-3333-3333-3333-333333333333',
        'e2000000-0000-0000-0000-000000000001',
        clock_timestamp() - INTERVAL '120 seconds');

SET LOCAL "request.jwt.claims" = '{"sub":"f3333333-3333-3333-3333-333333333333","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- All-wrong answers → score 0% → fail branch. PERFORM is PL/pgSQL-only, so at
-- top level we discard the JSONB result with a plain SELECT.
SELECT public.submit_exercise_attempt(
  'a3000000-0000-0000-0000-000000000003',
  'e2000000-0000-0000-0000-000000000001',
  '[{"questionId":"e3000000-0000-0000-0000-000000000001","choice":"b"},
    {"questionId":"e3000000-0000-0000-0000-000000000002","choice":"b"},
    {"questionId":"e3000000-0000-0000-0000-000000000003","choice":"b"},
    {"questionId":"e3000000-0000-0000-0000-000000000004","choice":"b"},
    {"questionId":"e3000000-0000-0000-0000-000000000005","choice":"b"}]'::jsonb
);

SELECT is(
  (SELECT count(*)::int FROM public.spaced_repetition_schedule
     WHERE user_id = 'f3333333-3333-3333-3333-333333333333'
       AND exercise_id = 'e2000000-0000-0000-0000-000000000001'
       AND status = 'pending'),
  3,
  'a <60% fail schedules the 3 spaced-repetition retries (1/3/7 days)'
);

RESET ROLE;

-- =========================================================
-- CASE 4 — an ARMED retry shield suppresses the spaced-rep penalty.
-- =========================================================
INSERT INTO auth.users (id, email)
VALUES ('f4444444-4444-4444-4444-444444444444', 'score-shield@test.local');

-- A shield shop item + an armed inventory row for this user.
INSERT INTO public.shop_items (id, code, name, description, price_coins, item_type, effect_payload)
VALUES ('b1000000-0000-0000-0000-000000000001', 'shield_retry_test', 'Retry Shield',
        'refaire sans penalite', 100, 'shield', '{"retries":1}'::jsonb)
ON CONFLICT (code) DO NOTHING;

INSERT INTO public.inventory_items (student_user_id, shop_item_id, quantity, is_active)
VALUES ('f4444444-4444-4444-4444-444444444444',
        'b1000000-0000-0000-0000-000000000001', 1, true);

INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('a4000000-0000-0000-0000-000000000004',
        'f4444444-4444-4444-4444-444444444444',
        'e2000000-0000-0000-0000-000000000001',
        clock_timestamp() - INTERVAL '120 seconds');

SET LOCAL "request.jwt.claims" = '{"sub":"f4444444-4444-4444-4444-444444444444","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- All-wrong again → fail branch, but the armed shield must suppress the schedule.
SELECT is(
  (
    SELECT (public.submit_exercise_attempt(
      'a4000000-0000-0000-0000-000000000004',
      'e2000000-0000-0000-0000-000000000001',
      '[{"questionId":"e3000000-0000-0000-0000-000000000001","choice":"b"},
        {"questionId":"e3000000-0000-0000-0000-000000000002","choice":"b"},
        {"questionId":"e3000000-0000-0000-0000-000000000003","choice":"b"},
        {"questionId":"e3000000-0000-0000-0000-000000000004","choice":"b"},
        {"questionId":"e3000000-0000-0000-0000-000000000005","choice":"b"}]'::jsonb
    ) ->> 'retryShieldUsed')::boolean
  ),
  true,
  'retry shield: an armed shield reports retryShieldUsed on a <60% fail'
);

SELECT is_empty(
  $$ SELECT 1 FROM public.spaced_repetition_schedule
       WHERE user_id = 'f4444444-4444-4444-4444-444444444444'
         AND exercise_id = 'e2000000-0000-0000-0000-000000000001'
         AND status = 'pending' $$,
  'retry shield: the spaced-repetition penalty is SUPPRESSED (no rows scheduled)'
);

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
