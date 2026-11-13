import { useMemo } from "react";
import type { NudgeCandidate } from "@/components/public/nudge-slot";
import { ParentInviteCard } from "@/components/public/parent-invite";

/**
 * Le candidat « parent » d'un écran (R-20), à passer à `NudgeSlot` avec les autres invitations.
 *
 * @param eligible        le moment est-il le bon (R-11 : une réussite) ?
 * @param allianceCode    le code de l'élève ; vide (parent, admin, profil non lu) ⇒ pas de carte.
 * @param hasActiveParent la lecture « un parent est-il déjà lié ? ». SENS SÛR : seule la réponse
 *                        `false` ouvre la carte — en cours ou en échec (`undefined`), rien.
 */
export function useParentInviteCandidate({
  eligible,
  allianceCode,
  hasActiveParent,
}: {
  eligible: boolean;
  allianceCode: string;
  hasActiveParent: boolean | undefined;
}): NudgeCandidate {
  return useMemo(
    () => ({
      kind: "parent",
      available: eligible && allianceCode !== "" && hasActiveParent === false,
      render: (controls) => <ParentInviteCard allianceCode={allianceCode} controls={controls} />,
    }),
    [eligible, allianceCode, hasActiveParent],
  );
}
