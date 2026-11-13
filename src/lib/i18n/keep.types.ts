/**
 * « GARDER CE CHAPITRE » — étude 40, lot 4. Sorti de `TranslationKeys` avec ses valeurs
 * (`keep/{fr,en,ar}.ts`), comme `install.types.ts` et pour la même raison mesurée : rangées dans
 * le catalogue de tout le monde, ces chaînes descendraient sur chaque page pour une rangée que
 * seuls un écran de résultat et le bas d'un cours affichent. Elles se chargent avec la rangée.
 *
 * REGISTRE (docs/content-voice-and-composition.md) : l'élève est tutoyé ; l'invitation dit le
 * gain, jamais la perte ; aucun texte ne compare un élève à un autre (é40 R-17).
 */
export type KeepTranslations = {
  title: string;
  /** Écran de résultat : s'envoyer la suite. */
  sendNext: string;
  /** Bas d'un cours : s'envoyer ce cours. */
  sendLesson: string;
  shareSuccess: string;
  /** Confirmation quand le texte a été COPIÉ (ni feuille de partage, ni WhatsApp). */
  copied: string;
  /** Le texte envoyé — gabarits de `fillShareTemplate` : {chapter} {subject} {correct} {total} {url}. */
  resumeText: string;
  successText: string;
};
