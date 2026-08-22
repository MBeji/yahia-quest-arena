-- =========================================================
-- S62 — LE COFFRE : le test qui garde l'invariant central de l'étude 29.
--
-- L'étude 29 §5 le nomme comme LE test à écrire :
--     has_table_privilege('authenticated', 'ai_credentials', 'SELECT') = false
--
-- Pourquoi celui-là et pas un autre. La table porte des clés d'API de tiers,
-- chiffrées sous une clé maîtresse qui n'est pas en base. La défense en
-- profondeur tient à trois étages (§3.1) : le grant retiré, la RLS, et le
-- chiffrement enveloppe. Le premier étage est le seul qui rende les deux autres
-- superflus — et c'est aussi le seul qu'une migration future peut annuler d'une
-- ligne, sans que rien d'autre ne rougisse. D'où ce fichier.
--
-- Il vérifie aussi ce que le lot 2 a promis autour :
--   * R-2 telle que Q-2 l'a réécrite : AUCUN filtre de rôle. Un `student` peut
--     attacher sa propre clé — la contrepartie est un écran (niveau scolaire lu,
--     confirmation d'adulte), pas un CHECK. Le test l'affirme pour que personne
--     ne « rétablisse » le filtre que l'arbitrage a retiré ;
--   * R-20 : aucune ligne sans consentement versionné ;
--   * R-6, la part que la base juge seule : une base_url non-https est refusée ;
--   * D-3 : `get_ai_credential_status` ne rend NI le secret NI son empreinte ;
--   * US-8 : révoquer SUPPRIME la ligne, ne la marque pas ;
--   * R-2a : `get_my_grade_rank` rend le rang réel, et NULL quand il est inconnu.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(21);

-- ---------------------------------------------------------
-- Fixtures : un ÉLÈVE (Q-2 : il a le droit de porter une clé) et un parent.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at,
                        raw_user_meta_data, created_at, updated_at,
                        aud, role, instance_id)
VALUES
  ('b9000000-0000-4000-8000-000000000001', 'ai-vault-student@test.local', 'x', now(),
   '{"display_name":"Élève"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'),
  ('b9000000-0000-4000-8000-000000000002', 'ai-vault-parent@test.local', 'x', now(),
   '{"display_name":"Parent"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000')
ON CONFLICT (id) DO NOTHING;

UPDATE public.profiles SET role = 'student' WHERE id = 'b9000000-0000-4000-8000-000000000001';
UPDATE public.profiles SET role = 'parent'  WHERE id = 'b9000000-0000-4000-8000-000000000002';

-- ---------------------------------------------------------
-- 1. L'INVARIANT : aucun droit client, aucune policy.
-- ---------------------------------------------------------
SELECT has_table('public', 'ai_credentials', 'ai_credentials existe');

SELECT ok(
  NOT has_table_privilege('authenticated', 'public.ai_credentials', 'SELECT'),
  'R-4 : `authenticated` ne peut PAS lire ai_credentials — l''invariant central de l''étude'
);

SELECT ok(
  NOT has_table_privilege('anon', 'public.ai_credentials', 'SELECT'),
  'un visiteur anonyme ne peut pas lire ai_credentials'
);

SELECT is_empty(
  $$ SELECT 1
       FROM information_schema.role_table_grants
      WHERE table_schema = 'public'
        AND table_name   = 'ai_credentials'
        AND grantee IN ('anon', 'authenticated') $$,
  'aucun privilège d''AUCUNE sorte pour anon/authenticated — PostgREST ne peut pas atteindre la table'
);

SELECT is_empty(
  $$ SELECT policyname
       FROM pg_policies
      WHERE schemaname = 'public' AND tablename = 'ai_credentials' $$,
  'aucune policy : il n''y a rien à autoriser, le grant est retiré (§3.3)'
);

SELECT ok(
  (SELECT relrowsecurity FROM pg_class WHERE oid = 'public.ai_credentials'::regclass),
  'RLS est activée quand même — deuxième étage, au cas où un GRANT reviendrait'
);

SELECT ok(
  has_table_privilege('service_role', 'public.ai_credentials', 'SELECT'),
  'service_role, lui, y accède — c''est par lui que Node lit le chiffré'
);

-- ---------------------------------------------------------
-- 2. R-2 (réécrite par Q-2) : un ÉLÈVE peut attacher sa propre clé.
-- ---------------------------------------------------------
-- La v1 de l'étude filtrait sur le rôle ; l'arbitrage du 2026-08-20 l'a écarté.
-- Ce test affirme l'absence de filtre, pour que personne ne le « rétablisse » en
-- croyant corriger un oubli.
SELECT lives_ok(
  $$ SELECT public.set_ai_credential(
       'b9000000-0000-4000-8000-000000000001'::uuid, 'anthropic', NULL,
       'm-fast', 'm-rich', '\x00112233445566778899aabbccddeeff'::bytea, 1::smallint,
       'fp-student', 'aaaa', 2, 20, '2026-08-22') $$,
  'Q-2 : un compte `student` peut attacher SA propre clé — aucun filtre de rôle'
);

SELECT is(
  (SELECT status FROM public.ai_credentials WHERE owner_user_id = 'b9000000-0000-4000-8000-000000000001'),
  'active',
  'la clé vérifiée est enregistrée active'
);

-- ---------------------------------------------------------
-- 3. R-20 : pas de ligne sans consentement versionné.
-- ---------------------------------------------------------
SELECT throws_ok(
  $$ SELECT public.set_ai_credential(
       'b9000000-0000-4000-8000-000000000002'::uuid, 'anthropic', NULL,
       'm-fast', 'm-rich', '\x0011'::bytea, 1::smallint, 'fp-p', 'bbbb', 2, 20, '') $$,
  'AI_CRED_NO_CONSENT',
  'R-20 : le consentement versionné est exigé EN BASE, pas seulement à l''écran'
);

-- ---------------------------------------------------------
-- 4. R-6, la part que la base juge seule.
-- ---------------------------------------------------------
SELECT throws_ok(
  $$ SELECT public.set_ai_credential(
       'b9000000-0000-4000-8000-000000000002'::uuid, 'openai_compatible', 'http://api.example.com/v1',
       'm', 'm', '\x0011'::bytea, 1::smallint, 'fp', 'cccc', 2, 20, '2026-08-22') $$,
  'AI_HOST_NOT_ALLOWED',
  'R-6 : une adresse en http est refusée dès l''écriture'
);

SELECT throws_ok(
  $$ SELECT public.set_ai_credential(
       'b9000000-0000-4000-8000-000000000002'::uuid, 'anthropic', 'https://ailleurs.example.com',
       'm', 'm', '\x0011'::bytea, 1::smallint, 'fp', 'cccc', 2, 20, '2026-08-22') $$,
  'AI_HOST_NOT_ALLOWED',
  'une base_url sur le fournisseur Anthropic est refusée : son adresse est fixe (§3.5)'
);

-- ---------------------------------------------------------
-- 5. Les plafonds sont bornés PAR LA BASE, pas seulement par l'écran.
-- ---------------------------------------------------------
SELECT throws_ok(
  $$ INSERT INTO public.ai_credentials
       (owner_user_id, provider, model_fast, model_rich, secret_enc, key_fingerprint,
        last4, daily_budget_usd, monthly_budget_usd, consent_version)
     VALUES ('b9000000-0000-4000-8000-000000000002', 'anthropic', 'm', 'm',
             '\x0011'::bytea, 'fp', 'dddd', 999, 20, '2026-08-22') $$,
  '23514',
  'un plafond journalier hors bornes est refusé par un CHECK (R-11)'
);

-- ---------------------------------------------------------
-- 6. D-3 : la lecture ne rend NI le secret NI son empreinte.
-- ---------------------------------------------------------
SET LOCAL request.jwt.claims = '{"sub":"b9000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT last4 FROM public.get_ai_credential_status()),
  'aaaa',
  'le porteur lit `last4` — le seul fragment de clé qui existe en clair'
);

SELECT is(
  (SELECT count(*)::int
     FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name   = 'ai_credentials'
      AND column_name IN ('secret_enc', 'key_fingerprint')),
  2,
  'les deux colonnes sensibles existent bien (sinon l''assertion suivante serait vide de sens)'
);

-- Le contrat de sortie de la RPC : ni `secret_enc`, ni `key_fingerprint`.
SELECT is_empty(
  $$ SELECT p.proname
       FROM pg_proc p
       JOIN pg_namespace n ON n.oid = p.pronamespace
      WHERE n.nspname = 'public'
        AND p.proname = 'get_ai_credential_status'
        AND (array_to_string(p.proargnames, ',') LIKE '%secret_enc%'
          OR array_to_string(p.proargnames, ',') LIKE '%key_fingerprint%') $$,
  'D-3 : get_ai_credential_status ne rend ni le secret ni son empreinte'
);

SELECT throws_ok(
  $$ SELECT secret_enc FROM public.ai_credentials $$,
  '42501',
  'un client authentifié ne peut pas lire le chiffré directement'
);

-- ---------------------------------------------------------
-- 7. Chacun ne voit que SA ligne.
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL request.jwt.claims = '{"sub":"b9000000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is_empty(
  $$ SELECT last4 FROM public.get_ai_credential_status() $$,
  'un autre compte ne voit rien de la clé du premier'
);

-- ---------------------------------------------------------
-- 8. US-8 : révoquer SUPPRIME la ligne.
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL request.jwt.claims = '{"sub":"b9000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT ok(public.revoke_ai_credential(), 'la révocation rapporte qu''elle a agi');

RESET ROLE;
SELECT is_empty(
  $$ SELECT 1 FROM public.ai_credentials
      WHERE owner_user_id = 'b9000000-0000-4000-8000-000000000001' $$,
  'US-8 : la ligne est SUPPRIMÉE, pas marquée `revoked` — le chiffré ne survit pas'
);

-- Révoquer deux fois n'est pas une erreur : deux onglets ouverts suffisent.
SET LOCAL request.jwt.claims = '{"sub":"b9000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT ok(NOT public.revoke_ai_credential(), 'révoquer une clé absente rend `false`, sans lever');

-- ---------------------------------------------------------
-- 9. R-2a : le niveau scolaire, ou NULL — traité comme mineur par l'appelant.
-- ---------------------------------------------------------
SELECT is(
  public.get_my_grade_rank(),
  NULL,
  'R-2a : un compte sans parcours n''a pas de rang — l''appelant le traite comme mineur (§7)'
);

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;
