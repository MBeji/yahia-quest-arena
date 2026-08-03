import { describe, it, expect } from "vitest";

import {
  CANONICAL_COINS_BY_DIFFICULTY,
  CANONICAL_XP_BY_DIFFICULTY,
  levelFor,
  makeRng,
  scoreAttempt,
  simulate,
} from "../simulate.mjs";

/**
 * Étude 09 lot 2 — le moteur du simulateur.
 *
 * Un simulateur d'équilibrage n'est utile que s'il rejoue la VRAIE règle. S'il
 * dérive, il valide une économie fantôme et donne un faux sentiment de sécurité
 * (RISK-3). Ces tests fixent donc la règle telle que `submit_exercise_attempt`
 * l'applique — vérifiée dans le SQL, pas dans l'énoncé de l'étude, qui décrivait
 * une règle de demi-coins que le moteur n'a jamais eue.
 */

describe("scoreAttempt — la règle du RPC, à la lettre", () => {
  const base = { difficulty: 2, secondsPerQuestion: 10, previousBestPct: null };

  it("d2 à 100 % rapporte le barème plein", () => {
    const r = scoreAttempt({ ...base, scorePct: 100 });
    expect(r.xp).toBe(CANONICAL_XP_BY_DIFFICULTY[2]); // 75
    expect(r.coins).toBe(CANONICAL_COINS_BY_DIFFICULTY[2]);
  });

  it("l'XP est PROPORTIONNEL au score, les coins sont un FORFAIT", () => {
    const r = scoreAttempt({ ...base, scorePct: 80 });
    expect(r.xp).toBe(Math.round(75 * 0.8)); // 60
    // Le forfait ne suit pas le score : c'est `exercises.reward_coins`.
    expect(r.coins).toBe(CANONICAL_COINS_BY_DIFFICULTY[2]);
  });

  it("sous 60 %, RIEN — ni XP ni coins (l'éligibilité est binaire)", () => {
    const r = scoreAttempt({ ...base, scorePct: 45 });
    expect(r.xp).toBe(0);
    expect(r.coins).toBe(0);
    expect(r.passed).toBe(false);
  });

  it("aucune règle de demi-coins n'existe — 45 % ne vaut pas la moitié", () => {
    // L'étude 09 décrivait « demi-coins entre 40 et 59 % ». Le RPC ne
    // l'implémente pas : ce test est le garde qui empêche de la réintroduire.
    expect(scoreAttempt({ ...base, scorePct: 45 }).coins).toBe(0);
    expect(scoreAttempt({ ...base, scorePct: 59 }).coins).toBe(0);
    expect(scoreAttempt({ ...base, scorePct: 60 }).coins).toBeGreaterThan(0);
  });

  it("précipité : rien, même à 100 % (anti-rush)", () => {
    const r = scoreAttempt({ ...base, scorePct: 100, secondsPerQuestion: 2 });
    expect(r.xp).toBe(0);
    expect(r.coins).toBe(0);
    expect(r.tooFast).toBe(true);
  });

  it("re-tentative NON améliorante : rien (anti-farm)", () => {
    const r = scoreAttempt({ ...base, scorePct: 80, previousBestPct: 90 });
    expect(r.xp).toBe(0);
    expect(r.improved).toBe(false);
  });

  it("re-tentative améliorante : payée", () => {
    const r = scoreAttempt({ ...base, scorePct: 95, previousBestPct: 90 });
    expect(r.xp).toBeGreaterThan(0);
    expect(r.improved).toBe(true);
  });
});

describe("levelFor — la seule formule de progression", () => {
  it("part du niveau 1 et monte tous les 200 XP", () => {
    expect(levelFor(0)).toBe(1);
    expect(levelFor(199)).toBe(1);
    expect(levelFor(200)).toBe(2);
    // ⚠️ Le niveau 5 est à 800 XP, pas 1 000 : l'étude écrit « niveau 5
    // (1 000 XP) », ce qui est le niveau 6. On suit le niveau.
    expect(levelFor(800)).toBe(5);
    expect(levelFor(1000)).toBe(6);
  });
});

describe("simulate — déterminisme et bornes", () => {
  it("deux exécutions rendent EXACTEMENT le même résultat", () => {
    // Sans ça, un garde-fou qui passe un jour et casse le lendemain ne prouve
    // rien — et on irait chercher la cause dans l'économie.
    expect(simulate("moyen")).toEqual(simulate("moyen"));
  });

  it("le PRNG est reproductible à graine égale, différent sinon", () => {
    const a = makeRng(1);
    const b = makeRng(1);
    const c = makeRng(2);
    expect(a()).toBe(b());
    expect(makeRng(1)()).not.toBe(c());
  });

  it("l'assidu gagne plus que le moyen, qui gagne plus que l'occasionnel", () => {
    const assidu = simulate("assidu");
    const moyen = simulate("moyen");
    const occ = simulate("occasionnel");
    expect(assidu.xpTotal).toBeGreaterThan(moyen.xpTotal);
    expect(moyen.xpTotal).toBeGreaterThan(occ.xpTotal);
  });

  it("compte 56 jours (8 semaines), actifs + manqués", () => {
    const r = simulate("moyen");
    expect(r.daysActive + r.daysMissed).toBe(56);
    expect(r.daysActive).toBe(8 * 3); // 3 j/semaine
  });

  it("refuse un persona inconnu plutôt que de simuler du vide", () => {
    expect(() => simulate("fantome")).toThrow(/Persona inconnu/);
  });
});
