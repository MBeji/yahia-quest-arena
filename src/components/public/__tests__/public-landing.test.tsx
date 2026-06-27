import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({
    children,
    to,
    params,
  }: {
    children: React.ReactNode;
    to: string;
    params?: Record<string, string>;
  }) =>
    React.createElement(
      "a",
      { href: params ? to.replace(/\$(\w+)/g, (_m, k: string) => params[k] ?? `$${k}`) : to },
      children,
    ),
}));
vi.mock("@/hooks/use-mobile", () => ({ useIsMobile: () => true }));
vi.mock("@/components/landing/golden-hero-canvas", () => ({ default: () => null }));
// The landing's game-block CTA is auth-aware; drive both states.
const mockUseAuth = vi.fn();
vi.mock("@/features/auth", () => ({ useAuth: () => mockUseAuth() }));

import { PublicLanding } from "../public-landing";

describe("PublicLanding", () => {
  beforeEach(() => {
    mockUseAuth.mockReturnValue({ user: null, session: null, loading: false });
  });

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

  it("highlights the two transverse language tracks with their CEFR ladder", () => {
    const { container } = render(<PublicLanding />);
    // Two language cards, each deep-linking to its public level page.
    expect(container.querySelectorAll('a[href^="/niveau/"]')).toHaveLength(2);
    expect(container.querySelector('a[href="/niveau/francais"]')).not.toBeNull();
    expect(container.querySelector('a[href="/niveau/anglais"]')).not.toBeNull();
    // The full A1 → C2 CEFR ladder is surfaced on both cards (6 levels × 2).
    expect(screen.getAllByText("A1")).toHaveLength(2);
    expect(screen.getAllByText("C2")).toHaveLength(2);
    // International-standard alignment is shown (FR locale → CECRL + DELF/DALF).
    expect(screen.getByText(/DELF/)).toBeInTheDocument();
  });

  it("keeps the game register as a single secondary block with a signup CTA", () => {
    const { container } = render(<PublicLanding />);
    expect(screen.getByText(/Apprends en jouant/)).toBeInTheDocument();
    expect(container.querySelector('a[href="/signup"]')).not.toBeNull();
  });

  it("signed-in: the game block CTA routes to the dashboard, never signup", () => {
    mockUseAuth.mockReturnValue({ user: { id: "u1" }, session: {}, loading: false });
    const { container } = render(<PublicLanding />);
    expect(container.querySelector('a[href="/dashboard"]')).not.toBeNull();
    expect(container.querySelector('a[href="/signup"]')).toBeNull();
    // The catalogue entry stays available to a signed-in visitor.
    expect(container.querySelector('a[href="/programme"]')).not.toBeNull();
  });
});
