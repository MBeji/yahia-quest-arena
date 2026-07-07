-- =========================================================
-- Duels — resume-not-pile-up fix (étude 05 follow-up).
-- match_duel returns the caller's own UNFINISHED active duel instead of
-- queuing/creating a new one (pulls a waiting player into their duel, caps
-- unfinished-active duels at one). A caller who already FINISHED their side of
-- an active duel is NOT short-circuited and queues normally.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(4);

-- Fixtures: one theme + libre parcours; two users on it.
INSERT INTO public.themes (id, name_fr, icon, color_token) VALUES
  ('rtheme', 'Resume Theme', 'Swords', 'subject-math');
INSERT INTO public.parcours (id, name_fr, kind, theme_id, icon, color) VALUES
  ('rp', 'Resume Parcours', 'libre', 'rtheme', 'Swords', 'subject-math');
INSERT INTO auth.users (id, email) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'ra@test.local'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'rb@test.local');
UPDATE public.profiles SET current_parcours_id = 'rp'
  WHERE id IN ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb');

-- A has an ACTIVE duel they have NOT finished (finished_at NULL).
INSERT INTO public.duels (id, parcours_id, question_ids, status, expires_at) VALUES
  ('d0000000-0000-0000-0000-0000000000d1', 'rp',
   ARRAY['e0000000-0000-0000-0000-000000000001']::uuid[], 'active', now() + INTERVAL '24 hours');
INSERT INTO public.duel_participants (duel_id, user_id) VALUES
  ('d0000000-0000-0000-0000-0000000000d1', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa');

-- B has an ACTIVE duel where B already FINISHED their side (finished_at set).
INSERT INTO public.duels (id, parcours_id, question_ids, status, expires_at) VALUES
  ('d0000000-0000-0000-0000-0000000000d2', 'rp',
   ARRAY['e0000000-0000-0000-0000-000000000001']::uuid[], 'active', now() + INTERVAL '24 hours');
INSERT INTO public.duel_participants (duel_id, user_id, finished_at) VALUES
  ('d0000000-0000-0000-0000-0000000000d2', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', now());

-- A. Caller A resumes their unfinished active duel.
SET LOCAL "request.jwt.claims" = '{"sub":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT is(public.match_duel(), 'd0000000-0000-0000-0000-0000000000d1'::uuid,
  'match_duel: caller with an unfinished active duel gets that duel back (resume, no new duel)');
RESET ROLE;

SELECT is((SELECT count(*)::int FROM public.duels), 2,
  'no extra duel was created by the resume');
SELECT is((SELECT count(*)::int FROM public.duel_queue
           WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'), 0,
  'the resumed caller is not left in the queue');

-- B. Caller B (finished their side) is NOT short-circuited: they queue normally
--    (no opponent waiting → NULL, and a queue row now exists).
SET LOCAL "request.jwt.claims" = '{"sub":"bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT is(public.match_duel(), NULL,
  'match_duel: a caller who already finished their side queues for a new duel (not short-circuited)');
RESET ROLE;

SELECT finish();
ROLLBACK;
