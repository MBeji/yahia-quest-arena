import { Skeleton } from "@/components/ui/skeleton";
import { PageShell } from "@/components/ui/page-shell";
import { useT } from "@/lib/i18n";

/**
 * Silhouette du hub matière — en-tête (fil d'ariane, titre, description), bande
 * « reprendre », puis la liste des chapitres. Remplace le spinner centré : à
 * durée identique, une silhouette dit ce qui arrive là où un spinner ne dit que
 * « attends ».
 *
 * Sans direction de contenu : la langue de la matière n'est connue qu'une fois
 * les données arrivées, donc au moment où cette silhouette disparaît. Elle reste
 * dans la direction de l'UI, et c'est le seul choix honnête.
 */
export function SubjectHubSkeleton() {
  const t = useT();

  return (
    <PageShell>
      <div role="status" aria-label={t.common.loading}>
        <div aria-hidden>
          <header className="mb-6 space-y-3">
            <Skeleton className="h-4 w-40" />
            <Skeleton className="h-9 w-64 max-w-full" />
            <Skeleton className="h-4 w-full max-w-md" />
          </header>

          {/* Bande « reprendre ici ». */}
          <Skeleton className="mb-6 h-16 rounded-xl" />

          {/* Chapitres : titre + rangée de missions. */}
          <div className="space-y-4">
            {[0, 1, 2, 3].map((i) => (
              <div key={i} className="space-y-3 rounded-2xl border border-border/50 p-4">
                <div className="flex items-center gap-3">
                  <Skeleton className="h-9 w-9 shrink-0 rounded-lg" />
                  <Skeleton className="h-5 w-48 max-w-full" />
                </div>
                <div className="flex flex-wrap gap-2">
                  <Skeleton className="h-8 w-24 rounded-lg" />
                  <Skeleton className="h-8 w-24 rounded-lg" />
                  <Skeleton className="h-8 w-24 rounded-lg" />
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </PageShell>
  );
}
