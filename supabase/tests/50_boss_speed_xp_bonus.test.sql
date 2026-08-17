-- =========================================================
-- Prime de rapidité du mode BOSS — 20260816140000_boss_speed_xp_bonus.sql
-- ---------------------------------------------------------
-- Le chronomètre du combat de boss est ouvert (il ne coupe plus personne) et
-- il NOTE : ici, sa lecture sur les XP. Ce fichier verrouille les quatre choses
-- qui font qu'on peut vivre avec un multiplicateur de vitesse alors qu'un
-- multiplicateur de vitesse GLOBAL a dû être purgé en juin 2026 :
--
--   1. sous le temps de référence, un boss paie la prime pleine (×1.5) ;
--   2. au-delà du double, il paie exactement comme avant — la prime vaut 1,
--      JAMAIS un malus, sinon on aurait réinventé la punition de la lenteur ;
--   3. la prime ne fuit PAS hors du mode boss : même durée, exercice practice,
--      XP inchangés ;
--   4. la porte anti-bâclage passe AVANT la prime : trop vite = zéro XP, et
--      c'est ce qui rend impossible de gagner en expédiant.
--
-- Temps de référence (miroir SQL/TS) : 35 s par question, corrections lues
-- comprises. Sur 4 questions ⇒ 140 s ; prime pleine à ≤ 140 s, nulle à ≥ 280 s.
-- Barème : xp_reward 100, 4 questions justes ⇒ base 100 XP.
--
-- Fixtures dans l'espace `7e57…` réservé aux tests. Chaque cas a son user et
-- son exercice pour que prev_best ne bave pas d'une assertion à l'autre ; tout
-- est annulé à la fin.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(5);

-- ---------------------------------------------------------
-- Contenu partagé : un chapitre, deux exercices identiques à un détail près —
-- l'un est un boss, l'autre non. C'est ce détail seul qu'on mesure.
-- ---------------------------------------------------------
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('boss-speed-subj', 'Boss Speed Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('7e574901-0000-0000-0000-000000000001', 'boss-speed-subj', 'Boss Speed Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward, reward_coins, mode)
VALUES
  ('7e574902-0000-0000-0000-000000000001',
   '7e574901-0000-0000-0000-000000000001', 'boss-speed-subj',
   'Boss Exercise', 100, 20, 'boss'),
  ('7e574902-0000-0000-0000-000000000002',
   '7e574901-0000-0000-0000-000000000001', 'boss-speed-subj',
   'Practice Exercise', 100, 20, 'practice');

-- 4 QCM par exercice, bonne réponse 'a'.
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
SELECT
  ('e4900000-0000-0000-0000-00000000000' || g)::uuid,
  '7e574902-0000-0000-0000-000000000001',
  'Q' || g,
  '[{"id":"a","text":"right"},{"id":"b","text":"wrong"},{"id":"c","text":"x"},{"id":"d","text":"y"}]'::jsonb,
  'a',
  g
FROM generate_series(1, 4) AS g;

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
SELECT
  ('e4900000-0000-0000-0000-00000000001' || g)::uuid,
  '7e574902-0000-0000-0000-000000000002',
  'Q' || g,
  '[{"id":"a","text":"right"},{"id":"b","text":"wrong"},{"id":"c","text":"x"},{"id":"d","text":"y"}]'::jsonb,
  'a',
  g
FROM generate_series(1, 4) AS g;

-- =========================================================
-- CAS 1 — boss mené sous le temps de référence → prime pleine.
-- 100 s écoulées < 140 s ⇒ facteur 1.5 ⇒ 150 XP.
-- =========================================================
INSERT INTO auth.users (id, email)
VALUES ('f4911111-1111-1111-1111-111111111111', 'boss-fast@test.local');

INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('a4900000-0000-0000-0000-000000000001',
        'f4911111-1111-1111-1111-111111111111',
        '7e574902-0000-0000-0000-000000000001',
        clock_timestamp() - INTERVAL '100 seconds');

SET LOCAL "request.jwt.claims" = '{"sub":"f4911111-1111-1111-1111-111111111111","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- La session est consommee par le premier appel : on lit les DEUX champs qui
-- comptent dans la meme charge utile, en une assertion, plutot que de rejouer.
SELECT is(
  (
    SELECT (p ->> 'xpEarned') || ' / ' || (p ->> 'speedBonus')
    FROM (
      SELECT public.submit_exercise_attempt(
        'a4900000-0000-0000-0000-000000000001',
        '7e574902-0000-0000-0000-000000000001',
        '[{"questionId":"e4900000-0000-0000-0000-000000000001","choice":"a"},
          {"questionId":"e4900000-0000-0000-0000-000000000002","choice":"a"},
          {"questionId":"e4900000-0000-0000-0000-000000000003","choice":"a"},
          {"questionId":"e4900000-0000-0000-0000-000000000004","choice":"a"}]'::jsonb
      ) AS p
    ) t
  ),
  '150 / 1.5',
  'boss sous le temps de reference : prime pleine annoncee (1.5) ET appliquee (100 -> 150 XP)'
);

SELECT is(
  (SELECT xp FROM public.profiles WHERE id = 'f4911111-1111-1111-1111-111111111111'),
  150,
  'le profil encaisse bien les XP primes'
);

RESET ROLE;

-- =========================================================
-- CAS 2 — boss mené lentement → AUCUNE prime, et surtout aucun malus.
-- 400 s écoulées > 280 s ⇒ facteur 1.0 ⇒ 100 XP, comme avant ce lot.
-- =========================================================
INSERT INTO auth.users (id, email)
VALUES ('f4922222-2222-2222-2222-222222222222', 'boss-slow@test.local');

INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('a4900000-0000-0000-0000-000000000002',
        'f4922222-2222-2222-2222-222222222222',
        '7e574902-0000-0000-0000-000000000001',
        clock_timestamp() - INTERVAL '400 seconds');

SET LOCAL "request.jwt.claims" = '{"sub":"f4922222-2222-2222-2222-222222222222","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (
    SELECT (public.submit_exercise_attempt(
      'a4900000-0000-0000-0000-000000000002',
      '7e574902-0000-0000-0000-000000000001',
      '[{"questionId":"e4900000-0000-0000-0000-000000000001","choice":"a"},
        {"questionId":"e4900000-0000-0000-0000-000000000002","choice":"a"},
        {"questionId":"e4900000-0000-0000-0000-000000000003","choice":"a"},
        {"questionId":"e4900000-0000-0000-0000-000000000004","choice":"a"}]'::jsonb
    ) ->> 'xpEarned')::int
  ),
  100,
  'boss lent : XP inchanges (la prime vaut 1, jamais un malus)'
);

RESET ROLE;

-- =========================================================
-- CAS 3 — la prime ne fuit pas hors du boss. Même durée que le cas 1, mode
-- practice : 100 XP, pas 150.
-- =========================================================
INSERT INTO auth.users (id, email)
VALUES ('f4933333-3333-3333-3333-333333333333', 'practice-fast@test.local');

INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('a4900000-0000-0000-0000-000000000003',
        'f4933333-3333-3333-3333-333333333333',
        '7e574902-0000-0000-0000-000000000002',
        clock_timestamp() - INTERVAL '100 seconds');

SET LOCAL "request.jwt.claims" = '{"sub":"f4933333-3333-3333-3333-333333333333","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (
    SELECT (public.submit_exercise_attempt(
      'a4900000-0000-0000-0000-000000000003',
      '7e574902-0000-0000-0000-000000000002',
      -- `…001' || g` avec g de 1 à 4 ⇒ …011 à …014. Répondre à partir de …010
      -- ratait la 4ᵉ question : 75 % au lieu de 100, et le cas mesurait alors
      -- une note, pas une prime.
      '[{"questionId":"e4900000-0000-0000-0000-000000000011","choice":"a"},
        {"questionId":"e4900000-0000-0000-0000-000000000012","choice":"a"},
        {"questionId":"e4900000-0000-0000-0000-000000000013","choice":"a"},
        {"questionId":"e4900000-0000-0000-0000-000000000014","choice":"a"}]'::jsonb
    ) ->> 'xpEarned')::int
  ),
  100,
  'practice a la meme vitesse : aucune prime (le lot ne touche que le boss)'
);

RESET ROLE;

-- =========================================================
-- CAS 4 — la porte anti-bâclage passe AVANT la prime : expédier un boss en
-- 2 s ne paie pas 1.5 × quelque chose, ça paie zéro.
-- =========================================================
INSERT INTO auth.users (id, email)
VALUES ('f4944444-4444-4444-4444-444444444444', 'boss-rush@test.local');

INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('a4900000-0000-0000-0000-000000000004',
        'f4944444-4444-4444-4444-444444444444',
        '7e574902-0000-0000-0000-000000000001',
        clock_timestamp() - INTERVAL '2 seconds');

SET LOCAL "request.jwt.claims" = '{"sub":"f4944444-4444-4444-4444-444444444444","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (
    SELECT (public.submit_exercise_attempt(
      'a4900000-0000-0000-0000-000000000004',
      '7e574902-0000-0000-0000-000000000001',
      '[{"questionId":"e4900000-0000-0000-0000-000000000001","choice":"a"},
        {"questionId":"e4900000-0000-0000-0000-000000000002","choice":"a"},
        {"questionId":"e4900000-0000-0000-0000-000000000003","choice":"a"},
        {"questionId":"e4900000-0000-0000-0000-000000000004","choice":"a"}]'::jsonb
    ) ->> 'xpEarned')::int
  ),
  0,
  'boss expedie sous 4 s/question : zero XP, la prime ne rattrape rien'
);

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
