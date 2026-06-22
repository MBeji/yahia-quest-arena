/**
 * Footer of the public (Référence register) shell. Carries the « 100 % gratuit »
 * promise of the pivot. A SEO sitemap of the 3 parcours × niveaux comes in L1.1.
 */
export function PublicFooter() {
  return (
    <footer className="mt-16 border-t border-border bg-card/60 print:hidden">
      <div className="mx-auto max-w-5xl px-4 py-8 text-center text-xs text-muted-foreground sm:px-6">
        <p className="text-sm font-semibold text-foreground">
          100 % gratuit · toute l’école tunisienne
        </p>
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
