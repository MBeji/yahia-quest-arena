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
export { useParcoursInterest } from "./use-parcours-interest";
export type { ParcoursInterestState } from "./components/parcours-hub";
