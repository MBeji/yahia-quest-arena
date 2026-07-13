-- Open the 1ère année secondaire (tronc commun) parcours: flip
-- "coming_soon" → "available".
--
-- Étude 16 (ouverture du lycée), vague A, seuil R-8 : « une matière complète
-- ouvre la section ». La matière mathématiques de la 1ère année secondaire est
-- désormais complète — les 16 chapitres du manuel officiel CNP (222104P01/P02)
-- ont été livrés via le pipeline de contenu idempotent (cours + résumé + quiz +
-- ladder d1/d2), migrations générées 20260713140000 → 20260713170000. Le seuil
-- d'ouverture est atteint : on rend le parcours sélectionnable (Explorer /
-- onboarding).
--
-- Le parcours `ecole-1ere-sec` (tronc commun) a été seedé `coming_soon` par
-- 20260617120000 (INSERT 'ecole-' || g.slug pour chaque grade ecole-tn). C'est
-- un parcours `scolaire` GRATUIT (is_premium = false, preview_policy = 'full',
-- phase gratuite) : devenir 'available' ouvre TOUTE la matière — quiz + toutes
-- les missions d1/d2 — et non un simple aperçu. Les paliers boss d3 / défi d4
-- (overlay prof-math-lycee) et les autres matières de la 1ère sec arriveront par
-- le même pipeline idempotent et apparaîtront sous ce parcours déjà ouvert (même
-- forme de déploiement que la 8ème : 20260704130940, et le bac-math :
-- 20260705100000).
--
-- Idempotent : re-jouer est un no-op une fois le statut déjà 'available'.
UPDATE public.parcours
SET status = 'available'
WHERE id = 'ecole-1ere-sec';
