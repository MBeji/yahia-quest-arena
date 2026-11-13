import { useMemo } from "react";
import type { InstallAudience } from "@/components/public/install-invite";
import { NudgeSlot } from "@/components/public/nudge-slot";
import { useInstallCandidate } from "@/components/public/use-install-candidate";

/**
 * L'emplacement d'un écran qui n'a QUE l'invitation à installer à proposer (étude 40, lot 3) :
 * l'écran de résultat sans compte, le bilan parent de `/suivi`. Un écran qui en compose
 * plusieurs passe ses candidats à `NudgeSlot` lui-même (la route de quête).
 *
 * @param eligible R-11 — après une réussite, ou devant un bilan affiché ; jamais autrement.
 * @param late     emplacement en bas de page : une invitation arrivée après l'écran ne pousse rien.
 */
export function InstallNudge({
  audience,
  eligible,
  late,
}: {
  audience: InstallAudience;
  eligible: boolean;
  late?: boolean;
}) {
  const install = useInstallCandidate(audience, eligible);
  const candidates = useMemo(() => [install], [install]);
  return <NudgeSlot candidates={candidates} late={late} />;
}
