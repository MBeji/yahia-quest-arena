/**
 * Tuteur « El Ostedh » (étude 11 lot 1) — clés de microcopy, dans leur propre
 * fichier pour la même raison que `duel.types.ts` : garder `types.ts` sous le
 * plafond de lignes. Référencé là-bas comme `tutor: TutorTranslations`.
 *
 * ⚠️ R-4 : cette microcopy suit le ton élève UNIQUE de l'étude 15 (tutoiement,
 * dès 8 ans) et la langue de l'INTERFACE. Le contenu pédagogique généré, lui,
 * est calibré par bande d'âge et rendu dans la langue de la MATIÈRE. Les deux
 * ne se confondent pas — c'est la règle « chrome-UI vs langue-contenu ».
 */
export interface TutorTranslations {
  /** Le bouton, sur une question ratée de l'écran de correction. */
  ask: string;
  panelTitle: string;
  thinking: string;
  /** « Explique autrement » — le registre suivant (R-7). */
  again: string;
  /** Quand les trois registres sont épuisés. */
  againExhausted: string;
  gotIt: string;
  helpful: string;
  notHelpful: string;
  rated: string;
  close: string;
  /** Servi depuis le pot commun : aucune énergie dépensée (R-15.2). */
  fromCache: string;
  /**
   * Les états dégradés (R-15). Jamais une erreur brute : un enfant lit
   * « El Ostedh revient demain », pas un code fournisseur.
   */
  offTitle: string;
  offBody: string;
  noEnergyTitle: string;
  noEnergyBody: string;
  pausedTitle: string;
  pausedBody: string;
  /** R-1 — les refus de la porte, dits en langage d'élève. */
  lockedSession: string;
  lockedDungeon: string;
  lockedDuel: string;
  lockedNotAttempted: string;
}
