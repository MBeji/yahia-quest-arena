import { render, screen, act } from "@testing-library/react";
import { describe, expect, it, vi, beforeEach, afterEach } from "vitest";
import React from "react";
import { BossChrono } from "@/features/quest/components/boss-chrono";

vi.mock("@/shared/constants/gamification", () => ({
  BOSS_PAR_SECONDS_PER_QUESTION: 10,
  BOSS_SPEED_WEIGHTS: { critical: 1, fast: 0.75, steady: 0.5 },
  BOSS_RANK_MIN_DAMAGE: { critical: 90, fast: 65 },
}));

// lucide-react icons are not needed for logic tests
vi.mock("lucide-react", () => ({
  Timer: () => React.createElement("span", { "data-testid": "timer-icon" }),
}));

const play = vi.fn();
vi.mock("@/lib/sound", () => ({ useSound: () => ({ play }) }));

describe("BossChrono — chronomètre ouvert", () => {
  beforeEach(() => {
    vi.useFakeTimers();
    play.mockClear();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it("démarre à zéro quand il est actif", () => {
    render(React.createElement(BossChrono, { active: true, questionIndex: 0 }));
    expect(screen.getByText("0s")).toBeInTheDocument();
  });

  it("ne démarre pas quand il est inactif", () => {
    render(React.createElement(BossChrono, { active: false, questionIndex: 0 }));
    act(() => {
      vi.advanceTimersByTime(5000);
    });
    expect(screen.getByText("0s")).toBeInTheDocument();
  });

  it("compte à l'endroit, une seconde par seconde", () => {
    render(React.createElement(BossChrono, { active: true, questionIndex: 0 }));
    act(() => {
      vi.advanceTimersByTime(3000);
    });
    expect(screen.getByText("3s")).toBeInTheDocument();
  });

  it("ne s'arrête JAMAIS au temps de référence — c'est tout l'objet du lot", () => {
    render(React.createElement(BossChrono, { active: true, questionIndex: 0 }));
    act(() => {
      vi.advanceTimersByTime(45_000); // 4,5× le temps de référence
    });
    expect(screen.getByText("45s")).toBeInTheDocument();
  });

  it("passe en minutes:secondes au-delà de la minute", () => {
    render(React.createElement(BossChrono, { active: true, questionIndex: 0 }));
    act(() => {
      vi.advanceTimersByTime(127_000);
    });
    expect(screen.getByText("2:07")).toBeInTheDocument();
  });

  it("est doré tant qu'on est sous le temps de référence, atténué au-delà", () => {
    render(React.createElement(BossChrono, { active: true, questionIndex: 0 }));
    act(() => {
      vi.advanceTimersByTime(9000); // 9 < 10
    });
    expect(screen.getByText("9s").className).toContain("--gold");

    act(() => {
      vi.advanceTimersByTime(3000); // 12 > 10
    });
    const late = screen.getByText("12s");
    expect(late.className).toContain("text-muted-foreground");
    // Aucune alarme : le rouge clignotant du compte à rebours a disparu.
    expect(late.className).not.toContain("animate-pulse");
    expect(late.className).not.toContain("text-destructive");
  });

  it("sonne UNE fois quand la fenêtre du coup critique se referme, puis se tait", () => {
    render(React.createElement(BossChrono, { active: true, questionIndex: 0 }));
    act(() => {
      vi.advanceTimersByTime(9000);
    });
    expect(play).not.toHaveBeenCalled();

    act(() => {
      vi.advanceTimersByTime(1000); // pile au temps de référence
    });
    expect(play).toHaveBeenCalledTimes(1);
    expect(play).toHaveBeenCalledWith("tick");

    act(() => {
      vi.advanceTimersByTime(20_000); // longtemps après : plus rien
    });
    expect(play).toHaveBeenCalledTimes(1);
  });

  it("repart de zéro à la question suivante", () => {
    const { rerender } = render(
      React.createElement(BossChrono, { active: true, questionIndex: 0 }),
    );
    act(() => {
      vi.advanceTimersByTime(6000);
    });
    expect(screen.getByText("6s")).toBeInTheDocument();

    rerender(React.createElement(BossChrono, { active: true, questionIndex: 1 }));
    expect(screen.getByText("0s")).toBeInTheDocument();

    act(() => {
      vi.advanceTimersByTime(2000);
    });
    expect(screen.getByText("2s")).toBeInTheDocument();
  });

  it("se fige quand il devient inactif (correction à l'écran)", () => {
    const { rerender } = render(
      React.createElement(BossChrono, { active: true, questionIndex: 0 }),
    );
    act(() => {
      vi.advanceTimersByTime(3000);
    });

    rerender(React.createElement(BossChrono, { active: false, questionIndex: 0 }));
    act(() => {
      vi.advanceTimersByTime(5000);
    });
    expect(screen.getByText("3s")).toBeInTheDocument();
  });
});
