import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));

import { SubjectPathCard } from "../components/subject-path-card";

const base = {
  id: "math",
  name_fr: "Mathématiques",
  icon: "Sword",
  attribute: "Force",
  color_token: "math",
};

describe("SubjectPathCard", () => {
  it("renders the name, attribute, quest count and average", () => {
    render(<SubjectPathCard subject={base} stat={{ count: 3, avg: 82 }} premiumLocked={false} />);
    expect(screen.getByText("Mathématiques")).toBeInTheDocument();
    expect(screen.getByText(/Force/)).toBeInTheDocument();
    expect(screen.getByText(/3 quest/)).toBeInTheDocument();
    expect(screen.getByText("82%")).toBeInTheDocument();
  });

  it("shows a dash for the average when there is no stat", () => {
    render(<SubjectPathCard subject={base} stat={undefined} premiumLocked={false} />);
    expect(screen.getByText("—")).toBeInTheDocument();
  });

  it("shows a Premium (lock) badge on a premium-locked subject", () => {
    render(<SubjectPathCard subject={base} stat={undefined} premiumLocked />);
    expect(screen.getByText("Premium")).toBeInTheDocument();
  });

  it("does not show a Premium badge when the subject is not locked (entitled or free)", () => {
    render(<SubjectPathCard subject={base} stat={undefined} premiumLocked={false} />);
    expect(screen.queryByText("Premium")).not.toBeInTheDocument();
  });

  it("resolves the subject colour var without double-prefixing a prefixed token", () => {
    const { container } = render(
      <SubjectPathCard
        subject={{ ...base, color_token: "subject-arabic" }}
        stat={{ count: 1, avg: 50 }}
        premiumLocked={false}
      />,
    );
    expect(container.innerHTML).toContain("var(--subject-arabic)");
    expect(container.innerHTML).not.toContain("subject-subject-arabic");
  });

  it("resolves the subject colour var from a bare token too", () => {
    const { container } = render(
      <SubjectPathCard
        subject={{ ...base, color_token: "math" }}
        stat={undefined}
        premiumLocked={false}
      />,
    );
    expect(container.innerHTML).toContain("var(--subject-math)");
    expect(container.innerHTML).not.toContain("subject-subject-math");
  });

  it("renders the mapped lucide icon instead of the Sword fallback", () => {
    const mapped = render(
      <SubjectPathCard
        subject={{ ...base, icon: "Calculator" }}
        stat={undefined}
        premiumLocked={false}
      />,
    )
      .container.querySelector("svg")
      ?.getAttribute("class");
    const fallback = render(
      <SubjectPathCard
        subject={{ ...base, icon: "DefinitelyNotAnIcon" }}
        stat={undefined}
        premiumLocked={false}
      />,
    )
      .container.querySelector("svg")
      ?.getAttribute("class");
    expect(mapped).toBeTruthy();
    expect(mapped).not.toEqual(fallback); // Calculator was resolved, not collapsed to Sword
  });
});
