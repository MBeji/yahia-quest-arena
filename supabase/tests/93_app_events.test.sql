-- =========================================================
-- Étude 31, lot 8 — LE CALENDRIER SCOLAIRE (US-12, R-21, R-2).
-- ---------------------------------------------------------
-- Constat n° 9 : « aucun événement, aucune saison » hors la semaine ISO de la
-- ligue. Rien ne rythme l'année scolaire tunisienne.
--
-- Trois propriétés, dont la première est une LIGNE ROUGE :
--
--   1. ⭐ R-2 — un événement ne borne JAMAIS un contenu. La fenêtre borne le défi
--      et son badge ; chaque exercice reste jouable avant, pendant et après.
--      C'est ce qui sépare un événement d'un mur, et c'est vérifié en assertion
--      plutôt que promis en commentaire.
--   2. ⭐ UN SEUL ACTIF À LA FOIS (R-21), tenu par une CONTRAINTE — pas par la
--      discipline de qui écrit un seed. Deux défis concurrents, c'est deux façons
--      de se sentir en retard.
--   3. ⭐ LE BADGE SE DÉCERNE DANS LA FENÊTRE, jamais après. Sans borne haute, un
--      défi de rentrée se rattraperait en juin et ne dirait plus rien.
--
-- Espace de noms des fixtures : préfixe `e318…`.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(12);

-- Le pilote semé par la migration est daté de septembre 2026 ; les assertions ne
-- doivent pas dépendre du jour où la suite tourne. On travaille donc sur un
-- événement de test, posé AUTOUR de `now()`.
DELETE FROM public.app_events;

INSERT INTO public.badges (code, name, description, rarity, icon_name, rule_key, family)
VALUES ('event_test', 'Défi de test', 'Relever le défi de test pendant sa fenêtre',
        'rare', 'Sparkles', 'event_test', 'saison')
ON CONFLICT (code) DO NOTHING;

INSERT INTO public.app_events (code, starts_at, ends_at, goal_type, goal_target, badge_code, name, description)
VALUES ('e318-actif', now() - INTERVAL '1 day', now() + INTERVAL '5 days',
        'exercises_n', 2, 'event_test',
        '{"fr":"Défi de test","en":"Test challenge","ar":"تحدّي تجريبيّ"}'::jsonb,
        '{"fr":"Deux missions.","en":"Two missions.","ar":"مهمّتان."}'::jsonb);

-- =========================================================
-- 1. ⭐ UN SEUL ACTIF À LA FOIS — par contrainte.
-- =========================================================
SELECT throws_ok(
  $$ INSERT INTO public.app_events (code, starts_at, ends_at, goal_type, goal_target, name, description)
     VALUES ('e318-concurrent', now(), now() + INTERVAL '2 days', 'exercises_n', 3,
             '{"fr":"x","en":"x","ar":"x"}'::jsonb, '{"fr":"x","en":"x","ar":"x"}'::jsonb) $$,
  '23P01',
  NULL,
  '⭐ deux événements qui se chevauchent sont REFUSÉS par la base (R-21) — pas par la discipline d''un seed'
);

-- Un événement qui ne chevauche pas passe : la contrainte borne le chevauchement,
-- pas le calendrier.
SELECT lives_ok(
  $$ INSERT INTO public.app_events (code, starts_at, ends_at, goal_type, goal_target, name, description)
     VALUES ('e318-plus-tard', now() + INTERVAL '30 days', now() + INTERVAL '40 days',
             'exercises_n', 3, '{"fr":"x","en":"x","ar":"x"}'::jsonb, '{"fr":"x","en":"x","ar":"x"}'::jsonb) $$,
  'un événement POSTÉRIEUR est accepté — le calendrier reste un calendrier'
);

-- =========================================================
-- 2. Le décor d'élève, et la progression comptée à la volée (D-3).
-- =========================================================
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('e318-subj', 'E318 Matière', 'Force', 'subject-math', 'Brain', 'ecole-tn');
INSERT INTO public.chapters (id, subject_id, title)
VALUES ('e3180000-0000-4000-8000-0000000000c1', 'e318-subj', 'E318 Chapitre');
INSERT INTO public.exercises (id, chapter_id, subject_id, title, mode, source)
VALUES ('e3180000-0000-4000-8000-0000000000e1', 'e3180000-0000-4000-8000-0000000000c1',
        'e318-subj', 'E318 Ex', 'practice', 'admin');

INSERT INTO auth.users (id, email)
VALUES ('e3180000-0000-4000-8000-000000000001', 'e318@test.local');

SET LOCAL "request.jwt.claims" = '{"sub":"e3180000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.get_active_event()->>'code'),
  'e318-actif',
  'l''événement du moment est celui dont la fenêtre contient maintenant'
);

SELECT is(
  (public.get_active_event()->>'progress')::int,
  0,
  'la progression part de zéro — elle se compte à la volée, sans table (D-3)'
);

SELECT is(
  (public.claim_event_badge()->>'granted')::boolean,
  false,
  'sans avoir atteint l''objectif, aucun badge — le défi reste un défi'
);

RESET ROLE;

-- Une tentative AVANT la fenêtre : elle ne compte pas pour le défi.
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct,
   duration_seconds, xp_earned, completed_at)
VALUES ('e3180000-0000-4000-8000-000000000001', 'e3180000-0000-4000-8000-0000000000e1',
        'e318-subj', 5, 5, 100, 100, 20, now() - INTERVAL '10 days');

SET LOCAL "request.jwt.claims" = '{"sub":"e3180000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.get_active_event()->>'progress')::int,
  0,
  '⭐ une mission jouée AVANT l''ouverture ne compte pas — sinon le défi serait déjà gagné'
);

RESET ROLE;

INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct,
   duration_seconds, xp_earned, completed_at)
SELECT 'e3180000-0000-4000-8000-000000000001', 'e3180000-0000-4000-8000-0000000000e1',
       'e318-subj', 5, 5, 100, 100, 20, now() - INTERVAL '1 hour'
FROM generate_series(1, 2);

SET LOCAL "request.jwt.claims" = '{"sub":"e3180000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.get_active_event()->>'progress')::int,
  2,
  'deux missions dans la fenêtre : l''objectif est atteint'
);

SELECT is(
  (public.claim_event_badge()->>'granted')::boolean,
  true,
  '⭐ le badge saisonnier tombe PENDANT la fenêtre'
);

SELECT is(
  (public.claim_event_badge()->>'granted')::boolean,
  false,
  'et une seconde fois ne redonne rien — `award_badge_if_new` est idempotente'
);

RESET ROLE;

-- =========================================================
-- 3. ⭐ R-2 — LA FENÊTRE NE BORNE AUCUN CONTENU.
-- =========================================================
UPDATE public.app_events SET ends_at = now() - INTERVAL '1 hour' WHERE code = 'e318-actif';

SET LOCAL "request.jwt.claims" = '{"sub":"e3180000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  public.get_active_event(),
  NULL,
  'l''événement clos disparaît de l''affiche'
);

SELECT ok(
  EXISTS (SELECT 1 FROM public.exercises WHERE id = 'e3180000-0000-4000-8000-0000000000e1'),
  '⭐ R-2 : l''exercice, lui, est TOUJOURS là — un événement borne un défi, jamais un contenu'
);

SELECT ok(
  EXISTS (SELECT 1 FROM public.student_badges sb JOIN public.badges b ON b.id = sb.badge_id
           WHERE sb.student_user_id = 'e3180000-0000-4000-8000-000000000001' AND b.code = 'event_test'),
  '⭐ et le badge déjà obtenu n''est JAMAIS retiré (R-21) — la fenêtre ferme, elle ne reprend pas'
);

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
