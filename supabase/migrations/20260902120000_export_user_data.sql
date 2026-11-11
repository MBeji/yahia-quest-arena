-- =========================================================
-- Portabilité — `export_user_data`, le dernier volet CODE de GAP-024.
--
-- LE MANQUE. La politique de confidentialité annonce « un droit d'accès, de
-- rectification et de suppression ». Deux des trois sont tenus depuis le dépôt :
-- les pages légales (#701) et la suppression de compte (#791). Le troisième
-- renvoie encore à `contact@na9ranal3ab.tn` — c'est-à-dire à un geste humain, sur
-- une boîte que personne ne relève. Zéro occurrence de `export_user_data`,
-- `exportUserData` ou « portabilité » dans `src/` et `supabase/migrations/` au
-- 2026-09-02. C'est le rang 1 de la ROADMAP privée (F1), et le seul verrou légal
-- du lancement qu'un agent puisse lever seul.
--
-- ---------------------------------------------------------
-- D-1 — L'EXPORT SE DÉRIVE DU CATALOGUE, IL NE SE RÉCITE PAS.
-- ---------------------------------------------------------
-- La suppression a déjà tranché cette question, et son argument vaut mot pour mot
-- ici : « une boucle applicative oublierait la prochaine table ajoutée au schéma,
-- alors que la clé étrangère, elle, est écrite au moment où la table naît »
-- (20260819170000_account_deletion_fk.sql). Une liste de tables écrite à la main
-- serait vraie le jour de sa PR et fausse à la suivante — et surtout, elle serait
-- fausse EN SILENCE : un export incomplet ressemble trait pour trait à un export
-- complet. C'est exactement le mécanisme L-2 de la ROADMAP (« une garde qui
-- échoue est indistinguable d'une garde qui passe »), et le dépôt l'a déjà payé
-- quatre fois.
--
-- Donc l'export énumère `pg_constraint` : toute table de `public` portant une clé
-- étrangère mono-colonne vers `auth.users(id)` est un endroit où l'utilisateur
-- existe. **Une table créée demain avec un `user_id` entre dans l'export sans que
-- personne n'y pense.** C'est la propriété qui justifie tout le reste du fichier.
--
-- ---------------------------------------------------------
-- D-2 — TOUTES LES COLONNES NE DÉSIGNENT PAS LA MÊME PERSONNE.
-- ---------------------------------------------------------
-- Le catalogue seul ne suffit pas, et le contre-exemple est concret :
-- `beta_access_requests.reviewed_by` pointe vers l'ADMIN qui a instruit la
-- demande — pas vers son auteur. Exporter « les lignes où je suis cité » y
-- rendrait à un administrateur **le nom et l'adresse en clair d'autres
-- personnes** (§3.5 de l'inventaire INPDP : c'est la seule table applicative
-- portant de l'état civil). Une portabilité qui fuit chez le voisin n'est pas une
-- portabilité.
--
-- Deux familles, donc, classées PAR NOM DE COLONNE :
--   • SUJET       — la ligne parle de cette personne. Exportée.
--   • ATTRIBUTION — la personne a agi SUR la ligne de quelqu'un d'autre
--                   (« qui a classé ce signalement », « qui a décerné ce badge »).
--                   Pas exportée : la ligne n'est pas la sienne.
--
-- Le classement porte sur le NOM, pas sur le couple (table, colonne), et c'est
-- délibéré : c'est ce qui fait qu'une table neuve nommée selon la convention du
-- dépôt est traitée correctement sans qu'on la déclare. Ce que le nom ne dit pas
-- tombe en `unclassified`.
--
-- ⚠️ Ce classement choisit des LIGNES, pas des cellules. Dans une ligne qui EST
-- la sienne, l'utilisateur reçoit aussi les colonnes d'attribution — le
-- `resolved_by` de son propre signalement, par exemple. C'est voulu : la RLS
-- (`user_id = auth.uid() OR is_admin()`) la lui rend déjà dans l'application, et
-- masquer ici ce que l'écran affiche là-bas poserait une SECONDE politique
-- d'accès, plus stricte, vivant à un seul endroit — c'est-à-dire deux règles
-- tenues à la main qui divergeront (le motif que l'AGENTS.md nomme pour les
-- refus d'auth). L'export rend ce que l'application rend, pas moins.
--
-- ---------------------------------------------------------
-- D-3 — L'INCONNU SORT DE L'EXPORT, ET IL ALLUME LA GARDE.
-- ---------------------------------------------------------
-- Une colonne d'un nom jamais vu ne peut pas être devinée. Deux erreurs possibles,
-- et elles ne se valent pas : sous-exporter est une omission qui se rattrape à la
-- PR suivante ; sur-exporter est une divulgation qu'aucun revert ne rattrape. Donc
-- **fail-closed** : `unclassified` n'est PAS exporté, il est NOMMÉ dans le
-- document (§ `not_exported`), et le pgTAP 85 échoue tant qu'il en reste un. La
-- garde est rouge, l'export reste sûr, et le correctif est une ligne dans la liste
-- ci-dessous.
--
-- ---------------------------------------------------------
-- D-4 — QUATRE COLONNES SONT DES SECRETS, PAS DES DONNÉES.
-- ---------------------------------------------------------
-- `ai_credentials.secret_enc` (la clé d'API d'une famille, chiffrée) et son
-- `key_fingerprint`, `push_subscriptions.auth` et `p256dh` (les clés de
-- chiffrement du canal de notification). Aucune des quatre ne dit quoi que ce soit
-- SUR la personne ; leur seul usage est d'agir EN TANT QUE elle. Un fichier
-- d'export a vocation à être partagé, transmis, déposé chez un tiers — y mettre
-- ces quatre-là transformerait un droit en vecteur. Elles sortent remplacées par
-- `"__redacted__"`, et le document dit lesquelles et pourquoi : une valeur retirée
-- en silence serait un mensonge de plus.
--
-- ---------------------------------------------------------
-- D-5 — L'ADRESSE E-MAIL N'EST PAS DANS `public`.
-- ---------------------------------------------------------
-- `profiles` ne porte ni adresse, ni nom réel (§3.1 de l'inventaire) : l'identité
-- vit dans `auth.users`. Un export qui ne rendrait que `public` omettrait la seule
-- donnée que l'utilisateur reconnaît. D'où `SECURITY DEFINER` — un rôle
-- `authenticated` ne lit pas `auth.users` — et d'où le bloc `account`.
--
-- SÉCURITÉ. La fonction ne prend AUCUN paramètre, et c'est le garde-fou principal :
-- rien en entrée ne désigne une personne, donc rien ne peut en faire une arme
-- (« exporte les données de quelqu'un d'autre »). Le sujet est `auth.uid()`, lu
-- dans le jeton vérifié — même posture que `deleteAccount`. Sans session, elle
-- refuse plutôt que de rendre un document vide, qui se lirait « tu n'as rien ».
--
-- D-6 — MIGRATION PUREMENT ADDITIVE (DoD §7) : aucun DROP, aucun REVOKE sur
-- l'existant, aucune table touchée. Elle précède le code qui s'en sert et peut
-- vivre seule sur `main` sans rien changer au comportement actuel.
-- =========================================================

-- ---------------------------------------------------------
-- 1. Le PLAN — qui est exporté, qui ne l'est pas, et pourquoi.
--
-- Cette fonction est le cœur du fichier : elle est à la fois ce que l'export
-- consomme et ce que le pgTAP interroge. Une seule liste, donc, impossible à
-- désynchroniser d'elle-même — le piège des « deux listes tenues à la main » que
-- l'AGENTS.md nomme déjà pour les refus d'auth.
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION public.user_data_export_plan()
RETURNS TABLE (
  table_name  TEXT,
  column_name TEXT,
  disposition TEXT,  -- subject | attribution | unclassified
  reason      TEXT
)
LANGUAGE sql
STABLE
SET search_path = public
AS $$
  WITH fk AS (
    -- Toute FK mono-colonne de `public` vers `auth.users(id)`. `conkey[1]` avec le
    -- garde `array_length = 1` : une FK composite n'existe pas ici, et si elle
    -- naissait un jour, la lire par sa première colonne serait faux — mieux vaut
    -- qu'elle n'apparaisse pas du tout et que la couverture du pgTAP la réclame.
    SELECT rel.relname::text AS table_name,
           att.attname::text AS column_name
      FROM pg_constraint con
      JOIN pg_class      rel ON rel.oid = con.conrelid
      JOIN pg_namespace  nsp ON nsp.oid = rel.relnamespace
      JOIN pg_attribute  att ON att.attrelid = con.conrelid AND att.attnum = con.conkey[1]
     WHERE con.contype   = 'f'
       AND con.confrelid = to_regclass('auth.users')
       AND array_length(con.conkey, 1) = 1
       AND nsp.nspname   = 'public'
       AND rel.relkind   = 'r'
  ),
  -- Le classement. Ajouter une ligne ici est le geste qui répare une garde rouge.
  known(column_name, disposition, reason) AS (
    VALUES
      -- SUJET — la ligne parle de cette personne.
      ('id',                  'subject', 'profiles.id : le profil EST le compte'),
      ('user_id',             'subject', 'le porteur de la ligne'),
      ('student_user_id',     'subject', 'l''élève décrit par la ligne'),
      ('parent_user_id',      'subject', 'le parent décrit par la ligne'),
      ('owner_user_id',       'subject', 'le porteur du dispositif (clé, budget, forge)'),
      ('target_student_id',   'subject', 'l''élève visé par un contenu ou un devoir'),
      ('credential_owner',    'subject', 'le payeur de l''appel — sa dépense, sa donnée'),
      ('assigned_by_user_id', 'subject', 'le parent qui a assigné : son geste, sa donnée'),
      ('created_by',          'subject', 'l''auteur du contenu — la policy d''écriture le dit déjà'),
      -- ATTRIBUTION — la personne a agi sur la ligne de quelqu'un d'autre.
      ('resolved_by',  'attribution', 'qui a classé le signalement d''un autre'),
      ('reviewed_by',  'attribution', 'qui a instruit la demande d''un autre'),
      ('granted_by',   'attribution', 'qui a octroyé le droit d''un autre'),
      ('awarded_by',   'attribution', 'qui a décerné le badge d''un autre')
  )
  SELECT fk.table_name,
         fk.column_name,
         COALESCE(k.disposition, 'unclassified'),
         COALESCE(
           k.reason,
           'colonne inconnue du classement — exclue par prudence, voir D-3'
         )
    FROM fk
    LEFT JOIN known k ON k.column_name = fk.column_name
   ORDER BY fk.table_name, fk.column_name;
$$;

COMMENT ON FUNCTION public.user_data_export_plan() IS
  'GAP-024 : quelles colonnes désignent le SUJET d''une ligne. Dérivé de pg_constraint — une table neuve y entre seule. Consommé par export_user_data(), vérifié par le pgTAP 85.';

-- ---------------------------------------------------------
-- 2. Les SECRETS, nommés une fois (D-4).
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION public.user_data_export_redactions()
RETURNS TABLE (table_name TEXT, column_name TEXT, reason TEXT)
LANGUAGE sql
IMMUTABLE
SET search_path = public
AS $$
  VALUES
    ('ai_credentials',     'secret_enc',
     'clé d''API de la famille (chiffrée) — un secret, pas une donnée personnelle'),
    ('ai_credentials',     'key_fingerprint',
     'empreinte HMAC de cette même clé — elle sert à la reconnaître'),
    ('push_subscriptions', 'auth',
     'clé de chiffrement du canal de notification de cet appareil'),
    ('push_subscriptions', 'p256dh',
     'clé publique de chiffrement du canal de notification de cet appareil');
$$;

COMMENT ON FUNCTION public.user_data_export_redactions() IS
  'GAP-024 D-4 : les colonnes dont la valeur sort en "__redacted__". Leur seul usage est d''agir EN TANT QUE la personne, jamais de la décrire.';

-- ---------------------------------------------------------
-- 3. Le caviardage lui-même — une ligne JSON, des colonnes à masquer.
--
-- On REMPLACE plutôt qu'on ne RETIRE : une clé absente se lit « cette colonne
-- n'existe pas », une clé à `"__redacted__"` se lit « elle existe et on ne te la
-- rend pas ». La deuxième est vraie, la première ne l'est pas. Le `p_row ? c`
-- garde la fonction honnête dans l'autre sens : elle n'invente jamais une colonne
-- que la table ne porte pas — une entrée périmée de la liste ci-dessus ne
-- fabriquerait donc pas un faux champ (le pgTAP 85 la réclame par ailleurs).
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION public.user_data_export_redact(p_row JSONB, p_columns TEXT[])
RETURNS JSONB
LANGUAGE sql
IMMUTABLE
SET search_path = public
AS $$
  SELECT CASE
    WHEN p_columns IS NULL OR cardinality(p_columns) = 0 THEN p_row
    ELSE p_row || COALESCE(
      (SELECT jsonb_object_agg(c, to_jsonb('__redacted__'::text))
         FROM unnest(p_columns) AS c
        WHERE p_row ? c),
      '{}'::jsonb)
  END;
$$;

COMMENT ON FUNCTION public.user_data_export_redact(JSONB, TEXT[]) IS
  'GAP-024 D-4 : masque des colonnes d''une ligne exportée en les REMPLAÇANT par "__redacted__" — jamais en les retirant.';

-- ---------------------------------------------------------
-- 4. L'EXPORT.
--
-- Un seul document JSON, complet et sans pagination — délibérément. Un export
-- tronqué en silence serait pire qu'absent : il donnerait à son porteur la
-- certitude d'avoir tout. Le volume réel est borné par la vie d'un élève (quelques
-- milliers de tentatives au plus), très loin des 255 Mo d'un JSONB.
--
-- Toutes les tables du plan figurent au document, MÊME VIDES. « Nous avons
-- regardé ici et il n'y avait rien » est une information ; un tableau absent
-- laisserait croire qu'on n'a pas cherché.
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION public.export_user_data()
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_uid     UUID := auth.uid();
  v_tables  JSONB := '{}'::jsonb;
  v_account JSONB;
  v_rec     RECORD;
  v_where   TEXT;
  v_redact  TEXT[];
  v_rows    JSONB;
BEGIN
  IF v_uid IS NULL THEN
    -- Refuser plutôt que rendre un document vide : « {} » se lirait « tu n'as
    -- rien chez nous », qui est la seule réponse fausse que cette fonction
    -- puisse donner.
    RAISE EXCEPTION 'export_user_data: aucune session'
      USING ERRCODE = '28000';
  END IF;

  -- Le bloc identité (D-5). `raw_user_meta_data` porte le pseudo et le rôle
  -- choisis à l'inscription, et pour un compte Google ce que le fournisseur a
  -- transmis : c'est de la donnée personnelle stockée, elle doit sortir.
  -- `raw_app_meta_data` n'en sort QUE la liste des fournisseurs — le reste est de
  -- la plomberie Supabase, pas de la donnée sur la personne.
  SELECT jsonb_build_object(
           'id',                 u.id,
           'email',              u.email,
           'created_at',         u.created_at,
           'last_sign_in_at',    u.last_sign_in_at,
           'email_confirmed_at', u.email_confirmed_at,
           'providers',          COALESCE(u.raw_app_meta_data -> 'providers', '[]'::jsonb),
           'metadata',           COALESCE(u.raw_user_meta_data, '{}'::jsonb)
         )
    INTO v_account
    FROM auth.users u
   WHERE u.id = v_uid;

  FOR v_rec IN
    SELECT p.table_name,
           array_agg(p.column_name ORDER BY p.column_name) AS columns
      FROM public.user_data_export_plan() p
     WHERE p.disposition = 'subject'
     GROUP BY p.table_name
     ORDER BY p.table_name
  LOOP
    -- Une table peut désigner la personne par PLUSIEURS colonnes
    -- (`parent_student_links` la nomme parent ou élève, `ai_forged_quizzes`
    -- porteur ou élève). Les manquer serait rendre la moitié d'un lien.
    SELECT string_agg(format('t.%I = $1', c), ' OR ')
      INTO v_where
      FROM unnest(v_rec.columns) AS c;

    SELECT COALESCE(array_agg(r.column_name), '{}'::text[])
      INTO v_redact
      FROM public.user_data_export_redactions() r
     WHERE r.table_name = v_rec.table_name;

    -- `%I` sur chaque identifiant : ils viennent du catalogue, donc d'un schéma
    -- déjà appliqué, mais une interpolation nue ici serait une injection en
    -- attente du jour où cette boucle lira autre chose.
    EXECUTE format(
      'SELECT COALESCE(jsonb_agg(x ORDER BY x), ''[]''::jsonb) FROM ('
      || 'SELECT public.user_data_export_redact(to_jsonb(t), %L::text[]) AS x '
      || 'FROM public.%I t WHERE %s) s',
      v_redact, v_rec.table_name, v_where
    )
    INTO v_rows
    USING v_uid;

    v_tables := v_tables || jsonb_build_object(v_rec.table_name, v_rows);
  END LOOP;

  RETURN jsonb_build_object(
    -- Un numéro de format, parce qu'un fichier déposé chez un tiers survit à
    -- l'application qui l'a produit.
    'format_version', 1,
    'generated_at',   to_char(now() AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS"Z"'),
    'account',        COALESCE(v_account, '{}'::jsonb),
    'tables',         v_tables,
    -- Le document dit ses propres limites. Sans ces deux blocs, il se présenterait
    -- comme exhaustif, et l'omission la plus intéressante serait l'invisible.
    'redacted', COALESCE(
      (SELECT jsonb_agg(jsonb_build_object(
                'table', r.table_name, 'column', r.column_name, 'reason', r.reason)
              ORDER BY r.table_name, r.column_name)
         FROM public.user_data_export_redactions() r), '[]'::jsonb),
    'not_exported', COALESCE(
      (SELECT jsonb_agg(jsonb_build_object(
                'table', p.table_name, 'column', p.column_name,
                'disposition', p.disposition, 'reason', p.reason)
              ORDER BY p.table_name, p.column_name)
         FROM public.user_data_export_plan() p
        WHERE p.disposition <> 'subject'), '[]'::jsonb)
  );
END;
$$;

COMMENT ON FUNCTION public.export_user_data() IS
  'GAP-024 / portabilité : rend à l''appelant TOUT ce que la base sait de lui, en un document JSON. Aucun paramètre — le sujet est auth.uid(), jamais une entrée.';

-- ---------------------------------------------------------
-- 5. Les droits.
--
-- `export_user_data` est `SECURITY DEFINER` et lit `auth.users` : elle ne doit
-- exister que pour une session. Les trois autres sont sa plomberie — elles
-- décrivent le SCHÉMA, pas des données, et personne n'a besoin de les appeler
-- depuis l'extérieur. Le pgTAP, lui, tourne en propriétaire.
-- ---------------------------------------------------------
REVOKE ALL ON FUNCTION public.user_data_export_plan()                  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.user_data_export_redactions()            FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.user_data_export_redact(JSONB, TEXT[])   FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.export_user_data()                       FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.export_user_data()                    TO authenticated;
