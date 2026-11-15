/**
 * Les écrans IMMERSIFS : ceux où l'élève joue ou passe une épreuve, et où la barre d'onglets
 * du bas n'a pas sa place — elle recouvrirait un bouton collé en bas d'écran (« Valider »,
 * la barre de rendu d'un examen) et offrirait quatre sorties au milieu d'une question.
 *
 * Deux coquilles, deux listes, un seul endroit pour les lire : la règle était écrite en ligne
 * dans la coquille connectée, et la coquille publique en a besoin depuis qu'elle porte aussi
 * la barre d'onglets d'un élève connecté (2026-11-15).
 */

/**
 * Coquille connectée. `examen/` porte sa barre oblique à dessein : seule la PASSATION
 * (`/examen/$examId`) est immersive — sans elle, `/examens`, la liste, perdrait ses onglets.
 * Le hall du donjon et un duel gardent les leurs (étude 15, D-4).
 */
export function isImmersiveAppPath(pathname: string): boolean {
  return /^\/(quest|lesson|onboarding|examen\/)/.test(pathname);
}

/**
 * Coquille publique. Le lecteur d'entraînement (`/exercice/$id`) et la passation du test de
 * niveau (`/test-de-niveau/$session`) — même raison que `examen/` pour la barre oblique :
 * `/test-de-niveau`, l'entrée où l'on choisit sa classe, garde la navigation.
 */
export function isImmersivePublicPath(pathname: string): boolean {
  return /^\/(exercice|test-de-niveau)\//.test(pathname);
}
