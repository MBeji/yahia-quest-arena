// Barrel PUBLIC de l'étage IA — étude 29 lot 1.
//
// ⚠️ CE BARREL EST ISOMORPHE, ET C'EST UN INVARIANT DE SÉCURITÉ.
//
// Il ne réexporte QUE des types, des codes d'erreur et des fonctions pures. Les
// modules `.server.ts` (adaptateurs, coffre, sortie réseau) sont importés
// DIRECTEMENT par le code serveur qui en a besoin — jamais d'ici. Même posture
// que `notifications/index.ts`, qui garde `notifications.cron.server.ts` hors du
// barrel parce qu'il importe `web-push`.
//
// Ce que cet invariant achète : le SDK `@anthropic-ai/sdk` et `node:https` ne
// peuvent pas entrer dans un bundle client par le seul fait qu'un composant a
// importé un type depuis « l'IA ». `build:check` le mesure, et
// `__tests__/barrel-is-isomorphic.test.ts` le prouve par lecture du module —
// pas par confiance.

export {
  AI_ERROR_CODES,
  AiError,
  aiErrorFromStatus,
  asAiErrorCode,
  isRetryableStatus,
  toAiError,
  type AiErrorCode,
} from "./errors";

export {
  estimateCostMicros,
  estimateTokens,
  hasKnownPrice,
  microsToUsd,
  priceFor,
  settledCostMicros,
  usdToMicros,
} from "./pricing";

export {
  cacheBoundaryIndex,
  renderBlocks,
  sealSecret,
  revealSecret,
  type AiBlock,
  type AiCapabilities,
  type AiChunk,
  type AiCredential,
  type AiProvider,
  type AiRequest,
  type AiResult,
  type AiUsage,
  type OpaqueSecret,
} from "./types";
