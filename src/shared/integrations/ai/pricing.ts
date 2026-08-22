// Estimation de dépense — étude 29 §3.7 et R-12.
//
// CE QUE CE MODULE PRÉTEND, ET CE QU'IL NE PRÉTEND PAS
// ---------------------------------------------------------------------------
// Il calcule une ESTIMATION, et l'étude interdit de la présenter autrement : la
// facture qui fait foi est celle du fournisseur (R-12, D-12). Aucun compteur
// d'ici ne fait autorité devant un relevé bancaire, et la console le dit en
// permanence — pas en note de bas de page.
//
// Deux moments, deux fonctions :
//   * AVANT l'appel — `estimateCostMicros()` : entrée estimée + `maxTokens` de
//     sortie au tarif plein. Volontairement PESSIMISTE : elle sert à décider si
//     l'appel a le droit d'être émis (R-11), et se tromper vers le bas livrerait
//     la facture surprise que toute l'étude cherche à rendre impossible.
//   * APRÈS l'appel — `settledCostMicros()` : les tokens réellement rapportés
//     par le fournisseur. C'est ce montant qui remplace la réservation.
//
// Tout est compté en MICRO-DOLLARS ENTIERS : un compteur d'argent en flottant
// dérive, et une comparaison à un plafond doit être exacte.

import {
  AI_MODEL_PRICES,
  AI_UNKNOWN_MODEL_PRICE,
  MICROS_PER_USD,
  type AiModelPrice,
} from "@/shared/constants/ai";

/**
 * Le prix d'un modèle. Un modèle absent de la grille est facturé au tarif de
 * repli — **jamais à zéro** : un prix inconnu ne doit pas ouvrir une vanne
 * (§3.7). C'est la conséquence directe de Q-4 (l'adresse, donc le modèle, est
 * libre) : nous ne connaîtrons jamais tous les modèles branchés.
 */
export function priceFor(model: string): AiModelPrice {
  return AI_MODEL_PRICES[model] ?? AI_UNKNOWN_MODEL_PRICE;
}

/** Un modèle est-il dans la grille datée ? Sert à afficher « estimation approchée ». */
export function hasKnownPrice(model: string): boolean {
  return model in AI_MODEL_PRICES;
}

/** Tokens × ($/MTok) → micro-dollars, arrondi au SUPÉRIEUR (on ne sous-facture jamais un plafond). */
function tokensToMicros(tokens: number, perMTokUsd: number): number {
  if (tokens <= 0 || perMTokUsd <= 0) return 0;
  return Math.ceil((tokens * perMTokUsd * MICROS_PER_USD) / 1_000_000);
}

/**
 * Estimation AVANT appel : `tokens_in_estimés × prix_in + maxTokens × prix_out`
 * (§3.7). Les tokens d'entrée estimés sont ceux du contexte assemblé ; la sortie
 * est prise à son plafond, parce qu'on ne sait pas encore ce que le modèle
 * écrira et que le plafond est le pire cas réel.
 */
export function estimateCostMicros(args: {
  model: string;
  estimatedInputTokens: number;
  maxOutputTokens: number;
}): number {
  const price = priceFor(args.model);
  return (
    tokensToMicros(args.estimatedInputTokens, price.inputPerMTokUsd) +
    tokensToMicros(args.maxOutputTokens, price.outputPerMTokUsd)
  );
}

/** Coût APRÈS appel, depuis l'usage rapporté par le fournisseur. */
export function settledCostMicros(args: {
  model: string;
  inputTokens: number;
  outputTokens: number;
  cachedTokens?: number;
}): number {
  const price = priceFor(args.model);
  return (
    tokensToMicros(args.inputTokens, price.inputPerMTokUsd) +
    tokensToMicros(args.outputTokens, price.outputPerMTokUsd) +
    tokensToMicros(args.cachedTokens ?? 0, price.cachedInputPerMTokUsd)
  );
}

/**
 * Estimation grossière du nombre de tokens d'un texte, SANS appel réseau.
 *
 * Le comptage exact est une requête payante chez chaque fournisseur, et nous en
 * avons besoin AVANT de décider si l'appel a le droit d'être émis — l'appeler
 * reviendrait à dépenser pour savoir si on a le droit de dépenser. Le ratio
 * retenu (≈ 3,6 caractères par token) est délibérément BAS, donc l'estimation
 * est haute : la réservation surestime, le solde réel la corrige (§3.7).
 *
 * L'arabe et le français accentué produisent plus de tokens par caractère que
 * l'anglais ; le ratio bas les couvre au lieu de les sous-estimer.
 */
export function estimateTokens(text: string): number {
  if (!text) return 0;
  return Math.ceil(text.length / 3.6);
}

/** Micro-dollars → dollars, pour l'affichage seul. Jamais pour une comparaison à un plafond. */
export function microsToUsd(micros: number): number {
  return micros / MICROS_PER_USD;
}

/** Dollars → micro-dollars entiers. Sert à convertir un plafond saisi par le porteur. */
export function usdToMicros(usd: number): number {
  return Math.round(usd * MICROS_PER_USD);
}
