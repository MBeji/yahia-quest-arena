// Feature: Dashboard
// Public API — import from "@/features/dashboard"

export {
  getCatalogueStats,
  getDashboard,
  getDashboardSecondary,
  getMyFamilyGoal,
  getParcours,
  getParcoursSubjects,
  getSprint2Dashboard,
} from "./dashboard.server";
export {
  getLeaderboard,
  getGradeLeaderboard,
  getLeaderboardSubjects,
  getSubjectLeaderboard,
  getWeeklyLeaderboard,
} from "./leaderboard.server";
export { getEconomyOverview, type EconomyOverview } from "./economy.server";
export {
  setDailyXpGoal,
  getDailyRing,
  DAILY_XP_GOALS,
  DAILY_GOAL_ALREADY_SET,
} from "./daily-goal.server";
export { EconomyAdmin } from "./components/economy-admin";
export {
  getEngagementOverview,
  type EngagementOverview,
  type EngagementCohort,
  type EngagementCurrWeek,
} from "./engagement.server";
export { EngagementAdmin } from "./components/engagement-admin";
export { getWeeklyRecap, type WeeklyRecap } from "./weekly-recap.server";
export { WeeklyRecapCard } from "./components/weekly-recap-card";
export { getActiveEvent, claimEventBadge, type ActiveEvent } from "./events.server";
export { EventBanner } from "./components/event-banner";
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
export type { DashboardGoalAction } from "./dashboard-helpers";
export { ParcoursInterestButton } from "./components/parcours-interest-button";
export { ParcoursInterestAdmin } from "./components/parcours-interest-admin";
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
