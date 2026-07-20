-- =========================================================
-- get_user_subject_stats — per-subject aggregate for the dashboard (audit M4).
-- ---------------------------------------------------------
-- The RPC replaces "fetch the user's entire attempt history and reduce in JS"
-- with a GROUP BY scoped to (SELECT auth.uid()). Assert it aggregates correctly
-- under a real authenticated role and stays self-scoped.
-- =========================================================

-- Espace de noms des fixtures : le prefixe `7e57…` est reserve aux tests et n'apparait
-- dans aucune migration. Ces ids ont ete deplaces le 2026-07-20 : ils entraient en
-- collision avec des lignes de contenu HERITEES que les migrations generees effacaient
-- autrefois par leur prune par matiere. Ces migrations ayant quitte le repo public
-- (etude 24 lot 4), les lignes heritees survivent sur une base fraiche et la fixture
-- se cognait dedans (duplicate key).
BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(4);

-- Fixtures: two subjects, one exercise each, a user with 3 attempts (2 on s1).
INSERT INTO auth.users (id, email) VALUES
  ('e5555555-5555-5555-5555-555555555555', 'stats-a@test.local'),
  ('e6666666-6666-6666-6666-666666666666', 'stats-b@test.local');

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id) VALUES
  ('stats-s1', 'S1', 'Esprit', 'subject-math', 'Brain', 'ecole-tn'),
  ('stats-s2', 'S2', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title) VALUES
  ('7e571301-0000-0000-0000-000000000001', 'stats-s1', 'Ch1'),
  ('7e571302-0000-0000-0000-000000000002', 'stats-s2', 'Ch2');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward) VALUES
  ('7e571303-0000-0000-0000-000000000001', '7e571301-0000-0000-0000-000000000001', 'stats-s1', 'E1', 50),
  ('7e571304-0000-0000-0000-000000000002', '7e571302-0000-0000-0000-000000000002', 'stats-s2', 'E2', 50);

INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned)
VALUES
  ('e5555555-5555-5555-5555-555555555555', '7e571303-0000-0000-0000-000000000001', 'stats-s1', 4, 5, 80, 120, 50),
  ('e5555555-5555-5555-5555-555555555555', '7e571303-0000-0000-0000-000000000001', 'stats-s1', 3, 5, 60, 120, 30),
  ('e5555555-5555-5555-5555-555555555555', '7e571304-0000-0000-0000-000000000002', 'stats-s2', 5, 5, 100, 120, 40),
  -- A different user's attempt must NOT leak into A's stats.
  ('e6666666-6666-6666-6666-666666666666', '7e571303-0000-0000-0000-000000000001', 'stats-s1', 5, 5, 100, 120, 99);

SET LOCAL "request.jwt.claims" = '{"sub":"e5555555-5555-5555-5555-555555555555","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- s1: 2 attempts, avg (80+60)/2 = 70, xp 50+30 = 80.
SELECT is(
  (SELECT attempts_count FROM public.get_user_subject_stats() WHERE subject_id = 'stats-s1'),
  2,
  'get_user_subject_stats: s1 counts the caller''s 2 attempts (not the peer''s)'
);
SELECT is(
  (SELECT avg_score::int FROM public.get_user_subject_stats() WHERE subject_id = 'stats-s1'),
  70,
  'get_user_subject_stats: s1 average score is (80+60)/2 = 70'
);
SELECT is(
  (SELECT total_xp FROM public.get_user_subject_stats() WHERE subject_id = 'stats-s1'),
  80::bigint,
  'get_user_subject_stats: s1 total xp is 50+30 = 80'
);

-- Exactly two subject rows for this caller (s1, s2) — the peer's row is excluded.
SELECT is(
  (SELECT count(*)::int FROM public.get_user_subject_stats()),
  2,
  'get_user_subject_stats: returns one row per subject, self-scoped to the caller'
);

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
