-- =========================================================
-- Suppression de compte — le contrat que la base doit tenir quand un compte part.
--
-- L'application supprime un compte par `auth.admin.deleteUser`, c'est-à-dire par
-- un simple DELETE sur `auth.users` : TOUT le comportement de l'effacement est
-- donc décidé ici, par les clés étrangères, et par rien d'autre. Un `ON DELETE`
-- mal posé ne se verrait ni au typecheck, ni en test unitaire, ni en revue — il se
-- verrait au premier utilisateur qui part, sur le geste le moins rattrapable de
-- l'application. D'où ce fichier.
--
-- Ce que la base doit garantir :
--   1. la progression PART — profil et tentatives cascadent, c'est l'effacement
--      promis par la politique de confidentialité (« à la suppression du compte,
--      elles sont effacées ») ;
--   2. le SIGNALEMENT reste, son AUTEUR part — une clé de réponse fausse reste
--      fausse quand le témoin s'en va ;
--   3. un compte ADMIN peut partir — les quatre colonnes « qui a classé ça »
--      étaient en NO ACTION et refusaient la suppression ;
--   4. un signalement orphelin n'est lisible que par un admin — la policy
--      `user_id = auth.uid() OR is_admin()` doit dégrader du bon côté quand
--      `user_id` vaut NULL.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(18);

-- ---------------------------------------------------------
-- 1. Le schéma : six colonnes en SET NULL, deux auteurs devenus facultatifs.
-- ---------------------------------------------------------
SELECT col_is_null('public', 'content_reports', 'user_id',
  'content_reports.user_id est nullable — un signalement survit à son auteur');
SELECT col_is_null('public', 'bug_reports', 'user_id',
  'bug_reports.user_id est nullable — un signalement survit à son auteur');

-- `confdeltype` : 'n' = SET NULL, 'c' = CASCADE, 'a' = NO ACTION (l'état d'avant).
CREATE OR REPLACE FUNCTION pg_temp.del_action(p_table text, p_column text)
RETURNS text LANGUAGE sql STABLE AS $fn$
  SELECT con.confdeltype::text
  FROM pg_constraint con
  JOIN pg_attribute att
    ON att.attrelid = con.conrelid AND att.attnum = con.conkey[1]
  WHERE con.conrelid  = format('public.%I', p_table)::regclass
    AND con.contype   = 'f'
    AND con.confrelid = 'auth.users'::regclass
    AND array_length(con.conkey, 1) = 1
    AND att.attname   = p_column;
$fn$;

SELECT is(pg_temp.del_action('content_reports', 'user_id'), 'n',
  'content_reports.user_id : SET NULL (le signalement reste, l''auteur part)');
SELECT is(pg_temp.del_action('bug_reports', 'user_id'), 'n',
  'bug_reports.user_id : SET NULL (le signalement reste, l''auteur part)');
SELECT is(pg_temp.del_action('content_reports', 'resolved_by'), 'n',
  'content_reports.resolved_by : SET NULL — un admin qui part ne bloque plus rien');
SELECT is(pg_temp.del_action('bug_reports', 'resolved_by'), 'n',
  'bug_reports.resolved_by : SET NULL — un admin qui part ne bloque plus rien');
SELECT is(pg_temp.del_action('beta_access_requests', 'reviewed_by'), 'n',
  'beta_access_requests.reviewed_by : SET NULL — un admin qui part ne bloque plus rien');
SELECT is(pg_temp.del_action('parcours_entitlements', 'granted_by'), 'n',
  'parcours_entitlements.granted_by : SET NULL — un admin qui part ne bloque plus rien');

-- La contrepartie : ce qui DOIT continuer à cascader. Si l'une de ces deux-là
-- passait un jour en SET NULL, l'effacement deviendrait une anonymisation sans
-- que personne ne l'ait décidé — et la page confidentialité deviendrait fausse.
SELECT is(pg_temp.del_action('attempts', 'user_id'), 'c',
  'attempts.user_id reste en CASCADE — la progression part vraiment');
SELECT is(pg_temp.del_action('parent_student_links', 'student_user_id'), 'c',
  'parent_student_links.student_user_id reste en CASCADE — le lien tombe avec l''élève');

-- ---------------------------------------------------------
-- 2. Les fixtures : un élève (A), un admin (B) qui a classé ses deux signalements.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('a0000000-0000-0000-0000-00000000000a', 'del-student@test.local'),
  ('b0000000-0000-0000-0000-00000000000b', 'del-admin@test.local');

UPDATE public.profiles SET role = 'admin'
  WHERE id = 'b0000000-0000-0000-0000-00000000000b';

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('del-subj', 'Delete Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('c0000000-0000-0000-0000-00000000000c', 'del-subj', 'Delete Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward)
VALUES ('e0000000-0000-0000-0000-00000000000e',
        'c0000000-0000-0000-0000-00000000000c', 'del-subj', 'Delete Exercise', 50);

INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned)
VALUES ('a0000000-0000-0000-0000-00000000000a', 'e0000000-0000-0000-0000-00000000000e',
        'del-subj', 5, 5, 100, 120, 50);

INSERT INTO public.content_reports (id, user_id, exercise_id, message, status, resolved_by)
VALUES ('11111111-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-00000000000a',
        'e0000000-0000-0000-0000-00000000000e', 'La reponse B est fausse.', 'resolved',
        'b0000000-0000-0000-0000-00000000000b');

INSERT INTO public.bug_reports (id, user_id, message, status, resolved_by)
VALUES ('22222222-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-00000000000a',
        'Le bouton ne repond pas.', 'resolved', 'b0000000-0000-0000-0000-00000000000b');

-- ---------------------------------------------------------
-- 3. L'admin part. C'est le cas qui levait une violation de clé étrangère.
-- ---------------------------------------------------------
SELECT lives_ok(
  $q$DELETE FROM auth.users WHERE id = 'b0000000-0000-0000-0000-00000000000b'$q$,
  'un compte ADMIN peut être supprimé — les 4 colonnes « qui a classé » ne bloquent plus'
);

SELECT is(
  (SELECT resolved_by FROM public.content_reports
     WHERE id = '11111111-0000-0000-0000-000000000001'),
  NULL::uuid,
  'le signalement de contenu reste classé, sans plus nommer qui l''a classé'
);
SELECT is(
  (SELECT resolved_by FROM public.bug_reports
     WHERE id = '22222222-0000-0000-0000-000000000002'),
  NULL::uuid,
  'le signalement de bug reste classé, sans plus nommer qui l''a classé'
);

-- ---------------------------------------------------------
-- 4. L'élève part. La progression disparaît, les signalements restent orphelins.
-- ---------------------------------------------------------
DELETE FROM auth.users WHERE id = 'a0000000-0000-0000-0000-00000000000a';

SELECT is(
  (SELECT count(*)::int FROM public.profiles
     WHERE id = 'a0000000-0000-0000-0000-00000000000a'),
  0, 'le profil a disparu — effacement, pas anonymisation');
SELECT is(
  (SELECT count(*)::int FROM public.attempts
     WHERE user_id = 'a0000000-0000-0000-0000-00000000000a'),
  0, 'les tentatives ont disparu — la progression part avec le compte');

SELECT is(
  (SELECT user_id FROM public.content_reports
     WHERE id = '11111111-0000-0000-0000-000000000001'),
  NULL::uuid,
  'le signalement de contenu SURVIT, orphelin : la faute reste connue du triage');
SELECT is(
  (SELECT count(*)::int FROM public.bug_reports
     WHERE id = '22222222-0000-0000-0000-000000000002' AND user_id IS NULL),
  1,
  'le signalement de bug SURVIT, orphelin : le défaut reste connu du triage');

-- ---------------------------------------------------------
-- 5. RLS : un orphelin n'appartient à personne, donc il n'est lisible qu'en admin.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email)
VALUES ('d0000000-0000-0000-0000-00000000000d', 'del-peer@test.local');

SET LOCAL "request.jwt.claims" = '{"sub":"d0000000-0000-0000-0000-00000000000d","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.content_reports
     WHERE id = '11111111-0000-0000-0000-000000000001'),
  0,
  'RLS : un signalement orphelin n''est PAS lisible par un utilisateur quelconque'
);

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
