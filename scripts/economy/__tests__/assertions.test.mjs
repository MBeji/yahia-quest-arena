// @vitest-environment node
import { describe, expect, it } from "vitest";

import { checkGuardrails, GUARDRAILS } from "../assertions.mjs";

/** Un run simulé réduit à ce que les garde-fous lisent. */
const run = (over = {}) => ({
  levelFiveDay: 20,
  xpTotal: 900,
  level: 5,
  weeks: Array.from({ length: 8 }),
  maxXpInADay: 200,
  coinsEarned: 100,
  shieldCoverableDays: 2,
  missedDays: 30,
  ...over,
});

const runs = (over = {}) => ({
  assidu: run({ levelFiveDay: 6 }),
  moyen: run({ levelFiveDay: 31 }),
  occasionnel: run({ levelFiveDay: null }),
  ...over,
});

const g1 = (results, persona) => results.find((r) => r.id === `G-1/${persona}`);

describe("G-1 — une fenêtre par profil (arbitrage A15)", () => {
  it("juge les trois profils séparément, plus un seuil unique", () => {
    const ids = checkGuardrails(runs())
      .map((r) => r.id)
      .filter((id) => id.startsWith("G-1"));
    expect(ids).toEqual(["G-1/assidu", "G-1/moyen", "G-1/occasionnel"]);
  });

  it("accepte les mesures RÉELLES du 2026-08-24 — c'est ce que l'arbitrage a acté", () => {
    // assidu J+6, moyen J+31 : les deux échouaient contre l'ancienne fenêtre unique 7-14.
    const results = checkGuardrails(runs());
    expect(g1(results, "assidu").ok).toBe(true);
    expect(g1(results, "moyen").ok).toBe(true);
  });

  it("refuse l'assidu qui monte trop vite — les paliers deviendraient décoratifs", () => {
    const results = checkGuardrails(runs({ assidu: run({ levelFiveDay: 3 }) }));
    expect(g1(results, "assidu").ok).toBe(false);
    expect(g1(results, "assidu").message).toMatch(/AVANT le jour 5/);
  });

  it("refuse le moyen qui décroche — au-delà du mois on sort du rythme scolaire", () => {
    const results = checkGuardrails(runs({ moyen: run({ levelFiveDay: 40 }) }));
    expect(g1(results, "moyen").ok).toBe(false);
    expect(g1(results, "moyen").message).toMatch(/APRÈS le jour 35/);
  });

  it("échoue quand un profil jugé n'atteint JAMAIS le niveau 5", () => {
    const results = checkGuardrails(runs({ moyen: run({ levelFiveDay: null }) }));
    expect(g1(results, "moyen").ok).toBe(false);
    expect(g1(results, "moyen").message).toMatch(/n'atteint jamais/);
  });

  it("ne juge PAS l'occasionnel, même quand il n'atteint jamais le niveau 5", () => {
    // Lui poser un seuil n'encoderait que l'horizon de la simulation.
    const results = checkGuardrails(runs());
    expect(g1(results, "occasionnel").ok).toBe(true);
    expect(g1(results, "occasionnel").message).toMatch(/non jugé/);
  });

  it("accepte les bornes exactes des fenêtres", () => {
    const at = (persona, day) => {
      const r = checkGuardrails(runs({ [persona]: run({ levelFiveDay: day }) }));
      return g1(r, persona).ok;
    };
    expect(at("assidu", GUARDRAILS.G1.assidu.minDays)).toBe(true);
    expect(at("assidu", GUARDRAILS.G1.assidu.maxDays)).toBe(true);
    expect(at("moyen", GUARDRAILS.G1.moyen.minDays)).toBe(true);
    expect(at("moyen", GUARDRAILS.G1.moyen.maxDays)).toBe(true);
  });

  it("garde les fenêtres DISTINCTES — c'est tout l'objet de l'arbitrage", () => {
    // Si un jour elles se rejoignent, on est revenu au seuil unique sans le dire.
    expect(GUARDRAILS.G1.assidu).not.toEqual(GUARDRAILS.G1.moyen);
    expect(GUARDRAILS.G1.occasionnel).toBeNull();
  });
});
