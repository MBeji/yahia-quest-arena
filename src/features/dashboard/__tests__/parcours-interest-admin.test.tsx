import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";

vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    parcoursInterest: {
      colProgram: "Program",
      colInterest: "Interested",
      empty: "No interest yet.",
    },
  }),
}));

import { ParcoursInterestAdmin } from "../components/parcours-interest-admin";

describe("ParcoursInterestAdmin", () => {
  it("shows the empty state when there are no counts", () => {
    render(<ParcoursInterestAdmin counts={[]} />);
    expect(screen.getByText("No interest yet.")).toBeInTheDocument();
  });

  it("renders a ranked row per program with its count", () => {
    render(
      <ParcoursInterestAdmin
        counts={[
          { parcoursId: "a", name: "Alpha", count: 9 },
          { parcoursId: "b", name: "Beta", count: 4 },
        ]}
      />,
    );
    expect(screen.getByText("Alpha")).toBeInTheDocument();
    expect(screen.getByText("9")).toBeInTheDocument();
    expect(screen.getByText("Beta")).toBeInTheDocument();
    expect(screen.getByText("4")).toBeInTheDocument();
    // Rank column (1-based).
    expect(screen.getByText("1")).toBeInTheDocument();
    expect(screen.getByText("2")).toBeInTheDocument();
  });
});
