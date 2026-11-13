// CE QUE CET APPAREIL SAIT FAIRE POUR INSTALLER L'APPLICATION — étude 40, lot 3, R-13.
//
// Trois cas, et pas un de plus :
//
//   - `native` : Chromium (Android, bureau) a émis `beforeinstallprompt`, que
//                `install-signals.ts` a retenu à son passage. `promptInstall()` ouvre la
//                fenêtre du navigateur.
//   - `ios`    : Safari sur iPhone / iPad. Aucune interface programmable : l'installation se fait
//                à la main, en deux gestes (« Partager », puis « Sur l'écran d'accueil ») — la
//                carte les montre, sans bouton d'action.
//   - `none`   : tout le reste. Application déjà installée (R-11), navigateur intégré d'une
//                messagerie, autre navigateur iOS, bureau sans événement : on ne propose RIEN
//                plutôt qu'un geste qui ne marcherait pas.
//
// DEUX FICHIERS, UNE RAISON. L'écouteur doit être posé dès le chargement des coquilles (l'événement
// ne passe qu'une fois par page) : il vit dans `install-signals.ts`, le seul morceau
// qui entre dans le chunk d'entrée. Ce module-ci — la détection, la fenêtre — se charge avec la
// carte, c'est-à-dire avec un écran de résultat.
//
// Ce module ne retient rien sur l'appareil et n'émet rien : la mémoire des invitations est
// `nudge-memory.ts`, la mesure est dans la carte.

import {
  installCapture,
  isStandaloneDisplay,
  type InstallCapture,
  type StandaloneProbe,
} from "@/shared/lib/install-signals";

export type InstallMode = "native" | "ios" | "none";

/** Ce que la personne a répondu à la fenêtre du navigateur ; `unavailable` = pas de fenêtre à ouvrir. */
export type InstallOutcome = "accepted" | "dismissed" | "unavailable";

/** Ce que ce module lit d'une fenêtre — injectable, pour que chaque cas ait son test. */
export type InstallWindow = StandaloneProbe & {
  readonly navigator?: { readonly userAgent?: string; readonly maxTouchPoints?: number };
};

// Les autres navigateurs iOS et les navigateurs intégrés (réseaux sociaux, messageries) :
// leur menu n'a pas « Sur l'écran d'accueil », ou pas au même endroit.
const IOS_NOT_SAFARI =
  /CriOS|FxiOS|EdgiOS|OPiOS|OPT\/|GSA\/|DuckDuckGo|YaBrowser|FBAN|FBAV|FB_IAB|Instagram|Line\/|MicroMessenger|Snapchat|TikTok|musical_ly|WhatsApp|Twitter/;

/** Safari — le vrai — sur iPhone, iPod ou iPad (un iPad récent se présente comme un Mac tactile). */
export function isIosSafari(navigator: InstallWindow["navigator"]): boolean {
  const ua = navigator?.userAgent ?? "";
  const isIosDevice =
    /iPhone|iPad|iPod/.test(ua) || (/Macintosh/.test(ua) && (navigator?.maxTouchPoints ?? 0) > 1);
  // Safari signe « Version/x … Safari/y » ; une vue web intégrée n'a pas ce couple.
  return isIosDevice && /Version\/\S+.* Safari\//.test(ua) && !IOS_NOT_SAFARI.test(ua);
}

/** R-13 et R-11, en PUR : ce que cette fenêtre sait proposer, événement retenu ou non. */
export function installModeOf(
  win: InstallWindow | undefined,
  capture: InstallCapture,
): InstallMode {
  try {
    if (!win || isStandaloneDisplay(win)) return "none";
    if (capture.peek()) return "native";
    return isIosSafari(win.navigator) ? "ios" : "none";
  } catch {
    return "none";
  }
}

/**
 * Ouvre la fenêtre du navigateur avec l'événement retenu, qui ne sert qu'une fois. Ne lève jamais :
 * un événement sans `prompt()` ou une fenêtre refusée rendent `unavailable`.
 */
export async function promptWith(capture: InstallCapture): Promise<InstallOutcome> {
  const event = capture.peek();
  if (!event) return "unavailable";
  // Consommé avant d'ouvrir : accepté ou refusé, il n'ouvrira plus rien, et la carte se retire.
  capture.set(null);
  try {
    await event.prompt();
    const { outcome } = await event.userChoice;
    return outcome === "accepted" ? "accepted" : "dismissed";
  } catch {
    return "unavailable";
  }
}

const browserWindow = (): InstallWindow | undefined =>
  typeof window === "undefined" ? undefined : window;

/** Ce que CET appareil sait proposer maintenant. Au rendu serveur : `none`. */
export const getInstallMode = (): InstallMode => installModeOf(browserWindow(), installCapture);

/** Ouvre la fenêtre d'installation du navigateur (mode `native`). */
export const promptInstall = (): Promise<InstallOutcome> => promptWith(installCapture);

/** Prévient quand le mode peut avoir changé (événement reçu, consommé, application installée). */
export const subscribeInstallMode = (listener: () => void): (() => void) =>
  installCapture.subscribe(listener);
