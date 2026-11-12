-- =========================================================
-- Étude 08 lot 1 — les examens blancs au rapport parent (US-5).
-- ---------------------------------------------------------
--   * accès : parent LIÉ oui ; parent non lié, élève tiers, anonyme non ;
--     un lien COUPÉ ne lit plus ;
--   * vide honnête : un élève sans examen rend une liste vide, et le compte des
--     examens encore ouverts dans SON parcours ;
--   * seules les sessions CLASSÉES et rendues remontent (ni entraînement, ni
--     copie en cours) ;
--   * règle é02 : percentile NULL à 19 candidats, chiffré à 20 — et ÉGAL à ce
--     que l'élève lit lui-même par get_mock_exam_percentile ;
--   * aucune donnée d'un autre candidat ne sort.
-- Espace de noms : `e8010000…` (comptes), `e8011000…` (contenu). Tout est annulé.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(17);

INSERT INTO auth.users (id, email) VALUES
  ('e8010000-0000-4000-8000-0000000000a1', 'exam-parent@test.local'),
  ('e8010000-0000-4000-8000-0000000000a2', 'exam-other-parent@test.local'),
  ('e8010000-0000-4000-8000-0000000000a3', 'exam-ex-parent@test.local'),
  ('e8010000-0000-4000-8000-0000000000b1', 'exam-kid@test.local'),
  ('e8010000-0000-4000-8000-0000000000b2', 'exam-kid-sans@test.local');

-- 19 autres candidats : avec l'enfant, le 20ᵉ rendu fait franchir le seuil.
INSERT INTO auth.users (id, email)
SELECT ('e8010000-0000-4000-8000-0000000c' || lpad(g::text, 4, '0'))::uuid,
       'exam-cand-' || g || '@test.local'
  FROM generate_series(1, 19) g;

INSERT INTO public.profiles (id, display_name)
SELECT u.id, 'x' FROM auth.users u WHERE u.id::text LIKE 'e8010000-%'
ON CONFLICT (id) DO NOTHING;

UPDATE public.profiles SET role = 'parent'
 WHERE id IN ('e8010000-0000-4000-8000-0000000000a1',
              'e8010000-0000-4000-8000-0000000000a2',
              'e8010000-0000-4000-8000-0000000000a3');
UPDATE public.profiles SET current_parcours_id = 'concours-9eme'
 WHERE id IN ('e8010000-0000-4000-8000-0000000000b1',
              'e8010000-0000-4000-8000-0000000000b2');

INSERT INTO public.parent_student_links (parent_user_id, student_user_id, relation_label, is_active)
VALUES
  ('e8010000-0000-4000-8000-0000000000a1', 'e8010000-0000-4000-8000-0000000000b1', 'parent', true),
  ('e8010000-0000-4000-8000-0000000000a1', 'e8010000-0000-4000-8000-0000000000b2', 'parent', true),
  ('e8010000-0000-4000-8000-0000000000a3', 'e8010000-0000-4000-8000-0000000000b1', 'parent', false);

-- Deux examens publiés du parcours, plus un brouillon (qui ne compte nulle part).
-- Les autres examens publiés de la base sont archivés le temps du test, pour que
-- `openExams` soit un nombre exact et non « au moins ».
UPDATE public.mock_exams SET status = 'archived' WHERE status = 'published';

INSERT INTO public.mock_exams (id, parcours_id, title_fr, title_ar, duration_minutes, status, display_order)
VALUES
  ('e8011000-0000-4000-8000-000000000001', 'concours-9eme', 'Blanc A', 'تجريبي أ', 60, 'published', 1),
  ('e8011000-0000-4000-8000-000000000002', 'concours-9eme', 'Blanc B', NULL, 60, 'published', 2),
  ('e8011000-0000-4000-8000-000000000003', 'concours-9eme', 'Blanc brouillon', NULL, 60, 'draft', 3);

-- L'enfant : 120/150 au blanc A (classé, rendu) ; un ENTRAÎNEMENT au blanc A ;
-- une copie classée EN COURS au blanc B (pas rendue).
INSERT INTO public.mock_exam_sessions
  (id, exam_id, user_id, kind, started_at, deadline, finished_at, score_points, max_points)
VALUES
  ('e8012000-0000-4000-8000-000000000001', 'e8011000-0000-4000-8000-000000000001',
   'e8010000-0000-4000-8000-0000000000b1', 'ranked',
   now() - INTERVAL '2 hours', now() - INTERVAL '1 hour', now() - INTERVAL '90 minutes', 120, 150),
  ('e8012000-0000-4000-8000-000000000002', 'e8011000-0000-4000-8000-000000000001',
   'e8010000-0000-4000-8000-0000000000b1', 'practice',
   now() - INTERVAL '50 minutes', now() + INTERVAL '10 minutes', now() - INTERVAL '40 minutes', 150, 150),
  ('e8012000-0000-4000-8000-000000000003', 'e8011000-0000-4000-8000-000000000002',
   'e8010000-0000-4000-8000-0000000000b1', 'ranked',
   now() - INTERVAL '5 minutes', now() + INTERVAL '55 minutes', NULL, NULL, NULL);

-- 18 autres candidats rendent le blanc A : 12 sous l'enfant (60), 6 au-dessus (140).
INSERT INTO public.mock_exam_sessions
  (exam_id, user_id, kind, started_at, deadline, finished_at, score_points, max_points)
SELECT 'e8011000-0000-4000-8000-000000000001',
       ('e8010000-0000-4000-8000-0000000c' || lpad(g::text, 4, '0'))::uuid,
       'ranked', now() - INTERVAL '3 hours', now() - INTERVAL '2 hours', now() - INTERVAL '150 minutes',
       CASE WHEN g <= 12 THEN 60 ELSE 140 END, 150
  FROM generate_series(1, 18) g;

-- ---------------------------------------------------------
-- 1. Anonyme.
-- ---------------------------------------------------------
SET LOCAL ROLE anon;
SELECT throws_ok(
  $$SELECT public.get_student_exam_summary('e8010000-0000-4000-8000-0000000000b1')$$,
  '42501', NULL, 'anon : la lecture est inatteignable');

-- ---------------------------------------------------------
-- 2. Parent NON lié, parent au lien COUPÉ, élève tiers.
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"e8010000-0000-4000-8000-0000000000a2","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT throws_ok(
  $$SELECT public.get_student_exam_summary('e8010000-0000-4000-8000-0000000000b1')$$,
  'Access denied: you are not linked to this student.',
  'parent non lié : refusé');

RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"e8010000-0000-4000-8000-0000000000a3","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT throws_ok(
  $$SELECT public.get_student_exam_summary('e8010000-0000-4000-8000-0000000000b1')$$,
  'Access denied: you are not linked to this student.',
  'lien coupé : refusé — le lien doit être ACTIF');

RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"e8010000-0000-4000-8000-0000000c0001","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT throws_ok(
  $$SELECT public.get_student_exam_summary('e8010000-0000-4000-8000-0000000000b1')$$,
  'Access denied.',
  'un autre élève : refusé');

-- ---------------------------------------------------------
-- 3. Le parent lié, à 19 candidats : la note, pas encore le percentile.
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"e8010000-0000-4000-8000-0000000000a1","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT set_config('test.s19',
  public.get_student_exam_summary('e8010000-0000-4000-8000-0000000000b1')::text, true);

SELECT is(
  jsonb_array_length(current_setting('test.s19')::jsonb -> 'exams'), 1,
  'une seule ligne : la session CLASSÉE et rendue — ni l''entraînement, ni la copie en cours');

SELECT is(
  (current_setting('test.s19')::jsonb -> 'exams' -> 0) - 'finishedAt',
  jsonb_build_object(
    'examId', 'e8011000-0000-4000-8000-000000000001',
    'titleFr', 'Blanc A', 'titleEn', NULL, 'titleAr', 'تجريبي أ',
    'scorePoints', 120, 'maxPoints', 150, 'scoreOn20', 16.00,
    'candidates', 19, 'percentile', NULL),
  'la note sur 20 suit le barème ; à 19 candidats le percentile est NULL (règle é02)');

SELECT is(
  (current_setting('test.s19')::jsonb ->> 'minCandidates')::int, 20,
  'le seuil voyage avec la réponse : l''écran n''a pas à le connaître');

SELECT is(
  (current_setting('test.s19')::jsonb ->> 'openExams')::int, 1,
  'un examen publié du parcours reste à rendre (le blanc B) — le brouillon ne compte pas');

SELECT ok(
  current_setting('test.s19') !~ 'e8010000',
  'aucun identifiant de candidat — ni l''enfant, ni les autres — dans la charge');

-- ---------------------------------------------------------
-- 4. L'enfant sans examen : vide, et deux examens ouverts.
-- ---------------------------------------------------------
SELECT is(
  public.get_student_exam_summary('e8010000-0000-4000-8000-0000000000b2') -> 'exams',
  '[]'::jsonb, 'élève sans examen : liste vide');
SELECT is(
  (public.get_student_exam_summary('e8010000-0000-4000-8000-0000000000b2') ->> 'openExams')::int, 2,
  'élève sans examen : les deux blancs publiés de son parcours sont ouverts');

-- ---------------------------------------------------------
-- 5. Le 20ᵉ candidat rend sa copie : le percentile apparaît.
-- ---------------------------------------------------------
RESET ROLE;
INSERT INTO public.mock_exam_sessions
  (exam_id, user_id, kind, started_at, deadline, finished_at, score_points, max_points)
VALUES ('e8011000-0000-4000-8000-000000000001', 'e8010000-0000-4000-8000-0000000c0019',
        'ranked', now() - INTERVAL '3 hours', now() - INTERVAL '2 hours', now() - INTERVAL '150 minutes', 30, 150);

SET LOCAL "request.jwt.claims" = '{"sub":"e8010000-0000-4000-8000-0000000000a1","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.get_student_exam_summary('e8010000-0000-4000-8000-0000000000b1')
     -> 'exams' -> 0 ->> 'candidates')::int, 20,
  '20 candidats classés');
SELECT is(
  (public.get_student_exam_summary('e8010000-0000-4000-8000-0000000000b1')
     -> 'exams' -> 0 ->> 'percentile')::numeric, 65.0,
  'à 20 candidats le percentile sort : 13 copies sous la sienne sur 20 = 65 %');

SELECT set_config('test.parent_pct',
  public.get_student_exam_summary('e8010000-0000-4000-8000-0000000000b1')
    -> 'exams' -> 0 ->> 'percentile', true);

-- L'élève lit lui-même son percentile (é02) : les deux lectures doivent s'accorder.
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"e8010000-0000-4000-8000-0000000000b1","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  public.get_mock_exam_percentile('e8012000-0000-4000-8000-000000000001') ->> 'percentile',
  current_setting('test.parent_pct'),
  'le parent lit EXACTEMENT le percentile que l''élève lit (une règle, deux lecteurs)');

SELECT throws_ok(
  $$SELECT public.get_student_exam_summary('e8010000-0000-4000-8000-0000000000b1')$$,
  'Access denied.',
  'l''élève lui-même ne passe pas par la lecture parent');

-- ---------------------------------------------------------
-- 6. La surface.
-- ---------------------------------------------------------
RESET ROLE;
SELECT is(
  has_function_privilege('anon', 'public.get_student_exam_summary(uuid)', 'EXECUTE'),
  false, 'anon n''a pas EXECUTE');
SELECT is(
  (SELECT p.prosecdef AND p.proconfig @> ARRAY['search_path=public']
     FROM pg_proc p WHERE p.oid = 'public.get_student_exam_summary(uuid)'::regprocedure),
  true, 'SECURITY DEFINER, search_path fixé');

SELECT * FROM finish();
ROLLBACK;
