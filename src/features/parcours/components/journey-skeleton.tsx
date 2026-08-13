import { Skeleton } from "@/components/ui/skeleton";
import { PageShell } from "@/components/ui/page-shell";
import { useT } from "@/lib/i18n";
import { nodeSide } from "../journey";

/**
 * Silhouette de la carte de parcours — l'en-tête (titre, chip de niveau, barre
 * d'XP) puis les nœuds sur le chemin sinueux. Les côtés viennent de `nodeSide`,
 * la MÊME fonction que la vraie carte : la silhouette serpente donc comme elle,
 * et ne se décalera pas si l'alternance change un jour.
 */
export function JourneySkeleton() {
  const t = useT();

  return (
    <PageShell>
      <div role="status" aria-label={t.common.loading}>
        <div aria-hidden>
          <div className="rounded-3xl border border-border/50 p-6">
            <div className="flex flex-wrap items-center justify-between gap-4">
              <div className="space-y-2">
                <Skeleton className="h-9 w-56 max-w-full" />
                <Skeleton className="h-4 w-72 max-w-full" />
              </div>
              <Skeleton className="h-16 w-40 rounded-2xl" />
            </div>
            <Skeleton className="mt-5 h-3 w-full rounded-full" />
          </div>

          <div className="mt-8 space-y-6">
            {[0, 1, 2, 3, 4].map((i) => (
              <div
                key={i}
                className={`flex ${nodeSide(i) === "left" ? "justify-start" : "justify-end"}`}
              >
                <div className="flex w-40 flex-col items-center gap-2">
                  <Skeleton className="h-20 w-20 rounded-full" />
                  <Skeleton className="h-4 w-24" />
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </PageShell>
  );
}
