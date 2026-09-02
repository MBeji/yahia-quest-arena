import { supabaseAdmin } from "@/shared/integrations/supabase/client.server";
import { logger } from "@/shared/lib/logger";
// Le TRANSPORT push vit dans `shared/` depuis l'étude 29 lot 3 : les alertes de
// budget du mode IA en ont besoin aussi, et une feature n'en importe pas une
// autre. Ce module garde ce qui lui appartient — QUI reçoit quoi, et quand.
import { configureVapid, sendPushToUsers, type SendStats } from "@/shared/lib/push-sender.server";
import {
  appLocalDate,
  groupPushPlan,
  isParentDigestDay,
  parentDigestPayload,
  payloadFor,
  resolveDailyPushPlan,
  safeLocale,
  type PushCandidate,
  type PushTag,
} from "./push-audience";

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "content-type": "application/json" },
  });
}

const EMPTY: SendStats = { audience: 0, sent: 0, pruned: 0 };

function addStats(a: SendStats, b: SendStats): SendStats {
  return { audience: a.audience + b.audience, sent: a.sent + b.sent, pruned: a.pruned + b.pruned };
}

/**
 * `push_daily_audiences` est postérieure aux types Supabase générés : contrat
 * figé ici, même patron que les autres RPC récentes.
 */
type AudienceRow = {
  user_id: string;
  tag: string;
  locale: string | null;
  arg: number | null;
  detail: string | null;
};

/** Contrat étroit pour `profiles.locale` (é31 lot 4), en attendant la régénération. */
type ParentLocaleClient = {
  from: (table: "profiles") => {
    select: (columns: string) => {
      in: (
        column: string,
        values: string[],
      ) => PromiseLike<{
        data: { id: string; locale: string | null }[] | null;
        error: { message: string } | null;
      }>;
    };
  };
};

type AudienceClient = {
  rpc: (
    fn: "push_daily_audiences",
    args: { p_today: string },
  ) => PromiseLike<{ data: AudienceRow[] | null; error: { message: string } | null }>;
};

/**
 * ⭐ LE DISPATCHER D'ÉLÈVE — une lecture, un pipeline, au plus un push par élève.
 *
 * Avant é31 lot 4 : deux audiences, une exclusion croisée écrite à la main entre
 * elles, et l'élève qui avait PERDU sa série n'était plus jamais recontacté. Il y
 * a désormais six moments (R-16), et la règle « ≤ 1 par jour » (R-4) ne tient
 * plus par une exclusion mais par la STRUCTURE : la base rend des candidats,
 * `resolveDailyPushPlan` n'en garde qu'un.
 *
 * Le regroupement par (tag, langue, nombre) évite un envoi par élève : le
 * transport prend une liste d'identifiants et un payload.
 */
async function dispatchStudentPush(
  now: Date,
): Promise<{ stats: SendStats; byTag: Record<string, number> }> {
  const { data, error } = await (supabaseAdmin as unknown as AudienceClient).rpc(
    "push_daily_audiences",
    { p_today: appLocalDate(now) },
  );
  if (error) {
    logger.error("Push cron: failed to load daily audiences", { error });
    throw new Error("audiences");
  }

  const candidates: PushCandidate[] = (data ?? []).map((row) => ({
    userId: row.user_id,
    tag: row.tag as PushTag,
    locale: row.locale,
    arg: row.arg,
  }));

  const plan = resolveDailyPushPlan(candidates);
  const byTag: Record<string, number> = {};
  for (const entry of plan) byTag[entry.tag] = (byTag[entry.tag] ?? 0) + 1;

  const groups = groupPushPlan(plan);
  const results = await Promise.all(
    groups.map((g) => sendPushToUsers(g.userIds, payloadFor(g.tag, safeLocale(g.locale), g.arg))),
  );

  return { stats: results.reduce(addStats, EMPTY), byTag };
}

/**
 * Weekly family digest — every parent with at least one active student link gets
 * a "your weekly report is ready" push on Sunday evening (see PARENT_DIGEST_WEEKDAY).
 * Les parents ne concourent pas avec les élèves : ils reçoivent leur propre canal,
 * et le pipeline de priorité ne les concerne pas.
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
  if (parentIds.length === 0) return EMPTY;

  // é31 R-17 — le bilan part dans la langue du parent, comme le reste.
  // ⚠️ `locale` est postérieure aux types Supabase générés (régénération
  // impossible sans accès DB) : contrat étroit, comme les autres lectures du lot.
  const { data: profiles, error: profilesError } = await (
    supabaseAdmin as unknown as ParentLocaleClient
  )
    .from("profiles")
    .select("id, locale")
    .in("id", parentIds);
  if (profilesError) {
    logger.error("Push cron: failed to load parent locales", { error: profilesError });
    throw new Error("parent_links");
  }

  const byLocale = new Map<string, string[]>();
  const known = new Map((profiles ?? []).map((p) => [p.id, safeLocale(p.locale)]));
  for (const id of parentIds) {
    const locale = known.get(id) ?? "fr";
    byLocale.set(locale, [...(byLocale.get(locale) ?? []), id]);
  }

  const results = await Promise.all(
    [...byLocale.entries()].map(([locale, ids]) =>
      sendPushToUsers(ids, parentDigestPayload(safeLocale(locale))),
    ),
  );
  return results.reduce(addStats, EMPTY);
}

/**
 * Scheduled push dispatcher. Vercel Cron hits GET /api/cron/notify daily, which
 * src/server.ts routes here. Envoie AU PLUS UN push par élève (é31 R-4), plus le
 * bilan famille le dimanche (heure de Tunis).
 *
 * Auth: the request must carry `Authorization: Bearer <CRON_SECRET>` (Vercel
 * injects this automatically when the CRON_SECRET env var is set). Runs in the
 * SSR worker, reads with the service-role client (bypasses RLS), and prunes dead
 * endpoints (404/410) as it sends. `now` is injectable for tests.
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

  let students: SendStats;
  let byTag: Record<string, number>;
  try {
    const result = await dispatchStudentPush(now);
    students = result.stats;
    byTag = result.byTag;
  } catch (err) {
    return jsonResponse({ error: err instanceof Error ? err.message : "audiences" }, 500);
  }

  let parentDigest: SendStats | null = null;
  if (isParentDigestDay(now)) {
    try {
      parentDigest = await dispatchParentDigest();
    } catch (err) {
      return jsonResponse({ error: err instanceof Error ? err.message : "parent_digest" }, 500);
    }
  }

  // Journal par TAG (§3.7) : sans lui, « 12 envoyés » ne dit pas si le canal
  // sert à relancer les absents ou à féliciter ceux qui sont déjà là.
  logger.info("Push cron complete", { students, byTag, parentDigest });
  return jsonResponse({ ...students, byTag, parentDigest });
}
