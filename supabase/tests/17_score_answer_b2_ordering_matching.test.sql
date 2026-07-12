-- =========================================================
-- Native question types (B2) — ordering + matching scoring.
-- ---------------------------------------------------------
-- Étude FableEtudes/03-types-questions-natifs #lot-B2.1 ;
-- spec normative docs/interactive-question-types.md.
--
--   1. 'ordering': EXACT sequence match on the id CSV — a partial/wrong order
--      scores false (no partial credit, R-2); whitespace-insensitive;
--      garbage never raises (R-3);
--   2. 'matching': SET equality of "left:right" pairs — order-insensitive,
--      inverted/subset/superset/duplicated pairs score false;
--   3. 'multi' subset answers score false (full matrix in test 18);
--   4. regression: mcq and numeric semantics are unchanged;
--   5. the correction RPCs reveal the canonical answer in the same wire
--      format as `choice` (ordering: id CSV; matching: pair CSV) — R-1 gates
--      unchanged (answer_key stays column-masked, helper not client-executable).
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(24);

-- ---------------------------------------------------------
-- Fixtures: one admin practice exercise carrying one question of each type.
-- ---------------------------------------------------------
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('b2-subj', 'B2 Types Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('f1000000-0000-0000-0000-000000000001', 'b2-subj', 'B2 Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode)
VALUES ('f2000000-0000-0000-0000-000000000001',
        'f1000000-0000-0000-0000-000000000001', 'b2-subj',
        'B2 Exercise', 'admin', 'practice');

INSERT INTO public.questions (id, exercise_id, prompt, options, question_type, answer_key, display_order)
VALUES
  ('f3000000-0000-0000-0000-000000000001',
   'f2000000-0000-0000-0000-000000000001',
   'Ordering: chronologie',
   '[{"id":"a","text":"étape A"},{"id":"b","text":"étape B"},{"id":"c","text":"étape C"},{"id":"d","text":"étape D"}]'::jsonb,
   'ordering', '{"order": ["b", "a", "d", "c"]}'::jsonb, 1),
  ('f3000000-0000-0000-0000-000000000002',
   'f2000000-0000-0000-0000-000000000001',
   'Matching: paires',
   '[{"id":"l1","text":"gauche 1"},{"id":"l2","text":"gauche 2"},{"id":"r1","text":"droite 1"},{"id":"r2","text":"droite 2"}]'::jsonb,
   'matching', '{"pairs": [["l1", "r2"], ["l2", "r1"]]}'::jsonb, 2),
  ('f3000000-0000-0000-0000-000000000003',
   'f2000000-0000-0000-0000-000000000001',
   'Multi (B3): pas encore', '[{"id":"a","text":"x"},{"id":"b","text":"y"}]'::jsonb,
   'multi', '{"correct": ["a", "b"]}'::jsonb, 3),
  ('f3000000-0000-0000-0000-000000000005',
   'f2000000-0000-0000-0000-000000000001',
   'Numeric regression', '[]'::jsonb,
   'numeric', '{"value": 2.5, "tolerance": 0.1}'::jsonb, 5);

-- mcq keeps its historical key column (the shape CHECK requires it at insert).
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES ('f3000000-0000-0000-0000-000000000004',
        'f2000000-0000-0000-0000-000000000001',
        'MCQ regression', '[{"id":"a","text":"1"},{"id":"b","text":"2"}]'::jsonb, 'a', 4);

-- =========================================================
-- 1–7. ordering semantics.
-- =========================================================
SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'f3000000-0000-0000-0000-000000000001'), 'b,a,d,c'),
  true,
  'ordering: the exact sequence scores true'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'f3000000-0000-0000-0000-000000000001'), 'b, a, d, c'),
  true,
  'ordering: whitespace around ids is ignored'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'f3000000-0000-0000-0000-000000000001'), 'a,b,d,c'),
  false,
  'ordering: two swapped steps score false (no partial credit — R-2)'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'f3000000-0000-0000-0000-000000000001'), 'b,a,d'),
  false,
  'ordering: a missing step scores false'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'f3000000-0000-0000-0000-000000000001'), 'b,a,d,c,c'),
  false,
  'ordering: an extra step scores false'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'f3000000-0000-0000-0000-000000000001'), 'n''importe quoi'),
  false,
  'ordering: garbage input scores false without raising (R-3)'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'f3000000-0000-0000-0000-000000000001'), NULL),
  false,
  'ordering: a NULL choice scores false'
);

-- =========================================================
-- 8–13. matching semantics.
-- =========================================================
SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'f3000000-0000-0000-0000-000000000002'), 'l1:r2,l2:r1'),
  true,
  'matching: the exact pair set scores true'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'f3000000-0000-0000-0000-000000000002'), 'l2:r1, l1:r2'),
  true,
  'matching: pair ORDER is irrelevant (set equality) and whitespace is ignored'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'f3000000-0000-0000-0000-000000000002'), 'l1:r1,l2:r2'),
  false,
  'matching: inverted associations score false'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'f3000000-0000-0000-0000-000000000002'), 'l1:r2'),
  false,
  'matching: a pair subset scores false (no partial credit — R-2)'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'f3000000-0000-0000-0000-000000000002'), 'l1:r2,l1:r2'),
  false,
  'matching: duplicating one pair does not fake completeness'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'f3000000-0000-0000-0000-000000000002'), 'l1:r2,l2:r1,l1:r1'),
  false,
  'matching: an extra wrong pair scores false'
);

-- =========================================================
-- 14. multi: a subset answer scores false (full matrix in test 18).
-- =========================================================
SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'f3000000-0000-0000-0000-000000000003'), 'a'),
  false,
  'multi: a subset answer scores false (no partial credit)'
);

-- =========================================================
-- 15–17. regression: mcq and numeric semantics unchanged.
-- =========================================================
SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'f3000000-0000-0000-0000-000000000004'), 'a'),
  true,
  'regression: mcq equality is unchanged'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'f3000000-0000-0000-0000-000000000005'), '2,4'),
  true,
  'regression: numeric tolerance (comma decimal) is unchanged'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'f3000000-0000-0000-0000-000000000005'), '2.7'),
  false,
  'regression: numeric out-of-tolerance is unchanged'
);

-- =========================================================
-- 18–20. canonical answer display (answer_key_display).
-- =========================================================
SELECT is(
  public.answer_key_display(
    (SELECT q FROM public.questions q WHERE q.id = 'f3000000-0000-0000-0000-000000000001')),
  'b,a,d,c',
  'answer_key_display: ordering serializes as the id CSV (choice wire format)'
);

SELECT is(
  public.answer_key_display(
    (SELECT q FROM public.questions q WHERE q.id = 'f3000000-0000-0000-0000-000000000002')),
  'l1:r2,l2:r1',
  'answer_key_display: matching serializes as the pair CSV (choice wire format)'
);

SELECT is(
  public.answer_key_display(
    (SELECT q FROM public.questions q WHERE q.id = 'f3000000-0000-0000-0000-000000000004')),
  'a',
  'answer_key_display: mcq keeps revealing correct_option'
);

-- =========================================================
-- 21–22. the anon correction RPC scores + reveals the B2 types.
-- =========================================================
SET LOCAL ROLE anon;

SELECT is(
  (SELECT c.is_correct FROM public.check_answers(
     'f2000000-0000-0000-0000-000000000001',
     '[{"questionId":"f3000000-0000-0000-0000-000000000001","choice":"b,a,d,c"}]'::jsonb) c),
  true,
  'check_answers: an exact ordering answer is correct for an anon practice run'
);

SELECT is(
  (SELECT c.correct_option FROM public.check_answers(
     'f2000000-0000-0000-0000-000000000001',
     '[{"questionId":"f3000000-0000-0000-0000-000000000002","choice":"l1:r1,l2:r2"}]'::jsonb) c),
  'l1:r2,l2:r1',
  'check_answers: the matching correction reveals the canonical pair CSV'
);

RESET ROLE;

-- =========================================================
-- 23–24. R-1 posture holds for the new helper and the key column.
-- =========================================================
SELECT is(
  has_function_privilege('anon', 'public.answer_key_display(public.questions)', 'EXECUTE')
    OR has_function_privilege('authenticated', 'public.answer_key_display(public.questions)', 'EXECUTE'),
  false,
  'R-1: answer_key_display is not client-executable'
);

SELECT is(
  has_column_privilege('authenticated', 'public.questions', 'answer_key', 'SELECT'),
  false,
  'R-1: answer_key stays column-masked from clients'
);

SELECT * FROM finish();
ROLLBACK;
