import { render, screen } from "@testing-library/react";
import { describe, it, expect } from "vitest";
import React from "react";

import { EconomyAdmin } from "../components/economy-admin";
import type { EconomyOverview } from "../economy.server";

/**
 * Étude 09 lot 1 — la page « Économie ».
 *
 * Ce qui est mis à l'épreuve n'est pas la mise en page, c'est l'HONNÊTETÉ des
 * chiffres affichés — les deux façons dont une page d'analytics nuit :
 *
 *   * elle présente une ESTIMATION comme un relevé (les sources de coins sont
 *     reconstruites, D-5) ;
 *   * elle invente un chiffre là où il n'y a pas de donnée (« 0 % d'inflation »
 *     sur une économie à l'arrêt, « 0 jour » pour un palier que personne n'a
 *     franchi). Un tiret est une réponse ; un zéro faux est une décision prise
 *     sur du vide.
 */

function overview(over: Partial<EconomyOverview> = {}): EconomyOverview {
  return {
    xp_daily: { p50: 75, p90: 150, max: 300, active_days: 12 },
    level_velocity: [{ level_reached: 2, students: 4, p50_days: 3.5, p90_days: 9 }],
    coin_flows: { sources_earned: 500, sinks_shop: 400, sink_ratio: 0.8 },
    consumables: [
      {
        code: "potion_xp_boost",
        name: "Potion XP x2",
        item_type: "potion",
        price_coins: 50,
        acquired: 10,
        still_armed: 7,
        consumed: 3,
        holders: 5,
      },
    ],
    premium_funnel: {
      active_30d: 12,
      entitled_total: 0,
      active_entitled: 0,
      premium_parcours: 0,
    },
    notes: { coins_exclude_potion_multipliers: true, xp_per_level: 200 },
    ...over,
  };
}

describe("EconomyAdmin — la page ne ment pas sur ses chiffres", () => {
  it("rend la distribution en percentiles, pas une moyenne (RISK-1)", () => {
    render(<EconomyAdmin data={overview()} />);
    const xp = screen.getByTestId("econ-xp");
    expect(xp.textContent).toContain("p50");
    expect(xp.textContent).toContain("p90");
    expect(xp.textContent).toContain("max");
    // Aucune « moyenne » nulle part : c'est ce qui masque l'élève qui décroche.
    expect(xp.textContent?.toLowerCase()).not.toContain("moyenne");
  });

  it("ne présente plus les sources comme une ESTIMATION — elles sont calculées", () => {
    const { container } = render(<EconomyAdmin data={overview()} />);
    const text = container.textContent ?? "";
    // La prémisse de D-5 est tombée : `attempts.xp_earned > 0` signe
    // l'éligibilité, `exercises.reward_coins` donne le forfait. Le seul écart
    // restant est la potion, et il est NOMMÉ plutôt que noyé dans « estimé ».
    expect(text).toContain("versées");
    expect(text.toLowerCase()).toContain("potion");
  });

  it("alerte quand les puits absorbent moins de 60 % des sources", () => {
    render(
      <EconomyAdmin
        data={overview({
          coin_flows: { sources_earned: 1000, sinks_shop: 100, sink_ratio: 0.1 },
        })}
      />,
    );
    expect(screen.getByTestId("econ-inflation-warning")).toBeTruthy();
  });

  it("n'alerte pas quand l'économie draine correctement", () => {
    render(<EconomyAdmin data={overview()} />); // ratio 0.8
    expect(screen.queryByTestId("econ-inflation-warning")).toBeNull();
  });

  it("n'invente PAS un pourcentage quand rien n'a été gagné", () => {
    render(
      <EconomyAdmin
        data={overview({
          coin_flows: { sources_earned: 0, sinks_shop: 0, sink_ratio: null },
        })}
      />,
    );
    // Un tiret, pas « 0 % » — et surtout pas d'alerte d'inflation sur du vide.
    expect(screen.getByTestId("econ-coins").textContent).toContain("—");
    expect(screen.queryByTestId("econ-inflation-warning")).toBeNull();
  });

  it("dit « personne n'a franchi de palier » au lieu d'un tableau vide", () => {
    render(<EconomyAdmin data={overview({ level_velocity: [] })} />);
    expect(screen.getByTestId("econ-levels-empty")).toBeTruthy();
    expect(screen.queryByTestId("econ-levels")).toBeNull();
  });

  it("montre armés ET consommés — un objet jamais consommé est le signal", () => {
    render(<EconomyAdmin data={overview()} />);
    const table = screen.getByTestId("econ-consumables");
    expect(table.textContent).toContain("Potion XP x2");
    expect(table.textContent).toContain("7"); // encore armés
    expect(table.textContent).toContain("3"); // consommés
  });

  it("garde la section funnel visible à zéro — dormante, pas absente", () => {
    render(<EconomyAdmin data={overview()} />);
    // En phase gratuite tout est à zéro ; masquer la section la ferait oublier
    // le jour où la phase change.
    expect(screen.getByTestId("econ-funnel")).toBeTruthy();
  });
});
