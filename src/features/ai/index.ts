// Feature: Mode IA « à la clé de la famille » (étude 29)
// Public API — import from "@/features/ai"
//
// ⚠️ `crypto.server.ts` n'est PAS réexporté ici, et ne le sera jamais : c'est le
// coffre. Il n'a qu'un seul appelant légitime (`ai-credentials.server.ts`), et
// le garder hors du barrel rend impossible qu'un composant l'importe « juste
// pour un type » — ce qui ferait entrer `node:crypto` dans le graphe du client.
// Même posture que `notifications.cron.server.ts` (é24).

export {
  AI_ACTIVATABLE_FEATURES,
  getAiStudentSurfaces,
  getAiStudents,
  setAiStudentAccess,
  type AiStudentAccess,
} from "./ai-access.server";

export {
  forgeQuiz,
  getForgedQuiz,
  gradeForgedQuiz,
  listForgeableChapters,
  listForgedQuizzes,
  type ForgeableChapter,
  type ForgedQuizResult,
  type ForgedQuizSummary,
  type ForgeResult,
  type ServedForgedQuiz,
} from "./forge.server";

export { AiLauncher } from "./components/ai-launcher";
export { ForgeEntry } from "./components/forge-entry";
export { ForgePanel } from "./components/forge-panel";

export {
  callAi,
  streamAi,
  type AiCallOutcome,
  type AiCallRequest,
  type AiStreamChunk,
} from "./ai-call.server";

export { notifyBudgetAlerts } from "./ai-alerts.server";

export {
  dominantModel,
  getAiAdminOverview,
  getAiConsole,
  modelAdviceFor,
  setAiModeEnabled,
  setAiOwnerSuspension,
  submitAiFeedback,
  type AiAdminOverview,
  type AiConsole,
} from "./ai-console.server";

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
