// Feature: Dashboard
// Public API — import from "@/features/dashboard"

export {
  getDashboard,
  getDashboardSecondary,
  getLeaderboard,
  getLeaderboardSubjects,
  getParcours,
  getSprint2Dashboard,
  getSubjectLeaderboard,
} from "./dashboard.server";
export {
  getMyParcoursInterests,
  getParcoursInterestCounts,
  toggleParcoursInterest,
  type ParcoursInterestCount,
} from "./parcours-interest.server";
export {
  formatObjectiveType,
  formatQuestType,
  resolveDailyAction,
  resolveWeeklyAction,
} from "./dashboard-helpers";
export { ParcoursInterestButton } from "./components/parcours-interest-button";
export { ParcoursInterestAdmin } from "./components/parcours-interest-admin";
export { FlagshipBanner } from "./components/flagship-banner";
export { FlagshipConcoursBanner } from "./components/flagship-concours-banner";
export { FlagshipCrown } from "./components/flagship-crown";
// NOTE: ProgramHub is intentionally NOT re-exported here — it pulls in `motion`
// (~350 kB). Import it directly from "@/features/dashboard/components/program-hub"
// so the barrel (consumed by many server-fn callers) stays light.
export { useParcoursInterest, type ParcoursInterestState } from "./use-parcours-interest";
export { buildPrograms, flagshipConcours, PROGRAM_FAMILIES, CYCLE_ORDER } from "./program-families";
export type { Program, ProgramParcours, ProgramKind } from "./program-families";
