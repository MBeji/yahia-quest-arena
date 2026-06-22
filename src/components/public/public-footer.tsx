import { useT } from "@/lib/i18n";

/**
 * Footer of the public (Référence register) shell. Carries the « 100 % gratuit »
 * promise of the pivot. Copy is i18n (fr/en/ar).
 */
export function PublicFooter() {
  const t = useT();
  return (
    <footer className="mt-16 border-t border-border bg-card/60 print:hidden">
      <div className="mx-auto max-w-5xl px-4 py-8 text-center text-xs text-muted-foreground sm:px-6">
        <p className="text-sm font-semibold text-foreground">{t.public.footer.tagline}</p>
        <p className="mt-1">
          © {new Date().getFullYear()} Na9ra Nal3ab ·{" "}
          <span lang="ar" dir="rtl" className="font-arabic">
            نقرا نلعب
          </span>
        </p>
      </div>
    </footer>
  );
}
