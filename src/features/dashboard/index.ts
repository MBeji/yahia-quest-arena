// Feature: Dashboard
// Public API — import from "@/features/dashboard"

export {
  getDashboard,
  getDashboardSecondary,
  getLeaderboard,
  getLeaderboardSubjects,
  getMyFamilyGoal,
  getParcours,
  getParcoursSubjects,
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
// NOTE: ProgramHub is intentionally NOT re-exported here — it pulls in `motion`
// (~350 kB). Import it directly from "@/features/dashboard/components/program-hub"
// so the barrel (consumed by many server-fn callers) stays light.
export { useParcoursInterest, type ParcoursInterestState } from "./use-parcours-interest";
export {
  buildPrograms,
  buildLyceeYears,
  lyceeYearOf,
  PROGRAM_FAMILIES,
  CYCLE_ORDER,
  LYCEE_SECTION_YEARS,
} from "./program-families";
export type {
  Program,
  ProgramParcours,
  ProgramKind,
  LyceeYear,
  LyceeYearGroup,
} from "./program-families";
