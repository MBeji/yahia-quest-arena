-- =========================================================
-- RLS isolation — a user cannot read another user's private rows.
-- ---------------------------------------------------------
-- `attempts` is self-scoped: "Users select own attempts" USING (auth.uid() =
-- user_id) with no permissive peer policy → user A must NOT see user B's
-- attempts. We assert this under a REAL `SET ROLE authenticated` so RLS is
-- actually enforced (it is bypassed for the table owner / superuser).
--
-- NOTE on `profiles`: the v1 policy "Profiles are viewable by everyone"
-- USING (true) makes profile ROWS world-readable by design (leaderboard, peer
-- display names). The privacy guarantee there is column-level — peer UUIDs are
-- hidden by the leaderboard RPC (see 02_role_escalation: S2(b)) — not row-level.
-- So we assert the REAL contract: a peer's `attempts` (private gameplay data)
-- are invisible, while the profile row remains visible by design.
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

-- Sanity: a direct UPDATE of B's attempt affects zero rows (no peer write).
WITH upd AS (
  UPDATE public.attempts SET xp_earned = 99999
   WHERE user_id = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
  RETURNING 1
)
SELECT is(
  (SELECT count(*)::int FROM upd),
  0,
  'RLS: user A canNOT UPDATE user B''s attempts'
);

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
