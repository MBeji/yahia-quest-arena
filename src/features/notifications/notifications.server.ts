import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { failWithClientError } from "@/shared/lib/safe-error";

/**
 * Persist (upsert) the current user's Web Push subscription, right after the
 * browser grants permission and PushManager.subscribe() resolves. Writes go
 * through the SECURITY DEFINER `save_push_subscription` RPC — the table itself
 * is unreachable by clients (RLS enabled, no policies; see migration
 * 20260613120000_push_subscriptions.sql).
 */
export const savePushSubscription = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        endpoint: z.string().url().max(2048),
        p256dh: z.string().min(1).max(512),
        auth: z.string().min(1).max(512),
        userAgent: z.string().max(512).optional(),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase } = context;
    const { error } = await supabase.rpc("save_push_subscription", {
      p_endpoint: data.endpoint,
      p_p256dh: data.p256dh,
      p_auth: data.auth,
      p_user_agent: data.userAgent,
    });
    if (error)
      failWithClientError(
        "notifications.savePushSubscription",
        error,
        "Impossible d'activer les notifications. Réessaie.",
      );
    return { ok: true } as const;
  });

/** Remove the current user's subscription for a given endpoint (unsubscribe). */
export const deletePushSubscription = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ endpoint: z.string().url().max(2048) }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;
    const { error } = await supabase.rpc("delete_push_subscription", {
      p_endpoint: data.endpoint,
    });
    if (error)
      failWithClientError(
        "notifications.deletePushSubscription",
        error,
        "Impossible de désactiver les notifications.",
      );
    return { ok: true } as const;
  });
