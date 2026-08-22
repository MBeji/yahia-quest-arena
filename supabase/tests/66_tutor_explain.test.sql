-- =========================================================
-- Étude 11, lot 1 — « Demander au Prof ». Les invariants de la PORTE.
-- ---------------------------------------------------------
-- Ce fichier ne teste pas la pédagogie : il teste les deux règles dont la
-- violation transformerait le tuteur en antisèche.
--
--   R-1  — le tuteur n'existe qu'APRÈS une réponse soumise, et jamais pendant
--          une session d'exercice, un donjon ou un duel en cours ;
--   R-16 — la clé de réponse et l'explication canonique ne sortent de la base
--          QUE si R-1 est franchie. C'est la garde qui rend légitime de mettre
--          la correction dans le contexte d'un modèle.
--
-- Plus l'escalier R-7 (un registre ne se sert jamais deux fois), la frontière du
-- cache mutualisé R-15.2 (une explication privée ne fuit pas chez le voisin), et
-- les droits d'exécution.
--
-- ⚠️ L'ASSERTION LA PLUS IMPORTANTE DU FICHIER est celle de la section 2 : un
-- élève qui n'a pas répondu se voit refuser le contexte. Si elle tombe un jour,
-- toute la légitimité de R-2 tombe avec elle.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(18);

-- ---------------------------------------------------------
-- Décor : un thème, une classe, une matière, un chapitre, un exercice,
-- deux questions. Deux élèves : l'un a répondu, l'autre non.
-- ---------------------------------------------------------
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('tt-theme', 'TT Theme', 'Brain', 'subject-math', true);

INSERT INTO public.grades (id, theme_id, slug, name_fr, cycle, display_order)
VALUES ('d7000000-0000-4000-8000-0000000000f1'::uuid, 'tt-theme', 'tt-9', 'TT 9ème', 'college', 9);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id, content_language)
VALUES ('tt-subj', 'TT Maths', 'Esprit', 'subject-math', 'Brain', 'tt-theme',
        'd7000000-0000-4000-8000-0000000000f1'::uuid, 'ar');

INSERT INTO public.chapters (id, subject_id, title, summary, lesson_content)
VALUES ('d7000000-0000-4000-8000-0000000000c1'::uuid, 'tt-subj', 'TT Fractions',
        'Résumé TT', '## Addition' || E'\n' || 'On garde le dénominateur.');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, mode, source)
VALUES ('d7000000-0000-4000-8000-0000000000e1'::uuid,
        'd7000000-0000-4000-8000-0000000000c1'::uuid, 'tt-subj', 'TT Ex', 1, 'practice', 'admin');

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order)
VALUES
  ('d7000000-0000-4000-8000-0000000000a1'::uuid, 'd7000000-0000-4000-8000-0000000000e1'::uuid,
   'TT question 1', '[{"id":"a","text":"3/4"},{"id":"b","text":"3/12"}]'::jsonb,
   'a', 'On garde le dénominateur commun.', 1),
  ('d7000000-0000-4000-8000-0000000000a2'::uuid, 'd7000000-0000-4000-8000-0000000000e1'::uuid,
   'TT question 2', '[{"id":"a","text":"1"},{"id":"b","text":"2"}]'::jsonb,
   'b', 'Explication 2.', 2);

INSERT INTO auth.users (id, email) VALUES
  ('d7000000-0000-4000-8000-000000000001', 'tt-repondu@test.local'),
  ('d7000000-0000-4000-8000-000000000002', 'tt-pas-repondu@test.local');

INSERT INTO public.misconceptions (tag, subject, label_fr, label_en, label_ar)
VALUES ('tt.frac.add-denominators', 'math', 'Tu additionnes les dénominateurs',
        'You add the denominators', 'تجمع المقامات')
ON CONFLICT (tag) DO NOTHING;

-- L'élève 1 a répondu, et faux : c'est le cas nominal du tuteur.
INSERT INTO public.question_attempts
  (user_id, question_id, chapter_id, session_id, choice, is_correct, source, misconception_tag)
VALUES ('d7000000-0000-4000-8000-000000000001'::uuid,
        'd7000000-0000-4000-8000-0000000000a1'::uuid,
        'd7000000-0000-4000-8000-0000000000c1'::uuid,
        'd7000000-0000-4000-8000-0000000000b1'::uuid,
        'b', false, 'exercise', 'tt.frac.add-denominators');

-- =========================================================
-- 1. R-1 — la porte.
-- =========================================================
SET LOCAL request.jwt.claims = '{"sub":"d7000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.can_use_tutor('question', 'd7000000-0000-4000-8000-0000000000a1'::uuid))->>'reason',
  'OK',
  'R-1 : un élève qui a soumis sa réponse peut demander au Prof'
);

SELECT is(
  (public.can_use_tutor('question', 'd7000000-0000-4000-8000-0000000000a2'::uuid))->>'reason',
  'NOT_ATTEMPTED',
  'R-1 : une question jamais jouée n''ouvre pas le tuteur — même pour un élève qui a joué la voisine'
);

SET LOCAL ROLE postgres;
INSERT INTO public.exercise_sessions (id, user_id, exercise_id)
VALUES ('d7000000-0000-4000-8000-0000000000b9'::uuid,
        'd7000000-0000-4000-8000-000000000001'::uuid,
        'd7000000-0000-4000-8000-0000000000e1'::uuid);
SET LOCAL ROLE authenticated;

SELECT is(
  (public.can_use_tutor('question', 'd7000000-0000-4000-8000-0000000000a1'::uuid))->>'reason',
  'ACTIVE_SESSION',
  'R-1 : une session d''exercice NON terminée referme le tuteur — l''élève peut encore changer sa réponse'
);

SET LOCAL ROLE postgres;
UPDATE public.exercise_sessions SET completed_at = now()
 WHERE id = 'd7000000-0000-4000-8000-0000000000b9'::uuid;
INSERT INTO public.dungeon_runs (id, user_id, current_floor, status)
VALUES ('d7000000-0000-4000-8000-0000000000d9'::uuid,
        'd7000000-0000-4000-8000-000000000001'::uuid, 1, 'active');
SET LOCAL ROLE authenticated;

SELECT is(
  (public.can_use_tutor('question', 'd7000000-0000-4000-8000-0000000000a1'::uuid))->>'reason',
  'ACTIVE_DUNGEON',
  'R-1 : un donjon en cours ferme le tuteur PARTOUT, pas seulement sur les questions du donjon'
);

SET LOCAL ROLE postgres;
UPDATE public.dungeon_runs SET status = 'completed', ended_at = now()
 WHERE id = 'd7000000-0000-4000-8000-0000000000d9'::uuid;
SET LOCAL ROLE authenticated;

-- =========================================================
-- 2. R-16 — ⭐ LA CLÉ NE SORT QU'APRÈS SOUMISSION.
-- =========================================================
SET LOCAL request.jwt.claims = '{"sub":"d7000000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$ SELECT public.get_tutor_question_context('d7000000-0000-4000-8000-0000000000a1'::uuid) $$,
  'NOT_ATTEMPTED',
  NULL,
  'R-16 ⭐ : un élève qui n''a pas répondu n''obtient NI la clé NI l''explication canonique'
);

SET LOCAL request.jwt.claims = '{"sub":"d7000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.get_tutor_question_context('d7000000-0000-4000-8000-0000000000a1'::uuid))->>'correct_option',
  'a',
  'R-16 : après soumission, la clé est rendue — c''est ce qui rend R-2 légitime'
);

SELECT is(
  (public.get_tutor_question_context('d7000000-0000-4000-8000-0000000000a1'::uuid))->>'selected_choice',
  'b',
  'le contexte porte le choix RÉEL de l''élève, pas une hypothèse'
);

SELECT is(
  (public.get_tutor_question_context('d7000000-0000-4000-8000-0000000000a1'::uuid))->>'misconception',
  'tt.frac.add-denominators',
  'le tag vient de question_attempts (é04 A1.2a), jamais de distractor_tags'
);

SELECT is(
  (public.get_tutor_question_context('d7000000-0000-4000-8000-0000000000a1'::uuid))->>'lang',
  'ar',
  'R-3 : la langue est celle de la MATIÈRE, pas celle de l''interface'
);

SELECT is(
  (public.get_tutor_question_context('d7000000-0000-4000-8000-0000000000a1'::uuid))->>'age_band',
  '12-14',
  'R-14 : la bande d''âge est DÉRIVÉE du rang de la classe, jamais collectée'
);

-- La map complète des tags de distracteurs ne doit jamais transiter : elle
-- désignerait la bonne réponse par élimination (stop-point D-A1.2-2).
SELECT ok(
  NOT ((public.get_tutor_question_context('d7000000-0000-4000-8000-0000000000a1'::uuid)) ? 'distractor_tags'),
  'la map distractor_tags n''entre jamais dans le contexte — elle donnerait la clé par élimination'
);

-- =========================================================
-- 3. R-7 — l'escalier de reformulation.
-- =========================================================
SELECT is(
  (public.open_tutor_thread('d7000000-0000-4000-8000-0000000000a1'::uuid, 'ar', '12-14'))->>'variant_served',
  '0',
  'R-7 : un fil neuf n''a servi aucun registre'
);

SELECT set_config('test.tt_thread',
  (public.open_tutor_thread('d7000000-0000-4000-8000-0000000000a1'::uuid, 'ar', '12-14'))->>'thread_id',
  true);

SELECT is(
  (SELECT count(*)::int FROM public.tutor_threads
    WHERE user_id = 'd7000000-0000-4000-8000-000000000001'::uuid AND status = 'active'),
  1,
  'rouvrir le panneau retrouve le fil actif, il n''en crée pas un second'
);

SELECT is(
  (public.append_tutor_message(current_setting('test.tt_thread')::uuid,
                               'tutor', 'explain', 'texte', 0, 0, true))->>'variant_served',
  '1',
  'R-7 : servir une explication consomme un registre'
);

SELECT is(
  (public.append_tutor_message(current_setting('test.tt_thread')::uuid,
                               'tutor', 'explain', 'texte', 0, 0, false))->>'variant_served',
  '1',
  'R-7 ⭐ : re-servir sans « explique autrement » NE consomme PAS de registre — rouvrir l''écran ne brûle pas l''escalier'
);

-- =========================================================
-- 4. R-15.2 — la frontière du cache mutualisé.
-- =========================================================
SET LOCAL ROLE postgres;
-- Une explication PRIVÉE, produite par un modèle hors liste curée, appartenant
-- à l'élève 2 (qui n'a rien à voir avec l'élève 1).
SELECT public.store_tutor_explanation(
  'd7000000-0000-4000-8000-0000000000a1'::uuid, 'tt.frac.add-denominators',
  'ar', '12-14', 'concret', 'explication privée', 'modele-inconnu-3b', false,
  'd7000000-0000-4000-8000-000000000002'::uuid);
SET LOCAL ROLE authenticated;

SELECT ok(
  public.find_tutor_explanation('d7000000-0000-4000-8000-0000000000a1'::uuid,
    'tt.frac.add-denominators', 'ar', '12-14', 'concret') IS NULL,
  'R-15.2 ⭐ : une explication PRIVÉE ne fuit pas chez le voisin — le pot commun exige un modèle curé'
);

SET LOCAL ROLE postgres;
SELECT public.store_tutor_explanation(
  'd7000000-0000-4000-8000-0000000000a1'::uuid, 'tt.frac.add-denominators',
  'ar', '12-14', 'concret', 'explication partagée', 'claude-sonnet-5', true,
  'd7000000-0000-4000-8000-000000000002'::uuid);
SET LOCAL ROLE authenticated;

SELECT is(
  (public.find_tutor_explanation('d7000000-0000-4000-8000-0000000000a1'::uuid,
    'tt.frac.add-denominators', 'ar', '12-14', 'concret'))->>'body',
  'explication partagée',
  'R-15.2 : une explication du pot commun est resservie — et l''élève ne paie rien pour elle'
);

-- =========================================================
-- 5. Les droits.
-- =========================================================
SELECT ok(
  NOT has_function_privilege('anon', 'public.get_tutor_question_context(uuid)', 'EXECUTE'),
  'anon ne peut pas demander un contexte de question : il n''a jamais soumis quoi que ce soit'
);

SELECT ok(
  NOT has_function_privilege('authenticated',
    'public.store_tutor_explanation(uuid,text,text,text,text,text,text,boolean,uuid)', 'EXECUTE'),
  'R-15.2 : un client ne peut pas ÉCRIRE dans le cache — il déclarerait son modèle « curé »'
);

SELECT * FROM finish();
ROLLBACK;
