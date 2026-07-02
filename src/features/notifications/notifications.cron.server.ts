import webpush, { WebPushError } from "web-push";
import { supabaseAdmin } from "@/shared/integrations/supabase/client.server";
import { logger } from "@/shared/lib/logger";
import {
  appLocalDate,
  isParentDigestDay,
  selectStreakAtRiskUserIds,
  streakReminderPayload,
  weeklyParentDigestPayload,
  type PushPayload,
} from "./push-audience";

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

type SendStats = { audience: number; sent: number; pruned: number };

/**
 * Send one payload to every push subscription of the given users, pruning dead
 * endpoints (404/410) as it goes. Shared by the streak reminder and the weekly
 * family digest.
 */
async function sendToUsers(userIds: string[], payload: PushPayload): Promise<SendStats> {
  if (userIds.length === 0) return { audience: 0, sent: 0, pruned: 0 };

  const { data: subs, error: subsError } = await supabaseAdmin
    .from("push_subscriptions")
    .select("id, endpoint, p256dh, auth")
    .in("user_id", userIds);
  if (subsError) {
    logger.error("Push cron: failed to load subscriptions", { error: subsError });
    throw new Error("subscriptions");
  }

  const body = JSON.stringify(payload);
  let sent = 0;
  let pruned = 0;

  await Promise.all(
    (subs ?? []).map(async (s) => {
      try {
        await webpush.sendNotification(
          { endpoint: s.endpoint, keys: { p256dh: s.p256dh, auth: s.auth } },
          body,
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

  return { audience: userIds.length, sent, pruned };
}

/** Audience: users with a live streak who have not been active *today* (Tunis-local). */
async function dispatchStreakReminder(now: Date): Promise<SendStats> {
  const { data: profiles, error: profilesError } = await supabaseAdmin
    .from("profiles")
    .select("id, current_streak, last_active_date")
    .gt("current_streak", 0);
  if (profilesError) {
    logger.error("Push cron: failed to load profiles", { error: profilesError });
    throw new Error("profiles");
  }

  const userIds = selectStreakAtRiskUserIds(profiles ?? [], appLocalDate(now));
  return sendToUsers(userIds, streakReminderPayload());
}

/**
 * Weekly family digest — every parent with at least one active student link gets
 * a "your weekly report is ready" push on Sunday evening (see PARENT_DIGEST_WEEKDAY).
 */
async function dispatchParentDigest(): Promise<SendStats> {
  const { data: links, error: linksError } = await supabaseAdmin
    .from("parent_student_links")
    .select("parent_user_id")
    .eq("is_active", true);
  if (linksError) {
    logger.error("Push cron: failed to load parent links", { error: linksError });
    throw new Error("parent_links");
  }

  const parentIds = [...new Set((links ?? []).map((l) => l.parent_user_id))];
  return sendToUsers(parentIds, weeklyParentDigestPayload());
}

/**
 * Scheduled push dispatcher. Vercel Cron hits GET /api/cron/notify daily, which
 * src/server.ts routes here. Sends the "streak at risk" reminder every day, plus
 * the weekly family digest on Sunday (Tunis-local).
 *
 * Auth: the request must carry `Authorization: Bearer <CRON_SECRET>` (Vercel
 * injects this automatically when the CRON_SECRET env var is set). Runs in the
 * SSR worker (Node 22), reads with the service-role client (bypasses RLS), and
 * prunes dead endpoints (404/410) as it sends. `now` is injectable for tests.
 */
export async function handlePushCron(request: Request, now: Date = new Date()): Promise<Response> {
  const secret = process.env.CRON_SECRET;
  if (!secret || request.headers.get("authorization") !== `Bearer ${secret}`) {
    return new Response("Unauthorized", { status: 401 });
  }

  if (!configureVapid()) {
    logger.error("Push cron: VAPID env not configured");
    return jsonResponse({ error: "VAPID not configured" }, 500);
  }

  let streak: SendStats;
  try {
    streak = await dispatchStreakReminder(now);
  } catch (err) {
    return jsonResponse({ error: err instanceof Error ? err.message : "streak" }, 500);
  }

  let parentDigest: SendStats | null = null;
  if (isParentDigestDay(now)) {
    try {
      parentDigest = await dispatchParentDigest();
    } catch (err) {
      return jsonResponse({ error: err instanceof Error ? err.message : "parent_digest" }, 500);
    }
  }

  logger.info("Push cron complete", { streak, parentDigest });
  return jsonResponse({ ...streak, parentDigest });
}
