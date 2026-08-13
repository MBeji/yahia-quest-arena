import { Skeleton } from "@/components/ui/skeleton";
import { PageShell } from "@/components/ui/page-shell";
import { useT } from "@/lib/i18n";

/**
 * Silhouette du tableau de bord pendant son chargement — la forme réelle de
 * l'écran (héros, bande focus, grille de matières), pas un rectangle générique.
 *
 * Elle remplace les `div.animate-pulse` posés à la main dans la route : mêmes
 * bones, mais sur la primitive partagée et surtout ANNONCÉE — les pulsations
 * précédentes étaient muettes pour un lecteur d'écran, qui n'avait donc aucun
 * moyen de savoir que la page arrivait.
 */
export function DashboardSkeleton() {
  const t = useT();

  return (
    <PageShell width="wide">
      <div role="status" aria-label={t.common.loading} className="space-y-6">
        <div aria-hidden className="space-y-6">
          {/* En-tête héros : avatar, nom, pastilles de stats, barre d'XP. */}
          <div className="rounded-3xl border border-border/50 p-6 sm:p-8">
            <div className="grid gap-6 sm:grid-cols-[auto_1fr] sm:items-center">
              <Skeleton className="h-20 w-20 rounded-2xl" />
              <div className="space-y-3">
                <Skeleton className="h-3 w-28" />
                <Skeleton className="h-8 w-56 max-w-full" />
                <div className="flex flex-wrap gap-2">
                  {[0, 1, 2, 3].map((i) => (
                    <Skeleton key={i} className="h-6 w-20 rounded-full" />
                  ))}
                </div>
                <Skeleton className="h-3 w-full rounded-full" />
              </div>
            </div>
          </div>

          {/* Bande focus : une action promue, deux tuiles calmes. */}
          <div className="grid gap-4 lg:grid-cols-[2fr_1fr_1fr]">
            <Skeleton className="h-28 rounded-2xl" />
            <Skeleton className="h-28 rounded-2xl" />
            <Skeleton className="h-28 rounded-2xl" />
          </div>

          {/* Grille des matières. */}
          <div className="grid gap-4 sm:grid-cols-3 lg:grid-cols-5">
            {[0, 1, 2, 3, 4].map((i) => (
              <Skeleton key={i} className="h-28 rounded-2xl" />
            ))}
          </div>
        </div>
      </div>
    </PageShell>
  );
}
