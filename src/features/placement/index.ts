// Feature: Placement — le test de niveau (étude 39)
// Public API — import from "@/features/placement"
//
// Les composants ne passent PAS par ce barrel : ils s'importent en profondeur
// (`@/features/placement/components/...`) pour qu'une route qui n'affiche que l'entrée ne tire
// pas le bilan, et qu'une carte du Hall chargée en `lazy()` ne tire pas la couche serveur.

export {
  startPlacementSession,
  finishPlacementSession,
  getPlacementSession,
  claimPlacementSessions,
  getMyPlacementOverview,
  listPlacementSubjects,
  getPlacementSubject,
  placementErrorCode,
  type PlacementBilan,
  type PlacementOverview,
  type PlacementRunning,
  type PlacementServedQuestion,
  type PlacementSession,
  type PlacementStarted,
  type PlacementSubject,
  type PlacementSubjectCard,
  type PlacementTestableSubject,
} from "./placement.server";
export {
  clearPlacementDraft,
  forgetPlacements,
  lastFinishedPlacement,
  readRememberedPlacements,
  rememberPlacement,
  rememberedToken,
  rememberedTokens,
  type RememberedPlacement,
} from "./placement-memory";
export {
  bandCopy,
  buildShareText,
  formatScoreOn20,
  placementEntrySearch,
  placementShareUrl,
  sharePlacementText,
  splitChapters,
} from "./placement-bilan";
export { useClaimPlacementSessions } from "./use-claim-placement-sessions";
