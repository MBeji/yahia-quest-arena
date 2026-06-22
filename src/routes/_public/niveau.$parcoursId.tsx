import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { getParcoursSubjects } from "@/features/dashboard";
import { ParcoursSubjects } from "@/features/dashboard/components/parcours-subjects";

/**
 * Public level page — the subjects of one parcours/level (« Référence » register,
 * chantier C8, L1.3). Thin: fetches the parcours + its subjects (anon-capable
 * `getParcoursSubjects`) and hands them to <ParcoursSubjects/>. No auth guard.
 */
export const Route = createFileRoute("/_public/niveau/$parcoursId")({
  head: () => ({ meta: [{ title: "Niveau · Na9ra Nal3ab" }] }),
  component: NiveauPage,
});

function NiveauPage() {
  const { parcoursId } = Route.useParams();
  const fetchParcoursSubjects = useServerFn(getParcoursSubjects);
  const { data, isLoading, isError } = useQuery({
    queryKey: ["parcours-subjects", parcoursId],
    queryFn: () => fetchParcoursSubjects({ data: { parcoursId } }),
  });

  if (isError) {
    return (
      <div className="mx-auto max-w-3xl px-6 py-20 text-center text-muted-foreground">
        Impossible de charger ce niveau.
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

  if (!data.parcours) {
    return (
      <div className="mx-auto max-w-3xl px-6 py-20 text-center text-muted-foreground">
        Ce niveau est introuvable.
      </div>
    );
  }

  return <ParcoursSubjects parcours={data.parcours} subjects={data.subjects} />;
}
