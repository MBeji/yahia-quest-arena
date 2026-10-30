import { useCallback } from "react";
import { useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { useT } from "@/lib/i18n";
import { supabase } from "@/shared/integrations/supabase/client";
import { logger } from "@/shared/lib/logger";

/**
 * Vrai tant qu'une session reste sur l'appareil. Une lecture qui échoue ne prouve pas la sortie :
 * dans le doute, on la tient pour ouverte.
 */
async function sessionRemains(): Promise<boolean> {
  try {
    const { data } = await supabase.auth.getSession();
    return data.session !== null;
  } catch {
    return true;
  }
}

/** La déconnexion complète ; rend l'échec (renvoyé ou levé) tel quel, `null` quand elle a réussi. */
async function signOutFailure(): Promise<unknown> {
  try {
    const { error } = await supabase.auth.signOut();
    return error;
  } catch (error: unknown) {
    return error;
  }
}

/**
 * SE DÉCONNECTER SANS QUITTER LA PAGE (é38 lot 1, R-11 · US-7).
 *
 * La coquille connectée renvoie sur l'accueil : son écran n'existe plus sans session. La
 * coquille publique, elle, n'est pas un espace de compte — un visiteur connecté qui lit un
 * cours et se déconnecte reste sur ce cours, en visiteur.
 *
 * Deux gestes, dans cet ordre.
 *
 *   1. `signOut()` termine la session. Il RENVOIE ses erreurs sans les lever, et `auth-js` retire
 *      la session de l'appareil même quand la révocation côté serveur échoue (réseau coupé) :
 *      une erreur ne veut donc pas dire « encore connecté ». On le lit sur la session elle-même ;
 *      si elle est restée, on le dit et on s'arrête — afficher « à bientôt » à quelqu'un qui reste
 *      connecté serait faux.
 *   2. `resetQueries()` : ce que le compte avait servi (indices, rôle, progression) ne doit pas
 *      rester à l'écran. Les requêtes actives repartent en anonyme, les autres sont oubliées.
 *
 * Ce que le geste NE touche PAS : les mémoires de l'appareil (portes quiz réussies, retour
 * mémorisé). Un identifiant de chapitre n'est pas une donnée de compte (R-13) ; et le retour
 * mémorisé n'est écrit par la garde que pour qui n'a jamais eu de session ici.
 */
export function useSignOutInPlace(): () => Promise<void> {
  const t = useT();
  const queryClient = useQueryClient();

  return useCallback(async () => {
    const failure = await signOutFailure();
    if (failure) {
      const stillSignedIn = await sessionRemains();
      const meta = {
        error: failure instanceof Error ? failure.message : failure,
        sessionRemains: stillSignedIn,
      };
      if (stillSignedIn) {
        logger.error("auth.signOutInPlace", meta);
        toast.error(t.errors.errorFallback);
        return;
      }
      logger.warn("auth.signOutInPlace", meta);
    }

    await queryClient.resetQueries();
    toast.success(t.layout.logoutToast);
  }, [queryClient, t]);
}
