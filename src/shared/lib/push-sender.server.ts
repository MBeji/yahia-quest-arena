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

// ⚠️ `web-push` N'EST JAMAIS IMPORTÉ STATIQUEMENT — et la raison est un défaut
// vécu, pas une précaution (#909).
//
// En dev, Vite sert les modules NON bundlés : un composant client qui importe un
// `*.server.ts` fait charger au NAVIGATEUR tout le graphe statique de ce module.
// Le plugin TanStack Start vide bien le corps des server functions, mais il
// LAISSE leurs imports en tête du module servi — vérifié en lisant ce que le dev
// server répond. La chaîne vivante était :
//
//   `_authenticated/dashboard.tsx` → `features/tutor/components/tutor-digest`
//     → `features/tutor/digest.server` → `features/ai/ai-call.server`
//     → `features/ai/ai-alerts.server` → CE FICHIER → `web-push`
//
// Or `web-push` → `jws`, dont `data-stream.js`, `sign-stream.js` et
// `verify-stream.js` appellent `util.inherits(…)` AU CHARGEMENT du module. Dans
// un navigateur, `util` est un stub vide : `util.inherits is not a function`, la
// frontière d'erreur racine attrape, et les 27 tests e2e authentifiés tombent sur
// « Le parchemin s'est déchiré » — six nuits durant.
//
// La coupure est posée ICI plutôt que chez l'appelant : deux correctifs
// précédents (#906, #942) ont coupé une arête chacun, et une troisième s'est
// rouverte derrière eux. Un `await import(…)` au point d'entrée du paquet ferme
// la CLASSE — aucun appelant, présent ou futur, ne peut plus le faire entrer
// dans un graphe client.
import { supabaseAdmin } from "@/shared/integrations/supabase/client.server";
import { logger } from "./logger";

export type PushPayload = { title: string; body: string; url: string; tag: string };

export type SendStats = { audience: number; sent: number; pruned: number };

type WebPushApi = typeof import("web-push");
type WebPushLoaded = { api: WebPushApi; WebPushError: WebPushApi["WebPushError"] };

/**
 * Le module, chargé UNE fois et partagé — pas un `await import(…)` par appel.
 *
 * Ce n'est pas de la coquetterie : `dispatchPlanReminder` lance un envoi par
 * groupe de révisions en `Promise.all`, et avec un `await import(…)` par appel le
 * SECOND recevait un espace de noms encore vide — donc `sendNotification`
 * absent. L'échec tombait dans le `catch` de l'envoi, qui comptait 0 envoyé sans
 * rien dire : mesuré sur `notifications.cron.test.ts`, où deux payloads distincts
 * n'en produisaient plus qu'un. Une promesse mémorisée supprime la course, quel
 * que soit le chargeur.
 */
let webPushModule: Promise<WebPushLoaded> | null = null;
function loadWebPush(): Promise<WebPushLoaded> {
  webPushModule ??= import("web-push").then((mod) => ({
    // `web-push` est CJS, et son espace de noms ESM est ASYMÉTRIQUE — mesuré,
    // pas supposé : `default` porte tout `module.exports`, tandis que les
    // exports NOMMÉS se limitent à ce que le lexer CJS sait voir, soit
    // `WebPushError` et `supportedContentEncodings`. `sendNotification` et
    // `setVapidDetails`, posés par expression de membre, n'en sont PAS. Passer
    // par les exports nommés casserait l'envoi en silence.
    // `@types/web-push` décrit l'API en exports nommés et ne modélise pas ce
    // `default` : l'assertion nomme la forme réelle, elle n'esquive aucun type.
    api: (mod as WebPushApi & { default: WebPushApi }).default,
    WebPushError: mod.WebPushError,
  }));
  return webPushModule;
}

let vapidConfigured = false;

/**
 * Configure web-push depuis l'environnement, une fois. `false` s'il manque une
 * variable — et dans ce cas le paquet n'est même pas chargé : l'absence de VAPID
 * se lit dans `process.env`, pas dans `web-push`.
 */
export async function configureVapid(): Promise<boolean> {
  if (vapidConfigured) return true;
  const subject = process.env.VAPID_SUBJECT;
  const publicKey = process.env.VAPID_PUBLIC_KEY;
  const privateKey = process.env.VAPID_PRIVATE_KEY;
  if (!subject || !publicKey || !privateKey) return false;
  const { api: webpush } = await loadWebPush();
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

  const { api: webpush, WebPushError } = await loadWebPush();

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
