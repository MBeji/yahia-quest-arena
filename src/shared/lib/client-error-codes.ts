// LES CODES D'ERREUR STABLES qu'une fonction serveur lève et que le client traduit.
//
// Seul le MESSAGE d'une `Error` traverse la frontière d'une fonction serveur
// (`safe-error.ts`). Une phrase en français dans un `throw` arrive donc telle quelle
// devant un élève qui lit l'arabe ; un code, lui, se traduit à l'écran
// (`error-message.ts`). Ce fichier n'importe rien, à dessein : le serveur et le
// client le lisent tous les deux, sans rien tirer l'un de l'autre.

/** Refus du limiteur de débit : trop d'appels sur la fenêtre (étude 38, R-15). */
export const RATE_LIMITED_CODE = "RATE_LIMITED";
