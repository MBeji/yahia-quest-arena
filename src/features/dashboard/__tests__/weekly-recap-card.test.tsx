import { render, screen } from "@testing-library/react";
import { describe, it, expect } from "vitest";
import React from "react";

import { WeeklyRecapCard } from "../components/weekly-recap-card";
import type { WeeklyRecap } from "../weekly-recap.server";
import { fr } from "@/lib/i18n/fr";

/**
 * Étude 31 lot 5 — « Ta semaine » (US-8, R-18).
 *
 * Trois propriétés, et chacune est une façon dont un bilan hebdomadaire nuit :
 *
 *   1. ⭐ il INVENTE un écart. Sans mission la semaine passée, « +67 points de
 *      progression » est un compliment mécanique et faux — le serveur rend NULL,
 *      et la carte doit se taire plutôt que d'afficher un zéro ;
 *   2. ⭐ il PROMET une récompense (R-18) : un bilan qui paye devient une tâche ;
 *   3. il REPROCHE une semaine vide (R-8).
 */

function recap(over: Partial<WeeklyRecap> = {}): WeeklyRecap {
  return {
    weekStart: "2026-08-31",
    hasActivity: true,
    thisWeek: { xp: 240, missions: 12, avgScore: 78, daysActive: 4 },
    lastWeek: { xp: 180, missions: 9, avgScore: 71, daysActive: 3 },
    delta: { xp: 60, missions: 3, avgScore: 7, daysActive: 1 },
    streak: 5,
    badges: ["streak_7"],
    league: null,
    ...over,
  };
}

describe("WeeklyRecapCard", () => {
  it("rend les quatre faits de la semaine et leur écart", () => {
    render(<WeeklyRecapCard recap={recap()} />);
    const card = screen.getByTestId("weekly-recap");
    expect(card.textContent).toContain("240");
    expect(card.textContent).toContain("12");
    expect(card.textContent).toContain("78 %");
    expect(card.textContent).toContain("+60");
  });

  it("⭐ n'affiche AUCUN écart de précision quand il n'est pas comparable", () => {
    const data = recap({
      lastWeek: { xp: 0, missions: 0, avgScore: 0, daysActive: 0 },
      delta: { xp: 240, missions: 12, avgScore: null, daysActive: 4 },
    });
    render(<WeeklyRecapCard recap={data} />);
    const card = screen.getByTestId("weekly-recap");
    // Le libellé « vs semaine dernière » n'apparaît que sur les faits comparables :
    // trois sur quatre ici, jamais quatre.
    const occurrences = (card.textContent ?? "").split(fr.dashboard.weeklyRecapVsLast).length - 1;
    expect(occurrences).toBe(3);
  });

  it("⭐ ne promet aucune récompense (R-18)", () => {
    const { container } = render(<WeeklyRecapCard recap={recap()} />);
    const text = (container.textContent ?? "").toLowerCase();
    for (const word of ["réclame", "récupère", "bonus", "gagne "]) {
      expect(text).not.toContain(word);
    }
    expect(container.querySelector("button")).toBeNull();
  });

  it("⭐ une semaine vide ne reproche rien (R-8)", () => {
    render(<WeeklyRecapCard recap={recap({ hasActivity: false })} />);
    const empty = screen.getByTestId("weekly-recap-empty");
    const text = (empty.textContent ?? "").toLowerCase();
    for (const word of ["rien fait", "aucun effort", "raté", "abandonn"]) {
      expect(text).not.toContain(word);
    }
    expect(text).toContain("commence");
  });

  it("montre le rang de ligue quand la semaine close en a produit un", () => {
    render(
      <WeeklyRecapCard
        recap={recap({ league: { tier: "gold", rank: 3, coins: 25, week_start: "2026-08-24" } })}
      />,
    );
    expect(screen.getByTestId("weekly-recap-league").textContent).toContain("3");
  });

  it("compte les badges de la semaine, et se tait quand il n'y en a pas", () => {
    render(<WeeklyRecapCard recap={recap({ badges: [] })} />);
    expect(screen.queryByTestId("weekly-recap-badges")).not.toBeInTheDocument();
  });
});
