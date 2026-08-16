import { useEffect, useRef } from "react";
import { useServerFn } from "@tanstack/react-start";
import { recordLearningPulse } from "@/shared/lib/learning-pulse.server";
import {
  PULSE_FLUSH_MS,
  PULSE_TICK_MS,
  advancePulse,
  createPulseState,
  takePulseSeconds,
  type LearningSurface,
  type PulseState,
} from "@/shared/lib/learning-pulse";

export type UseLearningPulseOptions = {
  surface: LearningSurface;
  /** Slug de matière (`subjects.id`). Facultatif : le rapport sait la retrouver. */
  subjectId?: string | null;
  chapterId?: string | null;
  exerciseId?: string | null;
  /**
   * Avancée dans le contenu (0–100) au moment de l'envoi. Lue à CHAQUE envoi via
   * une ref, pour qu'un défilement ne relance pas les minuteries.
   */
  progressPct?: number | null;
  /**
   * Aucun pouls sans compte : le suivi parental n'existe que pour un élève
   * identifié, et un visiteur anonyme n'a rien à alimenter. L'appelant transmet
   * son propre état d'authentification — ce hook ne dépend d'aucune feature.
   */
  enabled?: boolean;
};

/**
 * Mesure le temps d'apprentissage réel de l'écran courant et l'envoie au serveur.
 *
 * Monté sur un écran, il compte les secondes pendant lesquelles l'onglet est
 * visible ET l'élève actif (cf. `learning-pulse.ts`), puis les envoie chaque
 * minute, au masquage de l'onglet et au démontage. C'est ce qui alimente le
 * « temps par type d'activité », les heures de première/dernière activité, le
 * nombre de sessions, et — pour un cours — la durée et le pourcentage lu.
 *
 * Contraintes tenues :
 *   * jamais bloquant — les envois sont en arrière-plan, les erreurs avalées ;
 *   * jamais de re-rendu — tout l'état vit dans des refs ;
 *   * jamais de fuite — un seul minuteur, retiré au démontage ;
 *   * SSR-safe — rien ne démarre hors navigateur ;
 *   * jamais de temps mal attribué — changer de chapitre ou d'exercice solde le
 *     compteur AVANT de repartir (l'identité mesurée est dans les dépendances de
 *     l'effet, et la fermeture capture ses valeurs).
 */
export function useLearningPulse({
  surface,
  subjectId = null,
  chapterId = null,
  exerciseId = null,
  progressPct = null,
  enabled = true,
}: UseLearningPulseOptions): void {
  const record = useServerFn(recordLearningPulse);

  const recordRef = useRef(record);
  recordRef.current = record;

  // Seule valeur volatile : elle change à chaque défilement et ne doit surtout
  // pas figurer dans les dépendances de l'effet.
  const progressRef = useRef(progressPct);
  progressRef.current = progressPct;

  const stateRef = useRef<PulseState>(createPulseState());
  const lastInteractionRef = useRef(0);

  useEffect(() => {
    if (!enabled || typeof window === "undefined") return;

    stateRef.current = createPulseState();
    lastInteractionRef.current = Date.now();

    const markInteraction = () => {
      lastInteractionRef.current = Date.now();
    };

    // Passifs : aucun de ces écouteurs ne doit peser sur le défilement.
    const events = ["pointerdown", "keydown", "wheel", "touchstart", "scroll"] as const;
    for (const event of events) {
      window.addEventListener(event, markInteraction, { passive: true });
    }

    const flush = () => {
      const { seconds, next } = takePulseSeconds(stateRef.current);
      stateRef.current = next;
      if (seconds <= 0) return;

      const pct = progressRef.current;
      // Fire-and-forget : la télémétrie ne doit jamais faire échouer un écran.
      void recordRef
        .current({
          data: {
            surface,
            activeSeconds: seconds,
            subjectId: subjectId ?? undefined,
            chapterId: chapterId ?? undefined,
            exerciseId: exerciseId ?? undefined,
            progressPct: pct ?? undefined,
          },
        })
        .catch(() => {});
    };

    let sinceLastFlush = 0;
    const tick = () => {
      stateRef.current = advancePulse(stateRef.current, {
        now: Date.now(),
        visible: document.visibilityState === "visible",
        lastInteractionAt: lastInteractionRef.current,
      });

      sinceLastFlush += PULSE_TICK_MS;
      if (sinceLastFlush >= PULSE_FLUSH_MS) {
        sinceLastFlush = 0;
        flush();
      }
    };

    const timer = window.setInterval(tick, PULSE_TICK_MS);

    // Quitter l'onglet est le cas NORMAL de fin de lecture. On solde d'abord la
    // tranche en cours (un dernier tic), puis on envoie : sans ça, jusqu'à une
    // minute de lecture réelle serait perdue à chaque changement d'onglet.
    const onVisibilityChange = () => {
      if (document.visibilityState !== "hidden") {
        // Au retour, l'absence compte comme une interaction : un délai
        // d'inactivité hérité ne doit pas couper immédiatement le comptage.
        lastInteractionRef.current = Date.now();
        return;
      }
      tick();
      sinceLastFlush = 0;
      flush();
    };
    document.addEventListener("visibilitychange", onVisibilityChange);

    return () => {
      window.clearInterval(timer);
      document.removeEventListener("visibilitychange", onVisibilityChange);
      for (const event of events) {
        window.removeEventListener(event, markInteraction);
      }
      // Démontage OU changement de cible : on solde ici, avec le contexte que
      // cette fermeture a capturé — le temps lu sur le chapitre A ne peut donc
      // pas être crédité au chapitre B.
      tick();
      flush();
    };
  }, [enabled, surface, subjectId, chapterId, exerciseId]);
}
