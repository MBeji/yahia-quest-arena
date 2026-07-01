// Feature: Parent Report (family link + progress reports)
// Public API — import from "@/features/parent-report"

export {
  getLinkedStudents,
  getStudentReport,
  getStudentWeeklyGoal,
  linkStudentByCode,
  setStudentWeeklyGoal,
} from "./parent-report.server";
export { formatStudentAllianceCode, parseStudentAllianceCode } from "./family-link";
export { ReportContent } from "./components/report-content";
