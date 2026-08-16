import { describe, expect, it } from "vitest";
import {
  bossDamageFor,
  bossHpForDamage,
  bossRankForDamage,
  bossSpeedTier,
  formatChrono,
} from "@/features/quest/boss-speed";
import { BOSS_PAR_SECONDS_PER_QUESTION } from "@/shared/constants/gamification";

const PAR = BOSS_PAR_SECONDS_PER_QUESTION;

describe("bossSpeedTier", () => {
  it("porte un coup critique jusqu'au temps de référence INCLUS", () => {
    expect(bossSpeedTier(0)).toBe("critical");
    expect(bossSpeedTier(PAR - 1)).toBe("critical");
    expect(bossSpeedTier(PAR)).toBe("critical");
  });

  it("passe au palier intermédiaire juste après, jusqu'au double", () => {
    expect(bossSpeedTier(PAR + 0.5)).toBe("fast");
    expect(bossSpeedTier(PAR * 2)).toBe("fast");
  });

  it("reste au palier bas au-delà, quelle que soit la durée", () => {
    expect(bossSpeedTier(PAR * 2 + 1)).toBe("steady");
    expect(bossSpeedTier(3600)).toBe("steady");
  });
});

describe("bossDamageFor", () => {
  it("ne rend JAMAIS zéro : une question répondue avance toujours le combat", () => {
    for (const seconds of [0, PAR, PAR * 2, PAR * 10, 10_000]) {
      expect(bossDamageFor(seconds, 5)).toBeGreaterThan(0);
    }
  });

  it("répartit les 100 points de HP sur les questions de la manche", () => {
    expect(bossDamageFor(1, 5)).toBeCloseTo(20);
    expect(bossDamageFor(1, 4)).toBeCloseTo(25);
  });

  it("décroît par paliers avec le temps mis, sans rien couper", () => {
    const fastHit = bossDamageFor(1, 5);
    const midHit = bossDamageFor(PAR + 5, 5);
    const slowHit = bossDamageFor(PAR * 5, 5);
    expect(fastHit).toBeGreaterThan(midHit);
    expect(midHit).toBeGreaterThan(slowHit);
    expect(slowHit).toBeGreaterThan(0);
  });

  it("traite une durée négative (horloge qui recule) comme instantanée", () => {
    expect(bossDamageFor(-30, 5)).toBeCloseTo(bossDamageFor(0, 5));
  });

  it("ne divise pas par zéro sur une manche vide", () => {
    expect(bossDamageFor(5, 0)).toBe(0);
  });
});

describe("le bilan du combat", () => {
  const runOf = (seconds: number, total: number) =>
    Array.from({ length: total }, () => bossDamageFor(seconds, total)).reduce((a, b) => a + b, 0);

  it("met le boss à terre quand toute la manche est sous le temps de référence", () => {
    const damage = runOf(PAR - 1, 5);
    expect(bossHpForDamage(damage)).toBe(0);
    expect(bossRankForDamage(damage)).toBe("critical");
  });

  it("laisse le boss debout — mais l'exercice fini — quand toute la manche est lente", () => {
    const damage = runOf(PAR * 4, 5);
    expect(bossHpForDamage(damage)).toBe(50);
    expect(bossRankForDamage(damage)).toBe("steady");
  });

  it("classe entre les deux une manche jouée au palier intermédiaire", () => {
    const damage = runOf(PAR + 5, 5);
    expect(bossRankForDamage(damage)).toBe("fast");
    expect(bossHpForDamage(damage)).toBe(25);
  });

  it("borne les HP à l'intervalle affichable", () => {
    expect(bossHpForDamage(0)).toBe(100);
    expect(bossHpForDamage(140)).toBe(0);
    expect(bossHpForDamage(-40)).toBe(100);
  });
});

describe("formatChrono", () => {
  it("reste en secondes sous la minute", () => {
    expect(formatChrono(0)).toBe("0s");
    expect(formatChrono(59)).toBe("59s");
  });

  it("passe en minutes:secondes au-delà — le chrono n'a plus de plafond", () => {
    expect(formatChrono(60)).toBe("1:00");
    expect(formatChrono(127)).toBe("2:07");
    expect(formatChrono(3661)).toBe("61:01");
  });

  it("plancher à zéro", () => {
    expect(formatChrono(-5)).toBe("0s");
  });
});
