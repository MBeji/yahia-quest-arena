-- =========================================================
-- Étude 08 lot 3 — le comparatif de parcours, seuillé (US-8, R-5, R-6, D-3).
-- ---------------------------------------------------------
--   * R-6 : à 29 élèves actifs, AUCUN chiffre et aucun effectif ; à 30, la
--     moyenne sort ;
--   * anonymat : la charge ne porte aucun identifiant, aucun rang, aucun
--     minimum/maximum — et la mesure interne par élève est inatteignable ;
--   * un élève = une voix (moyenne des moyennes), navigation exclue du temps,
--     activité hors parcours et hors fenêtre exclue ; un parent actif sur le
--     parcours ne compte pas parmi les élèves ;
--   * accès au comparatif d'un enfant : parent lié oui ; non lié, lien coupé,
--     anonyme non ; élève sans parcours ou sans activité : vide honnête.
-- Parcours et matières de test dédiés (`t110-*`) : la base de test peut contenir
-- d'autres élèves, le compte doit être exact. Tout est annulé.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(21);

INSERT INTO public.themes (id, name_fr, description, icon, color_token, display_order)
SELECT 't110-theme', 'Thème 110', 'x', 'Brain', 'subject-math', 999
 WHERE NOT EXISTS (SELECT 1 FROM public.themes WHERE id = 't110-theme');

INSERT INTO public.parcours (id, theme_id, grade_id, name_fr, name_ar, kind, icon, color, display_order)
VALUES ('t110-parcours', 't110-theme', NULL, 'Parcours 110', 'مسار 110', 'libre', 'Brain', 'gold', 999);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id) VALUES
  ('t110-in',  'Dans le parcours', 'Esprit', 'subject-math', 'Brain', 't110-theme'),
  ('t110-out', 'Hors parcours',    'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title) VALUES
  ('e8111000-0000-4000-8000-000000000001', 't110-in',  'Ch in'),
  ('e8111000-0000-4000-8000-000000000002', 't110-out', 'Ch out');
INSERT INTO public.exercises (id, chapter_id, subject_id, title) VALUES
  ('e8112000-0000-4000-8000-000000000001', 'e8111000-0000-4000-8000-000000000001', 't110-in',  'Ex in'),
  ('e8112000-0000-4000-8000-000000000002', 'e8111000-0000-4000-8000-000000000002', 't110-out', 'Ex out');

-- Comptes : parent P (lié à l'enfant K), parent Q (non lié), parent R (lien coupé),
-- l'enfant K, un enfant Z sans activité, un enfant N sans parcours, 29 camarades.
INSERT INTO auth.users (id, email) VALUES
  ('e8110000-0000-4000-8000-0000000000a1', 'cmp-p@test.local'),
  ('e8110000-0000-4000-8000-0000000000a2', 'cmp-q@test.local'),
  ('e8110000-0000-4000-8000-0000000000a3', 'cmp-r@test.local'),
  ('e8110000-0000-4000-8000-0000000000b1', 'cmp-k@test.local'),
  ('e8110000-0000-4000-8000-0000000000b2', 'cmp-z@test.local'),
  ('e8110000-0000-4000-8000-0000000000b3', 'cmp-n@test.local');
INSERT INTO auth.users (id, email)
SELECT ('e8110000-0000-4000-8000-0000000c' || lpad(g::text, 4, '0'))::uuid, 'cmp-c' || g || '@test.local'
  FROM generate_series(1, 29) g;

INSERT INTO public.profiles (id, display_name)
SELECT u.id, 'x' FROM auth.users u WHERE u.id::text LIKE 'e8110000-%'
ON CONFLICT (id) DO NOTHING;

UPDATE public.profiles SET role = 'parent'
 WHERE id IN ('e8110000-0000-4000-8000-0000000000a1', 'e8110000-0000-4000-8000-0000000000a2',
              'e8110000-0000-4000-8000-0000000000a3');
UPDATE public.profiles SET current_parcours_id = 't110-parcours'
 WHERE id IN ('e8110000-0000-4000-8000-0000000000b1', 'e8110000-0000-4000-8000-0000000000b2');

INSERT INTO public.parent_student_links (parent_user_id, student_user_id, relation_label, is_active) VALUES
  ('e8110000-0000-4000-8000-0000000000a1', 'e8110000-0000-4000-8000-0000000000b1', 'parent', true),
  ('e8110000-0000-4000-8000-0000000000a1', 'e8110000-0000-4000-8000-0000000000b2', 'parent', true),
  ('e8110000-0000-4000-8000-0000000000a1', 'e8110000-0000-4000-8000-0000000000b3', 'parent', true),
  ('e8110000-0000-4000-8000-0000000000a3', 'e8110000-0000-4000-8000-0000000000b1', 'parent', false);

-- L'enfant K : deux missions du parcours (80 et 60 → 70), 40 min d'apprentissage
-- mesurées sur 28 jours (→ 10 min/semaine) + de la navigation qui ne compte pas ;
-- une mission HORS parcours et une mission VIEILLE de 40 jours, ignorées.
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, completed_at)
VALUES
  ('e8110000-0000-4000-8000-0000000000b1', 'e8112000-0000-4000-8000-000000000001', 't110-in', 8, 10, 80, 60, 1, now() - INTERVAL '2 days'),
  ('e8110000-0000-4000-8000-0000000000b1', 'e8112000-0000-4000-8000-000000000001', 't110-in', 6, 10, 60, 60, 1, now() - INTERVAL '3 days'),
  ('e8110000-0000-4000-8000-0000000000b1', 'e8112000-0000-4000-8000-000000000002', 't110-out', 0, 10, 0, 60, 1, now() - INTERVAL '2 days'),
  ('e8110000-0000-4000-8000-0000000000b1', 'e8112000-0000-4000-8000-000000000001', 't110-in', 0, 10, 0, 60, 1, now() - INTERVAL '40 days');
INSERT INTO public.learning_pulses (user_id, surface, subject_id, active_seconds, occurred_at)
SELECT 'e8110000-0000-4000-8000-0000000000b1', 'exercise', 't110-in', 300, now() - (g || ' hours')::interval
  FROM generate_series(1, 8) g;
INSERT INTO public.learning_pulses (user_id, surface, subject_id, active_seconds, occurred_at) VALUES
  ('e8110000-0000-4000-8000-0000000000b1', 'browse', 't110-in', 300, now() - INTERVAL '9 hours');

-- 28 camarades : 14 à 40 %, 14 à 60 %. Le premier rend DIX missions à 40 % —
-- s'il pesait dix voix, la moyenne bougerait (« un élève = une voix »).
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, completed_at)
SELECT ('e8110000-0000-4000-8000-0000000c' || lpad(g::text, 4, '0'))::uuid,
       'e8112000-0000-4000-8000-000000000001', 't110-in', 1, 10,
       CASE WHEN g <= 14 THEN 40 ELSE 60 END, 60, 1, now() - INTERVAL '1 day'
  FROM generate_series(1, 28) g;
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, completed_at)
SELECT 'e8110000-0000-4000-8000-0000000c0001', 'e8112000-0000-4000-8000-000000000001',
       't110-in', 4, 10, 40, 60, 1, now() - (g || ' hours')::interval
  FROM generate_series(1, 9) g;

-- Un PARENT qui a joué sur le parcours ne compte pas parmi les élèves.
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, completed_at)
VALUES ('e8110000-0000-4000-8000-0000000000a2', 'e8112000-0000-4000-8000-000000000001',
        't110-in', 10, 10, 100, 60, 1, now() - INTERVAL '1 day');

-- ---------------------------------------------------------
-- 1. La surface.
-- ---------------------------------------------------------
SELECT is(has_function_privilege('anon', 'public.get_parcours_platform_stats(text)', 'EXECUTE'),
  false, 'anon : pas d''agrégat');
SELECT is(has_function_privilege('anon', 'public.get_student_parcours_comparison(uuid)', 'EXECUTE'),
  false, 'anon : pas de comparatif');
SELECT is(has_function_privilege('authenticated', 'public._parcours_student_stats(text, uuid)', 'EXECUTE'),
  false, 'anonymat : la mesure PAR ÉLÈVE est inatteignable par un client');
SELECT is(
  (SELECT bool_and(p.prosecdef AND p.proconfig @> ARRAY['search_path=public'])
     FROM pg_proc p
    WHERE p.proname IN ('get_parcours_platform_stats', 'get_student_parcours_comparison', '_parcours_student_stats')),
  true, 'les trois fonctions : SECURITY DEFINER, search_path fixé');

-- ---------------------------------------------------------
-- 2. À 29 élèves actifs (K + 28) : masqué, sans chiffre ni effectif.
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"e8110000-0000-4000-8000-0000000000a1","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  public.get_parcours_platform_stats('t110-parcours'),
  jsonb_build_object('masked', true, 'minStudents', 30, 'windowDays', 28,
                     'students', NULL, 'avgScore', NULL, 'weeklyMinutes', NULL),
  'R-6 : à 29 élèves, ni moyenne ni effectif');

SELECT is(
  public.get_student_parcours_comparison('e8110000-0000-4000-8000-0000000000b1') -> 'student',
  jsonb_build_object('avgScore', 70, 'weeklyMinutes', 10),
  'l''enfant : missions du parcours et de la fenêtre seulement, navigation exclue du temps');

SELECT is(
  (public.get_student_parcours_comparison('e8110000-0000-4000-8000-0000000000b1')
     -> 'platform' ->> 'masked')::boolean, true,
  'le comparatif de l''enfant porte le même masque');

SELECT is(
  public.get_student_parcours_comparison('e8110000-0000-4000-8000-0000000000b1') -> 'parcours',
  jsonb_build_object('nameFr', 'Parcours 110', 'nameEn', NULL, 'nameAr', 'مسار 110'),
  'le parcours est nommé dans les trois langues disponibles');

-- ---------------------------------------------------------
-- 3. Le 30ᵉ élève rend une mission : la moyenne sort.
-- ---------------------------------------------------------
RESET ROLE;
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, completed_at)
VALUES ('e8110000-0000-4000-8000-0000000c0029', 'e8112000-0000-4000-8000-000000000001',
        't110-in', 5, 10, 50, 60, 1, now() - INTERVAL '1 day');

SET LOCAL "request.jwt.claims" = '{"sub":"e8110000-0000-4000-8000-0000000000a1","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT set_config('test.stats', public.get_parcours_platform_stats('t110-parcours')::text, true);

SELECT is((current_setting('test.stats')::jsonb ->> 'masked')::boolean, false,
  'R-6 : à 30 élèves, l''agrégat s''affiche');
SELECT is((current_setting('test.stats')::jsonb ->> 'students')::int, 30,
  '30 élèves — le parent joueur n''est pas compté');
-- (70 + 14×40 + 14×60 + 50) / 30 = 50,67 → 51. Pondérée par mission, elle
-- tomberait à 48 : le camarade aux dix missions ne pèse qu'une voix.
SELECT is((current_setting('test.stats')::jsonb ->> 'avgScore')::int, 51,
  'un élève = une voix : moyenne des moyennes par élève');
-- 40 min pour K, 0 pour les 29 autres : 10 min/sem ÷ 30 = 0,33 → 0.
SELECT is((current_setting('test.stats')::jsonb ->> 'weeklyMinutes')::int, 0,
  'le temps hebdo est une moyenne par élève, arrondie');
SELECT is(
  (SELECT array_agg(k ORDER BY k) FROM jsonb_object_keys(current_setting('test.stats')::jsonb) k),
  ARRAY['avgScore', 'masked', 'minStudents', 'students', 'weeklyMinutes', 'windowDays'],
  'D-3 : un agrégat et rien d''autre — ni rang, ni min/max, ni liste');
SELECT ok(
  public.get_student_parcours_comparison('e8110000-0000-4000-8000-0000000000b1')::text !~ 'e8110000',
  'anonymat : aucun identifiant d''élève dans la charge du comparatif');

-- ---------------------------------------------------------
-- 4. Vides honnêtes.
-- ---------------------------------------------------------
SELECT is(
  public.get_student_parcours_comparison('e8110000-0000-4000-8000-0000000000b2') -> 'student',
  'null'::jsonb, 'enfant sans mission sur la fenêtre : pas de chiffre inventé');
SELECT is(
  public.get_student_parcours_comparison('e8110000-0000-4000-8000-0000000000b3'),
  NULL, 'enfant sans parcours : rien à comparer');
SELECT is(
  (public.get_parcours_platform_stats('parcours-inconnu') ->> 'masked')::boolean, true,
  'parcours inconnu : masqué, pas d''erreur bavarde');

-- ---------------------------------------------------------
-- 5. Accès au comparatif d'un enfant.
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"e8110000-0000-4000-8000-0000000000a2","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT throws_ok(
  $$SELECT public.get_student_parcours_comparison('e8110000-0000-4000-8000-0000000000b1')$$,
  'Access denied: you are not linked to this student.', 'parent non lié : refusé');

RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"e8110000-0000-4000-8000-0000000000a3","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT throws_ok(
  $$SELECT public.get_student_parcours_comparison('e8110000-0000-4000-8000-0000000000b1')$$,
  'Access denied: you are not linked to this student.', 'lien coupé : refusé');

RESET ROLE;
SET LOCAL ROLE anon;
SELECT throws_ok(
  $$SELECT public.get_student_parcours_comparison('e8110000-0000-4000-8000-0000000000b1')$$,
  '42501', NULL, 'anonyme : refusé');
SELECT throws_ok(
  $$SELECT public.get_parcours_platform_stats('t110-parcours')$$,
  '42501', NULL, 'anonyme : pas d''agrégat non plus');

SELECT * FROM finish();
ROLLBACK;
