// Feature: Subscription (premium gating + admin management)
// Public API — import from "@/features/subscription"

export {
  getMySubscription,
  listSubscriptions,
  setSubscription,
  clearSubscription,
} from "./subscription.server";
export { isSubscriptionActive, type SubscriptionState } from "./subscription";
export { SubscriptionPaywall } from "./components/subscription-paywall";
export {
  SubscriptionAdminTable,
  type AdminSubscriptionUser,
} from "./components/subscription-admin-table";
