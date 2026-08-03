/**
 * Étude 09 lot 2 — les garde-fous G-1…G-4 (arbitrage A9, 2026-08-02).
 *
 * ⚠️ **Ces quatre nombres sont des hypothèses de départ, pas des mesures.** Ils
 * ont été ratifiés comme point de départ à corriger après la première lecture de
 * la page Économie. Un garde-fou qui casse ici pose une question — il ne prononce
 * pas un verdict. Et la réponse n'est JAMAIS de retoucher `gamification.ts` pour
 * faire passer le test : ce serait régler l'économie pour plaire à l'outil.
 *
 * Chaque garde-fou dit sa RAISON, pas seulement son seuil. Un « échec G-3 » sans
 * explication mène à changer le nombre ; « les coins s'accumulent sans puits, la
 * boutique perd sa valeur » mène à regarder la boutique.
 */

import { STREAK_RECOVERY_COST, XP_PER_LEVEL } from "../../src/shared/constants/gamification.ts";

/** Niveau 5 = 4 paliers franchis. */
export const LEVEL_FIVE_XP = 4 * XP_PER_LEVEL;

export const GUARDRAILS = {
  G1: { minDays: 7, maxDays: 14 },
  G2: { maxXpPerDay: 1000 },
  G3: { minSinkRatio: 0.6 },
  G4: { maxShieldCoverage: 0.2 },
};

/**
 * @param {Record<string, ReturnType<import("./simulate.mjs").simulate>>} runs
 * @returns {Array<{ id: string, ok: boolean, message: string }>}
 */
export function checkGuardrails(runs) {
  const out = [];
  const moyen = runs.moyen;
  const assidu = runs.assidu;

  // ---- G-1 : la courbe n'est ni trop rapide ni décourageante ----
  const day5 = moyen.levelFiveDay;
  if (day5 === null) {
    out.push({
      id: "G-1",
      ok: false,
      message: `le persona MOYEN n'atteint jamais le niveau 5 (${LEVEL_FIVE_XP} XP) en ${moyen.weeks.length} semaines — il finit à ${moyen.xpTotal} XP, niveau ${moyen.level}. Une courbe qu'on n'atteint pas décourage avant de récompenser.`,
    });
  } else {
    const ok = day5 >= GUARDRAILS.G1.minDays && day5 <= GUARDRAILS.G1.maxDays;
    out.push({
      id: "G-1",
      ok,
      message: ok
        ? `niveau 5 atteint au jour ${day5} (fenêtre ${GUARDRAILS.G1.minDays}-${GUARDRAILS.G1.maxDays})`
        : day5 < GUARDRAILS.G1.minDays
          ? `niveau 5 atteint au jour ${day5}, soit AVANT le jour ${GUARDRAILS.G1.minDays} : la courbe monte trop vite, les paliers ne veulent plus rien dire.`
          : `niveau 5 atteint au jour ${day5}, soit APRÈS le jour ${GUARDRAILS.G1.maxDays} : trop lent, l'élève décroche avant la première vraie récompense.`,
    });
  }

  // ---- G-2 : l'anti-farm borne la journée, même pour l'optimal ----
  const ok2 = assidu.maxXpInADay <= GUARDRAILS.G2.maxXpPerDay;
  out.push({
    id: "G-2",
    ok: ok2,
    message: ok2
      ? `pic à ${assidu.maxXpInADay} XP sur une journée (plafond ${GUARDRAILS.G2.maxXpPerDay})`
      : `le persona ASSIDU a farmé ${assidu.maxXpInADay} XP en une journée, au-delà de ${GUARDRAILS.G2.maxXpPerDay} : l'anti-farm (improved / tooFast / seuil 60 %) ne borne pas assez, un joueur peut s'acheter des niveaux en une session.`,
  });

  // ---- G-3 : la boutique draine ce que le jeu produit ----
  // Le simulateur ne fait pas acheter : il mesure ce que le persona POURRAIT
  // drainer au prix courant. Un ratio bas dit « rien à acheter d'assez cher ».
  const affordableSinks = moyen.shieldCoverableDays * STREAK_RECOVERY_COST;
  const ratio = moyen.coinsEarned > 0 ? affordableSinks / moyen.coinsEarned : null;
  const ok3 = ratio !== null && ratio >= GUARDRAILS.G3.minSinkRatio;
  out.push({
    id: "G-3",
    ok: ok3,
    message:
      ratio === null
        ? `le persona MOYEN ne gagne aucun coin en ${moyen.weeks.length} semaines — il n'y a pas d'économie à équilibrer.`
        : ok3
          ? `les puits absorbent ${Math.round(ratio * 100)} % des coins gagnés (plancher ${Math.round(GUARDRAILS.G3.minSinkRatio * 100)} %)`
          : `les puits n'absorbent que ${Math.round(ratio * 100)} % des ${moyen.coinsEarned} coins gagnés : ils s'accumulent, et une monnaie qu'on ne dépense pas cesse d'être une récompense.`,
  });

  // ---- G-4 : le shield ne rend pas la série triviale ----
  const coverage = moyen.daysMissed > 0 ? moyen.shieldCoverableDays / moyen.daysMissed : 0;
  const ok4 = coverage <= GUARDRAILS.G4.maxShieldCoverage;
  out.push({
    id: "G-4",
    ok: ok4,
    message: ok4
      ? `les shields couvriraient ${Math.round(coverage * 100)} % des ${moyen.daysMissed} jours manqués (plafond ${Math.round(GUARDRAILS.G4.maxShieldCoverage * 100)} %)`
      : `les shields couvriraient ${Math.round(coverage * 100)} % des ${moyen.daysMissed} jours manqués : la série s'achète, donc elle ne mesure plus l'assiduité.`,
  });

  return out;
}
