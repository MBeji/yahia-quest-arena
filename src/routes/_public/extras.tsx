import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
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
  const { data, isLoading, isError } = useQuery({
    queryKey: ["parcours", "catalogue"],
    queryFn: () => fetchParcours(),
  });

  if (isError) {
    return (
      <div className="mx-auto max-w-3xl px-6 py-20 text-center text-muted-foreground">
        Impossible de charger les extras.
      </div>
    );
  }

  if (isLoading || !data) {
    return (
      <div className="grid min-h-[60vh] place-items-center">
        <div className="h-9 w-9 animate-spin rounded-full border-2 border-primary border-t-transparent" />
      </div>
    );
  }

  return <ExtrasCatalogue parcours={data.parcours as CatalogueParcours[]} />;
}
