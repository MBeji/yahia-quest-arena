import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));
vi.mock("@/hooks/use-mobile", () => ({ useIsMobile: () => true }));
vi.mock("@/components/landing/golden-hero-canvas", () => ({ default: () => null }));

import { PublicLanding } from "../public-landing";

describe("PublicLanding", () => {
  it("leads with the free family promise and routes into the public catalogue", () => {
    const { container } = render(<PublicLanding />);
    expect(screen.getByRole("heading", { level: 1 }).textContent).toMatch(/école tunisienne/i);
    expect(screen.getByText(/gratuit, pour toute la famille/i)).toBeInTheDocument();
    expect(container.querySelector('a[href="/programme"]')).not.toBeNull();
    expect(container.querySelector('a[href="/extras"]')).not.toBeNull();
  });

  it("shows the 3 persona doors and the 3-cycle preview", () => {
    render(<PublicLanding />);
    expect(screen.getByText("Je suis élève")).toBeInTheDocument();
    expect(screen.getByText("Je suis parent")).toBeInTheDocument();
    expect(screen.getByText("Je suis enseignant")).toBeInTheDocument();
    expect(screen.getByText("Primaire")).toBeInTheDocument();
    expect(screen.getByText("Collège")).toBeInTheDocument();
    expect(screen.getByText("Lycée")).toBeInTheDocument();
  });

  it("keeps the game register as a single secondary block with a signup CTA", () => {
    const { container } = render(<PublicLanding />);
    expect(screen.getByText(/Apprends en jouant/)).toBeInTheDocument();
    expect(container.querySelector('a[href="/signup"]')).not.toBeNull();
  });
});
