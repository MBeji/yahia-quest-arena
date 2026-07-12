-- =========================================================
-- Duels — lot 5 ligues hebdomadaires (étude 05, #lot-5).
-- ---------------------------------------------------------
--   A. duel_league_tier: percentile → tier bands (+ empty-population guard).
--   B. weekly standings: championship points (win 3 / draw 1 / loss 0), rank.
--   C. get_duel_league: the caller's own row (is_me), tier, points.
--   D. award_duel_league_week: idempotent end-of-week coins to the prior week.
--   E. grants: duel_league_awards is owner-SELECT, no client writes.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(18);

INSERT INTO auth.users (id, email) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'lg-a@test.local'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'lg-b@test.local'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'lg-c@test.local');
UPDATE public.profiles SET display_name = 'Alpha' WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa';
UPDATE public.profiles SET display_name = 'Bravo' WHERE id = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb';
UPDATE public.profiles SET display_name = 'Charlie' WHERE id = 'cccccccc-cccc-cccc-cccc-cccccccccccc';

INSERT INTO public.themes (id, name_fr, icon, color_token) VALUES ('lg-th', 'LG', 'Swords', 'subject-math');
INSERT INTO public.parcours (id, name_fr, kind, theme_id, icon, color)
  VALUES ('lg-p', 'LG', 'libre', 'lg-th', 'Swords', 'subject-math');

-- =========================================================
-- A. duel_league_tier bands.
-- =========================================================
SELECT is(public.duel_league_tier(1, 10), 'diamond', 'tier: rank 1/10 → diamond (≤10%)');
SELECT is(public.duel_league_tier(2, 10), 'platinum', 'tier: rank 2/10 → platinum (≤25%)');
SELECT is(public.duel_league_tier(4, 10), 'gold', 'tier: rank 4/10 → gold (≤50%)');
SELECT is(public.duel_league_tier(7, 10), 'silver', 'tier: rank 7/10 → silver (≤75%)');
SELECT is(public.duel_league_tier(9, 10), 'bronze', 'tier: rank 9/10 → bronze');
SELECT is(public.duel_league_tier(1, 0), 'bronze', 'tier: empty population → bronze (guard)');

-- =========================================================
-- B. Weekly standings (CURRENT week). D1: A beats B; D2: A draws C.
--    A: 3 + 1 = 4 pts, 1 win, 2 played · C: 1 pt · B: 0 pt.
-- =========================================================
INSERT INTO public.duels (id, parcours_id, question_ids, status, created_at, expires_at) VALUES
  ('11110000-0000-0000-0000-000000000001', 'lg-p', '{}'::uuid[], 'finished', now(), now() + INTERVAL '1 hour'),
  ('11110000-0000-0000-0000-000000000002', 'lg-p', '{}'::uuid[], 'finished', now(), now() + INTERVAL '1 hour');
INSERT INTO public.duel_participants (duel_id, user_id, score, finished_at) VALUES
  ('11110000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 3, now()),
  ('11110000-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 1, now()),
  ('11110000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 2, now()),
  ('11110000-0000-0000-0000-000000000002', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 2, now());

SELECT is(
  (SELECT points FROM public.duel_league_standings(public.app_current_week_start())
     WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  4, 'standings: a unique win (3) + a draw (1) = 4 points');
SELECT is(
  (SELECT wins FROM public.duel_league_standings(public.app_current_week_start())
     WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  1, 'standings: exactly one win counted');
SELECT is(
  (SELECT points FROM public.duel_league_standings(public.app_current_week_start())
     WHERE user_id = 'cccccccc-cccc-cccc-cccc-cccccccccccc'),
  1, 'standings: a draw is worth 1 point for each player');
SELECT is(
  (SELECT rank FROM public.duel_league_standings(public.app_current_week_start())
     WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  1, 'standings: the top scorer ranks first');

-- =========================================================
-- C. get_duel_league as user A: own row, is_me, tier from rank/total.
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT is(
  (SELECT points FROM public.get_duel_league(20) WHERE is_me),
  4, 'get_duel_league: the caller sees their own points via is_me');
SELECT is(
  (SELECT tier FROM public.get_duel_league(20) WHERE is_me),
  public.duel_league_tier(1, 3),
  'get_duel_league: the caller''s tier matches their rank/total');
RESET ROLE;

-- =========================================================
-- D. award_duel_league_week — PRIOR week (A beats B), idempotent coins.
-- =========================================================
INSERT INTO public.duels (id, parcours_id, question_ids, status, created_at, expires_at) VALUES
  ('22220000-0000-0000-0000-000000000001', 'lg-p', '{}'::uuid[], 'finished',
   (public.app_current_week_start()::timestamptz - INTERVAL '3 days'), now() + INTERVAL '1 hour');
INSERT INTO public.duel_participants (duel_id, user_id, score, finished_at) VALUES
  ('22220000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 3, now()),
  ('22220000-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 0, now());

SELECT is(public.award_duel_league_week() >= 2, true,
  'award: the prior week grants both players (≥2 rows)');
SELECT is(
  (SELECT coins_awarded FROM public.duel_league_awards
     WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  public.duel_league_tier_coins(public.duel_league_tier(1, 2)),
  'award: the winner gets their tier''s coins in the ledger');
SELECT is(
  (SELECT yahia_coins FROM public.profiles WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  public.duel_league_tier_coins(public.duel_league_tier(1, 2)),
  'award: the winner''s coin balance is credited');
SELECT is(public.award_duel_league_week(), 0,
  'award: a second run for the same week is idempotent (0 new grants)');

-- =========================================================
-- E. Grants: the ledger is owner-SELECT, no client writes.
-- =========================================================
SELECT is(has_table_privilege('authenticated', 'public.duel_league_awards', 'SELECT'), true,
  'duel_league_awards: authenticated may SELECT (own rows via RLS)');
SELECT is(
  has_table_privilege('authenticated', 'public.duel_league_awards', 'INSERT')
    OR has_table_privilege('authenticated', 'public.duel_league_awards', 'UPDATE')
    OR has_table_privilege('authenticated', 'public.duel_league_awards', 'DELETE'),
  false, 'duel_league_awards: no client writes (award job only)');

SELECT * FROM finish();
ROLLBACK;
