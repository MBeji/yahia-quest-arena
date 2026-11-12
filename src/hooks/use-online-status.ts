import { useSyncExternalStore } from "react";
import { onlineManager } from "@tanstack/react-query";

const subscribe = (onChange: () => void) => onlineManager.subscribe(onChange);
const isOnline = () => onlineManager.isOnline();
// Le serveur n'a pas de réseau à lire : il rend « en ligne », et l'hydratation aussi.
const onlineOnServer = () => true;

/**
 * L'état du réseau, tel que TanStack Query le lit (étude 38, D-4).
 *
 * UNE source, pas deux : `onlineManager` est ce qui met les requêtes en pause. Un
 * écouteur `online`/`offline` maison donnerait une seconde vérité, et le bandeau
 * pourrait dire « hors connexion » pendant que l'écran charge — ou l'inverse. Ici,
 * le bandeau ne peut pas dire autre chose que ce que l'écran fait.
 */
export function useOnlineStatus(): boolean {
  return useSyncExternalStore(subscribe, isOnline, onlineOnServer);
}
