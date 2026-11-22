/**
 * Le GUIDE INTÉGRÉ — sa logique pure (2026-10-19).
 *
 * Deux questions, tranchées ici une fois pour tous les écrans (la fiche d'aide de l'écran
 * affiché, elle, est déclarée dans le registre des écrans, `screens.ts`) :
 *   - où en est l'élève dans les 3 étapes d'un chapitre (`chapterSteps`) ;
 *   - ce que l'appareil a retenu → `guide-storage.ts`, à part : le provider racine
 *     n'a besoin que de lui, et ce module-ci reste hors du chunk index.
 */

export type StepState = "done" | "current" | "next" | "locked";

export interface ChapterStepStates {
  lesson: StepState;
  quiz: StepState;
  missions: StepState;
}

/** Un chapitre dont la porte est encore fermée : le cours d'abord, le quiz ensuite. */
export const LOCKED_CHAPTER_STEPS: ChapterStepStates = {
  lesson: "current",
  quiz: "next",
  missions: "locked",
};

/**
 * Les 3 étapes d'un chapitre, telles que l'élève doit les lire.
 *
 * `null` quand le chapitre n'a pas de porte (pas de quiz, ou thème hors école) :
 * ses missions sont ouvertes d'emblée, et afficher un parcours « cours → quiz →
 * missions » y serait faux.
 *
 * La lecture du cours n'est pas suivie par le serveur : tant que la porte est
 * fermée, le cours est l'étape « à faire maintenant » ; une fois le quiz réussi,
 * la compréhension est prouvée et les deux premières étapes sont « faites ».
 */
export function chapterSteps({
  gated,
  cleared,
}: {
  gated: boolean;
  cleared: boolean;
}): ChapterStepStates | null {
  if (!gated) return null;
  if (cleared) return { lesson: "done", quiz: "done", missions: "current" };
  return LOCKED_CHAPTER_STEPS;
}

/** Remplace les `{clé}` d'une microcopy — le guide en a plusieurs par phrase. */
export function fillGuideText(text: string, values: Record<string, string | number>): string {
  return text.replace(/\{(\w+)\}/g, (match, key: string) =>
    key in values ? String(values[key]) : match,
  );
}
