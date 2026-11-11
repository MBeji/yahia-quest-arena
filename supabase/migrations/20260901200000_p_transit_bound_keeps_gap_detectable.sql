-- é30 · privé#247 item 2 — la borne haute de `p_transit` passe de 0,40 à 0,18.
--
-- POURQUOI. `p_transit` est le p(T) de BKT : la probabilité d'apprendre EN répondant. Le
-- plancher de la croyance n'est donc PAS la borne basse de la colonne — chaque erreur est
-- suivie d'une remontée de (1 − p⁺)·T, et la croyance converge vers un POINT FIXE, mesuré
-- au lot 1 à ≈ 1,12 × p(T) :
--
--     p(T)    plancher après 200 erreurs (mcq 4 options, difficulté 2)
--     0,02    0,022
--     0,15    0,168     ← défaut de famille, et valeur de TOUTES les lignes aujourd'hui
--     0,18    0,202     ← nouvelle borne haute
--     0,20    0,224
--     0,22    0,246     ← à partir d'ici le plancher touche le seuil de R-5
--     0,40    0,448     ← ancienne borne haute
--
-- R-5 déclare une LACUNE à `p_known ≤ 0,25`. Au-delà de p(T) ≈ 0,22, le plancher passe
-- AU-DESSUS de ce seuil : sur cette compétence, une lacune devient indétectable quel que
-- soit le nombre d'erreurs — et avec elle s'éteignent le marquage `suspect` (R-8) et le
-- rebranchement « cause racine ». L'ancienne borne laissait donc écrire, sans le moindre
-- avertissement, une valeur qui éteint la remédiation. §3.8c de l'étude documentait le
-- danger ; un paragraphe ne refuse rien, une contrainte si.
--
-- CE QUE ÇA COÛTE : rien. Aucune compétence du corpus n'écrit `pTransit` — registre `math`,
-- 62 entrées, re-vérifié le 2026-09-01 — donc toutes les lignes valent le défaut 0,15. La
-- borne 0,18 laisse la marge d'un réglage vers le haut tout en gardant le plancher (0,202)
-- sous le seuil de lacune, avec ~0,05 de garde.
--
-- ARBITRAGE DU PROPRIÉTAIRE, 2026-09-01, sur les trois options que posait privé#247 :
-- resserrer le CHECK — plutôt que documenter seul (déjà fait, et sans effet opposable) ou
-- rendre R-5 relatif au plancher (le plus propre conceptuellement, le plus coûteux, et rien
-- ne casse aujourd'hui qui le justifierait).
--
-- La contrainte est REMPLACÉE, pas ajoutée : deux CHECK sur la même colonne se cumuleraient
-- et la plus lâche deviendrait invisible à la lecture. Elle se retrouve par sa DÉFINITION,
-- jamais par son nom — `ADD COLUMN … CHECK` la nomme automatiquement, et un nom auto-généré
-- n'est pas un contrat sur lequel une migration peut s'appuyer. Le `NOT ILIKE '%p_init%'`
-- protège d'un cas qui n'existe pas ici mais coûterait cher : une contrainte portant les
-- deux colonnes serait retirée en entier, emportant la borne de `p_init` avec elle.
DO $$
DECLARE
  v_name text;
BEGIN
  FOR v_name IN
    SELECT c.conname
    FROM pg_constraint c
    JOIN pg_class t ON t.oid = c.conrelid
    JOIN pg_namespace n ON n.oid = t.relnamespace
    WHERE n.nspname = 'public'
      AND t.relname = 'competencies'
      AND c.contype = 'c'
      AND pg_get_constraintdef(c.oid) ILIKE '%p_transit%'
      AND pg_get_constraintdef(c.oid) NOT ILIKE '%p_init%'
  LOOP
    EXECUTE format('ALTER TABLE public.competencies DROP CONSTRAINT %I', v_name);
  END LOOP;
END $$;

ALTER TABLE public.competencies
  ADD CONSTRAINT competencies_p_transit_keeps_gap_detectable
  CHECK (p_transit BETWEEN 0.02 AND 0.18);

COMMENT ON CONSTRAINT competencies_p_transit_keeps_gap_detectable ON public.competencies IS
  'é30/privé#247 : borne haute 0,18 — au-delà de p(T) ≈ 0,22 le plancher de croyance (≈ 1,12·p(T)) passe au-dessus du seuil de lacune de R-5 (0,25) et la lacune devient indétectable.';
