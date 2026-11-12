import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { CloudOff } from "lucide-react";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/empty-state";
import { LoadingState } from "@/components/ui/loading-state";
import { ResumeCard } from "@/components/public/resume-card";
import { useT } from "@/lib/i18n";
import { getParcours } from "@/features/dashboard";
import {
  ProgrammeCatalogue,
  type CatalogueParcours,
} from "@/features/dashboard/components/parcours-catalogue";
import { breadcrumbJsonLd, seedOnServer, serializeJsonLd } from "@/shared/lib/public-page-seo";

/**
 * Public catalogue — the official school programme (« Référence » register, chantier
 * C8, L1.3). Thin: fetches the parcours catalogue (anon-capable `getParcours`) and
 * hands the rows to <ProgrammeCatalogue/>. No auth guard (under the `_public` coquille).
 */
export const Route = createFileRoute("/_public/programme")({
  // Rendu serveur du catalogue (`public-page-seo.ts`). Jusqu'au 2026-11-12 cette
  // page partait du serveur avec « Chargement… » pour seul contenu : la porte
  // d'entrée du catalogue ne portait AUCUN lien vers un niveau dans son HTML, et un
  // robot qui ne joue pas le JavaScript s'y arrêtait net. Le loader précharge la
  // version anonyme ; le composant la montre en `placeholderData`. Derrière
  // `import.meta.env.SSR`, ce code sort du bundle client.
  loader: () => (import.meta.env.SSR ? seedProgramme() : null),
  head: () => ({
    meta: [
      { title: "Programme scolaire tunisien · Na9ra Nal3ab" },
      {
        name: "description",
        content:
          "Tout le programme scolaire tunisien, de la 1ère année de base au Baccalauréat, en accès libre : cours, résumés et exercices gratuits, sans compte.",
      },
    ],
    scripts: [
      {
        type: "application/ld+json",
        children: serializeJsonLd(breadcrumbJsonLd([{ name: "Programme", path: "/programme" }])),
      },
    ],
  }),
  component: ProgrammePage,
});

/** SSR seulement : le catalogue anonyme des niveaux. `null` en cas de panne (le client recharge). */
function seedProgramme() {
  return seedOnServer("programme", async () => {
    const server = await import("@/features/dashboard/dashboard.server");
    return server.getParcours();
  });
}

function ProgrammePage() {
  const t = useT();
  const fetchParcours = useServerFn(getParcours);
  const seed = Route.useLoaderData();
  const { data, isLoading, isError, refetch } = useQuery({
    queryKey: ["parcours", "catalogue"],
    queryFn: () => fetchParcours(),
    placeholderData: seed ?? undefined,
  });

  if (isError) {
    return (
      <div className="mx-auto max-w-md px-6 py-20">
        <EmptyState
          icon={CloudOff}
          tone="error"
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

  return (
    <>
      <ProgrammeCatalogue parcours={data.parcours as CatalogueParcours[]} />
      {/* é38 lot 5 : le visiteur sans compte retrouve ici aussi le chapitre qu'il lisait —
          en carte flottante, pour ne rien pousser sur cette page rendue côté serveur. */}
      <ResumeCard surface="programme" />
    </>
  );
}
