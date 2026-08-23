// La NOTATION qu'une sortie de modèle doit respecter — une seule vérité.
//
// POURQUOI CE FICHIER EXISTE
// ---------------------------------------------------------------------------
// Ces trois règles étaient nées privées dans `features/ai/forge/filters.ts`
// (étude 29 lot 4), pour des QCM. L'étude 11 lot 1 en a besoin sur de la PROSE :
// une explication rendue à un élève est soumise aux mêmes contraintes qu'une
// question — c'est le même lecteur, le même manuel, le même renderer.
//
// Les recopier aurait créé deux vérités sur la notation, et la seconde aurait
// dérivé le jour où l'une des deux surfaces corrige un cas limite. Elles vivent
// donc ici, et la Forge comme le tuteur les importent.
//
// Source normative : `content-engine/references/math-and-notation.md`, injectée
// dans les prompts système (é11 R-3) — ce fichier en est le contrôle a posteriori.

/**
 * Chiffres NON occidentaux. `math-and-notation.md` impose 0-9 partout, y compris
 * en arabe : un élève tunisien lit ٤ dans un manuel et 4 dans une calculatrice,
 * et mélanger les deux dans un même écran est une charge gratuite.
 */
export const NON_WESTERN_DIGITS = /[٠-٩۰-۹]/;

/** LaTeX : le lecteur ne le rend pas — l'élève verrait `\frac{1}{2}` en clair. */
export const LATEX = /(\\[a-zA-Z]+\s*\{)|(\$\$?[^$]+\$\$?)/;

/** Aucune URL dans une sortie de modèle (RISK-6 : une adresse inventée est un piège). */
export const URL_LIKE = /(https?:\/\/)|(\bwww\.)/i;

/**
 * Du HTML dans une sortie destinée au pipeline markdown. `@/shared/lib/markdown`
 * l'assainit au rendu, donc rien ne casse — mais une balise qui arrive jusque-là
 * signale un prompt mal suivi, et on préfère le rebut à l'affichage d'un modèle
 * qui n'écoute pas ses instructions.
 */
export const HTML_TAG = /<\/?(?:script|style|iframe|img|a|div|span|p|br)\b/i;

/** Les trois règles de notation, en un geste. `true` ⇒ la sortie est à rejeter. */
export function violatesNotation(text: string): boolean {
  return NON_WESTERN_DIGITS.test(text) || LATEX.test(text) || URL_LIKE.test(text);
}
