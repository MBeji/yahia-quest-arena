import type { GuideScreenKey } from "@/lib/i18n/guide.types";

/**
 * LE REGISTRE DES ÉCRANS — ce que la navigation doit savoir d'une page, écrit UNE fois (audit de
 * navigation du 2026-11-21, § 6 A-1 · lot 5).
 *
 * Ces règles vivaient dans cinq listes de chemins parallèles, qui avaient déjà divergé : les écrans
 * sans barre d'onglets (deux expressions), ceux où la bulle IA se tait (une troisième, qui couvrait
 * par erreur la LISTE des examens), la fiche d'aide de chaque écran (dix expressions), et deux
 * définitions du tunnel de connexion (l'une ignorait la casse, l'autre non).
 *
 * Une entrée par premier segment d'adresse — `quest` pour `/quest/$id`, `""` pour l'accueil.
 * `registre-des-ecrans.test.ts` compare ces clés aux fichiers du routeur : une page ajoutée sans
 * son entrée fait échouer le gate. Une entrée vide est une décision : « rien de particulier ».
 *
 * `Portee` : `"segment"` vaut pour `/x` et tout ce qui est dessous ; `"enfant"` pour `/x/…`
 * seulement — `/examens` est la liste, `/examen/$id` la passation.
 */
type Portee = "segment" | "enfant";

export type Ecran = {
  /** Écran de jeu ou d'épreuve : pas de barre d'onglets, qui recouvrirait son bouton du bas. */
  readonly immersif?: Portee;
  /** Épreuve notée ou tunnel : la bulle IA se tait (l'inviter au milieu d'un donjon, c'est tricher). */
  readonly bulleMuette?: Portee;
  /** Page de CONTENU public : ce qu'un visiteur lit ou pratique avant de songer à un compte. */
  readonly contenu?: Portee;
  /** Le tunnel de connexion lui-même : on n'y « revient » pas, on ne le retient pas. */
  readonly tunnel?: true;
  /**
   * Écran d'ÉLÈVE : un parent n'a ni profil de jeu ni parcours, il est renvoyé à son Suivi
   * (audit de navigation du 2026-11-21, N-8). Un admin garde tout.
   */
  readonly eleve?: true;
  /** La fiche d'aide de l'écran ; `aidePortee` par défaut : `"segment"`. */
  readonly aide?: GuideScreenKey;
  readonly aidePortee?: Portee;
};

export const ECRANS: Readonly<Record<string, Ecran>> = {
  // Coquille publique
  "": {},
  programme: { aide: "programme", contenu: "segment" },
  extras: { aide: "programme", contenu: "segment" },
  niveau: { aide: "programme", contenu: "enfant" },
  matiere: { aide: "subject", aidePortee: "enfant", contenu: "enfant" },
  chapitre: { aide: "lesson", aidePortee: "enfant", contenu: "enfant" },
  exercice: { aide: "quest", aidePortee: "enfant", contenu: "enfant", immersif: "enfant" },
  "test-de-niveau": { immersif: "enfant" },
  suivi: { aide: "suivi" },
  conditions: {},
  confidentialite: {},
  // Tunnel de compte
  auth: { tunnel: true },
  login: { tunnel: true },
  signup: { tunnel: true },
  // Coquille connectée
  dashboard: { aide: "dashboard", eleve: true },
  parcours: { aide: "parcours", eleve: true },
  arene: { aide: "arena", eleve: true },
  // Le hall du donjon et un duel gardent leurs onglets (étude 15, D-4) ; la bulle s'y tait.
  dungeon: { aide: "arena", bulleMuette: "segment", eleve: true },
  duel: { aide: "arena", bulleMuette: "segment", eleve: true },
  leaderboard: { aide: "arena", eleve: true },
  examens: { eleve: true },
  // « Mon bilan » : le bilan et le programme du jour de l'élève (commande du 2026-11-22).
  bilan: { eleve: true },
  examen: { immersif: "enfant", bulleMuette: "enfant", eleve: true },
  quest: {
    aide: "quest",
    aidePortee: "enfant",
    immersif: "segment",
    bulleMuette: "segment",
    eleve: true,
  },
  onboarding: { immersif: "segment", bulleMuette: "segment", eleve: true },
  boutique: { eleve: true },
  forge: { eleve: true },
  parametrage: { aide: "settings" },
  "parent-report": { aide: "parent" },
  console: {},
  admin: {},
  // Anciennes adresses, redirigées (301) vers leur page publique.
  themes: { aide: "programme" },
  subject: { aide: "subject", aidePortee: "enfant" },
  lesson: { aide: "lesson", aidePortee: "enfant", immersif: "segment" },
};

/**
 * Le premier segment d'une adresse, en minuscules (le routeur apparie `/Quest` comme `/quest`), et
 * s'il est suivi d'un enfant. Requête et fragment sont ignorés.
 */
function lire(chemin: string): { ecran: Ecran | undefined; enfant: boolean } {
  const m = /^\/([^/?#]*)(\/[^?#]*)?/.exec(chemin);
  if (!m) return { ecran: undefined, enfant: false };
  return { ecran: ECRANS[m[1].toLowerCase()], enfant: m[2] !== undefined };
}

function vaut(portee: Portee | undefined, enfant: boolean): boolean {
  return portee === "segment" || (portee === "enfant" && enfant);
}

/** Pas de barre d'onglets : l'élève joue ou passe une épreuve. */
export function isImmersivePath(chemin: string): boolean {
  const { ecran, enfant } = lire(chemin);
  return vaut(ecran?.immersif, enfant);
}

/** La bulle IA se tait. */
export function isAiSilentPath(chemin: string): boolean {
  const { ecran, enfant } = lire(chemin);
  return vaut(ecran?.bulleMuette, enfant);
}

/** Une page de contenu public. */
export function isContentPath(chemin: string): boolean {
  const { ecran, enfant } = lire(chemin);
  return vaut(ecran?.contenu, enfant);
}

/** Le tunnel de connexion (`/auth`, `/login`, `/signup`), quelle que soit la casse. */
export function isFunnelPath(chemin: string): boolean {
  return lire(chemin).ecran?.tunnel === true;
}

/** Un écran d'élève, dont un parent est renvoyé à son Suivi. */
export function isStudentOnlyPath(chemin: string): boolean {
  return lire(chemin).ecran?.eleve === true;
}

/** La fiche d'aide de l'écran, ou la fiche générale. */
export function guideScreenForPath(chemin: string): GuideScreenKey {
  const { ecran, enfant } = lire(chemin);
  if (!ecran?.aide) return "general";
  return vaut(ecran.aidePortee ?? "segment", enfant) ? ecran.aide : "general";
}
