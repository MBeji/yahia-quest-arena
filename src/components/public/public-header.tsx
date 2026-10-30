import { Link } from "@tanstack/react-router";
import { useT } from "@/lib/i18n";
import { trackProductEvent } from "@/shared/lib/product-events";
import { rememberCurrentPage } from "@/shared/lib/return-to";
import { useAuth, useMyRole, useSignOutInPlace } from "@/features/auth";
import { SettingsMenu } from "@/components/ui/settings-menu";
import { AccountHud } from "@/components/account-hud";
import { GuideButton } from "@/components/guide/guide-button";

/**
 * Header of the public (Référence register) shell. Sober, content-first, and
 * AUTH-AWARE: a signed-in visitor — who now reaches public content via the
 * converged « Découvrir » nav, a course link, etc. — sees a link back to their
 * space, never the login/signup CTAs (which would wrongly read as "logged out").
 * Copy is i18n (fr/en/ar).
 *
 * é38 lot 1 :
 *   - R-6 — tant que la session n'est pas lue (`loading`), AUCUN libellé ne dit
 *     l'état du compte : ni « Connexion · Créer mon compte » (faux pour un
 *     connecté), ni le HUD (faux pour un visiteur). Le SSR rend ce même bloc
 *     neutre — réglages et aide seuls — puis la lecture de session le complète.
 *   - R-11 — le menu des réglages d'un connecté porte « Se déconnecter », qui le
 *     laisse SUR la page, en visiteur (US-7).
 *   - R-14 — « Suivi parent » est la porte du parent sans compte : un élève
 *     connecté, qui a son propre espace, ne la voit pas.
 */
export function PublicHeader() {
  const t = useT();
  const { user, loading } = useAuth();
  const { role } = useMyRole();
  const signOut = useSignOutInPlace();
  const isAuthed = user != null;
  // R-14. Le lien reste pour le visiteur (et dans le HTML rendu côté serveur) et pour le parent ou
  // l'admin ; il n'est PAS rendu pour un connecté dont le rôle n'est pas encore lu — mieux vaut un
  // lien qui arrive qu'un lien qui disparaît sous le doigt de l'élève.
  const showParentTracking = !isAuthed || role === "parent" || role === "admin";
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
            {/* Suivi parent — sans compte : discoverable depuis le catalogue,
                plus seulement depuis le bloc famille de la landing (audit §C-4). */}
            {showParentTracking && (
              <Link
                to="/suivi"
                className="inline-flex items-center rounded-lg px-2.5 py-2 text-sm font-medium text-muted-foreground transition hover:text-foreground sm:px-3 [@media(pointer:coarse)]:min-h-11"
              >
                {t.public.header.parentTracking}
              </Link>
            )}
          </nav>
        </div>
        <div className="flex items-center gap-1 sm:gap-2">
          {/* Même engrenage que la coquille connectée, sans le bloc compte : un
              visiteur anonyme règle thème, langue ET son — les trois providers
              vivent à la racine, mais l'ancien header public n'offrait pas le son. */}
          {/* Sur téléphone, la marque + « Créer mon compte » remplissent déjà la
              ligne : l'aide y garde son icône, son libellé revient dès `sm`. */}
          <GuideButton compact />
          <SettingsMenu onSignOut={isAuthed ? signOut : undefined} />
          {loading ? null : isAuthed ? (
            <AccountHud />
          ) : (
            <>
              <Link
                to="/login"
                onClick={() => rememberCurrentPage()}
                data-testid="header-login"
                className="hidden rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground transition hover:text-foreground sm:inline-block"
              >
                {t.public.header.login}
              </Link>
              <Link
                to="/signup"
                onClick={() => {
                  rememberCurrentPage();
                  trackProductEvent("account_invite_clicked", { surface: "header" });
                }}
                data-testid="header-signup"
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
        {showParentTracking && (
          <Link
            to="/suivi"
            className="rounded-lg px-2.5 py-2 text-sm font-medium text-muted-foreground transition hover:text-foreground"
          >
            {t.public.header.parentTracking}
          </Link>
        )}
        {!loading && !isAuthed && (
          <Link
            to="/login"
            onClick={() => rememberCurrentPage()}
            data-testid="header-login-phone"
            className="rounded-lg px-2.5 py-2 text-sm font-medium text-muted-foreground transition hover:text-foreground"
          >
            {t.public.header.login}
          </Link>
        )}
      </nav>
    </header>
  );
}
