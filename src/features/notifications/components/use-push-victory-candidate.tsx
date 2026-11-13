import { useEffect, useMemo, useState } from "react";
import type { NudgeCandidate, NudgeControls } from "@/components/public/nudge-slot";
import { usePush } from "../use-push";
import { PushVictoryCard } from "./push-victory-card";

/**
 * Combien de temps l'écran de résultat attend que l'état du push soit lu avant de choisir son
 * invitation sans lui. `navigator.serviceWorker.ready` ne se résout jamais sans service worker
 * enregistré (développement, navigateur qui l'a refusé) : sans borne, l'emplacement attendrait
 * pour toujours, et l'installation comme le parent ne paraîtraient plus.
 */
export const PUSH_STATE_WAIT_MS = 1_500;

/**
 * Le candidat « rappel » de l'écran de résultat (R-6), à passer à `NudgeSlot` avec les autres
 * invitations. Proposable seulement après une réussite, et seulement si le navigateur n'a encore
 * rien décidé (`default`) : accordé, refusé, non pris en charge ou non configuré ⇒ rien.
 *
 * @param eligible la quête est-elle réussie (le seuil de l'écran, pas un seuil nouveau) ?
 */
export function usePushVictoryCandidate(eligible: boolean): NudgeCandidate {
  const push = usePush({ moment: "victory" });
  const [waitedOut, setWaitedOut] = useState(false);
  const loading = push.state === "loading";

  useEffect(() => {
    if (!eligible || !loading) return;
    const timer = setTimeout(() => setWaitedOut(true), PUSH_STATE_WAIT_MS);
    return () => clearTimeout(timer);
  }, [eligible, loading]);

  return useMemo(
    () => ({
      kind: "push",
      available: eligible && push.state === "default",
      pending: eligible && loading && !waitedOut,
      render: (controls: NudgeControls) => <PushVictoryCard push={push} controls={controls} />,
    }),
    [eligible, push, loading, waitedOut],
  );
}
