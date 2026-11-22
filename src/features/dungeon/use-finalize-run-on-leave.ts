import { useEffect, useRef } from "react";

/**
 * L'AUTRE PORTE DE SORTIE : un onglet, le logo, le bouton Retour. L'écran disparaît pendant une
 * partie EN COURS — elle est finalisée quand même, pour que rien de ce qui a été franchi ne se
 * perde. Les valeurs sont lues au DÉMONTAGE (refs), pas au montage : la partie démarre après.
 */
export function useFinalizeRunOnLeave(
  run: { runId: string | null; playing: boolean },
  finalize: (runId: string) => void,
): void {
  const runRef = useRef(run);
  const finalizeRef = useRef(finalize);
  useEffect(() => {
    runRef.current = run;
    finalizeRef.current = finalize;
  });
  useEffect(
    () => () => {
      const { runId, playing } = runRef.current;
      if (playing && runId) finalizeRef.current(runId);
    },
    [],
  );
}
