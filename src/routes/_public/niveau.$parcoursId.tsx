import { createFileRoute, notFound, useNavigate } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { toast } from "sonner";
import { CloudOff } from "lucide-react";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/empty-state";
import { LoadingState } from "@/components/ui/loading-state";
import { getParcoursSubjects } from "@/features/dashboard";
import { setCurrentParcours, useAuth } from "@/features/auth";
import { ParcoursSubjects } from "@/features/dashboard/components/parcours-subjects";
import { useT } from "@/lib/i18n";
import { publicPageHead, seedOnServer } from "@/shared/lib/public-page-seo";
import { CatalogueNotFound } from "./-catalogue-not-found";

/**
 * Public level page — the subjects of one parcours/level (« Référence » register,
 * chantier C8, L1.3). Thin: fetches the parcours + its subjects (anon-capable
 * `getParcoursSubjects`). No auth guard. When signed in, it also offers to make
 * this the active parcours (`setCurrentParcours` → dashboard) — the converged
 * replacement for the removed `/themes` switch (chantier L2.A, GAP-046).
 */
export const Route = createFileRoute("/_public/niveau/$parcoursId")({
  // Rendu serveur de la page publique (`public-page-seo.ts`) : le loader ne tourne
  // utilement qu'au SSR, où il précharge la version ANONYME de la page et calcule
  // son <head> ; le composant la montre en `placeholderData` jusqu'à ce que sa
  // propre requête réponde. Derrière `import.meta.env.SSR`, ce code (et son
  // `<head>`) sort du bundle client — le loader y rend `null`.
  loader: ({ params }) => (import.meta.env.SSR ? seedNiveau(params.parcoursId) : null),
  head: ({ loaderData }) => loaderData?.head ?? { meta: [{ title: "Niveau · Na9ra Nal3ab" }] },
  component: NiveauPage,
  // Un niveau qui n'existe pas : HTTP 404 dans la coquille publique (voir
  // `seedNiveau`), pas un écran « introuvable » servi en 200.
  notFoundComponent: NiveauNotFound,
});

function NiveauNotFound() {
  const t = useT();
  return <CatalogueNotFound title={t.errors.parcoursNotFound} />;
}

/** SSR seulement : les matières du niveau et le <head> qui les annonce. */
async function seedNiveau(parcoursId: string) {
  const data = await seedOnServer("niveau", async () => {
    const server = await import("@/features/dashboard/dashboard.server");
    return server.getParcoursSubjects({ data: { parcoursId } });
  });
  // `data === null` : la lecture a échoué → 200, le client recharge. `parcours`
  // absent d'une lecture RÉUSSIE : ce niveau n'existe pas → 404.
  if (!data) return null;
  if (!data.parcours) throw notFound();
  const { parcours, subjects } = data;
  const head = publicPageHead({
    title: parcours.name_fr,
    description: `Cours, résumés et exercices corrigés, gratuits : ${subjects.map((s) => s.name_fr).join(" · ")}`,
    path: `/niveau/${parcoursId}`,
  });
  return { data, head };
}

function NiveauPage() {
  const t = useT();
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const { parcoursId } = Route.useParams();
  const { user } = useAuth();
  const fetchParcoursSubjects = useServerFn(getParcoursSubjects);
  const saveParcours = useServerFn(setCurrentParcours);
  const seed = Route.useLoaderData();

  const { data, isLoading, isError, refetch } = useQuery({
    queryKey: ["parcours-subjects", parcoursId],
    queryFn: () => fetchParcoursSubjects({ data: { parcoursId } }),
    placeholderData: seed?.data,
  });

  // Signed-in: make this level the active parcours, then land on the dashboard
  // (same effect the removed /themes "enter" had). Anonymous: button not shown.
  const chooseMutation = useMutation({
    mutationFn: () => saveParcours({ data: { parcoursId } }),
    onSuccess: async () => {
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: ["dashboard"] }),
        queryClient.invalidateQueries({ queryKey: ["me-role"] }),
      ]);
      navigate({ to: "/dashboard" });
    },
    onError: () => toast.error(t.explorer.switchError),
  });

  if (isError) {
    return (
      <div className="mx-auto max-w-md px-6 py-20">
        <EmptyState
          icon={CloudOff}
          title={t.errors.parcoursLoadFailed}
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

  if (!data.parcours) return <NiveauNotFound />;

  return (
    <ParcoursSubjects
      parcours={data.parcours}
      subjects={data.subjects}
      soon={data.soon}
      isAuthenticated={user != null}
      onChoose={() => chooseMutation.mutate()}
      isChoosing={chooseMutation.isPending}
    />
  );
}
