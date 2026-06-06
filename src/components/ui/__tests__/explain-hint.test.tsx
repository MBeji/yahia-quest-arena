import { describe, it, expect } from "vitest";
import { render, screen, fireEvent, within } from "@testing-library/react";

import { ExplainHint } from "@/components/ui/explain-hint";

describe("ExplainHint", () => {
  it("renders children as the trigger with a dotted-underline hint", () => {
    render(
      <ExplainHint text="Explained!">
        <span>1234 XP</span>
      </ExplainHint>,
    );
    const trigger = screen.getByRole("button");
    expect(within(trigger).getByText("1234 XP")).toBeInTheDocument();
    expect(trigger.className).toContain("decoration-dotted");
  });

  it("renders an icon-only trigger when no children are given", () => {
    render(<ExplainHint text="Some explanation" label="What is this?" />);
    const trigger = screen.getByRole("button", { name: "What is this?" });
    expect(trigger).toBeInTheDocument();
    // No explained content -> the help icon is the only child (svg).
    expect(trigger.querySelector("svg")).not.toBeNull();
  });

  it("falls back to the text as the accessible label when none is provided", () => {
    render(<ExplainHint text="Fallback label text" />);
    expect(screen.getByRole("button", { name: "Fallback label text" })).toBeInTheDocument();
  });

  it("shows the explanation text on focus", () => {
    render(
      <ExplainHint text="XP rule explanation">
        <span>XP</span>
      </ExplainHint>,
    );
    const trigger = screen.getByRole("button");
    fireEvent.focus(trigger);
    // Radix renders tooltip content (possibly multiple instances for a11y).
    expect(screen.getAllByText("XP rule explanation").length).toBeGreaterThan(0);
  });

  it("does not bubble a click to an underlying handler (tap-safe)", () => {
    let outerClicked = false;
    render(
      // Mimics the hint living inside a clickable card/link.
      <div onClick={() => (outerClicked = true)}>
        <ExplainHint text="hint">
          <span>label</span>
        </ExplainHint>
      </div>,
    );
    fireEvent.click(screen.getByText("label"));
    expect(outerClicked).toBe(false);
  });
});
