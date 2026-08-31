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
import { Toaster } from "@/components/ui/sonner";
import { I18nProvider, useT } from "@/lib/i18n";
import type { Locale } from "@/lib/i18n";
import { DEFAULT_LOCALE, dirForLocale, localeFromCookieHeader } from "@/lib/i18n/context";
import { fr } from "@/lib/i18n/fr";
import { en } from "@/lib/i18n/en";
import { ar } from "@/lib/i18n/ar";
import { buildErrorDebugText } from "@/shared/lib/error-debug";
import { ThemeProvider, useTheme, DEFAULT_THEME, themeFromCookieHeader } from "@/lib/theme";
import type { Theme } from "@/lib/theme";
import { SoundProvider, useSound } from "@/lib/sound";
import { logger } from "@/shared/lib/logger";
import { initAnalytics, trackPageview, pagePathFromLocation } from "@/shared/lib/analytics";
import { initWebVitals } from "@/shared/lib/web-vitals";
import { initHiddenTimeTracking } from "@/shared/lib/client-log";

import appCss from "../styles.css?url";

function NotFoundComponent() {
  const t = useT();
  return (
    <div className="flex min-h-screen items-center justify-center bg-black-deep px-4">
      <div className="max-w-md text-center">
        <h1 className="font-display text-6xl text-gradient-gold sm:text-8xl">404</h1>
        <h2 className="mt-4 text-xl font-semibold">{t.errors.notFoundTitle}</h2>
        <p className="mt-2 text-sm text-muted-foreground">{t.errors.notFoundDesc}</p>
        <div className="mt-6">
          <Link
            to="/"
            className="inline-flex items-center justify-center rounded-md bg-[image:var(--gradient-gold)] px-5 py-2.5 text-sm font-semibold text-primary-foreground shadow-gold hover:opacity-90"
          >
            {t.errors.notFoundAction}
          </Link>
        </div>
      </div>
    </div>
  );
}

function ErrorComponent({ error, reset }: { error: Error; reset: () => void }) {
  logger.error("Root error boundary caught an error", { error });
  const router = useRouter();
  const t = useT();
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
    <div className="flex min-h-screen items-center justify-center bg-black-deep px-4">
      <div className="max-w-md text-center">
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
            onClick={() => {
              router.invalidate();
              reset();
            }}
            className="rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground hover:opacity-90"
          >
            {t.common.retry}
          </button>
          <a href="/" className="rounded-md border border-input bg-black-deep px-4 py-2 text-sm">
            {t.common.home}
          </a>
        </div>
      </div>
    </div>
  );
}

export const Route = createRootRouteWithContext<{ queryClient: QueryClient }>()({
  head: () => {
    // Per-request locale for the document meta: getShellLocale() reads the
    // persisted cookie at SSR (and document.cookie on the client), so the
    // <title>/description/OG match the visitor's language for crawlers and social
    // shares. head() is a closure evaluated at render time, after the module is
    // fully initialised, so it can reference getShellLocale (defined below).
    const locale = getShellLocale();
    const m = ({ fr, en, ar }[locale] ?? fr).meta;
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
        { name: "twitter:card", content: "summary_large_image" },
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
        // latines — celles que tout premier écran utilise. L'arabe n'est pas
        // préchargé : son `unicode-range` le déclenche seulement sur du contenu
        // arabe, et le précharger ferait payer 124 ko à tous les autres.
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
 * Resolve the locale for the SSR document shell from the persisted cookie so that
 * <html lang/dir> is correct on first paint (no RTL FOUC for Arabic users).
 *
 * Hydration safety: the client provider (I18nProvider) starts at DEFAULT_LOCALE
 * and only applies the persisted locale in a post-mount effect, so the *body*
 * markup the client first renders matches the server. The <html> attributes here
 * are set from the same cookie the client reads, so they agree on both sides.
 *
 * Legacy localStorage-only users (preference set before this cookie existed) are
 * migrated automatically: I18nProvider mirrors the resolved locale into the cookie
 * on first mount when it's missing/stale, so subsequent SSR loads paint the right
 * locale with no flash of the default.
 */
const getShellLocale = createIsomorphicFn()
  // Client (hydration / client navigation): read the document cookie directly.
  .client((): Locale => localeFromCookieHeader(document.cookie))
  // Server: read the request Cookie header. This branch (and its server-only
  // import) is stripped from the client bundle by the isomorphic boundary.
  .server((): Locale => {
    try {
      return localeFromCookieHeader(getRequestHeader("cookie"));
    } catch {
      return DEFAULT_LOCALE;
    }
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
  const { queryClient } = Route.useRouteContext();
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
      trackPageview(pagePathFromLocation(router.state.location));
    };
    track();
    return router.subscribe("onResolved", track);
  }, [router]);

  return (
    <QueryClientProvider client={queryClient}>
      <ThemeProvider>
        <I18nProvider>
          <SoundProvider>
            <GlobalSoundEffects />
            <Outlet />
            <ThemedToaster />
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
 *  `light` are light-family registers; only `dark` is a dark scheme. */
function ThemedToaster() {
  const { theme } = useTheme();
  return <Toaster richColors theme={theme === "dark" ? "dark" : "light"} position="top-center" />;
}
