import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
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
  const fetchParcours = useServerFn(getParcours);
  const { data, isLoading, isError } = useQuery({
    queryKey: ["parcours", "catalogue"],
    queryFn: () => fetchParcours(),
  });

  if (isError) {
    return (
      <div className="mx-auto max-w-3xl px-6 py-20 text-center text-muted-foreground">
        Impossible de charger le programme.
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

  return <ProgrammeCatalogue parcours={data.parcours as CatalogueParcours[]} />;
}
