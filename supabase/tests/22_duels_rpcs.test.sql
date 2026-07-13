-- =========================================================
-- Duels — lot 2 RPCs (étude 05, FableEtudes/05-duels-ligues #lot-2).
-- ---------------------------------------------------------
--   A. match_duel: pairs two waiters of the SAME parcours (R-1), freezes a
--      5-question shared set (R-2), empties their queue rows; a third player on
--      another parcours stays queued.
--   B. submit_duel_answer: ordered scoring via score_answer, R-6 (no key echoed
--      mid-duel), settlement when both finish, win/loss rewards (R-8 floor).
--   C. R-5: an answer under the 4s floor is counted wrong.
--   D. expiry: a lone finisher wins by forfait, the no-show earns nothing (R-9).
--   E. R-7: beyond the daily rewarded-duel cap a finished duel pays nothing.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(21);

-- ---------------------------------------------------------
-- Content pool: a theme + libre parcours (grade NULL) + a non-quiz exercise
-- with 6 mcq questions (correct 'a'). A second theme/parcours for the R-1 case.
-- ---------------------------------------------------------
INSERT INTO public.themes (id, name_fr, icon, color_token) VALUES
  ('dtheme', 'Duel Theme', 'Swords', 'subject-math'),
  ('dtheme2', 'Duel Theme 2', 'Swords', 'subject-math');
INSERT INTO public.parcours (id, name_fr, kind, theme_id, icon, color) VALUES
  ('dp', 'Duel Parcours', 'libre', 'dtheme', 'Swords', 'subject-math'),
  ('dq', 'Duel Parcours 2', 'libre', 'dtheme2', 'Swords', 'subject-math');
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id) VALUES
  ('dsubj', 'Duel Subject', 'Esprit', 'subject-math', 'Brain', 'dtheme');
INSERT INTO public.chapters (id, subject_id, title)
  VALUES ('e0000000-0000-0000-0000-0000000000c1', 'dsubj', 'Duel Chapter');
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode)
  VALUES ('e0000000-0000-0000-0000-0000000000e1',
          'e0000000-0000-0000-0000-0000000000c1', 'dsubj', 'Duel Exercise', 'admin', 'practice');
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
SELECT ('e0000000-0000-0000-0000-00000000000' || g)::uuid,
       'e0000000-0000-0000-0000-0000000000e1', 'Q' || g,
       '[{"id":"a","text":"right"},{"id":"b","text":"wrong"}]'::jsonb, 'a', g
FROM generate_series(1, 6) AS g;

-- Users (handle_new_user auto-creates their profiles); set active parcours.
INSERT INTO auth.users (id, email) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'da@test.local'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'db@test.local'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'dc@test.local'),
  ('dddddddd-dddd-dddd-dddd-dddddddddddd', 'dd@test.local'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'de@test.local');
UPDATE public.profiles SET current_parcours_id = 'dp'
  WHERE id IN ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
               'dddddddd-dddd-dddd-dddd-dddddddddddd', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee');
UPDATE public.profiles SET current_parcours_id = 'dq'
  WHERE id = 'cccccccc-cccc-cccc-cccc-cccccccccccc';

-- =========================================================
-- A. match_duel — pairing + R-1 + R-2.
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT is(public.match_duel(), NULL, 'match_duel: first caller (A) is enqueued, no match yet');
RESET ROLE;

SET LOCAL "request.jwt.claims" = '{"sub":"cccccccc-cccc-cccc-cccc-cccccccccccc","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT is(public.match_duel(), NULL, 'match_duel: C (other parcours) is enqueued, does not pair with A (R-1)');
RESET ROLE;

SET LOCAL "request.jwt.claims" = '{"sub":"bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT set_config('test.duel', public.match_duel()::text, true);
RESET ROLE;

SELECT isnt(current_setting('test.duel'), '', 'match_duel: B pairs with A → a duel id is returned');
SELECT is((SELECT count(*)::int FROM public.duels), 1, 'exactly one duel was created');
SELECT is(
  (SELECT count(*)::int FROM public.duel_participants
     WHERE duel_id = current_setting('test.duel')::uuid), 2,
  'the duel has two participants (A and B)');
SELECT is(
  (SELECT array_length(question_ids, 1) FROM public.duels
     WHERE id = current_setting('test.duel')::uuid), 5,
  'R-2: the frozen set has DUEL_QUESTION_COUNT (5) questions');
SELECT is(
  (SELECT string_agg(user_id::text, ',' ORDER BY user_id) FROM public.duel_queue),
  'cccccccc-cccc-cccc-cccc-cccccccccccc',
  'the paired players left the queue; only C (unmatched) remains');

-- =========================================================
-- B. submit_duel_answer — scoring, R-6, settlement, rewards.
-- A hand-built 3-question duel between D and E; created 1 min ago so answers
-- clear the 4s anti-rush floor. D answers all right (3), E two right (2).
-- =========================================================
INSERT INTO public.duels (id, parcours_id, question_ids, status, created_at, expires_at)
VALUES ('df000000-0000-0000-0000-000000000001', 'dp',
        ARRAY['e0000000-0000-0000-0000-000000000001'::uuid,
              'e0000000-0000-0000-0000-000000000002'::uuid,
              'e0000000-0000-0000-0000-000000000003'::uuid],
        'active', now() - INTERVAL '60 seconds', now() + INTERVAL '24 hours');
INSERT INTO public.duel_participants (duel_id, user_id) VALUES
  ('df000000-0000-0000-0000-000000000001', 'dddddddd-dddd-dddd-dddd-dddddddddddd'),
  ('df000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee');

-- Helper convention: the manual backdate UPDATEs (simulating human pacing so
-- consecutive answers clear the 4s floor) run as the SUPERUSER test owner; only
-- the submit_duel_answer / get_duel_state calls run under the authenticated role.

-- R-6: mid-duel, get_duel_state exposes NO review.
SET LOCAL "request.jwt.claims" = '{"sub":"dddddddd-dddd-dddd-dddd-dddddddddddd","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT is(
  public.get_duel_state('df000000-0000-0000-0000-000000000001') ->> 'review', NULL,
  'R-6: the review is hidden while the duel is active');
-- D answers Q1 (baseline = created_at 60s ago → not too fast).
SELECT public.submit_duel_answer('df000000-0000-0000-0000-000000000001',
  'e0000000-0000-0000-0000-000000000001', 'a');
RESET ROLE;

-- Backdate Q1's ts so Q2 clears the floor.
UPDATE public.duel_participants
  SET answers_submitted_at = ARRAY[clock_timestamp() - INTERVAL '10 seconds']
  WHERE duel_id = 'df000000-0000-0000-0000-000000000001'
    AND user_id = 'dddddddd-dddd-dddd-dddd-dddddddddddd';

SET LOCAL "request.jwt.claims" = '{"sub":"dddddddd-dddd-dddd-dddd-dddddddddddd","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT is(
  public.submit_duel_answer('df000000-0000-0000-0000-000000000001',
    'e0000000-0000-0000-0000-000000000002', 'a') ->> 'answered', '2',
  'submit_duel_answer: returns the running answered count');
-- Out of order: D has answered Q1+Q2 (next expected = Q3); re-submitting Q1 throws.
SELECT throws_ok(
  $$ SELECT public.submit_duel_answer('df000000-0000-0000-0000-000000000001',
       'e0000000-0000-0000-0000-000000000001', 'a') $$,
  NULL, NULL, 'submit_duel_answer: rejects an out-of-order / replayed question');
RESET ROLE;

-- Backdate so D's Q3 clears the floor, then D finishes (score 3/3).
UPDATE public.duel_participants
  SET answers_submitted_at = ARRAY[clock_timestamp() - INTERVAL '20 seconds',
                                   clock_timestamp() - INTERVAL '10 seconds']
  WHERE duel_id = 'df000000-0000-0000-0000-000000000001'
    AND user_id = 'dddddddd-dddd-dddd-dddd-dddddddddddd';
SET LOCAL "request.jwt.claims" = '{"sub":"dddddddd-dddd-dddd-dddd-dddddddddddd","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT is(
  public.submit_duel_answer('df000000-0000-0000-0000-000000000001',
    'e0000000-0000-0000-0000-000000000003', 'a') ->> 'finished', 'true',
  'submit_duel_answer: the last answer finishes the player');
RESET ROLE;

-- E: Q1 right, then Q2 right, then Q3 WRONG → score 2. Backdate between answers.
SET LOCAL "request.jwt.claims" = '{"sub":"eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT public.submit_duel_answer('df000000-0000-0000-0000-000000000001',
  'e0000000-0000-0000-0000-000000000001', 'a');
RESET ROLE;
UPDATE public.duel_participants
  SET answers_submitted_at = ARRAY[clock_timestamp() - INTERVAL '10 seconds']
  WHERE duel_id = 'df000000-0000-0000-0000-000000000001'
    AND user_id = 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee';
SET LOCAL "request.jwt.claims" = '{"sub":"eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT public.submit_duel_answer('df000000-0000-0000-0000-000000000001',
  'e0000000-0000-0000-0000-000000000002', 'a');
RESET ROLE;
UPDATE public.duel_participants
  SET answers_submitted_at = ARRAY[clock_timestamp() - INTERVAL '20 seconds',
                                   clock_timestamp() - INTERVAL '10 seconds']
  WHERE duel_id = 'df000000-0000-0000-0000-000000000001'
    AND user_id = 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee';
SET LOCAL "request.jwt.claims" = '{"sub":"eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT public.submit_duel_answer('df000000-0000-0000-0000-000000000001',
  'e0000000-0000-0000-0000-000000000003', 'b');  -- wrong
RESET ROLE;

-- Both finished → auto-finalized.
SELECT is((SELECT status FROM public.duels WHERE id = 'df000000-0000-0000-0000-000000000001'),
  'finished', 'the duel auto-finalizes once both players finish');
SELECT is((SELECT score FROM public.duel_participants
  WHERE duel_id = 'df000000-0000-0000-0000-000000000001'
    AND user_id = 'dddddddd-dddd-dddd-dddd-dddddddddddd'), 3, 'winner D scored 3/3');
SELECT is((SELECT xp FROM public.profiles WHERE id = 'dddddddd-dddd-dddd-dddd-dddddddddddd'),
  60, 'R-1 reward: the winner earns the win XP (60)');
SELECT is((SELECT xp FROM public.profiles WHERE id = 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee'),
  20, 'R-8 floor: the loser earns the participation XP (20), never negative');

-- R-6: after settlement, the review is exposed to a participant.
SET LOCAL "request.jwt.claims" = '{"sub":"dddddddd-dddd-dddd-dddd-dddddddddddd","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT isnt(
  public.get_duel_state('df000000-0000-0000-0000-000000000001') ->> 'review', NULL,
  'R-6: the review appears once the duel is finished');
RESET ROLE;

-- =========================================================
-- D. expiry — a lone finisher wins by forfait (R-9).
-- =========================================================
INSERT INTO public.duels (id, parcours_id, question_ids, status, created_at, expires_at)
VALUES ('df000000-0000-0000-0000-000000000002', 'dp',
        ARRAY['e0000000-0000-0000-0000-000000000001'::uuid], 'active',
        now() - INTERVAL '30 hours', now() - INTERVAL '6 hours');  -- already expired
INSERT INTO public.duel_participants (duel_id, user_id, score, finished_at) VALUES
  ('df000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 1, now() - INTERVAL '7 hours'),
  ('df000000-0000-0000-0000-000000000002', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 0, NULL);
SELECT is(public.expire_duels() >= 1, true, 'expire_duels: sweeps at least the expired duel');
SELECT is((SELECT status FROM public.duels WHERE id = 'df000000-0000-0000-0000-000000000002'),
  'expired', 'R-9: an overdue duel becomes expired');
SELECT is((SELECT rewarded_at IS NOT NULL FROM public.duel_participants
  WHERE duel_id = 'df000000-0000-0000-0000-000000000002'
    AND user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'), true,
  'R-9: the lone finisher is rewarded (forfait win)');
SELECT is((SELECT rewarded_at IS NULL FROM public.duel_participants
  WHERE duel_id = 'df000000-0000-0000-0000-000000000002'
    AND user_id = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'), true,
  'R-9: the no-show earns nothing');

-- =========================================================
-- E. R-7 — daily rewarded-duel cap. Pre-seed 5 rewarded rows today for user D,
-- then finalize a 6th finished duel → no further reward.
-- =========================================================
INSERT INTO public.duels (id, parcours_id, question_ids, status, expires_at)
SELECT ('dfa00000-0000-0000-0000-00000000000' || g)::uuid, 'dp',
       ARRAY['e0000000-0000-0000-0000-000000000001'::uuid], 'finished', now() + INTERVAL '1 hour'
FROM generate_series(1, 5) AS g;
INSERT INTO public.duel_participants (duel_id, user_id, score, finished_at, rewarded_at)
SELECT ('dfa00000-0000-0000-0000-00000000000' || g)::uuid,
       'dddddddd-dddd-dddd-dddd-dddddddddddd', 1, now(), now()
FROM generate_series(1, 5) AS g;

INSERT INTO public.duels (id, parcours_id, question_ids, status, expires_at)
VALUES ('dfb00000-0000-0000-0000-000000000001', 'dp',
        ARRAY['e0000000-0000-0000-0000-000000000001'::uuid], 'active', now() + INTERVAL '1 hour');
INSERT INTO public.duel_participants (duel_id, user_id, score, finished_at) VALUES
  ('dfb00000-0000-0000-0000-000000000001', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 1, now()),
  ('dfb00000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 0, now());
SELECT public.finalize_duel('dfb00000-0000-0000-0000-000000000001');
SELECT is((SELECT rewarded_at IS NULL FROM public.duel_participants
  WHERE duel_id = 'dfb00000-0000-0000-0000-000000000001'
    AND user_id = 'dddddddd-dddd-dddd-dddd-dddddddddddd'), true,
  'R-7: beyond the daily cap a finished duel grants no reward');

SELECT * FROM finish();
ROLLBACK;
