/**
 * Les plafonds du budget runtime (`check-budget.mjs`) — ce qu'une page publique a le droit
 * de faire télécharger et attendre à un téléphone, à cache froid.
 *
 * Mesuré le 2026-11-12 sur `main` (2dd1f8b), bundle de production servi en local, brotli
 * maximal, profil téléphone de `measure-pages.mjs` (150 ms de RTT, 1,6 Mbit/s, CPU ÷ 4) :
 *
 *   /            34 requêtes · 369,5 Ko transférés · 305,0 Ko de JS · HTML 7,2 Ko · LCP ≈ 1,0 s
 *   /programme   37 requêtes · 367,5 Ko transférés · 306,3 Ko de JS · HTML 3,9 Ko · LCP ≈ 0,95 s
 *
 * DEUX SORTES DE PLAFONDS, et il ne faut pas les confondre :
 *
 *   • Poids et requêtes — DÉTERMINISTES (trois passes, mêmes chiffres à l'octet). Marge
 *     d'environ 3 % : assez pour une PR ordinaire, pas assez pour une bibliothèque de plus
 *     sur le chemin de tout le monde. C'est ce plafond qui travaille au quotidien.
 *
 *   • LCP — dépend de la machine. Plafond à 2 000 ms, le double du réel : un runner de CI
 *     lent ne le franchit pas, mais un premier rendu qui se met à ATTENDRE le JavaScript
 *     (305 Ko à 1,6 Mbit/s = 1,5 s de téléchargement avant même l'hydratation) le franchit
 *     toujours. Il n'attrape que cette régression-là, et c'est la seule qu'on lui demande.
 *
 * CE QUE CES DEUX PAGES NE VOIENT PAS. Sans base en face, seules `/` et `/programme`
 * rendent ; les pages de cours, de matière et d'exercice ne sont pas mesurables ici. Leur
 * socle (chunk d'entrée, CSS, polices, bibliothèques partagées) est le même et il est
 * borné par ces plafonds ; leur contenu propre se mesure en production avec
 * `measure-pages.mjs` (docs/performance-audit.md §0-quater). `/programme` rend ici son
 * squelette : son LCP local borne le socle, pas la page pleine.
 *
 * RÈGLE — la même que `check-bundle-budget.mjs` : on ne relève pas un plafond pour faire
 * passer une PR. On cherche ce que la page s'est mise à charger (`--detail`), on le sort du
 * premier rendu, et un plafond ne monte qu'avec, ici même, la ligne qui dit pourquoi ce
 * poids ne pouvait pas être différé. Quand un lot ALLÈGE une page, on ramène son plafond
 * près du nouveau réel dans le même lot : une marge rendue n'est pas un crédit à dépenser.
 */

/** Chargements par page ; le budget se lit sur la médiane. */
export const LCP_RUNS = 5;

export const BUDGETS = {
  "/": { requests: 36, transferredKb: 380, jsKb: 314, htmlKb: 8.5, lcpMs: 2000 },
  "/programme": { requests: 39, transferredKb: 378, jsKb: 315, htmlKb: 5, lcpMs: 2000 },
};
