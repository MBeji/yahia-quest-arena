import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";

vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    dashboard: { quoteLabel: "Quote of the day" },
    quotes: [{ text: "Stay sharp.", author: "Sensei" }],
  }),
}));

import { MotivationalQuote } from "../components/motivational-quote";

describe("MotivationalQuote", () => {
  it("renders the day's quote text and author", () => {
    render(<MotivationalQuote />);
    expect(screen.getByText("Quote of the day")).toBeInTheDocument();
    expect(screen.getByText(/Stay sharp\./)).toBeInTheDocument();
    expect(screen.getByText(/Sensei/)).toBeInTheDocument();
  });
});
