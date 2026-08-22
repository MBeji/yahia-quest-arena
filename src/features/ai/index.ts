// Feature: Mode IA « à la clé de la famille » (étude 29)
// Public API — import from "@/features/ai"
//
// ⚠️ `crypto.server.ts` n'est PAS réexporté ici, et ne le sera jamais : c'est le
// coffre. Il n'a qu'un seul appelant légitime (`ai-credentials.server.ts`), et
// le garder hors du barrel rend impossible qu'un composant l'importe « juste
// pour un type » — ce qui ferait entrer `node:crypto` dans le graphe du client.
// Même posture que `notifications.cron.server.ts` (é24).

export {
  getAiModeStatus,
  markCredentialState,
  revokeAiCredential,
  setAiCredential,
  setAiPreferences,
} from "./ai-credentials.server";

export {
  AI_MODE_ERROR_PREFIX,
  aiErrorLabel,
  aiModeErrorCode,
  type AiCredentialStatus,
  type AiCredentialView,
  type AiModeStatus,
} from "./ai-mode-status";

export { AiModeSection } from "./components/ai-mode-section";
