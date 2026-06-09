// Premium access (per-parcours entitlements) + admin contact — single source of truth.
// Premium is sold per Concours parcours (see PREMIUM_PARCOURS_IDS); access is granted
// out-of-band by the admin as an entitlement — there are no time-based subscription plans.

/** Phone number a student calls to purchase premium parcours access from the admin. */
export const ADMIN_CONTACT_PHONE = "+216 55 447 504";

// --- Per-parcours entitlements (premium access is now granted per parcours) ---

/**
 * How an entitlement was acquired. Mirrors the `p_source` enum the
 * `admin_grant_parcours` RPC accepts (and the `source` column it writes).
 */
export type ParcoursEntitlementSource = "purchase" | "beta" | "gift" | "family";

/** The valid entitlement source values (e.g. for input validation). */
export const PARCOURS_ENTITLEMENT_SOURCES = ["purchase", "beta", "gift", "family"] as const;

/** The two premium concours parcours. The flagship is the first one. */
export const PREMIUM_PARCOURS_IDS = ["concours-9eme", "concours-6eme"] as const;

/** The flagship premium parcours — the default target for a beta grant. */
export const FLAGSHIP_PARCOURS_ID = "concours-9eme";

// --- Beta tester free premium access ---

/** Status of a beta access request. */
export type BetaRequestStatus = "pending" | "approved" | "rejected";

/**
 * Free premium duration (months) granted when an admin approves a beta request.
 * Mirrored in SQL (admin_review_beta_request INTERVAL); keep both in sync.
 */
export const BETA_ACCESS_MONTHS = 3;
