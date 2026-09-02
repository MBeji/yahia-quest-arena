import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

const play = vi.fn();
vi.mock("@/lib/sound", () => ({ useSound: () => ({ play }) }));
vi.mock("@/features/quest/components/confetti", () => ({ Confetti: () => null }));
vi.mock("@/shared/lib/product-events", () => ({ trackProductEvent: vi.fn() }));
import { trackProductEvent } from "@/shared/lib/product-events";

import { LeaguePodium } from "../components/league-podium";

/**
 * Étude 31 lot 5 — LE PODIUM DE LIGUE (US-6).
 *
 * Constat n° 6 : « la ligue se termine dans le SILENCE ». Ce composant est ce que
 * l'élève trouve en arrivant. Deux propriétés le rendent utile plutôt que
 * pénible :
 *
 *   1. ⭐ il se montre UNE FOIS. Une fête rejouée à chaque visite cesse d'être une
 *      fête, et devient un obstacle entre l'élève et son écran ;
 *   2. ⭐ il ne relance RIEN (R-6) : une fin de cycle est une fin. Le seul bouton
 *      ferme.
 */

const AWARD = { weekStart: "2026-08-24", tier: "gold", rank: 3, points: 12, coins: 25 };

beforeEach(() => {
  window.localStorage.clear();
  play.mockClear();
  vi.mocked(trackProductEvent).mockClear();
});

describe("LeaguePodium", () => {
  it("célèbre le résultat : rang, palier, gain, et un son", () => {
    render(<LeaguePodium award={AWARD} />);
    const podium = screen.getByTestId("league-podium");
    expect(podium.textContent).toContain("3");
    expect(podium.textContent).toContain("25");
    expect(play).toHaveBeenCalledWith("victory");
  });

  it("⭐ ne se montre qu'UNE fois par semaine de ligue", () => {
    const { unmount } = render(<LeaguePodium award={AWARD} />);
    expect(screen.getByTestId("league-podium")).toBeInTheDocument();
    unmount();

    render(<LeaguePodium award={AWARD} />);
    expect(screen.queryByTestId("league-podium")).not.toBeInTheDocument();
  });

  it("mais revient pour la semaine SUIVANTE", () => {
    const { unmount } = render(<LeaguePodium award={AWARD} />);
    unmount();
    render(<LeaguePodium award={{ ...AWARD, weekStart: "2026-08-31" }} />);
    expect(screen.getByTestId("league-podium")).toBeInTheDocument();
  });

  it("émet `league_awarded` — le virement de 02:30 n'avait jamais rien mesuré", () => {
    render(<LeaguePodium award={AWARD} />);
    expect(trackProductEvent).toHaveBeenCalledWith("league_awarded", { tier: "gold", rank: 3 });
  });

  it("⭐ ne propose aucun enchaînement : les deux boutons ferment (R-6)", () => {
    render(<LeaguePodium award={AWARD} />);
    const buttons = screen.getByTestId("league-podium").querySelectorAll("button");
    expect(buttons).toHaveLength(2);
    for (const button of buttons) {
      expect(button.closest("a")).toBeNull();
    }
  });

  it("ne rend rien sans résultat de ligue", () => {
    render(<LeaguePodium award={null} />);
    expect(screen.queryByTestId("league-podium")).not.toBeInTheDocument();
    expect(play).not.toHaveBeenCalled();
  });
});
