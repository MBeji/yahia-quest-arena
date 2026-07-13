import type { DuelState } from "./duel.server";

/** The recap verdict for a settled duel. */
export type DuelOutcome = "resultWin" | "resultLoss" | "resultDraw" | "resultPending";

/**
 * Verdict from the settled state (mirrors finalize_duel's win/draw/forfait). Kept
 * out of the component file so it can be unit-tested and shared without tripping
 * react-refresh's only-export-components rule.
 */
export function computeOutcome(state: DuelState): DuelOutcome {
  if (state.status !== "finished" && state.status !== "expired") return "resultPending";
  const opp = state.opponentScore;
  if (opp == null) {
    // Expired with no opponent result: the finisher wins by forfait, else no result.
    return state.myAnswered >= state.total && state.total > 0 ? "resultWin" : "resultPending";
  }
  if (state.myScore > opp) return "resultWin";
  if (state.myScore < opp) return "resultLoss";
  return "resultDraw";
}
