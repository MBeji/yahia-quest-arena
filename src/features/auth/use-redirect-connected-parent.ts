import { useEffect } from "react";
import { useNavigate } from "@tanstack/react-router";
import { hubRouteForRole } from "./hub-route";
import { useMyRole } from "./use-my-role";

/**
 * UN PARENT CONNECTÉ N'A PAS BESOIN DE LA PORTE DU PARENT SANS COMPTE (é38 lot 1, R-14).
 *
 * `/suivi` sert le visiteur sans compte : il colle un code d'alliance et lit un bilan. Le parent
 * connecté a mieux — ses enfants liés, leur bilan, le lien lui-même — dans `/parent-report`. Il est
 * donc renvoyé là, par `replace` : « retour » ne le ramène pas sur une page qui le renverrait.
 *
 * Qui est renvoyé se décide ICI, par `hubRouteForRole` — la seule définition de « l'espace d'un
 * rôle » : un parent seulement. Un élève, un admin, un visiteur et un rôle encore inconnu gardent
 * la page ; aucune redirection ne part avant que le profil ait été lu.
 *
 * `enabled` laisse la route garder la page quand elle porte une demande précise : un lien partagé
 * `/suivi?code=…` vise le bilan de CET enfant, que l'espace du parent ne sait pas ouvrir.
 */
export function useRedirectConnectedParent({ enabled }: { enabled: boolean }): void {
  const { role } = useMyRole();
  const navigate = useNavigate();
  const hub = hubRouteForRole(role);

  useEffect(() => {
    if (enabled && hub === "/parent-report") void navigate({ to: hub, replace: true });
  }, [enabled, hub, navigate]);
}
