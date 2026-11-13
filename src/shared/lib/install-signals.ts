// CE QUE LE NAVIGATEUR DIT DE L'INSTALLATION — deux signaux, et rien d'autre :
//
//   - `beforeinstallprompt` (étude 40, lot 3, R-13) : Chromium ne l'émet QU'UNE FOIS par page,
//     souvent bien avant l'écran de résultat qui s'en servira. Il est retenu ici à son passage ;
//     ce module est importé pour son effet par les deux coquilles (`_public.tsx`,
//     `_authenticated.tsx`).
//   - le mode d'affichage (étude 40, lot 0) : l'application tourne-t-elle installée, depuis son
//     icône d'écran d'accueil, plutôt que dans un onglet ?
//
// C'EST LE SEUL MORCEAU DE L'INVITATION À INSTALLER SUR LE CHEMIN DE TOUT LE MONDE : quelques
// lignes, aucun import. Ce que l'appareil sait faire et la fenêtre à ouvrir sont dans
// `install-prompt.ts`, chargé avec la carte.
//
// POURQUOI LE MODE D'AFFICHAGE EST ICI, et plus dans `entry-source.ts`. Deux chunks différés le
// lisent : la mesure du retour (`visit-beacon`) et la carte. Laissé dans `entry-source`, le
// bundler en faisait un chunk partagé — une requête de plus sur CHAQUE page, que le budget runtime
// compte une à une.

/** L'événement de Chromium — absent des types du DOM. */
export type InstallPromptEvent = Event & {
  prompt(): Promise<unknown>;
  readonly userChoice: Promise<{ readonly outcome: "accepted" | "dismissed" }>;
};

/** Ce que l'écouteur demande à une fenêtre — injectable dans les tests. */
export type CaptureWindow = {
  addEventListener(type: string, listener: (event: Event) => void): void;
};

export type InstallCapture = {
  /** L'événement retenu, ou `null`. */
  peek(): InstallPromptEvent | null;
  /** Remplace l'événement retenu (`null` : consommé) et prévient les abonnés. */
  set(event: InstallPromptEvent | null): void;
  /** Prévient quand l'événement arrive, est consommé, ou que l'application vient d'être installée. */
  subscribe(listener: () => void): () => void;
};

/**
 * Pose les deux écouteurs sur `win` et rend ce qu'ils retiennent. Une instance par fenêtre :
 * l'application n'en a qu'une (`installCapture`) ; les tests en créent.
 *
 * Volontairement nu — chaque octet d'ici est payé par toutes les pages : la forme de l'événement
 * est vérifiée par celui qui s'en sert (`promptWith`, chargé avec la carte), pas ici.
 */
export function createInstallCapture(win: CaptureWindow | undefined): InstallCapture {
  let deferred: InstallPromptEvent | null = null;
  const listeners = new Set<() => void>();
  const set = (event: InstallPromptEvent | null): void => {
    deferred = event;
    listeners.forEach((listener) => listener());
  };
  win?.addEventListener("beforeinstallprompt", (event) => {
    // Sans cela, Chrome Android affiche sa propre bannière à l'arrivée — R-11 : jamais à l'arrivée.
    event.preventDefault();
    set(event as InstallPromptEvent);
  });
  win?.addEventListener("appinstalled", () => set(null));
  return {
    peek: () => deferred,
    set,
    subscribe(listener) {
      listeners.add(listener);
      return () => listeners.delete(listener);
    },
  };
}

/**
 * L'instance de la page, écouteurs posés DÈS LE CHARGEMENT DU MODULE : l'événement ne repassera
 * pas. Au rendu serveur il n'y a pas de fenêtre : rien n'est jamais retenu.
 */
export const installCapture = createInstallCapture(
  typeof window === "undefined" ? undefined : window,
);

/** Ce que `isStandaloneDisplay` lit d'une fenêtre — injectable dans les tests. */
export type StandaloneProbe = {
  readonly matchMedia?: (query: string) => { matches: boolean };
  /** `navigator.standalone` n'existe que sur Safari iOS : il se lit sans le supposer typé. */
  readonly navigator?: object;
};

function browserProbe(): StandaloneProbe | undefined {
  return typeof window === "undefined" ? undefined : window;
}

/** L'application tourne-t-elle installée (icône d'écran d'accueil), plutôt que dans un onglet ? */
export function isStandaloneDisplay(win: StandaloneProbe | undefined = browserProbe()): boolean {
  try {
    if (!win) return false;
    if (win.matchMedia?.("(display-mode: standalone)").matches === true) return true;
    // Safari iOS ne connaît pas toujours la media query.
    const nav = win.navigator;
    return nav !== undefined && "standalone" in nav && nav.standalone === true;
  } catch {
    return false;
  }
}
