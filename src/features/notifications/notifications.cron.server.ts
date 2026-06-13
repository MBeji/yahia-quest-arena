import webpush, { WebPushError } from "web-push";
import { supabaseAdmin } from "@/shared/integrations/supabase/client.server";
import { logger } from "@/shared/lib/logger";
import { appLocalDate, selectStreakAtRiskUserIds, streakReminderPayload } from "./push-audience";

let vapidConfigured = false;

/** Configure web-push from env once. Returns false if any VAPID var is missing. */
function configureVapid(): boolean {
  if (vapidConfigured) return true;
  const subject = process.env.VAPID_SUBJECT;
  const publicKey = process.env.VAPID_PUBLIC_KEY;
  const privateKey = process.env.VAPID_PRIVATE_KEY;
  if (!subject || !publicKey || !privateKey) return false;
  webpush.setVapidDetails(subject, publicKey, privateKey);
  vapidConfigured = true;
  return true;
}

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "content-type": "application/json" },
  });
}

/**
 * Scheduled push dispatcher. Vercel Cron hits GET /api/cron/notify, which
 * src/server.ts routes here. v1 sends the "streak at risk" reminder.
 *
 * Auth: the request must carry `Authorization: Bearer <CRON_SECRET>` (Vercel
 * injects this automatically when the CRON_SECRET env var is set). Runs in the
 * SSR worker (Node 22), reads with the service-role client (bypasses RLS), and
 * prunes dead endpoints (404/410) as it sends.
 */
export async function handlePushCron(request: Request): Promise<Response> {
  const secret = process.env.CRON_SECRET;
  if (!secret || request.headers.get("authorization") !== `Bearer ${secret}`) {
    return new Response("Unauthorized", { status: 401 });
  }

  if (!configureVapid()) {
    logger.error("Push cron: VAPID env not configured");
    return jsonResponse({ error: "VAPID not configured" }, 500);
  }

  // Audience: users with a live streak who have not been active *today* (Tunis-local).
  const { data: profiles, error: profilesError } = await supabaseAdmin
    .from("profiles")
    .select("id, current_streak, last_active_date")
    .gt("current_streak", 0);
  if (profilesError) {
    logger.error("Push cron: failed to load profiles", { error: profilesError });
    return jsonResponse({ error: "profiles" }, 500);
  }

  const userIds = selectStreakAtRiskUserIds(profiles ?? [], appLocalDate(new Date()));
  if (userIds.length === 0) return jsonResponse({ audience: 0, sent: 0, pruned: 0 });

  const { data: subs, error: subsError } = await supabaseAdmin
    .from("push_subscriptions")
    .select("id, endpoint, p256dh, auth")
    .in("user_id", userIds);
  if (subsError) {
    logger.error("Push cron: failed to load subscriptions", { error: subsError });
    return jsonResponse({ error: "subscriptions" }, 500);
  }

  const payload = JSON.stringify(streakReminderPayload());
  let sent = 0;
  let pruned = 0;

  await Promise.all(
    (subs ?? []).map(async (s) => {
      try {
        await webpush.sendNotification(
          { endpoint: s.endpoint, keys: { p256dh: s.p256dh, auth: s.auth } },
          payload,
        );
        sent++;
      } catch (err) {
        const status = err instanceof WebPushError ? err.statusCode : undefined;
        if (status === 404 || status === 410) {
          // Endpoint is gone (unsubscribed / expired) — prune it.
          await supabaseAdmin.from("push_subscriptions").delete().eq("id", s.id);
          pruned++;
        } else {
          logger.warn("Push cron: send failed", { status });
        }
      }
    }),
  );

  logger.info("Push cron complete", {
    audience: userIds.length,
    subscriptions: subs?.length ?? 0,
    sent,
    pruned,
  });
  return jsonResponse({ audience: userIds.length, sent, pruned });
}
