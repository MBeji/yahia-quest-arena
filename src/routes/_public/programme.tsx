import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { CloudOff } from "lucide-react";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/empty-state";
import { LoadingState } from "@/components/ui/loading-state";
import { useT } from "@/lib/i18n";
import { getParcours } from "@/features/dashboard";
import {
  ProgrammeCatalogue,
  type CatalogueParcours,
} from "@/features/dashboard/components/parcours-catalogue";

/**
 * Public catalogue — the official school programme (« Référence » register, chantier
 * C8, L1.3). Thin: fetches the parcours catalogue (anon-capable `getParcours`) and
 * hands the rows to <ProgrammeCatalogue/>. No auth guard (under the `_public` coquille).
 */
export const Route = createFileRoute("/_public/programme")({
  head: () => ({
    meta: [
      { title: "Programme scolaire tunisien · Na9ra Nal3ab" },
      {
        name: "description",
        content:
          "Tout le programme scolaire tunisien, de la 1ère année de base au Baccalauréat, en accès libre : cours, résumés et exercices gratuits, sans compte.",
      },
    ],
  }),
  component: ProgrammePage,
});

function ProgrammePage() {
  const t = useT();
  const fetchParcours = useServerFn(getParcours);
  const { data, isLoading, isError, refetch } = useQuery({
    queryKey: ["parcours", "catalogue"],
    queryFn: () => fetchParcours(),
  });

  if (isError) {
    return (
      <div className="mx-auto max-w-md px-6 py-20">
        <EmptyState
          icon={CloudOff}
          title={t.errors.programmeLoadFailed}
          action={
            <Button variant="outline" onClick={() => refetch()}>
              {t.common.retry}
            </Button>
          }
        />
      </div>
    );
  }

  if (isLoading || !data) {
    return <LoadingState label={t.common.loading} className="min-h-[60dvh]" />;
  }

  return <ProgrammeCatalogue parcours={data.parcours as CatalogueParcours[]} />;
}
