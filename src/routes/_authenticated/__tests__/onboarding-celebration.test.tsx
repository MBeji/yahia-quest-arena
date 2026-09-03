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
      welcomeCoins: "+{coins} pièces de bienvenue",
      welcomeFirstQuestCta: "Commencer ma première quête",
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

/**
 * Étude 31 lot 6 — L'ACCUEIL SE TERMINE SUR UNE VICTOIRE (US-9, R-19).
 *
 * Constat n° 8 : « le compte naît à zéro ». La fin de l'accueil renvoyait vers un
 * tableau de bord vide. Deux propriétés :
 *
 *   1. ⭐ la fin est UNE action — la première quête, à un tap. Le tableau de bord
 *      reste atteignable, mais en second : un menu à ce moment-là, c'est une
 *      décision de plus à prendre quand l'élève voulait jouer ;
 *   2. la récompense ne s'affiche que si elle a RÉELLEMENT été versée — l'écran
 *      ne fête pas deux fois un pack déjà pris.
 */
describe("CelebrationStep — la récompense de bienvenue (é31 lot 6)", () => {
  const welcome = { coins: 30, firstExerciseId: "ex-1" };

  it("⭐ propose la première quête en action principale", () => {
    const onFirstQuest = vi.fn();
    render(
      <CelebrationStep
        parcours={available as never}
        landing="/dashboard"
        onGo={vi.fn()}
        welcome={welcome}
        onFirstQuest={onFirstQuest}
      />,
    );
    fireEvent.click(screen.getByTestId("onboarding-first-quest"));
    expect(onFirstQuest).toHaveBeenCalledWith("ex-1");
  });

  it("affiche les pièces de bienvenue", () => {
    render(
      <CelebrationStep
        parcours={available as never}
        landing="/dashboard"
        onGo={vi.fn()}
        welcome={welcome}
        onFirstQuest={vi.fn()}
      />,
    );
    expect(screen.getByTestId("onboarding-welcome-coins").textContent).toContain("30");
  });

  it("⭐ ne fête rien quand la récompense a déjà été prise", () => {
    render(
      <CelebrationStep
        parcours={available as never}
        landing="/dashboard"
        onGo={vi.fn()}
        welcome={{ coins: 0, firstExerciseId: "ex-1" }}
        onFirstQuest={vi.fn()}
      />,
    );
    expect(screen.queryByTestId("onboarding-welcome-coins")).not.toBeInTheDocument();
    // Mais la première quête reste proposée : elle n'est pas une récompense.
    expect(screen.getByTestId("onboarding-first-quest")).toBeInTheDocument();
  });

  it("retombe sur le tableau de bord quand aucune quête n'est désignée", () => {
    const onGo = vi.fn();
    render(
      <CelebrationStep
        parcours={available as never}
        landing="/dashboard"
        onGo={onGo}
        welcome={{ coins: 30, firstExerciseId: null }}
        onFirstQuest={vi.fn()}
      />,
    );
    expect(screen.queryByTestId("onboarding-first-quest")).not.toBeInTheDocument();
    fireEvent.click(screen.getByText("Voir mon tableau de bord"));
    expect(onGo).toHaveBeenCalledWith("/dashboard");
  });
});
