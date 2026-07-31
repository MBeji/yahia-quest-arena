-- =========================================================
-- Étude 04 — amendement A1.2, lot A1.2b : le vocabulaire des erreurs en base.
-- ---------------------------------------------------------
-- `get_attempt_review` rend un TAG (A1.2a) ; cette table porte la phrase que
-- l'élève lit. Elle suit le canal des libellés de COMPÉTENCES (é07), et ce
-- fichier vérifie qu'elle en a aussi les garanties :
--
--   1. l'élève connecté LIT le vocabulaire — sinon la correction reste muette ;
--   2. `anon` n'y a AUCUN droit — la correction vit derrière l'auth ;
--   3. personne n'ÉCRIT hors du propriétaire : pas de politique d'écriture, donc
--      un client authentifié ne peut ni insérer, ni modifier, ni supprimer un
--      libellé. Un élève qui réécrirait « ton erreur » chez les autres serait un
--      défaut d'intégrité, pas une fantaisie ;
--   4. le tag est la clé — deux entrées pour un même tag sont impossibles.
--
-- ⚠️ Le GRANT explicite n'est pas décoratif : sans lui, la table marche en cloud
-- et casse cette suite sur une base VIERGE (piège documenté dans CLAUDE.md).
--
-- Espace de noms des fixtures : préfixe `a12b.` sur les tags, inutilisé ailleurs.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(11);

-- =========================================================
-- 1–3. La forme. La clé primaire n'est PAS asserée sur le catalogue mais par le
-- comportement (assertion 8) : ce qui compte est qu'un doublon soit refusé, pas
-- le nom de la contrainte qui le refuse.
-- =========================================================
SELECT has_column('public', 'misconceptions', 'tag',
  'le vocabulaire porte le tag — l''identité déjà utilisée par distractor_tags');
SELECT has_column('public', 'misconceptions', 'subject',
  'et la matière qui le déclare');
SELECT has_column('public', 'misconceptions', 'label_ar',
  'les trois langues sont là (ar, la plus facile à oublier)');

-- =========================================================
-- 4–7. Les droits. C'est ici que se joue la différence entre « marche en cloud »
-- et « se reconstruit sur une base vierge ».
-- =========================================================
SELECT is(
  has_table_privilege('authenticated', 'public.misconceptions', 'SELECT'),
  true, 'authenticated LIT le vocabulaire — sinon la correction reste muette');

SELECT is(
  has_table_privilege('anon', 'public.misconceptions', 'SELECT'),
  false, 'anon ne lit rien — la correction vit derrière l''auth');

SELECT is(
  has_table_privilege('authenticated', 'public.misconceptions', 'INSERT'),
  false, 'authenticated n''écrit pas : le vocabulaire vient du SQL compilé');

SELECT is(
  has_table_privilege('authenticated', 'public.misconceptions', 'UPDATE'),
  false, 'authenticated ne réécrit pas un libellé chez les autres');

-- =========================================================
-- Fixtures (en propriétaire, comme le fait le SQL de contenu).
-- =========================================================
INSERT INTO public.misconceptions (tag, subject, label_fr, label_en, label_ar) VALUES
  ('a12b.frac.add-denominators', 'math',
   'Tu additionnes les dénominateurs', 'You add the denominators', 'تجمع المقامات'),
  ('a12b.dec.compare-by-length', 'math',
   'Tu compares par la longueur', 'You compare by length', 'تقارن بالطول');

-- =========================================================
-- 8. Le tag est unique — un vocabulaire à deux voix ne serait plus un vocabulaire.
-- =========================================================
SELECT throws_ok(
  $$INSERT INTO public.misconceptions (tag, subject, label_fr, label_en, label_ar)
    VALUES ('a12b.frac.add-denominators', 'math', 'doublon', 'dup', 'مكرر')$$,
  '23505',
  NULL,
  'un tag en double est refusé — la clé tient');

-- =========================================================
-- 9–11. Vue de l'élève : il lit, et il ne peut RIEN écrire (RLS + grants).
-- =========================================================
INSERT INTO auth.users (id, email)
VALUES ('a12b0000-0000-0000-0000-000000000001', 'eleve-a12b@test.local');

SET LOCAL "request.jwt.claims" = '{"sub":"a12b0000-0000-0000-0000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT label_fr FROM public.misconceptions WHERE tag = 'a12b.frac.add-denominators'),
  'Tu additionnes les dénominateurs',
  'l''élève lit bien la phrase que la correction affichera');

SELECT is(
  (SELECT count(*)::int FROM public.misconceptions WHERE tag LIKE 'a12b.%'),
  2,
  'il voit tout le vocabulaire — il n''est pas scopé par élève');

SELECT throws_ok(
  $$INSERT INTO public.misconceptions (tag, subject, label_fr, label_en, label_ar)
    VALUES ('a12b.pirate', 'math', 'injecté', 'injected', 'مُدرج')$$,
  '42501',
  NULL,
  'un élève ne peut pas injecter un libellé — aucune politique d''écriture');

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;
