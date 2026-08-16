import { render, screen, act } from "@testing-library/react";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { ExamCountdown } from "@/features/exam/components/exam-countdown";

/**
 * Le chrono d'examen — ce qui vaut d'être testé, c'est l'ÉCART D'HORLOGE.
 *
 * La deadline est serveur (R-2) mais le compte à rebours s'affiche côté client.
 * Sans correction, un poste dont l'horloge avance de dix minutes verrait son
 * épreuve se terminer dix minutes trop tôt — un bug qui ne se reproduit que chez
 * la victime, et que personne ne voit en développement puisque le poste de dev
 * est à l'heure.
 */

const DEADLINE = "2026-08-16T12:00:00.000Z";

beforeEach(() => {
  vi.useFakeTimers();
});

afterEach(() => {
  vi.useRealTimers();
});

describe("ExamCountdown", () => {
  it("compte le temps restant depuis l'horloge du poste quand elle est juste", () => {
    vi.setSystemTime(new Date("2026-08-16T11:58:30.000Z"));
    render(<ExamCountdown deadline={DEADLINE} clockOffsetMs={0} />);
    expect(screen.getByRole("timer")).toHaveTextContent("01:30");
  });

  it("corrige une horloge de poste en avance — sinon l'épreuve finit trop tôt", () => {
    // Le poste croit qu'il est 11:59:00 ; le serveur dit 11:58:00.
    vi.setSystemTime(new Date("2026-08-16T11:59:00.000Z"));
    render(<ExamCountdown deadline={DEADLINE} clockOffsetMs={-60_000} />);
    // Il reste 2 minutes (heure serveur), pas 1 (heure du poste).
    expect(screen.getByRole("timer")).toHaveTextContent("02:00");
  });

  it("décompte à la seconde", () => {
    vi.setSystemTime(new Date("2026-08-16T11:59:50.000Z"));
    render(<ExamCountdown deadline={DEADLINE} clockOffsetMs={0} />);
    expect(screen.getByRole("timer")).toHaveTextContent("00:10");

    act(() => {
      vi.advanceTimersByTime(3000);
    });
    expect(screen.getByRole("timer")).toHaveTextContent("00:07");
  });

  it("n'annonce l'expiration qu'une seule fois — un rendu double paierait deux fois", () => {
    vi.setSystemTime(new Date("2026-08-16T11:59:58.000Z"));
    const onExpire = vi.fn();
    render(<ExamCountdown deadline={DEADLINE} clockOffsetMs={0} onExpire={onExpire} />);

    act(() => {
      vi.advanceTimersByTime(10_000);
    });

    expect(onExpire).toHaveBeenCalledTimes(1);
    expect(screen.getByRole("timer")).toHaveTextContent("00:00");
  });

  it("ne descend jamais sous zéro", () => {
    vi.setSystemTime(new Date("2026-08-16T12:05:00.000Z"));
    render(<ExamCountdown deadline={DEADLINE} clockOffsetMs={0} />);
    expect(screen.getByRole("timer")).toHaveTextContent("00:00");
  });

  it("affiche les heures au-delà de soixante minutes", () => {
    vi.setSystemTime(new Date("2026-08-16T10:29:00.000Z"));
    render(<ExamCountdown deadline={DEADLINE} clockOffsetMs={0} />);
    expect(screen.getByRole("timer")).toHaveTextContent("01:31:00");
  });
});
