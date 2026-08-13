import type { McqOptionRender } from "@/features/quest/components/question-input";

// =============================================================================
// Le vocabulaire du verdict par question (levier 01) : son type et l'apparence
// qu'il donne aux options. Module sans composant — `question-verdict.tsx` n'en
// exporte que, et le hook d'état a besoin du type sans tirer de JSX.
// =============================================================================

/**
 * Verdict d'UNE question rendu par la stratégie. `null` chez l'appelant signifie
 * « pas corrigible ici » (quiz, exercice hors catalogue admin) : le lecteur
 * enchaîne alors sans verdict, il n'échoue pas.
 */
export type QuestionVerdict = {
  questionId: string;
  isCorrect: boolean;
  /** Pour un QCM : l'ID de la bonne option. Sinon : la valeur attendue brute. */
  correctChoice: string | null;
  explanation: string | null;
};

/**
 * Apparence d'une option. Verdict affiché : la bonne passe au vert, la mauvaise
 * réponse donnée au rouge, le reste s'efface — plus aucun survol ni appui, la
 * liste n'est plus un contrôle mais une correction.
 */
export function optionClassNameFor(
  feedback: QuestionVerdict | null,
  bossMode: boolean,
  { option, isSelected }: McqOptionRender,
): string {
  if (feedback) {
    if (option.id === feedback.correctChoice) return "border-success bg-success/15 text-success";
    return isSelected
      ? "border-destructive bg-destructive/15 text-destructive"
      : "border-border/40 bg-surface-1 opacity-60";
  }
  return `active:scale-[0.97] ${
    isSelected
      ? bossMode
        ? "border-destructive bg-destructive/20"
        : "border-gold bg-gold/15"
      : bossMode
        ? "border-destructive/20 bg-surface-2 hover:border-destructive/60 hover:bg-destructive/10"
        : "border-border bg-surface-2 hover:border-gold/60 hover:bg-surface-3"
  }`;
}
