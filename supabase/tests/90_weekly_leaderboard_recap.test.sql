-- =========================================================
-- Étude 31, lot 5 — LA SEMAINE (US-7, US-8, R-15, R-18).
-- ---------------------------------------------------------
-- Constat n° 5 : « le classement ne repart JAMAIS ». L'XP est cumulé à vie, donc
-- un compte de septembre ne rattrapera jamais un compte de juin — l'anti-« fresh
-- start » exact, et il décourage précisément celui qui vient d'arriver.
--
-- Ce fichier garde trois propriétés :
--
--   1. ⭐ LA SEMAINE EST UNE FENÊTRE, PAS UN CUMUL. Un élève au cumul énorme mais
--      inactif cette semaine n'est PAS classé ; un nouveau venu très actif passe
--      devant lui. Si cette assertion tombe, le tableau est redevenu le cumul
--      qu'il était.
--   2. ⭐ L'HORLOGE EST CELLE DE LA LIGUE (R-15) : `app_current_week_start()`,
--      lundi, fuseau de Tunis. Une tentative de dimanche dernier n'entre pas.
--   3. ⭐ LE BILAN N'INVENTE AUCUN ÉCART (R-18) : sans mission la semaine passée,
--      l'écart de précision est NULL — sinon une reprise après vacances
--      annoncerait « +67 points de progression », un compliment mécanique et faux.
--
-- Espace de noms des fixtures : préfixe `a31…`.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(12);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, content_language)
VALUES ('a31-subj', 'A31 Matière', 'Force', 'subject-math', 'Brain', 'ecole-tn', 'fr');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('a3100000-0000-4000-8000-0000000000c1', 'a31-subj', 'A31 Chapitre');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source)
VALUES ('a3100000-0000-4000-8000-0000000000e1', 'a3100000-0000-4000-8000-0000000000c1',
        'a31-subj', 'A31 Ex', 'practice', 'admin');

INSERT INTO auth.users (id, email)
SELECT ('a3100000-0000-4000-8000-00000000000' || g)::uuid, 'a31-u' || g || '@test.local'
FROM generate_series(1, 3) AS g;

-- Un décor daté relativement au LUNDI de la semaine en cours (fuseau Tunis).
CREATE TEMP TABLE a31_week AS
SELECT public.app_current_week_start() AS w,
       (public.app_current_week_start()::timestamp AT TIME ZONE 'Africa/Tunis') AS from_ts;

-- u1 : le VÉTÉRAN — 5 000 XP à vie, mais rien cette semaine (tout date d'avant).
UPDATE public.profiles SET xp = 5000, level = 26 WHERE id = 'a3100000-0000-4000-8000-000000000001';
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct,
   duration_seconds, xp_earned, completed_at)
SELECT 'a3100000-0000-4000-8000-000000000001', 'a3100000-0000-4000-8000-0000000000e1', 'a31-subj',
       5, 5, 100, 100, 500, (SELECT from_ts FROM a31_week) - INTERVAL '3 days';

-- u2 : LE NOUVEAU — 60 XP à vie, tous gagnés cette semaine.
UPDATE public.profiles SET xp = 60 WHERE id = 'a3100000-0000-4000-8000-000000000002';
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct,
   duration_seconds, xp_earned, completed_at)
SELECT 'a3100000-0000-4000-8000-000000000002', 'a3100000-0000-4000-8000-0000000000e1', 'a31-subj',
       4, 5, 80, 100, 60, (SELECT from_ts FROM a31_week) + INTERVAL '2 hours';

-- u3 : actif cette semaine, moins que u2.
UPDATE public.profiles SET xp = 3000 WHERE id = 'a3100000-0000-4000-8000-000000000003';
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct,
   duration_seconds, xp_earned, completed_at)
SELECT 'a3100000-0000-4000-8000-000000000003', 'a3100000-0000-4000-8000-0000000000e1', 'a31-subj',
       3, 5, 60, 100, 20, (SELECT from_ts FROM a31_week) + INTERVAL '3 hours';

SET LOCAL "request.jwt.claims" = '{"sub":"a3100000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- =========================================================
-- 1. ⭐ La semaine est une FENÊTRE.
-- =========================================================
SELECT is(
  (SELECT COUNT(*)::int FROM public.get_weekly_leaderboard('global', 50)
    WHERE display_name IS NOT NULL),
  2,
  '⭐ seuls les DEUX élèves actifs cette semaine sont classés — le vétéran à 5 000 XP n''y est pas'
);

SELECT is(
  (SELECT is_me FROM public.get_weekly_leaderboard('global', 50) WHERE rank = 1),
  true,
  '⭐ le NOUVEAU passe devant : 60 XP cette semaine battent 5 000 XP à vie (fin de l''anti-fresh-start)'
);

SELECT is(
  (SELECT xp FROM public.get_weekly_leaderboard('global', 50) WHERE rank = 1),
  60,
  'la colonne `xp` porte l''XP DE LA SEMAINE, pas le cumul'
);

-- =========================================================
-- 2. ⭐ L'horloge de la ligue (R-15) — une tentative d'avant le lundi n'entre pas.
-- =========================================================
RESET ROLE;
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct,
   duration_seconds, xp_earned, completed_at)
SELECT 'a3100000-0000-4000-8000-000000000002', 'a3100000-0000-4000-8000-0000000000e1', 'a31-subj',
       5, 5, 100, 100, 999, (SELECT from_ts FROM a31_week) - INTERVAL '1 second';

SET LOCAL "request.jwt.claims" = '{"sub":"a3100000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT xp FROM public.get_weekly_leaderboard('global', 50) WHERE is_me),
  60,
  '⭐ une seconde AVANT le lundi de Tunis, c''est la semaine passée — 999 XP n''entrent pas'
);

-- =========================================================
-- 3. La portée « matière » et la portée « classe ».
-- =========================================================
SELECT is(
  (SELECT COUNT(*)::int FROM public.get_weekly_leaderboard('a31-subj', 50)),
  2,
  'la portée par matière garde ceux qui l''ont pratiquée cette semaine'
);

SELECT is(
  (SELECT COUNT(*)::int FROM public.get_weekly_leaderboard('matiere-inconnue', 50)),
  0,
  'une matière que personne n''a jouée rend un tableau vide, pas une erreur'
);

SELECT is(
  (SELECT COUNT(*)::int FROM public.get_weekly_leaderboard('grade', 50)),
  0,
  'sans classe rattachée, la cohorte « ma classe » est vide — on ne propose pas un rang qui n''existe pas'
);

-- =========================================================
-- 4. ⭐ Le bilan de la semaine (US-8, R-18).
-- =========================================================
SELECT is(
  (public.get_weekly_recap()->'thisWeek'->>'xp')::int,
  60,
  'le bilan compte l''XP de la semaine en cours'
);

SELECT is(
  (public.get_weekly_recap()->'lastWeek'->>'xp')::int,
  999,
  'et celui de la semaine précédente, pour l''écart'
);

SELECT is(
  (public.get_weekly_recap()->>'hasActivity')::boolean,
  true,
  'une semaine avec des missions a un bilan à montrer'
);

RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"a3100000-0000-4000-8000-000000000003","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.get_weekly_recap()->'delta'->>'avgScore'),
  NULL,
  '⭐ sans mission la semaine passée, l''écart de précision est NULL — pas « +60 points de progression »'
);

RESET ROLE;

SELECT ok(
  has_function_privilege('authenticated', 'public.get_weekly_recap()', 'EXECUTE')
    AND NOT has_function_privilege('anon', 'public.get_weekly_recap()', 'EXECUTE'),
  'le bilan est lisible par un connecté, jamais par anon — il est self-scopé'
);

SELECT * FROM finish();
ROLLBACK;
