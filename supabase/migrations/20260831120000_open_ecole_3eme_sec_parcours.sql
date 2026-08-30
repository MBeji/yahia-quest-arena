-- Open the six 3ème année secondaire parcours: flip "coming_soon" → "available".
--
-- Étude 16 (ouverture du lycée), seuil R-8. La matière ANGLAIS de la 3ème année
-- secondaire est COMPLÈTE : 9 chapitres sur 9 (couverture 100 % au manifeste, 0 chapitre
-- manquant, 0 hors-programme, 0 incomplet), soit 162 questions par section. Le contenu a
-- été appliqué en production le 2026-08-29 par apply-content.yml (run 33245378799),
-- journalisé dans `content_releases`, et la garde `content-drift` a constaté la fermeture
-- de l'écart (elle est passée de 10 sujets en retard à 4, les six d'anglais en sortant).
--
-- POURQUOI SIX PARCOURS D'UN SEUL COUP, ET PAS UN.
-- En 3ème année, toutes les matières se dédoublent par section SAUF l'anglais : le
-- catalogue CNP ne porte qu'un manuel élève (241303) et qu'un guide enseignant (641303)
-- pour les six sections, et aucun titre ne nomme de شعبة. La transcription l'a confirmé
-- (corpus privé, programme/3eme-sec-math/anglais.md). Le contenu est donc AUTHORED UNE
-- FOIS puis compilé en six sujets par `compileTo` (étude 16 D-4) — english-3eme-sec-{math,
-- sciences-exp, lettres, eco-gestion, techniques, info}. Les six sections reçoivent
-- exactement les mêmes 9 chapitres : les ouvrir séparément n'aurait pas de sens.
--
-- CE QUE L'ÉLÈVE VERRA, ET CE QU'IL NE VERRA PAS.
-- Chaque classe s'ouvre avec UNE SEULE MATIÈRE VISIBLE (anglais). C'est ce que R-8
-- prescrit : la classe s'ouvre, les matières suivantes s'ajoutent sous un parcours déjà
-- visible, sans nouvelle migration. Les autres matières de la 3ème année (arabe, maths,
-- philosophie, sciences physiques, SVT, histoire-géo…) restent à transcrire.
--
-- Les six parcours `ecole-3eme-sec-*` ont été seedés `coming_soon` par la migration du
-- lycée (INSERT 'ecole-' || g.slug pour chaque grade ecole-tn). Ce sont des parcours
-- `scolaire` GRATUITS (is_premium = false, preview_policy = 'full', phase gratuite) :
-- devenir 'available' ouvre TOUTE la matière — quiz + toutes les missions d1/d2/d3 — et
-- non un simple aperçu.
--
-- Idempotent : re-jouer est un no-op une fois les statuts déjà 'available'.
UPDATE public.parcours
SET status = 'available'
WHERE id IN (
  'ecole-3eme-sec-math',
  'ecole-3eme-sec-sciences-exp',
  'ecole-3eme-sec-lettres',
  'ecole-3eme-sec-eco-gestion',
  'ecole-3eme-sec-techniques',
  'ecole-3eme-sec-info'
);
