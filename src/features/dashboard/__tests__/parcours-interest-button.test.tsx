import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";

vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    parcoursInterest: {
      cta: "I'm interested",
      interested: "Interested ✓",
      count: "{count} interested",
    },
  }),
}));

import { ParcoursInterestButton } from "../components/parcours-interest-button";

describe("ParcoursInterestButton", () => {
  it("shows the CTA and the interpolated count when not interested", () => {
    render(
      <ParcoursInterestButton count={5} interested={false} isPending={false} onToggle={() => {}} />,
    );
    expect(screen.getByText("5 interested")).toBeInTheDocument();
    expect(screen.getByRole("button", { name: /I'm interested/ })).toBeInTheDocument();
  });

  it("reflects the interested state with aria-pressed", () => {
    render(
      <ParcoursInterestButton count={1} interested={true} isPending={false} onToggle={() => {}} />,
    );
    const btn = screen.getByRole("button", { name: /Interested ✓/ });
    expect(btn).toHaveAttribute("aria-pressed", "true");
  });

  it("calls onToggle on click", () => {
    const onToggle = vi.fn();
    render(
      <ParcoursInterestButton count={0} interested={false} isPending={false} onToggle={onToggle} />,
    );
    fireEvent.click(screen.getByRole("button"));
    expect(onToggle).toHaveBeenCalledTimes(1);
  });

  it("is disabled and does not toggle while pending", () => {
    const onToggle = vi.fn();
    render(
      <ParcoursInterestButton count={2} interested={false} isPending={true} onToggle={onToggle} />,
    );
    const btn = screen.getByRole("button");
    expect(btn).toBeDisabled();
    fireEvent.click(btn);
    expect(onToggle).not.toHaveBeenCalled();
  });
});
