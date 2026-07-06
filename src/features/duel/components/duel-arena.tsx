import { useEffect, useMemo, useState, type ReactNode } from "react";
import { QuestionInput, type McqOptionRender } from "@/features/quest/components/question-input";
import type { QuestLabels } from "@/features/quest/quest-labels";
import { isValidAnswerFormat } from "@/shared/lib/answer-formats";
import { shuffleOptions, type BaseOption } from "@/shared/lib/question-utils";
import type { TranslationKeys } from "@/lib/i18n/types";
import type { DuelQuestion } from "../duel.server";

type DuelLabels = TranslationKeys["duel"];

/**
 * US-2: the play screen — one frozen question at a time, the same
 * `<QuestionInput>` renderer as the quest/dungeon (options shuffled, no key on
 * the client). The parent owns submission + the opponent-progress node.
 */
export function DuelArena({
  question,
  questionIndex,
  total,
  rtl,
  questLabels,
  labels,
  opponent,
  submitting,
  tooFast,
  onSubmit,
}: {
  question: DuelQuestion;
  questionIndex: number;
  total: number;
  rtl: boolean;
  questLabels: QuestLabels;
  labels: DuelLabels;
  opponent: ReactNode;
  submitting: boolean;
  tooFast: boolean;
  onSubmit: (choice: string) => void;
}) {
  const [selected, setSelected] = useState<string | null>(null);
  const options = useMemo(
    () => shuffleOptions((question.options ?? []) as BaseOption[]),
    [question],
  );
  // Reset the selection whenever the frozen set advances to a new question.
  useEffect(() => setSelected(null), [question.id]);

  const canValidate = Boolean(selected && isValidAnswerFormat(question.questionType, selected));
  const submit = () => {
    if (!selected || !isValidAnswerFormat(question.questionType, selected)) return;
    onSubmit(selected);
  };

  return (
    <div className="space-y-4">
      <p className="text-sm font-medium text-muted-foreground">
        {labels.questionOf
          .replace("{n}", String(questionIndex + 1))
          .replace("{total}", String(total))}
      </p>
      <h2 className="text-lg font-semibold" dir={rtl ? "rtl" : undefined}>
        {question.prompt}
      </h2>

      <QuestionInput
        questionType={question.questionType}
        prompt={question.prompt}
        options={options}
        value={selected}
        onChange={setSelected}
        onSubmit={submit}
        disabled={submitting}
        rtl={rtl}
        labels={questLabels}
        optionClassName={({ isSelected }: McqOptionRender) =>
          `flex w-full items-center gap-3 rounded-lg border p-3 text-start transition-colors ${
            isSelected ? "border-primary bg-primary/10" : "border-border hover:bg-muted"
          }`
        }
      />

      {tooFast ? (
        <p className="text-sm text-amber-600" role="alert">
          {labels.tooFast}
        </p>
      ) : null}

      {opponent}

      <button
        type="button"
        onClick={submit}
        disabled={!canValidate || submitting}
        className="w-full rounded-lg bg-primary px-6 py-3 font-semibold text-primary-foreground hover:opacity-90 disabled:opacity-50"
      >
        {labels.validate}
      </button>
    </div>
  );
}
