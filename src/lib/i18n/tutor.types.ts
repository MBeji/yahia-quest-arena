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

  /**
   * LA BIBLIOTHÈQUE DE COACHING (lot 2, US-5 / US-15) — R-10.
   *
   * Ces phrases ne sont PAS générées, et c'est une décision d'architecture, pas
   * une économie : « les phrases de coach quotidiennes viennent de la
   * bibliothèque ; seule la rédaction des bilans hebdo est générée ». Un élève
   * qui ouvre son tableau de bord chaque matin déclencherait sinon un appel de
   * modèle par jour et par item — pour dire « cinq minutes et c'est réglé ».
   *
   * Deux variantes par registre : trois items d'affilée ne disent pas la même
   * chose, et le choix tourne sur la POSITION (jamais sur un hasard, qui
   * changerait à chaque re-rendu).
   */
  coach: {
    /** Le nom qui signe la phrase, dans la langue de l'interface. */
    signature: string;
    /** Une misconception active vit dans ce chapitre : c'est ÇA qu'il faut dire. */
    weak1: string;
    weak2: string;
    /** Sept jours de retard ou plus : ce n'est plus « à revoir », ça part. */
    late1: string;
    late2: string;
    due1: string;
    due2: string;
    today1: string;
    today2: string;
    /** US-15 — les moments clés. Jamais culpabilisants (étude 15). */
    comeback1: string;
    comeback2: string;
    streak1: string;
    streak2: string;
    clear1: string;
    clear2: string;
    steady1: string;
    steady2: string;
  };

  /** US-7 — le rappel du plan du jour, armé par l'élève. */
  planPushTitle: string;
  planPushDesc: string;
}
