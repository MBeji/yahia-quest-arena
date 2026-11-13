/**
 * L'INVITATION À INSTALLER — étude 40, lot 3. Sortie de `TranslationKeys` avec ses valeurs
 * (`install/{fr,en,ar}.ts`).
 *
 * Même statut que `placement.types.ts`, et pour une raison mesurée : rangées dans le catalogue
 * app-wide, ces dix chaînes descendaient chez tout le monde (+0,2 Ko brotli par page) pour une
 * carte que seuls un écran de résultat et le bilan parent affichent — et `/programme` franchissait
 * son plafond de JavaScript de 0,1 Ko (`npm run perf:budget`). Elles se chargent donc avec la carte.
 *
 * REGISTRES (docs/content-voice-and-composition.md) : l'élève est tutoyé, le parent vouvoyé.
 * L'invitation dit le gain, jamais la perte.
 */
export type InstallTranslations = {
  studentTitle: string;
  studentBody: string;
  parentTitle: string;
  parentBody: string;
  cta: string;
  later: string;
  /** Safari iOS : l'annonce des deux gestes, puis le nom EXACT des deux entrées du menu de Safari. */
  iosHint: string;
  iosShare: string;
  iosAdd: string;
};
