-- =========================================================
-- Duels — forfeit_duel (étude 05 follow-up).
-- A participant closes an ACTIVE duel on demand: it settles via finalize_duel
-- (a finisher wins by forfait vs a no-show opponent; a non-finisher gets
-- nothing) and leaves 'active', freeing the DUEL_MAX_ACTIVE cap. A non-
-- participant cannot forfeit someone else's duel.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(5);

-- Fixtures: theme/parcours + three users on it.
INSERT INTO public.themes (id, name_fr, icon, color_token) VALUES
  ('ftheme', 'Forfeit Theme', 'Swords', 'subject-math');
INSERT INTO public.parcours (id, name_fr, kind, theme_id, icon, color) VALUES
  ('fp', 'Forfeit Parcours', 'libre', 'ftheme', 'Swords', 'subject-math');
INSERT INTO auth.users (id, email) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'fa@test.local'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'fb@test.local'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'fc@test.local');
UPDATE public.profiles SET current_parcours_id = 'fp'
  WHERE id IN ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
               'cccccccc-cccc-cccc-cccc-cccccccccccc');

-- An ACTIVE duel where A finished (score 3), B has NOT — a no-show for B.
INSERT INTO public.duels (id, parcours_id, question_ids, status, expires_at) VALUES
  ('d0000000-0000-0000-0000-0000000000f1', 'fp',
   ARRAY['e0000000-0000-0000-0000-000000000001']::uuid[], 'active', now() + INTERVAL '24 hours');
INSERT INTO public.duel_participants (duel_id, user_id, score, finished_at) VALUES
  ('d0000000-0000-0000-0000-0000000000f1', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 3, now()),
  ('d0000000-0000-0000-0000-0000000000f1', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 0, NULL);

-- A non-participant (C) cannot forfeit this duel.
SET LOCAL "request.jwt.claims" = '{"sub":"cccccccc-cccc-cccc-cccc-cccccccccccc","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT throws_ok(
  $$ SELECT public.forfeit_duel('d0000000-0000-0000-0000-0000000000f1') $$,
  'Not a participant of an active duel.',
  'forfeit_duel: a non-participant cannot close the duel');
RESET ROLE;

SELECT is((SELECT status FROM public.duels WHERE id = 'd0000000-0000-0000-0000-0000000000f1'),
  'active', 'the duel is still active after the rejected forfeit');

-- The finisher A forfeits/closes: settles as a win-by-forfait, leaves 'active'.
SET LOCAL "request.jwt.claims" = '{"sub":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT lives_ok(
  $$ SELECT public.forfeit_duel('d0000000-0000-0000-0000-0000000000f1') $$,
  'forfeit_duel: a participant closes their own active duel');
RESET ROLE;

SELECT is((SELECT status FROM public.duels WHERE id = 'd0000000-0000-0000-0000-0000000000f1'),
  'expired', 'the closed duel is no longer active (settled as expired)');
SELECT isnt(
  (SELECT rewarded_at FROM public.duel_participants
   WHERE duel_id = 'd0000000-0000-0000-0000-0000000000f1'
     AND user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  NULL, 'the lone finisher A was rewarded (win by forfait)');

SELECT finish();
ROLLBACK;
