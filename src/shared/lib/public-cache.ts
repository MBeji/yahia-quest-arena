/**
 * Les SOMMAIRES publics servis par le CDN — décision du propriétaire du 2026-11-13
 * (ssr-04, option 2 de `docs/performance-audit.md` §0-quater ; `docs/journal-decisions.md`).
 *
 * QUOI. L'accueil, `/programme`, `/programme/lycee/<année>` et `/niveau/<parcours>` : des
 * listes de niveaux et de matières, sans leçon ni exercice. Mesuré en production le
 * 2026-11-13 : 175 à 260 ms de premier octet à chaque visite, contre ≈ 40 ms pour un
 * fichier que le CDN sert lui-même. Les pages de CONTENU (cours, matière, exercice) ne
 * sont PAS concernées : servies par le CDN, elles échapperaient au garde anti-aspiration
 * (`bot-guard.ts`), qui ne tourne que dans la fonction. C'est la raison de l'option 2.
 *
 * CE QUI REND UNE PAGE PARTAGEABLE ENTRE VISITEURS — quatre conditions, toutes vérifiées
 * ici, parce qu'une seule qui manque sert à quelqu'un la page de quelqu'un d'autre :
 *
 *   1. Le rendu serveur ne lit de la requête que deux cookies : la langue et le thème
 *      (relu le 2026-11-13 : `shell-locale.ts`, `__root.tsx` ; l'auth vit dans un en-tête
 *      `Authorization` qu'un chargement de page ne porte jamais). Le routage
 *      (`scripts/vercel-routes.mjs`) les recopie dans deux en-têtes de REQUÊTE, et la
 *      réponse déclare `Vary` sur eux : six variantes, une par couple. `Vary: Cookie`
 *      n'irait pas — les cookies de mesure d'audience rendent chaque visiteur unique.
 *      Si les en-têtes manquent ou ne disent pas la même chose que les cookies (routage
 *      absent : poste local, autre hébergeur), la page n'est PAS mise en cache.
 *   2. Une réponse 200 en HTML, qui ne pose aucun cookie.
 *   3. Un rendu complet : un préchargement en échec (`seedOnServer`) marque la réponse
 *      (`DEGRADED_RESPONSE_HEADER`) — un squelette de panne ne se sert pas à tout le monde
 *      pendant cinq minutes.
 *   4. Pas de nonce. Voir {@link toCacheableSummary}.
 */
import { buildContentSecurityPolicy } from "@/shared/lib/csp";
import { localeFromCookieHeader } from "@/lib/i18n/context";
import { themeFromCookieHeader } from "@/lib/theme/context";

/** En-têtes de requête posés par le routage, à partir des cookies `xp-scholars-*`. */
export const SHELL_LOCALE_HEADER = "x-na9ra-locale";
export const SHELL_THEME_HEADER = "x-na9ra-theme";

/** Marque interne d'un rendu dégradé ; retirée avant que la réponse ne parte. */
export const DEGRADED_RESPONSE_HEADER = "x-na9ra-ssr-degraded";

/**
 * Les chemins des sommaires. ⚠️ Recopié dans `scripts/vercel-routes.mjs` (module sans
 * import, lu par le builder de Vercel) ; `vercel-routes.test.mjs` tient les deux égaux.
 */
export const SUMMARY_PATH_SOURCE = "^/(?:programme(?:/lycee/[^/]+)?|niveau/[^/]+)?$";
const SUMMARY_PATH = new RegExp(SUMMARY_PATH_SOURCE);

/**
 * Cinq minutes au CDN, puis resservie périmée une journée le temps qu'une seule requête
 * la refasse en arrière-plan. Le navigateur, lui, revalide toujours : c'est le PoP qui
 * répond vite, pas le cache local qui garderait une page d'hier.
 */
export const CDN_CACHE_CONTROL = "max-age=300, stale-while-revalidate=86400";
const BROWSER_CACHE_CONTROL = "public, max-age=0, must-revalidate";

export function isSummaryPath(pathname: string): boolean {
  return SUMMARY_PATH.test(pathname);
}

/** La requête peut-elle recevoir — et produire — la version partagée de la page ? */
export function isShareableSummaryRequest(request: Request): boolean {
  if (request.method !== "GET") return false;
  if (request.headers.has("authorization")) return false;
  if (!isSummaryPath(new URL(request.url).pathname)) return false;
  const cookie = request.headers.get("cookie");
  return (
    request.headers.get(SHELL_LOCALE_HEADER) === localeFromCookieHeader(cookie) &&
    request.headers.get(SHELL_THEME_HEADER) === themeFromCookieHeader(cookie)
  );
}

/** Un script exécutable (pas un bloc de données comme `application/ld+json`). */
function isExecutableScript(openingTag: string): boolean {
  const type = /\stype\s*=\s*"([^"]*)"/i.exec(openingTag)?.[1]?.trim().toLowerCase();
  return (
    !type || type === "module" || type === "text/javascript" || type === "application/javascript"
  );
}

async function sha256Base64(text: string): Promise<string> {
  const digest = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(text));
  let binary = "";
  for (const byte of new Uint8Array(digest)) binary += String.fromCharCode(byte);
  return btoa(binary);
}

/**
 * Le HTML d'une page sans son nonce, et la liste des empreintes qui le remplacent.
 *
 * SEULS les scripts qui portent le nonce de CETTE requête sont empreints : ce sont ceux
 * que le framework a émis (amorce d'hydratation, état sérialisé). Un script arrivé par le
 * contenu — l'injection que la CSP existe pour arrêter — n'a pas pu connaître un nonce tiré
 * au hasard pour la requête : il ne reçoit pas d'empreinte, il reste refusé. La garantie est
 * celle du nonce, transportée sur une page qui ne peut plus en porter.
 *
 * `null` si la page n'a pas la forme attendue (pas de nonce) : elle n'est alors pas cachée.
 */
export async function replaceNonceWithHashes(
  html: string,
  nonce: string,
): Promise<{ html: string; hashes: string[] } | null> {
  const nonceAttribute = ` nonce="${nonce}"`;
  if (!html.includes(nonceAttribute)) return null;
  const hashes = new Set<string>();
  for (const match of html.matchAll(/<script\b([^>]*)>([\s\S]*?)<\/script\s*>/gi)) {
    const [, attributes, body] = match;
    if (!attributes.includes(nonceAttribute) || !isExecutableScript(attributes)) continue;
    if (/\ssrc\s*=/i.test(attributes)) continue; // externe : couvert par 'self'
    hashes.add(`sha256-${await sha256Base64(body)}`);
  }
  return { html: html.split(nonceAttribute).join(""), hashes: [...hashes] };
}

/**
 * La version partageable d'une réponse de sommaire — ou la réponse telle quelle, si une
 * seule condition manque. Le corps est lu en entier : sur une page de 30 à 45 Ko, c'est le
 * prix d'une CSP calculée sur les octets exacts qui partent.
 */
export async function toCacheableSummary(response: Response): Promise<Response> {
  const headers = response.headers;
  if (
    response.status !== 200 ||
    !(headers.get("content-type") ?? "").includes("text/html") ||
    headers.has("set-cookie") ||
    headers.has(DEGRADED_RESPONSE_HEADER)
  ) {
    return response;
  }
  const nonce = /'nonce-([^']+)'/.exec(headers.get("content-security-policy") ?? "")?.[1];
  if (!nonce) return response;

  const html = await response.text();
  const rewritten = await replaceNonceWithHashes(html, nonce);
  const outHeaders = new Headers(headers);
  outHeaders.delete("content-length");
  if (!rewritten) return new Response(html, { status: response.status, headers: outHeaders });

  outHeaders.set(
    "content-security-policy",
    buildContentSecurityPolicy(undefined, rewritten.hashes),
  );
  outHeaders.set("cache-control", BROWSER_CACHE_CONTROL);
  outHeaders.set("vercel-cdn-cache-control", CDN_CACHE_CONTROL);
  outHeaders.set("vary", `${SHELL_LOCALE_HEADER}, ${SHELL_THEME_HEADER}`);
  return new Response(rewritten.html, { status: response.status, headers: outHeaders });
}

/** Retire la marque interne de rendu dégradé, quelle que soit la page. */
export function withoutInternalMarks(response: Response): Response {
  if (!response.headers.has(DEGRADED_RESPONSE_HEADER)) return response;
  const headers = new Headers(response.headers);
  headers.delete(DEGRADED_RESPONSE_HEADER);
  return new Response(response.body, {
    status: response.status,
    statusText: response.statusText,
    headers,
  });
}
