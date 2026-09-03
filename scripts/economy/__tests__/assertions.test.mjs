// @vitest-environment node
import { describe, expect, it } from "vitest";

import { checkGuardrails, GUARDRAILS, prixMinimumPourG4 } from "../assertions.mjs";
import { shopCapacityCoins, shopPrices } from "../shop-catalogue.mjs";

/** Un run simulé réduit à ce que les garde-fous lisent. */
const run = (over = {}) => ({
  levelFiveDay: 20,
  xpTotal: 900,
  level: 5,
  weeks: Array.from({ length: 8 }),
  maxXpInADay: 200,
  coinsEarned: 100,
  recoveryCoverableDays: 2,
  // `daysMissed`, et non `missedDays` : c'est la clé que lit `assertions.mjs`.
  // Avec la faute, G-4 mesurait `undefined` jours et rendait le message
  // « 0 % des undefined jours manqués » — vert, et sans objet.
  daysMissed: 30,
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

describe("G-3 lit la BOUTIQUE, et G-4 gouverne seul le rachat (#937)", () => {
  const moyen = { coinsEarned: 256, daysMissed: 32, recoveryCoverableDays: 17 };

  it("le catalogue est lu dans les migrations, pas recopié", () => {
    // Une seconde liste tenue à la main divergerait — le dépôt l'a déjà vécu deux
    // fois (`auth-refusals.ts`). Ces bornes sont épinglées pour qu'AJOUTER un objet
    // en boutique fasse tomber ce test : la mise à jour devient délibérée.
    const prix = shopPrices();
    expect(prix).toHaveLength(19);
    expect(Math.min(...prix)).toBe(30);
    expect(Math.max(...prix)).toBe(500);
    expect(shopCapacityCoins()).toBe(3280);
  });

  it("G-3 ne dépend PLUS du prix du rachat — c'était tout le défaut", () => {
    // Avant, G-3 mesurait `recoveryCoverableDays × STREAK_RECOVERY_COST` : il
    // récompensait donc un rachat bon marché, pendant que G-4 en exige un cher.
    // Faire varier ce champ ne doit plus rien changer à G-3.
    const g3 = (over) =>
      checkGuardrails(runs({ moyen: run({ ...moyen, ...over }) })).find((r) => r.id === "G-3");
    expect(g3({ recoveryCoverableDays: 0 }).ok).toBe(true);
    expect(g3({ recoveryCoverableDays: 17 }).message).toBe(
      g3({ recoveryCoverableDays: 0 }).message,
    );
  });

  it("G-3 échoue si la boutique ne peut plus absorber ce que le jeu produit", () => {
    // Le fil-piège : des récompenses qui s'envolent (ou une boutique vidée).
    const g3 = checkGuardrails(runs({ moyen: run({ ...moyen, coinsEarned: 100_000 }) })).find(
      (r) => r.id === "G-3",
    );
    expect(g3.ok).toBe(false);
    expect(g3.message).toMatch(/s'accumulent/);
  });

  it("G-4 dit le prix MINIMUM, et se garde de donner un ordre", () => {
    const g4 = checkGuardrails(runs({ moyen: run(moyen) })).find((r) => r.id === "G-4");
    expect(g4.ok).toBe(false);
    // floor(256 / (floor(32 × 0,2) + 1)) + 1 = floor(256/7) + 1 = 37.
    expect(prixMinimumPourG4(moyen)).toBe(37);
    expect(g4.message).toMatch(/au moins 37/);
    expect(g4.message).toMatch(/PAS une consigne/);
  });

  it("le prix minimum est la VRAIE borne : 37 passe, 36 non", () => {
    const tient = (k) =>
      Math.floor(moyen.coinsEarned / k) / moyen.daysMissed <= GUARDRAILS.G4.maxRecoveryCoverage;
    expect(tient(prixMinimumPourG4(moyen))).toBe(true);
    expect(tient(prixMinimumPourG4(moyen) - 1)).toBe(false);
  });
});
