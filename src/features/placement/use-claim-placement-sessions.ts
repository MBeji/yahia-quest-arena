import { useEffect, useRef } from "react";
import { useServerFn } from "@tanstack/react-start";

import { trackProductEvent } from "@/shared/lib/product-events";

import { claimPlacementSessions } from "./placement.server";
import { forgetPlacements, readRememberedPlacements, rememberedTokens } from "./placement-memory";

/**
 * LE RATTACHEMENT (étude 39 R-16, US-4) — à la première connexion sur l'appareil, les tests que
 * l'appareil retient sont attachés au compte, puis oubliés de l'appareil.
 *
 * Monté par les ROUTES (la coquille connectée, l'entrée et le bilan du test) avec `enabled` =
 * « une session est lue ET il y a un utilisateur » : la feature n'importe pas `auth` (D-11).
 * Une fois par montage ; silencieux en cas d'échec (le test reste lisible par son jeton, et le
 * prochain montage réessaie). `onClaimed` permet à l'écran de bilan de se relire en propriétaire
 * — la correction complète s'ouvre sans rien rejouer (R-12).
 */
export function useClaimPlacementSessions(
  enabled: boolean,
  onClaimed?: (claimedIds: string[]) => void,
): void {
  const claim = useServerFn(claimPlacementSessions);
  const ran = useRef(false);
  const onClaimedRef = useRef(onClaimed);
  onClaimedRef.current = onClaimed;

  useEffect(() => {
    if (!enabled || ran.current) return;
    const tokens = rememberedTokens().slice(0, 10);
    if (tokens.length === 0) return;
    ran.current = true;
    const sent = new Set(tokens);
    claim({ data: { tokens } })
      .then(({ claimed }) => {
        // Tout ce qui a été envoyé quitte l'appareil : rattaché (c'est au compte désormais),
        // déjà au compte (lisible sans jeton), ou à quelqu'un d'autre (pas à cet appareil).
        forgetPlacements(
          readRememberedPlacements()
            .filter((p) => sent.has(p.token))
            .map((p) => p.id),
        );
        if (claimed.length > 0) {
          trackProductEvent("placement_claimed", { count: claimed.length });
          onClaimedRef.current?.(claimed);
        }
      })
      .catch(() => {
        ran.current = false;
      });
  }, [enabled, claim]);
}
