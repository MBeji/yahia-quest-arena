// D'OÙ VENAIT LE VISITEUR QUI CRÉE UN COMPTE — le retour gardé d'abord, la dernière page ensuite.
//
// POURQUOI CE MODULE. Le tunnel « sans compte → compte » (étude 38) ne se lit que si l'événement
// d'inscription ou de connexion dit si le visiteur venait du CONTENU — un cours, un entraînement,
// un catalogue — ou d'ailleurs : l'accueil, un lien direct. Avant lui, `signup` ne portait pas cette
// question, donc rien ne mesurait la fuite que l'étude répare, et ses indicateurs n'auraient eu aucun
// « avant » auquel se comparer.
//
// DEUX SOURCES, DANS CET ORDRE. (1) Le retour gardé (`return-to.ts`, lot 1) : c'est l'endroit où l'on
// RAMÈNERA le visiteur, et il survit au rechargement — l'aller-retour chez Google, le lien de
// confirmation d'e-mail. (2) À défaut, la dernière page vue, tenue ici en mémoire : une variable de
// module, qui meurt avec l'onglet, jamais écrite nulle part. Le lot 0 de l'étude n'avait que (2) ;
// c'est pourquoi le retour de Google, rechargé, n'y portait alors pas `from_content`.

/** Pages de CONTENU public : ce qu'un visiteur lit ou pratique avant de songer à un compte. */
const CONTENT_PATH =
  /^\/(?:(?:chapitre|matiere|exercice|niveau)\/|(?:programme|extras)(?:[/?#]|$))/;

/** Le tunnel lui-même : le traverser ne doit pas effacer la page d'où l'on venait. */
const FUNNEL_PATH = /^\/(?:auth|login|signup)(?:[/?#]|$)/;

let lastPath: string | null = null;

/** Retient la page qui vient de s'afficher — sauf le tunnel (auth, login, signup). */
export function notePageForFunnel(path: string): void {
  if (FUNNEL_PATH.test(path)) return;
  lastPath = path;
}

/**
 * Le visiteur venait-il du contenu ? `returnTo` est le retour gardé s'il y en a un (il répond d'abord :
 * c'est là qu'on le ramène), sinon `null` et c'est la dernière page vue qui répond.
 */
export function isFromContent(returnTo: string | null): boolean {
  if (returnTo !== null) return CONTENT_PATH.test(returnTo);
  return lastPath !== null && CONTENT_PATH.test(lastPath);
}
