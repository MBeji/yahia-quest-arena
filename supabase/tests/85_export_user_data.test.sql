-- =========================================================
-- Portabilité — le contrat que la base doit tenir quand un compte réclame ses données.
--
-- `export_user_data()` se dérive du CATALOGUE (voir 20260902120000_export_user_data.sql,
-- D-1) : elle exporte toute table de `public` portant une clé étrangère vers
-- `auth.users`. C'est ce qui la rend increvable — une table créée demain y entre
-- seule — et c'est exactement ce qui la rend intestable au typecheck : aucune
-- ligne de TypeScript ne sait ce que `pg_constraint` contient. Le contrat vit
-- donc ici, ou nulle part.
--
-- Trois familles d'assertions, et la première est la seule vraie garde :
--
--   1. LA COUVERTURE. Une colonne d'un nom jamais vu tombe en `unclassified` et
--      sort de l'export (fail-closed, D-3). C'est sûr, mais c'est une OMISSION —
--      et une omission silencieuse est précisément ce que l'export ne doit pas
--      être. Le test 1 est le seul endroit du dépôt qui la fait crier : il
--      échoue tant qu'une colonne reste non classée. Le correctif est une ligne
--      dans `user_data_export_plan()`.
--
--   2. LA SYMÉTRIE AVEC LA SUPPRESSION. Ce que `deleteAccount` efface, l'export
--      doit le rendre — c'est la même personne, décrite par les mêmes lignes.
--      Le test 3 le vérifie table par table, contre `confdeltype = 'c'`, c'est-à-dire
--      contre la MÊME source que le pgTAP 60. Les deux droits de GAP-024 ne
--      peuvent plus diverger sans qu'un test le dise.
--
--   3. LE COMPORTEMENT. Mes lignes, pas celles du voisin ; les secrets caviardés ;
--      aucun document pour qui n'a pas de session.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(22);

-- ---------------------------------------------------------
-- 1. La couverture — la garde qui rend l'omission bruyante.
-- ---------------------------------------------------------
SELECT is(
  (SELECT count(*)::int FROM public.user_data_export_plan() p
    WHERE p.disposition = 'unclassified'),
  0,
  'aucune colonne pointant vers auth.users ne reste non classée — sinon l''export l''omet en silence'
);

-- Une entrée périmée de la liste de caviardage serait l'échec inverse : elle
-- prétendrait masquer un secret que la table ne porte plus, et le document
-- annoncerait une protection qui ne s'applique à rien.
SELECT is(
  (SELECT count(*)::int
     FROM public.user_data_export_redactions() r
    WHERE NOT EXISTS (
      SELECT 1 FROM information_schema.columns c
       WHERE c.table_schema = 'public'
         AND c.table_name   = r.table_name
         AND c.column_name  = r.column_name)),
  0,
  'la liste de caviardage ne nomme que des colonnes qui existent encore'
);

-- ---------------------------------------------------------
-- 2. La symétrie : ce que la suppression emporte, l'export doit le rendre.
-- ---------------------------------------------------------
SELECT is(
  (SELECT count(*)::int FROM (
     SELECT rel.relname::text AS t
       FROM pg_constraint con
       JOIN pg_class     rel ON rel.oid = con.conrelid
       JOIN pg_namespace nsp ON nsp.oid = rel.relnamespace
      WHERE con.contype    = 'f'
        AND con.confrelid  = 'auth.users'::regclass
        AND con.confdeltype = 'c'          -- CASCADE : la ligne part avec le compte
        AND nsp.nspname    = 'public'
        AND rel.relkind    = 'r'
        AND array_length(con.conkey, 1) = 1
     EXCEPT
     SELECT p.table_name FROM public.user_data_export_plan() p
      WHERE p.disposition = 'subject'
   ) manquantes),
  0,
  'toute table que la suppression EFFACE est une table que l''export REND — les deux droits de GAP-024 restent alignés'
);

-- Et la contrepartie, sur les deux colonnes qui ont motivé le classement : elles
-- décrivent l'action d'un ADMIN sur la ligne de quelqu'un d'autre. Si l'une
-- passait « sujet », un administrateur recevrait dans son propre export le nom et
-- l'adresse en clair des demandeurs qu'il a instruits (§3.5 de l'inventaire INPDP).
SELECT is(
  (SELECT p.disposition FROM public.user_data_export_plan() p
    WHERE p.table_name = 'beta_access_requests' AND p.column_name = 'reviewed_by'),
  'attribution',
  'beta_access_requests.reviewed_by reste « attribution » — la demande d''un autre n''est pas la donnée de l''admin'
);
SELECT is(
  (SELECT p.disposition FROM public.user_data_export_plan() p
    WHERE p.table_name = 'bug_reports' AND p.column_name = 'resolved_by'),
  'attribution',
  'bug_reports.resolved_by reste « attribution » — le signalement d''un autre n''est pas la donnée de l''admin'
);

-- Le secret nommé par D-4 doit rester couvert : c'est la clé d'API d'une famille.
SELECT ok(
  EXISTS (SELECT 1 FROM public.user_data_export_redactions() r
           WHERE r.table_name = 'ai_credentials' AND r.column_name = 'secret_enc'),
  'ai_credentials.secret_enc est caviardée — un export voyage, une clé d''API ne doit pas voyager avec'
);

-- ---------------------------------------------------------
-- 3. Les droits. La fonction lit `auth.users` en SECURITY DEFINER : elle
--    n'existe que pour une session, et sa plomberie n'existe pour personne.
-- ---------------------------------------------------------
SELECT ok(
  NOT has_function_privilege('anon', 'public.export_user_data()', 'EXECUTE'),
  'anon ne peut pas exporter — il n''y a personne à exporter'
);
SELECT ok(
  has_function_privilege('authenticated', 'public.export_user_data()', 'EXECUTE'),
  'authenticated peut exporter ses propres données'
);
SELECT ok(
  NOT has_function_privilege('authenticated', 'public.user_data_export_plan()', 'EXECUTE'),
  'le plan reste interne — il décrit le schéma, pas une donnée'
);

-- ---------------------------------------------------------
-- 4. Sans session, pas de document — et surtout pas un document VIDE.
--    Un « {} » se lirait « tu n'as rien chez nous », la seule réponse fausse
--    que cette fonction puisse rendre.
-- ---------------------------------------------------------
SELECT throws_ok(
  'SELECT public.export_user_data()',
  '28000',
  NULL,
  'sans session, l''export refuse au lieu de rendre un document vide'
);

-- ---------------------------------------------------------
-- 5. Les fixtures : un élève (A) et un pair (B), plus une tentative chacun.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('e5000000-0000-0000-0000-00000000000a', 'export-eleve@test.local'),
  ('e5000000-0000-0000-0000-00000000000b', 'export-pair@test.local');

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('exp-subj', 'Export Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('e5000000-0000-0000-0000-00000000000c', 'exp-subj', 'Export Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward)
VALUES ('e5000000-0000-0000-0000-00000000000e',
        'e5000000-0000-0000-0000-00000000000c', 'exp-subj', 'Export Exercise', 50);

INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned)
VALUES ('e5000000-0000-0000-0000-00000000000a', 'e5000000-0000-0000-0000-00000000000e',
        'exp-subj', 5, 5, 100, 120, 50),
       ('e5000000-0000-0000-0000-00000000000b', 'e5000000-0000-0000-0000-00000000000e',
        'exp-subj', 1, 5, 20, 300, 10);

-- Un abonnement push : c'est lui qui porte les deux clés caviardées de D-4, et
-- ses fixtures tiennent en quatre colonnes (contrairement à `ai_credentials`,
-- dont le contrat de chiffrement est vérifié par le pgTAP 62).
INSERT INTO public.push_subscriptions (user_id, endpoint, p256dh, auth, user_agent)
VALUES ('e5000000-0000-0000-0000-00000000000a',
        'https://push.test.local/export-fixture', 'CLE-PUBLIQUE', 'CLE-AUTH', 'Firefox');

-- ---------------------------------------------------------
-- 6. Le document, pris UNE fois sous l'identité de A.
--    `auth.uid()` lit le réglage de session, pas le rôle Postgres : on peut donc
--    le prendre en propriétaire, et vérifier séparément (§3) que le rôle
--    `authenticated` y a bien droit — ce que le §7 rejoue pour de vrai.
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"e5000000-0000-0000-0000-00000000000a","role":"authenticated"}';

CREATE TEMP TABLE export_snapshot ON COMMIT DROP AS
  SELECT public.export_user_data() AS doc;

SELECT is(
  (SELECT doc -> 'account' ->> 'email' FROM export_snapshot),
  'export-eleve@test.local',
  'le document porte l''adresse du compte — elle vit dans auth.users, pas dans profiles'
);

SELECT is(
  (SELECT (doc ->> 'format_version')::int FROM export_snapshot),
  1,
  'le document porte un numéro de format — un fichier déposé chez un tiers survit à l''app'
);

SELECT is(
  (SELECT jsonb_array_length(doc -> 'tables' -> 'attempts') FROM export_snapshot),
  1,
  'l''export rend MA tentative, et une seule — celle du pair n''y est pas'
);

SELECT is(
  (SELECT doc -> 'tables' -> 'attempts' -> 0 ->> 'user_id' FROM export_snapshot),
  'e5000000-0000-0000-0000-00000000000a',
  'la tentative rendue est bien la mienne'
);

SELECT is(
  (SELECT doc -> 'tables' -> 'profiles' -> 0 ->> 'id' FROM export_snapshot),
  'e5000000-0000-0000-0000-00000000000a',
  'le profil rendu est le mien — profiles.id EST le compte'
);

-- Toutes les tables du plan figurent, même vides : « nous avons regardé ici et il
-- n'y avait rien » est une information. Un tableau absent laisserait croire qu'on
-- n'a pas cherché.
SELECT is(
  (SELECT count(*)::int FROM export_snapshot, jsonb_object_keys(doc -> 'tables')),
  (SELECT count(DISTINCT p.table_name)::int FROM public.user_data_export_plan() p
    WHERE p.disposition = 'subject'),
  'chaque table du plan est présente au document, même quand elle est vide'
);

-- ---------------------------------------------------------
-- 7. Le caviardage : les deux clés du canal de notification sortent masquées,
--    et RIEN d'autre dans la ligne n'est touché.
-- ---------------------------------------------------------
SELECT is(
  (SELECT doc -> 'tables' -> 'push_subscriptions' -> 0 ->> 'auth' FROM export_snapshot),
  '__redacted__',
  'push_subscriptions.auth sort masquée — sa seule utilité est d''agir EN TANT QUE moi'
);
SELECT is(
  (SELECT doc -> 'tables' -> 'push_subscriptions' -> 0 ->> 'p256dh' FROM export_snapshot),
  '__redacted__',
  'push_subscriptions.p256dh sort masquée'
);
SELECT is(
  (SELECT doc -> 'tables' -> 'push_subscriptions' -> 0 ->> 'endpoint' FROM export_snapshot),
  'https://push.test.local/export-fixture',
  'le caviardage ne déborde pas — le reste de la ligne sort intact'
);
-- Masquée, pas RETIRÉE : une clé absente se lirait « cette colonne n'existe pas ».
SELECT ok(
  (SELECT doc -> 'tables' -> 'push_subscriptions' -> 0 ? 'auth' FROM export_snapshot),
  'la colonne masquée est toujours LÀ — remplacée, jamais retirée'
);

-- Le document dit ses propres limites : sans ce bloc, il se présenterait comme
-- exhaustif et l'omission la plus intéressante serait l'invisible.
SELECT ok(
  (SELECT jsonb_array_length(doc -> 'not_exported') > 0 FROM export_snapshot),
  'le document NOMME ce qu''il n''exporte pas, avec le motif'
);

-- ---------------------------------------------------------
-- 8. Et pour de vrai : sous le rôle `authenticated`, avec le seul jeton.
-- ---------------------------------------------------------
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT public.export_user_data() -> 'account' ->> 'id'),
  'e5000000-0000-0000-0000-00000000000a',
  'un authenticated ordinaire exporte — et n''exporte que lui-même'
);

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
