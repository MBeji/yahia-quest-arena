-- =========================================================
-- Ouverture des six parcours de 3ème année secondaire — étude 16, seuil R-8
-- (« la première tranche complète ouvre la classe »).
--
-- Sur une DB fraîche (toutes les migrations appliquées, y compris
-- 20260831120000_open_ecole_3eme_sec_parcours), les six parcours `ecole-3eme-sec-*`
-- doivent être 'available', scolaires et gratuits.
--
-- ⚠️ Ce que ce fichier NE peut PAS affirmer ici : que le CONTENU existe. Depuis
-- l'étude 24 le corpus ne voyage plus en migrations — il arrive en prod par
-- `apply-content.yml` depuis le dépôt privé — et `db-tests.yml` monte la base avec
-- `supabase db start`, qui n'applique que supabase/migrations/. Une base vierge n'a
-- donc AUCUN `subjects` / `chapters` de contenu, et ne peut pas en avoir.
-- (Miroir de 83_open_ecole_2eme_sec_eco_services_parcours.test.sql, qui documente
-- la même limite. AGENTS.md : « la prod n'est PAS le juge de la reconstructibilité ».)
--
-- Les tests 4 à 6 portent donc sur la particularité que ce parcours atteste —
-- l'anglais de 3ème année est AUTHORED UNE FOIS et compilé en six sujets
-- (`compileTo`, étude 16 D-4) — mais formulés comme des invariants VRAIS À VIDE :
-- ils passent sur base vierge sans rien affirmer, et deviennent opposables dès que
-- le corpus est là (prod, ou un `supabase test db` local sur une base peuplée).
-- C'est le même geste que le `WHERE EXISTS` des INSERT de contenu : un test qui
-- SKIP toujours ne garde nulle part, un invariant universellement quantifié garde
-- partout où il y a quelque chose à garder.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(6);

-- 1) Les six parcours sont ouverts.
SELECT is(
  (SELECT COUNT(*)::int FROM public.parcours
   WHERE id LIKE 'ecole-3eme-sec-%' AND status = 'available'),
  6,
  'les six parcours ecole-3eme-sec-* sont ouverts (status = available)'
);

-- 2) Aucun n'est resté en coming_soon.
SELECT is(
  (SELECT COUNT(*)::int FROM public.parcours
   WHERE id LIKE 'ecole-3eme-sec-%' AND status = 'coming_soon'),
  0,
  'aucun parcours de 3ème sec ne reste en coming_soon'
);

-- 3) Ce sont des parcours scolaires GRATUITS (invariant de la phase gratuite).
SELECT is(
  (SELECT COUNT(*)::int FROM public.parcours
   WHERE id LIKE 'ecole-3eme-sec-%' AND kind = 'scolaire' AND NOT is_premium),
  6,
  'les six parcours sont scolaires et gratuits (is_premium = false)'
);

-- 4) La compilation est ATOMIQUE : `compileTo` produit les six sujets ou aucun.
--    Un état intermédiaire (1 à 5) signale une application de contenu partielle —
--    c'est le vrai défaut à attraper. Zéro = base sans corpus, rien à dire.
SELECT ok(
  (SELECT COUNT(*)::int FROM public.subjects WHERE id LIKE 'english-3eme-sec-%') IN (0, 6),
  'les sujets english-3eme-sec-* arrivent en bloc : six, ou aucun (base sans corpus)'
);

-- 5) Aucun sujet compilé n'est rattaché à un AUTRE grade que celui que son id nomme —
--    c'est ce que compileTo doit garantir. Vrai à vide.
SELECT is(
  (SELECT COUNT(*)::int
   FROM public.subjects s
   WHERE s.id LIKE 'english-3eme-sec-%'
     AND NOT EXISTS (
       SELECT 1 FROM public.grades g
       WHERE g.id = s.grade_id
         AND s.id = 'english-' || g.slug
         AND g.theme_id = 'ecole-tn'
     )),
  0,
  'aucun sujet compilé n''est rattaché à un grade que son id ne nomme pas'
);

-- 6) Les sujets compilés portent le même chapitrage : c'est le même dossier compilé
--    six fois. (Le nombre exact grandit au fil des tranches ; ce qui doit tenir, c'est
--    l'égalité.) `<= 1` plutôt que `= 1` : zéro sujet ⇒ zéro comptage distinct.
SELECT ok(
  (SELECT COUNT(DISTINCT n)::int FROM (
     SELECT COUNT(*) AS n
     FROM public.chapters c
     WHERE c.subject_id LIKE 'english-3eme-sec-%'
     GROUP BY c.subject_id
   ) AS counts) <= 1,
  'les sujets compilés portent tous exactement le même nombre de chapitres'
);

SELECT * FROM finish();
ROLLBACK;
