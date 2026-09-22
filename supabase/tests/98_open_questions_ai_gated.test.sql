-- =========================================================
-- Étude 33 — LES QUESTIONS OUVERTES SONT GATÉES SUR LE MODE IA, et leur refus
-- peut être renversé par un juge.
-- ---------------------------------------------------------
-- Arbitrage du propriétaire (2026-09-13) : « les exercices ouverts ne doivent
-- être proposés que si l'utilisateur a le mode IA activé, et la réponse est
-- vérifiée via IA ».
--
-- CE QUE CE FICHIER EXISTE POUR ATTRAPER, et que le TypeScript ne peut pas
-- ---------------------------------------------------------
-- La faute de ce lot n'est pas « la question s'affiche ». C'est la MOITIÉ
-- MANQUANTE : une `short_answer` retirée de l'écran mais laissée dans le
-- dénominateur du score. `submit_exercise_attempt` compte
-- `FROM questions WHERE exercise_id = …` — une question jamais servie y reste,
-- sans réponse, donc fausse. Une mission de 3 questions se jouerait sur 2 et se
-- noterait sur 3, et AUCUN test de composant ne le verrait.
--
-- §3 est donc le cœur du fichier : à décor identique, la même soumission vaut
-- 2/2 porte fermée et 3/3 porte ouverte. §4 prouve le filet, §5 son mur.
--
-- Décor : une matière, un chapitre, une mission ⭐ à 3 questions dont UNE
-- ouverte ; un porteur de clé et son élève lié ; un élève TÉMOIN sans mode IA.
-- Le témoin n'est pas décoratif — une porte écrite trop large rendrait vertes
-- les assertions de l'élève gaté sans lui.
--
-- Espace de noms des fixtures : préfixe `0a…`, inutilisé ailleurs.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(29);

-- ---------------------------------------------------------
-- Fixtures.
-- ---------------------------------------------------------
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id, content_language)
VALUES ('oaq-subj', 'Open Answer Subject', 'Esprit', 'subject-math', 'Brain', 'ecole-tn',
        (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '9eme-base'), 'fr');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('0a100000-0000-4000-8000-000000000001', 'oaq-subj', 'Open Answer Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward, difficulty, mode, source)
VALUES ('0a200000-0000-4000-8000-000000000001', '0a100000-0000-4000-8000-000000000001', 'oaq-subj',
        'OA mission', 50, 1, 'practice', 'admin');

-- Deux QCM ordinaires + UNE question ouverte. La clé canonique est
-- « l'hypoténuse » ; « le côté le plus long » est déclarée FAUSSE par l'auteur
-- (`mistakes`) — c'est elle qui servira de mur en §5.
INSERT INTO public.questions
  (id, exercise_id, prompt, options, correct_option, display_order, question_type, answer_key)
VALUES
  ('0a300000-0000-4000-8000-000000000001', '0a200000-0000-4000-8000-000000000001',
   'Capitale de la France ?',
   '[{"id":"a","text":"Paris"},{"id":"b","text":"Berlin"},{"id":"c","text":"Rome"}]'::jsonb,
   'a', 1, 'mcq', NULL),
  ('0a300000-0000-4000-8000-000000000002', '0a200000-0000-4000-8000-000000000001',
   'Capitale de l Italie ?',
   '[{"id":"a","text":"Rome"},{"id":"b","text":"Madrid"},{"id":"c","text":"Lisbonne"}]'::jsonb,
   'a', 2, 'mcq', NULL),
  ('0a300000-0000-4000-8000-000000000003', '0a200000-0000-4000-8000-000000000001',
   'Comment appelle-t-on le côté opposé à l angle droit ?',
   '[]'::jsonb, NULL, 3, 'short_answer',
   '{"text":"hypotenuse","mistakes":[{"text":"le cote le plus long","tag":"confusion-plus-long"}]}'::jsonb);

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at,
                        raw_user_meta_data, created_at, updated_at, aud, role, instance_id)
VALUES
  ('0a400000-0000-4000-8000-000000000001', 'oaq-parent@test.local', 'x', now(),
   '{"display_name":"OAQ Parent"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'),
  ('0a400000-0000-4000-8000-000000000002', 'oaq-child@test.local', 'x', now(),
   '{"display_name":"OAQ Eleve"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'),
  ('0a400000-0000-4000-8000-000000000003', 'oaq-witness@test.local', 'x', now(),
   '{"display_name":"OAQ Temoin"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.parent_student_links (parent_user_id, student_user_id, is_active)
VALUES ('0a400000-0000-4000-8000-000000000001', '0a400000-0000-4000-8000-000000000002', true)
ON CONFLICT (parent_user_id, student_user_id) DO UPDATE SET is_active = true;

SELECT public.set_ai_credential(
  '0a400000-0000-4000-8000-000000000001'::uuid, 'anthropic', NULL,
  'm-fast', 'm-rich', '\x00112233445566778899aabbccddeeff'::bytea, 1::smallint,
  'fp-oaq', 'zzzz', 2, 20, '2026-08-22');

-- ---------------------------------------------------------
-- 1. LE DÉFAUT EST FERMÉ — une clé enregistrée n'ouvre rien (é29 R-3).
-- ---------------------------------------------------------
SELECT is(
  public.can_play_open_questions('0a400000-0000-4000-8000-000000000002'::uuid),
  false,
  'défaut : sans activation, les questions ouvertes ne sont pas servies'
);

SELECT is(
  public.can_play_open_questions(NULL::uuid),
  false,
  'anonyme : aucun mode IA possible, donc aucune question ouverte (catalogue public)'
);

SELECT is(
  public.can_play_open_questions('0a400000-0000-4000-8000-000000000003'::uuid),
  false,
  'témoin : un élève sans porteur de clé reste devant la porte'
);

-- ---------------------------------------------------------
-- 2. L'ACTIVATION OUVRE — et seulement celle qui nomme la surface.
-- ---------------------------------------------------------
SET LOCAL request.jwt.claims = '{"sub":"0a400000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT lives_ok(
  $$ SELECT public.set_ai_student_access(
       '0a400000-0000-4000-8000-000000000002'::uuid, true, ARRAY['explain'], 10) $$,
  'le porteur active son élève, mais sur une AUTRE surface'
);
RESET ROLE;

SELECT is(
  public.can_play_open_questions('0a400000-0000-4000-8000-000000000002'::uuid),
  false,
  'activer « explication » n''ouvre PAS les questions ouvertes — la surface est nommée'
);

SET LOCAL request.jwt.claims = '{"sub":"0a400000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT lives_ok(
  $$ SELECT public.set_ai_student_access(
       '0a400000-0000-4000-8000-000000000002'::uuid, true, ARRAY['explain','open_answer'], 10) $$,
  '`open_answer` est ACTIVABLE : elle est dans le vocabulaire que le SQL accepte'
);
RESET ROLE;

SELECT is(
  public.can_play_open_questions('0a400000-0000-4000-8000-000000000002'::uuid),
  true,
  'la surface cochée ouvre la porte'
);

-- Le kill-switch de données passe devant tout (étape 1 de `resolve_ai_access`).
UPDATE public.ai_admin_state SET ai_enabled = false WHERE id;
SELECT is(
  public.can_play_open_questions('0a400000-0000-4000-8000-000000000002'::uuid),
  false,
  'kill-switch données baissé : la porte se referme, activation ou non'
);
UPDATE public.ai_admin_state SET ai_enabled = true WHERE id;

-- ⚠️ L'ÉNERGIE NE FERME PAS LA PORTE. Sinon des questions DISPARAÎTRAIENT au
-- milieu d'une après-midi de révisions, et la même mission se noterait
-- différemment selon l'heure. Sans énergie l'arbitrage ne part pas ; le verdict
-- déterministe tranche seul, et c'est tout.
INSERT INTO public.ai_energy_ledger (student_user_id, day, spent, bonus)
VALUES ('0a400000-0000-4000-8000-000000000002', CURRENT_DATE, 99, 0)
ON CONFLICT (student_user_id, day) DO UPDATE SET spent = 99, bonus = 0;

SELECT is(
  (SELECT reason FROM public.resolve_ai_access(
     '0a400000-0000-4000-8000-000000000002'::uuid, 'open_answer')),
  'AI_ENERGY_SPENT',
  'décor : l''énergie du jour est bien épuisée'
);
SELECT is(
  public.can_play_open_questions('0a400000-0000-4000-8000-000000000002'::uuid),
  true,
  'énergie épuisée : la porte RESTE ouverte — le mode est allumé, c''est le quota du jour qui est fini'
);
DELETE FROM public.ai_energy_ledger WHERE student_user_id = '0a400000-0000-4000-8000-000000000002';

-- ---------------------------------------------------------
-- 3. LE DÉNOMINATEUR — la moitié qu'on oublie, et qui fait perdre des points.
-- ---------------------------------------------------------
SELECT is(
  public.is_question_in_play(
    (SELECT q FROM public.questions q WHERE q.id = '0a300000-0000-4000-8000-000000000001'), false),
  true,
  'un QCM est en jeu quelle que soit la porte'
);
SELECT is(
  public.is_question_in_play(
    (SELECT q FROM public.questions q WHERE q.id = '0a300000-0000-4000-8000-000000000003'), false),
  false,
  'porte fermée : la question ouverte n''est PAS en jeu'
);
SELECT is(
  public.is_question_in_play(
    (SELECT q FROM public.questions q WHERE q.id = '0a300000-0000-4000-8000-000000000003'), true),
  true,
  'porte ouverte : elle rentre en jeu'
);

-- LE TÉMOIN joue la mission sans mode IA : deux bonnes réponses, et il ne doit
-- pas être noté sur une troisième question qu'il n'a jamais vue.
SET LOCAL request.jwt.claims = '{"sub":"0a400000-0000-4000-8000-000000000003","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT (public.submit_exercise_attempt(
     (SELECT s.session_id FROM public.start_exercise_session('0a200000-0000-4000-8000-000000000001') s),
     '0a200000-0000-4000-8000-000000000001',
     '[{"questionId":"0a300000-0000-4000-8000-000000000001","choice":"a"},
       {"questionId":"0a300000-0000-4000-8000-000000000002","choice":"a"}]'::jsonb
   ) ->> 'total')::int),
  2,
  'PORTE FERMÉE : la mission est notée sur 2, pas sur 3 — la question ouverte sort AUSSI du total'
);

-- L'ÉLÈVE GATÉ joue la même mission : la question ouverte compte, et il la rate
-- (sa saisie n'est ni la canonique ni une variante acceptée).
SET LOCAL request.jwt.claims = '{"sub":"0a400000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT (public.submit_exercise_attempt(
     (SELECT s.session_id FROM public.start_exercise_session('0a200000-0000-4000-8000-000000000001') s),
     '0a200000-0000-4000-8000-000000000001',
     '[{"questionId":"0a300000-0000-4000-8000-000000000001","choice":"a"},
       {"questionId":"0a300000-0000-4000-8000-000000000002","choice":"a"},
       {"questionId":"0a300000-0000-4000-8000-000000000003","choice":"le grand cote"}]'::jsonb
   ) ->> 'total')::int),
  3,
  'PORTE OUVERTE : la même mission est notée sur 3'
);
RESET ROLE;

-- ---------------------------------------------------------
-- 4. LE FILET — l'IA ne peut que RENVERSER un refus.
-- ---------------------------------------------------------
SET LOCAL request.jwt.claims = '{"sub":"0a400000-0000-4000-8000-000000000002","role":"authenticated"}';

-- Le plancher d'abord : la canonique est juste sans qu'aucun verdict n'existe.
SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = '0a300000-0000-4000-8000-000000000003'),
    'Hypoténuse'),
  true,
  'le PLANCHER déterministe est intact : la canonique normalisée reste juste, sans aucun appel'
);

SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = '0a300000-0000-4000-8000-000000000003'),
    'le grand cote'),
  false,
  'sans verdict, une formulation imprévue reste refusée — le comportement d''avant é33'
);

RESET ROLE;
SELECT is(
  public.record_ai_open_answer_verdict(
    '0a400000-0000-4000-8000-000000000002'::uuid,
    '0a300000-0000-4000-8000-000000000003'::uuid,
    'le grand cote', true, 'modele-de-test'),
  true,
  'le juge accepte : le verdict est enregistré tel quel'
);

SET LOCAL request.jwt.claims = '{"sub":"0a400000-0000-4000-8000-000000000002","role":"authenticated"}';
SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = '0a300000-0000-4000-8000-000000000003'),
    'le grand cote'),
  true,
  'LE FILET : le refus est renversé pour CET élève, sur CE texte'
);

-- Le verdict est PERSONNEL : il n'élargit pas l'acceptation pour les autres.
-- C'est ce qui distingue une trace d'arbitrage d'une écriture dans le corpus
-- (é20 R-7 : `accepted_answers` reste un fichier, relu dans un diff).
SET LOCAL request.jwt.claims = '{"sub":"0a400000-0000-4000-8000-000000000003","role":"authenticated"}';
SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = '0a300000-0000-4000-8000-000000000003'),
    'le grand cote'),
  false,
  'le verdict ne fuit pas : un autre élève tapant le même texte reste refusé'
);
RESET ROLE;

SELECT is(
  (SELECT accepted_answers FROM public.questions
    WHERE id = '0a300000-0000-4000-8000-000000000003'),
  '[]'::jsonb,
  'é20 R-7 tient : l''arbitrage n''a RIEN écrit dans le corpus authored'
);

-- ---------------------------------------------------------
-- 5. LE MUR (é20 R-4) — une erreur déclarée reste fausse, quoi qu'en dise le modèle.
-- ---------------------------------------------------------
SELECT is(
  public.record_ai_open_answer_verdict(
    '0a400000-0000-4000-8000-000000000002'::uuid,
    '0a300000-0000-4000-8000-000000000003'::uuid,
    'le côté le plus long', true, 'modele-convaincu'),
  false,
  'R-4 : une acceptation qui égale une ERREUR ATTENDUE est ramenée à un refus, en base'
);

SET LOCAL request.jwt.claims = '{"sub":"0a400000-0000-4000-8000-000000000002","role":"authenticated"}';
SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = '0a300000-0000-4000-8000-000000000003'),
    'le côté le plus long'),
  false,
  'et le scoring le confirme : ce que l''auteur déclare faux ne devient jamais juste'
);
RESET ROLE;

-- ---------------------------------------------------------
-- 5 bis. LE MUR TIENT AUSSI QUAND LE CONTENU BOUGE APRÈS LE VERDICT (#1074).
--
-- §5 prouve le mur au moment de l'arbitrage. Celui-ci prouve l'autre moitié,
-- celle qui manquait : l'auteur corrige sa question APRÈS qu'un verdict a été
-- écrit. « le grand cote » a été accepté en §4, et la ligne est en base.
-- ---------------------------------------------------------
UPDATE public.questions
SET answer_key = jsonb_set(
      answer_key, '{mistakes}',
      (answer_key -> 'mistakes') || '[{"text":"le grand cote","tag":"confusion-plus-long"}]'::jsonb)
WHERE id = '0a300000-0000-4000-8000-000000000003';

-- ⚠️ LE CLAIM, JAMAIS LE RÔLE — et ce n'est pas un détail de style.
-- `questions` n'est PAS lisible en entier par `authenticated` : elle porte une
-- LISTE BLANCHE de six colonnes, parce que `correct_option`, `answer_key`,
-- `accepted_answers` et `distractor_tags` ne doivent jamais sortir. Un
-- `SET LOCAL ROLE authenticated` avant un `SELECT q FROM public.questions q` —
-- la ligne ENTIÈRE — rend donc « permission denied for table questions ». C'est
-- ce qui a fait rougir la suite en CI le 2026-09-22 ; le refus était la bonne
-- réponse. Poser le claim suffit : `auth.uid()` rend l'élève, et c'est tout ce
-- dont R-4 a besoin. Les §4 et §5 font pareil ; ce bloc s'en était écarté, seul.
-- (Et `db:test:local` rend exactement le même refus : un superutilisateur qui
-- fait `SET ROLE` perd ses privilèges. La suite n'avait simplement jamais tourné
-- sur la version fautive — voir `docs/agents/pgtap-en-local.md`.)
SET LOCAL request.jwt.claims = '{"sub":"0a400000-0000-4000-8000-000000000002","role":"authenticated"}';
SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = '0a300000-0000-4000-8000-000000000003'),
    'le grand cote'),
  false,
  'R-4 à la LECTURE : un texte ajouté aux erreurs attendues APRÈS coup redevient faux'
);

-- ET LE GRAND LIVRE N'A PAS ÉTÉ RÉÉCRIT. On le prouve en RETIRANT l'erreur : si
-- la ligne `accepted` avait été effacée ou renversée, l'acceptation ne
-- reviendrait pas. Prouver la même chose en lisant `ai_open_answer_verdicts`
-- directement contredirait le §6, dont tout le propos est que cette table est un
-- ORACLE qui ne se lit pas — une preuve ne doit pas emprunter le chemin qu'on
-- déclare fermé.
UPDATE public.questions
SET answer_key = jsonb_set(
      answer_key, '{mistakes}',
      '[{"text":"le cote le plus long","tag":"confusion-plus-long"}]'::jsonb)
WHERE id = '0a300000-0000-4000-8000-000000000003';

SET LOCAL request.jwt.claims = '{"sub":"0a400000-0000-4000-8000-000000000002","role":"authenticated"}';
SELECT is(
  public.score_answer(
    (SELECT q FROM public.questions q WHERE q.id = '0a300000-0000-4000-8000-000000000003'),
    'le grand cote'),
  true,
  'et la correction agit à la LECTURE SEULEMENT : l''erreur retirée, le verdict écrit revit'
);
RESET ROLE;

-- ---------------------------------------------------------
-- 6. SÉCURITÉ — la table des verdicts est un ORACLE, elle ne se lit pas.
-- ---------------------------------------------------------
SELECT is(
  has_table_privilege('authenticated', 'public.ai_open_answer_verdicts', 'SELECT'),
  false,
  'RISK : `ai_open_answer_verdicts` est illisible par `authenticated` — « tape ceci, c''est accepté »'
);
SELECT is(
  has_function_privilege('authenticated',
    'public.ai_open_answer_candidates(uuid, jsonb)', 'EXECUTE'),
  false,
  'la liste des candidats rend la RÉPONSE ATTENDUE : réservée au service_role'
);
SELECT is(
  has_function_privilege('authenticated',
    'public.record_ai_open_answer_verdict(uuid, uuid, text, boolean, text)', 'EXECUTE'),
  false,
  'nul ne s''auto-déclare arbitré juste : l''écriture est réservée au service_role'
);
SELECT is(
  has_function_privilege('authenticated', 'public.can_play_open_questions(uuid)', 'EXECUTE'),
  true,
  'la PORTE, elle, se lit : l''élève a le droit de savoir si son propre mode est allumé'
);

SELECT * FROM finish();
ROLLBACK;
