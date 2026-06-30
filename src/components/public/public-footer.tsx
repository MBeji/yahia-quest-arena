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
        <p className="mt-2">
          <LegalNoticeDialog />
        </p>
      </div>
    </footer>
  );
}
