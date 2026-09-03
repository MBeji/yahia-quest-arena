-- =========================================================
-- Étude 31, lot 3 — LES MISSIONS DU JOUR (R-9 → R-12).
-- ---------------------------------------------------------
-- Trois propriétés portent tout le lot, et les trois se perdraient en silence :
--
--   1. ⭐ LE TIRAGE EST DÉTERMINISTE (D-4). Mêmes (élève, jour) ⇒ mêmes missions.
--      Sans cette garantie, un rechargement change les missions sous les pieds de
--      l'élève, et aucun test n'est reproductible. Le décor fait tourner
--      `ensure_daily_weekly_goals` DEUX FOIS et compare.
--   2. ⭐ LE POOL EST FILTRÉ PAR ÉLIGIBILITÉ RÉELLE (R-9). Un élève sans parcours
--      ne doit pas recevoir « 5 étages de donjon » : le donjon puise dans son
--      parcours, la mission serait un mur. C'est RISK-6, et il ne se voit pas —
--      l'élève croit simplement qu'il n'y arrive pas.
--   3. ⭐ L'ENVELOPPE DU JOUR NE BOUGE PAS (R-11). 3 × 15 + 5 = 50 XP,
--      3 × 3 + 1 = 10 pièces : exactement ce que la journée distribuait avant ce
--      lot. Toute autre valeur relève de é09, pas d'ici.
--
-- Plus : le socle est toujours en tête (une journée sans mission faisable serait
-- pire que la mission unique d'avant), le bonus de complétion se déclenche par
-- trigger, et l'anneau lit l'XP RÉEL (le compteur d'`award_xp`, qui doit se
-- remettre à zéro au changement de jour).
--
-- Espace de noms des fixtures : préfixe `d31…`.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(20);

-- ---------------------------------------------------------
-- Décor : une matière du parcours `ecole-tn` + un exercice jouable, deux élèves
-- (l'un avec parcours, l'autre sans) et un exercice hors parcours.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email)
VALUES
  ('d3100000-0000-4000-8000-000000000001', 'd31-avec@test.local'),
  ('d3100000-0000-4000-8000-000000000002', 'd31-sans@test.local');

-- =========================================================
-- 1. LE POOL — ce qu'un élève SANS parcours peut recevoir.
-- =========================================================
SELECT is(
  (SELECT COUNT(*)::int FROM public.app_daily_mission_pool('d3100000-0000-4000-8000-000000000002')
    WHERE mission_type IN ('dungeon_floors', 'duel_play', 'subject_focus', 'chapter_step')),
  0,
  '⭐ sans parcours actif : ni donjon, ni duel, ni « ta matière » — ces missions seraient des murs (R-9)'
);

SELECT ok(
  EXISTS (SELECT 1 FROM public.app_daily_mission_pool('d3100000-0000-4000-8000-000000000002')
           WHERE mission_type = 'exercises_n'),
  'le socle reste offert à tout le monde, y compris au premier jour'
);

SELECT is(
  (SELECT COUNT(*)::int FROM public.app_daily_mission_pool('d3100000-0000-4000-8000-000000000002')
    WHERE mission_type = 'review_due'),
  0,
  'aucune révision due ⇒ pas de mission de révision (R-9)'
);

-- Le parcours actif ouvre trois types de plus.
UPDATE public.profiles
   SET current_parcours_id = (SELECT id FROM public.parcours WHERE theme_id = 'ecole-tn' LIMIT 1)
 WHERE id = 'd3100000-0000-4000-8000-000000000001';

SELECT ok(
  (SELECT COUNT(*)::int FROM public.app_daily_mission_pool('d3100000-0000-4000-8000-000000000001'))
    >= 5,
  'avec un parcours actif, le pool s''ouvre (donjon, duel, matière du parcours)'
);

-- Une révision due entre dans le pool.
INSERT INTO public.spaced_repetition_schedule
  (user_id, exercise_id, subject_id, retry_level, scheduled_for, status)
SELECT 'd3100000-0000-4000-8000-000000000001', e.id, e.subject_id, 1,
       clock_timestamp() - INTERVAL '1 hour', 'pending'
  FROM public.exercises e
 WHERE e.source = 'admin' AND e.mode IS DISTINCT FROM 'quiz'
 LIMIT 1;

SELECT ok(
  EXISTS (SELECT 1 FROM public.app_daily_mission_pool('d3100000-0000-4000-8000-000000000001')
           WHERE mission_type = 'review_due'),
  'une révision DUE fait entrer la mission de révision dans le pool'
);

-- =========================================================
-- 2. ⭐ LE TIRAGE — trois missions, socle en tête, DÉTERMINISTE.
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"d3100000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT public.ensure_daily_weekly_goals('d3100000-0000-4000-8000-000000000001');
RESET ROLE;

SELECT is(
  (SELECT COUNT(*)::int FROM public.daily_objectives
    WHERE user_id = 'd3100000-0000-4000-8000-000000000001'
      AND objective_date = (clock_timestamp() AT TIME ZONE 'UTC')::date
      AND objective_type <> 'daily_complete'),
  3,
  'trois missions du jour — plus la mission unique d''avant ce lot (constat n° 3)'
);

SELECT ok(
  EXISTS (SELECT 1 FROM public.daily_objectives
           WHERE user_id = 'd3100000-0000-4000-8000-000000000001'
             AND objective_date = (clock_timestamp() AT TIME ZONE 'UTC')::date
             AND objective_type = 'exercises_n'),
  '⭐ le socle est TOUJOURS tiré : une journée sans mission faisable serait pire qu''une seule mission'
);

-- Le tirage rejoué ne change RIEN (D-4). Le pool a même grandi entre-temps —
-- c'est justement le cas qui ferait bouger les missions si l'idempotence
-- reposait sur le hasard plutôt que sur la présence du jour.
CREATE TEMP TABLE d31_first AS
SELECT objective_type FROM public.daily_objectives
 WHERE user_id = 'd3100000-0000-4000-8000-000000000001'
   AND objective_date = (clock_timestamp() AT TIME ZONE 'UTC')::date;

SET LOCAL "request.jwt.claims" = '{"sub":"d3100000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT public.ensure_daily_weekly_goals('d3100000-0000-4000-8000-000000000001');
SELECT public.ensure_daily_weekly_goals('d3100000-0000-4000-8000-000000000001');
RESET ROLE;

SELECT is_empty(
  $$ (SELECT objective_type FROM public.daily_objectives
       WHERE user_id = 'd3100000-0000-4000-8000-000000000001'
         AND objective_date = (clock_timestamp() AT TIME ZONE 'UTC')::date
      EXCEPT SELECT objective_type FROM d31_first)
     UNION
     (SELECT objective_type FROM d31_first
      EXCEPT SELECT objective_type FROM public.daily_objectives
       WHERE user_id = 'd3100000-0000-4000-8000-000000000001'
         AND objective_date = (clock_timestamp() AT TIME ZONE 'UTC')::date) $$,
  '⭐ rejouer le tirage ne change AUCUNE mission (D-4) — au rechargement comme au test'
);

-- =========================================================
-- 3. ⭐ L'ENVELOPPE (R-11) — la journée distribue toujours 50 XP / 10 pièces.
-- =========================================================
SELECT is(
  (SELECT SUM(xp_reward)::int FROM public.daily_objectives
    WHERE user_id = 'd3100000-0000-4000-8000-000000000001'
      AND objective_date = (clock_timestamp() AT TIME ZONE 'UTC')::date),
  50,
  '⭐ 3 × 15 + 5 = 50 XP : exactement l''enveloppe d''avant le lot (R-11)'
);

SELECT is(
  (SELECT SUM(coin_reward)::int FROM public.daily_objectives
    WHERE user_id = 'd3100000-0000-4000-8000-000000000001'
      AND objective_date = (clock_timestamp() AT TIME ZONE 'UTC')::date),
  10,
  '3 × 3 + 1 = 10 pièces — même enveloppe, autre monnaie'
);

SELECT is(
  (SELECT target_value FROM public.daily_objectives
    WHERE user_id = 'd3100000-0000-4000-8000-000000000001'
      AND objective_date = (clock_timestamp() AT TIME ZONE 'UTC')::date
      AND objective_type = 'daily_complete'),
  3,
  'le bonus vise le NOMBRE de missions réellement créées, pas un 3 en dur'
);

-- =========================================================
-- 4. LE BONUS DE COMPLÉTION — par trigger, jamais par les appelants (R-6).
-- =========================================================
UPDATE public.daily_objectives
   SET current_value = target_value, status = 'completed', completed_at = clock_timestamp()
 WHERE user_id = 'd3100000-0000-4000-8000-000000000001'
   AND objective_date = (clock_timestamp() AT TIME ZONE 'UTC')::date
   AND objective_type <> 'daily_complete';

SELECT is(
  (SELECT status FROM public.daily_objectives
    WHERE user_id = 'd3100000-0000-4000-8000-000000000001'
      AND objective_date = (clock_timestamp() AT TIME ZONE 'UTC')::date
      AND objective_type = 'daily_complete'),
  'completed',
  '⭐ les trois missions finies ferment la journée — le bonus suit tout seul (R-6)'
);

-- Le trigger de récompense existant (GAP-012) n'a pas été touché : il a crédité
-- l'enveloppe entière, bonus compris.
SELECT is(
  (SELECT xp FROM public.profiles WHERE id = 'd3100000-0000-4000-8000-000000000001'),
  50,
  'l''élève a bien reçu 50 XP — `credit_goal_reward` est resté intact (stop-point du lot)'
);

-- =========================================================
-- 5. `bump_daily_mission` — l'incrément, et ce qu'il refuse.
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"d3100000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT public.ensure_daily_weekly_goals('d3100000-0000-4000-8000-000000000002');
RESET ROLE;

SELECT public.bump_daily_mission('d3100000-0000-4000-8000-000000000002', 'exercises_n',
                                 (clock_timestamp() AT TIME ZONE 'UTC')::date, 2);

SELECT is(
  (SELECT current_value FROM public.daily_objectives
    WHERE user_id = 'd3100000-0000-4000-8000-000000000002'
      AND objective_type = 'exercises_n'
      AND objective_date = (clock_timestamp() AT TIME ZONE 'UTC')::date),
  2,
  'un incrément de 2 avance de 2 (le donjon en crédite autant que d''étages franchis)'
);

SELECT public.bump_daily_mission('d3100000-0000-4000-8000-000000000002', 'exercises_n',
                                 (clock_timestamp() AT TIME ZONE 'UTC')::date, 9);

SELECT is(
  (SELECT current_value FROM public.daily_objectives
    WHERE user_id = 'd3100000-0000-4000-8000-000000000002'
      AND objective_type = 'exercises_n'
      AND objective_date = (clock_timestamp() AT TIME ZONE 'UTC')::date),
  3,
  '⭐ la progression est BORNÉE à la cible : « 12/3 » sur une barre pleine n''a aucun sens'
);

SELECT ok(
  NOT has_function_privilege('authenticated', 'public.bump_daily_mission(uuid, text, date, integer)', 'EXECUTE'),
  'l''incrément n''est pas appelable depuis le navigateur — sinon les missions se complètent seules'
);

-- =========================================================
-- 6. L'ANNEAU (R-12) — l'XP RÉEL du jour, et l'objectif choisi.
-- =========================================================
SELECT is(
  (SELECT daily_xp_base FROM public.profiles WHERE id = 'd3100000-0000-4000-8000-000000000001'),
  0,
  'la base du jour est l''XP d''AVANT le premier crédit — ici zéro, donc 50 XP gagnés aujourd''hui'
);

-- Un compteur d'hier ne compte pas pour aujourd'hui.
UPDATE public.profiles
   SET daily_xp_day = CURRENT_DATE - 1, daily_xp_base = 0, xp = 500
 WHERE id = 'd3100000-0000-4000-8000-000000000002';

SET LOCAL "request.jwt.claims" = '{"sub":"d3100000-0000-4000-8000-000000000002","role":"authenticated"}';
SELECT public.award_xp('d3100000-0000-4000-8000-000000000002', 20);
RESET ROLE;

SELECT is(
  (SELECT xp - daily_xp_base FROM public.profiles
    WHERE id = 'd3100000-0000-4000-8000-000000000002'),
  20,
  '⭐ au changement de jour, le compteur repart : 20 XP aujourd''hui, pas 520'
);

-- R-12 : l'objectif se change une fois par jour, et re-choisir le même ne compte pas.
SET LOCAL "request.jwt.claims" = '{"sub":"d3100000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT public.set_daily_xp_goal(200);
RESET ROLE;

SELECT is(
  (SELECT daily_xp_goal FROM public.profiles WHERE id = 'd3100000-0000-4000-8000-000000000002'),
  200,
  'l''objectif du jour est bien celui que l''élève a choisi'
);

SET LOCAL "request.jwt.claims" = '{"sub":"d3100000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT throws_ok(
  $$ SELECT public.set_daily_xp_goal(50) $$,
  'P0001',
  'DAILY_GOAL_ALREADY_SET_TODAY',
  '⭐ un second changement le même jour est refusé — un objectif qu''on ajuste sans cesse ne mesure rien'
);
RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
