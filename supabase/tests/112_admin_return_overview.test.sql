-- =========================================================
-- Étude 40, lot 0 — LA MESURE DU RETOUR, côté comptes (`admin_return_overview`).
-- ---------------------------------------------------------
-- Ce que ce fichier tient, et qui se perdrait en silence :
--
--   1. ⭐ LA GARDE. Un non-admin est REFUSÉ, anon n'a même pas le droit d'appeler.
--      La fonction lit `auth.users` et la table des abonnements push.
--   2. ⭐ « PAS ENCORE MESURABLE » ≠ « PERDU ». Une cohorte dont la fenêtre de sept
--      jours n'est pas écoulée a une BASE À ZÉRO — même si l'un de ses comptes a
--      déjà joué. La compter perdue ferait paniquer sur une donnée absente ; la
--      compter gagnée ferait mentir la première semaine dans le sens qui arrange.
--   3. ⭐ LE JOUR J. `played_7d` l'INCLUT (c'est la première quête), `back_7d`
--      l'EXCLUT (c'est un retour). Le décor pose un compte qui ne joue QUE le jour J :
--      il est le seul à séparer les deux définitions.
--   4. ⭐ LE COMPTE NON CONFIRMÉ reste dans `signups` et dans la base — il s'est
--      inscrit et n'a pas joué — mais pas dans `confirmed`.
--   5. La portée du push compte des PERSONNES : deux abonnements d'un même élève,
--      deux enfants d'un même parent, un lien désactivé.
--
-- ⚠️ AUCUNE DATE EN DUR (leçon #934) : tout est relatif à `app_current_week_start()`
-- et à `now()`. Les jours d'activité sont posés à midi, heure de Tunis.
-- L'activité est posée par des POULS (`learning_pulses`) : aucune clé étrangère de
-- catalogue à satisfaire, et c'est la même vue `eng_activity_days` qui les lit.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(25);

-- ---------------------------------------------------------
-- Les comptes (suffixe → rôle dans le décor) :
--   01..05 : cohorte A, inscrite le lundi S-3 (fenêtre ÉCOULÉE) ; 05 non confirmé
--   06..07 : cohorte B, inscrite AUJOURD'HUI (fenêtre NON écoulée)
--   08..09 : élèves anciens, hors des huit semaines
--   10..12 : parents
--   13     : l'admin
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at,
                        raw_user_meta_data, created_at, updated_at,
                        aud, role, instance_id)
SELECT
  ('f4000000-0000-4000-8000-0000000000' || lpad(n::text, 2, '0'))::uuid,
  'ret-user-' || n || '@test.local', 'x',
  CASE WHEN n = 5 THEN NULL ELSE now() END,          -- ⭐ 05 n'a jamais confirmé son e-mail
  '{"display_name":"Ret"}'::jsonb, now(), now(),
  'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'::uuid
FROM generate_series(1, 13) n;

UPDATE public.profiles SET role = 'admin'  WHERE id = 'f4000000-0000-4000-8000-000000000013'::uuid;
UPDATE public.profiles SET role = 'parent'
 WHERE id IN ('f4000000-0000-4000-8000-000000000010'::uuid,
              'f4000000-0000-4000-8000-000000000011'::uuid,
              'f4000000-0000-4000-8000-000000000012'::uuid);

-- Tout compte étranger à ce décor sort des huit semaines (base de test partagée).
UPDATE public.profiles SET created_at = now() - INTERVAL '200 days'
 WHERE id::text NOT LIKE 'f4000000-%';

-- Cohorte A : lundi de la semaine S-3, 09:00 à Tunis.
UPDATE public.profiles
   SET created_at = ((public.app_current_week_start() - 21 + TIME '09:00') AT TIME ZONE 'Africa/Tunis')
 WHERE id IN ('f4000000-0000-4000-8000-000000000001'::uuid,
              'f4000000-0000-4000-8000-000000000002'::uuid,
              'f4000000-0000-4000-8000-000000000003'::uuid,
              'f4000000-0000-4000-8000-000000000004'::uuid,
              'f4000000-0000-4000-8000-000000000005'::uuid);

-- Cohorte B : aujourd'hui.
UPDATE public.profiles SET created_at = now()
 WHERE id IN ('f4000000-0000-4000-8000-000000000006'::uuid,
              'f4000000-0000-4000-8000-000000000007'::uuid);

-- Les anciens : bien avant la fenêtre des cohortes.
UPDATE public.profiles SET created_at = now() - INTERVAL '120 days'
 WHERE id IN ('f4000000-0000-4000-8000-000000000008'::uuid,
              'f4000000-0000-4000-8000-000000000009'::uuid);

-- =========================================================
-- 1. Les droits, puis la garde.
-- =========================================================
SELECT ok(
  NOT has_function_privilege('anon', 'public.admin_return_overview()', 'EXECUTE'),
  'anon ne peut pas appeler la mesure du retour — le REVOKE tient sans dépendre de is_admin()'
);

SELECT ok(
  has_function_privilege('authenticated', 'public.admin_return_overview()', 'EXECUTE'),
  'un connecté peut l''appeler : c''est la garde de RÔLE, pas le GRANT, qui trie les admins'
);

SET LOCAL request.jwt.claims = '{"sub":"f4000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$ SELECT public.admin_return_overview() $$,
  'P0001',
  'Unauthorized',
  '⭐ un élève est refusé — la fonction lit auth.users et les abonnements push de tout le parc'
);

RESET ROLE;
SET LOCAL request.jwt.claims = '{"sub":"f4000000-0000-4000-8000-000000000010","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$ SELECT public.admin_return_overview() $$,
  'P0001',
  'Unauthorized',
  'un parent est refusé lui aussi'
);

RESET ROLE;

-- =========================================================
-- 2. LE PARC SANS ACTIVITÉ — huit lignes, des zéros, aucune erreur.
-- =========================================================
SET LOCAL request.jwt.claims = '{"sub":"f4000000-0000-4000-8000-000000000013","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  jsonb_array_length(public.admin_return_overview()->'cohorts'),
  8,
  '⭐ huit cohortes, toujours — une semaine sans inscription rend une ligne, pas un trou'
);

SELECT is(
  (public.admin_return_overview()->'cohorts'->0->>'week')::date,
  public.app_current_week_start() - 49,
  'la première cohorte est le lundi d''il y a sept semaines'
);

SELECT is(
  (public.admin_return_overview()->'cohorts'->7->>'week')::date,
  public.app_current_week_start(),
  'la dernière cohorte est la semaine en cours'
);

SELECT is(
  (SELECT (c->>'signups')::int
     FROM jsonb_array_elements(public.admin_return_overview()->'cohorts') c
    WHERE (c->>'week')::date = public.app_current_week_start() - 35),
  0,
  'une semaine sans inscription compte zéro inscrit'
);

SELECT is(
  (public.admin_return_overview()->>'never_played')::int,
  (public.admin_return_overview()->>'students')::int,
  'sans aucune activité, tous les élèves sont « jamais joué » — et la fonction RÉPOND'
);

RESET ROLE;

-- ---------------------------------------------------------
-- LE DÉCOR MESURÉ.
--
-- Cohorte A (J = lundi S-3, fenêtre écoulée) :
--   01 : actif le jour J SEULEMENT → première quête OUI, retour NON   ⭐
--   02 : actif J+3                 → première quête OUI, retour OUI
--   03 : actif J+7                 → OUI, OUI (la borne est INCLUSE)
--   04 : actif J+8                 → NON, NON (hors fenêtre) — mais il a joué un jour
--   05 : non confirmé, un pouls de NAVIGATION seulement → jamais joué
--   ⇒ signups 5, confirmed 4, base 5, played_7d 3, back_7d 2.
--
-- Cohorte B (J = aujourd'hui) : 06 joue aujourd'hui, 07 non.
--   ⇒ signups 2, base 0, played_7d 0 : NON MESURABLE, ni perdue ni gagnée.   ⭐
--
-- Anciens : 08 n'a jamais joué ; 09 a joué il y a 40 jours (hors des 30 jours).
--   ⇒ never_played = 05, 07, 08 = 3 sur 9 élèves ;
--     students_active_30d = 01, 02, 03, 04, 06 = 5.
-- ---------------------------------------------------------
INSERT INTO public.learning_pulses (user_id, surface, active_seconds, occurred_at)
SELECT u, 'lesson', 120,
       ((public.app_current_week_start() - 21 + off + TIME '12:00') AT TIME ZONE 'Africa/Tunis')
FROM (VALUES
  ('f4000000-0000-4000-8000-000000000001'::uuid, 0),
  ('f4000000-0000-4000-8000-000000000002'::uuid, 3),
  ('f4000000-0000-4000-8000-000000000003'::uuid, 7),
  ('f4000000-0000-4000-8000-000000000004'::uuid, 8)
) AS v(u, off);

INSERT INTO public.learning_pulses (user_id, surface, active_seconds, occurred_at) VALUES
  ('f4000000-0000-4000-8000-000000000005'::uuid, 'browse', 120,
   ((public.app_current_week_start() - 21 + TIME '12:00') AT TIME ZONE 'Africa/Tunis')),
  ('f4000000-0000-4000-8000-000000000006'::uuid, 'lesson', 120, now()),
  ('f4000000-0000-4000-8000-000000000009'::uuid, 'lesson', 120, now() - INTERVAL '40 days');

-- Le push. 01 a DEUX appareils ; l'admin est abonné mais n'est pas un élève.
INSERT INTO public.push_subscriptions (user_id, endpoint, p256dh, auth) VALUES
  ('f4000000-0000-4000-8000-000000000001'::uuid, 'https://push.test/ret-01-a', 'k', 'a'),
  ('f4000000-0000-4000-8000-000000000001'::uuid, 'https://push.test/ret-01-b', 'k', 'a'),
  ('f4000000-0000-4000-8000-000000000010'::uuid, 'https://push.test/ret-10',   'k', 'a'),
  ('f4000000-0000-4000-8000-000000000012'::uuid, 'https://push.test/ret-12',   'k', 'a'),
  ('f4000000-0000-4000-8000-000000000013'::uuid, 'https://push.test/ret-13',   'k', 'a');

-- Les parents. 10 suit DEUX enfants (compté une fois) et est abonné ; 11 suit un
-- enfant sans être abonné ; 12 est abonné mais son lien est DÉSACTIVÉ.
INSERT INTO public.parent_student_links (parent_user_id, student_user_id, is_active) VALUES
  ('f4000000-0000-4000-8000-000000000010'::uuid, 'f4000000-0000-4000-8000-000000000001'::uuid, true),
  ('f4000000-0000-4000-8000-000000000010'::uuid, 'f4000000-0000-4000-8000-000000000002'::uuid, true),
  ('f4000000-0000-4000-8000-000000000011'::uuid, 'f4000000-0000-4000-8000-000000000003'::uuid, true),
  ('f4000000-0000-4000-8000-000000000012'::uuid, 'f4000000-0000-4000-8000-000000000004'::uuid, false);

SET LOCAL request.jwt.claims = '{"sub":"f4000000-0000-4000-8000-000000000013","role":"authenticated"}';
SET LOCAL ROLE authenticated;

-- =========================================================
-- 3. ⭐ LA COHORTE ÉCOULÉE — première quête contre retour.
-- =========================================================
CREATE TEMP TABLE ret_a ON COMMIT DROP AS
SELECT c FROM jsonb_array_elements(public.admin_return_overview()->'cohorts') c
 WHERE (c->>'week')::date = public.app_current_week_start() - 21;

SELECT is((SELECT (c->>'signups')::int FROM ret_a), 5,
  'la cohorte A compte ses cinq inscrits — le non-confirmé en fait partie');

SELECT is((SELECT (c->>'confirmed')::int FROM ret_a), 4,
  '⭐ quatre ont confirmé leur e-mail : la perte d''AVANT le premier écran se lit à part');

SELECT is((SELECT (c->>'played_7d_base')::int FROM ret_a), 5,
  'fenêtre écoulée : les cinq sont mesurables, non-confirmé compris');

SELECT is((SELECT (c->>'played_7d')::int FROM ret_a), 3,
  '⭐ première quête = 3/5 : le jour J COMPTE, J+7 compte, J+8 ne compte plus');

SELECT is((SELECT (c->>'back_7d')::int FROM ret_a), 2,
  '⭐ retour = 2/5 : celui qui n''a joué QUE le jour J a fait sa première quête, il n''est pas revenu');

SELECT is((SELECT (c->>'back_7d_base')::int FROM ret_a), 5,
  'le retour se lit sur la même base que la première quête');

-- =========================================================
-- 4. ⭐ LA COHORTE EN COURS — non mesurable, donc ni perdue ni gagnée.
-- =========================================================
CREATE TEMP TABLE ret_b ON COMMIT DROP AS
SELECT c FROM jsonb_array_elements(public.admin_return_overview()->'cohorts') c
 WHERE (c->>'week')::date = public.app_current_week_start();

SELECT is((SELECT (c->>'signups')::int FROM ret_b), 2,
  'la cohorte de la semaine en cours compte ses deux inscrits');

SELECT is((SELECT (c->>'played_7d_base')::int FROM ret_b), 0,
  '⭐ fenêtre NON écoulée : base à zéro — celui qui n''a pas encore joué n''est PAS compté perdu');

SELECT is((SELECT (c->>'played_7d')::int FROM ret_b), 0,
  '⭐ et celui qui a DÉJÀ joué n''est pas compté non plus : un numérateur sans base mentirait');

SELECT is((SELECT (c->>'back_7d_base')::int FROM ret_b), 0,
  'le retour de la semaine en cours n''est pas mesurable non plus');

-- =========================================================
-- 5. LES JAMAIS-JOUÉ — toutes dates confondues.
-- =========================================================
SELECT is((public.admin_return_overview()->>'students')::int, 9,
  'neuf élèves : ni les parents ni l''admin n''entrent au dénominateur');

SELECT is((public.admin_return_overview()->>'never_played')::int, 3,
  '⭐ trois n''ont aucun jour d''activité — un pouls de navigation n''est pas avoir joué');

-- =========================================================
-- 6. LA PORTÉE DU PUSH — des personnes, pas des lignes.
-- =========================================================
SELECT is((public.admin_return_overview()->'push'->>'students_active_30d')::int, 5,
  'cinq élèves actifs sur 30 jours — celui d''il y a 40 jours n''y est pas');

SELECT is((public.admin_return_overview()->'push'->>'students_reachable')::int, 1,
  '⭐ un élève joignable : ses deux appareils comptent pour une personne, l''admin abonné pour zéro');

SELECT is((public.admin_return_overview()->'push'->>'parents_linked')::int, 2,
  '⭐ deux parents liés : deux enfants = un parent, un lien désactivé = aucun');

SELECT is((public.admin_return_overview()->'push'->>'parents_reachable')::int, 1,
  'un parent joignable — l''abonné dont le lien est désactivé n''est pas compté');

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
