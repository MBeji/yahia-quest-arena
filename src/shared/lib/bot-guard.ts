import { isRateLimitedLocal } from "./rate-limit";

/**
 * Edge bot guard — discriminant anti-scraping (Couche 2 du plan de protection IP).
 *
 * Le contenu public est, par conception, lisible sans login : il est donc
 * physiquement « fetchable ». Cette couche augmente le COÛT du fetch automatisé
 * de masse sans nuire au SEO :
 *
 *  - moteurs de recherche + aperçus sociaux/liens sont en liste blanche (jamais
 *    bloqués ni limités) — l'indexation et le partage doivent continuer, c'est la
 *    stratégie même du portail ;
 *  - crawlers d'entraînement d'IA / LLM déclarés et outils HTTP/scraping
 *    génériques sont refusés (403). robots.txt le demande poliment ; ici on le
 *    fait respecter pour ceux qui l'ignorent. Le User-Agent est falsifiable :
 *    c'est un dissuasif, pas une garantie — la vraie couche bord = Cloudflare
 *    devant le domaine ;
 *  - un plafond de rafale par IP (en mémoire, best-effort) freine l'aspiration du
 *    catalogue. Volontairement GÉNÉREUX : les FAI tunisiens utilisent beaucoup de
 *    CGNAT (plusieurs vrais utilisateurs derrière une même IP), il ne faut pas
 *    bloquer une école ou un opérateur entier.
 *
 * Module pur/testable ; `src/server.ts` appelle `guardRequest()` et court-circuite
 * avec la Response retournée si non-nulle.
 */

// Plafond de rafale par IP. Seules les requêtes dynamiques (SSR/HTML/server-fn)
// atteignent la fonction — les assets statiques sont servis par le CDN et ne
// comptent pas — donc un humain reste loin sous ce seuil, un crawler rapide le
// dépasse.
export const RATE_LIMIT_MAX_REQUESTS = 600;
export const RATE_LIMIT_WINDOW_MS = 60_000;

// Crawlers jamais bloqués ni limités : indexation moteurs + aperçus de liens.
// Comparés en sous-chaîne minuscule du User-Agent.
const ALLOWED_CRAWLER_UA = [
  "googlebot",
  "google-inspectiontool",
  "storebot-google",
  "bingbot",
  "slurp", // Yahoo
  "duckduckbot",
  "baiduspider",
  "yandexbot",
  "applebot", // « applebot-extended » (entraînement IA) est traité via robots.txt
  "facebookexternalhit",
  "facebot",
  "twitterbot",
  "linkedinbot",
  "whatsapp",
  "telegrambot",
  "discordbot",
  "slackbot",
  "embedly",
  "pinterest",
];

// Crawlers d'entraînement d'IA / LLM déclarés — refusés d'emblée.
const BLOCKED_AI_UA = [
  "gptbot",
  "chatgpt-user",
  "oai-searchbot",
  "anthropic-ai",
  "claudebot",
  "claude-web",
  "claude-user",
  "ccbot",
  "perplexitybot",
  "perplexity-user",
  "bytespider",
  "amazonbot",
  "meta-externalagent",
  "facebookbot",
  "diffbot",
  "imagesiftbot",
  "omgili",
  "omgilibot",
  "dataforseobot",
  "cohere-ai",
  "cohere-training-data-crawler",
  "ai2bot",
  "timpibot",
  "magpie-crawler",
  "youbot",
  "petalbot",
];

// Aspirateurs SEO/back-links agressifs + outils HTTP/scraping génériques. Un site
// de contenu servant du HTML à des humains n'a aucune raison de leur répondre.
// NB : volontairement PAS de « headlesschrome » ici — Googlebot et nos propres
// tests e2e utilisent un navigateur headless ; le bloquer ferait des dégâts.
const BLOCKED_TOOL_UA = [
  "ahrefsbot",
  "semrushbot",
  "mj12bot",
  "dotbot",
  "blexbot",
  "barkrowler",
  "serpstatbot",
  "megaindex",
  "python-requests",
  "python-urllib",
  "aiohttp",
  "httpx",
  "scrapy",
  "go-http-client",
  "okhttp",
  "java/",
  "libwww-perl",
  "curl/",
  "wget/",
  "node-fetch",
  "axios/",
];

function uaMatches(ua: string, patterns: string[]): boolean {
  return patterns.some((p) => ua.includes(p));
}

/** Crawler en liste blanche (moteur de recherche / aperçu social) ? */
export function isAllowedCrawler(userAgent: string): boolean {
  return uaMatches(userAgent.toLowerCase(), ALLOWED_CRAWLER_UA);
}

/**
 * `true` quand ce User-Agent doit être refusé. Les crawlers en liste blanche
 * (moteurs + social) passent toujours, même si une sous-chaîne correspondrait.
 * Un UA manquant n'est PAS bloqué d'office (trop de faux positifs).
 */
export function isBlockedUserAgent(userAgent: string | null | undefined): boolean {
  if (!userAgent) return false;
  const ua = userAgent.toLowerCase();
  if (uaMatches(ua, ALLOWED_CRAWLER_UA)) return false;
  return uaMatches(ua, BLOCKED_AI_UA) || uaMatches(ua, BLOCKED_TOOL_UA);
}

/** IP cliente best-effort depuis les en-têtes posés par Vercel/Cloudflare. */
export function getClientIp(headers: Headers): string | null {
  const xff = headers.get("x-forwarded-for");
  if (xff) {
    const first = xff.split(",")[0]?.trim();
    if (first) return first;
  }
  return headers.get("x-real-ip") ?? headers.get("cf-connecting-ip") ?? null;
}

function textResponse(
  status: number,
  body: string,
  extraHeaders?: Record<string, string>,
): Response {
  return new Response(body, {
    status,
    headers: {
      "content-type": "text/plain; charset=utf-8",
      "cache-control": "no-store",
      ...extraHeaders,
    },
  });
}

/**
 * Inspecte une requête entrante et renvoie une Response de court-circuit (403
 * pour un agent refusé, 429 pour une IP au-dessus du plafond de rafale), ou
 * `null` pour laisser la requête continuer vers le SSR.
 */
export function guardRequest(request: Request): Response | null {
  const userAgent = request.headers.get("user-agent");

  if (isBlockedUserAgent(userAgent)) {
    return textResponse(403, "Automated access to this content is not permitted. See /robots.txt.");
  }

  // Ne jamais limiter les crawlers en liste blanche (gardés indexables — SEO).
  if (userAgent && isAllowedCrawler(userAgent)) return null;

  const ip = getClientIp(request.headers);
  if (ip && isRateLimitedLocal(`bot-guard:${ip}`, RATE_LIMIT_MAX_REQUESTS, RATE_LIMIT_WINDOW_MS)) {
    return textResponse(429, "Too many requests. Please slow down.", {
      "retry-after": String(Math.ceil(RATE_LIMIT_WINDOW_MS / 1000)),
    });
  }

  return null;
}
