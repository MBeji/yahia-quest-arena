// LA PORTE D'ENTRÉE DE LA BOÎTE NOIRE — et la seule du produit qui n'exige AUCUN
// jeton.
//
// ⚠️ CE N'EST PAS UN OUBLI, C'EST LA CONDITION MÊME DE SON UTILITÉ. Cette route
// existe pour recevoir le récit d'un refus d'authentification. Par définition,
// au moment où l'élève a quelque chose à raconter ici, son jeton est cassé :
// exiger un Bearer valide reviendrait à n'enregistrer que les incidents qui ne
// se sont pas produits. Toute personne qui viendrait « corriger » cette absence
// de garde rendrait la table vide et le diagnostic impossible.
//
// CE QUE ÇA COÛTE, ET CE QUI LE BORNE. Une écriture non authentifiée est une
// surface d'abus. Trois limites la referment :
//   1. la route est branchée APRÈS `guardRequest` dans `src/server.ts`, donc
//      elle hérite du plafond de rafales par IP et du refus des agents déclarés ;
//   2. le corps est plafonné à 8 ko, refusé au-delà, AVANT toute analyse ;
//   3. la table ne nomme personne (voir 20260831140000) : il n'y a rien à
//      usurper, et rien à exfiltrer — elle est en RLS sans policy.
//
// ELLE NE REND JAMAIS D'ERREUR. Un client qui apprend que sa télémétrie a
// échoué ne peut rien en faire, et un `catch` de plus sur le chemin d'un jeton
// déjà cassé ne ferait qu'ajouter du bruit à la panne qu'on essaie de lire.
// Toutes les issues — corps trop gros, JSON illisible, base en panne — rendent
// 204. Ce qui rate se voit dans les logs serveur, pas chez l'élève.
import { supabaseAdmin } from "@/shared/integrations/supabase/client.server";
import { logger } from "./logger";

/**
 * ⚠️ PONT DE TYPES, À RETIRER À LA PROCHAINE RÉGÉNÉRATION.
 *
 * `types.ts` est GÉNÉRÉ par `supabase gen types` depuis la PROD : `client_errors`
 * n'y apparaîtra qu'une fois 20260831140000 appliquée, c'est-à-dire au merge sur
 * `main`. La table et son écrivain voyagent pourtant dans la même PR — d'où
 * cette description, posée une fois et ici seulement.
 *
 * Ce n'est pas un `as any` qui esquive le typage (DoD §2) : la forme est écrite
 * en toutes lettres, recopiée colonne par colonne depuis la migration, et le
 * compilateur la vérifie à l'appel. La régénération des types la rendra
 * redondante — et c'est à ce moment-là qu'il faudra la supprimer.
 */
type ClientErrorRow = {
  stage: string;
  client_id: string | null;
  http_status: number | null;
  err_message: string | null;
  ttl_s: number | null;
  hidden_total_ms: number | null;
  last_hidden_ms: number | null;
  user_agent: string | null;
  payload: Record<string, unknown> | null;
};

type ClientErrorWriter = {
  from(table: "client_errors"): {
    insert(row: ClientErrorRow): PromiseLike<{ error: unknown }>;
  };
};

/** Au-delà, on refuse sans lire. Un récit d'erreur tient très large là-dedans. */
export const MAX_CLIENT_LOG_BYTES = 8 * 1024;

/** La seule réponse que cette route sache produire. */
function accepted(): Response {
  return new Response(null, {
    status: 204,
    headers: { "cache-control": "no-store, max-age=0" },
  });
}

/** Borne une chaîne, ou rend `null` si ce n'en est pas une. */
function text(value: unknown, max: number): string | null {
  return typeof value === "string" && value.length > 0 ? value.slice(0, max) : null;
}

/** Un entier fini, ou `null`. Les non-nombres du client ne polluent pas la table. */
function int(value: unknown): number | null {
  if (typeof value !== "number" || !Number.isFinite(value)) return null;
  return Math.trunc(value);
}

export async function handleClientLogRequest(request: Request): Promise<Response> {
  try {
    if (request.method !== "POST") return accepted();

    // `Content-Length` d'abord : quand il est là, on refuse sans même lire le
    // corps. Il est absent en `Transfer-Encoding: chunked` — d'où la seconde
    // mesure, sur les octets réellement reçus.
    const declared = Number(request.headers.get("content-length") ?? "");
    if (Number.isFinite(declared) && declared > MAX_CLIENT_LOG_BYTES) return accepted();

    const raw = await request.text();
    if (new TextEncoder().encode(raw).length > MAX_CLIENT_LOG_BYTES) return accepted();

    const parsed: unknown = JSON.parse(raw);
    if (!parsed || typeof parsed !== "object" || Array.isArray(parsed)) return accepted();
    const body = parsed as Record<string, unknown>;

    // `stage` est le seul champ obligatoire : sans lui, la ligne ne dit pas
    // d'où elle vient et n'aide personne.
    const stage = text(body.stage, 64);
    if (!stage) return accepted();

    await (supabaseAdmin as unknown as ClientErrorWriter).from("client_errors").insert({
      stage,
      client_id: text(body.clientId, 200),
      http_status: int(body.httpStatus),
      err_message: text(body.errMessage, 2000),
      ttl_s: int(body.ttlS),
      hidden_total_ms: int(body.hiddenTotalMs),
      last_hidden_ms: int(body.lastHiddenMs),
      // L'agent vient de L'EN-TÊTE, pas du corps : une seule source, celle que
      // le serveur observe lui-même.
      user_agent: text(request.headers.get("user-agent"), 500),
      payload:
        body.payload && typeof body.payload === "object" && !Array.isArray(body.payload)
          ? (body.payload as Record<string, unknown>)
          : null,
    });

    return accepted();
  } catch (error) {
    // Y compris une base indisponible : la télémétrie ne casse jamais rien, et
    // surtout pas la page d'un élève déjà en difficulté.
    logger.warn("client-log.insert-failed", { error: String(error) });
    return accepted();
  }
}
