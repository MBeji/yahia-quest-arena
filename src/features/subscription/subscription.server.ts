import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { failWithClientError } from "@/shared/lib/safe-error";
import type { SubscriptionType } from "@/shared/constants/subscription";
import { PARCOURS_ENTITLEMENT_SOURCES } from "@/shared/constants/subscription";
import { isSubscriptionActive, type SubscriptionState } from "./subscription";

const SUB_LOAD_ERROR_FR = "Impossible de charger les abonnements. Veuillez réessayer.";
const ENT_LOAD_ERROR_FR = "Impossible de charger les accès parcours. Veuillez réessayer.";

/** The current user's own subscription state (drives the paywall). */
export const getMySubscription = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<SubscriptionState> => {
    const { supabase, userId } = context;
    const { data, error } = await supabase
      .from("profiles")
      .select("subscription_type,subscription_activated_at,subscription_expires_at")
      .eq("id", userId)
      .maybeSingle();
    if (error) failWithClientError("subscription.getMySubscription", error, SUB_LOAD_ERROR_FR);

    return {
      // The column is DB-constrained to the plan types (CHECK), so this narrow is safe.
      type: (data?.subscription_type ?? null) as SubscriptionType | null,
      activatedAt: data?.subscription_activated_at ?? null,
      expiresAt: data?.subscription_expires_at ?? null,
      isActive: isSubscriptionActive(data?.subscription_expires_at ?? null),
    };
  });

/**
 * Admin: every live parcours entitlement (user × parcours grants). RPC enforces
 * admin-only. Premium access is now per-parcours — this lists who holds what.
 */
export const listParcoursEntitlements = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase } = context;
    const { data, error } = await supabase.rpc("admin_list_parcours_entitlements");
    if (error)
      failWithClientError("subscription.listParcoursEntitlements", error, ENT_LOAD_ERROR_FR);

    return {
      entitlements: (data ?? []).map((r) => ({
        userId: r.user_id,
        displayName: r.display_name,
        email: r.email,
        parcoursId: r.parcours_id,
        parcoursName: r.parcours_name,
        source: r.source,
        grantedAt: r.granted_at,
        expiresAt: r.expires_at,
        isActive: r.is_active,
      })),
    };
  });

/**
 * Admin: grant a user access to a parcours (upserts the live grant). RPC enforces
 * admin-only. Granting a parent's concours entitlement also covers their linked
 * children (the gate's `has_parcours_entitlement` is family-pack aware).
 *
 * Pass either an explicit `expiresAt` (ISO string, or null for a perpetual grant)
 * or a `months` convenience that is converted to an expiry from now. When neither
 * is supplied the grant is perpetual (no expiry).
 */
export const grantParcoursEntitlement = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        userId: z.string().uuid(),
        parcoursId: z.string().trim().min(1),
        source: z.enum(PARCOURS_ENTITLEMENT_SOURCES).default("purchase"),
        // An explicit expiry (ISO timestamp) or null = perpetual.
        expiresAt: z.string().datetime().nullish(),
        // Convenience: a duration in months, converted to an expiry from now.
        months: z.number().int().positive().max(120).optional(),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase } = context;
    // An explicit expiry wins; otherwise derive one from `months`; else perpetual.
    let expiry: string | null = data.expiresAt ?? null;
    if (!expiry && data.months) {
      const d = new Date();
      d.setMonth(d.getMonth() + data.months);
      expiry = d.toISOString();
    }
    const { error } = await supabase.rpc("admin_grant_parcours", {
      p_user: data.userId,
      p_parcours: data.parcoursId,
      p_source: data.source,
      ...(expiry ? { p_expires_at: expiry } : {}),
    });
    if (error)
      failWithClientError(
        "subscription.grantParcoursEntitlement",
        error,
        "Impossible d'accorder l'accès au parcours.",
      );
    return { ok: true } as const;
  });

/** Admin: revoke (soft-delete) a user's parcours entitlement. RPC enforces admin-only. */
export const revokeParcoursEntitlement = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z.object({ userId: z.string().uuid(), parcoursId: z.string().trim().min(1) }).parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase } = context;
    const { error } = await supabase.rpc("admin_revoke_parcours", {
      p_user: data.userId,
      p_parcours: data.parcoursId,
    });
    if (error)
      failWithClientError(
        "subscription.revokeParcoursEntitlement",
        error,
        "Impossible de révoquer l'accès au parcours.",
      );
    return { ok: true } as const;
  });
