import { memo } from "react";

import { QuestionInput, type McqOptionRender } from "@/components/game/question-input";
import { RichField } from "@/components/ui/svg-figure";
import type { QuestLabels } from "@/shared/lib/quest-labels";
import type { DisplayOption } from "@/shared/lib/question-utils";

import type { ExamQuestion } from "../exam.server";

// Aucun verdict pendant l'épreuve : la sélection seule est marquée. C'est la
// règle qui distingue un examen d'une quête. Hissée au niveau module pour que
// la fonction garde la même identité d'un rendu à l'autre.
const optionClassName = ({ isSelected }: McqOptionRender) =>
  `flex w-full items-center gap-3 rounded-lg border p-3 text-start transition-colors ${
    isSelected ? "border-gold bg-gold/15" : "border-border bg-surface-1 hover:bg-surface-3"
  }`;

/**
 * Une question de l'épreuve — mémoïsée, pour que cocher une réponse ne re-rende
 * que l'article touché.
 *
 * L'état `answers` vit dans le runner (un seul `setAnswers` par coche) ; avant
 * le 2026-10-31 chaque coche re-rendait les N articles de l'épreuve, chacun
 * repayant `RichField`/`OptionContent` : mesuré en jsdom, 20 questions à
 * figures = 20 rendus d'article et ~300-400 ms par tap, contre 1 rendu et
 * quelques ms une fois la carte mémoïsée. Toutes les props sont stables entre
 * deux coches sauf `value` de la question touchée : `options` vient d'une Map
 * mémoïsée par épreuve, `labels` d'un `useMemo` par locale, `onAnswer` d'un
 * `useCallback` sans dépendance, et `heading` est une chaîne (comparée par
 * valeur).
 *
 * `exam-question-cv` (styles.css) pose en plus le confinement
 * `content-visibility: auto` : hors écran, l'article ne paie ni layout ni paint.
 */
export const ExamQuestionCard = memo(function ExamQuestionCard({
  question,
  heading,
  options,
  value,
  onAnswer,
  rtl,
  labels,
}: {
  question: ExamQuestion;
  /** « Question i / n », déjà traduit et interpolé. */
  heading: string;
  options: DisplayOption[];
  value: string | null;
  onAnswer: (questionId: string, choice: string) => void;
  rtl: boolean;
  labels: QuestLabels;
}) {
  return (
    <article className="exam-question-cv rounded-xl border border-border bg-surface-2 p-4">
      <p className="mb-2 text-xs uppercase tracking-wide text-muted-foreground">{heading}</p>
      <RichField raw={question.prompt} className="mb-3 font-medium" />
      <QuestionInput
        questionType={question.questionType}
        prompt={question.prompt}
        options={options}
        value={value}
        onChange={(choice) => onAnswer(question.id, choice)}
        rtl={rtl}
        labels={labels}
        optionClassName={optionClassName}
      />
    </article>
  );
});
