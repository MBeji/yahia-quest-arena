import { Link } from "@tanstack/react-router";
import { useT } from "@/lib/i18n";
import { useAuth } from "@/features/auth";
import { LanguageSwitcher } from "@/components/ui/language-switcher";
import { ThemeSwitcher } from "@/components/ui/theme-switcher";
import { AccountHud } from "@/components/account-hud";

/**
 * Header of the public (Référence register) shell. Sober, content-first, and
 * AUTH-AWARE: a signed-in visitor — who now reaches public content via the
 * converged « Découvrir » nav, a course link, etc. — sees a link back to their
 * space, never the login/signup CTAs (which would wrongly read as "logged out").
 * Copy is i18n (fr/en/ar).
 */
export function PublicHeader() {
  const t = useT();
  const { user } = useAuth();
  const isAuthed = user != null;
  return (
    <header className="sticky top-0 z-30 border-b border-border bg-card/90 pt-[env(safe-area-inset-top)] backdrop-blur print:hidden">
      <div className="mx-auto flex max-w-5xl items-center justify-between gap-2 px-4 py-3 sm:gap-3 sm:px-6">
        <div className="flex items-center gap-3 sm:gap-6">
          {/* Brand = home. AUTH-AWARE destination: a signed-in visitor who reached
              this public shell via the converged « Découvrir » nav is sent back to
              their connected space (`/dashboard`), NOT the logged-out landing (`/`)
              — tapping the logo used to strand them on the public home that reads as
              "not logged in" (issue #312). Logged-out visitors still go to `/`. */}
          <Link
            to={isAuthed ? "/dashboard" : "/"}
            className="flex items-baseline gap-2"
            aria-label={isAuthed ? t.public.header.account : t.public.header.homeAria}
          >
            <span className="font-display text-lg font-bold tracking-tight text-primary">
              Na9ra Nal3ab
            </span>
            <span
              lang="ar"
              dir="rtl"
              aria-hidden="true"
              className="hidden font-arabic text-sm font-semibold text-muted-foreground sm:inline"
            >
              نقرا نلعب
            </span>
          </Link>
          <nav
            className="hidden items-center gap-0.5 sm:flex sm:gap-1"
            aria-label={t.public.header.navAria}
          >
            <Link
              to="/programme"
              className="inline-flex items-center rounded-lg px-2.5 py-2 text-sm font-medium text-muted-foreground transition hover:text-foreground sm:px-3 [@media(pointer:coarse)]:min-h-11"
            >
              {t.public.header.programme}
            </Link>
            <Link
              to="/extras"
              className="inline-flex items-center rounded-lg px-2.5 py-2 text-sm font-medium text-muted-foreground transition hover:text-foreground sm:px-3 [@media(pointer:coarse)]:min-h-11"
            >
              {t.public.header.extras}
            </Link>
          </nav>
        </div>
        <div className="flex items-center gap-1 sm:gap-2">
          <LanguageSwitcher />
          <ThemeSwitcher />
          {isAuthed ? (
            <AccountHud />
          ) : (
            <>
              <Link
                to="/login"
                className="hidden rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground transition hover:text-foreground sm:inline-block"
              >
                {t.public.header.login}
              </Link>
              <Link
                to="/signup"
                className="rounded-lg bg-primary px-3 py-2 text-sm font-semibold text-primary-foreground shadow-sm transition hover:opacity-90 sm:px-4"
              >
                {t.public.header.signup}
              </Link>
            </>
          )}
        </div>
      </div>
      {/* Phone-only catalogue nav: the inline nav above is hidden below `sm`, so
          surface Programme / Extras (+ login when logged out) in a compact wrapping
          row here, otherwise phone visitors lose those entry points entirely. */}
      <nav
        className="flex flex-wrap items-center gap-x-1 gap-y-0.5 border-t border-border px-4 py-1.5 sm:hidden"
        aria-label={t.public.header.navAria}
      >
        <Link
          to="/programme"
          className="rounded-lg px-2.5 py-2 text-sm font-medium text-muted-foreground transition hover:text-foreground"
        >
          {t.public.header.programme}
        </Link>
        <Link
          to="/extras"
          className="rounded-lg px-2.5 py-2 text-sm font-medium text-muted-foreground transition hover:text-foreground"
        >
          {t.public.header.extras}
        </Link>
        {!isAuthed && (
          <Link
            to="/login"
            className="rounded-lg px-2.5 py-2 text-sm font-medium text-muted-foreground transition hover:text-foreground"
          >
            {t.public.header.login}
          </Link>
        )}
      </nav>
    </header>
  );
}
