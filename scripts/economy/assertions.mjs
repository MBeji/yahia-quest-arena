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
import { shopCapacityCoins } from "./shop-catalogue.mjs";

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
  //
  // ⚠️ CE GARDE-FOU NE MESURAIT PAS LA BOUTIQUE, et son propre commentaire le
  // disait : « le seul puits modélisé ici est le RACHAT DE SÉRIE ». Il rendait
  // donc 100 % — non parce que la boutique draine, mais parce qu'un rachat à
  // 15 coins peut absorber presque tous les coins d'un élève. Autrement dit
  // G-3 récompensait un rachat BON MARCHÉ, pendant que G-4 en exige un CHER :
  // les deux lisaient LE MÊME NOMBRE en sens inverse (#937).
  //
  // Il lit désormais le CATALOGUE, dans les migrations qui le seedent.
  //
  // Le rachat de série en est volontairement EXCLU, et c'est tout le correctif :
  // il est RÉPÉTABLE, donc sa capacité d'absorption est infinie, donc l'inclure
  // faisait passer G-3 quoi qu'il arrive. Un puits sans fond n'est pas un puits.
  //
  // ⚠️ CE QUE ÇA MESURE, ET RIEN DE PLUS : une CAPACITÉ, pas un comportement.
  // On ne sait pas ce qu'un élève achète, et l'inventer pour faire tomber un
  // chiffre serait la même faute que régler l'économie sur le test. La question
  // posée est celle que G-3 pose depuis toujours : « la monnaie a-t-elle où
  // aller ? » Il passe donc confortablement aujourd'hui (3 280 coins de
  // catalogue face à 256 gagnés en 8 semaines) — c'est un fil-piège contre une
  // régression réelle (une boutique vidée, des récompenses qui s'envolent), pas
  // une mesure fine de l'équilibrage.
  const capacite = shopCapacityCoins();
  const ratio = moyen.coinsEarned > 0 ? Math.min(1, capacite / moyen.coinsEarned) : null;
  const ok3 = ratio !== null && ratio >= GUARDRAILS.G3.minSinkRatio;
  out.push({
    id: "G-3",
    ok: ok3,
    message:
      ratio === null
        ? `le persona MOYEN ne gagne aucun coin en ${moyen.weeks.length} semaines — il n'y a pas d'économie à équilibrer.`
        : ok3
          ? `la boutique peut absorber ${Math.round(ratio * 100)} % des ${moyen.coinsEarned} coins gagnés (${capacite} coins de catalogue, plancher ${Math.round(GUARDRAILS.G3.minSinkRatio * 100)} %)`
          : `la boutique ne peut absorber que ${Math.round(ratio * 100)} % des ${moyen.coinsEarned} coins gagnés (${capacite} coins de catalogue) : ils s'accumulent, et une monnaie qu'on ne dépense pas cesse d'être une récompense.`,
  });

  // ---- G-4 : le RACHAT DE SÉRIE ne rend pas la série triviale ----
  // Ce garde-fou a longtemps dit « shield » en mesurant le rachat. La confusion
  // n'est pas cosmétique : elle a envoyé une enquête chercher le prix d'un item
  // qui en coûte 250 (`bouclier_flamme`) alors que le nombre mesuré ici est
  // `STREAK_RECOVERY_COST`.
  //
  // Depuis que G-3 lit la boutique, G-4 gouverne SEUL le prix du rachat : plus
  // de contre-pression, donc plus de fenêtre à trous à calculer — une borne
  // basse suffit, et elle se lit d'un coup d'œil.
  const coverage = moyen.daysMissed > 0 ? moyen.recoveryCoverableDays / moyen.daysMissed : 0;
  const ok4 = coverage <= GUARDRAILS.G4.maxRecoveryCoverage;
  // Les deux bornes se calculent sur le MÊME arrondi que la mesure. `coverage`
  // vaut `floor(C / k) / D` : le numérateur est entier, donc la condition
  // `coverage <= M` équivaut à `floor(C / k) <= floor(D * M)`. Raisonner en
  // continu donne des nombres faux — 40 au lieu de 37 sur les valeurs du jour.
  const maxJoursRachetables = Math.floor(moyen.daysMissed * GUARDRAILS.G4.maxRecoveryCoverage);
  const rendementMax = (maxJoursRachetables + 1) * STREAK_RECOVERY_COST - 1;
  out.push({
    id: "G-4",
    ok: ok4,
    message: ok4
      ? `le rachat de série couvrirait ${Math.round(coverage * 100)} % des ${moyen.daysMissed} jours manqués (plafond ${Math.round(GUARDRAILS.G4.maxRecoveryCoverage * 100)} %) — marge : tient tant que le rendement reste ≤ ${rendementMax} coins, mesuré ${moyen.coinsEarned}`
      : `le rachat de série couvrirait ${Math.round(coverage * 100)} % des ${moyen.daysMissed} jours manqués : la série s'achète, donc elle ne mesure plus l'assiduité. ${phrasePrixMinimum(moyen)}`,
  });

  return out;
}

/**
 * LE PRIX MINIMUM auquel G-4 tiendrait, sur les valeurs mesurées du persona moyen.
 *
 * ⚠️ CE N'EST PAS UNE CONSIGNE, et la nuance a coûté assez cher pour être écrite :
 * l'étude interdit de régler `gamification.ts` pour faire passer un test, et de
 * caler un seuil sur la mesure du jour. Ce nombre dit seulement OÙ est la borne,
 * pour qu'un rouge soit une décision instruite plutôt qu'un rouge.
 *
 * Le calcul suit le même arrondi que la mesure : G-4 tient dès que
 * `floor(C / k) <= floor(D * M)`, donc dès que `k > C / (floor(D * M) + 1)`.
 *
 * @param {ReturnType<import("./simulate.mjs").simulate>} moyen
 * @returns {number}
 */
export function prixMinimumPourG4(moyen) {
  const maxJours = Math.floor(moyen.daysMissed * GUARDRAILS.G4.maxRecoveryCoverage);
  return Math.floor(moyen.coinsEarned / (maxJours + 1)) + 1;
}

/** La phrase qui remet la décision au lecteur, avec le nombre qui la borne. */
function phrasePrixMinimum(moyen) {
  return (
    `À ${STREAK_RECOVERY_COST} coins pièce, il en faudrait au moins ${prixMinimumPourG4(moyen)} pour que G-4 tienne. ` +
    `Ce n'est PAS une consigne : depuis que G-3 lit la boutique, plus rien ne pousse ce prix vers le bas, ` +
    `donc la question est enfin simple — un rachat de série à ${STREAK_RECOVERY_COST} coins est-il trop bon marché ` +
    `pour le produit ? À trancher page Économie, sur données réelles, pas ici.`
  );
}
