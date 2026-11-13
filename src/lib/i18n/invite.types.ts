/**
 * « INVITER MON PARENT » — étude 40, lot 5. Hors de `TranslationKeys` avec ses valeurs
 * (`invite/{fr,en,ar}.ts`), comme `install.types.ts` et `keep.types.ts`, et pour la même raison
 * mesurée : rangées sous `settings.*`, ces chaînes descendaient dans `i18n-fr` sur CHAQUE page
 * publique (`/programme` à 263,1 Ko de JavaScript pour 263) pour un bouton du paramétrage et une
 * carte de l'écran de résultat. Elles se chargent avec eux.
 *
 * REGISTRE (docs/content-voice-and-composition.md) : l'élève est tutoyé ; le message envoyé au
 * parent ne porte ni prénom ni pseudo (é40 R-19).
 */
export type InviteTranslations = {
  /** Le bouton : au paramétrage (permanent) et sur la carte de l'écran de résultat. */
  button: string;
  /** L'aide : le lien ouvre le bilan, il ne s'envoie qu'au parent (R-19). */
  hint: string;
  /** Le message envoyé — gabarit de `parentInviteText` : {url}. */
  text: string;
  /** Confirmation quand le message a été COPIÉ (ni feuille de partage, ni WhatsApp). */
  copied: string;
  cardTitle: string;
  later: string;
};
