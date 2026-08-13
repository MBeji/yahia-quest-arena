import { Skeleton } from "@/components/ui/skeleton";
import { useT } from "@/lib/i18n";

/**
 * Repli de <DashboardGoals/> pendant son chargement paresseux. Deux colonnes,
 * chacune avec son titre et trois lignes d'objectif : la section arrive à sa
 * place au lieu d'apparaître d'un coup et de pousser ce qui la suit.
 */
export function DashboardGoalsSkeleton() {
  const t = useT();

  return (
    <div role="status" aria-label={t.common.loading} className="mt-8 grid gap-6 sm:grid-cols-2">
      {[0, 1].map((col) => (
        <div key={col} aria-hidden className="rounded-2xl border border-border/50 p-5">
          <Skeleton className="mb-4 h-6 w-44" />
          <div className="space-y-3">
            {[0, 1, 2].map((row) => (
              <Skeleton key={row} className="h-24 rounded-xl" />
            ))}
          </div>
        </div>
      ))}
    </div>
  );
}
