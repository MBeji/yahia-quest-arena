import { useMemo } from "react";
import { isolateLtrRuns } from "@/shared/lib/bidi";
import { shuffleOptions, type BaseOption, type DisplayOption } from "@/shared/lib/question-utils";

// =============================================================================
// LES INDEX PAR QUESTION, et la mise en forme d'une réponse à l'écran.
//
// Extrait du lecteur de mission, qui avait atteint son plafond de taille : ce
// bloc n'a aucune part au déroulé du jeu (quand valider, quand avancer), il ne
// fait que TRADUIRE une réponse en quelque chose de lisible. Il en sort aussi
// gagnant : au feature-root, il entre dans le périmètre de couverture, dont
// `features/**/components/**` est exclu par choix — cette logique d'affichage,
// qui a quatre branches et deux pièges de bidirectionnalité, n'était couverte
// par rien.
// =============================================================================

type QuestionLike = {
  id: string;
  prompt: string;
  options?: unknown;
  question_type?: string | null;
};

/**
 * Rend une réponse telle qu'on la montre à l'élève.
 *
 * Pure et sans React : c'est ce qui la rend testable branche par branche.
 */
export function buildDisplayChoice({
  typeById,
  optionsById,
  isRecall,
}: {
  typeById: ReadonlyMap<string, string>;
  optionsById: ReadonlyMap<string, readonly DisplayOption[]>;
  isRecall: boolean;
}): (questionId: string, choice: string) => string {
  return (questionId, choice) => {
    if (!choice) return "-";
    // `short_answer` (étude 20 lot 7) : réponse tapée, aucune option — même
    // chemin d'affichage que le Rappel. Sans ce court-circuit, une réponse
    // contenant une virgule tomberait dans la branche CSV des types B2 et
    // s'afficherait découpée.
    if (typeById.get(questionId) === "short_answer") return isolateLtrRuns(choice);
    // Recall (étude 17): the answer is free text, options are empty by
    // construction — show the raw typed/expected text, LTR-isolated. Skipping
    // the option/CSV lookups avoids a comma/colon in the text hitting the B2
    // branch by accident.
    if (isRecall) return isolateLtrRuns(choice);
    const opts = optionsById.get(questionId) ?? [];
    // mcq: show the option's display letter.
    const direct = opts.find((opt) => opt.id === choice)?.displayId;
    if (direct) return direct;
    // B2 CSV answers (ordering "b,a,…" / matching "l1:r2,…"): map each id
    // back to its option text when it is short plain text — raw shuffled ids
    // mean nothing to the student. SVG/long texts fall back to the id.
    if (choice.includes(",") || choice.includes(":")) {
      const textById = new Map(opts.map((opt) => [opt.id, opt.text]));
      const plain = (id: string) => {
        const text = textById.get(id);
        return text && !text.includes("<") && text.length <= 40 ? text : id;
      };
      const rendered = choice
        .replace(/\s+/g, "")
        .split(",")
        .map((part) => {
          const [left, right] = part.split(":");
          return right !== undefined ? `${plain(left)} ⇢ ${plain(right)}` : plain(left);
        })
        .join(" · ");
      return isolateLtrRuns(rendered);
    }
    // Otherwise (numeric value, give-up sentinel): the raw answer, LTR-isolated.
    return isolateLtrRuns(choice);
  };
}

/**
 * Les trois index dérivés des questions servies, plus le formateur qui s'en sert.
 *
 * Les options sont MÉLANGÉES ici, une fois : c'est ce qui garantit que la
 * correction montre le même ordre que la question, et que l'ordre ne bouge pas
 * d'un rendu à l'autre.
 */
export function useQuestionMaps(questions: readonly QuestionLike[], isRecall: boolean) {
  // Resolve a review item's prompt: the connected review carries it; the anon
  // public correction does not, so the player fills it from the loaded questions.
  const promptById = useMemo(() => new Map(questions.map((q) => [q.id, q.prompt])), [questions]);

  const optionsById = useMemo(
    () =>
      new Map(
        questions.map((q) => [q.id, shuffleOptions((q.options as BaseOption[]) ?? [])] as const),
      ),
    [questions],
  );

  /** type par question — la correction en a besoin, pas seulement la question courante. */
  const typeById = useMemo(
    () =>
      new Map(
        questions.map((q) => [
          q.id,
          (q as { question_type?: string | null }).question_type ?? "mcq",
        ]),
      ),
    [questions],
  );

  const getDisplayChoice = useMemo(
    () => buildDisplayChoice({ typeById, optionsById, isRecall }),
    [typeById, optionsById, isRecall],
  );

  return { promptById, optionsById, typeById, getDisplayChoice };
}
