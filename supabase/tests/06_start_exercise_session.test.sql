-- =========================================================
-- start_exercise_session — server-authoritative quest start (GAP-021 Part 2).
-- ---------------------------------------------------------
-- Regression guard for the 2026-06-12 hotfix (GAP-026): the RPC declares OUT
-- parameters (session_id, started_at) via RETURNS TABLE, and its final
-- INSERT ... RETURNING referenced a BARE `started_at` that matched BOTH the
-- exercise_sessions column AND the OUT parameter -> PL/pgSQL raised SQLSTATE 42702
-- ("column reference started_at is ambiguous") on EVERY call. With the companion
-- REVOKE (20260610190000) removing the direct-INSERT fallback, this broke
-- quest-start entirely in production. Mocked JS unit tests could not catch it
-- (they stub supabase.rpc); only executing the real SQL does.
--
-- This file exercises the happy path end-to-end as an `authenticated` user. Against
-- the pre-hotfix function the first statement ERRORS (42702) and the whole file
-- aborts -> CI (db-tests.yml) goes red. Against the fixed function all 3 pass.
--
-- Fixture: an isolated theme with NO parcours mapping (resolve_exercise_access then
-- returns allowed=true) and a grade-less subject (so the comprehension-quiz gate is
-- skipped) — the minimal setup that reaches the INSERT ... RETURNING. Rolls back.
-- =========================================================

-- Espace de noms des fixtures : le prefixe `7e57…` est reserve aux tests et n'apparait
-- dans aucune migration. Ces ids ont ete deplaces le 2026-07-20 : ils entraient en
-- collision avec des lignes de contenu HERITEES que les migrations generees effacaient
-- autrefois par leur prune par matiere. Ces migrations ayant quitte le repo public
-- (etude 24 lot 4), les lignes heritees survivent sur une base fraiche et la fixture
-- se cognait dedans (duplicate key).
BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(3);

-- Isolated theme: no parcours points at it -> resolve_exercise_access allows.
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades, display_order)
VALUES ('start-sess-theme', 'Start Session Test', 'Brain', 'subject-math', false, 999);

-- Grade-less subject under it -> start_exercise_session skips the quiz gate.
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('start-sess-subj', 'Start Session Subject', 'Esprit', 'subject-math', 'Brain', 'start-sess-theme');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('7e570601-0000-0000-0000-000000000001', 'start-sess-subj', 'Start Session Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward, reward_coins, mode)
VALUES ('c6000000-0000-0000-0000-000000000001',
        '7e570601-0000-0000-0000-000000000001', 'start-sess-subj',
        'Start Session Exercise', 100, 20, 'practice');

INSERT INTO auth.users (id, email)
VALUES ('c7777777-7777-7777-7777-777777777777', 'start-sess@test.local');

SET LOCAL "request.jwt.claims" = '{"sub":"c7777777-7777-7777-7777-777777777777","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- Call the RPC once and stash the returned row as JSON in a txn-local GUC so two
-- assertions can read it. This SELECT is the regression trip-wire: it raises 42702
-- against the broken function.
SELECT set_config(
  'test.start_result',
  (
    SELECT row_to_json(t)::text
    FROM public.start_exercise_session('c6000000-0000-0000-0000-000000000001') AS t
  ),
  true  -- is_local: cleared at transaction end
);

SELECT isnt(
  current_setting('test.start_result')::jsonb ->> 'session_id',
  NULL,
  'start_exercise_session returns a non-null session_id (regression: 42702 ambiguous started_at)'
);

SELECT isnt(
  current_setting('test.start_result')::jsonb ->> 'started_at',
  NULL,
  'start_exercise_session returns a non-null started_at'
);

SELECT is(
  (SELECT count(*)::int FROM public.exercise_sessions
     WHERE user_id = 'c7777777-7777-7777-7777-777777777777'
       AND exercise_id = 'c6000000-0000-0000-0000-000000000001'),
  1,
  'start_exercise_session persists exactly one session for the caller'
);

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
