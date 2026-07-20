-- =========================================================
-- Étude 04, lot A1.1 (US-1, D-3, R-3, R-4) — « Révision du jour ».
-- ---------------------------------------------------------
-- `get_daily_plan` est un SÉLECTEUR : elle ne crée ni session, ni récompense, ni verrou.
-- Ce fichier prouve les quatre choses qui peuvent la rendre fausse :
--
--   1. ce qu'elle voit — seules les révisions ÉCHUES et encore ouvertes, celles de l'appelant ;
--   2. dans quel ORDRE (D-3) — le retard SM-2 domine, les misconceptions actives arbitrent ;
--   3. le SEUIL R-2 — une erreur ni installée ni reproduite ne pèse rien ;
--   4. la PORTE (R-3) — un exercice verrouillé n'est jamais servi : il est remplacé par une
--      mission d1–2 du même chapitre, ou il disparaît du plan.
--
-- Plus le plafond dur de trois (R-4), que l'appelant ne peut pas desserrer, et les droits
-- d'exécution.
--
-- La fonction est SECURITY INVOKER : ces tests s'exécutent donc en rôle `authenticated` avec
-- un JWT posé, exactement comme un vrai appel — la RLS des tables lues est dans le périmètre
-- testé, pas contournée. Tout est annulé à la fin.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(16);

-- ---------------------------------------------------------
-- Catalogue : un thème, deux classes — l'une gratuite, l'autre premium (la porte R-3 n'a
-- rien à mordre en phase gratuite, où tout parcours est `is_premium = false` ; on la teste
-- donc sur un parcours premium fabriqué ici).
-- ---------------------------------------------------------
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('dp-theme', 'DP Theme', 'Brain', 'subject-math', true);

INSERT INTO public.grades (id, theme_id, slug, name_fr, cycle, display_order)
VALUES
  ('da000000-0000-0000-0000-0000000000f1'::uuid, 'dp-theme', 'dp-free', 'DP Free', 'college', 981),
  ('da000000-0000-0000-0000-0000000000f2'::uuid, 'dp-theme', 'dp-prem', 'DP Prem', 'college', 982);

INSERT INTO public.parcours (id, name_fr, kind, theme_id, grade_id, is_premium, preview_policy, icon, color)
VALUES
  ('dp-par-free', 'DP Libre', 'concours', 'dp-theme',
   'da000000-0000-0000-0000-0000000000f1'::uuid, false, 'full', 'Brain', 'subject-math'),
  -- `difficulty_1` : l'aperçu gratuit ouvre le quiz et les missions ⭐, rien au-dessus.
  ('dp-par-prem', 'DP Premium', 'concours', 'dp-theme',
   'da000000-0000-0000-0000-0000000000f2'::uuid, true, 'difficulty_1', 'Brain', 'subject-math');

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id)
VALUES
  ('dp-subj-free', 'DP Libre', 'Esprit', 'subject-math', 'Brain', 'dp-theme',
   'da000000-0000-0000-0000-0000000000f1'::uuid),
  ('dp-subj-prem', 'DP Premium', 'Esprit', 'subject-math', 'Brain', 'dp-theme',
   'da000000-0000-0000-0000-0000000000f2'::uuid);

-- Chapitre A « propre », chapitre B « à misconceptions », chapitres premium P et Z.
INSERT INTO public.chapters (id, subject_id, title)
VALUES
  ('db000000-0000-0000-0000-0000000000a1'::uuid, 'dp-subj-free', 'Chapitre A'),
  ('db000000-0000-0000-0000-0000000000b1'::uuid, 'dp-subj-free', 'Chapitre B'),
  ('db000000-0000-0000-0000-0000000000c1'::uuid, 'dp-subj-prem', 'Chapitre P'),
  ('db000000-0000-0000-0000-0000000000d1'::uuid, 'dp-subj-prem', 'Chapitre Z');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, difficulty, display_order, source)
VALUES
  -- Chapitre A (propre)
  ('dc000000-0000-0000-0000-000000000001'::uuid, 'db000000-0000-0000-0000-0000000000a1'::uuid,
   'dp-subj-free', 'Ex 1 (20 j)', 'practice', 2, 1, 'admin'),
  ('dc000000-0000-0000-0000-000000000003'::uuid, 'db000000-0000-0000-0000-0000000000a1'::uuid,
   'dp-subj-free', 'Ex 3 (1 j)', 'practice', 2, 3, 'admin'),
  ('dc000000-0000-0000-0000-000000000004'::uuid, 'db000000-0000-0000-0000-0000000000a1'::uuid,
   'dp-subj-free', 'Ex 4 (a venir)', 'practice', 2, 4, 'admin'),
  ('dc000000-0000-0000-0000-000000000005'::uuid, 'db000000-0000-0000-0000-0000000000a1'::uuid,
   'dp-subj-free', 'Ex 5 (deja revise)', 'practice', 2, 5, 'admin'),
  ('dc000000-0000-0000-0000-000000000006'::uuid, 'db000000-0000-0000-0000-0000000000a1'::uuid,
   'dp-subj-free', 'Ex 6 (2 j)', 'practice', 2, 6, 'admin'),
  ('dc000000-0000-0000-0000-000000000007'::uuid, 'db000000-0000-0000-0000-0000000000a1'::uuid,
   'dp-subj-free', 'Ex 7 (du a un AUTRE eleve)', 'practice', 2, 7, 'admin'),
  -- Chapitre B (celui où l'élève exécute des erreurs nommées)
  ('dc000000-0000-0000-0000-000000000002'::uuid, 'db000000-0000-0000-0000-0000000000b1'::uuid,
   'dp-subj-free', 'Ex 2 (10 j)', 'practice', 2, 2, 'admin'),
  -- Chapitre P (premium) : le d3 dû est verrouillé, le d1 est le repli, le quiz n'en est pas un.
  ('dc000000-0000-0000-0000-0000000000e3'::uuid, 'db000000-0000-0000-0000-0000000000c1'::uuid,
   'dp-subj-prem', 'Ex P3 (verrouille)', 'practice', 3, 3, 'admin'),
  ('dc000000-0000-0000-0000-0000000000e1'::uuid, 'db000000-0000-0000-0000-0000000000c1'::uuid,
   'dp-subj-prem', 'Ex P1 (repli)', 'practice', 1, 2, 'admin'),
  -- display_order 1 : il gagnerait le tri du repli s'il n'était pas exclu par son mode.
  ('dc000000-0000-0000-0000-0000000000ec'::uuid, 'db000000-0000-0000-0000-0000000000c1'::uuid,
   'dp-subj-prem', 'Quiz P (porte du chapitre)', 'quiz', 1, 1, 'admin'),
  -- Chapitre Z (premium) : rien d'accessible, donc aucun repli possible.
  ('dc000000-0000-0000-0000-0000000000f3'::uuid, 'db000000-0000-0000-0000-0000000000d1'::uuid,
   'dp-subj-prem', 'Ex Z3 (verrouille, sans repli)', 'practice', 3, 1, 'admin');

INSERT INTO auth.users (id, email) VALUES
  ('dd000000-0000-0000-0000-000000000001', 'dp-u1@test.local'),
  ('dd000000-0000-0000-0000-000000000002', 'dp-u2@test.local'),
  ('dd000000-0000-0000-0000-000000000003', 'dp-u3@test.local'),
  ('dd000000-0000-0000-0000-000000000004', 'dp-u4@test.local'),
  ('dd000000-0000-0000-0000-000000000005', 'dp-u5@test.local'),
  ('dd000000-0000-0000-0000-000000000009', 'dp-autre@test.local');

-- =========================================================
-- CASE 1 — ce que la fonction voit, dans quel ordre, et son plafond.
-- =========================================================
INSERT INTO public.spaced_repetition_schedule
  (user_id, exercise_id, subject_id, retry_level, scheduled_for, status)
VALUES
  ('dd000000-0000-0000-0000-000000000001', 'dc000000-0000-0000-0000-000000000001'::uuid,
   'dp-subj-free', 1, now() - INTERVAL '20 days', 'pending'),
  ('dd000000-0000-0000-0000-000000000001', 'dc000000-0000-0000-0000-000000000002'::uuid,
   'dp-subj-free', 1, now() - INTERVAL '10 days', 'pending'),
  ('dd000000-0000-0000-0000-000000000001', 'dc000000-0000-0000-0000-000000000006'::uuid,
   'dp-subj-free', 1, now() - INTERVAL '2 days', 'pending'),
  ('dd000000-0000-0000-0000-000000000001', 'dc000000-0000-0000-0000-000000000003'::uuid,
   'dp-subj-free', 1, now() - INTERVAL '1 day', 'pending'),
  -- Pas encore échue : une révision d'avance n'est pas une révision du jour.
  ('dd000000-0000-0000-0000-000000000001', 'dc000000-0000-0000-0000-000000000004'::uuid,
   'dp-subj-free', 1, now() + INTERVAL '3 days', 'pending'),
  -- Refermée par la réussite (étude 22, lot 2) : elle ne doit plus jamais remonter.
  ('dd000000-0000-0000-0000-000000000001', 'dc000000-0000-0000-0000-000000000005'::uuid,
   'dp-subj-free', 1, now() - INTERVAL '5 days', 'completed'),
  -- Le retard le plus fort de toute la table… mais il appartient à quelqu'un d'autre.
  ('dd000000-0000-0000-0000-000000000009', 'dc000000-0000-0000-0000-000000000007'::uuid,
   'dp-subj-free', 1, now() - INTERVAL '30 days', 'pending');

SET LOCAL "request.jwt.claims" = '{"sub":"dd000000-0000-0000-0000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.get_daily_plan()),
  3,
  'R-4 : le plan est plafonne a trois, meme avec quatre revisions echues'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_daily_plan(99)),
  3,
  'R-4 : le plafond est SERVEUR — demander 99 n''en donne pas plus de trois'
);

SELECT is(
  (SELECT array_agg(p.exercise_id ORDER BY p.days_overdue DESC) FROM public.get_daily_plan() p),
  ARRAY['dc000000-0000-0000-0000-000000000001'::uuid,
        'dc000000-0000-0000-0000-000000000002'::uuid,
        'dc000000-0000-0000-0000-000000000006'::uuid],
  'D-3 : a chapitres egaux, le retard SM-2 ordonne — et le moins en retard sort du plan'
);

SELECT is(
  (SELECT p.days_overdue FROM public.get_daily_plan() p
    WHERE p.exercise_id = 'dc000000-0000-0000-0000-000000000001'::uuid),
  20,
  'le retard est rendu en jours pleins, tel que la raison l''affichera'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_daily_plan(99) p
    WHERE p.exercise_id IN ('dc000000-0000-0000-0000-000000000004'::uuid,
                            'dc000000-0000-0000-0000-000000000005'::uuid)),
  0,
  'ni l''echeance a venir ni la revision refermee n''entrent dans le plan'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_daily_plan(99) p
    WHERE p.exercise_id = 'dc000000-0000-0000-0000-000000000007'::uuid),
  0,
  'la revision la plus en retard d''un AUTRE eleve reste invisible'
);

RESET ROLE;

-- =========================================================
-- CASE 2 — les misconceptions actives arbitrent (D-3, terme 2).
-- L'élève 2 a le même arriéré que l'élève 1 sur A (20 j) et B (10 j), mais il exécute trois
-- erreurs nommées dans le chapitre B. Le chapitre diagnostiqué doit passer devant.
-- =========================================================
INSERT INTO public.spaced_repetition_schedule
  (user_id, exercise_id, subject_id, retry_level, scheduled_for, status)
VALUES
  ('dd000000-0000-0000-0000-000000000002', 'dc000000-0000-0000-0000-000000000001'::uuid,
   'dp-subj-free', 1, now() - INTERVAL '20 days', 'pending'),
  ('dd000000-0000-0000-0000-000000000002', 'dc000000-0000-0000-0000-000000000002'::uuid,
   'dp-subj-free', 1, now() - INTERVAL '10 days', 'pending');

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
VALUES
  ('de000000-0000-0000-0000-000000000002'::uuid, 'dc000000-0000-0000-0000-000000000002'::uuid,
   'Q du chapitre B', '[{"id":"a","text":"juste"},{"id":"b","text":"faux"}]'::jsonb, 'a', 1);

-- Trois tags, chacun vu 3 fois sur 2 sessions : le seuil R-2 est franchi pour les trois, et
-- l'agrégat `user_misconceptions` est bâti par le trigger d'A0.1 (jamais à la main).
INSERT INTO public.question_attempts
  (user_id, question_id, chapter_id, session_id, choice, is_correct, misconception_tag, source, created_at)
SELECT
  'dd000000-0000-0000-0000-000000000002',
  'de000000-0000-0000-0000-000000000002'::uuid,
  'db000000-0000-0000-0000-0000000000b1'::uuid,
  CASE WHEN occurrence < 3 THEN 'df000000-0000-0000-0000-00000000000a'::uuid
                           ELSE 'df000000-0000-0000-0000-00000000000b'::uuid END,
  'b', false,
  'dp.tag.' || tag_no,
  'exercise',
  now() - INTERVAL '2 days'
FROM generate_series(1, 3) AS tag_no, generate_series(1, 3) AS occurrence;

SET LOCAL "request.jwt.claims" = '{"sub":"dd000000-0000-0000-0000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT p.exercise_id FROM public.get_daily_plan() p LIMIT 1),
  'dc000000-0000-0000-0000-000000000002'::uuid,
  'D-3 : le chapitre ou l''eleve execute des erreurs nommees passe devant un retard deux fois plus long'
);

SELECT is(
  (SELECT p.weak_tags FROM public.get_daily_plan() p
    WHERE p.exercise_id = 'dc000000-0000-0000-0000-000000000002'::uuid),
  3,
  'le plan expose le nombre de misconceptions actives du chapitre'
);

RESET ROLE;

-- =========================================================
-- CASE 3 — le seuil R-2 n'est pas une formalité.
-- L'élève 3 a les mêmes erreurs dans le chapitre B, mais deux fois seulement et dans une
-- seule session : rien n'est « actif », donc rien ne bouscule l'ordre du retard.
-- =========================================================
INSERT INTO public.spaced_repetition_schedule
  (user_id, exercise_id, subject_id, retry_level, scheduled_for, status)
VALUES
  ('dd000000-0000-0000-0000-000000000003', 'dc000000-0000-0000-0000-000000000001'::uuid,
   'dp-subj-free', 1, now() - INTERVAL '20 days', 'pending'),
  ('dd000000-0000-0000-0000-000000000003', 'dc000000-0000-0000-0000-000000000002'::uuid,
   'dp-subj-free', 1, now() - INTERVAL '10 days', 'pending');

INSERT INTO public.question_attempts
  (user_id, question_id, chapter_id, session_id, choice, is_correct, misconception_tag, source, created_at)
SELECT
  'dd000000-0000-0000-0000-000000000003',
  'de000000-0000-0000-0000-000000000002'::uuid,
  'db000000-0000-0000-0000-0000000000b1'::uuid,
  'df000000-0000-0000-0000-00000000000c'::uuid,   -- une seule session
  'b', false,
  'dp.tag.' || tag_no,
  'exercise',
  now() - INTERVAL '2 days'
FROM generate_series(1, 3) AS tag_no, generate_series(1, 2) AS occurrence;  -- 2 occurrences

SET LOCAL "request.jwt.claims" = '{"sub":"dd000000-0000-0000-0000-000000000003","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT p.exercise_id FROM public.get_daily_plan() p LIMIT 1),
  'dc000000-0000-0000-0000-000000000001'::uuid,
  'R-2 : une erreur ni installee (< 3 fois) ni reproduite (1 session) ne pese rien'
);

SELECT is(
  (SELECT p.weak_tags FROM public.get_daily_plan() p
    WHERE p.exercise_id = 'dc000000-0000-0000-0000-000000000002'::uuid),
  0,
  'R-2 : sous le seuil, le chapitre est compte comme sain'
);

RESET ROLE;

-- =========================================================
-- CASE 4 — R-3 : la porte d'accès, et son repli.
-- L'élève 4 doit réviser un d3 d'un parcours premium qu'il n'a pas déverrouillé.
-- =========================================================
INSERT INTO public.spaced_repetition_schedule
  (user_id, exercise_id, subject_id, retry_level, scheduled_for, status)
VALUES
  ('dd000000-0000-0000-0000-000000000004', 'dc000000-0000-0000-0000-0000000000e3'::uuid,
   'dp-subj-prem', 1, now() - INTERVAL '5 days', 'pending');

SET LOCAL "request.jwt.claims" = '{"sub":"dd000000-0000-0000-0000-000000000004","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT p.exercise_id FROM public.get_daily_plan() p),
  'dc000000-0000-0000-0000-0000000000e1'::uuid,
  'R-3 : l''exercice verrouille cede la place a une mission d1-2 du MEME chapitre'
);

SELECT is(
  (SELECT p.is_fallback FROM public.get_daily_plan() p),
  true,
  'R-3 : le plan dit qu''il a substitue, il ne le cache pas'
);

SELECT is(
  (SELECT count(*)::int FROM public.get_daily_plan(99) p
    WHERE p.exercise_id IN ('dc000000-0000-0000-0000-0000000000e3'::uuid,
                            'dc000000-0000-0000-0000-0000000000ec'::uuid)),
  0,
  'R-3 : ni l''exercice verrouille ni le quiz de comprehension ne sont servis'
);

RESET ROLE;

-- =========================================================
-- CASE 5 — quand il n'y a rien d'accessible, on ne propose RIEN.
-- Le chapitre Z n'a qu'un d3 verrouillé : pas de repli, donc pas de ligne. Un plan qui
-- pointerait vers un refus vaudrait moins qu'un plan vide.
-- =========================================================
INSERT INTO public.spaced_repetition_schedule
  (user_id, exercise_id, subject_id, retry_level, scheduled_for, status)
VALUES
  ('dd000000-0000-0000-0000-000000000005', 'dc000000-0000-0000-0000-0000000000f3'::uuid,
   'dp-subj-prem', 1, now() - INTERVAL '9 days', 'pending');

SET LOCAL "request.jwt.claims" = '{"sub":"dd000000-0000-0000-0000-000000000005","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.get_daily_plan(99)),
  0,
  'R-3 : sans repli accessible, la revision quitte le plan plutot que de mener a un refus'
);

RESET ROLE;

-- =========================================================
-- CASE 6 — droits d'exécution.
-- =========================================================
SELECT ok(
  has_function_privilege('authenticated', 'public.get_daily_plan(int)', 'EXECUTE'),
  'authenticated peut appeler get_daily_plan'
);

SELECT ok(
  NOT has_function_privilege('anon', 'public.get_daily_plan(int)', 'EXECUTE'),
  'anon ne peut pas appeler get_daily_plan — un plan est nominatif'
);

SELECT * FROM finish();
ROLLBACK;
