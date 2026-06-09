-- Flip the 6ème concours parcours from "coming_soon" to "available".
-- math-6eme now ships the full NUMERICAL + PROPORTIONALITY strand of the official
-- 6ème programme: 15 chapters (numération, 4 opérations, décimaux, multiples,
-- divisibilité, fractions, fractions-décimales, ×fraction-entier, proportionnalité,
-- vitesse/distance/temps) — enough to sell the parcours. (Geometry + measurement
-- remain and can be added later without blocking launch.)
--
-- Idempotent: re-running is a no-op once the status is already 'available'.
UPDATE public.parcours
SET status = 'available'
WHERE id = 'concours-6eme';
