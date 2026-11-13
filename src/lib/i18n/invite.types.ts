/**
 * « INVITER MON PARENT » — étude 40, lot 5 (R-19). L'étude range ces chaînes sous `settings.*` ;
 * elles vivent ici, hors de `TranslationKeys`, comme `keep.types.ts` et `install.types.ts` et pour
 * la même raison mesurée : dans le catalogue de tout le monde, elles descendaient sur chaque page
 * publique (`perf:budget`, `/programme` au plafond de JavaScript). Elles se chargent avec le geste,
 * que seuls le paramétrage et l'écran de résultat connecté affichent.
 *
 * REGISTRE : l'élève est tutoyé ; ni argent, ni urgence, ni rareté (é40 R-21).
 */
export type InviteTranslations = {
  /** « Inviter mon parent » — le bouton du paramétrage et de la carte. */
  cta: string;
  /** R-19 — l'aide : ce lien ouvre le bilan, à n'envoyer qu'à son parent. */
  hint: string;
  /** Le message envoyé — un seul gabarit : {url}. */
  text: string;
  /** Confirmation quand le message a été COPIÉ (ni feuille de partage, ni WhatsApp). */
  copied: string;
  /** Titre de la carte de l'écran de résultat. */
  cardTitle: string;
  later: string;
};
