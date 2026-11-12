import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { isRateLimited } from "@/shared/lib/rate-limit";
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
  .validator((d) =>
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
  .validator((d) => z.object({ endpoint: z.string().url().max(2048) }).parse(d))
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

/**
 * Étude 08 lot 2 (US-7, R-7) — le digest hebdo ENRICHI est-il demandé ?
 *
 * Pas de ligne = pas demandé : le réglage est désactivé par défaut (Q-1), et le
 * parent reçoit le bilan générique tant qu'il n'a rien choisi. La lecture passe
 * par RLS (owner-only) — aucun identifiant n'entre dans cette fonction.
 */
export const getParentDigestPref = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;
    const { data, error } = await supabase
      .from("parent_digest_prefs")
      .select("enriched_digest")
      .eq("parent_user_id", userId)
      .maybeSingle();
    if (error)
      failWithClientError(
        "notifications.getParentDigestPref",
        error,
        "Impossible de charger votre réglage du bilan hebdomadaire.",
      );
    return { enriched: data?.enriched_digest === true };
  });

/**
 * Demande — ou coupe — le digest enrichi. L'écriture vit dans la RPC
 * `set_parent_digest_pref`, self-scopée : on ne règle que SA préférence.
 */
export const setParentDigestPref = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .validator((d) => z.object({ enabled: z.boolean() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    if (await isRateLimited(supabase, `digest_pref_${userId}`, 30, 60_000)) {
      throw new Error("Too many preference updates. Please slow down.");
    }

    const { error } = await supabase.rpc("set_parent_digest_pref", { p_enabled: data.enabled });
    if (error)
      failWithClientError(
        "notifications.setParentDigestPref",
        error,
        "Impossible d'enregistrer votre réglage du bilan hebdomadaire.",
      );
    return { enriched: data.enabled };
  });
