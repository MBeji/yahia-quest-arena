import { z } from "zod";
import { supabaseAdmin } from "@/shared/integrations/supabase/client.server";
import { parseRpcRows } from "@/shared/integrations/supabase/rpc-rows";
import { logger } from "@/shared/lib/logger";
// Le TRANSPORT push vit dans `shared/` depuis l'étude 29 lot 3 : les alertes de
// budget du mode IA en ont besoin aussi, et une feature n'en importe pas une
// autre. Ce module garde ce qui lui appartient — QUI reçoit quoi, et quand.
import { configureVapid, sendPushToUsers, type SendStats } from "@/shared/lib/push-sender.server";
import {
  appLocalDate,
  enrichedParentDigestPayload,
  groupPushPlan,
  isParentDigestDay,
  parentDigestPayload,
  payloadFor,
  PUSH_PRIORITY,
  resolveDailyPushPlan,
  safeLocale,
  type DigestChild,
  type PushCandidate,
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
 * Une ligne de `push_daily_audiences`, validée à la frontière. Le type généré dit
 * `tag: string` et ses autres colonnes non nulles ; le SQL rend six tags FERMÉS —
 * exactement `PUSH_PRIORITY` — et peut rendre `NULL` (langue d'un profil, compteur
 * absent). Un tag inconnu n'atteint donc jamais `payloadFor`, qui n'aurait aucun
 * texte pour lui : la ligne est écartée et la dérive journalisée, les autres
 * élèves reçoivent leur notification.
 */
const audienceRowSchema = z.object({
  user_id: z.string(),
  tag: z.enum(PUSH_PRIORITY),
  locale: z.string().nullable(),
  arg: z.number().nullable(),
});

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
  const { data, error } = await supabaseAdmin.rpc("push_daily_audiences", {
    p_today: appLocalDate(now),
  });
  if (error) {
    logger.error("Push cron: failed to load daily audiences", { error });
    throw new Error("audiences");
  }

  const rows = parseRpcRows(audienceRowSchema, data, "Push cron: daily audiences");
  const candidates: PushCandidate[] = rows.map((row) => ({
    userId: row.user_id,
    tag: row.tag,
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
 * Étude 08 lot 2 — le résumé rendu par `get_parent_digest_summary`, relu avant
 * d'entrer dans un texte : une forme inattendue vaut « pas de résumé », donc le
 * générique, jamais un « undefined missions » sur l'écran d'un parent.
 */
const digestChildSchema = z.object({
  displayName: z.string().nullable().catch(null),
  learningMinutes: z.number().int().min(0).catch(0),
  missions: z.number().int().min(0).catch(0),
  streak: z.number().int().min(0).catch(0),
  weakChapter: z.string().nullable().catch(null),
});
const digestSummarySchema = z.array(digestChildSchema);

/** Ce que le dimanche a envoyé, par nature — la mesure du lot (étude §1, KPI-4). */
export type ParentDigestBreakdown = {
  /** Parents ayant demandé le digest enrichi (et toujours liés). */
  optedIn: number;
  /** Parents dont le résumé a été composé et confié au transport. */
  enriched: number;
  /** Opt-in retombés sur le générique (résumé illisible ou vide). */
  fallback: number;
};

const NO_BREAKDOWN: ParentDigestBreakdown = { optedIn: 0, enriched: 0, fallback: 0 };

/**
 * Qui a DEMANDÉ le digest enrichi (R-7 : opt-in, désactivé par défaut).
 *
 * Une panne ici ne doit pas priver les parents du bilan : elle rend « personne »,
 * et tout le monde reçoit le générique — qui reste vrai.
 */
async function loadEnrichedOptIns(parentIds: string[]): Promise<Set<string>> {
  try {
    const { data, error } = await supabaseAdmin
      .from("parent_digest_prefs")
      .select("parent_user_id")
      .eq("enriched_digest", true);
    if (error) {
      logger.warn("Push cron: digest prefs unreadable — generic digest for all", { error });
      return new Set();
    }
    const linked = new Set(parentIds);
    return new Set((data ?? []).map((row) => row.parent_user_id).filter((id) => linked.has(id)));
  } catch (err) {
    logger.warn("Push cron: digest prefs unreadable — generic digest for all", { error: err });
    return new Set();
  }
}

/** Le résumé d'UN parent — `null` dès qu'il n'est pas sûr (panne, forme, vide). */
async function loadDigestSummary(parentId: string): Promise<DigestChild[] | null> {
  try {
    const { data, error } = await supabaseAdmin.rpc("get_parent_digest_summary", {
      p_parent: parentId,
    });
    if (error) {
      logger.warn("Push cron: digest summary failed — generic fallback", { error });
      return null;
    }
    const parsed = digestSummarySchema.safeParse(data);
    return parsed.success && parsed.data.length > 0 ? parsed.data : null;
  } catch (err) {
    logger.warn("Push cron: digest summary failed — generic fallback", { error: err });
    return null;
  }
}

/**
 * Date le PREMIER envoi enrichi réellement parti — c'est ce qui rend lisible le
 * « taux de coupure après le premier envoi ». Best-effort : la mesure ne fait
 * jamais échouer l'envoi.
 */
async function stampFirstEnrichedSend(parentIds: string[], now: Date): Promise<void> {
  if (parentIds.length === 0) return;
  try {
    const { error } = await supabaseAdmin
      .from("parent_digest_prefs")
      .update({ first_enriched_sent_at: now.toISOString() })
      .in("parent_user_id", parentIds)
      .is("first_enriched_sent_at", null);
    if (error) logger.warn("Push cron: could not stamp first enriched digest", { error });
  } catch (err) {
    logger.warn("Push cron: could not stamp first enriched digest", { error: err });
  }
}

/** Les résumés se lisent par petits paquets : un RPC par parent, jamais cent d'un coup. */
const DIGEST_SUMMARY_CONCURRENCY = 8;

/**
 * Weekly family digest — every parent with at least one active student link gets
 * a push on Sunday evening (see PARENT_DIGEST_WEEKDAY).
 * Les parents ne concourent pas avec les élèves : ils reçoivent leur propre canal,
 * et le pipeline de priorité ne les concerne pas.
 *
 * Étude 08 lot 2 : le parent qui a DEMANDÉ le digest enrichi reçoit le résumé
 * chiffré de la semaine à la place du générique « le bilan est prêt ». Jamais les
 * deux, et jamais le résumé sans l'avoir demandé.
 */
async function dispatchParentDigest(
  now: Date,
): Promise<{ stats: SendStats; breakdown: ParentDigestBreakdown }> {
  const { data: links, error: linksError } = await supabaseAdmin
    .from("parent_student_links")
    .select("parent_user_id")
    .eq("is_active", true);
  if (linksError) {
    logger.error("Push cron: failed to load parent links", { error: linksError });
    throw new Error("parent_links");
  }

  const parentIds = [...new Set((links ?? []).map((l) => l.parent_user_id))];
  if (parentIds.length === 0) return { stats: EMPTY, breakdown: NO_BREAKDOWN };

  // é31 R-17 — le bilan part dans la langue du parent, comme le reste.
  const { data: profiles, error: profilesError } = await supabaseAdmin
    .from("profiles")
    .select("id, locale")
    .in("id", parentIds);
  if (profilesError) {
    logger.error("Push cron: failed to load parent locales", { error: profilesError });
    throw new Error("parent_links");
  }
  const known = new Map((profiles ?? []).map((p) => [p.id, safeLocale(p.locale)]));
  const localeOf = (id: string) => known.get(id) ?? "fr";

  // 1) Les parents qui ont demandé le résumé — un payload par parent.
  const optIns = [...(await loadEnrichedOptIns(parentIds))];
  const enrichedSends: Promise<SendStats>[] = [];
  const enrichedIds: string[] = [];
  const stamped: string[] = [];
  for (let i = 0; i < optIns.length; i += DIGEST_SUMMARY_CONCURRENCY) {
    const batch = optIns.slice(i, i + DIGEST_SUMMARY_CONCURRENCY);
    const summaries = await Promise.all(batch.map((id) => loadDigestSummary(id)));
    batch.forEach((id, index) => {
      const summary = summaries[index];
      const payload = summary ? enrichedParentDigestPayload(localeOf(id), summary) : null;
      if (!payload) return;
      enrichedIds.push(id);
      enrichedSends.push(
        sendPushToUsers([id], payload).then((stats) => {
          if (stats.sent > 0) stamped.push(id);
          return stats;
        }),
      );
    });
  }

  // 2) Tous les autres — y compris les opt-in sans résumé sûr — le générique.
  const enrichedSet = new Set(enrichedIds);
  const byLocale = new Map<string, string[]>();
  for (const id of parentIds) {
    if (enrichedSet.has(id)) continue;
    const locale = localeOf(id);
    byLocale.set(locale, [...(byLocale.get(locale) ?? []), id]);
  }

  const results = await Promise.all([
    ...enrichedSends,
    ...[...byLocale.entries()].map(([locale, ids]) =>
      sendPushToUsers(ids, parentDigestPayload(safeLocale(locale))),
    ),
  ]);
  await stampFirstEnrichedSend(stamped, now);

  return {
    stats: results.reduce(addStats, EMPTY),
    breakdown: {
      optedIn: optIns.length,
      enriched: enrichedIds.length,
      fallback: optIns.length - enrichedIds.length,
    },
  };
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

  if (!(await configureVapid())) {
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
  let parentDigestKinds: ParentDigestBreakdown | null = null;
  if (isParentDigestDay(now)) {
    try {
      const digest = await dispatchParentDigest(now);
      parentDigest = digest.stats;
      parentDigestKinds = digest.breakdown;
    } catch (err) {
      return jsonResponse({ error: err instanceof Error ? err.message : "parent_digest" }, 500);
    }
  }

  // Journal par TAG (§3.7) : sans lui, « 12 envoyés » ne dit pas si le canal
  // sert à relancer les absents ou à féliciter ceux qui sont déjà là.
  // `parentDigestKinds` est le compteur du digest enrichi (é08 KPI-4) : combien
  // l'ont demandé, combien l'ont reçu, combien sont retombés sur le générique.
  logger.info("Push cron complete", { students, byTag, parentDigest, parentDigestKinds });
  // La clé n'existe que le dimanche : la réponse des six autres jours ne bouge pas.
  return jsonResponse({
    ...students,
    byTag,
    parentDigest,
    ...(parentDigestKinds ? { parentDigestKinds } : {}),
  });
}
