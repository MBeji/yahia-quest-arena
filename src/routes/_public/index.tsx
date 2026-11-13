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
  // Pas de `head` : le titre, la description et l'aperçu de partage de l'accueil
  // sont ceux du site, que la racine rend déjà dans la langue de la requête
  // (`metaByLocale`). Des littéraux français posés ici les écrasaient pour les
  // visiteurs anglais et arabes (issue #1228, `landing-head-overrides-localized-meta`).
  component: HomePage,
});

/**
 * Fetches the anon catalogue stats (real compiled numbers) for the landing proof
 * band and hands them to <PublicLanding/>. While they load the band holds its place
 * with empty slots (never a fake count); it disappears only if the read fails.
 */
function HomePage() {
  const fetchStats = useServerFn(getCatalogueStats);
  const { data, isPending } = useQuery({
    queryKey: ["catalogue-stats"],
    queryFn: () => fetchStats(),
  });
  // `isPending` est vrai aussi au rendu serveur (la requête ne part que du client) : le
  // HTML porte la bande à sa taille, et l'arrivée des chiffres ne déplace plus rien.
  return <PublicLanding stats={data} statsPending={isPending} />;
}
