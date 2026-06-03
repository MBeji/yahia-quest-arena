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
    render(<SubjectPathCard subject={base} stat={{ count: 3, avg: 82 }} hasSubscription={false} />);
    expect(screen.getByText("Mathématiques")).toBeInTheDocument();
    expect(screen.getByText(/Force/)).toBeInTheDocument();
    expect(screen.getByText(/3 quest/)).toBeInTheDocument();
    expect(screen.getByText("82%")).toBeInTheDocument();
  });

  it("shows a dash for the average when there is no stat", () => {
    render(<SubjectPathCard subject={base} stat={undefined} hasSubscription={false} />);
    expect(screen.getByText("—")).toBeInTheDocument();
  });

  it("shows a Premium badge on premium subjects", () => {
    render(
      <SubjectPathCard subject={{ ...base, is_premium: true }} stat={undefined} hasSubscription />,
    );
    expect(screen.getByText("Premium")).toBeInTheDocument();
  });

  it("does not show a Premium badge on regular subjects", () => {
    render(<SubjectPathCard subject={base} stat={undefined} hasSubscription={false} />);
    expect(screen.queryByText("Premium")).not.toBeInTheDocument();
  });
});
