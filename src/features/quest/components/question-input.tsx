import { useEffect, useMemo, useRef, type ReactNode } from "react";
import { Check } from "lucide-react";
import { isMathExpression, isRtlText } from "@/shared/lib/utils";
import { isValidAnswerFormat, UNSUPPORTED_ANSWER_CHOICE } from "@/shared/lib/answer-formats";
import { OptionContent } from "@/components/ui/svg-figure";
import { MatchingBoard, OrderingBoard } from "@/features/quest/components/question-boards";
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
//   * 'ordering'      — drag-&-drop (or arrow) sequencing board (phase B2);
//   * 'matching'      — drag-&-drop (or arrow) pair-alignment board (phase B2);
//   * 'multi'         — checkbox list, explicit "select ALL" mention (phase B3);
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
  orderingHint: string;
  matchingHint: string;
  moveUp: string;
  moveDown: string;
  multiHint: string;
  unsupportedTitle: string;
  unsupportedBody: string;
  // Recall mode (étude 17) — only the free-text input pieces are needed here.
  recallPlaceholder: string;
  recallHint: string;
  recallInsertChar: string;
};

export type McqOptionRender = { option: DisplayOption; isSelected: boolean };

export type QuestionInputProps = {
  /** questions.question_type — anything unknown renders the R-3 fallback. */
  questionType: string | null | undefined;
  /**
   * Play variant (étude 17). In "recall" the input is a free-text field (no
   * options), regardless of `questionType` (the recall play set is served as
   * mcq prompts). Defaults to "classic".
   */
  variant?: "classic" | "recall";
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
  /** Recall (étude 17, R-12): the static per-language "extra characters" palette. */
  recallChars?: string[];
  /** Per-surface mcq option styling (quest vs boss vs dungeon feedback). */
  optionClassName: (state: McqOptionRender) => string;
  /** Per-surface trailing indicator (check / correct / wrong icons). */
  optionTrailing?: (state: McqOptionRender) => ReactNode;
};

export function QuestionInput(props: QuestionInputProps) {
  // Recall (étude 17) overrides the per-type input: a mastered QCM is replayed
  // as free text, so the variant wins over questionType.
  if (props.variant === "recall") return <RecallInput {...props} />;
  const type = props.questionType ?? "mcq";
  if (type === "numeric") return <NumericInput {...props} />;
  if (type === "ordering") return <OrderingBoard {...props} />;
  if (type === "matching") return <MatchingBoard {...props} />;
  if (type === "multi") return <MultiSelect {...props} />;
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
            className={`flex w-full items-center justify-between gap-3 rounded-xl border px-4 py-3.5 text-start text-sm transition-all duration-200 ${optionClassName(state)}`}
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

function RecallInput({
  value,
  onChange,
  onSubmit,
  disabled,
  rtl,
  labels,
  recallChars = [],
  prompt,
}: QuestionInputProps) {
  const raw = value ?? "";
  const inputRef = useRef<HTMLInputElement>(null);
  return (
    <div className="mt-6">
      {/* Recall (étude 17): a free-text answer replaces the options. Unlike
          `numeric`, the field follows the CONTENT language's direction (R-8) —
          Arabic answers are typed RTL. Autocomplete/correct/spellcheck are off
          so the phone keyboard can't suggest the answer. */}
      <input
        ref={inputRef}
        type="text"
        inputMode="text"
        dir={rtl ? "rtl" : "ltr"}
        autoComplete="off"
        autoCorrect="off"
        autoCapitalize="off"
        spellCheck={false}
        data-testid="recall-answer-input"
        aria-label={prompt}
        placeholder={labels.recallPlaceholder}
        value={raw}
        disabled={disabled}
        onChange={(e) => onChange(e.target.value)}
        onKeyDown={(e) => {
          if (e.key === "Enter" && raw.trim().length > 0) {
            e.preventDefault();
            onSubmit?.();
          }
        }}
        className="w-full rounded-xl border border-border bg-black/40 px-4 py-3.5 text-lg outline-none transition focus:border-(--gold) focus:bg-black/70 disabled:opacity-50"
      />
      <RecallCharBar
        chars={recallChars}
        rtl={rtl}
        disabled={disabled}
        insertLabel={labels.recallInsertChar}
        inputRef={inputRef}
        value={raw}
        onChange={onChange}
      />
      <p className="mt-2 text-xs text-muted-foreground/60" dir={rtl ? "rtl" : undefined}>
        {labels.recallHint}
      </p>
    </div>
  );
}

/**
 * Recall "extra characters" bar (étude 17, R-12): a static per-language row of
 * tappable chips that insert a hard-to-type character at the caret, keeping
 * focus on the input. The palette is STATIC (never derived from the answer —
 * that would leak it). Empty palette (e.g. English) → renders nothing.
 */
export function RecallCharBar({
  chars,
  rtl,
  disabled,
  insertLabel,
  inputRef,
  value,
  onChange,
}: {
  chars: string[];
  rtl?: boolean;
  disabled?: boolean;
  insertLabel: string;
  inputRef: React.RefObject<HTMLInputElement | null>;
  value: string;
  onChange: (choice: string) => void;
}) {
  if (chars.length === 0) return null;
  const insert = (char: string) => {
    const el = inputRef.current;
    const start = el?.selectionStart ?? value.length;
    const end = el?.selectionEnd ?? value.length;
    const next = value.slice(0, start) + char + value.slice(end);
    onChange(next);
    // Restore focus and place the caret after the inserted character once React
    // has committed the new value.
    const caret = start + char.length;
    requestAnimationFrame(() => {
      const node = inputRef.current;
      if (!node) return;
      node.focus();
      node.setSelectionRange(caret, caret);
    });
  };
  return (
    <div
      className="mt-3 flex flex-wrap gap-2"
      dir={rtl ? "rtl" : "ltr"}
      data-testid="recall-char-bar"
    >
      {chars.map((char) => (
        <button
          key={char}
          type="button"
          disabled={disabled}
          aria-label={insertLabel.replace("{char}", char)}
          onClick={() => insert(char)}
          className="min-w-9 rounded-lg border border-border bg-black/40 px-2.5 py-1.5 text-sm transition hover:border-(--gold)/60 hover:bg-black/70 disabled:opacity-50 [@media(pointer:coarse)]:min-h-11"
        >
          {char}
        </button>
      ))}
    </div>
  );
}

function MultiSelect({
  prompt,
  options,
  value,
  onChange,
  disabled,
  rtl,
  labels,
}: QuestionInputProps) {
  const checked = useMemo(() => {
    const parts = (value ?? "").replace(/\s+/g, "").split(",").filter(Boolean);
    return new Set(parts);
  }, [value]);

  const toggle = (id: string) => {
    const next = new Set(checked);
    if (next.has(id)) next.delete(id);
    else next.add(id);
    // Sorted CSV — the wire format score_answer/answer_key_display expect.
    onChange([...next].sort().join(","));
  };

  return (
    <div className="mt-6">
      {/* US-3: the "select ALL" instruction is load-bearing — a checkbox list
          is only fair when this is unmistakable. */}
      <p
        className="mb-3 rounded-xl border border-[color:var(--gold)]/40 bg-[color:var(--gold)]/5 px-3 py-2 text-xs font-semibold text-[color:var(--gold)]"
        dir={rtl ? "rtl" : undefined}
      >
        {labels.multiHint}
      </p>
      <div className="space-y-3" role="group" aria-label={prompt}>
        {options.map((option) => {
          const isChecked = checked.has(option.id);
          return (
            <button
              key={option.id}
              type="button"
              role="checkbox"
              aria-checked={isChecked}
              disabled={disabled}
              onClick={() => toggle(option.id)}
              className={`flex w-full items-center justify-between gap-3 rounded-xl border px-4 py-3.5 text-start text-sm transition-all duration-200 ${
                isChecked
                  ? "border-(--gold) bg-(--gold)/15"
                  : "border-border bg-black/40 hover:border-(--gold)/60 hover:bg-black/70"
              }`}
            >
              <span
                className="flex items-center gap-3"
                dir={
                  isMathExpression(option.text) ? "ltr" : isRtlText(option.text) ? "rtl" : undefined
                }
              >
                <span
                  className={`grid h-6 w-6 shrink-0 place-items-center rounded-md border-2 ${
                    isChecked ? "border-(--gold) bg-(--gold)" : "border-current"
                  }`}
                >
                  {isChecked && <Check className="h-4 w-4 text-black" aria-hidden="true" />}
                </span>
                <OptionContent raw={option.text} />
              </span>
            </button>
          );
        })}
      </div>
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
