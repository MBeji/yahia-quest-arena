-- Ouvrir les 11 parcours du lycée restés invisibles : « coming_soon » →
-- « available » pour les six sections de 3ème année secondaire et les cinq
-- sections du Bac encore fermées.
--
-- POURQUOI MAINTENANT. Ces onze classes ont du contenu complet, appliqué en
-- prod et jouable — mais leur parcours est resté `coming_soon` depuis le seed
-- 20260704235000, donc rien n'est visible pour un élève. Le rapport
-- `programme:etat` lève un constat R-8 par classe ; aucun gate ne le signale,
-- parce qu'aucun gate ne regarde la jonction contenu ↔ ouverture. Onze classes
-- pourvues et muettes, c'est du contenu payé et jamais servi.
--
-- Couverture au moment de l'ouverture (mesurée par `programme:etat`) :
--   • les six sections de 3ème sec : 6 chapitres complets chacune ;
--   • concours-bac-lettres : 6 chapitres ;
--   • concours-bac-{eco-gestion,info,sciences-exp,techniques} : 9 chapitres.
-- Ce contenu vient de sujets MUTUALISÉS (`compileTo`, étude 16 D-4) : les
-- matières transversales du lycée — anglais, français — desservent plusieurs
-- sections depuis un manuel commun. L'ouverture ne coûte donc aucune écriture.
--
-- R-8 assume l'ouverture AVANT la complétude : une première tranche complète
-- ouvre la classe, les matières propres à chaque section (maths, physique,
-- SVT, technologie, philosophie…) s'ajoutent ensuite sous un parcours déjà
-- ouvert, sans nouvelle migration. C'est la même forme de déploiement que la
-- 8ème (20260704130940) et les trois sections de 2ème sec (20260730/31).
--
-- PHASE GRATUITE — rien n'est gaté. Les cinq `concours-bac-*` ont été semés
-- `is_premium = true` par 20260704235000, mais 20260711100000
-- (`free_phase_all_parcours`) a basculé TOUS les parcours à `is_premium = false`
-- après ce seed. `resolve_exercise_access` court-circuite alors à OPEN (« a FREE
-- parcours is always open »), et le `preview_policy = 'difficulty_1'` laissé sur
-- ces lignes devient sans effet. Passer à 'available' ouvre donc la classe
-- ENTIÈREMENT, sans entitlement et sans surface « premium » — l'invariant de la
-- phase gratuite (AGENTS.md) est préservé. L'étude 01, gelée, reste le véhicule
-- d'un éventuel retour en arrière : elle re-basculera `is_premium` d'un UPDATE
-- inverse, sans toucher au statut.
--
-- Idempotent : re-jouer est un no-op une fois les statuts déjà 'available'.
-- Groupée en une migration plutôt qu'une par section — même geste, même
-- justification, même instant ; miroir de 20260621170000, qui avait ouvert cinq
-- parcours du primaire d'un coup.
UPDATE public.parcours
SET status = 'available'
WHERE id IN (
  -- 3ème année secondaire — six sections (parcours `scolaire`, gratuits)
  'ecole-3eme-sec-math',
  'ecole-3eme-sec-sciences-exp',
  'ecole-3eme-sec-lettres',
  'ecole-3eme-sec-eco-gestion',
  'ecole-3eme-sec-techniques',
  'ecole-3eme-sec-info',
  -- Baccalauréat — les cinq sections encore fermées (`concours-bac-math` est
  -- ouvert depuis 20260705100000)
  'concours-bac-sciences-exp',
  'concours-bac-lettres',
  'concours-bac-eco-gestion',
  'concours-bac-techniques',
  'concours-bac-info'
);
