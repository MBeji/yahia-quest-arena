/**
 * Le routage Vercel (Build Output API v3, `config.json`) — UNE seule source, lue
 * par `build-vercel.mjs` et par son test.
 *
 * Module JS pur, sans import ni effet de bord, comme `vercel-function.mjs` : le
 * builder de Vercel l'exécute avec sa propre version de Node, et le test Vitest
 * l'importe sans passer par le `vite build` que `build-vercel.mjs` lance.
 *
 * Les routes à `continue: true` posent des en-têtes puis laissent la main ;
 * `handle: filesystem` sert ce qui existe dans `static/` (le `dist/client`, donc
 * `public/` compris) ; tout le reste tombe dans la fonction SSR.
 *
 * ⚠️ CACHE-CONTROL. Sans règle, Vercel sert un fichier statique en
 * `public, max-age=0, must-revalidate` : le navigateur le revalide à CHAQUE
 * chargement complet (une requête conditionnelle, un 304, un aller-retour vers
 * le PoP — ≈ 50 ms sur connexion ouverte depuis ce conteneur, 80-250 ms sur un
 * mobile tunisien). C'est le bon réglage pour `sw.js` (une mise à jour du
 * service worker doit partir tout de suite) et pour `offline.html`/`robots.txt`,
 * mais pas pour :
 *   • `/assets/*` — noms hachés par Vite : immuables par construction ;
 *   • `/fonts/*` — URL NON hachées (`styles.css`, `__root.tsx`) mais fichiers
 *     figés : un an immuable, et une fonte qui change CHANGE DE NOM de fichier.
 *     Sans cette règle les deux faces latines préchargées repartaient en 304 à
 *     chaque ouverture (relevé en prod le 2026-10-31 puis le 2026-11-03) : texte
 *     rendu d'abord en police de repli, puis échangé — un décalage de mise en
 *     page par chargement, sur le chemin critique du texte ;
 *   • icônes, favicon, manifest — un jour, resservis périmés pendant une semaine
 *     le temps de revalider en arrière-plan : hors chemin critique, mais
 *     inutile de les revalider à chaque ouverture.
 *
 * ⚠️ Ces règles s'appliquent au CHEMIN, pas au fichier : un chemin absent sous
 * `/fonts/` ou `/icons/` passe `handle: filesystem` sans rien trouver, tombe dans
 * la fonction SSR, et sa page 404 HTML part avec le même `Cache-Control` (motif
 * identique à `/assets/`, depuis toujours). Inoffensif tant qu'aucune page ne
 * référence un fichier manquant — y penser avant d'ajouter une règle ici.
 */
export const VERCEL_ROUTES = [
  // Static security headers on every response (then continue routing).
  // The Content-Security-Policy is deliberately NOT here: it needs a
  // per-request nonce so script-src can drop 'unsafe-inline' (GAP-022), and
  // Build Output headers are static. It is set on each HTML response by the
  // SSR function instead — see src/router.tsx + src/shared/lib/csp.ts.
  // (CSP on static assets is inert; only HTML documents need it.)
  {
    src: "/(.*)",
    headers: {
      "X-Content-Type-Options": "nosniff",
      "X-Frame-Options": "DENY",
      "Referrer-Policy": "strict-origin-when-cross-origin",
      "Strict-Transport-Security": "max-age=63072000; includeSubDomains; preload",
      "Permissions-Policy": "camera=(), microphone=(), geolocation=(), browsing-topics=()",
    },
    continue: true,
  },
  // Les bundles hachés par Vite : immuables par construction.
  {
    src: "/assets/(.*)",
    headers: { "Cache-Control": "public, max-age=31536000, immutable" },
    continue: true,
  },
  // Les fontes auto-hébergées : fichiers figés derrière des URL non hachées —
  // une fonte qui change prend un nouveau nom de fichier, la copie en cache est
  // donc immuable (voir l'en-tête du module).
  {
    src: "/fonts/(.*)",
    headers: { "Cache-Control": "public, max-age=31536000, immutable" },
    continue: true,
  },
  // Icônes PWA, favicon, manifest : hors chemin critique, revalidés en
  // arrière-plan au plus une fois par jour.
  {
    src: "/(icons/.*|favicon\\.svg|manifest\\.webmanifest)",
    headers: { "Cache-Control": "public, max-age=86400, stale-while-revalidate=604800" },
    continue: true,
  },
  // Les fichiers statiques existants sont servis tels quels (sw.js, offline.html,
  // robots.txt gardent le défaut Vercel : revalidation à chaque chargement).
  { handle: "filesystem" },
  // Tout le reste → fonction SSR.
  { src: "/(.*)", dest: "/index" },
];
