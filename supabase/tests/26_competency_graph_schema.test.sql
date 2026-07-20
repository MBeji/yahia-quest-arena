-- =========================================================
-- Knowledge graph — catalog schema + compiled registry (étude 07, lot 1).
-- ---------------------------------------------------------
--   1. Grants: the 3 catalog tables are SELECT-only for authenticated
--      (writes are compiled-migration-only), invisible to anon;
--   2. RLS is enabled on all 3 tables (and the read policy actually lets an
--      authenticated role read the catalogue);
--   3. Defensive integrity: self-prereq CHECK, junction FK to the registry.
--
-- Schema only — the compiled registry's CONTENT (how many competencies, which
-- slugs) left with the corpus in étude 24 and is tracked for the private
-- Content CI in #574. Fixtures here seed whatever they need.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(16);

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
-- 13–14. Defensive integrity: self-edge CHECK, junction FK.
-- ---------------------------------------------------------
-- The compiled-registry assertions that used to sit here (≥50 math
-- competencies, ≥60 prereq edges, the `math.geo.thales-direct` flagship, no
-- empty label) left with the corpus in étude 24 — tracked for the private
-- Content CI in #574. They could never pass here again: `db-tests.yml` boots
-- the stack with `supabase db start`, which applies supabase/migrations/ ONLY,
-- and content now compiles to sql/content/*.sql applied by the private repo.
-- The "no empty label" one had already rotted into a vacuous pass — a count of
-- 0 over an EMPTY table — which is why it stayed green while its four
-- neighbours went red.
--
-- What belongs here is the SCHEMA, and it now seeds its own competency instead
-- of borrowing a registry row: the CHECK constraint and the read policy are
-- exercised for real, corpus or no corpus.
-- =========================================================
INSERT INTO public.competencies (id, slug, family, label_fr, label_en, label_ar)
VALUES ('c9000000-0000-0000-0000-000000000001', 'kg.test.self-edge', 'math',
        'Compétence de test', 'Test competency', 'كفاءة اختبار');

SELECT throws_ok(
  $$ INSERT INTO public.competency_prereqs (competency_id, prereq_id)
     SELECT id, id FROM public.competencies WHERE slug = 'kg.test.self-edge' $$,
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
-- 15–16. The read policy actually serves an authenticated role; anon is
-- rejected at the grant layer.
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- Asserts the POLICY (a seeded row is readable under RLS), not the registry
-- size: the old `>= 50` measured the corpus, which no longer ships here.
SELECT is(
  (SELECT count(*)::int FROM public.competencies WHERE slug = 'kg.test.self-edge'),
  1,
  'RLS: an authenticated user reads the competency catalogue'
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
