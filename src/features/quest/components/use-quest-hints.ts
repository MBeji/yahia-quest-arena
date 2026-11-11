import { useCallback, useEffect, useState } from "react";
import { useMutation } from "@tanstack/react-query";
import type { ExercisePlayerStrategy } from "@/features/quest/components/exercise-player";

/**
 * Les indices consommables du lecteur (booster_hint / potion_rappel) : les
 * charges restantes, les indices déjà révélés par question, et la dépense d'une
 * charge via la stratégie. Extrait du lecteur tel quel — même geste que
 * `use-exercise-session` : le lecteur décide QUAND un indice est proposable
 * (jamais sur un quiz, un boss ou en Rappel), le hook tient l'état.
 */
export function useQuestHints({
  hintCharges,
  enabled,
  exerciseId,
  revealHint,
  onRevealed,
  onError,
}: {
  /** Les charges possédées, telles que `getExercise` les compte. */
  hintCharges: number;
  /** `capabilities.hints` de la stratégie : le registre anonyme n'en a pas. */
  enabled: boolean;
  exerciseId: string;
  revealHint: ExercisePlayerStrategy["revealHint"];
  /** Un indice vient d'être révélé (le son). */
  onRevealed: () => void;
  onError: (error: unknown) => void;
}) {
  const [remaining, setRemaining] = useState(0);
  const [revealed, setRevealed] = useState<Record<string, string | null>>({});

  useEffect(() => {
    setRemaining(enabled ? hintCharges : 0);
  }, [hintCharges, exerciseId, enabled]);

  const mutation = useMutation({
    mutationFn: (payload: { questionId: string }) => {
      if (!revealHint) return Promise.reject(new Error("hints unsupported"));
      return revealHint(payload.questionId);
    },
    onSuccess: (res) => {
      setRevealed((prev) =>
        res.questionId in prev ? prev : { ...prev, [res.questionId]: res.hint },
      );
      // Une charge n'est dépensée que si la RPC a bien révélé quelque chose.
      if (res.consumed) setRemaining((n) => Math.max(0, n - 1));
      onRevealed();
    },
    onError,
  });
  const { mutate } = mutation;

  const reveal = useCallback(
    (questionId: string) => {
      mutate({ questionId });
    },
    [mutate],
  );

  /** Remise à zéro au changement d'exercice ou au rejeu. */
  const reset = useCallback(() => {
    setRevealed({});
    setRemaining(enabled ? hintCharges : 0);
  }, [enabled, hintCharges]);

  return { remaining, revealed, reveal, isPending: mutation.isPending, reset };
}
