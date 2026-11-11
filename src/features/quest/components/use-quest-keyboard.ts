import { useEffect } from "react";

/**
 * Raccourcis clavier du lecteur : Entrée / Espace valide (ou enchaîne après un
 * verdict), 1-4 et A-D sélectionnent une option. Extrait du lecteur tel quel,
 * même geste que `use-exercise-session` — le lecteur garde ce qui le regarde
 * (quand valider, quand avancer), le hook tient la mécanique.
 *
 * Pas de tableau de dépendances, à dessein : l'effet se réabonne à chaque rendu
 * et lit donc toujours l'état courant. C'est exactement ce que faisait l'effet
 * en place ; un tableau incomplet rendrait des raccourcis périmés.
 */
export function useQuestKeyboard({
  active,
  feedbackShown,
  options,
  onContinue,
  onValidate,
  onSelect,
}: {
  /** Faux sur l'écran de résultat : plus rien à piloter au clavier. */
  active: boolean;
  /** Un verdict est à l'écran : la seule touche qui agit est celle qui enchaîne. */
  feedbackShown: boolean;
  /** Les options de la question courante, dans l'ordre affiché. */
  options: ReadonlyArray<{ id: string }>;
  onContinue: () => void;
  onValidate: () => void;
  onSelect: (optionId: string) => void;
}): void {
  useEffect(() => {
    if (!active) return;
    function handleKeyDown(e: KeyboardEvent) {
      if (e.target instanceof HTMLInputElement || e.target instanceof HTMLTextAreaElement) return;
      // Verdict à l'écran : la seule touche qui agit est celle qui enchaîne. Les
      // raccourcis de sélection sont muets — la réponse est déjà figée.
      if (feedbackShown) {
        if (e.key === "Enter" || e.key === " ") {
          e.preventDefault();
          onContinue();
        }
        return;
      }
      if (e.key === "Enter" || e.key === " ") {
        e.preventDefault();
        onValidate();
        return;
      }
      const num = parseInt(e.key, 10);
      if (num >= 1 && num <= options.length) {
        e.preventDefault();
        onSelect(options[num - 1].id);
        return;
      }
      const letterIdx = "abcd".indexOf(e.key.toLowerCase());
      if (letterIdx >= 0 && letterIdx < options.length) {
        e.preventDefault();
        onSelect(options[letterIdx].id);
      }
    }
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  });
}
