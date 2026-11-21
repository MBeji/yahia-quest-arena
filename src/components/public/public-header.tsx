import { Link } from "@tanstack/react-router";
import { useT } from "@/lib/i18n";
import { trackProductEvent } from "@/shared/lib/product-events";
import { rememberCurrentPage } from "@/shared/lib/return-to";
import { hubRouteForRole, useAuth, useMyRole, useSignOutInPlace } from "@/features/auth";
import { SettingsMenu } from "@/components/ui/settings-menu";
import { AccountHud } from "@/components/account-hud";
import { GuideButton } from "@/components/guide/guide-button";
import { useStickyHeaderOffset } from "@/components/public/use-sticky-header-offset";

/** L'onglet de la page où l'on est : encre de marque, graisse de titre. Le routeur pose
 * `data-status="active"` (et `aria-current="page"`) sur le lien de la route courante. */
const NAV_CURRENT = "data-[status=active]:font-semibold data-[status=active]:text-primary";
/** Un lien de la rangée de navigation sous `xl` : 44 px de haut, la garde tactile. */
const PHONE_NAV_LINK = `inline-flex min-h-11 shrink-0 items-center whitespace-nowrap rounded-lg px-2.5 text-sm font-medium text-muted-foreground transition hover:text-foreground ${NAV_CURRENT}`;
/** Un lien de la barre du haut, dès `xl`. `whitespace-nowrap` : « Test de niveau » et
 * « Suivi parent » se coupaient en deux lignes à 1440 px (constat du 2026-11-14). */
const DESKTOP_NAV_LINK = `inline-flex items-center whitespace-nowrap rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground transition hover:bg-foreground/5 hover:text-foreground [@media(pointer:coarse)]:min-h-11 ${NAV_CURRENT}`;
/** Les deux entrées du compte dans la barre du haut — partagées avec leur réserve
 * invisible, pour que la place prise pendant la lecture de la session soit EXACTEMENT
 * celle des liens qui arrivent. `whitespace-nowrap` : sur deux lignes, « Créer mon
 * compte » grandissait la barre de 16 px à 360 px. */
const HEADER_LOGIN =
  "min-h-11 items-center whitespace-nowrap rounded-lg px-3 text-sm font-medium text-muted-foreground transition hover:text-foreground";
const HEADER_SIGNUP =
  "inline-flex min-h-11 items-center whitespace-nowrap rounded-lg bg-primary px-3 text-sm font-semibold text-primary-foreground shadow-sm transition hover:opacity-90 max-[389px]:px-2 sm:px-4";

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
  // L'espace du rôle, pas « /dashboard » en dur : un parent a son Suivi, pas de Hall.
  const hub = hubRouteForRole(role);
  // R-14. Le lien reste pour le visiteur (et dans le HTML rendu côté serveur) et pour le parent ou
  // l'admin ; il n'est PAS rendu pour un connecté dont le rôle n'est pas encore lu — mieux vaut un
  // lien qui arrive qu'un lien qui disparaît sous le doigt de l'élève.
  const showParentTracking = !isAuthed || role === "parent" || role === "admin";
  // Les sauts d'ancre s'arrêtent SOUS cet en-tête, quelle que soit sa hauteur.
  const headerRef = useStickyHeaderOffset<HTMLElement>();
  // Sous 430 px la barre n'a pas la place de « Créer mon compte » sur UNE ligne (elle
  // débordait de 38 px à 360) : le bouton y prend le libellé court du catalogue.
  const signupLabel = (
    <>
      <span className="min-[430px]:hidden">{t.common.signUp}</span>
      <span className="max-[429px]:hidden">{t.public.header.signup}</span>
    </>
  );
  return (
    <header
      ref={headerRef}
      data-public-header
      className="sticky top-0 z-30 border-b border-border bg-card/90 pt-[env(safe-area-inset-top)] backdrop-blur print:hidden"
    >
      {/* Sous 360 px (iPhone SE 1re génération, petits Android) la barre débordait déjà de
          6 à 11 px : marge et marque y sont resserrées pour que tout tienne sur la ligne. */}
      {/* `max-w-7xl`, comme la coquille connectée : la marque ne change pas de place quand
          un élève passe de son Hall au catalogue. À `max-w-5xl` la barre du haut n'avait
          pas la place de ses liens — ils passaient sur deux lignes. */}
      <div className="mx-auto flex max-w-7xl items-center justify-between gap-2 px-4 py-2 max-[359px]:gap-1 max-[359px]:px-2 sm:gap-3 sm:px-6 sm:py-3">
        <div className="flex items-center gap-3 sm:gap-6">
          {/* Brand = home. AUTH-AWARE destination: a signed-in visitor who reached
              this public shell via the converged « Découvrir » nav is sent back to
              their own hub (Hall, or Suivi for a parent), NOT the logged-out landing (`/`)
              — tapping the logo used to strand them on the public home that reads as
              "not logged in" (issue #312). Logged-out visitors still go to `/`. */}
          <Link
            to={isAuthed ? hub : "/"}
            // 44 px de haut : la marque est le premier lien que le pouce cherche.
            className="flex min-h-11 items-center gap-2"
          >
            <span className="font-brand text-lg font-bold tracking-tight whitespace-nowrap text-primary max-[359px]:text-base">
              Na9ra Nal3ab
            </span>
            {/* Le nom accessible COMMENCE par la marque visible, puis dit où mène le lien.
                Un `aria-label` la remplaçait : « Mon espace » pour un connecté, et en arabe
                « نقرا نلعب — الرئيسية » — dans les deux cas le texte affiché n'y était plus,
                donc « clique Na9ra Nal3ab » ne trouvait rien (WCAG 2.5.3). */}
            <span className="sr-only">{isAuthed ? t.public.header.account : t.common.home}</span>
            <span
              lang="ar"
              dir="rtl"
              aria-hidden="true"
              className="hidden font-brand-ar text-sm font-semibold whitespace-nowrap text-muted-foreground sm:inline"
            >
              نقرا نلعب
            </span>
          </Link>
          <nav className="hidden items-center gap-1 xl:flex" aria-label={t.public.header.navAria}>
            <Link to="/programme" className={DESKTOP_NAV_LINK}>
              {t.public.header.programme}
            </Link>
            <Link to="/extras" className={DESKTOP_NAV_LINK}>
              {t.public.header.extras}
            </Link>
            {/* Le test de niveau (étude 39) : la porte d'entrée partageable, visible de partout —
                un visiteur qui arrive par un cours doit pouvoir la trouver sans l'accueil. */}
            <Link to="/test-de-niveau" className={DESKTOP_NAV_LINK}>
              {t.public.header.placement}
            </Link>
            {/* Suivi parent — sans compte : discoverable depuis le catalogue,
                plus seulement depuis le bloc famille de la landing (audit §C-4). */}
            {showParentTracking && (
              <Link to="/suivi" className={DESKTOP_NAV_LINK}>
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
          {loading ? (
            // é38 R-6 : tant que la session n'est pas lue, aucun libellé ne dit l'état du
            // compte — mais la PLACE des deux entrées est déjà prise. Sans elle, l'arrivée
            // de « Créer mon compte » repoussait toute la page (CLS 0,11 mesuré à 360 px).
            // Invisible, hors de l'arbre d'accessibilité, et ce n'est pas un lien.
            <span
              aria-hidden="true"
              data-testid="header-account-placeholder"
              className="invisible flex items-center gap-1 sm:gap-2"
            >
              <span className={`${HEADER_LOGIN} hidden sm:inline-flex`}>
                {t.public.header.login}
              </span>
              <span className={HEADER_SIGNUP}>{signupLabel}</span>
            </span>
          ) : isAuthed ? (
            <AccountHud to={hub} />
          ) : (
            <>
              <Link
                to="/login"
                onClick={() => rememberCurrentPage()}
                data-testid="header-login"
                className={`${HEADER_LOGIN} hidden sm:inline-flex`}
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
                className={HEADER_SIGNUP}
              >
                {signupLabel}
              </Link>
            </>
          )}
        </div>
      </div>
      {/* Navigation du catalogue sous `xl` : UNE rangée, jamais deux.
          - Elle s'enroulait sur deux lignes sur téléphone (et trois en anglais à 320 px) :
            l'en-tête prenait 150 à 166 px d'un écran de 780, et « Valider » passait sous
            la ligne de flottaison d'une question. Les liens du catalogue défilent
            désormais à l'horizontale ; le dernier, coupé par le bord, dit qu'il y en a
            d'autres — et le fondu de `scroll-fade-end` dit que la coupe est voulue.
            Mesuré à 360 px : 166 → 105 px.
          - « Connexion » ne défile PAS : épinglée en fin de rangée, toujours visible sous
            `sm` (dès `sm`, c'est la barre du haut qui la porte), derrière un filet qui la
            sépare des liens qui défilent. Sa place est réservée
            pendant la lecture de la session, comme celle de « Créer mon compte ».
          - Chaque lien fait 44 px de haut : la garde tactile. */}
      <div className="border-t border-border xl:hidden">
        <div className="mx-auto flex max-w-7xl items-center gap-1 px-4 sm:px-6">
          <nav
            className="scroll-fade-end -ms-2.5 flex min-w-0 flex-1 items-center gap-x-1 overflow-x-auto pe-6 [scrollbar-width:none] [&::-webkit-scrollbar]:hidden"
            aria-label={t.public.header.navAria}
          >
            <Link to="/programme" className={PHONE_NAV_LINK}>
              {t.public.header.programme}
            </Link>
            <Link to="/extras" className={PHONE_NAV_LINK}>
              {t.public.header.extras}
            </Link>
            <Link to="/test-de-niveau" className={PHONE_NAV_LINK}>
              {t.public.header.placement}
            </Link>
            {showParentTracking && (
              <Link to="/suivi" className={PHONE_NAV_LINK}>
                {t.public.header.parentTracking}
              </Link>
            )}
          </nav>
          {loading ? (
            <span
              aria-hidden="true"
              className={`${PHONE_NAV_LINK} invisible border-s border-transparent ps-3 sm:hidden`}
            >
              {t.public.header.login}
            </span>
          ) : (
            !isAuthed && (
              <Link
                to="/login"
                onClick={() => rememberCurrentPage()}
                data-testid="header-login-phone"
                className={`${PHONE_NAV_LINK} rounded-none border-s border-border ps-3 sm:hidden`}
              >
                {t.public.header.login}
              </Link>
            )
          )}
        </div>
      </div>
    </header>
  );
}
