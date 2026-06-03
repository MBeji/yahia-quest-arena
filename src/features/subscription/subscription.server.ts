import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { failWithClientError } from "@/shared/lib/safe-error";
import type { SubscriptionType } from "@/shared/constants/subscription";
import { isSubscriptionActive, type SubscriptionState } from "./subscription";

const SUB_LOAD_ERROR_FR = "Impossible de charger les abonnements. Veuillez réessayer.";

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

/** Admin: every user with their subscription state. RPC enforces admin-only. */
export const listSubscriptions = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase } = context;
    const { data, error } = await supabase.rpc("admin_list_subscriptions");
    if (error) failWithClientError("subscription.listSubscriptions", error, SUB_LOAD_ERROR_FR);

    return {
      users: (data ?? []).map((r) => ({
        userId: r.user_id,
        displayName: r.display_name,
        email: r.email,
        role: r.role,
        type: r.subscription_type,
        activatedAt: r.subscription_activated_at,
        expiresAt: r.subscription_expires_at,
        isActive: r.is_active,
      })),
    };
  });

/** Admin: unlock (activate) a subscription for a user. RPC enforces admin-only. */
export const setSubscription = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        userId: z.string().uuid(),
        type: z.enum(["monthly", "quarterly", "annual"]),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase } = context;
    const { error } = await supabase.rpc("admin_set_subscription", {
      p_user: data.userId,
      p_type: data.type,
    });
    if (error)
      failWithClientError(
        "subscription.setSubscription",
        error,
        "Impossible d'activer l'abonnement.",
      );
    return { ok: true } as const;
  });

/** Admin: block (revoke) a user's subscription. RPC enforces admin-only. */
export const clearSubscription = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ userId: z.string().uuid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;
    const { error } = await supabase.rpc("admin_clear_subscription", { p_user: data.userId });
    if (error)
      failWithClientError(
        "subscription.clearSubscription",
        error,
        "Impossible de bloquer l'abonnement.",
      );
    return { ok: true } as const;
  });
