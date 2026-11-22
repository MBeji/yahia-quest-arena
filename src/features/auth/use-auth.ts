import { useSyncExternalStore } from "react";
import type { Session, User } from "@supabase/supabase-js";
import { supabase } from "@/shared/integrations/supabase/client";
import { logger } from "@/shared/lib/logger";

/**
 * LA SESSION, LUE UNE FOIS ET PARTAGÉE (audit de navigation du 2026-11-21, § 6 A-2 · constats N-5
 * et N-6).
 *
 * `useAuth` tenait un état LOCAL : chacun de ses dix-sept appelants relisait la session à son
 * montage et repartait de « je ne sais pas ». Passer d'une coquille à l'autre démontait l'une et
 * montait l'autre : la nouvelle affichait un écran plein « Chargement… », sans en-tête ni onglets,
 * le temps de relire ce que l'ancienne savait déjà (100 à 145 ms mesurées sur un téléphone lent), et
 * la barre d'onglets disparaissait puis revenait. Une page de catalogue relisait la session six fois.
 *
 * Désormais une seule mémoire, partagée par tous : un composant qui se monte APRÈS la première
 * lecture reçoit la session tout de suite, au premier rendu.
 *
 * L'abonnement à Supabase vit tant qu'un composant lit la session. Quand le dernier se démonte, il
 * est coupé au tour suivant — pas tout de suite : une bascule de coquille démonte l'ancienne et
 * monte la nouvelle dans le même commit, et couper puis rouvrir entre les deux reviendrait à relire.
 * La dernière valeur connue est GARDÉE : à la réouverture, elle sert le premier rendu, et la relecture
 * qui repart la confirme ou la corrige aussitôt. Les server fns, elles, valident toujours le jeton.
 */
type AuthState = { session: Session | null; user: User | null; loading: boolean };

const LOADING: AuthState = { session: null, user: null, loading: true };

let state: AuthState = LOADING;
const listeners = new Set<() => void>();
let stop: (() => void) | null = null;
let stopTimer: ReturnType<typeof setTimeout> | null = null;

function publish(next: AuthState): void {
  state = next;
  for (const listener of listeners) listener();
}

function start(): void {
  let cancelled = false;
  const {
    data: { subscription },
  } = supabase.auth.onAuthStateChange((_event, session) => {
    if (cancelled) return;
    publish({ session, user: session?.user ?? null, loading: state.loading });
  });
  // `loading` retombe sur les DEUX chemins. Une lecture de session qui rejetait laissait `loading` à
  // `true` POUR TOUJOURS — et c'est le mur de connexion qui en dépend : `routes/_authenticated.tsx`
  // rend son écran d'attente tant que `loading`, son effet de redirection ne partait jamais, et une
  // route de compte restait affichée à un visiteur sans session. La posture juste pour une garde est
  // de **se fermer** : une session qu'on n'arrive pas à LIRE n'est pas une session.
  supabase.auth
    .getSession()
    .then(({ data }) => {
      if (!cancelled)
        publish({ session: data.session, user: data.session?.user ?? null, loading: false });
    })
    .catch((error: unknown) => {
      logger.error("auth.getSession", { error: error instanceof Error ? error.message : error });
      if (!cancelled) publish({ session: null, user: null, loading: false });
    });
  stop = () => {
    cancelled = true;
    subscription.unsubscribe();
  };
}

function subscribe(listener: () => void): () => void {
  listeners.add(listener);
  if (stopTimer) {
    clearTimeout(stopTimer);
    stopTimer = null;
  }
  if (!stop) start();
  return () => {
    listeners.delete(listener);
    if (listeners.size > 0 || stopTimer) return;
    stopTimer = setTimeout(() => {
      stopTimer = null;
      if (listeners.size === 0 && stop) {
        stop();
        stop = null;
      }
    }, 0);
  };
}

const readState = () => state;
// Le rendu serveur ne connaît pas la session (elle vit dans le navigateur), et l'hydratation doit
// rendre ce que le serveur a rendu : « je ne sais pas encore ».
const readServerState = () => LOADING;

export function useAuth(): AuthState {
  return useSyncExternalStore(subscribe, readState, readServerState);
}

/** Pour les tests : chaque cas repart d'une mémoire vide et sans abonnement. */
export function resetAuthStoreForTests(): void {
  if (stopTimer) clearTimeout(stopTimer);
  stopTimer = null;
  stop?.();
  stop = null;
  listeners.clear();
  state = LOADING;
}
