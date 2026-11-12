/**
 * « Plus tard » sur la carte de classe de la quête (étude 38, lot 2 — R-5).
 *
 * La carte se ferme pour la SESSION DE NAVIGATION : `sessionStorage`, donc l'onglet.
 * Un élève qui a dit « plus tard » ne la revoit pas à chaque quête de sa séance ;
 * elle revient à sa prochaine visite, tant qu'il n'a pas de classe. Rien n'atteint
 * le serveur : différer n'est pas une décision à enregistrer.
 *
 * Stockage absent ou refusé (navigation privée, iframe) : la carte reste montrable
 * et « plus tard » ne vaut que pour l'écran en cours — le sens sûr, jamais une erreur.
 */
const KEY = "xp-scholars-quickpick-later";

export function hasPostponedQuickPick(): boolean {
  try {
    return window.sessionStorage.getItem(KEY) === "1";
  } catch {
    return false;
  }
}

export function postponeQuickPick(): void {
  try {
    window.sessionStorage.setItem(KEY, "1");
  } catch {
    // Pas de stockage : la carte se ferme quand même pour cet écran (état React).
  }
}
