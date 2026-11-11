-- =========================================================
-- Étude 31, lot 2 — LES BADGES SONT-ILS RÉELLEMENT DÉCERNABLES ?
-- ---------------------------------------------------------
-- Le constat qui a ouvert ce lot est mécanique : neuf badges sur treize avaient
-- un nom, une rareté, une icône, un `rule_key` — et AUCUNE ligne de code pour
-- les décerner. Rien ne le disait : la table était pleine, les écrans
-- s'affichaient, et un élève de six mois avait la même vitrine qu'un élève de
-- six jours.
--
-- La première assertion de ce fichier est donc structurelle, et c'est la plus
-- importante : ⭐ **aucun badge de la base ne doit être sans règle**. Elle
-- cherche le code du badge dans le corps des fonctions SQL. Elle échouera le
-- jour où quelqu'un sèmera un badge sans le décerner — c'est-à-dire le jour où
-- la panne d'aujourd'hui recommencerait.
--
-- Le reste éprouve chaque condition à travers son VRAI chemin d'appel
-- (`submit_exercise_attempt`, `finalize_dungeon_run`, `purchase_shop_item`,
-- `award_coins`) : une condition testée par un SELECT direct prouverait que la
-- requête est juste, pas qu'elle est branchée. C'était exactement le problème.
--
-- Espace de noms des fixtures : préfixe `b31…`.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(20);

-- =========================================================
-- 1. ⭐ R-13 — TOUT BADGE DE LA BASE EST DÉCERNABLE.
-- =========================================================
-- Une règle peut être ÉCRITE (le code du badge apparaît dans le corps d'une
-- fonction qui décerne) ou DÉCLARÉE (un événement du calendrier la porte en
-- donnée, é31 lot 8 : `claim_event_badge` passe le code dynamiquement, donc
-- aucun corps ne le contient). Les deux comptent ; l'absence des deux, non.
SELECT is(
  (SELECT COUNT(*)::int FROM public.badges b
    WHERE NOT EXISTS (
      SELECT 1
      FROM pg_proc p
      JOIN pg_namespace n ON n.oid = p.pronamespace
      WHERE n.nspname = 'public'
        AND p.prosrc LIKE '%award_badge_if_new%'
        AND p.prosrc LIKE '%''' || b.code || '''%'
    )
    AND NOT EXISTS (
      SELECT 1 FROM public.app_events e WHERE e.badge_code = b.code
    )),
  0,
  '⭐ R-13 : aucun badge de la base n''est sans règle — c''est la panne du lot 2, en assertion'
);

SELECT is(
  (SELECT COUNT(*)::int FROM public.badges WHERE code = 'night_owl'),
  0,
  'D-5 : `night_owl` a quitté la base — aucun badge ne juge l''heure à laquelle un enfant travaille'
);

SELECT is(
  (SELECT COUNT(*)::int FROM public.badges WHERE family IS NULL),
  0,
  'chaque badge porte sa famille : une collection groupée ne peut pas avoir d''orphelin'
);

SELECT throws_ok(
  $$ INSERT INTO public.badges (code, name, rarity, family) VALUES ('b31_bad', 'X', 'common', 'inconnue') $$,
  '23514',
  NULL,
  'une famille hors liste est refusée par la base, pas par la relecture'
);

-- La règle « matière de mathématiques », définie une fois (§2 de la migration).
SELECT ok(public.badge_is_math_subject('math'), 'la matière historique `math` est bien des maths');
SELECT ok(public.badge_is_math_subject('math-bac-math'), '`math-bac-math` aussi');
SELECT ok(
  NOT public.badge_is_math_subject('iq-training-fr'),
  '⭐ l''entraînement au QI n''est PAS des maths — il porte pourtant `subject-math` comme jeton de couleur'
);

-- ---------------------------------------------------------
-- Le décor : une matière de maths, deux matières d'autres langues de contenu,
-- un exercice jouable de 2 questions, et neuf exercices de maths pour le compte
-- cumulé.
-- ---------------------------------------------------------
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, content_language)
VALUES
  ('math-b31',    'B31 Maths',   'Force',  'subject-math',    'Brain', 'ecole-tn', 'fr'),
  ('b31-lang-en', 'B31 English', 'Agilite','subject-english', 'Book',  'ecole-tn', 'en'),
  ('b31-lang-ar', 'B31 Arabe',   'Esprit', 'subject-arabic',  'Book',  'ecole-tn', 'ar');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('b3100000-0000-4000-8000-0000000000c1', 'math-b31', 'B31 Chapitre');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward, reward_coins, mode, source)
VALUES ('b3100000-0000-4000-8000-0000000000e1', 'b3100000-0000-4000-8000-0000000000c1',
        'math-b31', 'B31 Exercice', 100, 20, 'practice', 'admin');

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, display_order)
SELECT
  ('b3100000-0000-4000-8000-0000000000b' || g)::uuid,
  'b3100000-0000-4000-8000-0000000000e1',
  'Q' || g,
  '[{"id":"a","text":"juste"},{"id":"b","text":"faux"}]'::jsonb,
  'a',
  g
FROM generate_series(1, 2) AS g;

-- Neuf autres exercices de maths : ils ne sont jamais JOUÉS, seulement portés
-- par des tentatives écrites en dur — le compte de `math_master` se fait sur
-- `attempts`, pas sur des sessions.
INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward, reward_coins, mode, source)
SELECT
  ('b3100000-0000-4000-8000-0000000000f' || g)::uuid,
  'b3100000-0000-4000-8000-0000000000c1', 'math-b31', 'B31 Ex ' || g, 10, 2, 'practice', 'admin'
FROM generate_series(1, 9) AS g;

INSERT INTO auth.users (id, email)
SELECT ('b3100000-0000-4000-8000-00000000000' || g)::uuid, 'b31-u' || g || '@test.local'
FROM generate_series(1, 6) AS g;

-- =========================================================
-- 2. `streak_30` et `level_10` — dans `submit_exercise_attempt`, sur le profil
--    relu APRÈS récompense.
-- =========================================================
UPDATE public.profiles
   SET current_streak = 30, last_active_date = CURRENT_DATE, xp = 2000
 WHERE id = 'b3100000-0000-4000-8000-000000000001';

INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('b3100000-0000-4000-8000-0000000000a1', 'b3100000-0000-4000-8000-000000000001',
        'b3100000-0000-4000-8000-0000000000e1', clock_timestamp() - INTERVAL '120 seconds');

SET LOCAL "request.jwt.claims" = '{"sub":"b3100000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT public.submit_exercise_attempt(
  'b3100000-0000-4000-8000-0000000000a1',
  'b3100000-0000-4000-8000-0000000000e1',
  (SELECT jsonb_agg(jsonb_build_object('questionId', q.id, 'choice', 'a'))
     FROM public.questions q WHERE q.exercise_id = 'b3100000-0000-4000-8000-0000000000e1')
);
RESET ROLE;

SELECT ok(
  EXISTS (SELECT 1 FROM public.student_badges sb JOIN public.badges b ON b.id = sb.badge_id
           WHERE sb.student_user_id = 'b3100000-0000-4000-8000-000000000001' AND b.code = 'streak_30'),
  '⭐ `streak_30` tombe : une série de 30 jours cessait d''être récompensée après le 7ᵉ'
);

SELECT ok(
  EXISTS (SELECT 1 FROM public.student_badges sb JOIN public.badges b ON b.id = sb.badge_id
           WHERE sb.student_user_id = 'b3100000-0000-4000-8000-000000000001' AND b.code = 'level_10'),
  '`level_10` tombe sur un profil au-delà du palier'
);

-- =========================================================
-- 3. `math_blitz` et `math_master`.
-- =========================================================
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned)
SELECT 'b3100000-0000-4000-8000-000000000002',
       ('b3100000-0000-4000-8000-0000000000f' || g)::uuid, 'math-b31', 4, 5, 80, 120, 10
FROM generate_series(1, 9) AS g;

INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('b3100000-0000-4000-8000-0000000000a2', 'b3100000-0000-4000-8000-000000000002',
        'b3100000-0000-4000-8000-0000000000e1', clock_timestamp() - INTERVAL '120 seconds');

SET LOCAL "request.jwt.claims" = '{"sub":"b3100000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT public.submit_exercise_attempt(
  'b3100000-0000-4000-8000-0000000000a2',
  'b3100000-0000-4000-8000-0000000000e1',
  (SELECT jsonb_agg(jsonb_build_object('questionId', q.id, 'choice', 'a'))
     FROM public.questions q WHERE q.exercise_id = 'b3100000-0000-4000-8000-0000000000e1')
);
RESET ROLE;

SELECT ok(
  EXISTS (SELECT 1 FROM public.student_badges sb JOIN public.badges b ON b.id = sb.badge_id
           WHERE sb.student_user_id = 'b3100000-0000-4000-8000-000000000002' AND b.code = 'math_blitz'),
  '`math_blitz` tombe à 100 % sur un exercice de maths (seuil 95, porté par son rule_key)'
);

SELECT ok(
  EXISTS (SELECT 1 FROM public.student_badges sb JOIN public.badges b ON b.id = sb.badge_id
           WHERE sb.student_user_id = 'b3100000-0000-4000-8000-000000000002' AND b.code = 'math_master'),
  '⭐ `math_master` tombe au 10ᵉ exercice de maths DISTINCT réussi à 80 % ou plus'
);

SELECT ok(
  NOT EXISTS (SELECT 1 FROM public.student_badges sb JOIN public.badges b ON b.id = sb.badge_id
               WHERE sb.student_user_id = 'b3100000-0000-4000-8000-000000000001' AND b.code = 'math_master'),
  '⭐ l''élève au seul exercice joué ne l''a PAS : dix tentatives, pas dix fois la même'
);

-- =========================================================
-- 4. `polyglot` — trois LANGUES DE CONTENU, pas trois matières.
-- =========================================================
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned)
VALUES
  ('b3100000-0000-4000-8000-000000000003', 'b3100000-0000-4000-8000-0000000000f1', 'b31-lang-en', 3, 5, 60, 120, 5),
  ('b3100000-0000-4000-8000-000000000003', 'b3100000-0000-4000-8000-0000000000f2', 'b31-lang-ar', 3, 5, 60, 120, 5);

INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('b3100000-0000-4000-8000-0000000000a3', 'b3100000-0000-4000-8000-000000000003',
        'b3100000-0000-4000-8000-0000000000e1', clock_timestamp() - INTERVAL '120 seconds');

SET LOCAL "request.jwt.claims" = '{"sub":"b3100000-0000-4000-8000-000000000003","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT public.submit_exercise_attempt(
  'b3100000-0000-4000-8000-0000000000a3',
  'b3100000-0000-4000-8000-0000000000e1',
  (SELECT jsonb_agg(jsonb_build_object('questionId', q.id, 'choice', 'a'))
     FROM public.questions q WHERE q.exercise_id = 'b3100000-0000-4000-8000-0000000000e1')
);
RESET ROLE;

SELECT ok(
  EXISTS (SELECT 1 FROM public.student_badges sb JOIN public.badges b ON b.id = sb.badge_id
           WHERE sb.student_user_id = 'b3100000-0000-4000-8000-000000000003' AND b.code = 'polyglot'),
  '`polyglot` tombe à la troisième langue de contenu réussie'
);

SELECT ok(
  NOT EXISTS (SELECT 1 FROM public.student_badges sb JOIN public.badges b ON b.id = sb.badge_id
               WHERE sb.student_user_id = 'b3100000-0000-4000-8000-000000000002' AND b.code = 'polyglot'),
  '⭐ dix exercices dans UNE langue ne font pas un polyglotte'
);

-- =========================================================
-- 5. `boss_slayer` — le cumul des étages, pas la course du jour.
-- =========================================================
INSERT INTO public.dungeon_runs (id, user_id, floors_cleared, status, ended_at, rewarded_at)
VALUES ('b3100000-0000-4000-8000-0000000000d1', 'b3100000-0000-4000-8000-000000000004',
        6, 'completed', clock_timestamp(), clock_timestamp());
INSERT INTO public.dungeon_runs (id, user_id, floors_cleared, status)
VALUES ('b3100000-0000-4000-8000-0000000000d2', 'b3100000-0000-4000-8000-000000000004', 4, 'active');

SET LOCAL "request.jwt.claims" = '{"sub":"b3100000-0000-4000-8000-000000000004","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT public.finalize_dungeon_run('b3100000-0000-4000-8000-0000000000d2', 300);
RESET ROLE;

SELECT ok(
  EXISTS (SELECT 1 FROM public.student_badges sb JOIN public.badges b ON b.id = sb.badge_id
           WHERE sb.student_user_id = 'b3100000-0000-4000-8000-000000000004' AND b.code = 'boss_slayer'),
  '⭐ `boss_slayer` tombe au 10ᵉ étage CUMULÉ (6 + 4) — trois soirs de 3 étages valent une nuit de 10'
);

-- =========================================================
-- 6. `collector` — cinq objets DIFFÉRENTS, par le vrai chemin d'achat.
-- =========================================================
UPDATE public.profiles SET yahia_coins = 1000 WHERE id = 'b3100000-0000-4000-8000-000000000005';
INSERT INTO public.inventory_items (student_user_id, shop_item_id, quantity)
SELECT 'b3100000-0000-4000-8000-000000000005', s.id, 1
FROM public.shop_items s WHERE s.code IN ('skin_ninja', 'skin_samurai', 'skin_mage', 'shield_retry');

SET LOCAL "request.jwt.claims" = '{"sub":"b3100000-0000-4000-8000-000000000005","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT public.purchase_shop_item('booster_hint');
RESET ROLE;

SELECT ok(
  EXISTS (SELECT 1 FROM public.student_badges sb JOIN public.badges b ON b.id = sb.badge_id
           WHERE sb.student_user_id = 'b3100000-0000-4000-8000-000000000005' AND b.code = 'collector'),
  '`collector` tombe au cinquième objet différent possédé'
);

-- =========================================================
-- 7. `rich_kid` — là où le solde MONTE, jamais à l'achat (écart assumé à
--    la proposition de l'étude).
-- =========================================================
-- ⚠️ `award_coins` n'est PAS exécutable par `authenticated` (faille S1, revoquée
-- en 20260606150000) : ses appelants sont des fonctions serveur. On l'appelle
-- donc en propriétaire, avec les claims de l'élève — ce que fait la prod.
SET LOCAL "request.jwt.claims" = '{"sub":"b3100000-0000-4000-8000-000000000006","role":"authenticated"}';
SELECT public.award_coins('b3100000-0000-4000-8000-000000000006', 499);

SELECT ok(
  NOT EXISTS (SELECT 1 FROM public.student_badges sb JOIN public.badges b ON b.id = sb.badge_id
               WHERE sb.student_user_id = 'b3100000-0000-4000-8000-000000000006' AND b.code = 'rich_kid'),
  '499 pièces ne suffisent pas — le seuil est un seuil'
);

SELECT public.award_coins('b3100000-0000-4000-8000-000000000006', 1);

SELECT ok(
  EXISTS (SELECT 1 FROM public.student_badges sb JOIN public.badges b ON b.id = sb.badge_id
           WHERE sb.student_user_id = 'b3100000-0000-4000-8000-000000000006' AND b.code = 'rich_kid'),
  '⭐ `rich_kid` tombe à 500 pièces — au CRÉDIT, le seul moment où le solde monte'
);

-- =========================================================
-- 8. Idempotence — un badge ne se décerne pas deux fois, et ne se retire jamais.
-- =========================================================
SELECT is(
  (SELECT COUNT(*)::int FROM public.student_badges sb JOIN public.badges b ON b.id = sb.badge_id
    WHERE sb.student_user_id = 'b3100000-0000-4000-8000-000000000006' AND b.code = 'rich_kid'),
  1,
  'un second crédit ne redonne pas le badge : `award_badge_if_new` est idempotente'
);

SELECT is(
  (SELECT public.award_badge_if_new('b3100000-0000-4000-8000-000000000006', 'rich_kid', 'rejeu')),
  NULL,
  'et elle le DIT : rien à annoncer quand le badge est déjà porté'
);

SELECT * FROM finish();
ROLLBACK;
