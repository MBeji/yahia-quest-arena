-- =========================================================
-- Étude 22, lot 2 (R-19) — la boucle SM-2 se referme.
-- ---------------------------------------------------------
-- `submit_exercise_attempt` insérait trois échéances de révision à l'échec et ne les
-- fermait JAMAIS : l'élève qui refaisait l'exercice avec succès voyait la révision rester
-- « due » indéfiniment (`getSprint2Dashboard` filtre status = 'pending' + échéance passée).
-- Ce fichier prouve la clôture, ses bornes, et la ré-ouverture.
--
--   1. réussite non précipitée → les lignes 'pending' passent à 'completed', horodatées et
--      porteuses du score ;
--   2. réussite PRÉCIPITÉE → aucune clôture (la précipitation ne vaut pas révision faite) ;
--   3. après clôture, un nouvel échec ré-ouvre bien un cycle de trois échéances ;
--   4. non-régression directe : un échec insère toujours ses trois échéances.
--
-- La non-régression du bouclier de re-tentative est couverte par
-- `04_scoring_submit_attempt.test.sql` (CASE 4), qui s'exécute contre cette même RPC —
-- `CREATE OR REPLACE` remplace la définition pour toute la suite.
--
-- Un utilisateur + un exercice distincts par cas, pour qu'aucun `prev_best` ni aucune ligne
-- de planning ne fuite d'une assertion à l'autre. Tout est annulé à la fin.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(8);

-- ---------------------------------------------------------
-- Fixtures : un exercice de 5 questions, bonne réponse 'a' partout.
-- ---------------------------------------------------------
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('sm2-subj', 'SM-2 Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('c1000000-0000-0000-0000-0000000000a1', 'sm2-subj', 'SM-2 Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward, reward_coins, mode)
VALUES ('c2000000-0000-0000-0000-0000000000a1',
        'c1000000-0000-0000-0000-0000000000a1', 'sm2-subj',
        'SM-2 Exercise', 100, 20, 'practice');

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
SELECT
  ('c3000000-0000-0000-0000-00000000000' || g)::uuid,
  'c2000000-0000-0000-0000-0000000000a1',
  'Q' || g,
  '[{"id":"a","text":"right"},{"id":"b","text":"wrong"},{"id":"c","text":"x"},{"id":"d","text":"y"}]'::jsonb,
  'a',
  g
FROM generate_series(1, 5) AS g;

-- =========================================================
-- CASE 1 — échec puis réussite non précipitée → clôture.
-- =========================================================
INSERT INTO auth.users (id, email)
VALUES ('c1111111-1111-1111-1111-1111111111a1', 'sm2-close@test.local');

-- 1a. L'échec ouvre le cycle (5 questions × 4 s = 20 s de garde ; 120 s la dégagent).
INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('c4000000-0000-0000-0000-0000000000a1',
        'c1111111-1111-1111-1111-1111111111a1',
        'c2000000-0000-0000-0000-0000000000a1',
        clock_timestamp() - INTERVAL '120 seconds');

SET LOCAL "request.jwt.claims" = '{"sub":"c1111111-1111-1111-1111-1111111111a1","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT public.submit_exercise_attempt(
  'c4000000-0000-0000-0000-0000000000a1',
  'c2000000-0000-0000-0000-0000000000a1',
  '[{"questionId":"c3000000-0000-0000-0000-000000000001","choice":"b"},
    {"questionId":"c3000000-0000-0000-0000-000000000002","choice":"b"},
    {"questionId":"c3000000-0000-0000-0000-000000000003","choice":"b"},
    {"questionId":"c3000000-0000-0000-0000-000000000004","choice":"b"},
    {"questionId":"c3000000-0000-0000-0000-000000000005","choice":"b"}]'::jsonb
);

SELECT is(
  (SELECT count(*)::int FROM public.spaced_repetition_schedule
     WHERE user_id = 'c1111111-1111-1111-1111-1111111111a1' AND status = 'pending'),
  3,
  'échec : le cycle de trois échéances est ouvert'
);

RESET ROLE;

-- 1b. La réussite (100 %, non précipitée) ferme les trois.
INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('c4000000-0000-0000-0000-0000000000a2',
        'c1111111-1111-1111-1111-1111111111a1',
        'c2000000-0000-0000-0000-0000000000a1',
        clock_timestamp() - INTERVAL '120 seconds');

SET LOCAL "request.jwt.claims" = '{"sub":"c1111111-1111-1111-1111-1111111111a1","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT public.submit_exercise_attempt(
  'c4000000-0000-0000-0000-0000000000a2',
  'c2000000-0000-0000-0000-0000000000a1',
  '[{"questionId":"c3000000-0000-0000-0000-000000000001","choice":"a"},
    {"questionId":"c3000000-0000-0000-0000-000000000002","choice":"a"},
    {"questionId":"c3000000-0000-0000-0000-000000000003","choice":"a"},
    {"questionId":"c3000000-0000-0000-0000-000000000004","choice":"a"},
    {"questionId":"c3000000-0000-0000-0000-000000000005","choice":"a"}]'::jsonb
);

SELECT is(
  (SELECT count(*)::int FROM public.spaced_repetition_schedule
     WHERE user_id = 'c1111111-1111-1111-1111-1111111111a1' AND status = 'pending'),
  0,
  'R-19 : une réussite non précipitée ne laisse plus AUCUNE révision en attente'
);

SELECT is(
  (SELECT count(*)::int FROM public.spaced_repetition_schedule
     WHERE user_id = 'c1111111-1111-1111-1111-1111111111a1'
       AND status = 'completed'
       AND completed_at IS NOT NULL),
  3,
  'R-19 : les trois échéances sont closes ET horodatées'
);

SELECT is(
  (SELECT DISTINCT retry_score_pct FROM public.spaced_repetition_schedule
     WHERE user_id = 'c1111111-1111-1111-1111-1111111111a1' AND status = 'completed'),
  100,
  'R-19 : la clôture porte le score de la reprise'
);

RESET ROLE;

-- =========================================================
-- CASE 2 — une réussite PRÉCIPITÉE ne ferme rien.
-- =========================================================
INSERT INTO auth.users (id, email)
VALUES ('c2222222-2222-2222-2222-2222222222a2', 'sm2-rushed@test.local');

INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('c4000000-0000-0000-0000-0000000000b1',
        'c2222222-2222-2222-2222-2222222222a2',
        'c2000000-0000-0000-0000-0000000000a1',
        clock_timestamp() - INTERVAL '120 seconds');

SET LOCAL "request.jwt.claims" = '{"sub":"c2222222-2222-2222-2222-2222222222a2","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT public.submit_exercise_attempt(
  'c4000000-0000-0000-0000-0000000000b1',
  'c2000000-0000-0000-0000-0000000000a1',
  '[{"questionId":"c3000000-0000-0000-0000-000000000001","choice":"b"},
    {"questionId":"c3000000-0000-0000-0000-000000000002","choice":"b"},
    {"questionId":"c3000000-0000-0000-0000-000000000003","choice":"b"},
    {"questionId":"c3000000-0000-0000-0000-000000000004","choice":"b"},
    {"questionId":"c3000000-0000-0000-0000-000000000005","choice":"b"}]'::jsonb
);

RESET ROLE;

-- Reprise parfaite mais expédiée en 2 s : sous la garde de 20 s.
INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('c4000000-0000-0000-0000-0000000000b2',
        'c2222222-2222-2222-2222-2222222222a2',
        'c2000000-0000-0000-0000-0000000000a1',
        clock_timestamp() - INTERVAL '2 seconds');

SET LOCAL "request.jwt.claims" = '{"sub":"c2222222-2222-2222-2222-2222222222a2","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT public.submit_exercise_attempt(
  'c4000000-0000-0000-0000-0000000000b2',
  'c2000000-0000-0000-0000-0000000000a1',
  '[{"questionId":"c3000000-0000-0000-0000-000000000001","choice":"a"},
    {"questionId":"c3000000-0000-0000-0000-000000000002","choice":"a"},
    {"questionId":"c3000000-0000-0000-0000-000000000003","choice":"a"},
    {"questionId":"c3000000-0000-0000-0000-000000000004","choice":"a"},
    {"questionId":"c3000000-0000-0000-0000-000000000005","choice":"a"}]'::jsonb
);

SELECT is(
  (SELECT count(*)::int FROM public.spaced_repetition_schedule
     WHERE user_id = 'c2222222-2222-2222-2222-2222222222a2' AND status = 'pending'),
  3,
  'R-19 : un 100 % expédié sous la garde anti-précipitation ne ferme AUCUNE révision'
);

RESET ROLE;

-- =========================================================
-- CASE 3 — après clôture, un nouvel échec ré-ouvre un cycle.
-- =========================================================
INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('c4000000-0000-0000-0000-0000000000a3',
        'c1111111-1111-1111-1111-1111111111a1',
        'c2000000-0000-0000-0000-0000000000a1',
        clock_timestamp() - INTERVAL '120 seconds');

SET LOCAL "request.jwt.claims" = '{"sub":"c1111111-1111-1111-1111-1111111111a1","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT public.submit_exercise_attempt(
  'c4000000-0000-0000-0000-0000000000a3',
  'c2000000-0000-0000-0000-0000000000a1',
  '[{"questionId":"c3000000-0000-0000-0000-000000000001","choice":"b"},
    {"questionId":"c3000000-0000-0000-0000-000000000002","choice":"b"},
    {"questionId":"c3000000-0000-0000-0000-000000000003","choice":"b"},
    {"questionId":"c3000000-0000-0000-0000-000000000004","choice":"b"},
    {"questionId":"c3000000-0000-0000-0000-000000000005","choice":"b"}]'::jsonb
);

SELECT is(
  (SELECT count(*)::int FROM public.spaced_repetition_schedule
     WHERE user_id = 'c1111111-1111-1111-1111-1111111111a1' AND status = 'pending'),
  3,
  'un échec ultérieur ré-ouvre un cycle : la garde « aucune ligne pending » ne le bloque plus'
);

SELECT is(
  (SELECT count(*)::int FROM public.spaced_repetition_schedule
     WHERE user_id = 'c1111111-1111-1111-1111-1111111111a1' AND status = 'completed'),
  3,
  'les échéances déjà closes restent closes — la clôture est un fait acquis, pas un état courant'
);

RESET ROLE;

-- =========================================================
-- CASE 4 — non-régression : l'échec insère toujours ses trois échéances.
-- =========================================================
INSERT INTO auth.users (id, email)
VALUES ('c3333333-3333-3333-3333-3333333333a3', 'sm2-insert@test.local');

INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('c4000000-0000-0000-0000-0000000000c1',
        'c3333333-3333-3333-3333-3333333333a3',
        'c2000000-0000-0000-0000-0000000000a1',
        clock_timestamp() - INTERVAL '120 seconds');

SET LOCAL "request.jwt.claims" = '{"sub":"c3333333-3333-3333-3333-3333333333a3","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT public.submit_exercise_attempt(
  'c4000000-0000-0000-0000-0000000000c1',
  'c2000000-0000-0000-0000-0000000000a1',
  '[{"questionId":"c3000000-0000-0000-0000-000000000001","choice":"b"},
    {"questionId":"c3000000-0000-0000-0000-000000000002","choice":"b"},
    {"questionId":"c3000000-0000-0000-0000-000000000003","choice":"b"},
    {"questionId":"c3000000-0000-0000-0000-000000000004","choice":"b"},
    {"questionId":"c3000000-0000-0000-0000-000000000005","choice":"b"}]'::jsonb
);

SELECT results_eq(
  $$SELECT retry_level FROM public.spaced_repetition_schedule
     WHERE user_id = 'c3333333-3333-3333-3333-3333333333a3'
       AND status = 'pending'
     ORDER BY retry_level$$,
  ARRAY[1, 2, 3],
  'non-régression : l''échec planifie toujours les trois paliers 1 / 3 / 7 jours'
);

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
