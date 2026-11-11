import { useCallback, useEffect, useRef, useState } from "react";

import {
  parseAttemptProgress,
  sealToCelebrate,
  type AttemptProgress,
} from "@/shared/lib/progress-stars";
import { emitStarProgressTelemetry } from "./quest-result-facts";

/** Le son que la modale de sceau accompagne. Le lecteur le joue, comme le level-up. */
type PlaySound = (name: "unlock") => void;

/**
 * LA CÉLÉBRATION DES ÉTOILES ET DES SCEAUX (étude 34, R-12) — ses deux états et
 * ses trois gardes, sortis du lecteur d'exercice.
 *
 * Extrait parce que `exercise-player.tsx` avait atteint sa limite de 750 lignes,
 * et le découpage tombe juste : « ce que ce geste a fait tomber » est un sujet
 * entier, avec ses règles à lui.
 *
 * Les trois gardes, et pourquoi chacune existe :
 *
 *  1. **Un rejeu ne célèbre rien.** `replayed` dit que la RPC a renvoyé une
 *     tentative déjà enregistrée : le grand livre n'a pas bougé, donc il n'y a
 *     rien de neuf à fêter. Même garde que le level-up.
 *  2. **La modale de sceau passe DERRIÈRE le level-up.** Deux plein-écrans au
 *     même instant se recouvriraient ; R-12 n'en veut qu'un à la fois, et é31 R-6
 *     interdit déjà d'en enchaîner.
 *  3. **Une lecture qui échoue ne fête rien.** L'écran de résultat reste complet ;
 *     il se tait simplement. Une célébration inventée vaut moins que pas de
 *     célébration — elle apprend à l'élève à ne plus y croire.
 *
 * ⚠️ Le report de la modale (garde 2) est un `setTimeout`, donc il SURVIT à ce qui
 * l'a demandé s'il n'est pas annulé. Un élève qui enchaîne dans la seconde et demie
 * — le lecteur se réinitialise, il ne se démonte pas — verrait le sceau de
 * l'exercice PRÉCÉDENT se lever sur le nouveau : la pire version de la garde 3, une
 * célébration qui ment sur ce qu'elle fête. Le timer est donc tenu en ref, annulé
 * par `reset` et au démontage, et remplacé s'il en revient un.
 */
export function useAttemptCelebration(
  loadProgress: ((exerciseId: string) => Promise<unknown>) | undefined,
  play: PlaySound,
) {
  const [progress, setProgress] = useState<AttemptProgress | null>(null);
  const [showSeal, setShowSeal] = useState(false);
  // `play` change à chaque rendu du provider de son : le garder dans une ref évite
  // de recréer `load` (et donc de relancer la lecture) pour cette seule raison.
  const playRef = useRef(play);
  playRef.current = play;
  // Le report de la modale, annulable. `undefined` = rien en vol.
  const sealTimerRef = useRef<ReturnType<typeof setTimeout> | undefined>(undefined);
  const clearSealTimer = useCallback(() => {
    if (sealTimerRef.current !== undefined) {
      clearTimeout(sealTimerRef.current);
      sealTimerRef.current = undefined;
    }
  }, []);
  // Le démontage compte autant que la réinitialisation : quitter la page pendant
  // le report ne doit pas laisser un timer tenir une fermeture sur du démonté.
  useEffect(() => clearSealTimer, [clearSealTimer]);

  const load = useCallback(
    ({
      exerciseId,
      replayed,
      leveledUp,
    }: {
      exerciseId: string;
      replayed: boolean;
      leveledUp: boolean;
    }) => {
      if (!loadProgress || replayed) return;
      clearSealTimer();
      void loadProgress(exerciseId)
        .then((raw) => {
          const parsed = parseAttemptProgress(raw);
          setProgress(parsed);
          if (parsed) emitStarProgressTelemetry(parsed);
          if (sealToCelebrate(parsed)) {
            sealTimerRef.current = setTimeout(
              () => {
                sealTimerRef.current = undefined;
                setShowSeal(true);
                playRef.current("unlock");
              },
              leveledUp ? 2600 : 1400,
            );
          }
        })
        .catch(() => setProgress(null));
    },
    [loadProgress, clearSealTimer],
  );

  const reset = useCallback(() => {
    clearSealTimer();
    setProgress(null);
    setShowSeal(false);
  }, [clearSealTimer]);

  const dismissSeal = useCallback(() => {
    clearSealTimer();
    setShowSeal(false);
  }, [clearSealTimer]);

  return { progress, showSeal, load, reset, dismissSeal };
}
