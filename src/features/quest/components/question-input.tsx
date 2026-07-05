import { useEffect, type ReactNode } from "react";
import { isMathExpression, isRtlText } from "@/shared/lib/utils";
import { isValidAnswerFormat, UNSUPPORTED_ANSWER_CHOICE } from "@/shared/lib/answer-formats";
import { OptionContent } from "@/components/ui/svg-figure";
import type { DisplayOption } from "@/shared/lib/question-utils";

// =============================================================================
// <QuestionInput> — the per-type answer input (Tier B, phase B1).
//
// One renderer for BOTH gameplay surfaces (quest player and dungeon): the
// surface passes its own option styling/trailing indicators, the component owns
// the per-type switch. Types:
//   * 'mcq' (default) — the historical radiogroup of option buttons;
//   * 'numeric'       — a free numeric entry (mobile decimal keyboard, always
//                       LTR even inside an RTL subject — R-4);
//   * anything else   — the R-3 fallback: a clean "unavailable" notice that
//                       auto-fills a sentinel answer so the run stays
//                       completable (the sentinel scores as wrong server-side).
// =============================================================================

export { UNSUPPORTED_ANSWER_CHOICE };

/** Content-language labels the input needs (from buildQuestLabels or t.*). */
export type QuestionInputLabels = {
  numericPlaceholder: string;
  numericHint: string;
  numericInvalid: string;
  unsupportedTitle: string;
  unsupportedBody: string;
};

export type McqOptionRender = { option: DisplayOption; isSelected: boolean };

export type QuestionInputProps = {
  /** questions.question_type — anything unknown renders the R-3 fallback. */
  questionType: string | null | undefined;
  /** Accessible name of the radiogroup (the question prompt). */
  prompt: string;
  /** Shuffled display options — mcq only (ignored by other types). */
  options: DisplayOption[];
  /** Current answer: an option id (mcq) or the typed number (numeric). */
  value: string | null;
  onChange: (choice: string) => void;
  /** Numeric only: Enter submits when the current value is well-formed. */
  onSubmit?: () => void;
  disabled?: boolean;
  /** The subject's content language is RTL (numeric entry stays LTR — R-4). */
  rtl?: boolean;
  labels: QuestionInputLabels;
  /** Per-surface mcq option styling (quest vs boss vs dungeon feedback). */
  optionClassName: (state: McqOptionRender) => string;
  /** Per-surface trailing indicator (check / correct / wrong icons). */
  optionTrailing?: (state: McqOptionRender) => ReactNode;
};

export function QuestionInput(props: QuestionInputProps) {
  const type = props.questionType ?? "mcq";
  if (type === "numeric") return <NumericInput {...props} />;
  if (type !== "mcq") return <UnsupportedQuestion {...props} />;
  return <McqInput {...props} />;
}

function McqInput({
  prompt,
  options,
  value,
  onChange,
  disabled,
  optionClassName,
  optionTrailing,
}: QuestionInputProps) {
  return (
    <div className="mt-6 space-y-3" role="radiogroup" aria-label={prompt}>
      {options.map((option) => {
        const state: McqOptionRender = { option, isSelected: value === option.id };
        return (
          <button
            key={option.id}
            type="button"
            role="radio"
            aria-checked={state.isSelected}
            disabled={disabled}
            onClick={() => onChange(option.id)}
            className={`flex w-full items-center justify-between gap-3 rounded-xl border px-4 py-3.5 text-left text-sm transition-all duration-200 ${optionClassName(state)}`}
          >
            <span
              className="flex items-center gap-3"
              dir={
                isMathExpression(option.text) ? "ltr" : isRtlText(option.text) ? "rtl" : undefined
              }
            >
              <span className="grid h-7 w-7 place-items-center rounded-md border border-current font-mono text-xs uppercase">
                {option.displayId}
              </span>
              <OptionContent raw={option.text} />
            </span>
            {optionTrailing?.(state)}
          </button>
        );
      })}
    </div>
  );
}

function NumericInput({ value, onChange, onSubmit, disabled, rtl, labels }: QuestionInputProps) {
  const raw = value ?? "";
  const invalid = raw.trim().length > 0 && !isValidAnswerFormat("numeric", raw);
  return (
    <div className="mt-6">
      {/* Numbers are standard notation in every language (Western digits, LTR),
          so the entry is hard-LTR even inside an RTL subject (R-4). */}
      <input
        type="text"
        inputMode="decimal"
        autoComplete="off"
        dir="ltr"
        data-testid="numeric-answer-input"
        aria-invalid={invalid || undefined}
        placeholder={labels.numericPlaceholder}
        value={raw}
        disabled={disabled}
        onChange={(e) => onChange(e.target.value)}
        onKeyDown={(e) => {
          if (e.key === "Enter" && !invalid && raw.trim().length > 0) {
            e.preventDefault();
            onSubmit?.();
          }
        }}
        className="w-full rounded-xl border border-border bg-black/40 px-4 py-3.5 text-center font-mono text-lg outline-none transition focus:border-(--gold) focus:bg-black/70 disabled:opacity-50"
      />
      <p
        className={`mt-2 text-xs ${invalid ? "font-semibold text-destructive" : "text-muted-foreground/60"}`}
        dir={rtl ? "rtl" : undefined}
      >
        {invalid ? labels.numericInvalid : labels.numericHint}
      </p>
    </div>
  );
}

function UnsupportedQuestion({ value, onChange, rtl, labels }: QuestionInputProps) {
  // Auto-fill the sentinel so the surface's validate button enables and the run
  // stays completable — the sentinel scores as wrong, never crashes (R-3).
  useEffect(() => {
    if (value !== UNSUPPORTED_ANSWER_CHOICE) onChange(UNSUPPORTED_ANSWER_CHOICE);
  }, [value, onChange]);

  return (
    <div
      data-testid="question-unsupported"
      className="mt-6 rounded-2xl border border-[color:var(--gold)]/40 bg-[color:var(--gold)]/5 p-5 text-sm"
      dir={rtl ? "rtl" : undefined}
    >
      <div className="font-display font-bold">{labels.unsupportedTitle}</div>
      <p className="mt-1 text-muted-foreground">{labels.unsupportedBody}</p>
    </div>
  );
}
