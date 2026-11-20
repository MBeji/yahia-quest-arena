-- =========================================================
-- Étude 39 lot 5 — les tests de niveau de l'enfant au rapport parent (é08).
-- ---------------------------------------------------------
--   * accès : parent LIÉ oui ; parent non lié, lien COUPÉ, élève tiers, anonyme non ;
--   * vide honnête : un élève sans test rend une liste vide ;
--   * les règles du Hall : le DERNIER test fini par matière, ni bâclé, ni en cours ;
--   * un test passé « en parent » n'entre pas ;
--   * ce qui sort : note, bande, chapitres tenus / à revoir dans l'ordre du programme,
--     portée figée — et RIEN de la correction (ni réponses, ni jeton, ni percentile).
-- Espace de noms : `e3910000…` (comptes), `e3911000…` (contenu). Tout est annulé.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(16);

INSERT INTO auth.users (id, email) VALUES
  ('e3910000-0000-4000-8000-0000000000a1', 'pl-parent@test.local'),
  ('e3910000-0000-4000-8000-0000000000a2', 'pl-other-parent@test.local'),
  ('e3910000-0000-4000-8000-0000000000a3', 'pl-ex-parent@test.local'),
  ('e3910000-0000-4000-8000-0000000000b1', 'pl-kid@test.local'),
  ('e3910000-0000-4000-8000-0000000000b2', 'pl-kid-sans@test.local'),
  ('e3910000-0000-4000-8000-0000000000b3', 'pl-other-kid@test.local');

INSERT INTO public.profiles (id, display_name)
SELECT u.id, 'x' FROM auth.users u WHERE u.id::text LIKE 'e3910000-%'
ON CONFLICT (id) DO NOTHING;

UPDATE public.profiles SET role = 'parent'
 WHERE id IN ('e3910000-0000-4000-8000-0000000000a1',
              'e3910000-0000-4000-8000-0000000000a2',
              'e3910000-0000-4000-8000-0000000000a3');

INSERT INTO public.parent_student_links (parent_user_id, student_user_id, relation_label, is_active)
VALUES
  ('e3910000-0000-4000-8000-0000000000a1', 'e3910000-0000-4000-8000-0000000000b1', 'parent', true),
  ('e3910000-0000-4000-8000-0000000000a1', 'e3910000-0000-4000-8000-0000000000b2', 'parent', true),
  ('e3910000-0000-4000-8000-0000000000a3', 'e3910000-0000-4000-8000-0000000000b1', 'parent', false);

INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('e391-theme', 'Thème placement parent', 'book', 'primary', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.grades (id, theme_id, slug, name_fr, display_order)
VALUES ('e3911000-0000-4000-8000-0000000000e9'::uuid, 'e391-theme', 'e391-9', '9ème test', 9)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.subjects (id, theme_id, grade_id, name_fr, attribute, color_token, icon) VALUES
  ('e391-math', 'e391-theme', 'e3911000-0000-4000-8000-0000000000e9'::uuid, 'Maths PL', 'logic', 'primary', 'sigma'),
  ('e391-svt',  'e391-theme', 'e3911000-0000-4000-8000-0000000000e9'::uuid, 'SVT PL',   'logic', 'primary', 'leaf');

-- Le snapshot (R-13) : deux chapitres, donnés DANS LE DÉSORDRE pour prouver le tri.
-- Maths : un test ancien (4/10), puis le dernier (8/10, portée figée) — c'est lui qui sort ;
-- un test plus récent encore mais BÂCLÉ (10 s pour 10 questions) et un autre EN COURS : ignorés.
-- SVT : un test passé EN PARENT : ignoré. Un autre élève a son propre test : jamais lu ici.
INSERT INTO public.placement_sessions
  (id, user_id, subject_id, audience, status, question_ids, answers, started_at, finished_at,
   duration_seconds, correct_count, total_count, result, scope)
VALUES
  ('e3912000-0000-4000-8000-000000000001', 'e3910000-0000-4000-8000-0000000000b1', 'e391-math',
   'student', 'completed', ARRAY[]::uuid[], '{"q":"a"}', now() - INTERVAL '10 days',
   now() - INTERVAL '10 days', 300, 4, 10,
   '{"chapters":[{"chapterId":"c1","title":"Nombres","displayOrder":1,"correct":2,"total":5,"held":false}]}', NULL),
  ('e3912000-0000-4000-8000-000000000002', 'e3910000-0000-4000-8000-0000000000b1', 'e391-math',
   'student', 'completed', ARRAY[]::uuid[], '{"q":"a"}', now() - INTERVAL '2 days',
   now() - INTERVAL '2 days', 300, 8, 10,
   '{"chapters":[{"chapterId":"c2","title":"Angles","displayOrder":2,"correct":3,"total":5,"held":false},{"chapterId":"c1","title":"Nombres","displayOrder":1,"correct":5,"total":5,"held":true}]}',
   '{"throughChapterId":"c2","throughTitle":"Angles","chaptersInScope":2,"chaptersTotal":6,"upcoming":[{"chapterId":"c3","title":"Secret","displayOrder":3}]}'),
  ('e3912000-0000-4000-8000-000000000003', 'e3910000-0000-4000-8000-0000000000b1', 'e391-math',
   'student', 'completed', ARRAY[]::uuid[], '{}', now() - INTERVAL '1 day',
   now() - INTERVAL '1 day', 10, 10, 10, '{"chapters":[]}', NULL),
  ('e3912000-0000-4000-8000-000000000004', 'e3910000-0000-4000-8000-0000000000b1', 'e391-math',
   'student', 'running', ARRAY[]::uuid[], '{}', now(), NULL, NULL, NULL, NULL, NULL, NULL),
  ('e3912000-0000-4000-8000-000000000005', 'e3910000-0000-4000-8000-0000000000b1', 'e391-svt',
   'parent', 'completed', ARRAY[]::uuid[], '{}', now() - INTERVAL '3 days',
   now() - INTERVAL '3 days', 300, 9, 10, '{"chapters":[]}', NULL),
  ('e3912000-0000-4000-8000-000000000006', 'e3910000-0000-4000-8000-0000000000b3', 'e391-svt',
   'student', 'completed', ARRAY[]::uuid[], '{}', now() - INTERVAL '3 days',
   now() - INTERVAL '3 days', 300, 9, 10, '{"chapters":[]}', NULL);

-- ---------------------------------------------------------
-- 1. Anonyme.
-- ---------------------------------------------------------
SET LOCAL ROLE anon;
SELECT throws_ok(
  $$SELECT public.get_student_placement_summary('e3910000-0000-4000-8000-0000000000b1')$$,
  '42501', NULL, 'anon : la lecture est inatteignable');

-- ---------------------------------------------------------
-- 2. Parent NON lié, parent au lien COUPÉ, élève tiers.
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"e3910000-0000-4000-8000-0000000000a2","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT throws_ok(
  $$SELECT public.get_student_placement_summary('e3910000-0000-4000-8000-0000000000b1')$$,
  'Access denied: you are not linked to this student.',
  'parent non lié : refusé');

RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"e3910000-0000-4000-8000-0000000000a3","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT throws_ok(
  $$SELECT public.get_student_placement_summary('e3910000-0000-4000-8000-0000000000b1')$$,
  'Access denied: you are not linked to this student.',
  'lien coupé : refusé — le lien doit être ACTIF');

RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"e3910000-0000-4000-8000-0000000000b3","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT throws_ok(
  $$SELECT public.get_student_placement_summary('e3910000-0000-4000-8000-0000000000b1')$$,
  'Access denied.',
  'un autre élève : refusé');

-- ---------------------------------------------------------
-- 3. Le parent lié.
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"e3910000-0000-4000-8000-0000000000a1","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  public.get_student_placement_summary('e3910000-0000-4000-8000-0000000000b2'),
  '{"tests":[]}'::jsonb,
  'élève sans test : une liste vide, pas une erreur');

CREATE TEMP TABLE pl_out ON COMMIT DROP AS
  SELECT public.get_student_placement_summary('e3910000-0000-4000-8000-0000000000b1') AS j;

SELECT is(jsonb_array_length((SELECT j -> 'tests' FROM pl_out)), 1,
  'un seul test : le test en parent (SVT) et celui d''un autre élève restent dehors');

SELECT is((SELECT j -> 'tests' -> 0 ->> 'sessionId' FROM pl_out),
  'e3912000-0000-4000-8000-000000000002',
  'le DERNIER test valable de la matière — ni le bâclé, ni l''en-cours, ni l''ancien');

SELECT is((SELECT (j -> 'tests' -> 0 ->> 'scoreOn20')::numeric FROM pl_out), 16.0::numeric,
  'note sur 20 : 8/10 → 16');

SELECT is((SELECT j -> 'tests' -> 0 ->> 'band' FROM pl_out), 'solide',
  'la bande vient de placement_band (16 → solide)');

SELECT is((SELECT j -> 'tests' -> 0 ->> 'subjectNameFr' FROM pl_out), 'Maths PL',
  'le nom de la matière');

SELECT is((SELECT j -> 'tests' -> 0 ->> 'gradeNameFr' FROM pl_out), '9ème test',
  'le nom de la classe');

SELECT is((SELECT j -> 'tests' -> 0 -> 'chaptersHeld' FROM pl_out), '["Nombres"]'::jsonb,
  'chapitres tenus');

SELECT is((SELECT j -> 'tests' -> 0 -> 'chaptersToReview' FROM pl_out), '["Angles"]'::jsonb,
  'chapitres à revoir');

SELECT is((SELECT j -> 'tests' -> 0 -> 'scope' FROM pl_out),
  '{"throughTitle":"Angles","chaptersInScope":2,"chaptersTotal":6}'::jsonb,
  'la portée figée : le chapitre atteint et les deux comptes, sans la liste à venir');

SELECT is(
  (SELECT array_agg(k ORDER BY k) FROM pl_out, jsonb_object_keys(j -> 'tests' -> 0) AS k),
  ARRAY['band','chaptersHeld','chaptersToReview','correct','finishedAt','gradeNameFr',
        'scope','scoreOn20','sessionId','subjectId','subjectNameFr','total'],
  'rien d''autre ne sort : ni réponses, ni jeton, ni percentile, ni correction');

-- ---------------------------------------------------------
-- 4. Les droits de la fonction.
-- ---------------------------------------------------------
RESET ROLE;
SELECT ok(
  NOT has_function_privilege('anon', 'public.get_student_placement_summary(uuid)', 'EXECUTE'),
  'anon n''a pas EXECUTE');

SELECT * FROM finish();
ROLLBACK;
