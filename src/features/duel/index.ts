// Feature: Duel (1v1 temps réel & ligues — étude 05)
// Public API — import from "@/features/duel"
// (Client components live under ./components/* and are imported by deep path so
//  the *.server.ts graph never reaches the client bundle.)

export {
  matchDuel,
  leaveDuelQueue,
  getDuelState,
  getDuelQuestions,
  submitDuelAnswer,
  getDuelHistory,
  getDuelLeague,
  getDuelLastAward,
} from "./duel.server";

export type {
  DuelState,
  DuelQuestion,
  DuelSubmitResult,
  DuelHistoryEntry,
  DuelReviewItem,
  DuelLeagueRow,
  DuelLastAward,
} from "./duel.server";
