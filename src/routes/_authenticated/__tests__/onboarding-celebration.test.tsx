import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

vi.mock("motion/react", () => ({
  motion: {
    div: ({ children, ...p }: { children?: React.ReactNode }) =>
      React.createElement("div", p, children),
  },
  useReducedMotion: () => true,
}));
vi.mock("@/shared/lib/parcours-locale", () => ({
  parcoursName: (p: { name_fr: string }) => p.name_fr,
}));
vi.mock("@/lib/i18n", () => ({
  useI18n: () => ({ locale: "fr" }),
  useT: () => ({
    onboarding: {
      celebrateTitle: "C'est parti !",
      celebrateDesc: "Bienvenue dans {parcours}. Ton tableau de bord t'attend.",
      celebrateSoonTitle: "Ta classe arrive bientôt",
      celebrateSoonDesc: "{parcours} est en construction. En attendant, explore les extras.",
      celebrateExtrasCta: "Explorer les extras",
      celebrateDashboardCta: "Voir mon tableau de bord",
    },
  }),
}));

import { CelebrationStep } from "../onboarding";

const available = { id: "ecole-9eme-base", name_fr: "9ème année de base", status: "available" };
const soon = { id: "concours-bac-math", name_fr: "Bac Mathématiques", status: "coming_soon" };

describe("CelebrationStep (onboarding v2)", () => {
  it("an available class celebrates and lands on the (deep-linked) dashboard target", () => {
    const onGo = vi.fn();
    render(<CelebrationStep parcours={available as never} landing="/matiere/x" onGo={onGo} />);
    expect(screen.getByText("C'est parti !")).toBeInTheDocument();
    expect(screen.getByText(/Bienvenue dans 9ème année de base/)).toBeInTheDocument();
    fireEvent.click(screen.getByText("Voir mon tableau de bord"));
    expect(onGo).toHaveBeenCalledWith("/matiere/x");
  });

  it("a coming-soon class gets the « ta classe arrive » welcome pointing to the extras (Q-6 opt. A)", () => {
    const onGo = vi.fn();
    render(<CelebrationStep parcours={soon as never} landing="/dashboard" onGo={onGo} />);
    expect(screen.getByText("Ta classe arrive bientôt")).toBeInTheDocument();
    expect(screen.getByText(/Bac Mathématiques est en construction/)).toBeInTheDocument();
    fireEvent.click(screen.getByText("Explorer les extras"));
    expect(onGo).toHaveBeenCalledWith("/extras");
    // the dashboard remains a secondary destination
    fireEvent.click(screen.getByText("Voir mon tableau de bord"));
    expect(onGo).toHaveBeenCalledWith("/dashboard");
  });
});
