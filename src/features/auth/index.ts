// Feature: Auth (login, signup, session)
// Public API — import from "@/features/auth"

export { useAuth } from "./use-auth";
export { useMyRole } from "./use-my-role";
export { useMyStats } from "./use-my-stats";
export { shouldRedirectToOnboarding } from "./onboarding-guard";
export { hubRouteForRole, shouldLeaveDashboard } from "./hub-route";
export type { HubRoute } from "./hub-route";
export { bootstrapProfile, setCurrentParcours, updateDisplayName } from "./auth.server";
export { displayNameSchema, isValidDisplayName, DISPLAY_NAME_MAX_LENGTH } from "./display-name";
