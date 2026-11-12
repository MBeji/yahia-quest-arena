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
import { pageTitle } from "@/lib/i18n/head";
import { seedOnServer } from "@/shared/lib/public-page-seo";
import { WaitingForNetwork, isWaitingForNetwork } from "@/components/ui/query-wait-state";

/**
 * Public catalogue — the optional `libre` extras (« Référence » register, chantier C8,
 * L1.3). Thin: fetches the parcours catalogue (anon-capable `getParcours`) and hands
 * the rows to <ExtrasCatalogue/>, which keeps only the `libre` tracks. No auth guard.
 */
export const Route = createFileRoute("/_public/extras")({
  // Rendu serveur du catalogue (`public-page-seo.ts`), comme `/programme` : cette
  // page partait du serveur avec « Chargement… », or c'est par elle seule que le
  // site mène aux six parcours libres (langues, culture générale, logique…).
  // Derrière `import.meta.env.SSR`, le préchargement sort du bundle client.
  loader: () => (import.meta.env.SSR ? seedExtras() : null),
  head: () => ({
    meta: [
      { title: pageTitle((t) => t.public.titles.extras) },
      {
        name: "description",
        content:
          "Au-delà du programme scolaire : apprends les langues, la culture générale et muscle ton cerveau. Parcours optionnels en accès libre et gratuit.",
      },
    ],
  }),
  component: ExtrasPage,
});

/** SSR seulement : le catalogue anonyme des niveaux. `null` en cas de panne (le client recharge). */
function seedExtras() {
  return seedOnServer("extras", async () => {
    const server = await import("@/features/dashboard/dashboard.server");
    return server.getParcours();
  });
}

function ExtrasPage() {
  const fetchParcours = useServerFn(getParcours);
  const t = useT();
  const seed = Route.useLoaderData();
  const { data, isLoading, isError, refetch, fetchStatus } = useQuery({
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

  // é38 lot 4 (R-9) : sans réseau la lecture est en PAUSE, pas en cours — le dire,
  // au lieu d'un chargement qui ne finira pas. Elle repart seule à son retour.
  if (isWaitingForNetwork({ fetchStatus, data })) {
    return <WaitingForNetwork onRetry={() => refetch()} />;
  }

  if (isLoading || !data) {
    return <LoadingState label={t.common.loading} className="min-h-[60dvh]" />;
  }

  return <ExtrasCatalogue parcours={data.parcours as CatalogueParcours[]} />;
}
