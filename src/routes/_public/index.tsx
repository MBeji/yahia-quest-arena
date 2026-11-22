import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useEffect } from "react";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { getCatalogueStats } from "@/features/dashboard";
import { hubRouteForRole, useAuth, useMyRole } from "@/features/auth";
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
  // LA VITRINE EST POUR LE VISITEUR (arbitrage Q-3 de l'audit de navigation du 2026-11-21, N-9).
  // L'application installée s'ouvre ici (`start_url`), comme l'adresse tapée du site et le lien
  // « Retour à l'accueil » de la page 404 : un connecté y voyait la présentation du produit et
  // devait toucher « Hall ». Une fois sa session et son rôle lus, il passe dans SON espace — Hall,
  // ou Suivi pour un parent — sans que la vitrine reste dans l'historique. Le rendu serveur ne
  // connaît pas la session : moteurs de recherche et aperçus de partage voient toujours la vitrine.
  const { user } = useAuth();
  const { role, isLoaded: roleLoaded } = useMyRole();
  const navigate = useNavigate();
  useEffect(() => {
    if (user && roleLoaded) void navigate({ to: hubRouteForRole(role), replace: true });
  }, [user, roleLoaded, role, navigate]);

  const fetchStats = useServerFn(getCatalogueStats);
  const { data, isPending } = useQuery({
    queryKey: ["catalogue-stats"],
    queryFn: () => fetchStats(),
  });
  // `isPending` est vrai aussi au rendu serveur (la requête ne part que du client) : le
  // HTML porte la bande à sa taille, et l'arrivée des chiffres ne déplace plus rien.
  return <PublicLanding stats={data} statsPending={isPending} />;
}
