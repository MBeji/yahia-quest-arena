-- =========================================================
-- Native question types (B3) — multi-select scoring.
-- ---------------------------------------------------------
-- Étude FableEtudes/03-types-questions-natifs #lot-B3.1 ;
-- spec normative docs/interactive-question-types.md.
--
--   1. 'multi': SET equality of the checked ids — order-insensitive,
--      duplicates collapse; subset/superset/wrong sets score false
--      (no partial credit, R-2); garbage never raises (R-3);
--   2. the correction RPCs reveal the canonical sorted id CSV;
--   3. a hypothetical FUTURE type still scores false without raising
--      (probed via jsonb_populate_record — the table CHECK forbids such rows);
--   4. R-1 posture holds (helper + key column stay server-only).
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(12);

-- ---------------------------------------------------------
-- Fixture: one admin practice exercise with one multi question (key {a,c}).
-- ---------------------------------------------------------
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('b3-subj', 'B3 Multi Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('a3100000-0000-0000-0000-000000000001', 'b3-subj', 'B3 Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode)
VALUES ('a3200000-0000-0000-0000-000000000001',
        'a3100000-0000-0000-0000-000000000001', 'b3-subj',
        'B3 Exercise', 'admin', 'practice');

INSERT INTO public.questions (id, exercise_id, prompt, options, question_type, answer_key, display_order)
VALUES ('a3300000-0000-0000-0000-000000000001',
        'a3200000-0000-0000-0000-000000000001',
        'Multi: coche TOUTES les bonnes réponses',
        '[{"id":"a","text":"vrai 1"},{"id":"b","text":"faux"},{"id":"c","text":"vrai 2"},{"id":"d","text":"faux 2"}]'::jsonb,
        'multi', '{"correct": ["a", "c"]}'::jsonb, 1);

-- =========================================================
-- 1–7. multi semantics.
-- =========================================================
SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'a3300000-0000-0000-0000-000000000001'), 'a,c'),
  true,
  'multi: the exact checked set scores true'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'a3300000-0000-0000-0000-000000000001'), 'c, a'),
  true,
  'multi: selection ORDER is irrelevant and whitespace is ignored'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'a3300000-0000-0000-0000-000000000001'), 'a,a,c'),
  true,
  'multi: duplicated ids collapse to the same set'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'a3300000-0000-0000-0000-000000000001'), 'a'),
  false,
  'multi: a subset scores false (no partial credit — R-2)'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'a3300000-0000-0000-0000-000000000001'), 'a,b,c'),
  false,
  'multi: a superset (one wrong extra) scores false'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'a3300000-0000-0000-0000-000000000001'), 'b,d'),
  false,
  'multi: a fully wrong set scores false'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = 'a3300000-0000-0000-0000-000000000001'), NULL),
  false,
  'multi: a NULL choice scores false'
);

-- =========================================================
-- 8–9. canonical answer display + anon correction RPC.
-- =========================================================
SELECT is(
  public.answer_key_display(
    (SELECT q FROM public.questions q WHERE q.id = 'a3300000-0000-0000-0000-000000000001')),
  'a,c',
  'answer_key_display: multi serializes as the SORTED id CSV (choice wire format)'
);

SET LOCAL ROLE anon;
SELECT is(
  (SELECT c.is_correct FROM public.check_answers(
     'a3200000-0000-0000-0000-000000000001',
     '[{"questionId":"a3300000-0000-0000-0000-000000000001","choice":"c,a"}]'::jsonb) c),
  true,
  'check_answers: an anon multi answer scores through the seam'
);
RESET ROLE;

-- =========================================================
-- 10. a hypothetical future type scores false, never raises (R-3).
-- (The table CHECK forbids such rows; probe with a constructed record.)
-- =========================================================
SELECT is(
  public.score_answer(
    jsonb_populate_record(NULL::public.questions,
      '{"question_type": "essay", "correct_option": null}'::jsonb),
    'anything'),
  false,
  'a future/unknown question_type scores false instead of crashing'
);

-- =========================================================
-- 11–12. R-1 posture holds.
-- =========================================================
SELECT is(
  has_function_privilege('anon', 'public.score_answer(public.questions, text)', 'EXECUTE')
    OR has_function_privilege('authenticated', 'public.score_answer(public.questions, text)', 'EXECUTE'),
  false,
  'R-1: score_answer stays non-client-executable'
);

SELECT is(
  has_column_privilege('anon', 'public.questions', 'answer_key', 'SELECT'),
  false,
  'R-1: answer_key stays column-masked from clients'
);

SELECT * FROM finish();
ROLLBACK;
