import { QueryClient } from "@tanstack/react-query";
import { createRouter } from "@tanstack/react-router";
import { createIsomorphicFn } from "@tanstack/react-start";
import { setResponseHeader } from "@tanstack/react-start/server";
import { shouldReplayRejectedToken } from "@/shared/integrations/supabase/auth-rejection";
import { buildContentSecurityPolicy } from "@/shared/lib/csp";
import { initBrowserMonitoring } from "@/shared/lib/monitoring";
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

export const getRouter = () => {
  // Install browser error handlers once (no-op on the server / without a DSN).
  initBrowserMonitoring();

  const nonce = resolveCspNonce();

  const queryClient = new QueryClient({
    defaultOptions: {
      queries: {
        // Avoid refetching on every navigation; mutations explicitly invalidate.
        staleTime: 30_000,
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
        // Pourquoi rejouer une mutation n'est pas la faute qu'on croit : ce
        // refus-là est levé par `requireSupabaseAuth` AVANT `next()`, donc avant
        // la moindre ligne de code métier. Rien n'a été écrit, il n'y a donc
        // rien à écrire deux fois. C'est vrai de CE message et d'aucun autre —
        // d'où un prédicat exact plutôt qu'un « ça ressemble à de l'auth ».
        retry: shouldReplayRejectedToken,
      },
    },
  });

  const router = createRouter({
    routeTree,
    context: { queryClient },
    scrollRestoration: true,
    // Cache preloaded route data briefly so hovering/navigating does not refetch.
    defaultPreloadStaleTime: 30_000,
    // Stamp the framework's inline hydration scripts with the per-request nonce
    // so they satisfy the nonce-based CSP (undefined on the client = no-op).
    ssr: nonce ? { nonce } : undefined,
  });

  return router;
};
