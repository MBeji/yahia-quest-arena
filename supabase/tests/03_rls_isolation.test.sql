-- =========================================================
-- RLS isolation — a user cannot read another user's private rows.
-- ---------------------------------------------------------
-- `attempts` is self-scoped: "Users select own attempts" USING (auth.uid() =
-- user_id) with no permissive peer policy → user A must NOT see user B's
-- attempts. We assert this under a REAL `SET ROLE authenticated` so RLS is
-- actually enforced (it is bypassed for the table owner / superuser).
--
-- NOTE on `profiles`: since 20260522153000 the SELECT policy is "Users can view
-- own or linked profiles" (auth.uid() = id OR an active parent/student link), so
-- profile ROWS are NOT peer-readable directly. The leaderboards therefore read
-- through SECURITY DEFINER RPCs (get_global_leaderboard / get_subject_leaderboard)
-- which aggregate across users and expose only public-safe fields + is_me, never a
-- peer UUID (see 02_role_escalation: S2(b)). Here we assert the gameplay contract:
-- a peer's `attempts` (private data) are invisible under a real authenticated role.
-- =========================================================

BEGIN;
-- pgTAP is normally pre-installed by `supabase test db`; create it defensively
-- so the file is self-contained when run via psql too. Idempotent.
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(4);

-- ---------------------------------------------------------
-- Fixtures: two users A and B, each with one attempt, owned by the superuser so
-- RLS does not block the seed. We need a subject + exercise for the FK targets.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'rls-a@test.local'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'rls-b@test.local');

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('rls-subj', 'RLS Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'rls-subj', 'RLS Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward)
VALUES ('dddddddd-dddd-dddd-dddd-dddddddddddd',
        'cccccccc-cccc-cccc-cccc-cccccccccccc', 'rls-subj', 'RLS Exercise', 50);

INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned)
VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'rls-subj', 5, 5, 100, 120, 50),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'rls-subj', 1, 5, 20, 120, 0);

-- ---------------------------------------------------------
-- Become user A. Set claims first (superuser-only), then switch role.
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- A sees their own attempt.
SELECT is(
  (SELECT count(*)::int FROM public.attempts
     WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  1,
  'RLS: user A can read their OWN attempts'
);

-- A cannot see B's attempt: a targeted query for B's row returns nothing.
SELECT is_empty(
  $$ SELECT 1 FROM public.attempts
       WHERE user_id = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb' $$,
  'RLS: user A canNOT read user B''s attempts (self-scoped policy holds)'
);

-- Even an unfiltered scan only ever returns A's own rows.
SELECT is(
  (SELECT count(*)::int FROM public.attempts),
  1,
  'RLS: an unfiltered attempts scan returns ONLY the caller''s rows'
);

-- Sanity: a direct UPDATE on attempts is rejected OUTRIGHT — since
-- 20260610160000_revoke_gameplay_table_writes the client roles have no write
-- grants at all on the gameplay tables (writes are SECURITY DEFINER RPC-only),
-- so this fails with 42501 before RLS even applies.
SELECT throws_ok(
  $$ UPDATE public.attempts SET xp_earned = 99999
       WHERE user_id = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb' $$,
  '42501',
  NULL,
  'grants: a direct UPDATE on attempts is rejected (writes are RPC-only)'
);

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
