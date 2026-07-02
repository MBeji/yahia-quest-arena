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
export function buildContentSecurityPolicy(nonce?: string): string {
  // Google Analytics 4 (gtag.js) loads from this host as an external <script>.
  // We do NOT use 'strict-dynamic', so listing the host alongside the nonce keeps
  // it effective (see src/shared/lib/analytics.ts).
  const gaScript = "https://www.googletagmanager.com";
  // With a nonce, `'self'` still allows the hashed /assets/*.js chunks (we do
  // not use 'strict-dynamic', so host-source allowlisting stays effective);
  // the nonce allows the framework's inline scripts. No 'unsafe-inline'.
  const scriptSrc = nonce
    ? `script-src 'self' 'nonce-${nonce}' ${gaScript}`
    : `script-src 'self' ${gaScript}`;
  return [
    "default-src 'self'",
    scriptSrc,
    // Google Fonts: the stylesheet is served from fonts.googleapis.com and the
    // woff2 files from fonts.gstatic.com (see the <link>s in routes/__root.tsx).
    // 'unsafe-inline' stays — Tailwind/charting inject inline <style> (scoped out).
    "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com",
    "img-src 'self' data: blob: https:",
    "font-src 'self' data: https://fonts.gstatic.com",
    // Supabase API/realtime + the GA4 collect endpoints (gtag.js beacons the
    // measurement protocol to the regional google-analytics.com hosts).
    "connect-src 'self' https://*.supabase.co wss://*.supabase.co https://www.googletagmanager.com https://www.google-analytics.com https://*.google-analytics.com https://*.analytics.google.com",
    "frame-ancestors 'none'",
    "base-uri 'self'",
    "form-action 'self'",
    "object-src 'none'",
  ].join("; ");
}
