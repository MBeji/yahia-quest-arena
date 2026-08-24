-- =========================================================
-- Étude 11, lot 7 — LES DEUX MESURES DE LA CONSOLE.
-- ---------------------------------------------------------
-- Ce fichier ne teste PAS la mécanique d'énergie : `get_tutor_energy` et
-- `recharge_tutor_energy` existent depuis le 2026-08-23 et sont déjà gardées en
-- 27 assertions par `68_tutor_platform_energy.test.sql`. Les retester ici
-- doublerait la surface à maintenir sans rien couvrir de neuf.
--
-- Il garde la seule chose que le lot 7 AJOUTE en base — `get_tutor_cache_stats`
-- — et trois propriétés dont la perte serait silencieuse :
--
--   1. ⭐ LA GARDE. Un non-admin est REFUSÉ. C'est l'assertion qui compte : la
--      fonction lit deux tables `REVOKE ALL` dont les corps portent la
--      correction (R-1/R-16), et elle agrège TOUT LE PARC. Sans cette garde,
--      un SECURITY DEFINER ouvert aux `authenticated` transformerait une
--      console d'admin en fuite de volumétrie pour n'importe quel élève.
--   2. ⭐ LE REBUT EST BIEN CELUI DU PARC. `get_ai_console` rend déjà un taux de
--      rebut, mais scopé `owner_user_id = auth.uid()`. Le décor pose donc deux
--      quiz de porteurs DIFFÉRENTS, choisis pour que le bon chiffre (0,500) ne
--      soit atteignable QU'EN agrégeant les deux familles — pris seuls ils
--      donnent 0,818 et 0,111. Une régression qui rescoperait la mesure sur une
--      famille serait attrapée par la valeur, pas par une intention.
--   3. LES DIVISIONS PAR ZÉRO NE LÈVENT PAS. Le jour 1 d'une mise en service —
--      exactement le moment où on regarde la console — le parc est vide. Une
--      `division_by_zero` remonterait à l'écran déguisée en « accès refusé »,
--      et on chercherait la panne du mauvais côté.
--
-- Plus le bornage de la fenêtre, et la cohorte (§ arbitrage de la migration
-- 20260824130000) : une explication créée AVANT la fenêtre n'entre pas dans le
-- hit-rate, même si elle a été massivement servie.
--
-- ⚠️ L'ORDRE DES SECTIONS EST PORTEUR : les assertions « parc vide » tournent
-- AVANT l'insertion du décor. Ce n'est pas de la coquetterie — c'est le seul
-- moyen d'observer un vrai zéro sans truquer les dates.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(26);

-- ---------------------------------------------------------
-- Décor immuable : de quoi accrocher des explications à de vraies questions
-- (`tutor_explanations.question_id` est une FK), deux porteurs, deux élèves,
-- un admin.
-- ---------------------------------------------------------
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('tcs-theme', 'TCS Theme', 'Brain', 'subject-math', true);

INSERT INTO public.grades (id, theme_id, slug, name_fr, cycle, display_order)
VALUES ('7c000000-0000-4000-8000-0000000000f1'::uuid, 'tcs-theme', 'tcs-9', 'TCS 9ème', 'college', 9);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id, content_language)
VALUES ('tcs-subj', 'TCS Maths', 'Esprit', 'subject-math', 'Brain', 'tcs-theme',
        '7c000000-0000-4000-8000-0000000000f1'::uuid, 'fr');

INSERT INTO public.chapters (id, subject_id, title, summary, lesson_content)
VALUES ('7c000000-0000-4000-8000-0000000000c1'::uuid, 'tcs-subj', 'TCS Fractions',
        'Résumé TCS', '## Addition' || E'\n' || 'On garde le dénominateur.');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, mode, source)
VALUES ('7c000000-0000-4000-8000-0000000000e1'::uuid,
        '7c000000-0000-4000-8000-0000000000c1'::uuid, 'tcs-subj', 'TCS Ex', 1, 'practice', 'admin');

INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order)
VALUES
  ('7c000000-0000-4000-8000-0000000000a1'::uuid, '7c000000-0000-4000-8000-0000000000e1'::uuid,
   'TCS question 1', '[{"id":"a","text":"3/4"},{"id":"b","text":"3/12"}]'::jsonb,
   'a', 'On garde le dénominateur commun.', 1),
  ('7c000000-0000-4000-8000-0000000000a2'::uuid, '7c000000-0000-4000-8000-0000000000e1'::uuid,
   'TCS question 2', '[{"id":"a","text":"1"},{"id":"b","text":"2"}]'::jsonb,
   'b', 'Explication 2.', 2);

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at,
                        raw_user_meta_data, created_at, updated_at,
                        aud, role, instance_id)
VALUES
  ('7c000000-0000-4000-8000-000000000001', 'tcs-porteur-a@test.local', 'x', now(),
   '{"display_name":"Porteur A"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'),
  ('7c000000-0000-4000-8000-000000000002', 'tcs-porteur-b@test.local', 'x', now(),
   '{"display_name":"Porteur B"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'),
  ('7c000000-0000-4000-8000-000000000003', 'tcs-eleve-a@test.local', 'x', now(),
   '{"display_name":"Élève A"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'),
  ('7c000000-0000-4000-8000-000000000004', 'tcs-eleve-b@test.local', 'x', now(),
   '{"display_name":"Élève B"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'),
  ('7c000000-0000-4000-8000-000000000009', 'tcs-admin@test.local', 'x', now(),
   '{"display_name":"Admin"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000')
ON CONFLICT (id) DO NOTHING;

-- Le profil est créé par le trigger `on_auth_user_created` ; seul le rôle se
-- promeut ici, et c'est lui que `is_admin()` lit.
UPDATE public.profiles SET role = 'admin' WHERE id = '7c000000-0000-4000-8000-000000000009';

-- =========================================================
-- 1. Les droits d'exécution — le premier rempart, avant même la garde de rôle.
-- =========================================================
SELECT ok(
  NOT has_function_privilege('anon', 'public.get_tutor_cache_stats(integer)', 'EXECUTE'),
  'anon ne peut pas appeler la console du cache — le REVOKE tient sans dépendre de is_admin()'
);

SELECT ok(
  has_function_privilege('authenticated', 'public.get_tutor_cache_stats(integer)', 'EXECUTE'),
  'un utilisateur connecté peut l''appeler : c''est la garde de RÔLE, pas le GRANT, qui trie les admins'
);

-- =========================================================
-- 2. ⭐ LA GARDE. Un élève ordinaire ne lit pas la volumétrie du parc.
-- =========================================================
SET LOCAL request.jwt.claims = '{"sub":"7c000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$ SELECT public.get_tutor_cache_stats(30) $$,
  'P0001',
  'Unauthorized',
  '⭐ un NON-admin est refusé — la fonction lit deux tables REVOKE ALL et agrège tout le parc'
);

RESET ROLE;

-- =========================================================
-- 3. Le parc VIDE — des zéros, jamais une division_by_zero.
--    (Aucune explication, aucun quiz forgé n'existe encore à ce point.)
-- =========================================================
SET LOCAL request.jwt.claims = '{"sub":"7c000000-0000-4000-8000-000000000009","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.get_tutor_cache_stats(30)->>'misses')::INT,
  0,
  'sur un parc vide la fonction RÉPOND — elle ne lève pas, elle rend un objet à zéro'
);

SELECT is(
  (public.get_tutor_cache_stats(30)->>'hitRate')::NUMERIC,
  0::NUMERIC,
  'hit-rate sans aucune explication : 0, pas une erreur de division — c''est l''état du jour 1'
);

SELECT is(
  (public.get_tutor_cache_stats(30)->>'discardRate')::NUMERIC,
  0::NUMERIC,
  'taux de rebut sans aucun quiz forgé : 0, pas une erreur de division'
);

RESET ROLE;

-- ---------------------------------------------------------
-- Le décor mesuré. Chaque valeur est choisie pour qu'un seul calcul la produise.
--
-- CACHE — quatre explications du jour, une cinquième vieille de 100 jours :
--   partagées   : 5 + 3 services  (porteur A)
--   privées     : 2 + 0 services  (porteur B)
--   hors cohorte: 100 services    — volontairement ÉNORME : si la fenêtre ne
--                                   mordait pas, elle écraserait tout le reste
--                                   et le hit-rate sauterait de 0,714 à 0,957.
--
-- FORGE — deux porteurs DIFFÉRENTS, et un payload malformé hors cohorte :
--   A : 9 jetés / 2 gardés  ⇒ seul, 0,818
--   B : 1 jeté  / 8 gardés  ⇒ seul, 0,111
--   ensemble                ⇒ 10/20 = 0,500  ← la seule valeur qui prouve
--                                              l'agrégation inter-familles.
-- ---------------------------------------------------------
INSERT INTO public.tutor_explanations
  (question_id, misconception, lang, age_band, variant, body, model, shared, owner_user_id,
   serve_count, created_at)
VALUES
  ('7c000000-0000-4000-8000-0000000000a1'::uuid, 'tcs.frac.add-denominators', 'fr', '12-14',
   'concret', 'Explication partagée A.', 'claude-haiku-4-5', true,
   '7c000000-0000-4000-8000-000000000001'::uuid, 5, now()),
  ('7c000000-0000-4000-8000-0000000000a1'::uuid, 'tcs.frac.add-denominators', 'fr', '12-14',
   'visuel-verbal', 'Explication partagée B.', 'claude-haiku-4-5', true,
   '7c000000-0000-4000-8000-000000000001'::uuid, 3, now()),
  -- R-15.2 : un modèle hors liste curée reste PRIVÉ à son payeur. Ces deux-là
  -- ne mutualisent rien, et la coupe partagé/privé doit le montrer.
  ('7c000000-0000-4000-8000-0000000000a2'::uuid, NULL, 'fr', '12-14',
   'concret', 'Explication privée A.', 'modele-maison', false,
   '7c000000-0000-4000-8000-000000000002'::uuid, 2, now()),
  ('7c000000-0000-4000-8000-0000000000a2'::uuid, NULL, 'fr', '12-14',
   'formel', 'Explication privée B — jamais resservie.', 'modele-maison', false,
   '7c000000-0000-4000-8000-000000000002'::uuid, 0, now()),
  ('7c000000-0000-4000-8000-0000000000a2'::uuid, NULL, 'fr', '12-14',
   'visuel-verbal', 'Vieille explication très servie.', 'claude-haiku-4-5', true,
   '7c000000-0000-4000-8000-000000000001'::uuid, 100, now() - INTERVAL '100 days');

INSERT INTO public.ai_forged_quizzes
  (student_user_id, owner_user_id, scope, chapter_id, competency_id, lang, difficulty,
   requested, payload, model, discarded, created_at)
VALUES
  ('7c000000-0000-4000-8000-000000000003'::uuid, '7c000000-0000-4000-8000-000000000001'::uuid,
   'mistakes', NULL, NULL, 'fr', 2, 5,
   '{"items":[{"id":"q1"},{"id":"q2"}]}'::jsonb, 'claude-haiku-4-5', 9, now()),
  ('7c000000-0000-4000-8000-000000000004'::uuid, '7c000000-0000-4000-8000-000000000002'::uuid,
   'mistakes', NULL, NULL, 'fr', 3, 8,
   ('{"items":[{"id":"q1"},{"id":"q2"},{"id":"q3"},{"id":"q4"},' ||
    '{"id":"q5"},{"id":"q6"},{"id":"q7"},{"id":"q8"}]}')::jsonb, 'modele-maison', 1, now()),
  -- ⚠️ `items` n'est PAS un tableau. `jsonb_array_length` LÈVERAIT dessus : une
  -- seule ligne malformée n'importe où dans le parc éteindrait la console de
  -- tout le monde. Elle est datée hors cohorte 30 j pour n'entrer que dans les
  -- assertions de la section 6, qui la traversent sans exception.
  ('7c000000-0000-4000-8000-000000000003'::uuid, '7c000000-0000-4000-8000-000000000001'::uuid,
   'mistakes', NULL, NULL, 'fr', 2, 5,
   '{"items":"pas-un-tableau"}'::jsonb, 'claude-haiku-4-5', 5, now() - INTERVAL '100 days');

SET LOCAL request.jwt.claims = '{"sub":"7c000000-0000-4000-8000-000000000009","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- =========================================================
-- 4. La COHORTE à 30 jours — le hit-rate de §1.4.
-- =========================================================
SELECT is(
  (public.get_tutor_cache_stats(30)->>'misses')::INT,
  4,
  'la cohorte compte les explications CRÉÉES dans la fenêtre : 4, pas les 5 de la table'
);

SELECT is(
  (public.get_tutor_cache_stats(30)->>'hits')::INT,
  10,
  'les services de la cohorte s''additionnent (5+3+2+0) — les 100 de la vieille ligne restent dehors'
);

SELECT is(
  (public.get_tutor_cache_stats(30)->>'delivered')::INT,
  14,
  'ce que l''élève a REÇU = les générations plus les services (4+10)'
);

SELECT is(
  (public.get_tutor_cache_stats(30)->>'hitRate')::NUMERIC,
  0.714::NUMERIC,
  '⭐ §1.4 : la part des livraisons qui n''a rien coûté — 10/14, arrondi à 3 décimales'
);

SELECT is(
  (public.get_tutor_cache_stats(30)->>'sharedRows')::INT,
  2,
  'R-15.2 : deux explications sont entrées au pot commun'
);

SELECT is(
  (public.get_tutor_cache_stats(30)->>'privateRows')::INT,
  2,
  'R-15.2 : deux sont restées privées à leur payeur — un modèle hors liste curée ne fixe pas la qualité du parc'
);

SELECT is(
  (public.get_tutor_cache_stats(30)->>'sharedHits')::INT,
  8,
  'D-9 : ce sont les partagées qui portent la charge (5+3 services)'
);

SELECT is(
  (public.get_tutor_cache_stats(30)->>'privateHits')::INT,
  2,
  'et les privées presque rien (2+0) — un hit-rate porté par du privé ne mutualise rien'
);

SELECT is(
  (public.get_tutor_cache_stats(30)->>'sharedRate')::NUMERIC,
  0.5::NUMERIC,
  'la coupe partagé/privé se lit AVEC le hit-rate, jamais seule'
);

-- =========================================================
-- 5. ⭐ LE REBUT DU PARC — ce que get_ai_console ne peut pas dire.
-- =========================================================
SELECT is(
  (public.get_tutor_cache_stats(30)->>'discarded')::INT,
  10,
  'les candidats jetés s''additionnent AU-DELÀ d''une famille (9 chez A + 1 chez B)'
);

SELECT is(
  (public.get_tutor_cache_stats(30)->>'kept')::INT,
  10,
  'les items retenus se comptent dans payload->''items'' (2 chez A + 8 chez B)'
);

SELECT is(
  (public.get_tutor_cache_stats(30)->>'discardRate')::NUMERIC,
  0.5::NUMERIC,
  '⭐ 10/20 : seule l''agrégation des DEUX porteurs donne 0,500 — A seul dirait 0,818, B seul 0,111'
);

-- =========================================================
-- 6. La fenêtre — elle mord, et elle se dit.
-- =========================================================
SELECT is(
  (public.get_tutor_cache_stats(30)->>'days')::INT,
  30,
  'la fenêtre voyage AVEC les chiffres : un ratio sans fenêtre est un chiffre qu''on ne peut pas contredire'
);

-- La clé que l'écran lit pour choisir son LIBELLÉ : « sur 30 j » ou « depuis
-- toujours ». L'arbitrage du lot a retenu la cohorte, donc une vraie fenêtre —
-- si ce booléen passait à `true` sans que le calcul change, l'écran mentirait
-- dans l'autre sens.
SELECT is(
  (public.get_tutor_cache_stats(30)->>'lifetimeHitRate')::BOOLEAN,
  false,
  'le hit-rate est FENÊTRÉ (cohorte), pas « depuis toujours » — et il le dit au client'
);

SELECT is(
  (public.get_tutor_cache_stats(200)->>'hits')::INT,
  110,
  'élargie à 200 jours, la vieille explication entre dans la cohorte (10+100)'
);

SELECT is(
  (public.get_tutor_cache_stats(200)->>'hitRate')::NUMERIC,
  0.957::NUMERIC,
  '110/115 : le hit-rate d''une cohorte ancienne est bien plus haut — c''est pourquoi la cohorte SOUS-ESTIME'
);

SELECT is(
  (public.get_tutor_cache_stats(200)->>'discardRate')::NUMERIC,
  0.6::NUMERIC,
  'un payload dont ''items'' n''est pas un tableau compte 0 gardé et ne LÈVE pas (15/25)'
);

SELECT is(
  (public.get_tutor_cache_stats(200)->>'days')::INT,
  200,
  'la fenêtre demandée est celle qui est rendue, tant qu''elle reste dans les bornes'
);

-- =========================================================
-- 7. Le bornage — une fenêtre absurde se corrige, elle ne se propage pas.
-- =========================================================
SELECT is(
  (public.get_tutor_cache_stats(5000)->>'days')::INT,
  365,
  'plafonnée à 365 j : au-delà, R-14 a déjà purgé — on balaierait pour rien'
);

SELECT is(
  (public.get_tutor_cache_stats(0)->>'days')::INT,
  1,
  'plancher à 1 j : sans lui, un 0 rendrait une fenêtre vide — un faux zéro, le pire des états'
);

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
