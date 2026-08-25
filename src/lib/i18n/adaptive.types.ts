/**
 * Tuteur déterministe (étude 30 lot 3) — clés de microcopy, dans leur propre fichier pour
 * la même raison que `duel.types.ts` et `tutor.types.ts` : garder `types.ts` sous le plafond
 * de lignes. Référencé là-bas comme `adaptive: AdaptiveTranslations`.
 *
 * ⚠️ LA RÈGLE QUI GOUVERNE CE FICHIER (§2.3) : le serveur rend un IDENTIFIANT, le client le
 * met en langue. `get_learning_state` renvoie `maitrisee` / `frontiere` / `inference` — des
 * clés, pas des phrases. Aucune phrase française n'entre en base, et la traduction d'un état
 * ne demande jamais une migration. C'est la posture de é04 A1.2b, tenue.
 *
 * ⚠️ ET CELLE QU'ON N'A PAS LE DROIT D'OUBLIER (D-1) : aucune de ces chaînes n'affiche une
 * PROBABILITÉ. L'élève lit « maîtrisée », « prouvé 4 fois sous 2 formes » — jamais « 0,97 ».
 * Une croyance affichée serait un score de plus, et le produit en a déjà un (l'EWMA de é07).
 */
export interface AdaptiveTranslations {
  /** Les quatre états + l'absence d'état (R-4/R-5). Ton élève, é15. */
  state: {
    maitrisee: string;
    "en-cours": string;
    fragile: string;
    lacune: string;
    inconnue: string;
  };
  /** Ce que chaque état veut dire, en une phrase — l'état seul ne suffit pas à agir. */
  stateHint: {
    maitrisee: string;
    "en-cours": string;
    fragile: string;
    lacune: string;
    inconnue: string;
  };
  /** Les trois zones du graphe (§3.4). `hors-portee` n'est PAS « interdit » (R-17). */
  zone: {
    interieur: string;
    frontiere: string;
    "hors-portee": string;
  };
  /** La carte à 4 états — le panneau qui remplace l'affichage en pourcentage. */
  mapTitle: string;
  mapSubtitle: string;
  mapEmpty: string;
  /** « prouvé {n} fois, sous {m} formes » — la preuve de R-4, montrée et non affirmée. */
  provenBy: string;
  /** Une croyance déduite, jamais gagnée : elle se dit, et elle se conteste (US-3). */
  inferredBadge: string;
  inferredExplain: string;
  disputeCta: string;
  disputePending: string;
  disputeDone: string;
  /** Une compétence marquée à sonder (R-8) — jamais présentée comme une sanction. */
  suspectBadge: string;

  /** « Prêt à apprendre » — la frontière, au plus trois cartes, jamais une liste. */
  frontierTitle: string;
  frontierSubtitle: string;
  frontierEmpty: string;
  /** « ouvre {n} suites » — le fan-out, le seul pari pédagogique explicite de l'étude. */
  frontierUnlocks: string;
  frontierUnlocksNone: string;
  frontierStartCta: string;
  /** Le hors-portée, dit sans interdire : on propose une remontée, on ne ferme pas la porte. */
  blockedNotice: string;
}
