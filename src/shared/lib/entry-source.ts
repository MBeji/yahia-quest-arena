// PAR OÙ L'APPAREIL EST ENTRÉ — étude 40, lot 0, R-3.
//
// Deux faits, tous deux déduits de l'adresse et aussitôt réduits à une étiquette fermée :
//
//   - `entry`         : le canal qui a ramené la personne — `?src=pwa` (icône installée), `push`,
//                       `resume_link`, `share`. Le paramètre est LU PUIS RETIRÉ de l'adresse
//                       affichée : il ne doit ni se partager avec le lien, ni se recompter à un
//                       rechargement. Absent ou inconnu ⇒ `direct`.
//   - `entry_surface` : le GENRE de page d'arrivée (chapitre, exercice, accueil…), déduit du
//                       chemin. Jamais l'adresse, jamais l'identifiant du chapitre (R-4).
//
// Les lots suivants de l'étude 40 posent `?src=` sur leurs liens (lot 3 : `pwa` ; lot 4 : `share` ;
// lot 5 : `resume_link`) ; ce module sait déjà les lire, c'est ce qui permettra de les juger.
// Pur : l'adresse entre en argument, rien n'est importé.

/** R-3 — la liste fermée des sources d'entrée. */
export type EntrySource = "pwa" | "push" | "resume_link" | "share" | "direct";

/** R-3 — la liste fermée des surfaces d'arrivée. */
export type EntrySurface =
  | "chapitre"
  | "exercice"
  | "matiere"
  | "niveau"
  | "accueil"
  | "test"
  | "suivi"
  | "compte"
  | "autre";

/** Le paramètre d'adresse que ce module consomme. */
export const ENTRY_PARAM = "src";

const KNOWN_SOURCES: readonly EntrySource[] = ["pwa", "push", "resume_link", "share"];

/** La source lue dans la partie `?…` d'une adresse. Tout ce qui n'est pas de la liste est `direct`. */
export function readEntrySource(search: string): EntrySource {
  const value = new URLSearchParams(search).get(ENTRY_PARAM);
  return KNOWN_SOURCES.find((source) => source === value) ?? "direct";
}

/**
 * L'adresse relative (`chemin?reste#ancre`) débarrassée de `?src=`, ou `null` s'il n'y a rien à
 * retirer. Un `src` INCONNU est laissé en place : il n'est pas à nous.
 */
export function stripEntrySource(location: {
  pathname: string;
  search: string;
  hash: string;
}): string | null {
  if (readEntrySource(location.search) === "direct") return null;
  const params = new URLSearchParams(location.search);
  params.delete(ENTRY_PARAM);
  const rest = params.toString();
  return `${location.pathname}${rest ? `?${rest}` : ""}${location.hash}`;
}

/** Ce dont `consumeEntrySource` a besoin d'une fenêtre — injectable dans les tests. */
export type EntryWindow = {
  readonly location: { pathname: string; search: string; hash: string };
  readonly history: Pick<History, "replaceState" | "state">;
};

/**
 * Lit la source d'entrée et la retire de l'adresse affichée (`history.replaceState` natif, même
 * état : le routeur garde sa clé d'historique et n'y voit pas une navigation). Ne lève jamais — une adresse qu'on ne peut pas nettoyer
 * reste telle quelle, et la source est rendue quand même.
 */
export function consumeEntrySource(win: EntryWindow | undefined = browserWindow()): EntrySource {
  if (!win) return "direct";
  try {
    const source = readEntrySource(win.location.search);
    const cleaned = stripEntrySource(win.location);
    if (cleaned !== null) {
      try {
        win.history.replaceState(win.history.state, "", cleaned);
      } catch {
        // Historique verrouillé (iframe, navigateur embarqué) : l'adresse garde son paramètre.
      }
    }
    return source;
  } catch {
    return "direct";
  }
}

/**
 * La fenêtre du navigateur, avec le `replaceState` NATIF.
 *
 * ⚠️ Pas `window.history.replaceState` : le routeur l'a remplacé par le sien, qui re-résout la
 * page à chaque appel. Mesuré sur le bundle de production : retirer `?src=` par là émettait une
 * SECONDE page vue (`/?src=pwa` puis `/`) et rejouait le son de navigation. Retirer un paramètre
 * de mesure n'est pas une navigation — la méthode du prototype change l'adresse affichée et rien
 * d'autre ; l'état d'historique du routeur est repassé tel quel.
 */
function browserWindow(): EntryWindow | undefined {
  if (typeof window === "undefined") return undefined;
  return {
    location: window.location,
    history: {
      get state(): unknown {
        return window.history.state;
      },
      replaceState: (state, unused, url) =>
        History.prototype.replaceState.call(window.history, state, unused, url),
    },
  };
}

/** Le premier segment du chemin → le genre de page. Les routes connectées y ont leur équivalent. */
const SURFACE_BY_SEGMENT: Readonly<Record<string, EntrySurface>> = {
  chapitre: "chapitre",
  lesson: "chapitre",
  exercice: "exercice",
  quest: "exercice",
  matiere: "matiere",
  subject: "matiere",
  niveau: "niveau",
  programme: "niveau",
  "test-de-niveau": "test",
  suivi: "suivi",
  "parent-report": "suivi",
  auth: "compte",
  login: "compte",
  signup: "compte",
};

/** R-3 — le genre de la page d'arrivée, déduit du chemin. */
export function entrySurfaceFromPath(pathname: string): EntrySurface {
  const segment = pathname.split("/").find((part) => part.length > 0);
  if (segment === undefined) return "accueil";
  return SURFACE_BY_SEGMENT[segment] ?? "autre";
}
