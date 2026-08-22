-- =========================================================
-- S61 — La comptabilité IA : un payeur, jamais de montant à l'élève.
--
-- Étude 29 lot 1. Trois invariants, dont deux sont des règles de l'étude que
-- rien d'autre ne peut tenir :
--
--   1. R-7 — « un appel IA porte toujours un payeur ». `log_ai_usage` refuse une
--      dépense ORPHELINE : `payer='family'` sans porteur de clé, et son
--      symétrique `payer='platform'` AVEC un porteur (qui ferait porter notre
--      dépense à une famille dans la console).
--   2. R-14 — « celui dont un autre paie ne voit que l'énergie ». La table porte
--      des MONTANTS : un élève servi par la clé de son parent ne lit rien ici,
--      y compris par PostgREST, y compris sur les lignes qui le concernent. La
--      frontière est `credential_owner`, pas le rôle — donc elle est vérifiable
--      en SQL, et c'est ce que fait ce fichier.
--   3. Le client n'ÉCRIT pas de comptabilité : `log_ai_usage` n'est pas
--      EXECUTE-grantable par `authenticated`, et la table n'a aucune policy
--      d'écriture. Sinon un navigateur pourrait déclarer 0 $ sur chaque appel et
--      les plafonds du lot 3 ne vaudraient plus rien.
--
-- `supabase test db` enveloppe chaque fichier dans sa transaction ; on ajoute un
-- BEGIN/ROLLBACK explicite pour que le fichier soit autonome.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(16);

-- ---------------------------------------------------------
-- Fixtures : un porteur de clé (le parent) et l'élève qu'il paie.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at,
                        raw_user_meta_data, created_at, updated_at,
                        aud, role, instance_id)
VALUES
  ('a9000000-0000-4000-8000-000000000001', 'ai-owner@test.local', 'x', now(),
   '{"display_name":"Porteur"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'),
  ('a9000000-0000-4000-8000-000000000002', 'ai-student@test.local', 'x', now(),
   '{"display_name":"Élève"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000')
ON CONFLICT (id) DO NOTHING;

-- ---------------------------------------------------------
-- 1. Le schéma existe et porte le payeur.
-- ---------------------------------------------------------
SELECT has_table('public', 'ai_usage_events', 'ai_usage_events existe');
SELECT has_column('public', 'ai_usage_events', 'payer',
  'R-7 : la colonne payer existe — aucune dépense ne peut être anonyme');
SELECT has_column('public', 'ai_usage_events', 'credential_owner',
  'é29 : le porteur de la clé est nommé sur chaque ligne');
SELECT has_column('public', 'ai_usage_events', 'provider',
  'R-13 : le fournisseur réel est journalisé, sinon la console qualité mélange tout');

SELECT ok(
  (SELECT relrowsecurity FROM pg_class WHERE oid = 'public.ai_usage_events'::regclass),
  'RLS est activée sur ai_usage_events'
);

-- ---------------------------------------------------------
-- 2. R-7 : la dépense orpheline est refusée EN BASE, pas seulement en TypeScript.
-- ---------------------------------------------------------
SELECT throws_ok(
  $$ SELECT public.log_ai_usage('family', 'anthropic', 'explain', 'm', 'ok') $$,
  'AI_USAGE_FAMILY_REQUIRES_OWNER',
  'R-7 : payer=family sans porteur de clé est refusé — une dépense ne peut pas être orpheline'
);

SELECT throws_ok(
  $$ SELECT public.log_ai_usage('platform', 'anthropic', 'explain', 'm', 'ok',
       NULL, 'a9000000-0000-4000-8000-000000000001'::uuid) $$,
  'AI_USAGE_PLATFORM_HAS_NO_OWNER',
  'R-7 : payer=platform AVEC un porteur est refusé — notre dépense ne se met pas au compte d''une famille'
);

-- Deux lignes légitimes, une par payeur : l'élève 2 est servi par la clé du
-- porteur 1, et un appel plateforme ne sert personne en particulier.
SELECT ok(
  public.log_ai_usage(
    'family', 'anthropic', 'explain', 'claude-haiku-4-5', 'ok',
    'a9000000-0000-4000-8000-000000000002'::uuid,
    'a9000000-0000-4000-8000-000000000001'::uuid,
    120, 80, 0, 4200, NULL, 350
  ) > 0,
  'un appel famille complet s''écrit'
);

SELECT ok(
  public.log_ai_usage('platform', 'anthropic', 'digest_parent', 'claude-haiku-4-5', 'ok') > 0,
  'un appel plateforme s''écrit sans porteur'
);

-- ---------------------------------------------------------
-- 3. Les grants : personne ne fabrique une ligne de comptabilité depuis un client.
-- ---------------------------------------------------------
SELECT is_empty(
  $$ SELECT 1
       FROM information_schema.role_routine_grants
      WHERE routine_schema = 'public'
        AND routine_name   = 'log_ai_usage'
        AND grantee IN ('anon', 'authenticated', 'PUBLIC') $$,
  'log_ai_usage n''est EXECUTE-grantable ni pour anon, ni pour authenticated'
);

SELECT is_empty(
  $$ SELECT 1
       FROM information_schema.role_table_grants
      WHERE table_schema = 'public'
        AND table_name   = 'ai_usage_events'
        AND grantee IN ('anon', 'authenticated')
        AND privilege_type IN ('INSERT', 'UPDATE', 'DELETE') $$,
  'aucun droit d''écriture client sur ai_usage_events — la comptabilité n''est pas déclarative'
);

SELECT is_empty(
  $$ SELECT 1
       FROM information_schema.role_table_grants
      WHERE table_schema = 'public'
        AND table_name   = 'ai_usage_events'
        AND grantee = 'anon' $$,
  'un visiteur anonyme n''a aucun droit sur la comptabilité IA'
);

-- ---------------------------------------------------------
-- 4. R-14 — la ligne de partage est `credential_owner`, et elle tient sous RLS.
-- ---------------------------------------------------------

-- L'ÉLÈVE servi : il est `user_id` sur une ligne, et il ne doit RIEN voir. C'est
-- l'assertion centrale de R-14a — un enfant ne voit pas d'argent, même le sien.
SET LOCAL request.jwt.claims = '{"sub":"a9000000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.ai_usage_events),
  0,
  'R-14a : l''élève servi par la clé d''un autre ne lit AUCUNE ligne de dépense'
);

RESET ROLE;

-- LE PORTEUR : il voit sa dépense en entier (R-14b), et seulement la sienne.
SET LOCAL request.jwt.claims = '{"sub":"a9000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM public.ai_usage_events),
  1,
  'R-14b : le porteur de la clé voit sa dépense — une ligne, la sienne'
);

SELECT is(
  (SELECT payer FROM public.ai_usage_events),
  'family',
  'la ligne que le porteur voit est bien celle de sa clé'
);

-- La ligne plateforme n'appartient à personne : elle reste invisible côté client.
SELECT is(
  (SELECT count(*)::int FROM public.ai_usage_events WHERE payer = 'platform'),
  0,
  'la dépense plateforme n''est imputée à aucune famille'
);

-- Écrire directement, sans passer par la RPC : refusé par l'absence de GRANT.
SELECT throws_ok(
  $$ INSERT INTO public.ai_usage_events (payer, provider, feature, model, status)
     VALUES ('platform', 'anthropic', 'explain', 'm', 'ok') $$,
  '42501',
  'un client authentifié ne peut pas insérer une ligne de comptabilité'
);

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
