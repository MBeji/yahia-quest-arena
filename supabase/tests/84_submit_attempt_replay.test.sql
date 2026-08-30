-- =========================================================
-- REJEU D'UNE SOUMISSION — l'idempotence, prouvée plutôt que promise.
-- ---------------------------------------------------------
-- Depuis 20260831130000, rejouer `submit_exercise_attempt` sur une session déjà
-- rendue REND la tentative enregistrée au lieu de lever. Ce fichier vérifie les
-- deux moitiés de cette promesse, celle qui aide l'élève et celle qui protège
-- le jeu :
--
--   1. le rejeu rend le VRAI score de la tentative d'origine ;
--   2. il ne crédite RIEN une seconde fois — ni XP, ni pièces — et n'écrit pas
--      de seconde ligne dans `attempts`, même joué dix fois de suite.
--
-- La deuxième moitié est la raison d'être de l'ancienne garde : sans elle, un
-- rejeu était une machine à XP. Elle tient toujours, et par construction — la
-- branche de rejeu sort avant le premier INSERT — mais « par construction » se
-- vérifie aussi.
--
-- Le cas HÉRITÉ est couvert lui aussi : une session close sans tentative
-- rattachée (antérieure à `attempts.session_id`, 20260816170000) n'a rien à
-- rendre, et doit continuer de refuser.
--
-- Espace de noms des fixtures : préfixe `7e57…`, réservé aux tests (voir
-- 04_scoring_submit_attempt.test.sql).
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(11);

-- ---------------------------------------------------------
-- Contenu : un exercice de 5 questions, bonne réponse 'a' partout.
-- ---------------------------------------------------------
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('replay-subj', 'Replay Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('7e578401-0000-0000-0000-000000000001', 'replay-subj', 'Replay Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward, reward_coins, mode)
VALUES ('7e578402-0000-0000-0000-000000000001',
        '7e578401-0000-0000-0000-000000000001', 'replay-subj',
        'Replay Exercise', 100, 20, 'practice');

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
SELECT
  ('e3840000-0000-0000-0000-00000000000' || g)::uuid,
  '7e578402-0000-0000-0000-000000000001',
  'Q' || g,
  '[{"id":"a","text":"right"},{"id":"b","text":"wrong"},{"id":"c","text":"x"},{"id":"d","text":"y"}]'::jsonb,
  'a',
  g
FROM generate_series(1, 5) AS g;

-- =========================================================
-- CAS 1 — une soumission, puis dix rejeux.
-- =========================================================
INSERT INTO auth.users (id, email)
VALUES ('f8888888-8888-8888-8888-888888888888', 'replay@test.local');

INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('a8000000-0000-0000-0000-000000000001',
        'f8888888-8888-8888-8888-888888888888',
        '7e578402-0000-0000-0000-000000000001',
        -- 5 questions × 4 s = 20 s de garde anti-précipitation ; 120 s la passent.
        clock_timestamp() - INTERVAL '120 seconds');

SET LOCAL "request.jwt.claims" = '{"sub":"f8888888-8888-8888-8888-888888888888","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- Le rendu d'origine : score plein, récompense pleine.
SELECT is(
  (
    SELECT (public.submit_exercise_attempt(
      'a8000000-0000-0000-0000-000000000001',
      '7e578402-0000-0000-0000-000000000001',
      '[{"questionId":"e3840000-0000-0000-0000-000000000001","choice":"a"},
        {"questionId":"e3840000-0000-0000-0000-000000000002","choice":"a"},
        {"questionId":"e3840000-0000-0000-0000-000000000003","choice":"a"},
        {"questionId":"e3840000-0000-0000-0000-000000000004","choice":"a"},
        {"questionId":"e3840000-0000-0000-0000-000000000005","choice":"a"}]'::jsonb
    ) ->> 'xpEarned')::int
  ),
  100,
  'le rendu d''origine attribue les XP (100)'
);

SELECT is(
  (SELECT count(*)::int FROM public.attempts
     WHERE session_id = 'a8000000-0000-0000-0000-000000000001'),
  1,
  'le rendu d''origine écrit exactement une tentative'
);

-- ---------------------------------------------------------
-- DIX REJEUX. C'est le test que la panne réclame : la file de
-- `outbox.ts` peut renvoyer la même soumission autant de fois que le réseau
-- l'exige, et l'élève lui-même peut recliquer.
-- ---------------------------------------------------------
SELECT is(
  (
    SELECT count(*)::int FROM (
      SELECT public.submit_exercise_attempt(
        'a8000000-0000-0000-0000-000000000001',
        '7e578402-0000-0000-0000-000000000001',
        '[{"questionId":"e3840000-0000-0000-0000-000000000001","choice":"a"},
          {"questionId":"e3840000-0000-0000-0000-000000000002","choice":"a"},
          {"questionId":"e3840000-0000-0000-0000-000000000003","choice":"a"},
          {"questionId":"e3840000-0000-0000-0000-000000000004","choice":"a"},
          {"questionId":"e3840000-0000-0000-0000-000000000005","choice":"a"}]'::jsonb
      ) AS r
      FROM generate_series(1, 10)
    ) s
  ),
  10,
  'dix rejeux aboutissent tous, aucun ne lève'
);

SELECT is(
  (SELECT count(*)::int FROM public.attempts
     WHERE session_id = 'a8000000-0000-0000-0000-000000000001'),
  1,
  'après dix rejeux, il y a TOUJOURS exactement une tentative'
);

SELECT is(
  (SELECT xp FROM public.profiles WHERE id = 'f8888888-8888-8888-8888-888888888888'),
  100,
  'dix rejeux ne créditent pas un seul XP de plus'
);

SELECT is(
  (SELECT yahia_coins FROM public.profiles WHERE id = 'f8888888-8888-8888-8888-888888888888'),
  20,
  'dix rejeux ne créditent pas une seule pièce de plus'
);

-- ---------------------------------------------------------
-- Ce que le rejeu REND : le vrai score, des récompenses neutres.
--
-- L'appel est répété en toutes lettres à chaque assertion plutôt que factorisé
-- dans une vue temporaire : la créer exigerait des droits sur le schéma temp que
-- le rôle `authenticated` n'a pas à garantir, et un test qui échoue pour une
-- raison de plomberie ne dit plus rien de ce qu'il prétend vérifier.
-- ---------------------------------------------------------
SELECT is(
  ((    SELECT public.submit_exercise_attempt(
      'a8000000-0000-0000-0000-000000000001',
      '7e578402-0000-0000-0000-000000000001',
      '[{"questionId":"e3840000-0000-0000-0000-000000000001","choice":"a"},
        {"questionId":"e3840000-0000-0000-0000-000000000002","choice":"a"},
        {"questionId":"e3840000-0000-0000-0000-000000000003","choice":"a"},
        {"questionId":"e3840000-0000-0000-0000-000000000004","choice":"a"},
        {"questionId":"e3840000-0000-0000-0000-000000000005","choice":"a"}]'::jsonb
    ) ->> 'replayed')::boolean),
  true,
  'le rejeu se déclare comme tel — le client s''en sert pour ne pas refêter'
);

SELECT is(
  ((    SELECT public.submit_exercise_attempt(
      'a8000000-0000-0000-0000-000000000001',
      '7e578402-0000-0000-0000-000000000001',
      '[{"questionId":"e3840000-0000-0000-0000-000000000001","choice":"a"},
        {"questionId":"e3840000-0000-0000-0000-000000000002","choice":"a"},
        {"questionId":"e3840000-0000-0000-0000-000000000003","choice":"a"},
        {"questionId":"e3840000-0000-0000-0000-000000000004","choice":"a"},
        {"questionId":"e3840000-0000-0000-0000-000000000005","choice":"a"}]'::jsonb
    ) ->> 'scorePct')::int),
  100,
  'le rejeu rend le VRAI score de la tentative d''origine'
);

SELECT is(
  ((    SELECT public.submit_exercise_attempt(
      'a8000000-0000-0000-0000-000000000001',
      '7e578402-0000-0000-0000-000000000001',
      '[{"questionId":"e3840000-0000-0000-0000-000000000001","choice":"a"},
        {"questionId":"e3840000-0000-0000-0000-000000000002","choice":"a"},
        {"questionId":"e3840000-0000-0000-0000-000000000003","choice":"a"},
        {"questionId":"e3840000-0000-0000-0000-000000000004","choice":"a"},
        {"questionId":"e3840000-0000-0000-0000-000000000005","choice":"a"}]'::jsonb
    ) ->> 'correct')::int),
  5,
  'le rejeu rend le vrai nombre de bonnes réponses'
);

SELECT is(
  ((    SELECT public.submit_exercise_attempt(
      'a8000000-0000-0000-0000-000000000001',
      '7e578402-0000-0000-0000-000000000001',
      '[{"questionId":"e3840000-0000-0000-0000-000000000001","choice":"a"},
        {"questionId":"e3840000-0000-0000-0000-000000000002","choice":"a"},
        {"questionId":"e3840000-0000-0000-0000-000000000003","choice":"a"},
        {"questionId":"e3840000-0000-0000-0000-000000000004","choice":"a"},
        {"questionId":"e3840000-0000-0000-0000-000000000005","choice":"a"}]'::jsonb
    ) ->> 'coinsEarned')::int),
  0,
  'le rejeu n''annonce AUCUNE pièce — elles ont été créditées au premier rendu'
);

RESET ROLE;

-- =========================================================
-- CAS 2 — session close SANS tentative rattachée (données héritées).
-- Rien à rendre : l'ancien refus reste le seul énoncé vrai.
-- =========================================================
INSERT INTO auth.users (id, email)
VALUES ('f9999999-9999-9999-9999-999999999999', 'replay-legacy@test.local');

INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at, completed_at)
VALUES ('a9000000-0000-0000-0000-000000000001',
        'f9999999-9999-9999-9999-999999999999',
        '7e578402-0000-0000-0000-000000000001',
        clock_timestamp() - INTERVAL '120 seconds',
        clock_timestamp() - INTERVAL '60 seconds');

SET LOCAL "request.jwt.claims" = '{"sub":"f9999999-9999-9999-9999-999999999999","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$SELECT public.submit_exercise_attempt(
      'a9000000-0000-0000-0000-000000000001',
      '7e578402-0000-0000-0000-000000000001',
      '[{"questionId":"e3840000-0000-0000-0000-000000000001","choice":"a"}]'::jsonb
    )$$,
  'This quest session is already completed.',
  'une session close sans tentative rattachée refuse encore — il n''y a rien à rendre'
);

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
