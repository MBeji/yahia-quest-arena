// Feature: Parent Report (family link + progress reports)
// Public API — import from "@/features/parent-report"

export {
  getLinkedStudents,
  getStudentAttemptDetail,
  getStudentAttemptDetailByCode,
  getStudentDailyGoal,
  getStudentDailyReport,
  getStudentDailyReportByCode,
  getStudentExamSummary,
  getStudentParcoursComparison,
  getStudentPlacementSummary,
  getStudentReport,
  getStudentReportByCode,
  getStudentWeeklyGoal,
  getTutorParentCounters,
  linkStudentByCode,
  setStudentDailyGoal,
  setStudentWeeklyGoal,
  type TutorParentCounters,
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
// Bilan et programme du jour de l'enfant (commande du 2026-11-22) : la section porte sa
// lecture et son écriture ; la route authentifiée la place dans `ReportContent` par un slot.
export { StudyReportSection } from "./components/study-report-section";
export { DailyDashboard } from "./components/daily-dashboard";
export { reportSourceKey, type ReportSource } from "./report-source";
export { buildFamilyReportShareText, buildWeeklyAdvice, shareFamilyReport } from "./report-share";
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
