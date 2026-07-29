-- Ouvrir le parcours 7ème année de base : « coming_soon » → « available ».
--
-- DETTE RATTRAPÉE. Le commentaire d'en-tête de
-- 20260704130940_open_8eme_base_parcours.sql annonce qu'il « mirrors
-- 20260703210000_open_7eme_base_parcours.sql » — ce fichier n'a jamais existé
-- (aucune trace dans l'historique : `git log -S open_7eme_base_parcours` ne
-- ramène que la 8ème). La 8ème a donc été ouverte, la 7ème oubliée, et le
-- parcours est resté sur le statut `coming_soon` que lui avait donné
-- 20260617120000_parcours_interest_and_school_grades.sql, avant tout contenu.
--
-- Depuis, la 7ème est la classe la mieux fournie du collège : 54 chapitres
-- répartis sur ses 6 matières — arabic-7eme (17), math-7eme (13),
-- sciences-vie-terre-7eme (7), french-7eme (6), sciences-physiques-7eme (6),
-- english-7eme (5) — tous appliqués en prod par le canal contenu. Ce contenu
-- est en base et reste invisible aux élèves : `coming_soon` affiche le teaser
-- « En construction » et `resolve_exercise_access` refuse l'entrée
-- (PARCOURS_COMING_SOON). C'est exactement le constat que remonte
-- `npm run programme:etat` au titre de la règle R-8.
--
-- Parcours `scolaire` GRATUIT (is_premium = false, preview_policy = 'full') :
-- passer à 'available' l'ouvre entièrement, sans entitlement.
--
-- Idempotent : re-jouer est un no-op une fois le statut déjà 'available'.
-- Miroir de 20260704130940_open_8eme_base_parcours.sql.
UPDATE public.parcours
SET status = 'available'
WHERE id = 'ecole-7eme-base';
