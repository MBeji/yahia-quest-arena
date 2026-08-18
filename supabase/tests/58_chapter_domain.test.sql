-- =========================================================
-- `chapters.domain` — le contrat de la colonne qui rend les domaines d'une
-- matière (« Algèbre », « Géométrie », « قواعد اللغة »…) visibles sous elle.
--
-- Ce que la base doit garantir, et rien de plus :
--   1. la colonne existe, est du bon type, et reste NULLABLE — un chapitre sans
--      domaine reste un chapitre, et c'est l'état de tout le corpus le jour de
--      la migration ;
--   2. un libellé vide ou à espaces de bord est REFUSÉ — il créerait un groupe
--      fantôme, ou deux groupes pour un même domaine ;
--   3. la colonne est lisible sans grant nouveau (grant de TABLE hérité).
-- L'ordre des domaines, lui, n'est pas un fait de base : il se lit dans
-- `display_order` (première apparition), et se teste côté moteur.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(8);

SELECT has_column('public', 'chapters', 'domain',
  'chapters porte une colonne domain');

SELECT col_type_is('public', 'chapters', 'domain', 'text',
  'chapters.domain est du texte — un libellé dans la langue de la matière, pas une clé');

SELECT col_is_null('public', 'chapters', 'domain',
  'chapters.domain est nullable — un chapitre non rattaché reste un chapitre');

SELECT ok(
  has_column_privilege('anon', 'public.chapters', 'domain', 'SELECT'),
  'la colonne hérite du GRANT SELECT de table : le hub public la lit sans grant nouveau'
);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('domain-subj', 'Domain Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

SELECT lives_ok($$
  INSERT INTO public.chapters (id, subject_id, title, display_order, domain)
  VALUES ('d0004a11-0000-0000-0000-000000000001', 'domain-subj', 'Thalès', 1, 'Géométrie')
$$, 'un libellé propre est accepté');

SELECT lives_ok($$
  INSERT INTO public.chapters (id, subject_id, title, display_order, domain)
  VALUES ('d0004a11-0000-0000-0000-000000000002', 'domain-subj', 'Équations', 2, NULL)
$$, 'NULL est accepté — le corpus n''en déclare aucun au jour de la migration');

-- Les deux écritures que la colonne existe pour empêcher : elles ne cassent rien
-- en base, mais elles cassent le GROUPEMENT, où le libellé EST l'identité.
SELECT throws_ok($$
  INSERT INTO public.chapters (id, subject_id, title, display_order, domain)
  VALUES ('d0004a11-0000-0000-0000-000000000003', 'domain-subj', 'Vide', 3, '')
$$, '23514', NULL,
  'un libellé vide est refusé — il ouvrirait un groupe sans nom');

SELECT throws_ok($$
  INSERT INTO public.chapters (id, subject_id, title, display_order, domain)
  VALUES ('d0004a11-0000-0000-0000-000000000004', 'domain-subj', 'Bordure', 4, ' Géométrie')
$$, '23514', NULL,
  'un libellé à espaces de bord est refusé — « Géométrie » et « Géométrie » feraient deux groupes');

SELECT * FROM finish();
ROLLBACK;
