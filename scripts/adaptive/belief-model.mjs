/**
 * Le modèle de croyance, en JavaScript — un PORT, pas une seconde vérité.
 *
 * ⚠️ La référence normative est le SQL : `belief_guess`, `belief_slip` et `belief_update`
 * de `supabase/migrations/20260825100000_belief_foundation.sql` (étude 30 §3.2). Ce module
 * n'existe que parce que la calibration (KPI-3) doit REJOUER l'historique hors de la base :
 * `question_attempts` n'enregistre pas la croyance qui avait cours au moment de la réponse,
 * et sans elle il n'y a rien à calibrer. Les fonctions SQL, elles, sont `REVOKE`d de tout
 * rôle client — donc injoignables depuis un script.
 *
 * LE RISQUE, ET CE QUI LE TIENT. Deux implémentations d'un même modèle dérivent. La parade
 * n'est pas une promesse : c'est que les deux sont épinglées à LA MÊME table de vérité —
 * l'annexe A de l'étude — par deux suites qui asservissent les mêmes nombres :
 * `supabase/tests/75_adaptive_belief.test.sql` d'un côté, `__tests__/belief-model.test.mjs`
 * de l'autre. Une dérive fait rougir l'une des deux.
 */

/** Bornes de la croyance (R-1) : la certitude absolue n'est pas un état atteignable. */
export const P_MIN = 0.01;
export const P_MAX = 0.99;

/** Arrondi à 4 décimales, comme le `ROUND(..., 4)` du SQL. */
function round4(value) {
  return Math.round(value * 1e4) / 1e4;
}

/**
 * p(G) — le hasard est la GÉOMÉTRIE de l'item (D-2), jamais un paramètre d'auteur.
 *
 * @param {string|null|undefined} questionType type natif de la question
 * @param {number|null|undefined} optionCount nombre d'options (QCM seulement)
 * @param {string|null|undefined} variant `'recall'` (é17) ou `'classic'`
 * @returns {number} la probabilité de tomber juste sans savoir
 */
export function beliefGuess(questionType, optionCount, variant) {
  if (variant === "recall") return 0.02;
  switch (questionType) {
    case "short_answer":
      return 0.02;
    case "numeric":
    case "ordering":
    case "matching":
      return 0.05;
    case "multi":
      return 0.08;
    case "mcq": {
      const k = Math.max(optionCount ?? 4, 2);
      return round4(Math.min(0.3, Math.max(0.15, 1 / k)));
    }
    default:
      return 0.25;
  }
}

/**
 * p(S) — l'inattention décroît avec la difficulté (D-2), et monte au plafond de R-3 sous
 * signal de charge (lot 6, différé : les appelants d'aujourd'hui passent `false`).
 *
 * @param {number|null|undefined} difficulty palier 1-4 de l'exercice porteur
 * @param {boolean} underLoad un signal de charge est-il actif
 * @returns {number} la probabilité de rater ce qu'on sait
 */
export function beliefSlip(difficulty, underLoad) {
  if (underLoad) return 0.2;
  switch (difficulty ?? 2) {
    case 1:
      return 0.1;
    case 3:
      return 0.06;
    case 4:
      return 0.05;
    default:
      return 0.08;
  }
}

/**
 * Une observation BKT, pondérée par le poids de la preuve (R-21).
 *
 * @param {number} prior croyance avant l'observation
 * @param {boolean} correct l'élève a-t-il répondu juste
 * @param {number} guess p(G)
 * @param {number} slip p(S)
 * @param {number} transit p(T)
 * @param {number} [weight=1] le poids de la preuve — 1 sans aide, 0,5 après aide légère
 * @returns {number} la croyance après, bornée [0,01 ; 0,99]
 */
export function beliefUpdate(prior, correct, guess, slip, transit, weight = 1) {
  const denominator = correct
    ? prior * (1 - slip) + (1 - prior) * guess
    : prior * slip + (1 - prior) * (1 - guess);
  // Un item dégénéré n'informe pas : ne rien apprendre est la seule réponse honnête.
  const after =
    denominator === 0
      ? prior
      : (() => {
          const posterior = (correct ? prior * (1 - slip) : prior * slip) / denominator;
          return posterior + (1 - posterior) * transit;
        })();
  const weighted = prior + (weight ?? 1) * (after - prior);
  return Math.min(P_MAX, Math.max(P_MIN, round4(weighted)));
}

/**
 * P(réussite) prédite AVANT de servir l'item (§3.4, annexe A.5) : `p·(1−S) + (1−p)·G`.
 * C'est ce que le sélecteur du lot 3 vise dans la ZPD — et, ici, ce qu'on confronte au
 * résultat observé pour savoir si le modèle ment poliment.
 *
 * @param {number} belief la croyance courante
 * @param {number} guess p(G)
 * @param {number} slip p(S)
 * @returns {number} la probabilité de réussite prédite
 */
export function predictedSuccess(belief, guess, slip) {
  return round4(belief * (1 - slip) + (1 - belief) * guess);
}
