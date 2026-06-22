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
      <div className="mx-auto flex max-w-5xl items-center justify-between gap-3 px-4 py-3 sm:px-6">
        <Link to="/" className="flex items-baseline gap-2" aria-label="Na9ra Nal3ab — accueil">
          <span className="font-display text-lg font-bold tracking-tight text-primary">
            Na9ra Nal3ab
          </span>
          <span
            lang="ar"
            dir="rtl"
            aria-hidden="true"
            className="font-arabic text-sm font-semibold text-muted-foreground"
          >
            نقرا نلعب
          </span>
        </Link>
        <div className="flex items-center gap-1 sm:gap-2">
          <Link
            to="/login"
            className="rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground transition hover:text-foreground"
          >
            Connexion
          </Link>
          <Link
            to="/signup"
            className="rounded-lg bg-primary px-4 py-2 text-sm font-semibold text-primary-foreground shadow-sm transition hover:opacity-90"
          >
            Créer mon compte
          </Link>
        </div>
      </div>
    </header>
  );
}
