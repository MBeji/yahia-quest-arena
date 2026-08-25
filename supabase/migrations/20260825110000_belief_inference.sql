-- Tuteur déterministe — étude 30 lot 2 : l'inférence dans le graphe
-- (FableEtudes/30-tuteur-deterministe, dépôt privé — §3.3, R-7 à R-10).
--
-- CE QUE CE LOT AJOUTE. Le lot 1 sait ce que l'élève croit d'une compétence qu'il a JOUÉE.
-- Ce lot ajoute ce qu'on peut en DÉDUIRE : le mandat, point 2 — « si l'élève valide une
-- notion complexe, le système en déduit la maîtrise probable des prérequis sous-jacents ».
-- C'est le cœur de l'économie d'ALEKS, et le graphe de é07 le permet sans rien ajouter au
-- corpus : les arêtes existent déjà, personne ne les avait encore fait travailler.
--
--   D-3 — L'INFÉRENCE MONTE, ELLE NE DESCEND JAMAIS. Une croyance haute sur C RELÈVE ses
--   prérequis (R-7). Une lacune confirmée sur C ne BAISSE pas les siens : elle les marque
--   `suspect`, ce qui les fait sonder en priorité (R-8). L'asymétrie n'est pas une timidité,
--   c'est la seule qui reste vraie quand on se trompe : relever par déduction est charitable
--   — au pire on fait sauter des exercices redondants, et la première preuve contraire
--   corrige — tandis qu'abaisser par déduction fabrique dans le dossier de l'élève des
--   lacunes qu'il n'a jamais commises, que le rapport parent affichera.
--
--   D-4 — L'INFÉRENCE NE DÉCLARE JAMAIS LA MAÎTRISE (R-9) : plafond 0,90 < 0,95, et ni
--   `evidence_count` ni `forms_seen` ni `sessions_seen` ne bougent. On peut être DISPENSÉ
--   d'un prérequis ; on n'est déclaré MAÎTRE que de ce qu'on a fait soi-même.
--
--   D-5 — ELLE EST TRAÇABLE ET CONTESTABLE (R-10) : la ligne porte `belief_source` et
--   `inferred_from`. Le geste « je ne suis pas d'accord » est une lecture du lot 3 ; les
--   deux colonnes qui le rendent possible sont écrites ici.
--
-- MIGRATION ADDITIVE : une fonction, un trigger. Aucune signature existante n'est modifiée,
-- aucune colonne n'est ajoutée (le lot 1 les a toutes posées), aucun GRANT ne bouge.
--
-- ⚠️ LA NOTE DE PASSAGE, à lire avant de s'étonner en prod. Une ligne créée par inférence
-- garde `mastery = 50` et `attempts = 0` (§3.8a, piège 1) — elle est donc rendue par
-- `get_my_competency_map` (é07 lot 4), qui ne lit pas `belief_source` et affichera une barre
-- à 50 %. C'est prévu par l'étude, qui confie l'affichage « déduit » à la carte à 4 états du
-- LOT 3. Entre ce merge et celui du lot 3, un élève de la matière pilote peut voir apparaître
-- des compétences à 50 % qu'il n'a pas jouées. La fenêtre est d'une PR, et `get_my_competency_map`
-- ne peut pas être corrigée ici : sa retraite est une décision de é07 (stop-point du lot 3).

-- ---------------------------------------------------------------------------
-- 0. Ce que la mesure de perf du lot a trouvé : `belief_update` n'était pas inlinable.
-- ---------------------------------------------------------------------------
-- Le critère d'acceptation du lot 2 impose un relevé avant/après sur les deux appelants
-- (`scripts/adaptive/bench-belief.sql`). Il a trouvé autre chose que ce qu'il cherchait : le
-- coût dominant n'était pas l'inférence de CE lot mais le trigger du lot 1, à +12,7 ms par
-- soumission de 20 réponses. La cause est un détail de planification, pas un défaut de
-- modèle : `belief_update` était écrite avec un `WITH`, et une fonction SQL qui contient une
-- CTE n'est **pas inlinable** — le planificateur l'appelle donc via le gestionnaire de
-- fonctions, une fois par ligne et par compétence, au lieu de fondre son expression dans le
-- plan de l'upsert.
--
-- La même formule, écrite en UNE expression, redevient inlinable : −3,6 ms par soumission,
-- soit 29 % du surcoût du lot 1, pour zéro changement de comportement. Les valeurs rendues
-- sont identiques au chiffre près — la table de vérité de l'annexe A, inchangée dans
-- `supabase/tests/75_adaptive_belief.test.sql`, en est la preuve exécutable, et c'est la
-- raison pour laquelle cette réécriture voyage sans son propre test.
--
-- La lisibilité y perd un peu, et le commentaire ci-dessous paie cette dette : l'identité
-- utilisée est `p⁺ + (1−p⁺)·T = T + (1−T)·p⁺`, qui permet de n'écrire le quotient qu'une fois.
CREATE OR REPLACE FUNCTION public.belief_update(
  p_prior   NUMERIC,
  p_correct BOOLEAN,
  p_guess   NUMERIC,
  p_slip    NUMERIC,
  p_transit NUMERIC,
  p_weight  NUMERIC DEFAULT 1.0
) RETURNS NUMERIC
LANGUAGE sql
IMMUTABLE
AS $$
  --   juste : p⁺ = p(1−S) / [ p(1−S) + (1−p)G ]
  --   faux  : p⁺ = p·S    / [ p·S    + (1−p)(1−G) ]
  --   puis    p' = p⁺ + (1−p⁺)·T   ≡   T + (1−T)·p⁺      (l'élève peut apprendre EN répondant)
  --   enfin   p_final = p_avant + w·(p' − p_avant)        (le poids de la preuve, R-21)
  --
  -- `w` est ce qui distingue une preuve d'autonomie d'une reprise après aide : 1,0 sans aide,
  -- 0,5 après les paliers 1-2 ou un mini-check du tuteur, 0,25 après le palier 3. C'est
  -- l'échafaudage de Bruner rendu arithmétique — l'aide se retire à mesure que l'autonomie se
  -- prouve, et le système sait toujours de quelle autonomie il parle.
  --
  -- Le `NULLIF` sur le dénominateur couvre l'item dégénéré (G = 1, ou S = 1 sur une erreur) :
  -- le quotient devient NULL, le `COALESCE` rend le prior, et le résultat est le prior intact.
  -- Ne rien apprendre est la seule réponse honnête à une observation qui n'informe pas.
  --
  -- Bornes [0,01 ; 0,99] : la certitude absolue n'est pas un état atteignable, et une croyance
  -- à 0 ou 1 serait un point fixe dont aucune preuve contraire ne pourrait plus la sortir.
  SELECT LEAST(0.99, GREATEST(0.01, ROUND(
    p_prior + COALESCE(p_weight, 1.0) * (
      COALESCE(
        p_transit + (1 - p_transit) * (
          (CASE WHEN p_correct THEN p_prior * (1 - p_slip) ELSE p_prior * p_slip END)
          / NULLIF(CASE WHEN p_correct
                        THEN p_prior * (1 - p_slip) + (1 - p_prior) * p_guess
                        ELSE p_prior * p_slip       + (1 - p_prior) * (1 - p_guess) END, 0)
        ),
        p_prior
      ) - p_prior
    )
  , 4)))::NUMERIC;
$$;

COMMENT ON FUNCTION public.belief_update(NUMERIC, BOOLEAN, NUMERIC, NUMERIC, NUMERIC, NUMERIC) IS
  'Étude 30 §3.2 : une observation BKT, pondérée par le poids de la preuve (R-21). Bornée [0,01 ; 0,99]. Écrite en une expression pour rester inlinable (mesure du lot 2).';

-- Le `REVOKE` du lot 1 survit à un `CREATE OR REPLACE` (les privilèges suivent l'objet, pas sa
-- définition) ; on le réaffirme quand même, pour qu'une lecture de ce fichier seul ne laisse
-- aucun doute sur l'état final.
REVOKE EXECUTE ON FUNCTION public.belief_update(NUMERIC, BOOLEAN, NUMERIC, NUMERIC, NUMERIC, NUMERIC)
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 1. La propagation elle-même.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.propagate_competency_belief(
  p_user       UUID,
  p_competency UUID,
  p_belief     NUMERIC,
  p_confirmed_gap BOOLEAN DEFAULT false
) RETURNS INT
LANGUAGE plpgsql
SET search_path = public
AS $$
DECLARE
  v_touched INT := 0;
BEGIN
  -- Les ancêtres du DAG jusqu'à la profondeur 2 (R-7 · INFERENCE_MAX_DEPTH). `UNION` et non
  -- `UNION ALL` : un losange dans le graphe rejoindrait deux fois le même ancêtre, et la
  -- borne de profondeur ne protège pas d'un cycle qui aurait échappé au lint de é07 lot 1.
  -- La profondeur RETENUE est la plus COURTE — c'est celle qui amortit le moins, donc celle
  -- qui dit le plus, et prendre l'autre reviendrait à sous-estimer volontairement.
  WITH RECURSIVE ancestry(competency_id, depth) AS (
    SELECT pr.prereq_id, 1
      FROM public.competency_prereqs pr
     WHERE pr.competency_id = p_competency
    UNION
    SELECT pr.prereq_id, a.depth + 1
      FROM public.competency_prereqs pr
      JOIN ancestry a ON pr.competency_id = a.competency_id
     WHERE a.depth < 2
  ),
  shortest AS (
    SELECT competency_id, min(depth) AS depth
      FROM ancestry
     -- Un cycle ramènerait la compétence source parmi ses propres ancêtres : elle se
     -- relèverait elle-même et le trigger repartirait. On l'exclut explicitement.
     WHERE competency_id <> p_competency
     GROUP BY competency_id
  ),
  target AS (
    SELECT
      s.competency_id,
      -- γ^d · p, plafonné à 0,90 — SOUS le seuil de maîtrise par construction (R-9).
      LEAST(0.90, ROUND(POWER(0.70, s.depth)::NUMERIC * p_belief, 4)) AS p_target
      FROM shortest s
  ),
  raised AS (
    -- L'inférence PREND LE MAXIMUM (annexe A.4) : elle ne peut donc jamais dégrader une
    -- croyance existante, et une ligne déjà mieux informée n'est même pas réécrite —
    -- le `WHERE` ci-dessous fait de la non-dégradation une propriété du plan, pas une
    -- promesse de la formule.
    INSERT INTO public.user_competency_mastery AS m
      (user_id, competency_id, last_attempt_at, p_known, belief_source, inferred_from)
    SELECT p_user, t.competency_id, now(), t.p_target, 'inference', p_competency
      FROM target t
     WHERE NOT p_confirmed_gap
    ON CONFLICT (user_id, competency_id) DO UPDATE SET
      p_known       = EXCLUDED.p_known,
      belief_source = 'inference',
      inferred_from = EXCLUDED.inferred_from
      -- D-4 : ni `evidence_count`, ni `sessions_seen`, ni `forms_seen`, ni `mastery`, ni
      -- `attempts` ne figurent dans ce SET. Aucune ligne inférée ne peut donc satisfaire les
      -- cinq conditions de R-4 — l'attaque « faire déclarer une maîtrise sans preuve » ne
      -- passe pas par ici, et c'est structurel, pas conditionnel.
      WHERE m.p_known < EXCLUDED.p_known
    RETURNING 1
  ),
  suspected AS (
    -- R-8 · la moitié descendante : une lacune CONFIRMÉE ne baisse rien, elle marque.
    -- `suspect` n'est pas un diagnostic, c'est une priorité de sondage — d'où deux
    -- différences avec la branche montante : elle ne CRÉE aucune ligne (une compétence sans
    -- preuve n'a pas de ligne, R-6, et le sélecteur sait déjà aller chercher ce qu'il ne
    -- connaît pas), et elle ne touche pas `p_known`.
    UPDATE public.user_competency_mastery m
       SET suspect = true
      FROM shortest s
     WHERE p_confirmed_gap
       AND m.user_id = p_user
       AND m.competency_id = s.competency_id
       AND NOT m.suspect
    RETURNING 1
  )
  SELECT (SELECT count(*) FROM raised) + (SELECT count(*) FROM suspected) INTO v_touched;

  RETURN v_touched;
END;
$$;

COMMENT ON FUNCTION public.propagate_competency_belief(UUID, UUID, NUMERIC, BOOLEAN) IS
  'Étude 30 R-7/R-8 : relève les prérequis (γ=0,7, profondeur ≤ 2, plafond 0,90) ou les marque suspects. Ne descend jamais.';

REVOKE EXECUTE ON FUNCTION public.propagate_competency_belief(UUID, UUID, NUMERIC, BOOLEAN)
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 2. Le déclencheur : la TRAVERSÉE DE BANDE, pas chaque réponse.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.trigger_belief_propagation()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  -- Franchissement de 0,85 VERS LE HAUT. Le test sur OLD est ce qui fait de la propagation
  -- un événement rare : un élève déjà au-dessus de la bande peut répondre cent fois de
  -- suite, la fonction n'est jamais appelée. C'est la moitié du budget de perf du lot —
  -- l'autre étant la clause WHEN du trigger, qui écarte tout le reste sans exécuter de plpgsql.
  IF NEW.p_known >= 0.85 AND (TG_OP = 'INSERT' OR OLD.p_known < 0.85) THEN
    PERFORM public.propagate_competency_belief(NEW.user_id, NEW.competency_id, NEW.p_known, false);
    RETURN NULL;
  END IF;

  -- Franchissement de 0,25 VERS LE BAS — et seulement quand la lacune devient CONFIRMÉE au
  -- sens de R-5 (`p_known <= 0,25` ET `evidence_count >= 3`). En deçà de trois preuves on dit
  -- « fragile », jamais « lacune » : accuser sur deux items est une erreur de mesure, pas un
  -- diagnostic — et marquer les prérequis suspects sur cette base ferait sonder au hasard.
  IF NEW.p_known <= 0.25 AND NEW.evidence_count >= 3
     AND (TG_OP = 'INSERT' OR OLD.p_known > 0.25 OR OLD.evidence_count < 3) THEN
    PERFORM public.propagate_competency_belief(NEW.user_id, NEW.competency_id, NEW.p_known, true);
  END IF;

  RETURN NULL;
END;
$$;

COMMENT ON FUNCTION public.trigger_belief_propagation() IS
  'Étude 30 §3.3 : propage à la traversée de bande (0,85 vers le haut, 0,25 vers le bas), jamais à chaque réponse.';

REVOKE EXECUTE ON FUNCTION public.trigger_belief_propagation() FROM PUBLIC, anon, authenticated;

-- La clause WHEN porte tout le filtrage bon marché, et `UPDATE OF p_known` fait le reste :
--
--   * `belief_source IN ('evidence','placement')` — UNE LIGNE ÉCRITE PAR INFÉRENCE NE
--     PROPAGE PAS. C'est le garde-fou de récursion, et il est sémantique plutôt que
--     technique : sans lui, un prérequis relevé à 0,90 franchirait 0,85 et repartirait,
--     ce qui donnerait une profondeur 3, 4, … — exactement le stop-point du lot
--     (« profondeur 2, pas 3 »). `pg_trigger_depth()` aurait borné la casse sans dire
--     pourquoi ; cette condition-ci dit pourquoi.
--   * `UPDATE OF p_known` — le marquage `suspect` ne touche que `suspect`, donc il ne
--     réveille pas ce trigger du tout. La branche descendante ne peut pas se propager
--     en chaîne.
--   * les deux bornes de bande — une croyance entre 0,25 et 0,85 (la vaste majorité des
--     écritures) n'exécute pas une ligne de plpgsql.
DROP TRIGGER IF EXISTS trg_ucm_belief_propagation ON public.user_competency_mastery;
CREATE TRIGGER trg_ucm_belief_propagation
  AFTER INSERT OR UPDATE OF p_known ON public.user_competency_mastery
  FOR EACH ROW
  WHEN (
    NEW.belief_source IN ('evidence', 'placement')
    AND (NEW.p_known >= 0.85 OR (NEW.p_known <= 0.25 AND NEW.evidence_count >= 3))
  )
  EXECUTE FUNCTION public.trigger_belief_propagation();
