// Feature: Subscription (premium gating + admin management)
// Public API — import from "@/features/subscription"

export {
  listParcoursEntitlements,
  grantParcoursEntitlement,
  revokeParcoursEntitlement,
} from "./subscription.server";
export {
  getMyBetaRequest,
  requestBetaAccess,
  listBetaRequests,
  getPendingBetaCount,
  reviewBetaRequest,
  type BetaRequest,
} from "./beta-access.server";
export { SubscriptionPaywall } from "./components/subscription-paywall";
export { BetaAccessRequest } from "./components/beta-access-request";
export { BetaRequestsAdmin } from "./components/beta-requests-admin";
export {
  ParcoursEntitlementsAdmin,
  type ParcoursEntitlementRow,
  type AdminParcoursOption,
} from "./components/parcours-entitlements-admin";
