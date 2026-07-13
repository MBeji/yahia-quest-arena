import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { getCatalogueStats } from "@/features/dashboard";
import { PublicLanding } from "@/components/public/public-landing";

/**
 * Public home `/` — repositioned « plateforme publique gratuite » entry (chantier C8,
 * L1.2). Thin: renders <PublicLanding/> inside the `_public` coquille (Référence
 * register + public header/footer). Replaces the old paid-concours RPG landing.
 */
export const Route = createFileRoute("/_public/")({
  head: () => ({
    meta: [
      { title: "Na9ra Nal3ab — tous les cours de l’école tunisienne, gratuitement" },
      {
        name: "description",
        content:
          "Cours, résumés et exercices corrigés de toute l’école tunisienne, de la 1re année au Baccalauréat. Accès libre, gratuit, sans inscription — pour toute la famille.",
      },
      {
        property: "og:title",
        content: "Na9ra Nal3ab — l’école tunisienne, gratuite et en accès libre",
      },
      {
        property: "og:description",
        content:
          "Tout le programme officiel, du Primaire au Bac : cours, résumés et exercices corrigés, gratuitement.",
      },
    ],
  }),
  component: HomePage,
});

/**
 * Fetches the anon catalogue stats (real compiled numbers) for the landing proof
 * band and hands them to <PublicLanding/>. The band self-hides until the numbers
 * load, so the landing renders instantly and never shows a fake/placeholder count.
 */
function HomePage() {
  const fetchStats = useServerFn(getCatalogueStats);
  const { data } = useQuery({
    queryKey: ["catalogue-stats"],
    queryFn: () => fetchStats(),
  });
  return <PublicLanding stats={data} />;
}
