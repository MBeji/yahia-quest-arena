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
import { ThemeProvider, useTheme, DEFAULT_THEME, themeFromCookieHeader } from "@/lib/theme";
import type { Theme } from "@/lib/theme";

import appCss from "../styles.css?url";

function NotFoundComponent() {
  const t = useT();
  return (
    <div className="flex min-h-screen items-center justify-center bg-black-deep px-4">
      <div className="max-w-md text-center">
        <h1 className="font-display text-8xl text-gradient-gold">404</h1>
        <h2 className="mt-4 text-xl font-semibold">{t.errors.notFoundTitle}</h2>
        <p className="mt-2 text-sm text-muted-foreground">{t.errors.notFoundDesc}</p>
        <div className="mt-6">
          <Link
            to="/"
            className="inline-flex items-center justify-center rounded-md bg-[image:var(--gradient-gold)] px-5 py-2.5 text-sm font-semibold text-black shadow-gold hover:opacity-90"
          >
            {t.errors.notFoundAction}
          </Link>
        </div>
      </div>
    </div>
  );
}

function ErrorComponent({ error, reset }: { error: Error; reset: () => void }) {
  console.error(error);
  const router = useRouter();
  const t = useT();
  return (
    <div className="flex min-h-screen items-center justify-center bg-black-deep px-4">
      <div className="max-w-md text-center">
        <h1 className="font-display text-2xl">{t.errors.errorTitle}</h1>
        <p className="mt-2 text-sm text-muted-foreground">
          {error.message || t.errors.errorFallback}
        </p>
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
        { rel: "preconnect", href: "https://fonts.googleapis.com" },
        { rel: "preconnect", href: "https://fonts.gstatic.com", crossOrigin: "anonymous" },
        {
          rel: "stylesheet",
          href: "https://fonts.googleapis.com/css2?family=Noto+Kufi+Arabic:wght@600;700&family=Orbitron:wght@500;600;700;800;900&family=Space+Grotesk:wght@400;500;600;700&display=swap",
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
 * TODO(review #8): the cookie is the SSR source of truth, but legacy users who only
 * have the localStorage value (set before this cookie existed) still see one frame of
 * the default locale until their next setLocale call writes the cookie. A one-time
 * migration that mirrors localStorage -> cookie on first mount would close that gap.
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

  // Register the PWA service worker (client + production only). The SW caches
  // immutable assets and serves an offline fallback; HTML is never cached.
  useEffect(() => {
    if (import.meta.env.PROD && typeof navigator !== "undefined" && "serviceWorker" in navigator) {
      navigator.serviceWorker.register("/sw.js").catch(() => {});
    }
  }, []);

  return (
    <QueryClientProvider client={queryClient}>
      <ThemeProvider>
        <I18nProvider>
          <Outlet />
          <ThemedToaster />
        </I18nProvider>
      </ThemeProvider>
    </QueryClientProvider>
  );
}

/** Toaster whose colour scheme follows the active UI theme. */
function ThemedToaster() {
  const { theme } = useTheme();
  return <Toaster richColors theme={theme} position="top-center" />;
}
