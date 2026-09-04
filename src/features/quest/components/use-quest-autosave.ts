import { useCallback, useEffect, useRef, useState, useSyncExternalStore } from "react";
import { isSessionRefusalError } from "@/shared/integrations/supabase/auth-rejection";
import { ensureFreshSession } from "@/shared/integrations/supabase/session-freshness";
import { enqueue, pendingCount, remove, subscribe } from "@/shared/lib/outbox";
import { reportClientError } from "@/shared/lib/client-log";
import {
  QUEST_SUBMIT_KIND,
  clearDraft,
  loadDraft,
  questOutboxClientId,
  resumeFrom,
  saveDraft,
  type QuestDraftAnswer,
} from "@/features/quest/quest-draft";

// =============================================================================
// LE TRAVAIL DE L'ÉLÈVE NE DOIT PLUS POUVOIR SE PERDRE — les deux étages.
//
// Étage 1, la partie EN COURS : un instantané local des réponses déjà données,
// pris périodiquement et à la fermeture de l'onglet. Il ne part jamais au
// serveur, parce qu'il n'y a rien pour le recevoir : une mission ne se soumet
// qu'en une fois, à la fin.
//
// Étage 2, la partie TERMINÉE : la soumission est mise en file AVANT d'être
// tentée, et n'en sort qu'une fois acceptée. C'est ce qui fait qu'un réseau
// coupé, un jeton refusé ou un onglet fermé ne coûtent plus la partie — au pire
// un délai, jusqu'au prochain déclencheur de `outbox.ts`.
//
// POURQUOI UN HOOK ET PAS DU CODE DANS LE LECTEUR. Même geste que
// `use-exercise-session` et `use-instant-feedback` : le lecteur garde ce qui le
// regarde (quand valider, quand avancer), le hook tient un cycle de vie. Ici
// c'est celui de la sauvegarde, et il a ses propres écouteurs à démonter.
// =============================================================================

/**
 * Cadence de l'instantané local. 20 s : assez rare pour ne rien coûter (une
 * écriture localStorage de quelques kilo-octets), assez fréquent pour qu'un
 * onglet tué par le système mobile ne fasse jamais perdre plus d'une question
 * ou deux — le rythme d'un élève étant de l'ordre de la dizaine de secondes par
 * question.
 */
export const QUEST_SNAPSHOT_INTERVAL_MS = 20_000;

/** Ce que l'indicateur d'UI affiche. */
export type AutosaveStatus = "idle" | "pending" | "saved";

export type QuestAutosave = {
  status: AutosaveStatus;
  /** Une réponse vient de changer : le prochain instantané aura du travail. */
  markDirty: () => void;
  /**
   * Soumet le travail SOUS FILET, et rend ce que `send` a rendu.
   *
   * Le protocole entier vit ici plutôt qu'à l'écran, parce que c'est son ORDRE
   * qui protège et qu'un ordre réparti sur trois appels chez l'appelant est un
   * ordre qu'on finit par écrire de travers : mise en file et jeton frais AVANT
   * l'envoi, sortie de file au succès seulement, boîte noire à l'échec.
   */
  guardSubmit: <T>(sessionId: string, payload: unknown, send: () => Promise<T>) => Promise<T>;
};

export function useQuestAutosave({
  exerciseId,
  variant,
  enabled,
  sessionId,
  answers,
  idx,
}: {
  exerciseId: string;
  variant: string;
  /**
   * Le registre CONNECTÉ seulement. Le registre public `/exercice` joue en
   * anonyme : il n'a pas de compte où resynchroniser quoi que ce soit, et son
   * score ne quitte pas le navigateur.
   */
  enabled: boolean;
  sessionId: string | null;
  answers: readonly QuestDraftAnswer[];
  idx: number;
}): QuestAutosave {
  // Le nombre d'items en file est un état EXTERNE au React : la file bouge aussi
  // depuis les déclencheurs de `outbox.ts` (intervalle, retour de focus,
  // reconnexion), qui ne passent par aucun rendu.
  const queued = useSyncExternalStore(
    subscribe,
    pendingCount,
    // Au SSR il n'y a pas de `localStorage`, donc rien en attente.
    () => 0,
  );
  const [everSaved, setEverSaved] = useState(false);

  // Miroirs en ref : l'instantané est pris depuis un intervalle et depuis un
  // écouteur `pagehide`, dont l'identité ne doit pas changer à chaque réponse.
  const answersRef = useRef(answers);
  const idxRef = useRef(idx);
  const sessionIdRef = useRef(sessionId);
  const dirtyRef = useRef(false);
  answersRef.current = answers;
  idxRef.current = idx;
  sessionIdRef.current = sessionId;

  const markDirty = useCallback(() => {
    dirtyRef.current = true;
  }, []);

  const snapshot = useCallback(() => {
    if (!enabled || !dirtyRef.current) return;
    dirtyRef.current = false;
    saveDraft(exerciseId, variant, {
      sessionId: sessionIdRef.current,
      answers: answersRef.current,
      idx: idxRef.current,
    });
  }, [enabled, exerciseId, variant]);

  useEffect(() => {
    if (!enabled) return;
    const id = setInterval(snapshot, QUEST_SNAPSHOT_INTERVAL_MS);
    // ⚠️ `pagehide`, et pas `beforeunload` : sur mobile, `beforeunload` est
    // routinièrement SAUTÉ quand le système tue l'onglet — c'est exactement le
    // cas qu'on veut couvrir. `visibilitychange` complète le tableau, l'onglet
    // pouvant ne jamais revenir au premier plan. Les deux écrivent de façon
    // SYNCHRONE : après eux, il n'y a plus de tour de boucle garanti.
    const onHide = () => snapshot();
    const onVisibility = () => {
      if (document.visibilityState === "hidden") snapshot();
    };
    window.addEventListener("pagehide", onHide, { capture: true });
    document.addEventListener("visibilitychange", onVisibility);
    return () => {
      clearInterval(id);
      window.removeEventListener("pagehide", onHide, { capture: true });
      document.removeEventListener("visibilitychange", onVisibility);
      // Le démontage est lui aussi une sortie : changement d'exercice, retour
      // arrière. Ce qui n'a pas encore été pris l'est ici.
      snapshot();
    };
  }, [enabled, snapshot]);

  /**
   * ⚠️ L'ORDRE EST LE SUJET, et il est indivisible.
   *
   * On ÉCRIT, puis on tente. Une mise en file faite après l'appel ne
   * protégerait de rien — c'est pendant l'appel que tout se perd. Le jeton part
   * frais : geste préventif, en amont du rattrapage réactif d'`auth-attacher`.
   * Un échec de rafraîchissement ne bloque rien, le serveur tranchera et la
   * file rattrapera son refus.
   *
   * À l'échec, l'item RESTE en file — c'est tout l'intérêt de l'étage 2 — mais
   * l'échec est désormais RACONTÉ. ⚠️ C'est la moitié qui manquait le
   * 2026-09-03 : une mission validée qui ne s'enregistre pas ne produisait
   * qu'un `toast.error`, ni ligne en base, ni compteur, ni issue. Le lendemain,
   * le suivi parental montrait « 0 exercice » pour une soirée entière passée à
   * répondre, et rien nulle part ne disait pourquoi.
   *
   * Un refus d'AUTH n'est pas raconté ici : `outbox.ts` le fait déjà, avec le
   * TTL du jeton pris avant le rafraîchissement forcé, et le doubler fausserait
   * ses seuils.
   *
   * Aucune donnée personnelle : `clientId` désigne une soumission, jamais une
   * personne, et le payload ne porte que la variante et l'état de la file.
   */
  const guardSubmit = useCallback(
    async <T>(session: string, payload: unknown, send: () => Promise<T>): Promise<T> => {
      const clientId = questOutboxClientId(session);
      if (enabled) {
        enqueue({ clientId, kind: QUEST_SUBMIT_KIND, payload });
        await ensureFreshSession().catch(() => null);
      }

      try {
        const result = await send();
        remove(clientId);
        clearDraft(exerciseId, variant);
        dirtyRef.current = false;
        setEverSaved(true);
        return result;
      } catch (error) {
        if (!isSessionRefusalError(error)) {
          reportClientError({
            stage: "quest-submit",
            clientId,
            errMessage: error instanceof Error ? error.message : String(error),
            payload: { variant, queued: enabled },
          });
        }
        throw error;
      }
    },
    [enabled, exerciseId, variant],
  );

  return {
    status: queued > 0 ? "pending" : everSaved ? "saved" : "idle",
    markDirty,
    guardSubmit,
  };
}

/**
 * Reprend un brouillon laissé par une session précédente, une fois par exercice.
 *
 * VIT ICI ET PAS DANS LE LECTEUR, pour la même raison que le reste du fichier :
 * c'est un cycle de vie de la SAUVEGARDE. Le lecteur ne fournit que ce qu'il est
 * seul à savoir — les questions réellement servies — et reçoit un état à poser.
 *
 * ⚠️ UN BROUILLON COMPLET N'EST PAS REPRIS. S'il ne reste aucune question sans
 * réponse, la partie était finie et seule la SOUMISSION a échoué : elle est déjà
 * en file, et `outbox.ts` la rejouera. Repeupler l'écran ferait re-valider
 * l'élève sous une session NEUVE — donc une seconde tentative pour un travail
 * déjà enregistré.
 */
export function useQuestDraftRestore({
  exerciseId,
  variant,
  enabled,
  questionIds,
  onRestore,
}: {
  exerciseId: string;
  variant: string;
  enabled: boolean;
  questionIds: readonly string[];
  onRestore: (state: { answers: QuestDraftAnswer[]; idx: number }) => void;
}): void {
  const restoredForRef = useRef<string | null>(null);
  const onRestoreRef = useRef(onRestore);
  onRestoreRef.current = onRestore;

  useEffect(() => {
    if (!enabled || questionIds.length === 0) return;
    if (restoredForRef.current === exerciseId) return;
    restoredForRef.current = exerciseId;

    const draft = loadDraft(exerciseId, variant);
    if (!draft) return;
    const resumed = resumeFrom(questionIds, draft.answers);
    if (resumed.answers.length === 0 || resumed.idx >= questionIds.length) return;
    onRestoreRef.current(resumed);
  }, [enabled, exerciseId, questionIds, variant]);
}
