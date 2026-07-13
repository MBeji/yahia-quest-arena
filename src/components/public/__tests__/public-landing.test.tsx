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

  it("presents the Espace Famille section with the 3-step linking flow and a parent CTA", () => {
    const { container } = render(<PublicLanding />);
    const famille = container.querySelector('[data-testid="famille-block"]');
    expect(famille).not.toBeNull();
    expect(famille?.id).toBe("espace-famille");
    // The four value props of the actionable family report.
    expect(screen.getByText(/points forts et chapitres à renforcer/i)).toBeInTheDocument();
    expect(screen.getByText(/conseil de la semaine/i)).toBeInTheDocument();
    expect(screen.getByText(/bilan imprimable/i)).toBeInTheDocument();
    // Signed-out: the CTA routes to the auth page (signup mode, parent role preselected).
    expect(screen.getByText("Créer mon compte parent").closest("a")?.getAttribute("href")).toBe(
      "/auth",
    );
  });

  it("signed-in: the famille CTA opens the parent report instead of signup", () => {
    mockUseAuth.mockReturnValue({ user: { id: "u1" }, session: {}, loading: false });
    const { container } = render(<PublicLanding />);
    expect(container.querySelector('a[href="/parent-report"]')).not.toBeNull();
    expect(screen.getByText("Ouvrir le suivi parental")).toBeInTheDocument();
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

  it("renders the proof band with real numbers and a sample-course deep link", () => {
    const { container } = render(
      <PublicLanding
        stats={{ subjects: 62, lessons: 418, exercises: 3250, sampleChapterId: "chap-1" }}
      />,
    );
    expect(screen.getByText("62")).toBeInTheDocument();
    expect(screen.getByText("418")).toBeInTheDocument();
    // thousands are grouped with a space (Western digits, all locales).
    expect(screen.getByText("3 250")).toBeInTheDocument();
    // « Voir un exemple de cours » deep-links into the public reader.
    expect(container.querySelector('a[href="/chapitre/chap-1"]')).not.toBeNull();
  });

  it("omits the proof band when there are no stats or an empty catalogue", () => {
    const { container: noStats } = render(<PublicLanding />);
    expect(noStats.querySelector('a[href^="/chapitre/"]')).toBeNull();
    const { container: empty } = render(
      <PublicLanding stats={{ subjects: 0, lessons: 0, exercises: 0, sampleChapterId: null }} />,
    );
    expect(empty.querySelector('a[href^="/chapitre/"]')).toBeNull();
  });
});
