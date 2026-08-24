import { supabaseAdmin } from "@/shared/integrations/supabase/client.server";
import { logger } from "@/shared/lib/logger";
// Le TRANSPORT push vit dans `shared/` depuis l'étude 29 lot 3 : les alertes de
// budget du mode IA en ont besoin aussi, et une feature n'en importe pas une
// autre. Ce module garde ce qui lui appartient — QUI reçoit quoi, et quand.
import { configureVapid, sendPushToUsers, type SendStats } from "@/shared/lib/push-sender.server";
import {
  appLocalDate,
  isParentDigestDay,
  planReminderPayload,
  selectStreakAtRiskUserIds,
  streakReminderPayload,
  weeklyParentDigestPayload,
} from "./push-audience";

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "content-type": "application/json" },
  });
}

/** Audience: users with a live streak who have not been active *today* (Tunis-local). */
async function dispatchStreakReminder(now: Date): Promise<{ stats: SendStats; sentTo: string[] }> {
  const { data: profiles, error: profilesError } = await supabaseAdmin
    .from("profiles")
    .select("id, current_streak, last_active_date")
    .gt("current_streak", 0);
  if (profilesError) {
    logger.error("Push cron: failed to load profiles", { error: profilesError });
    throw new Error("profiles");
  }

  const userIds = selectStreakAtRiskUserIds(profiles ?? [], appLocalDate(now));
  return { stats: await sendPushToUsers(userIds, streakReminderPayload()), sentTo: userIds };
}

/**
 * Le rappel du plan du jour — étude 11 US-7.
 *
 * `alreadyNotified` porte la promesse « au plus un par jour » : le rappel de
 * série vise EXACTEMENT la même population (élève inactif aujourd'hui), et deux
 * notifications le même soir pour la même raison sont la meilleure façon de
 * faire couper les notifications. Ce n'est pas une politesse — c'est la seule
 * chose qui tienne l'opt-in dans la durée.
 *
 * L'audience est calculée en SQL (`tutor_plan_push_audience`) : opt-in armé,
 * au moins une révision due, pas encore venu. Le JOUR lui est passé, parce que
 * la journée de l'application est celle de Tunis et qu'elle est déjà calculée
 * ici — deux définitions de « aujourd'hui » dans le même cron divergeraient.
 */
async function dispatchPlanReminder(now: Date, alreadyNotified: string[]): Promise<SendStats> {
  const { data, error } = await (
    supabaseAdmin as unknown as {
      rpc: (
        fn: "tutor_plan_push_audience",
        args: { p_today: string },
      ) => PromiseLike<{
        data: { user_id: string; due_count: number }[] | null;
        error: { message: string } | null;
      }>;
    }
  ).rpc("tutor_plan_push_audience", { p_today: appLocalDate(now) });

  if (error) {
    logger.error("Push cron: failed to load tutor plan audience", { error });
    throw new Error("tutor_plan");
  }

  const skip = new Set(alreadyNotified);
  const rows = (data ?? []).filter((r) => !skip.has(r.user_id));
  if (rows.length === 0) return { audience: 0, sent: 0, pruned: 0 };

  // Le texte dépend du NOMBRE de révisions dues : on groupe par ce nombre pour
  // n'envoyer qu'un payload par groupe plutôt qu'un par élève.
  const byCount = new Map<number, string[]>();
  for (const row of rows) {
    const bucket = byCount.get(row.due_count) ?? [];
    bucket.push(row.user_id);
    byCount.set(row.due_count, bucket);
  }

  const results = await Promise.all(
    [...byCount.entries()].map(([count, ids]) => sendPushToUsers(ids, planReminderPayload(count))),
  );

  return results.reduce(
    (total, r) => ({
      audience: total.audience + r.audience,
      sent: total.sent + r.sent,
      pruned: total.pruned + r.pruned,
    }),
    { audience: 0, sent: 0, pruned: 0 },
  );
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
  return sendPushToUsers(parentIds, weeklyParentDigestPayload());
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
  let streakSentTo: string[];
  try {
    const result = await dispatchStreakReminder(now);
    streak = result.stats;
    streakSentTo = result.sentTo;
  } catch (err) {
    return jsonResponse({ error: err instanceof Error ? err.message : "streak" }, 500);
  }

  // Étude 11 US-7. Après le rappel de série, et en l'excluant : les deux visent
  // l'élève inactif du jour, et la promesse est « au plus un par jour ».
  let tutorPlan: SendStats;
  try {
    tutorPlan = await dispatchPlanReminder(now, streakSentTo);
  } catch (err) {
    return jsonResponse({ error: err instanceof Error ? err.message : "tutor_plan" }, 500);
  }

  let parentDigest: SendStats | null = null;
  if (isParentDigestDay(now)) {
    try {
      parentDigest = await dispatchParentDigest();
    } catch (err) {
      return jsonResponse({ error: err instanceof Error ? err.message : "parent_digest" }, 500);
    }
  }

  logger.info("Push cron complete", { streak, tutorPlan, parentDigest });
  return jsonResponse({ ...streak, tutorPlan, parentDigest });
}
