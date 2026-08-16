// Feature: Parent Report (family link + progress reports)
// Public API — import from "@/features/parent-report"

export {
  getLinkedStudents,
  getStudentAttemptDetail,
  getStudentDailyReport,
  getStudentReport,
  getStudentReportByCode,
  getStudentWeeklyGoal,
  linkStudentByCode,
  setStudentWeeklyGoal,
} from "./parent-report.server";
export { formatStudentAllianceCode, parseStudentAllianceCode } from "./family-link";
export { parentCodeErrorLabel, type ParentCodeErrorCode } from "./parent-code-errors";
export {
  forgetRememberedCode,
  readRememberedCode,
  rememberCode,
  SUIVI_CODE_STORAGE_KEY,
} from "./remembered-code";
export { ReportContent } from "./components/report-content";
export { DailyDashboard } from "./components/daily-dashboard";
export { buildFamilyReportShareText, buildWeeklyAdvice } from "./report-share";
// Le moteur d'analyse (pur) reste importable à part pour les tests et pour une
// future couche d'insights : `@/features/parent-report/insights`.
export {
  buildAlerts,
  computeEfficiency,
  computeEngagement,
  deriveKpis,
  resolvePeriod,
  type DailyReport,
  type ParentAlert,
  type PeriodPresetKey,
} from "./insights";
