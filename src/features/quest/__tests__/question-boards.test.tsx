import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";

import { MatchingBoard, OrderingBoard } from "../components/question-boards";
import { splitMatchingOptions } from "@/shared/lib/question-utils";
import type { QuestionInputLabels } from "../components/question-input";

const labels: QuestionInputLabels = {
  numericPlaceholder: "n",
  numericHint: "n",
  numericInvalid: "n",
  orderingHint: "Range dans le bon ordre.",
  matchingHint: "Aligne chaque paire.",
  moveUp: "Monter",
  moveDown: "Descendre",
  unsupportedTitle: "⚠️ Question indisponible",
  unsupportedBody: "Type non pris en charge.",
};

const steps = [
  { id: "b", text: "étape B", displayId: "A" },
  { id: "a", text: "étape A", displayId: "B" },
  { id: "c", text: "étape C", displayId: "C" },
];

describe("OrderingBoard", () => {
  it("auto-fills the initial (shuffled) arrangement as the answer", () => {
    const onChange = vi.fn();
    render(<OrderingBoard options={steps} value={null} onChange={onChange} labels={labels} />);
    expect(onChange).toHaveBeenCalledWith("b,a,c");
    expect(screen.getByText(labels.orderingHint)).toBeInTheDocument();
  });

  it("renders the arrangement carried by value, in order", () => {
    render(<OrderingBoard options={steps} value="c,b,a" onChange={vi.fn()} labels={labels} />);
    const items = screen.getAllByTestId("ordering-item");
    expect(items.map((el) => el.getAttribute("data-option-id"))).toEqual(["c", "b", "a"]);
    expect(screen.getByText("étape C")).toBeInTheDocument();
  });

  it("tap-to-order: the down arrow swaps the step with its neighbour", () => {
    const onChange = vi.fn();
    render(<OrderingBoard options={steps} value="b,a,c" onChange={onChange} labels={labels} />);
    const downArrows = screen.getAllByRole("button", { name: labels.moveDown });
    fireEvent.click(downArrows[0]);
    expect(onChange).toHaveBeenCalledWith("a,b,c");
  });

  it("tap-to-order: the up arrow of the first step is disabled", () => {
    render(<OrderingBoard options={steps} value="b,a,c" onChange={vi.fn()} labels={labels} />);
    const upArrows = screen.getAllByRole("button", { name: labels.moveUp });
    expect(upArrows[0]).toBeDisabled();
    expect(upArrows[1]).not.toBeDisabled();
  });

  it("disables the arrows when the board is disabled", () => {
    render(
      <OrderingBoard options={steps} value="b,a,c" onChange={vi.fn()} disabled labels={labels} />,
    );
    for (const arrow of screen.getAllByRole("button", { name: labels.moveDown })) {
      expect(arrow).toBeDisabled();
    }
  });
});

const pairs = [
  { id: "l1", text: "la moitié de 10", displayId: "A" },
  { id: "l2", text: "le double de 4", displayId: "B" },
  { id: "r2", text: "8", displayId: "C" },
  { id: "r1", text: "5", displayId: "D" },
];

describe("MatchingBoard", () => {
  it("splits options into fixed lefts and movable rights by id prefix", () => {
    const { lefts, rights } = splitMatchingOptions(pairs);
    expect(lefts.map((o) => o.id)).toEqual(["l1", "l2"]);
    expect(rights.map((o) => o.id)).toEqual(["r2", "r1"]);
  });

  it("auto-fills the initial alignment as a pair CSV", () => {
    const onChange = vi.fn();
    render(<MatchingBoard options={pairs} value={null} onChange={onChange} labels={labels} />);
    expect(onChange).toHaveBeenCalledWith("l1:r2,l2:r1");
    expect(screen.getByText(labels.matchingHint)).toBeInTheDocument();
  });

  it("renders the alignment carried by value and exposes the pairs", () => {
    render(
      <MatchingBoard options={pairs} value="l1:r1,l2:r2" onChange={vi.fn()} labels={labels} />,
    );
    const rows = screen.getAllByTestId("matching-row");
    expect(rows.map((el) => el.getAttribute("data-pair"))).toEqual(["l1:r1", "l2:r2"]);
  });

  it("tap-to-order: moving a right item re-pairs the rows", () => {
    const onChange = vi.fn();
    render(
      <MatchingBoard options={pairs} value="l1:r2,l2:r1" onChange={onChange} labels={labels} />,
    );
    const downArrows = screen.getAllByRole("button", { name: labels.moveDown });
    fireEvent.click(downArrows[0]);
    expect(onChange).toHaveBeenCalledWith("l1:r1,l2:r2");
  });

  it("falls back to the clean R-3 notice on unbalanced sides", () => {
    render(
      <MatchingBoard
        options={[
          { id: "l1", text: "seul à gauche", displayId: "A" },
          { id: "r1", text: "droite 1", displayId: "B" },
          { id: "r2", text: "droite 2", displayId: "C" },
        ]}
        value={null}
        onChange={vi.fn()}
        labels={labels}
      />,
    );
    expect(screen.getByTestId("question-unsupported")).toBeInTheDocument();
  });
});
