-- =========================================================
-- S85 — client_errors : la boîte noire est verrouillée.
--
-- 20260831140000_client_errors_telemetry.sql crée une table intentionnellement
-- accessible UNIQUEMENT par la service role key : RLS activée, aucune policy,
-- REVOKE explicite sur PUBLIC/anon/authenticated.
--
-- Ce fichier honore la promesse du corps du commit #918 : « un test le nomme ».
-- Sans lui, ajouter une policy par erreur ouvrirait la table en silence —
-- exactement ce que le commentaire d'en-tête de la migration prévient.
--
-- Aucune fixture : on ne teste que le schéma et les droits, pas le contenu.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(8);

-- ---------------------------------------------------------
-- 1. Structure — les colonnes de diagnostic qui servent la requête d'analyse.
-- ---------------------------------------------------------
SELECT has_table('public', 'client_errors',
  'client_errors existe (20260831140000)');

SELECT has_column('public', 'client_errors', 'ttl_s',
  'ttl_s — discrimine expiration ordinaire (<=0) vs jeton valide refusé (>60)');

SELECT has_column('public', 'client_errors', 'last_hidden_ms',
  'last_hidden_ms — durée de la dernière veille, hypothèse gel minuteries mobiles');

-- ---------------------------------------------------------
-- 2. RLS activée — une policy ajoutée par erreur plus tard ne suffirait
--    pas à ouvrir la table si ce premier garde tient.
-- ---------------------------------------------------------
SELECT ok(
  (SELECT relrowsecurity FROM pg_class WHERE oid = 'public.client_errors'::regclass),
  'RLS est activée sur client_errors'
);

-- ---------------------------------------------------------
-- 3. Aucun privilège pour les rôles client — la boîte noire n'est lisible et
--    inscriptible que par la service role key.
--
--    Ces quatre assertions sont le « test qui nomme » promis dans le commit #918 :
--    si quelqu'un ajoute un GRANT ou une policy d'écriture par erreur, au moins
--    l'une d'elles passe de false à true et le pgTAP le détecte.
-- ---------------------------------------------------------
SELECT is(
  has_table_privilege('anon', 'public.client_errors', 'SELECT'),
  false,
  'anon ne peut pas lire client_errors — le diagnostic est réservé au service role'
);

SELECT is(
  has_table_privilege('anon', 'public.client_errors', 'INSERT'),
  false,
  'anon ne peut pas écrire dans client_errors'
);

SELECT is(
  has_table_privilege('authenticated', 'public.client_errors', 'SELECT'),
  false,
  'authenticated ne peut pas lire client_errors — pas de montants visibles côté élève'
);

SELECT is(
  has_table_privilege('authenticated', 'public.client_errors', 'INSERT'),
  false,
  'authenticated ne peut pas écrire directement dans client_errors'
);

SELECT * FROM finish();
ROLLBACK;
