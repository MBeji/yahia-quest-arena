// Les SEPT conditions de sortie de R-6 — étude 29, la pièce qui rend Q-4 tenable.
//
// POURQUOI CE FICHIER EXISTE
// ---------------------------------------------------------------------------
// Q-4 a été arbitrée le 2026-08-20 **contre** la recommandation de l'architecte :
// l'adresse du fournisseur est SAISIE LIBREMENT par l'utilisateur, il n'y a pas
// de liste blanche d'hôtes. Autrement dit, un champ de formulaire décide vers
// quelle adresse notre serveur émet une requête. C'est la définition d'un SSRF,
// et RISK-7 le dit sans détour.
//
// Ce qui remplace la liste blanche, ce sont sept conditions, vérifiées à
// l'enregistrement ET à chaque appel. Elles ne sont pas interchangeables et
// aucune n'est là pour faire nombre :
//
//   1. https, et rien d'autre.
//   2. port 443, et rien d'autre.
//   3. pas de littéral IP dans l'URL — v4, v6, décimal, octal, hexadécimal.
//   4. résolution DNS AVANT connexion, et refus de toute IP privée, loopback,
//      lien-local, CGNAT, multicast — dont `169.254.169.254`, l'adresse de
//      métadonnées du cloud, cible n° 1 d'un SSRF.
//   5. IP ÉPINGLÉE pour la connexion : on se connecte à l'IP validée, pas au
//      nom. Sans cela, un domaine peut changer de cible entre la vérification et
//      l'appel — c'est le DNS rebinding, et il annule le point 4 à lui seul.
//   6. aucune redirection suivie : un `302` vers l'adresse de métadonnées
//      annulerait les quatre points précédents d'un coup.
//   7. délai et taille de réponse plafonnés ; la requête ne porte **aucun**
//      identifiant de la plateforme — seulement la clé de l'utilisateur.
//
// POURQUOI `node:https` ET PAS `fetch`
// ---------------------------------------------------------------------------
// `fetch` ne permet pas d'épingler une IP tout en gardant la validation TLS sur
// le NOM (SNI + certificat). `https.request` accepte une fonction `lookup`, ce
// qui donne exactement cela : la connexion part vers l'IP que NOUS avons
// validée, la poignée de main TLS reste faite sur le nom d'hôte. La condition 5
// n'est pas exprimable autrement en Node sans dépendance supplémentaire.
//
// CONSÉQUENCE ASSUMÉE, écrite dans l'UI : un modèle tournant sur la machine de
// l'utilisateur ne marchera pas, sauf exposé publiquement en https. Le refus des
// réseaux privés ne se lève pas — c'est lui qui tient tout l'édifice (RISK-7).

import { lookup as dnsLookupCb } from "node:dns";
import { isIP } from "node:net";
import { request as httpsRequest, type RequestOptions } from "node:https";
import type { IncomingMessage } from "node:http";
import { AI_EGRESS_RULES, AI_HOST_DENYLIST } from "@/shared/constants/ai";
import { AiError } from "./errors";

/** Une cible validée : le nom (pour TLS) et l'IP épinglée (pour la connexion). */
export type EgressTarget = {
  readonly url: URL;
  readonly address: string;
  readonly family: 4 | 6;
};

/** Signature minimale d'un résolveur DNS — paramétrable pour que les tests n'aient pas de réseau. */
export type EgressLookup = (
  hostname: string,
) => Promise<readonly { address: string; family: number }[]>;

function refuse(detail: string): never {
  throw new AiError("AI_HOST_NOT_ALLOWED", { detail });
}

// ---------------------------------------------------------------------------
// Conditions 1 à 3 — la forme de l'URL, sans toucher au réseau
// ---------------------------------------------------------------------------

/**
 * Un nom d'hôte acceptable : des étiquettes DNS, au moins un point, et une
 * étiquette finale qui **commence par une lettre**.
 *
 * Cette dernière clause fait tout le travail de la condition 3. Un littéral IP
 * ne se limite pas à `127.0.0.1` : `2130706433` (décimal), `0x7f000001` (hexa)
 * et `0177.0.0.1` (octal) désignent tous la même boucle locale, et `isIP()` n'en
 * reconnaît aucun. Tous ont en commun une étiquette finale numérique — exiger
 * une lettre les élimine ensemble, plutôt qu'un par un.
 *
 * Effet de bord voulu : `localhost` (sans point) et un nom de machine du réseau
 * interne (`gpu-box`) sont refusés ici, avant toute résolution.
 */
const HOSTNAME_RE = /^[a-z0-9]([a-z0-9-]*[a-z0-9])?(\.[a-z0-9]([a-z0-9-]*[a-z0-9])?)*$/i;

function assertHostname(hostname: string): void {
  if (!hostname || hostname.length > 253) refuse("hostname_shape");
  // `new URL("https://[::1]/")` garde les crochets dans `hostname` : la garde
  // suivante les refuse, mais `isIP` reste la ceinture explicite pour v4/v6.
  if (isIP(hostname.replace(/^\[|\]$/g, "")) !== 0) refuse("ip_literal");
  if (!HOSTNAME_RE.test(hostname)) refuse("hostname_shape");
  const labels = hostname.split(".");
  if (labels.length < 2) refuse("hostname_shape");
  const tld = labels[labels.length - 1];
  if (!/^[a-z]/i.test(tld)) refuse("ip_literal");
}

/** Liste de REFUS (Q-4) : elle s'ajoute aux sept conditions, elle n'en remplace aucune. */
function assertNotDenied(hostname: string): void {
  const host = hostname.toLowerCase();
  for (const denied of AI_HOST_DENYLIST) {
    if (host === denied || host.endsWith(`.${denied}`)) refuse("denylist");
  }
}

/**
 * Conditions 1-3 : parse et valide la FORME de l'URL. Aucune résolution ici —
 * c'est la garde qu'on peut appeler dans un test sans réseau, et à la saisie
 * pour dire non tout de suite.
 */
export function assertUrlShape(rawUrl: string): URL {
  let url: URL;
  try {
    url = new URL(rawUrl);
  } catch {
    refuse("url_parse");
  }
  if (url.protocol !== AI_EGRESS_RULES.protocol) refuse("protocol");
  // `url.port` est vide quand le port est celui par défaut du schéma (443 en
  // https). Tout port explicitement écrit doit être 443 — y compris `:443`,
  // accepté, et `:8443`, refusé.
  if (url.port !== "" && url.port !== String(AI_EGRESS_RULES.port)) refuse("port");
  if (url.username || url.password) refuse("credentials_in_url");
  assertHostname(url.hostname);
  assertNotDenied(url.hostname);
  return url;
}

// ---------------------------------------------------------------------------
// Condition 4 — l'IP résolue doit être publique
// ---------------------------------------------------------------------------

function ipv4ToInt(address: string): number | null {
  const parts = address.split(".");
  if (parts.length !== 4) return null;
  let value = 0;
  for (const part of parts) {
    if (!/^\d{1,3}$/.test(part)) return null;
    const octet = Number(part);
    if (octet > 255) return null;
    value = value * 256 + octet;
  }
  return value;
}

/** Plages IPv4 interdites, en `[premier, dernier]` inclusifs. */
const BLOCKED_V4: readonly (readonly [string, string])[] = [
  ["0.0.0.0", "0.255.255.255"], // « ce réseau »
  ["10.0.0.0", "10.255.255.255"], // privé RFC 1918
  ["100.64.0.0", "100.127.255.255"], // CGNAT RFC 6598
  ["127.0.0.0", "127.255.255.255"], // loopback
  ["169.254.0.0", "169.254.255.255"], // lien-local — contient 169.254.169.254
  ["172.16.0.0", "172.31.255.255"], // privé RFC 1918
  ["192.0.0.0", "192.0.0.255"], // affectations IETF
  ["192.0.2.0", "192.0.2.255"], // TEST-NET-1
  ["192.88.99.0", "192.88.99.255"], // 6to4 relais (déprécié)
  ["192.168.0.0", "192.168.255.255"], // privé RFC 1918
  ["198.18.0.0", "198.19.255.255"], // bancs d'essai RFC 2544
  ["198.51.100.0", "198.51.100.255"], // TEST-NET-2
  ["203.0.113.0", "203.0.113.255"], // TEST-NET-3
  ["224.0.0.0", "239.255.255.255"], // multicast
  ["240.0.0.0", "255.255.255.255"], // réservé + diffusion
];

function isBlockedV4(address: string): boolean {
  const value = ipv4ToInt(address);
  if (value === null) return true; // illisible ⇒ refusé, jamais l'inverse
  return BLOCKED_V4.some(([from, to]) => {
    const lo = ipv4ToInt(from);
    const hi = ipv4ToInt(to);
    return lo !== null && hi !== null && value >= lo && value <= hi;
  });
}

function isBlockedV6(address: string): boolean {
  const a = address.toLowerCase().split("%")[0]; // `%eth0` : identifiant de zone
  if (a === "::" || a === "::1") return true; // non spécifiée, loopback
  // IPv4 encapsulée : `::ffff:127.0.0.1` et `64:ff9b::127.0.0.1` (NAT64) sont
  // des adresses v4 déguisées. On juge l'adresse v4 qu'elles portent.
  const mapped = /(?:^::ffff:|^64:ff9b::)(\d{1,3}(?:\.\d{1,3}){3})$/.exec(a);
  if (mapped) return isBlockedV4(mapped[1]);
  // La forme hexadécimale de la même chose (`::ffff:7f00:1`).
  if (a.startsWith("::ffff:") || a.startsWith("64:ff9b::")) return true;
  if (/^f[cd][0-9a-f]{2}:/.test(a)) return true; // fc00::/7 — unique local
  if (/^fe[89ab][0-9a-f]:/.test(a)) return true; // fe80::/10 — lien-local
  if (a.startsWith("ff")) return true; // ff00::/8 — multicast
  if (a.startsWith("2001:db8:")) return true; // documentation RFC 3849
  return false;
}

/** Une adresse résolue est-elle hors d'atteinte pour nous ? (condition 4) */
export function isBlockedAddress(address: string): boolean {
  const family = isIP(address);
  if (family === 4) return isBlockedV4(address);
  if (family === 6) return isBlockedV6(address);
  return true; // ni v4 ni v6 ⇒ refusé
}

const defaultLookup: EgressLookup = (hostname) =>
  new Promise((resolve, reject) => {
    dnsLookupCb(hostname, { all: true }, (err, addresses) => {
      if (err) reject(err);
      else resolve(addresses);
    });
  });

/**
 * Conditions 1-4 réunies : la forme, puis la résolution, puis le verdict sur
 * **toutes** les adresses rendues.
 *
 * Toutes, et pas seulement celle qu'on retiendra : un nom qui résout vers une IP
 * publique ET une IP privée est un nom hostile, pas un nom à moitié valide.
 */
export async function resolveEgressTarget(
  rawUrl: string,
  lookup: EgressLookup = defaultLookup,
): Promise<EgressTarget> {
  const url = assertUrlShape(rawUrl);

  let addresses: readonly { address: string; family: number }[];
  try {
    addresses = await lookup(url.hostname);
  } catch {
    refuse("dns_failure");
  }
  if (!addresses.length) refuse("dns_empty");

  for (const { address } of addresses) {
    if (isBlockedAddress(address)) refuse("private_address");
  }

  const chosen = addresses[0];
  return {
    url,
    address: chosen.address,
    family: isIP(chosen.address) === 6 ? 6 : 4,
  };
}

// ---------------------------------------------------------------------------
// Conditions 5 à 7 — la requête elle-même
// ---------------------------------------------------------------------------

export type EgressResponse = { readonly status: number; readonly body: string };

export type EgressRequestInit = {
  readonly method: "POST" | "GET";
  /**
   * En-têtes de la requête. La condition 7 est une règle d'APPELANT : seuls
   * l'autorisation du fournisseur et le type de contenu doivent s'y trouver.
   * Rien qui identifie la plateforme — pas de cookie, pas d'`User-Agent` maison,
   * pas d'en-tête de traçage. Node n'ajoute aucun `User-Agent` de lui-même.
   */
  readonly headers: Readonly<Record<string, string>>;
  readonly body?: string;
  readonly timeoutMs?: number;
  readonly maxBytes?: number;
};

/** Le transport, injectable pour que les tests couvrent redirection et débordement sans réseau. */
export type HttpsRequestFn = typeof httpsRequest;

/**
 * Émet la requête vers l'**IP épinglée** (condition 5), refuse toute redirection
 * (condition 6), et plafonne délai et taille (condition 7).
 *
 * La fonction `lookup` passée à `https.request` court-circuite la résolution de
 * `net.connect` : elle rend l'adresse déjà validée, sans deuxième requête DNS.
 * C'est ce court-circuit — et lui seul — qui ferme la fenêtre du DNS rebinding.
 * Le `servername` reste le nom d'hôte, donc le certificat est vérifié contre le
 * nom que l'utilisateur a saisi, pas contre une IP.
 */
export function egressRequest(
  target: EgressTarget,
  init: EgressRequestInit,
  requestFn: HttpsRequestFn = httpsRequest,
): Promise<EgressResponse> {
  const timeoutMs = init.timeoutMs ?? AI_EGRESS_RULES.timeoutMs;
  const maxBytes = init.maxBytes ?? AI_EGRESS_RULES.maxResponseBytes;

  return new Promise<EgressResponse>((resolve, reject) => {
    const options: RequestOptions = {
      protocol: target.url.protocol,
      hostname: target.url.hostname,
      port: AI_EGRESS_RULES.port,
      path: `${target.url.pathname}${target.url.search}`,
      method: init.method,
      headers: init.headers,
      servername: target.url.hostname,
      timeout: timeoutMs,
      // Condition 5 : la connexion part vers l'IP validée, sans re-résoudre.
      lookup: (_hostname, options_, callback) => {
        const all = typeof options_ === "object" && options_ !== null && options_.all;
        if (all) {
          (callback as unknown as (e: null, a: { address: string; family: number }[]) => void)(
            null,
            [{ address: target.address, family: target.family }],
          );
        } else {
          (callback as (e: null, a: string, f: number) => void)(
            null,
            target.address,
            target.family,
          );
        }
      },
    };

    const req = requestFn(options, (res: IncomingMessage) => {
      const status = res.statusCode ?? 0;

      // Condition 6 : aucune redirection suivie. `https.request` ne les suit pas
      // tout seul — ce refus explicite empêche l'appelant de les suivre à sa
      // place en lisant `location`.
      if (status >= 300 && status < 400) {
        res.destroy();
        reject(new AiError("AI_HOST_NOT_ALLOWED", { detail: "redirect", httpStatus: status }));
        return;
      }

      let received = 0;
      const chunks: Buffer[] = [];
      res.on("data", (chunk: Buffer) => {
        received += chunk.length;
        if (received > maxBytes) {
          res.destroy();
          req.destroy();
          reject(new AiError("AI_HOST_NOT_ALLOWED", { detail: "response_too_large" }));
          return;
        }
        chunks.push(chunk);
      });
      res.on("end", () => resolve({ status, body: Buffer.concat(chunks).toString("utf8") }));
      res.on("error", () => reject(new AiError("AI_PROVIDER_DOWN", { detail: "response_stream" })));
    });

    req.on("timeout", () => {
      req.destroy();
      reject(new AiError("AI_PROVIDER_DOWN", { detail: "timeout" }));
    });
    // Le corps d'une erreur de transport (DNS, TLS, RST) n'est jamais propagé :
    // il peut citer l'URL, donc l'hôte du parent. Un code, et rien de plus (R-5).
    req.on("error", () => reject(new AiError("AI_PROVIDER_DOWN", { detail: "transport" })));

    if (init.body !== undefined) req.write(init.body);
    req.end();
  });
}

/**
 * Le chemin complet, tel que l'adaptateur `openai_compatible` l'emprunte :
 * résolution validée puis requête épinglée. Les sept conditions sont vérifiées
 * **à chaque appel**, jamais mises en cache — c'est la lettre de R-6.
 */
export async function egressFetch(
  rawUrl: string,
  init: EgressRequestInit,
  deps?: { lookup?: EgressLookup; requestFn?: HttpsRequestFn },
): Promise<EgressResponse> {
  const target = await resolveEgressTarget(rawUrl, deps?.lookup);
  return egressRequest(target, init, deps?.requestFn);
}
