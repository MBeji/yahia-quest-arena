// @vitest-environment node
import { describe, expect, it } from "vitest";

import { checkGuardrails, GUARDRAILS, prixOuLesDeuxTiennent } from "../assertions.mjs";

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

describe("prixOuLesDeuxTiennent — l'intervalle où G-3 et G-4 s'accordent (#937)", () => {
  // Les valeurs mesurées du persona moyen au 2026-09-03 : 256 coins gagnés,
  // 32 jours manqués. Ce sont elles qui rendent l'échec de G-4 lisible.
  const moyen = { coinsEarned: 256, daysMissed: 32 };

  it("rend l'ensemble EXACT, trous compris — pas un min et un max", () => {
    // Le piège que ce test verrouille : au-delà de 128 le rachat ne couvre plus
    // qu'un seul jour, et G-3 retombe sous son plancher jusqu'à ce que le prix
    // atteigne 60 % des coins à lui seul. Rendre « 37 à 256 » serait FAUX —
    // 129 à 153 ne conviennent pas.
    expect(prixOuLesDeuxTiennent(moyen)).toEqual([
      { min: 37, max: 128 },
      { min: 154, max: 256 },
    ]);
  });

  it("chaque prix rendu satisfait VRAIMENT les deux garde-fous, et les autres non", () => {
    const tient = (k) => {
      const rachetables = Math.floor(moyen.coinsEarned / k);
      return (
        (rachetables * k) / moyen.coinsEarned >= GUARDRAILS.G3.minSinkRatio &&
        rachetables / moyen.daysMissed <= GUARDRAILS.G4.maxRecoveryCoverage
      );
    };
    const dansLesPlages = (k) => prixOuLesDeuxTiennent(moyen).some((p) => k >= p.min && k <= p.max);
    // Contrôle exhaustif : la fonction et la définition disent la même chose.
    for (let k = 1; k <= moyen.coinsEarned; k++) expect(dansLesPlages(k)).toBe(tient(k));
    // Et le prix courant en est dehors — c'est bien pourquoi G-4 échoue.
    expect(dansLesPlages(15)).toBe(false);
  });

  it("rend une liste VIDE quand rien ne se concilie, plutôt qu'un intervalle inventé", () => {
    // Aucun jour manqué : G-4 n'a rien à mesurer, la question ne se pose pas.
    expect(prixOuLesDeuxTiennent({ coinsEarned: 256, daysMissed: 0 })).toEqual([]);
    expect(prixOuLesDeuxTiennent({ coinsEarned: 0, daysMissed: 32 })).toEqual([]);
  });

  it("le message d'échec de G-4 porte l'intervalle et le prix courant", () => {
    const results = checkGuardrails(
      runs({ moyen: run({ coinsEarned: 256, daysMissed: 32, recoveryCoverableDays: 17 }) }),
    );
    const g4 = results.find((r) => r.id === "G-4");
    expect(g4.ok).toBe(false);
    expect(g4.message).toMatch(/37–128/);
    expect(g4.message).toMatch(/154–256/);
    // Il ne donne PAS d'ordre : les deux sorties faciles restent interdites.
    expect(g4.message).toMatch(/Ce n'est pas une consigne/);
  });
});
