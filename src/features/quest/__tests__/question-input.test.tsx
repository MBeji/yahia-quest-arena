import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";

import {
  QuestionInput,
  UNSUPPORTED_ANSWER_CHOICE,
  type QuestionInputLabels,
} from "../components/question-input";

const labels: QuestionInputLabels = {
  numericPlaceholder: "Ta réponse (nombre)",
  numericHint: "Saisis un nombre — ex. 3,14 ou -5",
  numericInvalid: "Entre uniquement un nombre (entier ou décimal).",
  orderingHint: "Range dans le bon ordre.",
  matchingHint: "Aligne chaque paire.",
  moveUp: "Monter",
  moveDown: "Descendre",
  multiHint: "Sélectionne TOUTES les bonnes réponses.",
  unsupportedTitle: "⚠️ Question indisponible",
  unsupportedBody: "Ce type de question n'est pas encore pris en charge ici.",
  recallPlaceholder: "Tape ta réponse",
  recallHint: "Tape ta réponse, puis Entrée pour valider.",
  recallInsertChar: "insérer {char}",
};

const options = [
  { id: "a", text: "Quatre", displayId: "A" },
  { id: "b", text: "Cinq", displayId: "B" },
];

function renderInput(overrides: Partial<Parameters<typeof QuestionInput>[0]> = {}) {
  const onChange = vi.fn();
  const onSubmit = vi.fn();
  const utils = render(
    <QuestionInput
      questionType="mcq"
      prompt="2+2 ?"
      options={options}
      value={null}
      onChange={onChange}
      onSubmit={onSubmit}
      labels={labels}
      optionClassName={({ isSelected }) => (isSelected ? "is-selected" : "is-idle")}
      optionTrailing={({ isSelected }) => (isSelected ? <span data-testid="trail" /> : null)}
      {...overrides}
    />,
  );
  return { onChange, onSubmit, ...utils };
}

describe("QuestionInput — mcq (historical radiogroup)", () => {
  it("renders a radiogroup with the display letters and forwards selection", () => {
    const { onChange } = renderInput();
    expect(screen.getByRole("radiogroup", { name: "2+2 ?" })).toBeInTheDocument();
    const radios = screen.getAllByRole("radio");
    expect(radios).toHaveLength(2);
    expect(screen.getByText("A")).toBeInTheDocument();
    expect(screen.getByText("Quatre")).toBeInTheDocument();

    fireEvent.click(radios[1]);
    expect(onChange).toHaveBeenCalledWith("b");
  });

  it("marks the selected option and applies the surface's styling + trailing node", () => {
    renderInput({ value: "a" });
    const [first, second] = screen.getAllByRole("radio");
    expect(first).toHaveAttribute("aria-checked", "true");
    expect(first.className).toContain("is-selected");
    expect(second.className).toContain("is-idle");
    expect(screen.getByTestId("trail")).toBeInTheDocument();
  });

  it("treats a missing question_type as mcq (old rows keep working — US-4)", () => {
    renderInput({ questionType: null });
    expect(screen.getByRole("radiogroup")).toBeInTheDocument();
  });
});

describe("QuestionInput — numeric (native entry)", () => {
  it("renders a hard-LTR decimal input and forwards typed text", () => {
    const { onChange } = renderInput({ questionType: "numeric", options: [], rtl: true });
    const input = screen.getByTestId("numeric-answer-input");
    // R-4: numbers are standard LTR notation even inside an RTL subject.
    expect(input).toHaveAttribute("dir", "ltr");
    expect(input).toHaveAttribute("inputmode", "decimal");
    fireEvent.change(input, { target: { value: "3,14" } });
    expect(onChange).toHaveBeenCalledWith("3,14");
  });

  it("shows the invalid warning for a malformed value and blocks Enter", () => {
    const { onSubmit } = renderInput({ questionType: "numeric", options: [], value: "abc" });
    const input = screen.getByTestId("numeric-answer-input");
    expect(input).toHaveAttribute("aria-invalid", "true");
    expect(screen.getByText(labels.numericInvalid)).toBeInTheDocument();
    fireEvent.keyDown(input, { key: "Enter" });
    expect(onSubmit).not.toHaveBeenCalled();
  });

  it("submits a well-formed value on Enter", () => {
    const { onSubmit } = renderInput({ questionType: "numeric", options: [], value: "-5.5" });
    expect(screen.getByText(labels.numericHint)).toBeInTheDocument();
    fireEvent.keyDown(screen.getByTestId("numeric-answer-input"), { key: "Enter" });
    expect(onSubmit).toHaveBeenCalledTimes(1);
  });
});

describe("QuestionInput — multi (B3 checkbox list)", () => {
  const multiOptions = [
    { id: "a", text: "vrai 1", displayId: "A" },
    { id: "b", text: "faux", displayId: "B" },
    { id: "c", text: "vrai 2", displayId: "C" },
  ];

  it("renders the explicit select-ALL mention (US-3) and a checkbox group", () => {
    renderInput({ questionType: "multi", options: multiOptions, value: null });
    expect(screen.getByText(labels.multiHint)).toBeInTheDocument();
    expect(screen.getByRole("group", { name: "2+2 ?" })).toBeInTheDocument();
    expect(screen.getAllByRole("checkbox")).toHaveLength(3);
  });

  it("toggling a checkbox emits the sorted CSV of checked ids", () => {
    // renderInput's <QuestionInput> is uncontrolled across clicks (its `value`
    // prop doesn't update itself), so simulate the parent re-rendering with
    // the previous onChange result to accumulate a second selection.
    const { onChange, rerender } = renderInput({
      questionType: "multi",
      options: multiOptions,
      value: null,
    });
    fireEvent.click(screen.getAllByRole("checkbox")[2]); // c
    expect(onChange).toHaveBeenLastCalledWith("c");

    rerender(
      <QuestionInput
        questionType="multi"
        prompt="2+2 ?"
        options={multiOptions}
        value="c"
        onChange={onChange}
        labels={labels}
        optionClassName={() => ""}
      />,
    );
    fireEvent.click(screen.getAllByRole("checkbox")[0]); // a
    expect(onChange).toHaveBeenLastCalledWith("a,c");
  });

  it("un-checking removes the id from the CSV", () => {
    const { onChange } = renderInput({
      questionType: "multi",
      options: multiOptions,
      value: "a,c",
    });
    fireEvent.click(screen.getAllByRole("checkbox")[0]); // uncheck a
    expect(onChange).toHaveBeenLastCalledWith("c");
  });

  it("marks checked boxes from the current value", () => {
    renderInput({ questionType: "multi", options: multiOptions, value: "a,c" });
    const [a, b, c] = screen.getAllByRole("checkbox");
    expect(a).toHaveAttribute("aria-checked", "true");
    expect(b).toHaveAttribute("aria-checked", "false");
    expect(c).toHaveAttribute("aria-checked", "true");
  });
});

describe("QuestionInput — B2 boards routing", () => {
  it("routes ordering to the sequencing board", () => {
    renderInput({
      questionType: "ordering",
      options: [
        { id: "a", text: "étape A", displayId: "A" },
        { id: "b", text: "étape B", displayId: "B" },
      ],
    });
    expect(screen.getByTestId("ordering-board")).toBeInTheDocument();
    expect(screen.queryByRole("radiogroup")).not.toBeInTheDocument();
  });

  it("routes matching to the pair-alignment board", () => {
    renderInput({
      questionType: "matching",
      options: [
        { id: "l1", text: "gauche 1", displayId: "A" },
        { id: "l2", text: "gauche 2", displayId: "B" },
        { id: "r1", text: "droite 1", displayId: "C" },
        { id: "r2", text: "droite 2", displayId: "D" },
      ],
    });
    expect(screen.getByTestId("matching-board")).toBeInTheDocument();
  });
});

describe("QuestionInput — recall (étude 17 free-text)", () => {
  it("renders a free-text input following the content direction and forwards typed text", () => {
    const { onChange } = renderInput({ variant: "recall", options: [], rtl: true });
    const input = screen.getByTestId("recall-answer-input");
    // R-8: recall follows the CONTENT language direction (unlike numeric).
    expect(input).toHaveAttribute("dir", "rtl");
    expect(input).toHaveAttribute("autocomplete", "off");
    expect(input).toHaveAttribute("spellcheck", "false");
    expect(input).toHaveAttribute("placeholder", labels.recallPlaceholder);
    expect(screen.queryByRole("radiogroup")).not.toBeInTheDocument();
    fireEvent.change(input, { target: { value: "Paris" } });
    expect(onChange).toHaveBeenCalledWith("Paris");
  });

  it("submits a non-empty answer on Enter but ignores an empty one", () => {
    const blank = renderInput({ variant: "recall", options: [], value: "  " });
    fireEvent.keyDown(blank.getByTestId("recall-answer-input"), { key: "Enter" });
    expect(blank.onSubmit).not.toHaveBeenCalled();

    const filled = renderInput({ variant: "recall", options: [], value: "42" });
    const inputs = filled.getAllByTestId("recall-answer-input");
    fireEvent.keyDown(inputs[inputs.length - 1], { key: "Enter" });
    expect(filled.onSubmit).toHaveBeenCalledTimes(1);
  });

  it("shows the char bar for a non-empty palette and inserts a character at the caret", () => {
    const { onChange } = renderInput({
      variant: "recall",
      options: [],
      value: "e",
      recallChars: ["é", "è"],
    });
    const bar = screen.getByTestId("recall-char-bar");
    expect(bar).toBeInTheDocument();
    const chip = screen.getByRole("button", {
      name: labels.recallInsertChar.replace("{char}", "é"),
    });
    fireEvent.click(chip);
    expect(onChange).toHaveBeenCalledWith("eé");
  });

  it("hides the char bar entirely for an empty palette (e.g. English — R-12)", () => {
    renderInput({ variant: "recall", options: [], recallChars: [] });
    expect(screen.queryByTestId("recall-char-bar")).not.toBeInTheDocument();
  });

  it("wins over questionType — a recall-variant mcq is still free text", () => {
    renderInput({ variant: "recall", questionType: "mcq", options });
    expect(screen.getByTestId("recall-answer-input")).toBeInTheDocument();
    expect(screen.queryByRole("radiogroup")).not.toBeInTheDocument();
  });
});

describe("QuestionInput — unsupported types (R-3 fallback)", () => {
  it("renders the clean unavailable notice instead of crashing", () => {
    renderInput({ questionType: "essay", options: [] });
    expect(screen.getByTestId("question-unsupported")).toBeInTheDocument();
    expect(screen.getByText(labels.unsupportedTitle)).toBeInTheDocument();
    expect(screen.queryByRole("radiogroup")).not.toBeInTheDocument();
  });

  it("auto-fills the sentinel answer so the run stays completable", () => {
    const { onChange } = renderInput({ questionType: "essay", options: [] });
    expect(onChange).toHaveBeenCalledWith(UNSUPPORTED_ANSWER_CHOICE);
  });

  it("does not re-fill once the sentinel is already the value", () => {
    const { onChange } = renderInput({
      questionType: "essay",
      options: [],
      value: UNSUPPORTED_ANSWER_CHOICE,
    });
    expect(onChange).not.toHaveBeenCalled();
  });
});
