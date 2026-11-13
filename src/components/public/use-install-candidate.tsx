import { useMemo, useSyncExternalStore } from "react";
import { InstallInvite, type InstallAudience } from "@/components/public/install-invite";
import type { NudgeCandidate } from "@/components/public/nudge-slot";
import {
  getInstallMode,
  subscribeInstallMode,
  type InstallMode,
} from "@/shared/lib/install-prompt";

// Le serveur ne connaît pas l'appareil : `useSyncExternalStore` lui fait rendre « rien à
// proposer », rejoue ce rien pendant l'hydratation, puis lit le navigateur — aucun écart.
const noInstallOnServer = (): InstallMode => "none";

/**
 * Le candidat « installation » d'un écran (étude 40, lot 3), à passer à `NudgeSlot` avec les
 * autres invitations que l'écran sait proposer. Relu quand l'événement du navigateur arrive ou
 * se consomme.
 *
 * @param eligible le moment est-il le bon (R-11 : une réussite, un bilan affiché) ?
 */
export function useInstallCandidate(audience: InstallAudience, eligible: boolean): NudgeCandidate {
  const mode = useSyncExternalStore(subscribeInstallMode, getInstallMode, noInstallOnServer);
  return useMemo(
    () => ({
      kind: "install",
      available: eligible && mode !== "none",
      render: (controls) =>
        mode === "none" ? null : (
          <InstallInvite platform={mode} audience={audience} controls={controls} />
        ),
    }),
    [audience, eligible, mode],
  );
}
