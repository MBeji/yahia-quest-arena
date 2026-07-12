-- =========================================================
-- Knowledge graph — catalog schema + compiled registry (étude 07, lot 1).
-- ---------------------------------------------------------
--   1. Grants: the 3 catalog tables are SELECT-only for authenticated
--      (writes are compiled-migration-only), invisible to anon;
--   2. RLS is enabled on all 3 tables (and the read policy actually lets an
--      authenticated role read the catalogue);
--   3. The compiled math registry is seeded: ≥50 competencies, ≥60 prereq
--      edges, trilingual labels all non-empty, flagship slug present;
--   4. Defensive integrity: self-prereq CHECK, junction FK to the registry.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(20);

-- =========================================================
-- 1–9. Grants (CLAUDE.md gotcha: explicit end-state on every stack).
-- =========================================================
SELECT is(
  has_table_privilege('authenticated', 'public.competencies', 'SELECT'),
  true,
  'competencies: authenticated may SELECT (catalogue)'
);

SELECT is(
  has_table_privilege('authenticated', 'public.competencies', 'INSERT')
    OR has_table_privilege('authenticated', 'public.competencies', 'UPDATE')
    OR has_table_privilege('authenticated', 'public.competencies', 'DELETE'),
  false,
  'competencies: no client writes (compiled migrations only)'
);

SELECT is(
  has_table_privilege('anon', 'public.competencies', 'SELECT'),
  false,
  'competencies: anon sees nothing (v1 surfaces are authenticated)'
);

SELECT is(
  has_table_privilege('authenticated', 'public.competency_prereqs', 'SELECT'),
  true,
  'competency_prereqs: authenticated may SELECT'
);

SELECT is(
  has_table_privilege('authenticated', 'public.competency_prereqs', 'INSERT')
    OR has_table_privilege('authenticated', 'public.competency_prereqs', 'UPDATE')
    OR has_table_privilege('authenticated', 'public.competency_prereqs', 'DELETE'),
  false,
  'competency_prereqs: no client writes'
);

SELECT is(
  has_table_privilege('anon', 'public.competency_prereqs', 'SELECT'),
  false,
  'competency_prereqs: anon sees nothing'
);

SELECT is(
  has_table_privilege('authenticated', 'public.question_competencies', 'SELECT'),
  true,
  'question_competencies: authenticated may SELECT (ids never reveal the key — D-2)'
);

SELECT is(
  has_table_privilege('authenticated', 'public.question_competencies', 'INSERT')
    OR has_table_privilege('authenticated', 'public.question_competencies', 'UPDATE')
    OR has_table_privilege('authenticated', 'public.question_competencies', 'DELETE'),
  false,
  'question_competencies: no client writes'
);

SELECT is(
  has_table_privilege('anon', 'public.question_competencies', 'SELECT'),
  false,
  'question_competencies: anon sees nothing'
);

-- =========================================================
-- 10–12. RLS enabled on the 3 catalog tables.
-- =========================================================
SELECT is(
  (SELECT relrowsecurity FROM pg_class WHERE oid = 'public.competencies'::regclass),
  true,
  'competencies: RLS enabled'
);

SELECT is(
  (SELECT relrowsecurity FROM pg_class WHERE oid = 'public.competency_prereqs'::regclass),
  true,
  'competency_prereqs: RLS enabled'
);

SELECT is(
  (SELECT relrowsecurity FROM pg_class WHERE oid = 'public.question_competencies'::regclass),
  true,
  'question_competencies: RLS enabled'
);

-- =========================================================
-- 13–16. Compiled math registry is seeded and trilingual (Q-1: ~55-70).
-- =========================================================
SELECT cmp_ok(
  (SELECT count(*)::int FROM public.competencies WHERE family = 'math'),
  '>=',
  50,
  'registry: the math family ships ≥50 competencies (medium granularity — Q-1)'
);

SELECT cmp_ok(
  (SELECT count(*)::int FROM public.competency_prereqs),
  '>=',
  60,
  'registry: the prerequisite DAG ships ≥60 edges'
);

SELECT is(
  (SELECT count(*)::int FROM public.competencies
     WHERE slug = 'math.geo.thales-direct'
       AND length(label_fr) > 0 AND length(label_en) > 0 AND length(label_ar) > 0),
  1,
  'registry: flagship competency math.geo.thales-direct exists with trilingual labels'
);

SELECT is(
  (SELECT count(*)::int FROM public.competencies
     WHERE label_fr = '' OR label_en = '' OR label_ar = ''),
  0,
  'registry: no empty label in any language (R-6)'
);

-- =========================================================
-- 17–18. Defensive integrity: self-edge CHECK, junction FK.
-- =========================================================
SELECT throws_ok(
  $$ INSERT INTO public.competency_prereqs (competency_id, prereq_id)
     SELECT id, id FROM public.competencies WHERE slug = 'math.geo.thales-direct' $$,
  '23514',
  NULL,
  'competency_prereqs: a competency cannot be its own prerequisite (CHECK)'
);

-- Fixture: one admin question to exercise the junction FK.
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('kg-subj', 'KG Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');
INSERT INTO public.chapters (id, subject_id, title)
VALUES ('c7100000-0000-0000-0000-000000000001', 'kg-subj', 'KG Chapter');
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode)
VALUES ('c7200000-0000-0000-0000-000000000001',
        'c7100000-0000-0000-0000-000000000001', 'kg-subj',
        'KG Exercise', 'admin', 'practice');
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES ('c7300000-0000-0000-0000-000000000001',
        'c7200000-0000-0000-0000-000000000001',
        'Thalès ?',
        '[{"id":"a","text":"oui"},{"id":"b","text":"non"}]'::jsonb,
        'a', 1);

SELECT throws_ok(
  $$ INSERT INTO public.question_competencies (question_id, competency_id, is_primary)
     VALUES ('c7300000-0000-0000-0000-000000000001',
             'deadbeef-dead-beef-dead-beefdeadbeef', true) $$,
  '23503',
  NULL,
  'question_competencies: an unregistered competency violates the FK'
);

-- =========================================================
-- 19–20. The read policy actually serves an authenticated role; anon is
-- rejected at the grant layer.
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT cmp_ok(
  (SELECT count(*)::int FROM public.competencies),
  '>=',
  50,
  'RLS: an authenticated user reads the whole competency catalogue'
);

RESET ROLE;
SET LOCAL ROLE anon;

SELECT throws_ok(
  $$ SELECT count(*) FROM public.competencies $$,
  '42501',
  NULL,
  'grants: anon is denied at the table-privilege layer'
);

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
