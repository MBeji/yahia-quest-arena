import { useEffect } from "react";
import { supabase } from "@/shared/integrations/supabase/client";
import { isSessionRefusalError } from "@/shared/integrations/supabase/auth-rejection";
import { reportClientError } from "@/shared/lib/client-log";

/**
 * UN REFUS D'AUTHENTIFICATION QUI ATTEINT L'ÉCRAN TERMINE LA SESSION (#938 → #969).
 *
 * CE QUE LA MESURE A MONTRÉ, APRÈS TROIS DIAGNOSTICS FAUX. La spec e2e affirme qu'une session
 * cassée ne laisse jamais l'élève sur un écran dont rien ne le sort. Trois correctifs ont visé
 * l'amont — le jeton (#1009), le classifieur (#1010), la frontière d'erreur racine — et la spec
 * est restée rouge chaque fois. Instrumentée pour dire ce qu'elle VOYAIT plutôt que la seule
 * URL, elle a rendu trois faits qui ont tout tranché :
 *
 *     frontière d'erreur racine visible: false
 *     titre à l'écran: "Impossible de charger le dashboard"
 *     clés de session restantes: 1
 *
 * Donc : ce n'est pas la frontière racine mais l'écran d'erreur PROPRE à la page ; le garde de
 * `_authenticated` est bien monté ; et surtout **la session est toujours là**. `user` reste vrai,
 * le garde n'a donc aucune raison de rediriger, et le seul bouton offert rejoue l'appel qui
 * échoue. C'est la panne de #931, jamais complètement refermée.
 *
 * LE CHAÎNON QUI MANQUAIT. `auth-attacher` ne termine une session que sur un refus PROUVÉ du
 * rafraîchissement — prudence justifiée, elle protège d'une déconnexion sur un réseau qui tousse.
 * Mais quand un refus atteint un écran d'erreur TERMINAL, la preuve est déjà faite ailleurs :
 * react-query a épuisé ses trois essais, et le premier échec a armé le forçage d'un jeton neuf.
 * Un refus qui survit à tout cela n'est plus passager. C'est le seul endroit qui le sache, donc
 * c'est ici que la session se termine.
 *
 * L'effet suffit à sortir l'élève : `signOut` émet `SIGNED_OUT`, `useAuth` remet `user` à `null`,
 * et le garde de `_authenticated` fait ce pour quoi il existe. On ne navigue pas soi-même — une
 * seule règle de redirection, au même endroit qu'avant.
 *
 * CE QU'IL NE FAIT PAS : une panne ORDINAIRE (bug de rendu, 500, requête cassée) garde son écran
 * et son bouton « Réessayer », qui sont la bonne réponse. Le prédicat lit `auth-refusals.ts`,
 * source unique des deux côtés — jamais un message en dur, c'est la divergence de #931 et
 * #914/#915.
 */
export function useExitOnRefusedSession(error: unknown): void {
  useEffect(() => {
    if (!isSessionRefusalError(error)) return;
    // `scope: "local"` : les jetons sont refusés, une révocation réseau échouerait de toute
    // façon — et faire dépendre la SORTIE de l'élève d'un appel qui peut pendre reproduirait
    // le gel que ce chemin est censé supprimer.
    void supabase.auth.signOut({ scope: "local" }).catch((cause: unknown) => {
      // Une déconnexion locale qui échoue ne doit pas masquer le refus d'origine : l'écran
      // d'erreur reste, il est visible, et c'est mieux qu'une exception avalée.
      reportClientError({
        stage: "token-attach",
        errMessage: `local sign-out after a refusal reached the UI: ${
          cause instanceof Error ? cause.message : String(cause)
        }`,
      });
    });
  }, [error]);
}
