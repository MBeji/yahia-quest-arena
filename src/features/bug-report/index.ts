// Feature: Bug reports ("Signaler un bug") — beta-phase feedback channel
// Public API — import from "@/features/bug-report"

export {
  reportBug,
  listBugReports,
  getOpenBugsCount,
  resolveBugReport,
  type BugReport,
  type BugReportStatus,
} from "./bug-report.server";
export { BetaBadge } from "./components/beta-badge";
export { BugReportLauncher } from "./components/bug-report-launcher";
export { BugReportsAdmin } from "./components/bug-reports-admin";
