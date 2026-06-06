import type { SubscriptionType } from "@/shared/constants/subscription";

/** Current subscription state for a user. */
export type SubscriptionState = {
  type: SubscriptionType | null;
  activatedAt: string | null;
  expiresAt: string | null;
  isActive: boolean;
};

/**
 * A subscription is active iff it has a future expiry. Mirrors the SQL
 * `has_active_subscription` so the UI and the DB agree on what "active" means;
 * access is revoked automatically once `expiresAt` passes.
 */
export function isSubscriptionActive(expiresAt: string | null, now: Date = new Date()): boolean {
  if (!expiresAt) return false;
  const ts = Date.parse(expiresAt);
  return Number.isFinite(ts) && ts > now.getTime();
}
