-- Ouvrir le parcours Baccalauréat — section Sciences de l'informatique :
-- « coming_soon » → « available », ET le rendre gratuit.
--
-- Seuil R-8 : une première tranche complète ouvre la classe, on n'attend pas la
-- matière complète. Ici la section reçoit d'un coup DEUX matières, l'une et
-- l'autre par MUTUALISATION — aucune écriture ne lui est propre :
--
--   * français — `french-bac-info`, **7 chapitres sur 7 (100 %)**, compilés
--     depuis content/french-bac/ (`compileTo` ×5, étude 16 D-4). Le manuel
--     « Au gré des textes » (221402) dessert cinq sections : sa PAGE DE TITRE
--     les nomme une par une, éco-gestion comprise — c'est un constat, pas une
--     déduction, et il clôt la question laissée ouverte par
--     docs/lycee-architecture.md §3.1 pour le français.
--   * anglais — `english-bac-info`, 6 chapitres, même mécanique depuis
--     content/english-bac/ (le manuel 241403 dessert les SIX sections).
--
-- Contenu appliqué en production par `apply-content.yml` AVANT cette migration,
-- releases journalisées dans `content_releases` (dernière : fca8b29, les 7
-- chapitres de français). Sans cette antériorité, la section s'ouvrirait vide.
--
-- ⚠️ POURQUOI DEUX UPDATE ET NON UN SEUL. Le seed 20260704235000 a créé les six
-- parcours bac avec la forme premium CIBLE (is_premium = true, preview
-- 'difficulty_1'), et seul `concours-bac-math` a été libéré ensuite
-- (20260705120000_bac_math_free_beta_phase). Passer cette section à
-- 'available' sans la libérer ouvrirait le seul APERÇU — le quiz et les
-- missions de difficulté 1 —, laissant la révision ⭐⭐ et le boss ⭐⭐⭐
-- verrouillés derrière un entitlement que personne ne vend encore. L'app est
-- 100 % gratuite depuis le pivot du 2026-06-21 : la forme premium reste la
-- cible, elle ne doit simplement pas précéder la capacité de payer
-- (FableEtudes/01, gelée). Re-verrouiller à la monétisation est l'UPDATE
-- inverse, livré avec le checkout.
--
-- `kind` reste 'concours' : c'est bien le produit concours, seule la barrière
-- est en pause. Miroir exact de la paire 20260705100000 + 20260705120000 qui a
-- ouvert bac-math.
--
-- Ce qui manque à la section est nommé plutôt que taillé sous silence : ses
-- dominantes propres (informatique — algorithmique, programmation, bases de données) et la philosophie — dont le chapitrage est
-- codifié mais dont la fiche est en profondeur « first-pass » (16 %), donc non
-- générable (R-5). R-8 assume l'ouverture avant la complétude.
--
-- Idempotent : re-jouer est un no-op une fois le parcours ouvert et libéré.
UPDATE public.parcours
SET status = 'available'
WHERE id = 'concours-bac-info';

UPDATE public.parcours
SET is_premium = false,
    preview_policy = 'full'
WHERE id = 'concours-bac-info';
