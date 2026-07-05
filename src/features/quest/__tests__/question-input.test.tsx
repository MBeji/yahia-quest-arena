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
  unsupportedTitle: "⚠️ Question indisponible",
  unsupportedBody: "Ce type de question n'est pas encore pris en charge ici.",
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

describe("QuestionInput — unsupported types (R-3 fallback)", () => {
  it("renders the clean unavailable notice instead of crashing", () => {
    renderInput({ questionType: "multi", options: [] });
    expect(screen.getByTestId("question-unsupported")).toBeInTheDocument();
    expect(screen.getByText(labels.unsupportedTitle)).toBeInTheDocument();
    expect(screen.queryByRole("radiogroup")).not.toBeInTheDocument();
  });

  it("auto-fills the sentinel answer so the run stays completable", () => {
    const { onChange } = renderInput({ questionType: "multi", options: [] });
    expect(onChange).toHaveBeenCalledWith(UNSUPPORTED_ANSWER_CHOICE);
  });

  it("does not re-fill once the sentinel is already the value", () => {
    const { onChange } = renderInput({
      questionType: "multi",
      options: [],
      value: UNSUPPORTED_ANSWER_CHOICE,
    });
    expect(onChange).not.toHaveBeenCalled();
  });
});
