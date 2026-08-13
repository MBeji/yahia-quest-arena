import { motion } from "motion/react";
import { Check, X, Flame } from "lucide-react";
import type { ReactNode } from "react";
import { RichField } from "@/components/ui/svg-figure";
import type { McqOptionRender } from "@/features/quest/components/question-input";
import type { QuestLabels } from "@/features/quest/quest-labels";
import type { Encouragement } from "@/lib/sound";
import type { QuestionVerdict } from "@/features/quest/verdict";

// =============================================================================
// Le retour immédiat par question (levier 01), côté présentation. Extrait du
// lecteur — comme <QuestResultScreen> avant lui — pour tenir le plafond de
// lignes du fichier de boucle : ici il n'y a AUCUN état, que du rendu.
// =============================================================================

/** Marque de fin de ligne d'une option : sélection, ou verdict une fois corrigé. */
export function OptionVerdictMark({
  feedback,
  state: { option, isSelected },
  labels,
}: {
  feedback: QuestionVerdict | null;
  state: McqOptionRender;
  /** Le sac de libellés d'UI de la quête — pas un objet reconstruit à chaque option. */
  labels: { selectedAnswer: string; correctAnswer: string; yourAnswer: string };
}): ReactNode {
  if (feedback) {
    if (option.id === feedback.correctChoice) {
      return (
        <span className="flex shrink-0 items-center gap-1 text-success">
          <Check className="h-5 w-5" aria-hidden="true" />
          <span className="sr-only">{labels.correctAnswer}</span>
        </span>
      );
    }
    return isSelected ? (
      <span className="flex shrink-0 items-center gap-1 text-destructive">
        <X className="h-5 w-5" aria-hidden="true" />
        <span className="sr-only">{labels.yourAnswer}</span>
      </span>
    ) : null;
  }
  return isSelected ? (
    <span className="flex shrink-0 items-center gap-1">
      <Check className="h-5 w-5" aria-hidden="true" />
      <span className="sr-only">{labels.selectedAnswer}</span>
    </span>
  ) : null;
}

/**
 * Série en cours : même mécanique que le donjon — la pastille compte à partir de
 * 2, la bannière ne parle qu'aux paliers (3, 5, 7, 10+).
 */
export function ComboStrip({
  streak,
  encouragement,
  entrance,
}: {
  streak: number;
  encouragement: Encouragement | null;
  entrance: Record<string, unknown>;
}) {
  if (streak < 2 && !encouragement) return null;
  return (
    <div className="mb-4 flex flex-col items-center gap-1.5">
      {streak >= 2 && (
        <motion.div
          {...entrance}
          data-testid="quest-combo"
          className="flex items-center gap-1.5 rounded-full bg-flame/20 px-3 py-1 text-sm font-bold text-flame"
        >
          <Flame className="h-3.5 w-3.5" aria-hidden="true" /> x{streak}
        </motion.div>
      )}
      {encouragement && (
        <motion.div
          key={encouragement.message}
          {...entrance}
          className="font-display text-sm font-bold text-[color:var(--gold)]"
        >
          {encouragement.message}
        </motion.div>
      )}
    </div>
  );
}

/** Le panneau de correction, sous la question qui vient d'être validée. */
export function QuestionVerdictPanel({
  feedback,
  labels,
  showAnswerInText,
  answerText,
  rtl,
}: {
  feedback: QuestionVerdict;
  labels: QuestLabels;
  /**
   * Sur un QCM la bonne option est déjà surlignée dans la liste : on ne répète
   * la réponse en toutes lettres que pour les types où il n'y a rien à
   * surligner (numérique, ordre, appariement, multi).
   */
  showAnswerInText: boolean;
  answerText: string | null;
  rtl: boolean;
}) {
  return (
    <div
      data-testid="quest-feedback"
      data-correct={feedback.isCorrect ? "true" : "false"}
      role="status"
      className={`mt-5 rounded-2xl border p-4 ${
        feedback.isCorrect
          ? "border-success/40 bg-success/10"
          : "border-destructive/40 bg-destructive/10"
      }`}
      dir={rtl ? "rtl" : undefined}
    >
      <div
        className={`flex items-center gap-2 text-sm font-bold ${
          feedback.isCorrect ? "text-success" : "text-destructive"
        }`}
      >
        {feedback.isCorrect ? (
          <Check className="h-4 w-4 shrink-0" aria-hidden="true" />
        ) : (
          <X className="h-4 w-4 shrink-0" aria-hidden="true" />
        )}
        {feedback.isCorrect ? labels.feedbackCorrect : labels.feedbackWrong}
      </div>
      {showAnswerInText && answerText && (
        <p className="mt-2 text-sm font-semibold">
          {labels.feedbackAnswerIs.replace("{answer}", answerText)}
        </p>
      )}
      {feedback.explanation && (
        <RichField
          raw={feedback.explanation}
          as="p"
          className="mt-2 text-sm text-muted-foreground"
        />
      )}
    </div>
  );
}
