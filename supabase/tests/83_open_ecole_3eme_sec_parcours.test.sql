-- =========================================================
-- Ouverture des six parcours de 3ème année secondaire — étude 16, seuil R-8
-- (« la première tranche complète ouvre la classe »).
--
-- Sur une DB fraîche (toutes les migrations appliquées, y compris
-- 20260831120000_open_ecole_3eme_sec_parcours), les six parcours `ecole-3eme-sec-*`
-- doivent être 'available', scolaires et gratuits — et chacun adossé à son sujet
-- d'anglais compilé.
--
-- La particularité que ce test atteste : l'anglais de 3ème année est AUTHORED UNE FOIS
-- et compilé en six sujets (`compileTo`, étude 16 D-4). Les six sujets doivent donc
-- être rattachés chacun à SON grade et porter le MÊME nombre de chapitres.
--
-- ⚠️ DEUX MOITIÉS QUI NE VIVENT PAS AU MÊME ENDROIT (#919). Les assertions 1-3 portent
-- sur `parcours`, créé par la migration `20260831120000` : elles tiennent sur toute base
-- reconstruite. Les assertions 4-6 portent sur `subjects`/`chapters`, c'est-à-dire sur du
-- CONTENU — il n'arrive JAMAIS par les migrations, mais par `apply-content.yml` depuis le
-- dépôt privé. Sur la base vierge que `db-tests.yml` fabrique, ces lignes n'existent pas et
-- ne peuvent pas exister : écrites en comptes absolus, elles échouaient sur CHAQUE PR
-- (deux fois sur `feat/open-3eme-sec-parcours` avant même son merge), rendant le prochain
-- vrai rouge pgTAP indiscernable — donc invisible.
--
-- Elles sont donc formulées en invariants de COHÉRENCE plutôt qu'en comptes absolus :
-- « tout ou rien », « autant que », « tous pareils ». C'est vrai sur une base vierge (zéro)
-- comme en prod (six), et c'est STRICTEMENT PLUS FORT que la version d'origine — le nombre
-- attendu n'est plus codé en dur mais dérivé des `grades`, eux bien seedés par migration
-- (`20260704235000`), donc un grade ajouté sans son sujet compilé fait désormais rougir.
--
-- Ce que ce fichier ne prétend plus prouver : que le corpus EST appliqué. Cette question-là
-- appartient à la Content CI privée et à `programme:etat`, qui voient le corpus. Ici on
-- teste le schéma. AGENTS.md le dit : « la prod n'est PAS le juge de la reconstructibilité ».
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

-- 4) L'anglais est compilé pour TOUS les grades de la classe, ou pour aucun.
--    Une fraction (trois sujets sur six) est un vrai défaut de compilation et rougit.
SELECT ok(
  (SELECT COUNT(*)::int FROM public.subjects WHERE id LIKE 'english-3eme-sec-%')
    IN (
      0,
      (SELECT COUNT(*)::int FROM public.grades
        WHERE theme_id = 'ecole-tn' AND slug LIKE '3eme-sec-%')
    ),
  'english-3eme-sec-* est compilé pour tous les grades de 3ème sec, ou pour aucun (corpus non appliqué) — jamais une fraction'
);

-- 5) Chacun est rattaché à SON grade — c'est ce que compileTo doit garantir.
--    Comparé au nombre de sujets PRÉSENTS, pas à 6 : vrai à zéro comme à six, et un seul
--    sujet mal rattaché fait diverger les deux comptes.
SELECT is(
  (SELECT COUNT(*)::int
   FROM public.subjects s
   JOIN public.grades g ON g.id = s.grade_id
   WHERE s.id = 'english-' || g.slug
     AND g.theme_id = 'ecole-tn'
     AND g.slug LIKE '3eme-sec-%'),
  (SELECT COUNT(*)::int FROM public.subjects WHERE id LIKE 'english-3eme-sec-%'),
  'chaque sujet compilé présent est rattaché au grade que son id nomme'
);

-- 6) Ils portent tous le même chapitrage : c'est le même dossier compilé six fois.
--    (Le nombre exact grandit au fil des tranches ; ce qui doit tenir, c'est l'égalité.)
--    `<= 1` et non `= 1` : sans corpus il n'y a AUCUN groupe, donc zéro chapitrage
--    distinct — ce qui ne contredit rien. Deux chapitrages différents, si.
SELECT ok(
  (SELECT COUNT(DISTINCT n)::int FROM (
     SELECT COUNT(*) AS n
     FROM public.chapters c
     WHERE c.subject_id LIKE 'english-3eme-sec-%'
     GROUP BY c.subject_id
   ) AS counts) <= 1,
  'les sujets compilés portent tous le même nombre de chapitres'
);

SELECT * FROM finish();
ROLLBACK;
