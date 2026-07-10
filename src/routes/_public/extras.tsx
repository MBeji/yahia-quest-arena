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
  ExtrasCatalogue,
  type CatalogueParcours,
} from "@/features/dashboard/components/parcours-catalogue";

/**
 * Public catalogue — the optional `libre` extras (« Référence » register, chantier C8,
 * L1.3). Thin: fetches the parcours catalogue (anon-capable `getParcours`) and hands
 * the rows to <ExtrasCatalogue/>, which keeps only the `libre` tracks. No auth guard.
 */
export const Route = createFileRoute("/_public/extras")({
  head: () => ({
    meta: [
      { title: "Extras · langues, culture générale, logique · Na9ra Nal3ab" },
      {
        name: "description",
        content:
          "Au-delà du programme scolaire : apprends les langues, la culture générale et muscle ton cerveau. Parcours optionnels en accès libre et gratuit.",
      },
    ],
  }),
  component: ExtrasPage,
});

function ExtrasPage() {
  const fetchParcours = useServerFn(getParcours);
  const t = useT();
  const { data, isLoading, isError, refetch } = useQuery({
    queryKey: ["parcours", "catalogue"],
    queryFn: () => fetchParcours(),
  });

  if (isError) {
    return (
      <div className="mx-auto max-w-md px-6 py-20">
        <EmptyState
          icon={CloudOff}
          title={t.errors.extrasLoadFailed}
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

  return <ExtrasCatalogue parcours={data.parcours as CatalogueParcours[]} />;
}
