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

/**
 * G-1 : une fenêtre PAR PROFIL (arbitrage A15, 2026-08-24).
 *
 * Il n'y en avait qu'une — 7 à 14 jours — et elle échouait **des deux côtés**.
 * Mesures du 2026-08-24 : l'assidu atteignait le niveau 5 au **jour 6**, le moyen
 * au **jour 31**, l'occasionnel **jamais** en 8 semaines. Une fenêtre unique ne
 * peut pas décrire trois rythmes qui vont de 6 à 24 jours actifs sur la même
 * période : à 3 séances par semaine, 800 XP demandent environ cinq semaines, donc
 * le seuil de 14 jours était **arithmétiquement hors d'atteinte** pour le persona
 * cible. Un garde-fou qui échoue par construction cesse d'être lu.
 *
 * ⚠️ **Le piège qu'on évite ici est l'image en miroir de celui de l'en-tête.**
 * Retoucher `gamification.ts` pour faire passer le test est interdit ; caler les
 * seuils sur la mesure du jour ne vaut pas mieux — ce serait décrire l'économie
 * actuelle et appeler ça un garde-fou. Ces fenêtres disent donc une INTENTION
 * sur l'expérience de chaque profil, et il se trouve qu'elles passent aujourd'hui.
 * Elles restent des hypothèses à corriger sur données réelles, comme les autres.
 *
 * - `assidu` — 5 à 14 j. En deçà de 5, les paliers sont décoratifs pour qui joue
 *   beaucoup ; au-delà de 14, même le plus engagé n'a rien touché en deux semaines.
 * - `moyen` — 14 à 35 j. La première vraie récompense doit tomber dans le mois :
 *   au-delà, on sort du rythme d'un trimestre scolaire.
 * - `occasionnel` — **non jugé**, et c'est dit plutôt que tu. Une séance par
 *   semaine sur un horizon de 8 semaines ne permet aucune conclusion : lui poser
 *   un seuil n'encoderait que la durée de la simulation.
 */
export const GUARDRAILS = {
  G1: {
    assidu: { minDays: 5, maxDays: 14 },
    moyen: { minDays: 14, maxDays: 35 },
    occasionnel: null,
  },
  G2: { maxXpPerDay: 1000 },
  G3: { minSinkRatio: 0.6 },
  G4: { maxRecoveryCoverage: 0.2 },
};

/**
 * @param {Record<string, ReturnType<import("./simulate.mjs").simulate>>} runs
 * @returns {Array<{ id: string, ok: boolean, message: string }>}
 */
export function checkGuardrails(runs) {
  const out = [];
  const moyen = runs.moyen;
  const assidu = runs.assidu;

  // ---- G-1 : la courbe n'est ni trop rapide ni décourageante, PAR PROFIL ----
  for (const [persona, window] of Object.entries(GUARDRAILS.G1)) {
    if (window === null) {
      out.push({
        id: `G-1/${persona}`,
        ok: true,
        message: `non jugé — une séance par semaine sur ${runs[persona]?.weeks.length ?? "?"} semaines ne permet aucune conclusion (voir GUARDRAILS.G1).`,
      });
      continue;
    }
    const run = runs[persona];
    if (!run) continue;
    const day5 = run.levelFiveDay;
    if (day5 === null) {
      out.push({
        id: `G-1/${persona}`,
        ok: false,
        message: `n'atteint jamais le niveau 5 (${LEVEL_FIVE_XP} XP) en ${run.weeks.length} semaines — il finit à ${run.xpTotal} XP, niveau ${run.level}. Une courbe qu'on n'atteint pas décourage avant de récompenser.`,
      });
      continue;
    }
    const ok = day5 >= window.minDays && day5 <= window.maxDays;
    out.push({
      id: `G-1/${persona}`,
      ok,
      message: ok
        ? `niveau 5 atteint au jour ${day5} (fenêtre ${window.minDays}-${window.maxDays})`
        : day5 < window.minDays
          ? `niveau 5 atteint au jour ${day5}, soit AVANT le jour ${window.minDays} : la courbe monte trop vite, les paliers ne veulent plus rien dire.`
          : `niveau 5 atteint au jour ${day5}, soit APRÈS le jour ${window.maxDays} : trop lent, l'élève décroche avant la première vraie récompense.`,
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
  //
  // ⚠️ PORTÉE RÉELLE, à ne pas surestimer : le seul puits modélisé ici est le
  // RACHAT DE SÉRIE, alors que `shop_items` en seede treize, de 30 à 500 coins.
  // G-3 ne dit donc rien de la boutique — il dit ce qu'un élève pourrait
  // racheter. Élargir son modèle est un arbitrage à part, pas un nettoyage.
  const affordableSinks = moyen.recoveryCoverableDays * STREAK_RECOVERY_COST;
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

  // ---- G-4 : le RACHAT DE SÉRIE ne rend pas la série triviale ----
  // Ce garde-fou a longtemps dit « shield » en mesurant le rachat. La confusion
  // n'est pas cosmétique : elle a envoyé une enquête chercher le prix d'un item
  // qui en coûte 250 (`bouclier_flamme`) alors que le nombre mesuré ici est
  // `STREAK_RECOVERY_COST`.
  const coverage = moyen.daysMissed > 0 ? moyen.recoveryCoverableDays / moyen.daysMissed : 0;
  const ok4 = coverage <= GUARDRAILS.G4.maxRecoveryCoverage;
  // Les deux bornes se calculent sur le MÊME arrondi que la mesure. `coverage`
  // vaut `floor(C / k) / D` : le numérateur est entier, donc la condition
  // `coverage <= M` équivaut à `floor(C / k) <= floor(D * M)`. Raisonner en
  // continu donne des nombres faux — 40 au lieu de 37 sur les valeurs du jour.
  const maxJoursRachetables = Math.floor(moyen.daysMissed * GUARDRAILS.G4.maxRecoveryCoverage);
  const rendementMax = (maxJoursRachetables + 1) * STREAK_RECOVERY_COST - 1;
  const prixMin = Math.floor(moyen.coinsEarned / (maxJoursRachetables + 1)) + 1;
  out.push({
    id: "G-4",
    ok: ok4,
    message: ok4
      ? `le rachat de série couvrirait ${Math.round(coverage * 100)} % des ${moyen.daysMissed} jours manqués (plafond ${Math.round(GUARDRAILS.G4.maxRecoveryCoverage * 100)} %) — marge : tient tant que le rendement reste ≤ ${rendementMax} coins, mesuré ${moyen.coinsEarned}`
      : `le rachat de série couvrirait ${Math.round(coverage * 100)} % des ${moyen.daysMissed} jours manqués : la série s'achète, donc elle ne mesure plus l'assiduité. À ${STREAK_RECOVERY_COST} coins pièce il en faudrait au moins ${prixMin} — mais un prix posé au bord du seuil n'y tient que jusqu'au prochain exercice ajouté au corpus.`,
  });

  return out;
}
