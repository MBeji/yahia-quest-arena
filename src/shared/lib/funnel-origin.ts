// D'OÙ VENAIT LE VISITEUR QUI CRÉE UN COMPTE — en mémoire, jamais stocké.
//
// POURQUOI CE MODULE. Le tunnel « sans compte → compte » (étude 38) ne se lit que
// si l'événement d'inscription ou de connexion dit si la page d'avant était du
// CONTENU — un cours, un entraînement, un catalogue — ou autre chose : l'accueil,
// un lien direct. Avant lui, `signup` ne portait pas cette question, donc rien ne
// mesurait la fuite que l'étude répare, et ses indicateurs n'auraient eu aucun
// « avant » auquel se comparer.
//
// CE QU'IL NE FAIT PAS. Aucun stockage : une variable de module, qui meurt avec
// l'onglet — rien n'est écrit dans `localStorage`, rien n'est envoyé tel quel,
// l'appelant n'en tire qu'un booléen. Il ne survit pas non plus à un aller-retour
// chez Google (la page est rechargée) : sur ce chemin, l'appelant OMET le booléen
// de l'événement plutôt que d'y écrire `false`. « Inconnu » n'est pas « non ».
//
// Le lot 1 de l'étude 38 lira l'origine dans `returnTo`, qui voyage dans l'URL et
// survit au rechargement ; ce module aura alors dit ce qu'il en était AVANT.

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

/** La dernière page vue avant le tunnel était-elle du contenu public ? */
export function cameFromContent(): boolean {
  return lastPath !== null && CONTENT_PATH.test(lastPath);
}
