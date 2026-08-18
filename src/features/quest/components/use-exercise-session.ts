import { useCallback, useEffect, useRef, useState } from "react";
import { useMutation } from "@tanstack/react-query";
import { toast } from "sonner";
import type {
  ExercisePlayerStrategy,
  StartOutcome,
} from "@/features/quest/components/exercise-player";

// =============================================================================
// Le CYCLE DE VIE d'une session de mission, extrait du lecteur : démarrage,
// verdict de gate (premium / quiz / rappel), échec, relance, remise à zéro.
// Même geste que `use-instant-feedback` — le lecteur garde ce qui le regarde
// (quand valider, quand avancer), le hook tient l'état de la session.
//
// POURQUOI LA RELANCE EXISTE. Le démarrage vit dans un effet qui ne se
// redéclenche pas tout seul après un échec, et un garde-fou interdit une
// seconde tentative pour le même exercice. Sans `retry`, une panne passagère
// était donc DÉFINITIVE pour la partie : le lecteur se rendait sans session, et
// « Valider » restait actif sans jamais rien faire.
// =============================================================================

/** Ce que le hook a besoin de lire de l'exercice chargé. */
type ExerciseForSession = {
  exercise?: { id?: string | null; chapter_id?: unknown; mode?: unknown } | null;
  quizGated?: boolean;
} | null;

export type ExerciseSession = {
  /** La session en cours — `null` tant qu'elle n'est pas ouverte. */
  sessionId: string | null;
  /** Le gate qui a refusé le démarrage (premium, quiz, rappel), s'il y en a un. */
  startGate: Exclude<StartOutcome, { ok: true }> | null;
  isPending: boolean;
  isError: boolean;
  error: unknown;
  /** Relance un démarrage après un échec (le seul moyen d'en sortir). */
  retry: () => void;
  /** Remet tout à zéro (changement d'exercice, rejeu). */
  reset: () => void;
};

export function useExerciseSession({
  data,
  paused,
  variant,
  startSession,
  onStarted,
}: {
  data: ExerciseForSession | undefined;
  /** La partie est finie (écran de score) : ne rien démarrer. */
  paused: boolean;
  variant: "classic" | "recall";
  startSession: ExercisePlayerStrategy["startSession"];
  /** Appelé quand une session vient de s'ouvrir (chrono de la partie, son). */
  onStarted: () => void;
}): ExerciseSession {
  const [sessionId, setSessionId] = useState<string | null>(null);
  const [startGate, setStartGate] = useState<Exclude<StartOutcome, { ok: true }> | null>(null);
  // Compteur de relance : les dépendances de l'effet ne bougent pas après un
  // échec, donc c'est lui qui le fait repartir. Aucune autre sémantique.
  const [retryTick, setRetryTick] = useState(0);
  const startedForRef = useRef<string | null>(null);
  // `onStarted` est recréé à chaque rendu côté lecteur : on le lit par ref pour
  // ne pas relancer l'effet (ni recréer la mutation) à cause de son identité.
  const onStartedRef = useRef(onStarted);
  onStartedRef.current = onStarted;

  const mutation = useMutation({
    mutationFn: (payload: {
      exerciseId: string;
      quizGated: boolean;
      chapterId: string | null;
      mode: string;
      variant: "classic" | "recall";
    }) => startSession(payload),
    onSuccess: (outcome) => {
      if (outcome.ok) {
        setSessionId(outcome.sessionId);
        onStartedRef.current();
      } else {
        setStartGate(outcome);
      }
    },
    onError: (e) => toast.error(e instanceof Error ? e.message : "Unable to start the quest"),
  });
  const { mutate, reset: resetMutation } = mutation;

  useEffect(() => {
    const ex = data?.exercise;
    if (!ex?.id || sessionId || paused || startGate) return;
    if (startedForRef.current === ex.id) return;
    startedForRef.current = ex.id;
    mutate({
      exerciseId: ex.id,
      quizGated: data?.quizGated ?? false,
      chapterId: (ex.chapter_id as string | null) ?? null,
      mode: (ex.mode as string | null) ?? "",
      variant,
    });
  }, [data, paused, sessionId, startGate, mutate, variant, retryTick]);

  const retry = useCallback(() => {
    startedForRef.current = null;
    resetMutation();
    setRetryTick((n) => n + 1);
  }, [resetMutation]);

  const reset = useCallback(() => {
    startedForRef.current = null;
    resetMutation();
    setSessionId(null);
    setStartGate(null);
  }, [resetMutation]);

  return {
    sessionId,
    startGate,
    isPending: mutation.isPending,
    isError: mutation.isError,
    error: mutation.error,
    retry,
    reset,
  };
}
