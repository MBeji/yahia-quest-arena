-- =========================================================
-- `attempts.session_id` — le contrat de la colonne, puis celui de l'écrivain.
--
-- La tentative doit retenir la session qui l'a produite, pour que le détail
-- question par question (`question_attempts`, indexé par session) se relie à elle
-- par une CLÉ et non par proximité temporelle.
--   1. le contrat de schéma de la colonne (20260816170000) ;
--   2. le comportement de `submit_exercise_attempt`, qui la renseigne
--      (20260816190000), et le cas des deux onglets qui a motivé tout ceci.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(13);

-- =========================================================
-- 1. La colonne.
-- =========================================================
SELECT has_column('public', 'attempts', 'session_id',
  'attempts porte une colonne session_id');

SELECT col_type_is('public', 'attempts', 'session_id', 'uuid',
  'attempts.session_id est un uuid');

-- Nullable par construction : les lignes antérieures à la colonne, et celles que
-- le backfill ne saura pas trancher, restent sans session.
SELECT col_is_null('public', 'attempts', 'session_id',
  'attempts.session_id est nullable — une tentative sans session reste une tentative');

SELECT is(
  (SELECT c.confrelid::regclass::text
     FROM pg_constraint c
     JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = c.conkey[1]
    WHERE c.conrelid = 'public.attempts'::regclass
      AND c.contype = 'f'
      AND a.attname = 'session_id'),
  'exercise_sessions',
  'attempts.session_id référence exercise_sessions'
);

-- L'action de suppression est le cœur du choix : une session est de
-- l'échafaudage, la tentative est le fait pédagogique. CASCADE effacerait le
-- score, l'XP et l'historique lu par le parent.
SELECT is(
  (SELECT c.confdeltype
     FROM pg_constraint c
     JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = c.conkey[1]
    WHERE c.conrelid = 'public.attempts'::regclass
      AND c.contype = 'f'
      AND a.attname = 'session_id'),
  'n'::"char",
  'supprimer une session met la référence à NULL, elle n''efface pas la tentative'
);

SELECT has_index('public', 'attempts', 'idx_attempts_session',
  'un index sert la clé étrangère (sans lui, chaque suppression de session balaye attempts)');

SELECT ok(
  has_column_privilege('authenticated', 'public.attempts', 'session_id', 'SELECT'),
  'la colonne hérite du GRANT SELECT de table : aucun grant nouveau à poser'
);

-- =========================================================
-- 2. L'écrivain — `submit_exercise_attempt` pose la session sur la tentative,
--    et deux onglets ne se mélangent plus.
--
-- Le cas des deux onglets est CELUI qui a motivé la colonne, et ce fichier le
-- démontre : dans une même transaction, `attempts.completed_at` (posé par le
-- défaut `now()`, horodatage de DÉBUT de transaction) est rigoureusement
-- identique pour les deux tentatives. La résolution par proximité temporelle
-- rend donc la MÊME session pour les deux — elle ne peut pas les distinguer.
-- La clé, si.
-- =========================================================
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('sessid-subj', 'Session Id Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('7e575001-0000-0000-0000-000000000001', 'sessid-subj', 'Session Id Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward, reward_coins, mode)
VALUES ('7e575002-0000-0000-0000-000000000001',
        '7e575001-0000-0000-0000-000000000001', 'sessid-subj',
        'Session Id Exercise', 90, 9, 'practice');

-- 3 QCM, bonne réponse 'a'.
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
SELECT
  ('7e575003-0000-0000-0000-00000000000' || g)::uuid,
  '7e575002-0000-0000-0000-000000000001',
  'Q' || g,
  '[{"id":"a","text":"right"},{"id":"b","text":"wrong"}]'::jsonb,
  'a',
  g
FROM generate_series(1, 3) AS g;

INSERT INTO auth.users (id, email)
VALUES ('7e575aaa-0000-0000-0000-000000000001', 'sessid@test.local');

-- Deux onglets ouverts sur le même exercice : deux sessions vivantes à la fois.
-- 3 questions × 4 s = 12 s de garde anti-précipitation ; 120 s la passent.
INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES
  ('7e575bbb-0000-0000-0000-000000000001',
   '7e575aaa-0000-0000-0000-000000000001',
   '7e575002-0000-0000-0000-000000000001',
   clock_timestamp() - INTERVAL '120 seconds'),
  ('7e575bbb-0000-0000-0000-000000000002',
   '7e575aaa-0000-0000-0000-000000000001',
   '7e575002-0000-0000-0000-000000000001',
   clock_timestamp() - INTERVAL '110 seconds');

SET LOCAL "request.jwt.claims" = '{"sub":"7e575aaa-0000-0000-0000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- Onglet 1 : tout juste (100 %).
SELECT lives_ok($$
  SELECT public.submit_exercise_attempt(
    '7e575bbb-0000-0000-0000-000000000001',
    '7e575002-0000-0000-0000-000000000001',
    '[{"questionId":"7e575003-0000-0000-0000-000000000001","choice":"a"},
      {"questionId":"7e575003-0000-0000-0000-000000000002","choice":"a"},
      {"questionId":"7e575003-0000-0000-0000-000000000003","choice":"a"}]'::jsonb
  )
$$, 'onglet 1 : la soumission passe');

-- Onglet 2 : une seule bonne réponse (33 %), ce qui rend les deux tentatives
-- distinguables par leur score — elles ne le sont ni par l'heure, ni par
-- l'exercice, ni par l'élève.
SELECT lives_ok($$
  SELECT public.submit_exercise_attempt(
    '7e575bbb-0000-0000-0000-000000000002',
    '7e575002-0000-0000-0000-000000000001',
    '[{"questionId":"7e575003-0000-0000-0000-000000000001","choice":"a"},
      {"questionId":"7e575003-0000-0000-0000-000000000002","choice":"b"},
      {"questionId":"7e575003-0000-0000-0000-000000000003","choice":"b"}]'::jsonb
  )
$$, 'onglet 2 : la soumission passe aussi (une session terminée n''en bloque pas une autre)');

-- Relectures faites hors rôle applicatif, comme le reste de la suite : on vérifie
-- ce qui a été ÉCRIT, sans que RLS ne s'interpose sur la lecture.
RESET ROLE;

SELECT is(
  (SELECT session_id FROM public.attempts
    WHERE user_id = '7e575aaa-0000-0000-0000-000000000001'
      AND score_pct = 100),
  '7e575bbb-0000-0000-0000-000000000001'::uuid,
  'la tentative de l''onglet 1 porte la session de l''onglet 1'
);

SELECT is(
  (SELECT session_id FROM public.attempts
    WHERE user_id = '7e575aaa-0000-0000-0000-000000000001'
      AND score_pct < 100),
  '7e575bbb-0000-0000-0000-000000000002'::uuid,
  'la tentative de l''onglet 2 porte la session de l''onglet 2'
);

-- Le détail question par question se relit maintenant PAR LA CLÉ : les réponses
-- attachées à la tentative de l'onglet 2 sont bien les siennes (1 juste sur 3),
-- pas celles de l'onglet 1.
SELECT is(
  (SELECT count(*) FILTER (WHERE qa.is_correct)
     FROM public.attempts a
     JOIN public.question_attempts qa ON qa.session_id = a.session_id
    WHERE a.user_id = '7e575aaa-0000-0000-0000-000000000001'
      AND a.score_pct < 100),
  1::bigint,
  'les réponses relues par la clé sont celles de LA tentative (1 juste sur 3)'
);

-- Et la démonstration par l'absurde : l'ancienne résolution, appliquée aux mêmes
-- lignes, donne la même session aux deux tentatives. `attempts.completed_at`
-- vaut `now()` — l'horodatage de début de transaction — donc il est identique
-- pour les deux, et « la session terminée la plus proche » ne discrimine plus
-- rien. C'est exactement le détail de réponses qu'un parent voyait attribué au
-- mauvais onglet.
SELECT is(
  (SELECT count(DISTINCT proche.id)
     FROM public.attempts a
     CROSS JOIN LATERAL (
       SELECT s.id
         FROM public.exercise_sessions s
        WHERE s.user_id = a.user_id
          AND s.exercise_id = a.exercise_id
          AND s.completed_at IS NOT NULL
        -- `s.id` départage : sans lui, deux sessions closes à la même microseconde
        -- rendraient l'assertion non déterministe. La règle reproduite reste celle
        -- du lecteur, le départage ne fait que la rendre observable.
        ORDER BY ABS(EXTRACT(EPOCH FROM (s.completed_at - a.completed_at))), s.id
        LIMIT 1
     ) AS proche
    WHERE a.user_id = '7e575aaa-0000-0000-0000-000000000001'),
  1::bigint,
  'la proximité temporelle rendait UNE seule session pour les DEUX tentatives — c''est le défaut que la colonne supprime'
);

SELECT * FROM finish();
ROLLBACK;
