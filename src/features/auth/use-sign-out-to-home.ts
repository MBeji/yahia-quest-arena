import { useCallback } from "react";
import { useNavigate } from "@tanstack/react-router";
import { useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { supabase } from "@/shared/integrations/supabase/client";

/**
 * SE DÉCONNECTER DEPUIS L'ESPACE CONNECTÉ : RETOUR À L'ACCUEIL (arbitrage Q-4 de l'audit de
 * navigation du 2026-11-21, constat N-7).
 *
 * Le geste faisait deux navigations qui se disputaient : le code poussait l'accueil avec « à
 * bientôt », et la garde de la coquille, voyant la session disparaître, poussait `/auth`. La garde
 * gagnait — on arrivait sur l'écran de connexion, l'accueil restait derrière dans l'historique.
 *
 * Une déconnexion VOULUE se déclare donc avant de partir ; la garde la lit et s'efface. Une session
 * qui MEURT (refus, expiration) ne passe pas par ici : la garde la traite comme avant, et `/auth`
 * dit « ta session a expiré ».
 */
let deliberate = false;

/** Vrai pendant une déconnexion demandée par l'utilisateur — la garde de la coquille s'efface. */
export function isDeliberateSignOut(): boolean {
  return deliberate;
}

/**
 * La déconnexion qui mène à l'accueil. `message` : le toast affiché à l'arrivée (« à bientôt »,
 * ou « compte supprimé » après une suppression de compte).
 *
 * Ordre : la session se ferme, on quitte l'espace connecté (`replace` : Retour ne ramène pas sur un
 * écran de compte qui renverrait à `/auth`), puis ce que le compte avait servi est oublié — APRÈS
 * le départ, pour que les écrans du compte ne relancent pas leurs lectures sans session.
 */
export function useSignOutToHome(): (message: string) => Promise<void> {
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  return useCallback(
    async (message: string) => {
      deliberate = true;
      try {
        await supabase.auth.signOut();
        await navigate({ to: "/", replace: true });
        await queryClient.resetQueries();
        toast.success(message);
      } finally {
        deliberate = false;
      }
    },
    [navigate, queryClient],
  );
}
