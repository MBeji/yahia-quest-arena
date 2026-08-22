// L'ENVOI de notifications push — le transport, extrait de son premier appelant.
//
// POURQUOI CE MODULE EXISTE (et pourquoi il est ici et pas dans une feature)
// ---------------------------------------------------------------------------
// Le transport push est né dans `notifications.cron.server.ts`, son seul client
// jusqu'ici. L'étude 29 lui en donne un second : R-11 exige que le porteur d'une
// clé soit prévenu — une fois par seuil de plafond, et **le jour même** sur une
// anomalie de dépense. Une alerte qui attend la prochaine ouverture de la console
// ne préviendrait de rien.
//
// Les features n'importent jamais d'autres features (AGENTS.md) : le transport
// remonte donc dans `shared/`, et ses deux clients — le cron des rappels de série
// et les alertes de budget — le partagent au lieu de le dupliquer.
//
// ⚠️ Ce module ne DÉCIDE rien : il ne choisit ni l'audience, ni le texte, ni le
// moment. Ces trois-là appartiennent à l'appelant. Ici il n'y a que l'envoi,
// l'élagage des abonnements morts, et le refus silencieux quand VAPID n'est pas
// configuré (l'app doit tourner sans push, en développement comme en CI).

import webpush, { WebPushError } from "web-push";
import { supabaseAdmin } from "@/shared/integrations/supabase/client.server";
import { logger } from "./logger";

export type PushPayload = { title: string; body: string; url: string; tag: string };

export type SendStats = { audience: number; sent: number; pruned: number };

let vapidConfigured = false;

/** Configure web-push depuis l'environnement, une fois. `false` s'il manque une variable. */
export function configureVapid(): boolean {
  if (vapidConfigured) return true;
  const subject = process.env.VAPID_SUBJECT;
  const publicKey = process.env.VAPID_PUBLIC_KEY;
  const privateKey = process.env.VAPID_PRIVATE_KEY;
  if (!subject || !publicKey || !privateKey) return false;
  webpush.setVapidDetails(subject, publicKey, privateKey);
  vapidConfigured = true;
  return true;
}

/**
 * Supprime les abonnements morts en lot. Un `DELETE` par ligne coûtait un
 * aller-retour par abonné perdu : une vague d'endpoints expirés (une version de
 * navigateur, un désabonnement massif) martelait PostgREST à proportion des
 * dégâts. Découpé, parce que `.in()` voyage dans l'URL, qui a une longueur max.
 *
 * L'élagage est au mieux : les notifications sont déjà parties, donc un nettoyage
 * raté ne doit pas faire échouer l'appelant — la prochaine passe réessaiera.
 */
async function pruneSubscriptions(ids: string[]): Promise<number> {
  if (ids.length === 0) return 0;

  const CHUNK_SIZE = 200;
  let pruned = 0;

  for (let i = 0; i < ids.length; i += CHUNK_SIZE) {
    const chunk = ids.slice(i, i + CHUNK_SIZE);
    const { error } = await supabaseAdmin.from("push_subscriptions").delete().in("id", chunk);
    if (error) {
      logger.error("Push: failed to prune dead subscriptions", { error, count: chunk.length });
      continue;
    }
    pruned += chunk.length;
  }

  return pruned;
}

/**
 * Envoie une charge utile à tous les abonnements des utilisateurs donnés, en
 * élaguant les endpoints morts (404/410) au passage.
 */
export async function sendPushToUsers(userIds: string[], payload: PushPayload): Promise<SendStats> {
  if (userIds.length === 0) return { audience: 0, sent: 0, pruned: 0 };

  const { data: subs, error: subsError } = await supabaseAdmin
    .from("push_subscriptions")
    .select("id, endpoint, p256dh, auth")
    .in("user_id", userIds);
  if (subsError) {
    logger.error("Push: failed to load subscriptions", { error: subsError });
    throw new Error("subscriptions");
  }

  const body = JSON.stringify(payload);
  let sent = 0;
  const deadIds: string[] = [];

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
          // L'endpoint n'existe plus (désabonnement / expiration) — on le
          // collecte, l'élagage se fait en lot ci-dessous.
          deadIds.push(s.id);
        } else {
          logger.warn("Push: send failed", { status });
        }
      }
    }),
  );

  const pruned = await pruneSubscriptions(deadIds);

  return { audience: userIds.length, sent, pruned };
}
