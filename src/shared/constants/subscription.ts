// Premium subscription plans + admin contact — single source of truth.
// Durations are mirrored in SQL (admin_set_subscription); keep both in sync.

export type SubscriptionType = "monthly" | "quarterly" | "annual";

/** Phone number a student calls to purchase a subscription from the admin. */
export const ADMIN_CONTACT_PHONE = "+216 55 447 504";

/** Currency unit shown next to prices (Tunisian dinar). */
export const SUBSCRIPTION_CURRENCY = "DT";

export type SubscriptionPlan = {
  type: SubscriptionType;
  /** Price in Tunisian dinars. */
  priceTnd: number;
  /** Plan duration in months. */
  months: number;
};

export const SUBSCRIPTION_PLANS: readonly SubscriptionPlan[] = [
  { type: "monthly", priceTnd: 19, months: 1 },
  { type: "quarterly", priceTnd: 40, months: 3 },
  { type: "annual", priceTnd: 99, months: 12 },
] as const;

/** The valid subscription type values (e.g. for input validation). */
export const SUBSCRIPTION_TYPES = ["monthly", "quarterly", "annual"] as const;

// --- Beta tester free premium access ---

/** Status of a beta access request. */
export type BetaRequestStatus = "pending" | "approved" | "rejected";

/**
 * Free premium duration (months) granted when an admin approves a beta request.
 * Mirrored in SQL (admin_review_beta_request INTERVAL); keep both in sync.
 */
export const BETA_ACCESS_MONTHS = 3;
