import { useCallback, useRef, useState } from "react";
import { useSound, encouragementFor, type Encouragement } from "@/lib/sound";
import type { TranslationKeys } from "@/lib/i18n/types";
import type { QuestionVerdict } from "@/features/quest/verdict";

// =============================================================================
// La machine à états du retour immédiat (levier 01), extraite du lecteur : elle
// tient le verdict courant, la série de bonnes réponses et sa bannière. Le
// lecteur garde ce qui le regarde — quand valider, quand avancer.
// =============================================================================

export type InstantFeedback = {
  verdict: QuestionVerdict | null;
  checking: boolean;
  streak: number;
  encouragement: Encouragement | null;
  /**
   * Corrige la réponse déjà VERROUILLÉE par l'appelant. Rend `true` si un
   * verdict est désormais à l'écran (le lecteur attend « Continuer »), `false`
   * s'il doit enchaîner tout de suite : correction indisponible, exercice non
   * corrigible, ou panne — aucun de ces cas ne doit enfermer l'élève.
   */
  check: (questionId: string, choice: string) => Promise<boolean>;
  /** Referme le verdict avant de passer à la question suivante. */
  clear: () => void;
  /** Remet la série à zéro (changement d'exercice, rejeu). */
  reset: () => void;
};

export function useInstantFeedback({
  enabled,
  exerciseId,
  labels,
  checkAnswer,
}: {
  enabled: boolean;
  exerciseId: string;
  labels: TranslationKeys["encouragement"];
  checkAnswer?: (args: {
    exerciseId: string;
    questionId: string;
    choice: string;
  }) => Promise<QuestionVerdict | null>;
}): InstantFeedback {
  const { play, combo } = useSound();
  const [verdict, setVerdict] = useState<QuestionVerdict | null>(null);
  const [checking, setChecking] = useState(false);
  const [streak, setStreak] = useState(0);
  const [encouragement, setEncouragement] = useState<Encouragement | null>(null);
  // La série est lue ET écrite dans le même tour : un ref évite d'en dépendre
  // dans les callbacks (et donc de corriger sur une valeur périmée).
  const streakRef = useRef(0);

  const check = useCallback(
    async (questionId: string, choice: string): Promise<boolean> => {
      if (!enabled || !checkAnswer) return false;
      setChecking(true);
      try {
        const result = await checkAnswer({ exerciseId, questionId, choice });
        if (!result) return false;
        setVerdict(result);
        if (result.isCorrect) {
          streakRef.current += 1;
          setStreak(streakRef.current);
          combo(streakRef.current);
          setEncouragement(encouragementFor(labels, streakRef.current));
        } else {
          streakRef.current = 0;
          setStreak(0);
          setEncouragement(null);
          play("wrong");
        }
        return true;
      } catch {
        return false;
      } finally {
        setChecking(false);
      }
    },
    [enabled, checkAnswer, exerciseId, labels, combo, play],
  );

  const clear = useCallback(() => {
    setVerdict(null);
    setEncouragement(null);
  }, []);

  const reset = useCallback(() => {
    streakRef.current = 0;
    setVerdict(null);
    setChecking(false);
    setStreak(0);
    setEncouragement(null);
  }, []);

  return { verdict, checking, streak, encouragement, check, clear, reset };
}
