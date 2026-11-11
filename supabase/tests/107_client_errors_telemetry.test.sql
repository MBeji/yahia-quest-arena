-- =========================================================
-- S107 — client_errors : la boîte noire est verrouillée.
--
-- 20260831140000_client_errors_telemetry.sql crée une table intentionnellement
-- accessible UNIQUEMENT par la service role key : RLS activée, aucune policy,
-- REVOKE explicite sur PUBLIC/anon/authenticated.
--
-- Ce fichier honore la promesse du corps du commit #918 : « un test le nomme ».
-- Le verrou a DEUX moitiés, et chacune est nommée ici parce qu'aucune ne suffit
-- seule à rouvrir la table : une policy sans GRANT ne donne rien, un GRANT sans
-- policy non plus. C'est la seconde erreur, ajoutée à la première des mois plus
-- tard, qui ouvrirait la boîte noire en silence — donc on refuse la première.
--
-- Aucune fixture : on ne teste que le schéma et les droits, pas le contenu.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(11);

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
-- 2. Première moitié du verrou — RLS activée ET aucune policy : tout est
--    refusé, sauf la service role key, qui contourne RLS par définition.
-- ---------------------------------------------------------
SELECT ok(
  (SELECT relrowsecurity FROM pg_class WHERE oid = 'public.client_errors'::regclass),
  'RLS est activée sur client_errors'
);

-- Le refus total s'exprime par l'ABSENCE de policy : on l'affirme donc
-- explicitement, sinon en ajouter une passerait inaperçu.
SELECT is_empty(
  $$ SELECT policyname
       FROM pg_policies
      WHERE schemaname = 'public' AND tablename = 'client_errors' $$,
  'aucune policy RLS sur client_errors — refus total pour tout rôle client'
);

-- ---------------------------------------------------------
-- 3. Seconde moitié — aucun privilège pour les rôles client (REVOKE ALL) : la
--    boîte noire n'est lisible et inscriptible que par la service role key.
--    Un GRANT ajouté par erreur fait passer l'une de ces assertions à true.
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

SELECT ok(
  NOT (has_table_privilege('anon', 'public.client_errors', 'UPDATE')
    OR has_table_privilege('anon', 'public.client_errors', 'DELETE')),
  'anon ne peut ni modifier ni effacer une ligne de client_errors'
);

SELECT is(
  has_table_privilege('authenticated', 'public.client_errors', 'SELECT'),
  false,
  'authenticated ne peut pas lire client_errors — la télémétrie des autres ne se lit pas côté élève'
);

SELECT is(
  has_table_privilege('authenticated', 'public.client_errors', 'INSERT'),
  false,
  'authenticated ne peut pas écrire directement dans client_errors'
);

SELECT ok(
  NOT (has_table_privilege('authenticated', 'public.client_errors', 'UPDATE')
    OR has_table_privilege('authenticated', 'public.client_errors', 'DELETE')),
  'authenticated ne peut ni modifier ni effacer une ligne de client_errors'
);

SELECT * FROM finish();
ROLLBACK;
