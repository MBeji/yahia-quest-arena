import { useCallback } from "react";
import { toast } from "sonner";
import { useInviteT } from "@/lib/i18n/invite";
import { parentInviteText } from "@/shared/lib/parent-invite";
import { trackProductEvent } from "@/shared/lib/product-events";
import { shareText, type ShareMethod } from "@/shared/lib/share-text";

/**
 * « INVITER MON PARENT » — étude 40, lot 5 (R-19, R-20 ; US-9).
 *
 * Rien ne partait de l'élève vers son parent : le code alliance se recopiait à la main. Ici un
 * geste suffit — le message porte le lien du bilan, code déjà rempli, et c'est l'élève qui choisit
 * le destinataire dans SON application (feuille de partage → WhatsApp → copie : le geste commun
 * de `share-text.ts`). Aucun champ de saisie, rien n'atteint nos serveurs.
 *
 * Deux surfaces, un seul geste :
 *   - le paramétrage, où le bouton est PERMANENT, à côté de « Copier » ;
 *   - l'écran de résultat, où la carte ne paraît qu'après une réussite, à un élève SANS lien
 *     parent actif, et seulement si `NudgeSlot` la retient (R-12 : une invitation par écran).
 *
 * LA MESURE : `content_shared{intent:"parent", surface, method}` — trois étiquettes fermées. Ni le
 * code, ni un identifiant, ni un prénom (R-4 — des mineurs) : ils ne vivent que dans le message
 * que l'élève envoie lui-même.
 */
export type ParentInviteSurface = "settings" | "result";

/** Le geste : rend le canal qui a abouti (`none` = rien n'est parti, rien n'est compté). */
export function useParentInvite(
  allianceCode: string,
  surface: ParentInviteSurface,
): () => Promise<ShareMethod> {
  const { text: template, copied } = useInviteT();
  return useCallback(async () => {
    if (!allianceCode) return "none";
    const method = await shareText(parentInviteText(template, allianceCode));
    if (method === "none") return method;
    trackProductEvent("content_shared", { intent: "parent", surface, method });
    // La copie est le seul canal muet : sans ce mot, l'élève ne sait pas qu'il a un message à coller.
    if (method === "copy") toast.success(copied);
    return method;
  }, [allianceCode, surface, template, copied]);
}
