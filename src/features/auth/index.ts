// Feature: Auth (login, signup, session)
// Public API — import from "@/features/auth"

export { useAuth } from "./use-auth";
export { useMyRole } from "./use-my-role";
export { useMyStats } from "./use-my-stats";
export { shouldRedirectToOnboarding } from "./onboarding-guard";
export { hubRouteForRole, shouldLeaveDashboard } from "./hub-route";
export type { HubRoute } from "./hub-route";
export {
  bootstrapProfile,
  setCurrentParcours,
  updateDisplayName,
  deleteAccount,
  exportUserData,
  setProfileLocale,
} from "./auth.server";
export { useProfileLocaleSync } from "./use-locale-sync";
export { displayNameSchema, isValidDisplayName, DISPLAY_NAME_MAX_LENGTH } from "./display-name";
export {
  ACCOUNT_DELETE_ERROR_PREFIX,
  accountDeleteErrorLabel,
  confirmsAccountEmail,
  normalizeAccountEmail,
} from "./account-deletion";
export type { AccountDeleteErrorCode } from "./account-deletion";
export { countExportedRows, userDataExportFileName } from "./data-export";
export type { UserDataExport, UserDataExportNote } from "./data-export";
