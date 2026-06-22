import { Link } from "@tanstack/react-router";

/**
 * Header of the public (Référence register) shell. Sober, content-first: the
 * brand returns home, and a single primary CTA invites account creation — the
 * account is for play/XP/saving, never to read. i18n keys are part of the L1.6
 * sweep; first-pass copy is FR literals.
 */
export function PublicHeader() {
  return (
    <header className="sticky top-0 z-30 border-b border-border bg-card/90 backdrop-blur print:hidden">
      <div className="mx-auto flex max-w-5xl items-center justify-between gap-2 px-4 py-3 sm:gap-3 sm:px-6">
        <div className="flex items-center gap-3 sm:gap-6">
          <Link to="/" className="flex items-baseline gap-2" aria-label="Na9ra Nal3ab — accueil">
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
          <nav className="flex items-center gap-0.5 sm:gap-1" aria-label="Catalogue">
            <Link
              to="/programme"
              className="rounded-lg px-2.5 py-2 text-sm font-medium text-muted-foreground transition hover:text-foreground sm:px-3"
            >
              Programme
            </Link>
            <Link
              to="/extras"
              className="rounded-lg px-2.5 py-2 text-sm font-medium text-muted-foreground transition hover:text-foreground sm:px-3"
            >
              Extras
            </Link>
          </nav>
        </div>
        <div className="flex items-center gap-1 sm:gap-2">
          <Link
            to="/login"
            className="hidden rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground transition hover:text-foreground sm:inline-block"
          >
            Connexion
          </Link>
          <Link
            to="/signup"
            className="rounded-lg bg-primary px-3 py-2 text-sm font-semibold text-primary-foreground shadow-sm transition hover:opacity-90 sm:px-4"
          >
            Créer mon compte
          </Link>
        </div>
      </div>
    </header>
  );
}
