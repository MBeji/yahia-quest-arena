-- =========================================================
-- Suivi parental — la couverture du programme DU BILAN.
-- ---------------------------------------------------------
-- Le pgTAP 53 garde la couverture du rapport QUOTIDIEN. Le bilan
-- (`_student_report_json`, sa sous-requête `subjectStats`) n'avait aucune
-- couverture exécutable — découvert en réécrivant sa requête le 2026-08-18
-- (migration 20260818130000, le LATERAL par tentative devenu un appel unique).
--
-- Ce que ce fichier protège :
--
--   1. La couverture affichée au parent est celle de la carte /parcours de
--      l'élève. Une seule règle, deux appelants : la RPC de l'élève et le bilan
--      doivent rendre le MÊME compte.
--   2. ⚠️ Une matière TRAVAILLÉE mais dont aucun chapitre n'est publié doit
--      rester dans le bilan, à 0/0 — pas disparaître. C'est la jointure
--      EXTERNE sur la couverture qui le garantit : `student_parcours_progress`
--      ne rend aucune ligne pour une telle matière, et c'est le COALESCE qui la
--      ramène à 0/0. Transformer ce LEFT JOIN en jointure interne ferait
--      s'évanouir la matière du rapport sans qu'aucun autre test ne bronche.
--
-- Tout est annulé à la fin.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(7);

-- ---------------------------------------------------------
-- Fixtures : un élève, et DEUX matières qu'il a travaillées.
--   A — un chapitre publié (une mission de catalogue), mission réussie.
--   B — un chapitre sans aucune mission de catalogue (rien qu'un quiz), donc
--       NON publié : l'élève y a pourtant une tentative.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('b9000000-0000-0000-0000-0000000000aa', 'bilan-cov-student@test.local');

INSERT INTO public.profiles (id, display_name, role) VALUES
  ('b9000000-0000-0000-0000-0000000000aa', 'BilanCovStudent', 'student')
ON CONFLICT (id) DO UPDATE SET role = EXCLUDED.role;

-- Aucune des deux n'est rattachée à un niveau : le verrou de quiz ne s'applique
-- donc pas (`quiz_gated` exige `grade_id IS NOT NULL`), ce qui isole ce que le
-- test mesure — la publication et la complétion, pas la porte du quiz.
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES
  ('bil-cov-a', 'Bilan Couverture A', 'Esprit', 'subject-math', 'Brain', 'ecole-tn'),
  ('bil-cov-b', 'Bilan Couverture B', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title) VALUES
  ('b9100000-0000-0000-0000-000000000001', 'bil-cov-a', 'Chapitre publié'),
  ('b9100000-0000-0000-0000-000000000002', 'bil-cov-b', 'Chapitre sans mission');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source) VALUES
  ('b9200000-0000-0000-0000-000000000001',
   'b9100000-0000-0000-0000-000000000001', 'bil-cov-a', 'Mission A', 'practice', 'admin'),
  -- Le seul exercice de B est un quiz : son chapitre n'est donc pas « publié ».
  ('b9200000-0000-0000-0000-000000000002',
   'b9100000-0000-0000-0000-000000000002', 'bil-cov-b', 'Quiz B', 'quiz', 'admin');

INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at, completed_at) VALUES
  ('b9400000-0000-0000-0000-000000000001', 'b9000000-0000-0000-0000-0000000000aa',
   'b9200000-0000-0000-0000-000000000001', now() - INTERVAL '2 hours', now() - INTERVAL '118 minutes'),
  ('b9400000-0000-0000-0000-000000000002', 'b9000000-0000-0000-0000-0000000000aa',
   'b9200000-0000-0000-0000-000000000002', now() - INTERVAL '1 hour', now() - INTERVAL '58 minutes');

-- Mission A réussie (≥ 60 %, variante classique) ⇒ chapitre de A terminé.
-- Tentative sur le quiz de B ⇒ B est TRAVAILLÉE, donc présente au bilan.
INSERT INTO public.attempts
  (id, user_id, exercise_id, subject_id, correct_count, total_count, score_pct,
   duration_seconds, xp_earned, variant, session_id, completed_at)
VALUES
  ('b9500000-0000-0000-0000-000000000001', 'b9000000-0000-0000-0000-0000000000aa',
   'b9200000-0000-0000-0000-000000000001', 'bil-cov-a', 9, 10, 90, 300, 0, 'classic',
   'b9400000-0000-0000-0000-000000000001', now() - INTERVAL '118 minutes'),
  ('b9500000-0000-0000-0000-000000000002', 'b9000000-0000-0000-0000-0000000000aa',
   'b9200000-0000-0000-0000-000000000002', 'bil-cov-b', 1, 1, 100, 60, 0, 'classic',
   'b9400000-0000-0000-0000-000000000002', now() - INTERVAL '58 minutes');

-- ---------------------------------------------------------
-- 1–2. La référence : ce que la carte /parcours de l'ÉLÈVE affiche.
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"b9000000-0000-0000-0000-0000000000aa","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT chapters_total FROM public.get_user_parcours_progress(ARRAY['bil-cov-a'])),
  1,
  'référence élève : le chapitre portant une mission de catalogue est publié'
);

SELECT is(
  (SELECT chapters_completed FROM public.get_user_parcours_progress(ARRAY['bil-cov-a'])),
  1,
  'référence élève : sa seule mission étant réussie, le chapitre est terminé'
);

-- ---------------------------------------------------------
-- 3–7. Le BILAN, par le chemin public (anonyme, code alliance).
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL "request.jwt.claims" = '';
SET LOCAL ROLE anon;

SELECT is(
  (SELECT (s ->> 'chaptersTotal')::INT
     FROM jsonb_array_elements(
       public.get_student_report_by_code('b90000000000000000000000000000aa') -> 'subjectStats') s
    WHERE s ->> 'subjectId' = 'bil-cov-a'),
  1,
  'le bilan rend le MÊME dénominateur que la carte de l''élève'
);

SELECT is(
  (SELECT (s ->> 'chaptersCompleted')::INT
     FROM jsonb_array_elements(
       public.get_student_report_by_code('b90000000000000000000000000000aa') -> 'subjectStats') s
    WHERE s ->> 'subjectId' = 'bil-cov-a'),
  1,
  'le bilan rend le MÊME numérateur que la carte de l''élève'
);

-- Le garde-fou de la jointure EXTERNE. `student_parcours_progress` ne rend
-- aucune ligne pour une matière sans chapitre publié : si la jointure devenait
-- interne, la matière quitterait le rapport en silence.
SELECT ok(
  EXISTS (
    SELECT 1
      FROM jsonb_array_elements(
        public.get_student_report_by_code('b90000000000000000000000000000aa') -> 'subjectStats') s
     WHERE s ->> 'subjectId' = 'bil-cov-b'
  ),
  'une matière travaillée SANS chapitre publié reste présente au bilan'
);

SELECT is(
  (SELECT (s ->> 'chaptersTotal')::INT
     FROM jsonb_array_elements(
       public.get_student_report_by_code('b90000000000000000000000000000aa') -> 'subjectStats') s
    WHERE s ->> 'subjectId' = 'bil-cov-b'),
  0,
  'et elle y figure à 0 chapitre publié, pas à NULL'
);

SELECT is(
  (SELECT (s ->> 'chaptersCompleted')::INT
     FROM jsonb_array_elements(
       public.get_student_report_by_code('b90000000000000000000000000000aa') -> 'subjectStats') s
    WHERE s ->> 'subjectId' = 'bil-cov-b'),
  0,
  'et à 0 chapitre terminé'
);

SELECT * FROM finish();
ROLLBACK;
