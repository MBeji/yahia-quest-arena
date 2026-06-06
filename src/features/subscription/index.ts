// Feature: Subscription (premium gating + admin management)
// Public API — import from "@/features/subscription"

export {
  getMySubscription,
  listSubscriptions,
  setSubscription,
  clearSubscription,
} from "./subscription.server";
export { isSubscriptionActive, type SubscriptionState } from "./subscription";
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
  SubscriptionAdminTable,
  type AdminSubscriptionUser,
} from "./components/subscription-admin-table";
