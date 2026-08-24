-- =========================================================
-- Étude 11 — lot 3 : le chat cadré, côté base.
-- ---------------------------------------------------------
-- ⚠️ L'ASSERTION LA PLUS IMPORTANTE DU FICHIER est celle de la section 1.2 :
-- `get_tutor_chapter_context` ne rend AUCUNE clé de réponse.
--
-- C'est la différence de nature entre les deux surfaces du tuteur. L'explication
-- post-review peut recevoir la correction complète, parce que R-1 garantit que
-- l'élève a déjà soumis. Le chat, lui, se tient à côté du COURS — souvent avant
-- toute tentative — donc R-16 s'applique dans sa forme la plus stricte : le
-- modèle ne peut pas divulguer ce qu'il n'a pas reçu.
--
-- Si cette assertion tombe, le chat devient une antisèche, et tout le lot avec.
--
-- Plus la borne de mémoire (§1.5, dix messages) et l'historique (US-9).
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(12);

-- ---------------------------------------------------------
-- Décor : un chapitre avec un cours, un exercice, une question CORRIGÉE.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at,
                        raw_user_meta_data, created_at, updated_at,
                        aud, role, instance_id)
VALUES
  ('a2000000-0000-4000-8000-000000000001', 'chat-eleve@test.local', 'x', now(),
   '{"display_name":"Eleve"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'),
  ('a2000000-0000-4000-8000-000000000002', 'chat-voisin@test.local', 'x', now(),
   '{"display_name":"Voisin"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000');

INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('tc-theme', 'TC', 'Brain', 'subject-math', true);

INSERT INTO public.grades (id, theme_id, slug, name_fr, cycle, display_order)
VALUES ('a2000000-0000-4000-8000-0000000000f1'::uuid, 'tc-theme', 'tc-9', 'TC 9ème', 'college', 9);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id, content_language)
VALUES ('tc-subj', 'TC Maths', 'Esprit', 'subject-math', 'Brain', 'tc-theme',
        'a2000000-0000-4000-8000-0000000000f1'::uuid, 'fr');

INSERT INTO public.chapters (id, subject_id, title, summary, lesson_content)
VALUES ('a2000000-0000-4000-8000-0000000000c1'::uuid, 'tc-subj', 'TC Fractions',
        'Résumé TC', '## Addition' || E'\n' || 'On garde le dénominateur.');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, mode, source)
VALUES ('a2000000-0000-4000-8000-0000000000e1'::uuid,
        'a2000000-0000-4000-8000-0000000000c1'::uuid, 'tc-subj', 'TC Ex', 1, 'practice', 'admin');

-- La question porte une clé ET une explication canonique : c'est exactement ce
-- que le contexte de CHAPITRE ne doit pas laisser fuir.
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order)
VALUES ('a2000000-0000-4000-8000-0000000000a1'::uuid, 'a2000000-0000-4000-8000-0000000000e1'::uuid,
        'TC question', '[{"id":"a","text":"3/4"},{"id":"b","text":"3/12"}]'::jsonb,
        'a', 'SECRET-EXPLICATION-CANONIQUE', 1);

UPDATE public.profiles SET current_grade_id = 'a2000000-0000-4000-8000-0000000000f1'::uuid
 WHERE id IN ('a2000000-0000-4000-8000-000000000001'::uuid,
              'a2000000-0000-4000-8000-000000000002'::uuid);

SET LOCAL request.jwt.claims = '{"sub":"a2000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- =========================================================
-- 1. Le contexte du chapitre.
-- =========================================================
SELECT is(
  (public.get_tutor_chapter_context('a2000000-0000-4000-8000-0000000000c1'::uuid))->>'chapter_title',
  'TC Fractions',
  'le chat reçoit le cours du chapitre'
);

-- ⭐ L'assertion qui tient tout le lot.
SELECT ok(
  (public.get_tutor_chapter_context('a2000000-0000-4000-8000-0000000000c1'::uuid))::TEXT
    NOT LIKE '%SECRET-EXPLICATION-CANONIQUE%',
  '⭐ R-16 : le contexte de CHAPITRE ne porte aucune correction — le chat n''est pas post-review'
);

SELECT is(
  (public.get_tutor_chapter_context('a2000000-0000-4000-8000-0000000000c1'::uuid))->>'age_band',
  '12-14',
  'R-4 : la bande d''âge est dérivée de la CLASSE, jamais collectée'
);

SELECT is(
  (public.get_tutor_chapter_context('a2000000-0000-4000-8000-0000000000c1'::uuid))->>'lang',
  'fr',
  'R-3 : la langue est celle de la MATIÈRE, pas celle de l''interface'
);

SELECT is(
  (public.get_tutor_chapter_context('a2000000-0000-4000-8000-0000000000cf'::uuid))->>'found',
  'false',
  'un chapitre inexistant rend un état, pas une exception'
);

-- =========================================================
-- 2. Le fil de chapitre.
-- =========================================================
SELECT is(
  (public.open_tutor_chapter_thread(
     'a2000000-0000-4000-8000-0000000000c1'::uuid, 'fr', '12-14'))->>'message_count',
  '0',
  'un fil neuf est vide'
);

-- Le MÊME fil doit être retrouvé, pas un second : rouvrir le lecteur ne
-- redémarre pas la conversation.
SELECT is(
  (public.open_tutor_chapter_thread(
     'a2000000-0000-4000-8000-0000000000c1'::uuid, 'fr', '12-14'))->>'thread_id',
  (SELECT id::TEXT FROM public.tutor_threads
    WHERE user_id = 'a2000000-0000-4000-8000-000000000001'::uuid
      AND scope = 'chapter' AND status = 'active'),
  'rouvrir le chapitre RETROUVE le fil, il n''en crée pas un second'
);

SELECT is(
  (SELECT count(*)::INT FROM public.tutor_threads
    WHERE user_id = 'a2000000-0000-4000-8000-000000000001'::uuid AND scope = 'chapter'),
  1,
  '…et la base n''en contient toujours qu''un'
);

-- =========================================================
-- 3. La borne de mémoire — §1.5, dix messages.
-- =========================================================
RESET ROLE;

UPDATE public.tutor_threads
   SET messages = (
     SELECT jsonb_agg(jsonb_build_object('role', 'student', 'content', 'm' || n))
       FROM generate_series(1, 25) n
   )
 WHERE user_id = 'a2000000-0000-4000-8000-000000000001'::uuid AND scope = 'chapter';

SET LOCAL request.jwt.claims = '{"sub":"a2000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  jsonb_array_length(
    (public.open_tutor_chapter_thread(
       'a2000000-0000-4000-8000-0000000000c1'::uuid, 'fr', '12-14'))->'messages'),
  10,
  '§1.5 : la fenêtre transmise est bornée à dix messages, en BASE'
);

SELECT ok(
  (public.open_tutor_chapter_thread(
     'a2000000-0000-4000-8000-0000000000c1'::uuid, 'fr', '12-14'))->'messages' @> '[{"content":"m25"}]'::jsonb,
  '…et ce sont les DERNIERS, pas les premiers'
);

-- L'élève, lui, relit son fil ENTIER : la borne protège le prompt, pas lui.
SELECT is(
  jsonb_array_length(
    (public.get_tutor_thread(
       (SELECT id FROM public.tutor_threads
         WHERE user_id = 'a2000000-0000-4000-8000-000000000001'::uuid AND scope = 'chapter')
     ))->'messages'),
  25,
  'US-9 / R-14 : l''élève relit son fil entier — la borne protège le PROMPT'
);

-- =========================================================
-- 4. L'historique est nominatif.
-- =========================================================
SET LOCAL request.jwt.claims = '{"sub":"a2000000-0000-4000-8000-000000000002","role":"authenticated"}';

SELECT is(
  (SELECT count(*)::INT FROM public.list_tutor_threads(20)),
  0,
  'un élève ne voit JAMAIS les conversations d''un autre'
);

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
