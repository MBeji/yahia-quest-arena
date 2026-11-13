/**
 * Les plafonds du budget runtime (`check-budget.mjs`) — ce qu'une page publique a le droit
 * de faire télécharger et attendre à un téléphone, à cache froid.
 *
 * Mesuré le 2026-11-12, bundle de production servi en local, brotli maximal, profil
 * téléphone de `measure-pages.mjs` (150 ms de RTT, 1,6 Mbit/s, CPU ÷ 4) :
 *
 *   /            35 requêtes · 319,0 Ko transférés · 254,2 Ko de JS · HTML 7,3 Ko · LCP ≈ 1,0 s
 *   /programme   38 requêtes · 317,1 Ko transférés · 255,5 Ko de JS · HTML 4,1 Ko · LCP ≈ 0,98 s
 *
 * Comment on en est arrivé là, le même jour (le budget n'a été posé qu'une fois, ici) :
 *   `main` 2dd1f8b, avant tout lot      `/` 34 req · 369,5 Ko · 305,0 Ko de JS
 *   `react` sorti de `vendor-dndkit`    `/` 33 req · 315,8 Ko · 251,3 Ko de JS
 *   moteur de son au premier geste      `/` 33 req · 314,8 Ko · 250,3 Ko de JS
 *   `main` c17d5d5 (dix PR plus tard)   `/` 35 req · 319,0 Ko · 254,2 Ko de JS  ← plafonds
 *
 * DEUX SORTES DE PLAFONDS, et il ne faut pas les confondre :
 *
 *   • Poids et requêtes — DÉTERMINISTES (trois passes, mêmes chiffres à l'octet). Marge
 *     d'environ 3 % : assez pour une PR ordinaire, pas assez pour une bibliothèque de plus
 *     sur le chemin de tout le monde. C'est ce plafond qui travaille au quotidien.
 *
 *   • LCP — dépend de la machine. Plafond à 2 000 ms, le double du réel : un runner de CI
 *     lent ne le franchit pas, mais un premier rendu qui se met à ATTENDRE le JavaScript
 *     (254 Ko à 1,6 Mbit/s = 1,3 s de téléchargement avant même l'hydratation) le franchit
 *     toujours. Il n'attrape que cette régression-là, et c'est la seule qu'on lui demande.
 *
 * CE QUE CES DEUX PAGES NE VOIENT PAS. Sans base en face, seules `/` et `/programme`
 * rendent ; les pages de cours, de matière et d'exercice ne sont pas mesurables ici. Leur
 * socle (chunk d'entrée, CSS, polices, bibliothèques partagées) est le même et il est
 * borné par ces plafonds ; leur contenu propre se mesure en production avec
 * `measure-pages.mjs` (docs/performance-audit.md §0-quater). `/programme` lit la base
 * au rendu serveur depuis #1266 : ici la base factice répond une erreur immédiate, la page
 * rend son squelette — son LCP local borne le socle, pas la page pleine.
 *
 * RÈGLE — la même que `check-bundle-budget.mjs` : on ne relève pas un plafond pour faire
 * passer une PR. On cherche ce que la page s'est mise à charger (`--detail`), on le sort du
 * premier rendu, et un plafond ne monte qu'avec, ici même, la ligne qui dit pourquoi ce
 * poids ne pouvait pas être différé. Quand un lot ALLÈGE une page, on ramène son plafond
 * près du nouveau réel dans le même lot : une marge rendue n'est pas un crédit à dépenser.
 *
 * PLAFONDS RELEVÉS, chacun avec sa ligne :
 *
 *   • 2026-11-12, étude 40 lot 0 — `/programme` : 40 → 41 requêtes. `main` (eca2a89) était à
 *     40/40 avant ce lot. La requête de plus est `visit-beacon` (3,4 Ko bruts) : la mesure du
 *     retour (« première visite » / « revenu un autre jour »), chargée par `import()` APRÈS
 *     l'hydratation — elle est déjà hors du premier rendu, c'est le décompte qui ne distingue pas.
 *     Ce qui a été fait pour ne pas en ajouter deux : le jour de Tunis est calculé par la racine
 *     (sinon `app-day` devenait un chunk partagé de plus). Ce qui a été écarté : l'inliner dans le
 *     chunk d'entrée (+3,4 Ko sur un budget à 3 Ko de sa limite, et sur le chemin de tout le
 *     monde), ou le loger de force dans un chunk voisin par une règle de découpage (les groupes
 *     emportent leurs dépendances : c'est le cycle `index` ⇄ chunk que `vite.config.ts` raconte).
 *     `/` reste à 37 (36 mesurées). Poids : inchangés, aucun plafond d'octets ne bouge.
 *
 *   • 2026-11-13, étude 40 lot 5 — `/programme` : 263 → 263,5 Ko de JavaScript. `main` (a1384de)
 *     était à 262,9/263. Le poids de plus (+195 octets brotli) est dans le chunk d'ENTRÉE et n'est
 *     pas du code : c'est la table de préchargement de Vite (`__vite__mapDeps`), qui nomme chaque
 *     chunk qu'une route paresseuse peut tirer. « Inviter mon parent » vit sur deux routes (le
 *     paramétrage, l'écran de résultat de la quête) : ses modules forment un chunk partagé, et son
 *     nom entre dans la table — par construction, aucun `import()` ne la diffère. Ce qui a été fait
 *     d'abord : `parent-invite.ts` n'importe plus que le TYPE d'`entry-source` (la valeur en faisait
 *     un chunk de plus sur chaque page : 42 requêtes pour 41, −1 requête) ; les chaînes ont quitté
 *     `i18n-fr` pour un catalogue chargé avec le bouton et la carte (`i18n/invite`, −0,2 Ko). Ce qui
 *     a été écarté : loger ces modules dans un chunk voisin par une règle de découpage (même raison
 *     qu'au lot 0) ; dupliquer le geste dans les deux routes (dette). `/` : 257,9/262, inchangé.
 */

/** Chargements par page ; le budget se lit sur la médiane. */
export const LCP_RUNS = 5;

export const BUDGETS = {
  "/": { requests: 37, transferredKb: 328, jsKb: 262, htmlKb: 8.5, lcpMs: 2000 },
  "/programme": { requests: 41, transferredKb: 327, jsKb: 263.5, htmlKb: 5, lcpMs: 2000 },
};
