-- =========================================================
-- Knowledge graph — per-competency mastery (étude 07, lot 2).
-- ---------------------------------------------------------
--   1. Grants/RLS: SELECT-only for authenticated, nothing for anon, writes
--      are trigger-only; helper functions are not client-executable;
--   2. EWMA (R-4): the difficulty × outcome matrix, first-contact baseline 50,
--      compounding, attempts counter, 1..3 competencies per question,
--      untagged questions stay neutral, bounds hold;
--   3. Forgetting (R-4): −1 pt/week idle, floored at 30, never RAISES a
--      mastery already below the floor;
--   4. RLS (R-6): owner reads own; an ACTIVE linked parent reads their child;
--      an inactive link and an unrelated user read nothing.
--
-- Schema + behaviour only — every competency/question row is a fixture created
-- INSIDE this transaction, so the suite is independent of the content corpus
-- (which lives in the yahia-quest-content repo since étude 24).
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(24);

-- ---------------------------------------------------------
-- Fixtures (superuser: RLS bypassed for the seed).
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('cc000000-0000-0000-0000-0000000000a1', 'mastery-student-a@test.local'),
  ('cc000000-0000-0000-0000-0000000000b2', 'mastery-student-b@test.local'),
  ('cc000000-0000-0000-0000-0000000000c3', 'mastery-parent@test.local');

-- An ACTIVE link parent→A, and an INACTIVE link parent→B (negative control).
INSERT INTO public.parent_student_links (parent_user_id, student_user_id, is_active) VALUES
  ('cc000000-0000-0000-0000-0000000000c3', 'cc000000-0000-0000-0000-0000000000a1', true),
  ('cc000000-0000-0000-0000-0000000000c3', 'cc000000-0000-0000-0000-0000000000b2', false);

-- Two competencies of our own (no corpus dependency).
INSERT INTO public.competencies (id, slug, family, label_fr, label_en, label_ar) VALUES
  ('cc100000-0000-0000-0000-000000000001', 'test.kg.primaire', 'test', 'Primaire', 'Primary', 'أساسية'),
  ('cc100000-0000-0000-0000-000000000002', 'test.kg.secondaire', 'test', 'Secondaire', 'Secondary', 'ثانوية');

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('kg2-subj', 'KG Mastery Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('cc200000-0000-0000-0000-000000000001', 'kg2-subj', 'KG Mastery Chapter');

-- One exercise per difficulty tier so we can drive α (d1 .15 → d4 .30).
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode, difficulty) VALUES
  ('cc300000-0000-0000-0000-000000000001', 'cc200000-0000-0000-0000-000000000001', 'kg2-subj', 'd1', 'admin', 'practice', 1),
  ('cc300000-0000-0000-0000-000000000002', 'cc200000-0000-0000-0000-000000000001', 'kg2-subj', 'd2', 'admin', 'practice', 2),
  ('cc300000-0000-0000-0000-000000000003', 'cc200000-0000-0000-0000-000000000001', 'kg2-subj', 'd3', 'admin', 'boss', 3),
  ('cc300000-0000-0000-0000-000000000004', 'cc200000-0000-0000-0000-000000000001', 'kg2-subj', 'd4', 'admin', 'challenge', 4);

-- q1..q4 = one per tier (tagged with the primary competency);
-- q5 = d2 tagged with BOTH competencies; q6 = d2 UNTAGGED (neutral control).
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order) VALUES
  ('cc400000-0000-0000-0000-000000000001', 'cc300000-0000-0000-0000-000000000001', 'q d1', '[{"id":"a","text":"1"},{"id":"b","text":"2"}]'::jsonb, 'a', 1),
  ('cc400000-0000-0000-0000-000000000002', 'cc300000-0000-0000-0000-000000000002', 'q d2', '[{"id":"a","text":"1"},{"id":"b","text":"2"}]'::jsonb, 'a', 1),
  ('cc400000-0000-0000-0000-000000000003', 'cc300000-0000-0000-0000-000000000003', 'q d3', '[{"id":"a","text":"1"},{"id":"b","text":"2"}]'::jsonb, 'a', 1),
  ('cc400000-0000-0000-0000-000000000004', 'cc300000-0000-0000-0000-000000000004', 'q d4', '[{"id":"a","text":"1"},{"id":"b","text":"2"}]'::jsonb, 'a', 1),
  ('cc400000-0000-0000-0000-000000000005', 'cc300000-0000-0000-0000-000000000002', 'q multi', '[{"id":"a","text":"1"},{"id":"b","text":"2"}]'::jsonb, 'a', 2),
  ('cc400000-0000-0000-0000-000000000006', 'cc300000-0000-0000-0000-000000000002', 'q untagged', '[{"id":"a","text":"1"},{"id":"b","text":"2"}]'::jsonb, 'a', 3);

INSERT INTO public.question_competencies (question_id, competency_id, is_primary) VALUES
  ('cc400000-0000-0000-0000-000000000001', 'cc100000-0000-0000-0000-000000000001', true),
  ('cc400000-0000-0000-0000-000000000002', 'cc100000-0000-0000-0000-000000000001', true),
  ('cc400000-0000-0000-0000-000000000003', 'cc100000-0000-0000-0000-000000000001', true),
  ('cc400000-0000-0000-0000-000000000004', 'cc100000-0000-0000-0000-000000000001', true),
  ('cc400000-0000-0000-0000-000000000005', 'cc100000-0000-0000-0000-000000000001', true),
  ('cc400000-0000-0000-0000-000000000005', 'cc100000-0000-0000-0000-000000000002', false);

-- Helper: one telemetry row (the trigger under test fires on this INSERT).
CREATE OR REPLACE FUNCTION pg_temp.answer(
  p_user UUID, p_question UUID, p_correct BOOLEAN, p_at TIMESTAMPTZ DEFAULT now()
) RETURNS void LANGUAGE sql AS $$
  INSERT INTO public.question_attempts
    (user_id, question_id, chapter_id, session_id, choice, is_correct, source, created_at)
  VALUES (p_user, p_question, 'cc200000-0000-0000-0000-000000000001',
          'cc500000-0000-0000-0000-000000000001', 'a', p_correct, 'exercise', p_at);
$$;

-- =========================================================
-- 1–7. Grants: SELECT-only for the client, nothing for anon, helpers private.
-- =========================================================
SELECT is(
  has_table_privilege('authenticated', 'public.user_competency_mastery', 'SELECT'),
  true,
  'mastery: authenticated may SELECT (own rows via RLS)'
);

SELECT is(
  has_table_privilege('authenticated', 'public.user_competency_mastery', 'INSERT')
    OR has_table_privilege('authenticated', 'public.user_competency_mastery', 'UPDATE')
    OR has_table_privilege('authenticated', 'public.user_competency_mastery', 'DELETE'),
  false,
  'mastery: trigger-only writes — no client write grants'
);

SELECT is(
  has_table_privilege('anon', 'public.user_competency_mastery', 'SELECT'),
  false,
  'mastery: anon sees nothing'
);

SELECT is(
  (SELECT relrowsecurity FROM pg_class WHERE oid = 'public.user_competency_mastery'::regclass),
  true,
  'mastery: RLS enabled'
);

SELECT is(
  has_function_privilege('authenticated', 'public.record_competency_mastery()', 'EXECUTE'),
  false,
  'the aggregate maintainer is not client-executable'
);

SELECT is(
  has_function_privilege('authenticated', 'public.competency_mastery_alpha(int)', 'EXECUTE'),
  false,
  'the alpha ladder is not client-executable'
);

SELECT is(
  has_function_privilege('anon', 'public.competency_mastery_with_decay(numeric, timestamptz)', 'EXECUTE'),
  false,
  'the decay lens is not anon-executable'
);

-- =========================================================
-- 8–13. EWMA: the difficulty × outcome matrix from first contact (R-4).
--   m0 = 50; correct → 50 + α·50 ; wrong → 50 − α·50
-- =========================================================
SELECT pg_temp.answer('cc000000-0000-0000-0000-0000000000a1', 'cc400000-0000-0000-0000-000000000001', true);
SELECT is(
  (SELECT mastery FROM public.user_competency_mastery
    WHERE user_id = 'cc000000-0000-0000-0000-0000000000a1'
      AND competency_id = 'cc100000-0000-0000-0000-000000000001'),
  57.50::NUMERIC,
  'EWMA d1 correct from 50: 50 + 0.15·50 = 57.5'
);

-- Same student, now a WRONG d4 answer on the same competency:
--   57.5 + 0.30·(0 − 57.5) = 40.25
SELECT pg_temp.answer('cc000000-0000-0000-0000-0000000000a1', 'cc400000-0000-0000-0000-000000000004', false);
SELECT is(
  (SELECT mastery FROM public.user_competency_mastery
    WHERE user_id = 'cc000000-0000-0000-0000-0000000000a1'
      AND competency_id = 'cc100000-0000-0000-0000-000000000001'),
  40.25::NUMERIC,
  'EWMA compounds on the stored value; a hard miss moves it most (α=0.30)'
);

SELECT is(
  (SELECT attempts FROM public.user_competency_mastery
    WHERE user_id = 'cc000000-0000-0000-0000-0000000000a1'
      AND competency_id = 'cc100000-0000-0000-0000-000000000001'),
  2,
  'attempts counts every answer on the competency'
);

-- Student B, first contact, WRONG at d2: 50 − 0.20·50 = 40
SELECT pg_temp.answer('cc000000-0000-0000-0000-0000000000b2', 'cc400000-0000-0000-0000-000000000002', false);
SELECT is(
  (SELECT mastery FROM public.user_competency_mastery
    WHERE user_id = 'cc000000-0000-0000-0000-0000000000b2'
      AND competency_id = 'cc100000-0000-0000-0000-000000000001'),
  40.00::NUMERIC,
  'EWMA d2 wrong from 50: 50 − 0.20·50 = 40 (aggregates are per-user)'
);

-- A d2 correct answer on the multi-tagged question updates BOTH competencies.
SELECT pg_temp.answer('cc000000-0000-0000-0000-0000000000b2', 'cc400000-0000-0000-0000-000000000005', true);
SELECT is(
  (SELECT mastery FROM public.user_competency_mastery
    WHERE user_id = 'cc000000-0000-0000-0000-0000000000b2'
      AND competency_id = 'cc100000-0000-0000-0000-000000000002'),
  60.00::NUMERIC,
  'a 1..3-competency question seeds EVERY mapped competency (R-2), primary or not'
);

-- The untagged question must stay strictly neutral (R-2).
SELECT pg_temp.answer('cc000000-0000-0000-0000-0000000000b2', 'cc400000-0000-0000-0000-000000000006', true);
SELECT is(
  (SELECT count(*)::int FROM public.user_competency_mastery
    WHERE user_id = 'cc000000-0000-0000-0000-0000000000b2'),
  2,
  'an UNTAGGED question creates no mastery row (tagging is progressive — R-2)'
);

-- =========================================================
-- 14–16. Bounds: mastery is asymptotic and the CHECK holds.
-- =========================================================
SELECT pg_temp.answer('cc000000-0000-0000-0000-0000000000a1', 'cc400000-0000-0000-0000-000000000004', true);
SELECT pg_temp.answer('cc000000-0000-0000-0000-0000000000a1', 'cc400000-0000-0000-0000-000000000004', true);
SELECT pg_temp.answer('cc000000-0000-0000-0000-0000000000a1', 'cc400000-0000-0000-0000-000000000004', true);
SELECT cmp_ok(
  (SELECT mastery FROM public.user_competency_mastery
    WHERE user_id = 'cc000000-0000-0000-0000-0000000000a1'
      AND competency_id = 'cc100000-0000-0000-0000-000000000001'),
  '<=',
  100::NUMERIC,
  'repeated correct answers approach but never exceed 100'
);

SELECT cmp_ok(
  (SELECT mastery FROM public.user_competency_mastery
    WHERE user_id = 'cc000000-0000-0000-0000-0000000000a1'
      AND competency_id = 'cc100000-0000-0000-0000-000000000001'),
  '>',
  40.25::NUMERIC,
  'three correct d4 answers lift the estimate back up'
);

-- Student A has no row for the SECOND competency, so this INSERT can only ever
-- trip the range CHECK — never the primary key (which would mask it).
SELECT throws_ok(
  $$ INSERT INTO public.user_competency_mastery (user_id, competency_id, mastery, last_attempt_at)
     VALUES ('cc000000-0000-0000-0000-0000000000a1', 'cc100000-0000-0000-0000-000000000002', 140, now()) $$,
  '23514',
  NULL,
  'mastery outside 0..100 violates the CHECK'
);

-- =========================================================
-- 17–20. Forgetting, applied at READ (R-4).
-- =========================================================
SELECT is(
  public.competency_mastery_with_decay(80::NUMERIC, now()),
  80.00::NUMERIC,
  'decay: a mastery refreshed just now is untouched'
);

SELECT is(
  public.competency_mastery_with_decay(80::NUMERIC, now() - INTERVAL '4 weeks'),
  76.00::NUMERIC,
  'decay: −1 pt per week of inactivity (80 → 76 after 4 weeks)'
);

SELECT is(
  public.competency_mastery_with_decay(32::NUMERIC, now() - INTERVAL '52 weeks'),
  30.00::NUMERIC,
  'decay: a long idle spell stops at the floor of 30'
);

SELECT is(
  public.competency_mastery_with_decay(12::NUMERIC, now() - INTERVAL '52 weeks'),
  12.00::NUMERIC,
  'decay: NEVER raises a mastery already below the floor (a weak 12 stays 12)'
);

-- =========================================================
-- 21–24. RLS (R-6): owner, linked parent, inactive link, stranger.
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"cc000000-0000-0000-0000-0000000000a1","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.user_competency_mastery),
  1,
  'RLS: an unfiltered scan returns ONLY the caller''s own mastery rows'
);

SELECT is_empty(
  $$ SELECT 1 FROM public.user_competency_mastery
       WHERE user_id = 'cc000000-0000-0000-0000-0000000000b2' $$,
  'RLS: student A canNOT read student B''s mastery (R-6)'
);

RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"cc000000-0000-0000-0000-0000000000c3","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.user_competency_mastery
     WHERE user_id = 'cc000000-0000-0000-0000-0000000000a1'),
  1,
  'RLS: an ACTIVE linked parent reads their child''s mastery (family visibility)'
);

SELECT is_empty(
  $$ SELECT 1 FROM public.user_competency_mastery
       WHERE user_id = 'cc000000-0000-0000-0000-0000000000b2' $$,
  'RLS: an INACTIVE link grants nothing'
);

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
