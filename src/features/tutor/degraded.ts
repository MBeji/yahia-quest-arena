// R-15 — LES ÉTATS DÉGRADÉS, et le seul endroit qui tranche « définitif » ou non.
//
// Même raison d'être que `./locked`, un cran plus loin dans la chaîne : la porte
// franchie, l'appel peut encore échouer, et les deux écrans qui l'affichent — la
// correction d'une question et le chat d'un chapitre — doivent la MÊME phrase au
// même code. Deux copies auraient divergé au premier code ajouté.
//
// CE QUE CETTE TABLE SÉPARE, ET POURQUOI ÇA COMPTE
// ---------------------------------------------------------------------------
// Jusqu'ici, tout échec d'appel finissait sur « Il ne répond pas pour l'instant.
// Réessaie dans un moment. » — le repli de `pausedBody`. C'est vrai d'un 5xx ou
// d'un timeout ; c'est FAUX, et c'est un mauvais conseil, quand la clé de la
// famille est refusée ou que le compte du fournisseur n'a plus de crédit :
// réessayer ne peut rien y changer, et l'enfant réessaie quand même — en
// dépensant son énergie du jour à chaque fois.
//
// Ces codes-là ont ceci de commun qu'ils se lèvent AILLEURS, dans les Réglages,
// par la personne qui a attaché la clé. L'écran de l'élève ne doit donc ni les
// nommer (R-5 : aucun détail de fournisseur sous les yeux d'un enfant) ni les
// taire : il désigne la personne qui peut agir, exactement comme `offBody` le
// fait déjà pour le mode IA éteint.

/** Les codes qu'un enfant ne peut pas lever, et qu'un nouvel essai ne lève pas. */
const KEY_HOLDER_FAULTS: ReadonlySet<string> = new Set([
  /** La clé est refusée par le fournisseur (401/403). Elle le restera. */
  "AI_KEY_INVALID",
  /** Le compte du fournisseur n'a plus de crédit. */
  "AI_CREDIT_EXHAUSTED",
  /** Le modèle configuré n'existe pas chez ce fournisseur. */
  "AI_MODEL_UNKNOWN",
  /** L'adresse est recalée par une des sept conditions de sortie de R-6. */
  "AI_HOST_NOT_ALLOWED",
]);

/**
 * Cet échec appelle-t-il le porteur de la clé, plutôt qu'un nouvel essai ?
 *
 * `false` pour tout le reste — y compris un code inconnu. C'est le bon défaut :
 * « réessaie dans un moment » ne coûte qu'un essai, alors qu'envoyer un enfant
 * chercher ses parents pour une panne passagère les dérange pour rien.
 */
export function isKeyHolderFault(code: string): boolean {
  return KEY_HOLDER_FAULTS.has(code);
}
