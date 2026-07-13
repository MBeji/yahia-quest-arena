import { Link } from "@tanstack/react-router";
import { useT } from "@/lib/i18n";
import { LegalNoticeDialog } from "./legal-notice-dialog";

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
          <span lang="ar" dir="rtl" className="font-arabic">
            نقرا نلعب
          </span>{" "}
          · {t.public.footer.rights}
        </p>
        <p className="mt-2 flex flex-wrap items-center justify-center gap-x-3 gap-y-1">
          {/* Suivi parent — 2nd discoverable entry point besides the header
              (audit §C-4: the page used to be reachable only from the landing). */}
          <Link to="/suivi" className="font-medium text-primary hover:underline">
            {t.public.header.parentTracking}
          </Link>
          <span aria-hidden="true">·</span>
          <LegalNoticeDialog />
        </p>
      </div>
    </footer>
  );
}
