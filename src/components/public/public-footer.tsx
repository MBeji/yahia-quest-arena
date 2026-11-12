import { Link } from "@tanstack/react-router";
import { useT } from "@/lib/i18n";
import { LegalNoticeDialog } from "./legal-notice-dialog";

const FOOTER_LINK =
  "inline-flex min-h-11 items-center rounded-md px-2 underline-offset-2 transition hover:text-foreground hover:underline";

/**
 * Footer of the public (Référence register) shell. Carries the « 100 % gratuit »
 * promise of the pivot + the IP/copyright notice (legal modal). Copy is i18n.
 */
export function PublicFooter() {
  const t = useT();
  return (
    <footer className="mt-16 border-t border-border bg-card/60 print:hidden">
      <div className="mx-auto max-w-5xl px-4 py-8 pb-[max(2rem,env(safe-area-inset-bottom))] text-center text-xs text-muted-foreground sm:px-6">
        <p className="text-sm font-semibold text-foreground">{t.public.footer.tagline}</p>
        <p className="mt-1">
          © {new Date().getFullYear()} Na9ra Nal3ab ·{" "}
          <span lang="ar" dir="rtl" className="font-brand-ar">
            نقرا نلعب
          </span>{" "}
          · {t.public.footer.rights}
        </p>
        {/* Cibles tactiles : chaque lien fait 44 px de haut (ils en faisaient 16, serrés à
            12 px l'un de l'autre). C'est une liste de liens, et elle se dit comme telle. */}
        <nav aria-label={t.public.footer.legalLink} className="mt-1">
          <ul className="flex flex-wrap items-center justify-center gap-x-1">
            {/* Suivi parent — 2nd discoverable entry point besides the header
                (audit §C-4: the page used to be reachable only from the landing). */}
            <li>
              <Link to="/suivi" className={`${FOOTER_LINK} font-medium text-primary`}>
                {t.public.header.parentTracking}
              </Link>
            </li>
            {/* Les libellés des deux pages légales sont ceux de `/parametrage` : ils existent
                déjà en trois langues, donc aucune clé de plus dans le chunk i18n. */}
            <li>
              <Link to="/confidentialite" className={FOOTER_LINK}>
                {t.settings.helpPrivacy}
              </Link>
            </li>
            <li>
              <Link to="/conditions" className={FOOTER_LINK}>
                {t.settings.helpTerms}
              </Link>
            </li>
            <li>
              <LegalNoticeDialog className={FOOTER_LINK} />
            </li>
          </ul>
        </nav>
      </div>
    </footer>
  );
}
