import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import {
  Outlet,
  Link,
  createRootRouteWithContext,
  useRouter,
  HeadContent,
  Scripts,
} from "@tanstack/react-router";
import { createIsomorphicFn } from "@tanstack/react-start";
import { getRequestHeader } from "@tanstack/react-start/server";
import { useEffect } from "react";
import { LazyToaster } from "@/components/ui/lazy-toaster";
import { I18nProvider, useT } from "@/lib/i18n";
import type { Locale } from "@/lib/i18n";
import { GuideProvider } from "@/components/guide/guide-provider";
import { dirForLocale } from "@/lib/i18n/context";
import { headCatalogue } from "@/lib/i18n/head";
import { getShellLocale } from "@/lib/i18n/shell-locale";
import { metaByLocale } from "@/lib/i18n/meta";
import { SOCIAL_IMAGE } from "@/shared/constants/site";
import { buildErrorDebugText } from "@/shared/lib/error-debug";
import { useExitOnRefusedSession } from "@/features/auth";
import { ThemeProvider, useTheme, DEFAULT_THEME, themeFromCookieHeader } from "@/lib/theme";
import type { Theme } from "@/lib/theme";
import { SoundProvider, useSound } from "@/lib/sound";
import { logger } from "@/shared/lib/logger";
import { initAnalytics, trackPageview, pagePathFromLocation } from "@/shared/lib/analytics";
import { notePageForFunnel } from "@/shared/lib/funnel-origin";
import { initWebVitals } from "@/shared/lib/web-vitals";
import { initHiddenTimeTracking } from "@/shared/lib/client-log";

import appCss from "../styles.css?url";

/** Une issue d'écran sans issue : 44 px de haut, la garde tactile. */
const EXIT_PRIMARY =
  "inline-flex min-h-11 items-center justify-center rounded-md bg-primary px-5 text-sm font-semibold text-primary-foreground hover:opacity-90";
const EXIT_SECONDARY =
  "inline-flex min-h-11 items-center justify-center rounded-md border border-input bg-background px-5 text-sm font-medium hover:bg-accent";

/**
 * La page 404. Elle se rend HORS de toute coquille (aucune route n'a répondu) : elle
 * porte donc elle-même son `<main>`, dans le registre sobre des pages publiques — c'est
 * un visiteur venu d'un lien mort qui la voit, pas un élève en mission — et deux issues,
 * l'accueil et le programme, là où il n'y en avait qu'une.
 */
function NotFoundComponent() {
  const t = useT();
  return (
    <main className="flex min-h-[100dvh] items-center justify-center bg-background px-4 text-foreground">
      <div className="max-w-md text-center">
        <p aria-hidden="true" className="font-display text-6xl font-bold text-primary sm:text-8xl">
          404
        </p>
        <h1 className="mt-4 text-xl font-semibold">{t.errors.notFoundTitle}</h1>
        <p className="mt-2 text-sm text-muted-foreground">{t.errors.notFoundDesc}</p>
        <div className="mt-6 flex flex-wrap justify-center gap-2">
          <Link to="/" className={EXIT_PRIMARY}>
            {t.errors.notFoundAction}
          </Link>
          <Link to="/programme" className={EXIT_SECONDARY}>
            {t.public.header.programme}
          </Link>
        </div>
      </div>
    </main>
  );
}

// `error` est `unknown` : TanStack Router le type ainsi depuis le lot de dépendances du 2026-09-22 (on
// peut lever autre chose qu'une Error), et `Error` n'y était qu'une promesse. Normalisé une
// fois ici, il compile sous les deux versions.
function ErrorComponent({ error: thrown, reset }: { error: unknown; reset: () => void }) {
  const error = thrown instanceof Error ? thrown : new Error(String(thrown));
  logger.error("Root error boundary caught an error", { error });
  const router = useRouter();
  // PAS `useT()` : cette frontière REMPLACE `RootComponent`, donc `I18nProvider`
  // n'est plus au-dessus d'elle et le contexte retombait sur sa valeur par défaut —
  // du français pour tout le monde, mis en page de gauche à droite (issue #1228,
  // `root-error-boundary-wrong-language-direction`). Le catalogue de la langue de
  // la requête est chargé avant tout rendu (`router.tsx`) : on le lit directement,
  // et l'écran porte lui-même `lang`/`dir` au cas où `<html>` ne les aurait plus.
  const locale = getShellLocale();
  const t = headCatalogue();
  useExitOnRefusedSession(error);
  // Incident forensics: with `?debug=1` in the URL, surface the error identity
  // on the page itself — the only reliable diagnostic channel for mobile users
  // (no devtools). Client-only read; hidden for everyone else. The stack trace
  // (internal module structure) is withheld in production so an anonymous
  // visitor never receives it — see buildErrorDebugText.
  const debugText =
    typeof window !== "undefined" && new URLSearchParams(window.location.search).has("debug")
      ? buildErrorDebugText(error, import.meta.env.PROD)
      : null;
  return (
    // `data-testid` : la frontière d'erreur racine est le CUL-DE-SAC que l'e2e
    // doit pouvoir nommer sans dépendre de la langue (`errorTitle` existe en
    // fr/en/ar). C'est l'écran qu'une session morte ne doit JAMAIS produire —
    // voir `e2e/authed/session-invalidation.spec.ts` (#938).
    <main
      data-testid="root-error-boundary"
      lang={locale}
      dir={dirForLocale(locale)}
      className="flex min-h-[100dvh] items-center justify-center bg-background px-4 text-foreground"
    >
      {/* `role="alert"` : l'écran remplace la page sans rechargement, donc un lecteur
          d'écran n'apprenait rien de la panne tant qu'il ne relisait pas tout. */}
      <div role="alert" className="max-w-md text-center">
        <h1 className="font-display text-2xl">{t.errors.errorTitle}</h1>
        <p className="mt-2 text-sm text-muted-foreground">
          {error.message || t.errors.errorFallback}
        </p>
        {debugText ? (
          // rtl-ok: une trace technique est toujours LTR, même en page AR.
          <pre
            dir="ltr"
            className="mt-4 max-h-72 overflow-auto rounded-md border border-input p-3 text-left text-xs whitespace-pre-wrap break-all text-muted-foreground"
          >
            {debugText}
          </pre>
        ) : null}
        <div className="mt-6 flex flex-wrap justify-center gap-2">
          <button
            type="button"
            onClick={() => {
              router.invalidate();
              reset();
            }}
            className={EXIT_PRIMARY}
          >
            {t.common.retry}
          </button>
          <a href="/" className={EXIT_SECONDARY}>
            {t.common.home}
          </a>
        </div>
      </div>
    </main>
  );
}

export const Route = createRootRouteWithContext<{ queryClient: QueryClient; locale: Locale }>()({
  head: () => {
    // Per-request locale for the document meta: getShellLocale() reads the
    // persisted cookie at SSR (and document.cookie on the client), so the
    // <title>/description/OG match the visitor's language for crawlers and social
    // shares.
    const locale = getShellLocale();
    const m = metaByLocale[locale];
    return {
      meta: [
        { charSet: "utf-8" },
        { name: "viewport", content: "width=device-width, initial-scale=1, viewport-fit=cover" },
        { title: m.title },
        { name: "description", content: m.description },
        { name: "author", content: "Na9ra Nal3ab" },
        { name: "copyright", content: `© ${new Date().getFullYear()} Na9ra Nal3ab` },
        { property: "og:site_name", content: "Na9ra Nal3ab" },
        { property: "og:title", content: m.ogTitle },
        { property: "og:description", content: m.ogDescription },
        { property: "og:type", content: "website" },
        { property: "og:image", content: SOCIAL_IMAGE.url },
        { property: "og:image:width", content: String(SOCIAL_IMAGE.width) },
        { property: "og:image:height", content: String(SOCIAL_IMAGE.height) },
        { property: "og:image:alt", content: m.ogTitle },
        { name: "twitter:card", content: "summary_large_image" },
        { name: "twitter:image", content: SOCIAL_IMAGE.url },
        // PWA / mobile install
        { name: "theme-color", content: "#0a0a0a" },
        { name: "mobile-web-app-capable", content: "yes" },
        { name: "apple-mobile-web-app-capable", content: "yes" },
        { name: "apple-mobile-web-app-status-bar-style", content: "black-translucent" },
        { name: "apple-mobile-web-app-title", content: "Na9ra Nal3ab" },
      ],
      links: [
        { rel: "stylesheet", href: appCss },
        { rel: "manifest", href: "/manifest.webmanifest" },
        { rel: "icon", href: "/favicon.svg", type: "image/svg+xml" },
        { rel: "icon", href: "/icons/icon-192.png", type: "image/png", sizes: "192x192" },
        { rel: "apple-touch-icon", href: "/icons/apple-touch-icon.png" },
        // Fontes auto-hébergées (levier 06) : les @font-face vivent dans
        // styles.css, il ne reste ici que le préchargement des DEUX faces
        // latines — celles que tout premier écran utilise. Rien d'arabe ici,
        // même pour la locale `ar` (mesuré le 2026-10-31, bundle-03) : l'UI
        // arabe se rend en police système, la face Noto Kufi complète (124 ko)
        // n'a plus aucun consommateur depuis que la signature de marque porte
        // sa sous-police de 6,8 ko, et un preload dans ce head() partirait en
        // haute priorité sur CHAQUE page, publique ou non — « preloaded but
        // not used » et 124 ko payés par tous.
        // `crossOrigin` est requis même en same-origin : une fonte se récupère
        // en mode CORS, et sans lui le navigateur télécharge le fichier DEUX
        // fois (le préchargement ne matche pas la requête de la fonte).
        {
          rel: "preload",
          href: "/fonts/space-grotesk-latin-var.woff2",
          as: "font",
          type: "font/woff2",
          crossOrigin: "anonymous",
        },
        {
          rel: "preload",
          href: "/fonts/orbitron-latin-var.woff2",
          as: "font",
          type: "font/woff2",
          crossOrigin: "anonymous",
        },
      ],
    };
  },
  shellComponent: RootShell,
  component: RootComponent,
  notFoundComponent: NotFoundComponent,
  errorComponent: ErrorComponent,
});

/**
 * Resolve the UI theme for the SSR shell from the persisted cookie so the
 * <html class="dark|light"> is correct on first paint (no flash of the wrong
 * theme). The client branch reads the same cookie during hydration, so both
 * sides agree on the <html> class. See ThemeProvider for the runtime sync.
 */
const getShellTheme = createIsomorphicFn()
  .client((): Theme => themeFromCookieHeader(document.cookie))
  .server((): Theme => {
    try {
      return themeFromCookieHeader(getRequestHeader("cookie"));
    } catch {
      return DEFAULT_THEME;
    }
  });

function RootShell({ children }: { children: React.ReactNode }) {
  const locale = getShellLocale();
  const theme = getShellTheme();
  return (
    <html lang={locale} dir={dirForLocale(locale)} className={theme}>
      <head>
        <HeadContent />
      </head>
      <body>
        {children}
        <Scripts />
      </body>
    </html>
  );
}

function RootComponent() {
  const { queryClient, locale } = Route.useRouteContext();
  const router = useRouter();

  // Register the PWA service worker (client + production only). The SW caches
  // immutable assets and serves an offline fallback; HTML is never cached.
  useEffect(() => {
    if (import.meta.env.PROD && typeof navigator !== "undefined" && "serviceWorker" in navigator) {
      navigator.serviceWorker.register("/sw.js").catch(() => {});
    }
  }, []);

  // Le filet de sauvegarde, installé pour toute l'application.
  //
  // POURQUOI ICI ET PAS DANS LA ROUTE DE QUÊTE. Une soumission restée en file
  // appartient à la session PRÉCÉDENTE : l'élève a rechargé, fermé l'onglet, ou
  // rouvert l'app le lendemain. L'installer sur la route de quête ne la
  // rejouerait qu'au moment où il retourne de lui-même sur une mission — c'est
  // exactement le moment où il croit son travail perdu.
  //
  // ⚠️ LA FILE ET LA QUÊTE SONT TOUTES DEUX EN IMPORT DYNAMIQUE, ET CE N'EST PAS
  // NÉGOCIABLE. Tout ce que `__root` importe STATIQUEMENT entre dans le chunk
  // `index` et son budget de 450 ko — y compris une simple constante : nommer
  // `QUEST_SUBMIT_KIND` depuis ici suffisait à y faire entrer `quest-draft.ts`,
  // et le budget passait à 452,26 ko (rouge en CI, PR #918). Sortir la seule
  // constante en rendait 1,26 ; sortir aussi `outbox.ts` a rendu le reste. Même
  // piège que celui déjà signalé dans le barrel pour `recall-messages`.
  //
  // Rien n'est perdu à différer : un flush est un travail de FOND, il n'a aucune
  // raison d'être synchrone au montage. `initHiddenTimeTracking`, lui, reste
  // statique — il doit compter dès la première milliseconde, et `client-log.ts`
  // est de toute façon déjà dans le chunk, tiré par `auth-attacher`.
  useEffect(() => {
    // Le compteur de temps caché doit tourner DÈS le chargement : quand un refus
    // survient, il est trop tard pour se demander depuis combien de temps
    // l'onglet dormait. C'est l'une des trois grandeurs qui départagent les
    // hypothèses (voir 20260831140000_client_errors_telemetry.sql).
    const stopHiddenTracking = initHiddenTimeTracking();
    let stopOutbox: (() => void) | undefined;
    let unmounted = false;

    void (async () => {
      const [outbox, quest] = await Promise.all([
        import("@/shared/lib/outbox"),
        import("@/features/quest"),
      ]);
      // Démonté avant que les deux modules n'arrivent : ne rien installer, il n'y
      // aurait plus personne pour le démonter.
      if (unmounted) return;
      quest.registerQuestOutboxSender();
      stopOutbox = outbox.startOutbox();
      await outbox.flush();
    })().catch(() => {});

    return () => {
      unmounted = true;
      stopOutbox?.();
      stopHiddenTracking();
    };
  }, []);

  // Google Analytics 4: load gtag.js once, then report a page_view for the
  // current location and on every resolved SPA navigation. All calls no-op
  // outside a production build (see analytics.ts).
  useEffect(() => {
    initAnalytics();
    // Real User Monitoring (perf audit M-1): the team could see 500s but was
    // blind to p95 / LCP growth. Dependency-free, reports once on page hide.
    initWebVitals();
    const track = () => {
      const path = pagePathFromLocation(router.state.location);
      // é38 lot 0 : d'où venait un clic de compte ? La dernière page, en mémoire seulement.
      notePageForFunnel(path);
      trackPageview(path);
    };
    track();
    return router.subscribe("onResolved", track);
  }, [router]);

  return (
    <QueryClientProvider client={queryClient}>
      <ThemeProvider>
        <I18nProvider initialLocale={locale}>
          <SoundProvider>
            <GuideProvider>
              <GlobalSoundEffects />
              <Outlet />
              <ThemedToaster />
            </GuideProvider>
          </SoundProvider>
        </I18nProvider>
      </ThemeProvider>
    </QueryClientProvider>
  );
}

/**
 * Global audio glue that needs router + sound context: a soft "whoosh" on every
 * SPA navigation, and switching the ambient-music mood to the darker theme while
 * in the Dungeon. Rendered inside SoundProvider; renders nothing.
 */
function GlobalSoundEffects() {
  const router = useRouter();
  const { play, setMusicMood } = useSound();

  useEffect(() => {
    // Skip the very first resolution (initial load) — only cue real navigations.
    let first = true;
    const applyMood = () => {
      const path = router.state.location.pathname;
      setMusicMood(path.startsWith("/dungeon") ? "dungeon" : "calm");
    };
    applyMood();
    return router.subscribe("onResolved", () => {
      applyMood();
      if (first) {
        first = false;
        return;
      }
      play("whoosh");
    });
  }, [router, play, setMusicMood]);

  return null;
}

/** Toaster whose colour scheme follows the active UI theme. `reference` and
 *  `light` are light-family registers; only `dark` is a dark scheme. Chargé après
 *  l'hydratation (`lazy-toaster.tsx`) : `sonner` ne pèse plus sur le chunk d'entrée. */
function ThemedToaster() {
  const { theme } = useTheme();
  return (
    <LazyToaster richColors theme={theme === "dark" ? "dark" : "light"} position="top-center" />
  );
}
