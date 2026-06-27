import { Link } from "@tanstack/react-router";
import { useT } from "@/lib/i18n";
import { LanguageSwitcher } from "@/components/ui/language-switcher";
import { ThemeSwitcher } from "@/components/ui/theme-switcher";

/**
 * Header of the public (Référence register) shell. Sober, content-first: the
 * brand returns home, and a single primary CTA invites account creation — the
 * account is for play/XP/saving, never to read. Copy is i18n (fr/en/ar).
 */
export function PublicHeader() {
  const t = useT();
  return (
    <header className="sticky top-0 z-30 border-b border-border bg-card/90 backdrop-blur print:hidden">
      <div className="mx-auto flex max-w-5xl items-center justify-between gap-2 px-4 py-3 sm:gap-3 sm:px-6">
        <div className="flex items-center gap-3 sm:gap-6">
          <Link to="/" className="flex items-baseline gap-2" aria-label={t.public.header.homeAria}>
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
              className="rounded-lg px-2.5 py-2 text-sm font-medium text-muted-foreground transition hover:text-foreground sm:px-3"
            >
              {t.public.header.programme}
            </Link>
            <Link
              to="/extras"
              className="rounded-lg px-2.5 py-2 text-sm font-medium text-muted-foreground transition hover:text-foreground sm:px-3"
            >
              {t.public.header.extras}
            </Link>
          </nav>
        </div>
        <div className="flex items-center gap-1 sm:gap-2">
          <LanguageSwitcher />
          <ThemeSwitcher />
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
        </div>
      </div>
    </header>
  );
}
