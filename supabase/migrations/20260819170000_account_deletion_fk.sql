-- =========================================================
-- Suppression de compte — ce que la base doit laisser partir, et ce qu'elle retient.
--
-- LE MANQUE. Depuis l'origine, aucun utilisateur ne peut supprimer son compte :
-- `deleteAccount` n'existe nulle part dans `src/`, et la politique de
-- confidentialité renvoie vers une adresse e-mail. C'est la moitié restante de
-- GAP-024 (STATUS.md §5), et le seul verrou légal qui soit du CODE.
--
-- CE QUE LA SUPPRESSION SERA. Un effacement DUR, immédiat : `auth.admin.deleteUser`
-- sur `auth.users`, et les 32 clés étrangères `ON DELETE CASCADE` déjà en place
-- emportent le reste en une transaction — profil, tentatives, séries, révisions
-- SM-2, badges, duels, liens parentaux, abonnements push. Le schéma était donc
-- déjà écrit pour ce geste. Cette migration ne l'invente pas : elle répare les
-- SIX colonnes qui l'auraient fait échouer ou l'auraient fait trop bien réussir.
--
-- D-1 — QUATRE FK ADMIN AURAIENT REFUSÉ LA SUPPRESSION. `content_reports.resolved_by`,
-- `bug_reports.resolved_by`, `beta_access_requests.reviewed_by` et
-- `parcours_entitlements.granted_by` ont été déclarées `REFERENCES auth.users(id)`
-- SANS `ON DELETE` — donc `NO ACTION`. Les quatre ne sont écrites que par des RPC
-- gardées par `is_admin()`, si bien que seul un compte ADMIN est concerné : mais il
-- l'est vraiment, et la panne serait opaque (violation de clé étrangère remontée en
-- 500 depuis une server fn, sur le geste le moins rattrapable de l'application).
-- Elles passent en `SET NULL` : qui a classé un signalement n'est pas une donnée
-- dont la disparition doit empêcher un départ.
--
-- D-2 — UN SIGNALEMENT SURVIT À SON AUTEUR. `content_reports.user_id` et
-- `bug_reports.user_id` étaient `NOT NULL ... ON DELETE CASCADE` : partir effaçait
-- ses propres signalements. Or une clé de réponse fausse reste fausse quand le
-- témoin s'en va — et le triage hebdomadaire (STATUS.md §5, `report-triage`)
-- perdrait le signal jusqu'à ce qu'un autre élève retrouve la même faute. Les deux
-- colonnes deviennent NULLABLE + `SET NULL` : le CORPS du signalement (« la réponse
-- B est fausse à la question 3 ») ne porte aucune identité, seul `user_id` en
-- portait une. L'effacement reste donc entier du point de vue de la personne.
--   ⚠️ Effet RLS voulu, et vérifié en pgTAP : la policy de lecture est
--   `user_id = auth.uid() OR is_admin()`. Avec `user_id` à NULL, le premier terme
--   vaut NULL — jamais vrai — donc un signalement orphelin n'est lisible que par un
--   admin. Et la policy d'insertion (`user_id = auth.uid()`) refuse NULL : personne
--   ne peut FABRIQUER un signalement anonyme, il ne peut que le DEVENIR.
--
-- D-3 — RIEN N'EST DÉTRUIT ICI. Migration purement additive au sens de la DoD §7 :
-- aucun DROP de table ni de colonne, aucun REVOKE. Elle précède le code qui s'en
-- sert, et peut vivre seule sur `main` sans rien changer au comportement actuel.
-- =========================================================

-- 1) Les six clés étrangères, reprises SANS supposer leur nom.
--
-- Elles ont été créées en ligne dans un `CREATE TABLE`, donc PostgreSQL les a
-- nommées lui-même. Un `DROP CONSTRAINT IF EXISTS <nom deviné>` qui se tromperait
-- de nom ne dirait rien et laisserait l'ancienne contrainte en place : la table se
-- retrouverait avec DEUX clés étrangères sur la même colonne, dont celle qui bloque
-- — un échec silencieux qui ne se verrait qu'au premier compte supprimé. On lit
-- donc le nom réel dans `pg_constraint` (même idiome qu'en
-- 20260603160000_beta_access_requests.sql), puis on repose une contrainte nommée.
DO $$
DECLARE
  rec RECORD;
  c   text;
BEGIN
  FOR rec IN
    SELECT * FROM (VALUES
      ('content_reports',       'user_id'),
      ('content_reports',       'resolved_by'),
      ('bug_reports',           'user_id'),
      ('bug_reports',           'resolved_by'),
      ('beta_access_requests',  'reviewed_by'),
      ('parcours_entitlements', 'granted_by')
    ) AS v(tbl, col)
  LOOP
    SELECT con.conname INTO c
    FROM pg_constraint con
    JOIN pg_attribute att
      ON att.attrelid = con.conrelid
     AND att.attnum   = con.conkey[1]
    WHERE con.conrelid  = format('public.%I', rec.tbl)::regclass
      AND con.contype   = 'f'
      AND con.confrelid = 'auth.users'::regclass
      AND array_length(con.conkey, 1) = 1
      AND att.attname   = rec.col;

    IF c IS NOT NULL THEN
      EXECUTE format('ALTER TABLE public.%I DROP CONSTRAINT %I', rec.tbl, c);
    END IF;

    -- Un SEUL littéral : deux chaînes adjacentes se concatènent bien en SQL, mais
    -- la règle exige un saut de ligne entre elles et ne survit pas au premier
    -- reformatage. Sur une migration qui s'applique toute seule en prod, ce n'est
    -- pas le genre de finesse dont on veut dépendre.
    EXECUTE format(
      'ALTER TABLE public.%I ADD CONSTRAINT %I FOREIGN KEY (%I) REFERENCES auth.users(id) ON DELETE SET NULL',
      rec.tbl, rec.tbl || '_' || rec.col || '_fkey', rec.col
    );
  END LOOP;
END $$;

-- 2) L'auteur d'un signalement devient facultatif (D-2).
--
-- `SET NULL` sur une colonne `NOT NULL` échouerait à la première suppression : les
-- deux moitiés de la décision sont ici, pas dans deux migrations.
ALTER TABLE public.content_reports ALTER COLUMN user_id DROP NOT NULL;
ALTER TABLE public.bug_reports     ALTER COLUMN user_id DROP NOT NULL;

COMMENT ON COLUMN public.content_reports.user_id IS
  'Auteur du signalement. NULL = compte supprimé depuis (le signalement survit, la personne non).';
COMMENT ON COLUMN public.bug_reports.user_id IS
  'Auteur du signalement. NULL = compte supprimé depuis (le signalement survit, la personne non).';
