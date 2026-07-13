-- =========================================================
-- Moteur adaptatif A0 — telemetry schema (étude 04, lot A0.1).
-- ---------------------------------------------------------
--   1. R-1/D-1: questions.distractor_tags is invisible to client roles
--      (the column-grant whitelist on questions never includes it);
--   2. question_attempts / user_misconceptions: client roles are SELECT-only
--      (writes are SECURITY DEFINER RPC-only — lot A0.2), anon sees nothing;
--   3. RLS isolation: a user reads ONLY their own telemetry and aggregates;
--   4. the aggregate trigger: occurrences, ≥2-sessions counting (R-2 feed),
--      last_seen_at monotonicity, tag independence, NULL-tag no-op;
--   5. the `source` CHECK rejects unknown sources.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(20);

-- ---------------------------------------------------------
-- Fixtures (superuser: RLS bypassed for the seed).
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'telemetry-a@test.local'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'telemetry-b@test.local');

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('a0-subj', 'A0 Telemetry Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('a0100000-0000-0000-0000-000000000001', 'a0-subj', 'A0 Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode)
VALUES ('a0200000-0000-0000-0000-000000000001',
        'a0100000-0000-0000-0000-000000000001', 'a0-subj',
        'A0 Exercise', 'admin', 'practice');

INSERT INTO public.questions
  (id, exercise_id, prompt, options, correct_option, display_order, distractor_tags)
VALUES ('a0300000-0000-0000-0000-000000000001',
        'a0200000-0000-0000-0000-000000000001',
        '1/2 + 1/3 = ?',
        '[{"id":"a","text":"5/6"},{"id":"b","text":"2/5"}]'::jsonb,
        'a', 1,
        '{"b": "math.frac.add-denominators"}'::jsonb);

-- =========================================================
-- 1–3. D-1/R-1: distractor_tags stays server-only; the whitelist is intact.
-- =========================================================
SELECT is(
  has_column_privilege('anon', 'public.questions', 'distractor_tags', 'SELECT'),
  false,
  'R-1: anon cannot SELECT questions.distractor_tags'
);

SELECT is(
  has_column_privilege('authenticated', 'public.questions', 'distractor_tags', 'SELECT'),
  false,
  'R-1: authenticated cannot SELECT questions.distractor_tags'
);

SELECT is(
  has_column_privilege('authenticated', 'public.questions', 'options', 'SELECT'),
  true,
  'sanity: the questions column whitelist (options, …) is untouched'
);

-- =========================================================
-- 4–10. Grants: telemetry is SELECT-only for authenticated, invisible to anon.
-- =========================================================
SELECT is(
  has_table_privilege('authenticated', 'public.question_attempts', 'SELECT'),
  true,
  'question_attempts: authenticated may SELECT (own rows via RLS)'
);

SELECT is(
  has_table_privilege('authenticated', 'public.question_attempts', 'INSERT'),
  false,
  'question_attempts: authenticated has NO direct INSERT (RPC-only writes)'
);

SELECT is(
  has_table_privilege('authenticated', 'public.question_attempts', 'UPDATE')
    OR has_table_privilege('authenticated', 'public.question_attempts', 'DELETE'),
  false,
  'question_attempts: append-only — no client UPDATE/DELETE'
);

SELECT is(
  has_table_privilege('anon', 'public.question_attempts', 'SELECT'),
  false,
  'question_attempts: anon sees nothing'
);

SELECT is(
  has_table_privilege('authenticated', 'public.user_misconceptions', 'SELECT'),
  true,
  'user_misconceptions: authenticated may SELECT (own rows via RLS)'
);

SELECT is(
  has_table_privilege('authenticated', 'public.user_misconceptions', 'INSERT')
    OR has_table_privilege('authenticated', 'public.user_misconceptions', 'UPDATE')
    OR has_table_privilege('authenticated', 'public.user_misconceptions', 'DELETE'),
  false,
  'user_misconceptions: trigger-only writes — no client write grants'
);

SELECT is(
  has_table_privilege('anon', 'public.user_misconceptions', 'SELECT'),
  false,
  'user_misconceptions: anon sees nothing'
);

-- =========================================================
-- 11. The source CHECK rejects unknown sources.
-- =========================================================
SELECT throws_ok(
  $$ INSERT INTO public.question_attempts
       (user_id, question_id, chapter_id, session_id, choice, is_correct, source)
     VALUES ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
             'a0300000-0000-0000-0000-000000000001',
             'a0100000-0000-0000-0000-000000000001',
             'e0000000-0000-0000-0000-000000000001', 'b', false, 'telepathy') $$,
  '23514',
  NULL,
  'question_attempts: an unknown source violates the CHECK'
);

-- =========================================================
-- 12–16. Aggregate trigger. User A: same tag in session s1 (×2) then s2 (×1),
-- a second tag, and an untagged (correct) attempt. User B: one tagged attempt.
-- =========================================================
INSERT INTO public.question_attempts
  (user_id, question_id, chapter_id, session_id, choice, is_correct, misconception_tag, source, created_at)
VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'a0300000-0000-0000-0000-000000000001',
   'a0100000-0000-0000-0000-000000000001', 'e0000000-0000-0000-0000-0000000000a1',
   'b', false, 'math.frac.add-denominators', 'exercise', '2026-07-01T10:00:00Z'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'a0300000-0000-0000-0000-000000000001',
   'a0100000-0000-0000-0000-000000000001', 'e0000000-0000-0000-0000-0000000000a1',
   'b', false, 'math.frac.add-denominators', 'exercise', '2026-07-01T10:05:00Z'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'a0300000-0000-0000-0000-000000000001',
   'a0100000-0000-0000-0000-000000000001', 'e0000000-0000-0000-0000-0000000000a2',
   'b', false, 'math.frac.add-denominators', 'quiz', '2026-07-02T09:00:00Z'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'a0300000-0000-0000-0000-000000000001',
   'a0100000-0000-0000-0000-000000000001', 'e0000000-0000-0000-0000-0000000000a2',
   'b', false, 'math.dec.compare-by-length', 'quiz', '2026-07-02T09:01:00Z'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'a0300000-0000-0000-0000-000000000001',
   'a0100000-0000-0000-0000-000000000001', 'e0000000-0000-0000-0000-0000000000a2',
   'a', true, NULL, 'quiz', '2026-07-02T09:02:00Z'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'a0300000-0000-0000-0000-000000000001',
   'a0100000-0000-0000-0000-000000000001', 'e0000000-0000-0000-0000-0000000000b3',
   'b', false, 'math.frac.add-denominators', 'dungeon', '2026-07-02T11:00:00Z');

SELECT is(
  (SELECT occurrences FROM public.user_misconceptions
     WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
       AND tag = 'math.frac.add-denominators'),
  3,
  'trigger: occurrences counts every tagged attempt'
);

SELECT is(
  (SELECT sessions_seen FROM public.user_misconceptions
     WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
       AND tag = 'math.frac.add-denominators'),
  2,
  'trigger: sessions_seen counts DISTINCT sessions (R-2 feed), not attempts'
);

SELECT is(
  (SELECT last_seen_at FROM public.user_misconceptions
     WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
       AND tag = 'math.frac.add-denominators'),
  '2026-07-02T09:00:00Z'::timestamptz,
  'trigger: last_seen_at tracks the most recent tagged attempt'
);

SELECT is(
  (SELECT count(*)::int FROM public.user_misconceptions
     WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  2,
  'trigger: each tag aggregates independently; untagged attempts add no row'
);

SELECT is(
  (SELECT sessions_seen FROM public.user_misconceptions
     WHERE user_id = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
       AND tag = 'math.frac.add-denominators'),
  1,
  'trigger: aggregates are per-user (B has their own row)'
);

-- =========================================================
-- 17–20. RLS isolation under a REAL authenticated role (user A).
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.question_attempts),
  5,
  'RLS: an unfiltered question_attempts scan returns ONLY the caller''s rows'
);

SELECT is_empty(
  $$ SELECT 1 FROM public.question_attempts
       WHERE user_id = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb' $$,
  'RLS: user A canNOT read user B''s telemetry'
);

SELECT is(
  (SELECT count(*)::int FROM public.user_misconceptions),
  2,
  'RLS: an unfiltered user_misconceptions scan returns ONLY the caller''s rows'
);

SELECT is_empty(
  $$ SELECT 1 FROM public.user_misconceptions
       WHERE user_id = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb' $$,
  'RLS: user A canNOT read user B''s misconception profile'
);

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
