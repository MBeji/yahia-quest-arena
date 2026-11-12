import { QueryClient } from "@tanstack/react-query";
import { createRouter } from "@tanstack/react-router";
import { createIsomorphicFn } from "@tanstack/react-start";
import { setResponseHeader } from "@tanstack/react-start/server";
import { shouldReplaySessionRefusal } from "@/shared/integrations/supabase/auth-rejection";
import { loadCatalogue } from "@/lib/i18n/catalogues";
import { getShellLocale } from "@/lib/i18n/shell-locale";
import { buildContentSecurityPolicy } from "@/shared/lib/csp";
import { initBrowserMonitoring } from "@/shared/lib/monitoring";
import { RESUME_REFETCH_AFTER_MS, refetchOnlyIfOlderThan } from "@/shared/lib/query-resume";
import { routeTree } from "./routeTree.gen";

/**
 * Per-request CSP nonce (GAP-022).
 *
 * On the server: mint a fresh nonce, publish it on this HTML response's
 * `Content-Security-Policy` header, and return it so the router can stamp every
 * inline <script> it emits with the same value (via `ssr.nonce`). The header is
 * set on the request's h3 event before any rendering, so it lands on the
 * (possibly streamed) response — the same channel the auth layer uses for
 * cookies. See `src/shared/lib/csp.ts` for the policy and rationale.
 *
 * On the client: a no-op. The SSR'd scripts already carry their nonce in the
 * delivered HTML, and a document's CSP is fixed for its lifetime — the client
 * never re-mints one. The `.server()` branch (and its server-only import) is
 * stripped from the client bundle by the isomorphic boundary.
 */
const resolveCspNonce = createIsomorphicFn()
  .client((): string | undefined => undefined)
  .server((): string | undefined => {
    const nonce = crypto.randomUUID();
    setResponseHeader("Content-Security-Policy", buildContentSecurityPolicy(nonce));
    return nonce;
  });

/**
 * `getRouter` est ASYNCHRONE depuis le 2026-11-12, pour une seule attente : le
 * catalogue de la langue de la requête (le cookie, `getShellLocale`). TanStack Start
 * attend ce retour des deux côtés — avant le rendu serveur, avant l'hydratation —,
 * si bien que le premier rendu sort dans la langue de l'élève et que le client
 * hydrate le MÊME texte. Avant, le serveur rendait toujours du français, que
 * l'hydratation reproduisait avant de basculer (issue #1228,
 * `ssr-body-wrong-language-flash`).
 *
 * Ce que cela coûte : rien pour le français (catalogue dans le graphe statique,
 * promesse déjà résolue) ; pour `en`/`ar`, l'hydratation attend un chunk que
 * `catalogues.ts` a demandé dès l'évaluation du module, en parallèle du reste du
 * graphe. Le chunk d'entrée, lui, ne grossit pas : en/ar restent des `import()`.
 *
 * Un chunk qui ne vient pas (réseau coupé) ne bloque pas le démarrage : on hydrate
 * en français, React répare l'écart de texte, et `I18nProvider` redemande le
 * catalogue après le montage — l'état d'avant ce changement.
 */
export const getRouter = async () => {
  // Install browser error handlers once (no-op on the server / without a DSN).
  initBrowserMonitoring();

  const locale = getShellLocale();
  await loadCatalogue(locale).catch(() => {});

  const nonce = resolveCspNonce();

  const queryClient = new QueryClient({
    defaultOptions: {
      queries: {
        // Avoid refetching on every navigation; mutations explicitly invalidate.
        staleTime: 30_000,
        // Retour d'onglet ou de réseau (2026-10-31, data-02) : un seuil de reprise
        // de 5 min, distinct de la staleTime — le détour calculatrice ne relance
        // plus les 9 server fns du tableau de bord ; les écrans vivants
        // (classement, salon de duel) repassent explicitement à `true`.
        refetchOnWindowFocus: refetchOnlyIfOlderThan(RESUME_REFETCH_AFTER_MS),
        refetchOnReconnect: refetchOnlyIfOlderThan(RESUME_REFETCH_AFTER_MS),
        // Pas de `retry` ici, À DESSEIN : le défaut de la librairie (3 essais)
        // suffit à guérir un jeton refusé — le premier échec arme le drapeau de
        // `auth-attacher`, l'essai suivant repart donc avec un jeton neuf. Le
        // poser explicitement ne ferait qu'écraser ce défaut (et le `0` du SSR).
      },
      mutations: {
        // Les mutations, elles, ne réessaient JAMAIS par défaut (`retry: 0`) :
        // sans cette ligne, un jeton refusé se voyait offrir un rafraîchissement
        // que plus rien ne venait consommer. C'est la panne signalée — l'élève
        // termine son quiz, « Valider » lève « Unauthorized: Invalid token », et
        // ses réponses, qui ne vivent que dans l'état React, partent avec.
        //
        // Pourquoi rejouer une mutation n'est pas la faute qu'on croit : ces
        // refus-là sont levés par `requireSupabaseAuth` AVANT `next()`, donc avant
        // la moindre ligne de code métier. Rien n'a été écrit, il n'y a donc
        // rien à écrire deux fois. C'est vrai des DEUX messages que le prédicat
        // reconnaît (jeton refusé, jeton absent) et d'aucun autre — d'où une
        // liste exacte plutôt qu'un « ça ressemble à de l'auth ».
        retry: shouldReplaySessionRefusal,
      },
    },
  });

  const router = createRouter({
    routeTree,
    context: { queryClient, locale },
    scrollRestoration: true,
    // Cache preloaded route data briefly so hovering/navigating does not refetch.
    defaultPreloadStaleTime: 30_000,
    // Stamp the framework's inline hydration scripts with the per-request nonce
    // so they satisfy the nonce-based CSP (undefined on the client = no-op).
    ssr: nonce ? { nonce } : undefined,
  });

  return router;
};
