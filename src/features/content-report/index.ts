// Feature: Content error reports ("Signaler une erreur")
// Public API — import from "@/features/content-report"

export {
  reportContentError,
  listContentReports,
  getOpenReportsCount,
  resolveContentReport,
  type ContentReport,
  type ContentReportStatus,
} from "./content-report.server";
export { ReportErrorButton } from "./components/report-error-button";
export { ContentReportsAdmin } from "./components/content-reports-admin";
