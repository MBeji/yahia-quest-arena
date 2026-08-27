-- =========================================================
-- R-1 (é11) — la porte du tuteur ne compte que les épreuves VIVANTES.
-- ---------------------------------------------------------
-- Ce fichier tient les deux moitiés d'un même invariant, et il faut les deux :
--
--   * une épreuve réellement en cours FERME le tuteur (l'anti-triche de R-1,
--     déjà couverte par `66_tutor_explain` — elle est reprise ici parce qu'une
--     borne temporelle qui s'ouvrirait trop tôt la casserait en silence) ;
--   * une épreuve ABANDONNÉE ne le ferme plus (le défaut du 2026-08-27).
--
-- Aucune des trois lignes d'épreuve ne se referme d'elle-même : `dungeon_runs`
-- reste 'active' à vie sur un onglet fermé, `exercise_sessions.completed_at`
-- n'est posé qu'à la soumission, et `duels.status` attend le balayage pg_cron.
-- La garde lisait l'EXISTENCE de ces lignes ; elle lit désormais leur activité.
--
-- ⚠️ Les assertions ⭐ sont celles du défaut vécu : sur l'écran de correction
-- d'une quête, « Demander au Prof » répondait « Pas pendant un donjon ! » pour
-- un donjon quitté des jours plus tôt. La garde du donjon étant GLOBALE, elle
-- éteignait du même coup l'explication, le chat, la boucle de compréhension et
-- « Entraîne-moi là-dessus » — un mode IA « non fonctionnel » qui n'était qu'une
-- porte fermée à l'étape 1.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(12);

-- ---------------------------------------------------------
-- Décor : un chapitre, DEUX exercices (pour la portée chapitre), une question
-- chacun, un élève qui a répondu aux deux — donc `NOT_ATTEMPTED` ne masque
-- jamais ce qu'on mesure ici.
-- ---------------------------------------------------------
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('lt-theme', 'LT Theme', 'Brain', 'subject-math', true);

INSERT INTO public.grades (id, theme_id, slug, name_fr, cycle, display_order)
VALUES ('e8000000-0000-4000-8000-0000000000f1'::uuid, 'lt-theme', 'lt-9', 'LT 9ème', 'college', 9);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id, content_language)
VALUES ('lt-subj', 'LT Maths', 'Esprit', 'subject-math', 'Brain', 'lt-theme',
        'e8000000-0000-4000-8000-0000000000f1'::uuid, 'fr');

INSERT INTO public.chapters (id, subject_id, title, summary, lesson_content)
VALUES ('e8000000-0000-4000-8000-0000000000c1'::uuid, 'lt-subj', 'LT Divisibilité',
        'Résumé LT', '## Critères' || E'\n' || 'Par 12 : par 3 ET par 4.');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, mode, source)
VALUES
  ('e8000000-0000-4000-8000-0000000000e1'::uuid,
   'e8000000-0000-4000-8000-0000000000c1'::uuid, 'lt-subj', 'LT Ex 1', 1, 'practice', 'admin'),
  ('e8000000-0000-4000-8000-0000000000e2'::uuid,
   'e8000000-0000-4000-8000-0000000000c1'::uuid, 'lt-subj', 'LT Ex 2', 1, 'practice', 'admin');

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order)
VALUES
  ('e8000000-0000-4000-8000-0000000000a1'::uuid, 'e8000000-0000-4000-8000-0000000000e1'::uuid,
   'LT question 1', '[{"id":"a","text":"oui"},{"id":"b","text":"non"}]'::jsonb,
   'a', 'Explication 1.', 1),
  ('e8000000-0000-4000-8000-0000000000a2'::uuid, 'e8000000-0000-4000-8000-0000000000e2'::uuid,
   'LT question 2', '[{"id":"a","text":"oui"},{"id":"b","text":"non"}]'::jsonb,
   'b', 'Explication 2.', 1);

INSERT INTO auth.users (id, email)
VALUES ('e8000000-0000-4000-8000-000000000001', 'lt-eleve@test.local');

INSERT INTO public.question_attempts
  (user_id, question_id, chapter_id, session_id, choice, is_correct, source)
VALUES
  ('e8000000-0000-4000-8000-000000000001'::uuid, 'e8000000-0000-4000-8000-0000000000a1'::uuid,
   'e8000000-0000-4000-8000-0000000000c1'::uuid, 'e8000000-0000-4000-8000-0000000000b0'::uuid,
   'b', false, 'exercise'),
  ('e8000000-0000-4000-8000-000000000001'::uuid, 'e8000000-0000-4000-8000-0000000000a2'::uuid,
   'e8000000-0000-4000-8000-0000000000c1'::uuid, 'e8000000-0000-4000-8000-0000000000b0'::uuid,
   'a', false, 'exercise');

INSERT INTO public.parcours (id, name_fr, kind, theme_id, icon, color)
VALUES ('lt-parcours', 'LT Parcours', 'libre', 'lt-theme', 'Swords', 'subject-math');

SET LOCAL request.jwt.claims = '{"sub":"e8000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.can_use_tutor('question', 'e8000000-0000-4000-8000-0000000000a1'::uuid))->>'reason',
  'OK',
  'point de départ : sans épreuve en cours, la porte est ouverte'
);

-- =========================================================
-- 1. LE DONJON — la garde globale, celle du défaut signalé.
-- =========================================================
SET LOCAL ROLE postgres;
INSERT INTO public.dungeon_runs (id, user_id, current_floor, status, started_at)
VALUES ('e8000000-0000-4000-8000-0000000000d1'::uuid,
        'e8000000-0000-4000-8000-000000000001'::uuid, 1, 'active', now());
SET LOCAL ROLE authenticated;

SELECT is(
  (public.can_use_tutor('question', 'e8000000-0000-4000-8000-0000000000a1'::uuid))->>'reason',
  'ACTIVE_DUNGEON',
  'R-1 : un donjon qui vient de démarrer ferme le tuteur PARTOUT — l''anti-triche est intacte'
);

-- Le même donjon, jamais refermé, laissé en plan il y a deux heures. C'est
-- l'état RÉEL de toute course quittée : rien ne repasse jamais dessus.
SET LOCAL ROLE postgres;
UPDATE public.dungeon_runs SET started_at = now() - INTERVAL '2 hours'
 WHERE id = 'e8000000-0000-4000-8000-0000000000d1'::uuid;
SET LOCAL ROLE authenticated;

SELECT is(
  (public.can_use_tutor('question', 'e8000000-0000-4000-8000-0000000000a1'::uuid))->>'reason',
  'OK',
  '⭐ un donjon ABANDONNÉ (aucune activité depuis 2 h) n''éteint plus le Prof — le défaut du 2026-08-27'
);

-- Une réponse récente sur cette même course : l'élève l'a REPRISE, la porte doit
-- se refermer. C'est ce qui interdit de « libérer » le tuteur en laissant
-- simplement le donjon ouvert dans un autre onglet.
SET LOCAL ROLE postgres;
INSERT INTO public.dungeon_run_questions (run_id, question_id, assigned_floor, answered_at, selected_choice, is_correct)
VALUES ('e8000000-0000-4000-8000-0000000000d1'::uuid,
        'e8000000-0000-4000-8000-0000000000a1'::uuid, 1, now(), 'a', true);
SET LOCAL ROLE authenticated;

SELECT is(
  (public.can_use_tutor('question', 'e8000000-0000-4000-8000-0000000000a1'::uuid))->>'reason',
  'ACTIVE_DUNGEON',
  'R-1 : une réponse récente REPREND la course — la porte se referme, on ne triche pas en laissant un onglet ouvert'
);

SET LOCAL ROLE postgres;
UPDATE public.dungeon_run_questions SET answered_at = now() - INTERVAL '90 minutes'
 WHERE run_id = 'e8000000-0000-4000-8000-0000000000d1'::uuid;
SET LOCAL ROLE authenticated;

SELECT is(
  (public.can_use_tutor('question', 'e8000000-0000-4000-8000-0000000000a1'::uuid))->>'reason',
  'OK',
  '⭐ une course dont la DERNIÈRE réponse date d''une heure et demie est abandonnée, pas en cours'
);

SET LOCAL ROLE postgres;
DELETE FROM public.dungeon_runs WHERE id = 'e8000000-0000-4000-8000-0000000000d1'::uuid;
SET LOCAL ROLE authenticated;

-- =========================================================
-- 2. LE DUEL — son échéance fait autorité, pas le passage du cron.
-- =========================================================
SET LOCAL ROLE postgres;
INSERT INTO public.duels (id, parcours_id, question_ids, status, expires_at)
VALUES ('e8000000-0000-4000-8000-0000000000d2'::uuid, 'lt-parcours',
        ARRAY['e8000000-0000-4000-8000-0000000000a1'::uuid], 'active', now() + INTERVAL '10 minutes');
INSERT INTO public.duel_participants (duel_id, user_id)
VALUES ('e8000000-0000-4000-8000-0000000000d2'::uuid, 'e8000000-0000-4000-8000-000000000001'::uuid);
SET LOCAL ROLE authenticated;

SELECT is(
  (public.can_use_tutor('question', 'e8000000-0000-4000-8000-0000000000a1'::uuid))->>'reason',
  'ACTIVE_DUEL',
  'R-1 : un duel encore ouvert ferme le tuteur — l''anti-triche est intacte'
);

SET LOCAL ROLE postgres;
UPDATE public.duels SET expires_at = now() - INTERVAL '1 minute'
 WHERE id = 'e8000000-0000-4000-8000-0000000000d2'::uuid;
SET LOCAL ROLE authenticated;

SELECT is(
  (public.can_use_tutor('question', 'e8000000-0000-4000-8000-0000000000a1'::uuid))->>'reason',
  'OK',
  '⭐ un duel dont l''échéance est passée n''attend pas `expire_duels` pour cesser de bloquer'
);

SET LOCAL ROLE postgres;
DELETE FROM public.duels WHERE id = 'e8000000-0000-4000-8000-0000000000d2'::uuid;
SET LOCAL ROLE authenticated;

-- =========================================================
-- 3. LA SÉANCE D'EXERCICE — la dernière de l'exercice, et elle seule.
-- =========================================================
SET LOCAL ROLE postgres;
INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('e8000000-0000-4000-8000-00000000005a'::uuid,
        'e8000000-0000-4000-8000-000000000001'::uuid,
        'e8000000-0000-4000-8000-0000000000e1'::uuid, now() - INTERVAL '2 minutes');
SET LOCAL ROLE authenticated;

SELECT is(
  (public.can_use_tutor('question', 'e8000000-0000-4000-8000-0000000000a1'::uuid))->>'reason',
  'ACTIVE_SESSION',
  'R-1 : une séance en cours sur l''exercice ferme le tuteur — l''élève peut encore changer sa réponse'
);

-- Le geste le plus banal du produit : on quitte un exercice, on le relance, on
-- le termine. La séance abandonnée reste ouverte à vie ; c'est la séance
-- SUIVANTE qui dit où en est l'élève.
SET LOCAL ROLE postgres;
INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at, completed_at)
VALUES ('e8000000-0000-4000-8000-00000000005b'::uuid,
        'e8000000-0000-4000-8000-000000000001'::uuid,
        'e8000000-0000-4000-8000-0000000000e1'::uuid, now() - INTERVAL '1 minute', now());
SET LOCAL ROLE authenticated;

SELECT is(
  (public.can_use_tutor('question', 'e8000000-0000-4000-8000-0000000000a1'::uuid))->>'reason',
  'OK',
  '⭐ une séance abandonnée puis RELANCÉE et terminée n''éteint plus le Prof sur l''écran de correction'
);

SET LOCAL ROLE postgres;
DELETE FROM public.exercise_sessions WHERE id = 'e8000000-0000-4000-8000-00000000005b'::uuid;
UPDATE public.exercise_sessions SET started_at = now() - INTERVAL '5 hours'
 WHERE id = 'e8000000-0000-4000-8000-00000000005a'::uuid;
SET LOCAL ROLE authenticated;

SELECT is(
  (public.can_use_tutor('question', 'e8000000-0000-4000-8000-0000000000a1'::uuid))->>'reason',
  'OK',
  '⭐ une séance ouverte depuis cinq heures n''est plus jouée — la borne est le plafond, pas l''oubli'
);

-- =========================================================
-- 4. LA PORTÉE CHAPITRE (le chat) suit exactement la même règle.
-- =========================================================
SET LOCAL ROLE postgres;
UPDATE public.exercise_sessions SET started_at = now() - INTERVAL '2 minutes'
 WHERE id = 'e8000000-0000-4000-8000-00000000005a'::uuid;
SET LOCAL ROLE authenticated;

SELECT is(
  (public.can_use_tutor('chapter', NULL, 'e8000000-0000-4000-8000-0000000000c1'::uuid))->>'reason',
  'ACTIVE_SESSION',
  'R-1 : le chat de chapitre se ferme aussi pendant une séance en cours sur un exercice du chapitre'
);

SET LOCAL ROLE postgres;
INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at, completed_at)
VALUES ('e8000000-0000-4000-8000-00000000005c'::uuid,
        'e8000000-0000-4000-8000-000000000001'::uuid,
        'e8000000-0000-4000-8000-0000000000e1'::uuid, now() - INTERVAL '1 minute', now());
SET LOCAL ROLE authenticated;

SELECT is(
  (public.can_use_tutor('chapter', NULL, 'e8000000-0000-4000-8000-0000000000c1'::uuid))->>'reason',
  'OK',
  '⭐ portée chapitre : une séance abandonnée puis relancée et terminée rouvre le chat'
);

SELECT * FROM finish();
ROLLBACK;
