/**
 * Content-Security-Policy for the app's HTML responses (GAP-022).
 *
 * Built per-request and published on the `Content-Security-Policy` response
 * header from the SSR handler (`src/router.tsx`) so that `script-src` carries a
 * per-request `'nonce-…'` instead of `'unsafe-inline'`. The same nonce is handed
 * to the router via its `ssr.nonce` option, which stamps every inline <script>
 * TanStack Start emits (hydration bootstrap, dehydrated state). Result: the
 * framework's own inline scripts execute, while an injected inline script (the
 * classic stored/reflected XSS payload) is refused by the browser.
 *
 * Why this lives in the SSR function and NOT in the static Vercel routing
 * headers (`scripts/build-vercel.mjs`): a nonce must be fresh per request, and
 * Vercel's Build Output `config.json` headers are static. The other security
 * headers (HSTS, X-Frame-Options, Referrer-Policy, Permissions-Policy,
 * X-Content-Type-Options) stay static there — they need no per-request value and
 * apply to every response, including static assets. CSP on a static asset is
 * inert (CSP governs documents), so only HTML responses — all served by this
 * function — need it.
 *
 * `style-src` intentionally keeps `'unsafe-inline'`: Tailwind and the charting
 * primitives inject inline <style>, and inline styles are not nonce-covered the
 * way scripts are. Tightening styles is out of scope for GAP-022.
 */
import { POSTHOG_HOST } from "@/shared/lib/product-analytics";

export function buildContentSecurityPolicy(nonce?: string): string {
  // Google Analytics 4 (gtag.js) loads from this host as an external <script>.
  // We do NOT use 'strict-dynamic', so listing the host alongside the nonce keeps
  // it effective (see src/shared/lib/analytics.ts).
  const gaScript = "https://www.googletagmanager.com";
  // Les hôtes vers lesquels gtag.js émet réellement ses balises /g/collect.
  // Deux d'entre eux sont faciles à manquer, et l'ont été jusqu'à ce qu'une
  // console navigateur sur la prod montre les blocages (constat 2026-08-19 :
  // `page_view` et `scroll` refusés en silence, gate serveur au vert) :
  //   • `analytics.google.com` est un domaine NU. En CSP, un joker d'hôte exige
  //     au moins un label de sous-domaine : `*.analytics.google.com` ne le
  //     couvre PAS. Les deux entrées sont nécessaires, aucune ne remplace l'autre.
  //   • `www.google.com` reçoit lui aussi /g/collect (signaux Google, endpoints
  //     régionaux). Listé étroitement : ne jamais élargir en `*.google.com`, qui
  //     ouvrirait toute propriété Google comme destination de fetch.
  const gaCollect = [
    "https://www.google-analytics.com",
    "https://*.google-analytics.com",
    "https://analytics.google.com",
    "https://*.analytics.google.com",
    "https://www.google.com",
  ].join(" ");
  // With a nonce, `'self'` still allows the hashed /assets/*.js chunks (we do
  // not use 'strict-dynamic', so host-source allowlisting stays effective);
  // the nonce allows the framework's inline scripts. No 'unsafe-inline'.
  const scriptSrc = nonce
    ? `script-src 'self' 'nonce-${nonce}' ${gaScript}`
    : `script-src 'self' ${gaScript}`;
  return [
    "default-src 'self'",
    scriptSrc,
    // Les fontes sont AUTO-HÉBERGÉES (levier 06) : plus de feuille tierce, donc
    // `fonts.googleapis.com` sort de `style-src` et `fonts.gstatic.com` de
    // `font-src`. La politique dit maintenant ce qui est vrai — aucune fonte ne
    // peut plus venir d'un tiers, et l'IP d'un élève n'y voyage plus.
    // 'unsafe-inline' stays — Tailwind/charting inject inline <style> (scoped out).
    "style-src 'self' 'unsafe-inline'",
    "img-src 'self' data: blob: https:",
    "font-src 'self' data:",
    // Supabase API/realtime + the GA4 collect endpoints (gtag.js beacons the
    // measurement protocol to the hosts listed in `gaCollect` above — read the
    // comment there before touching that list, the bare/wildcard distinction is
    // load-bearing).
    // …and the PostHog ingest origin (product analytics — plain `fetch`, no SDK
    // and no external <script>, so `script-src` stays untouched; see
    // src/shared/lib/product-analytics.ts). Read from the SAME constant the
    // sender uses, so an env override can never leave the policy behind.
    `connect-src 'self' https://*.supabase.co wss://*.supabase.co https://www.googletagmanager.com ${gaCollect} ${POSTHOG_HOST}`,
    // Curated explainer videos (étude 23): the ONLY host we embed in an iframe,
    // and only after the user clicks the privacy facade (no iframe exists in the
    // DOM before then — étude 23 R-4/D-6). This directive is the technical proof
    // that no other video host can ever appear; adding a provider is a reviewed
    // code change here, never a data change. `youtube-nocookie` sets no cookie
    // before Play. No `enablejsapi`, so `connect-src`/`script-src` stay untouched.
    "frame-src https://www.youtube-nocookie.com",
    "frame-ancestors 'none'",
    "base-uri 'self'",
    "form-action 'self'",
    "object-src 'none'",
  ].join("; ");
}
