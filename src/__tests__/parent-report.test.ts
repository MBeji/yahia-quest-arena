import { describe, it, expect } from "vitest";

/**
 * Tests for the seriousness score algorithm used in parent reporting.
 * Logic extracted from gamification.parent.ts getStudentReport handler.
 */

function computeSeriousnessScore(params: {
  currentStreak: number;
  daysActiveThisWeek: number;
  avgScore: number;
  totalTimeMinutes: number;
}): number {
  const streakFactor = Math.min(params.currentStreak / 7, 1) * 25;
  const frequencyFactor = Math.min(params.daysActiveThisWeek / 5, 1) * 25;
  const scoreFactor = Math.min(params.avgScore / 80, 1) * 25;
  const timeFactor = Math.min(params.totalTimeMinutes / 120, 1) * 25;
  return Math.round(streakFactor + frequencyFactor + scoreFactor + timeFactor);
}

function getVerdict(score: number, totalExercises: number): string {
  if (score >= 80) return "excellent";
  if (score >= 60) return "good";
  if (score >= 40) return "average";
  if (totalExercises > 0) return "needs_improvement";
  return "inactive";
}

describe("Seriousness Score", () => {
  it("perfect student gets 100", () => {
    const score = computeSeriousnessScore({
      currentStreak: 10,
      daysActiveThisWeek: 7,
      avgScore: 95,
      totalTimeMinutes: 200,
    });
    expect(score).toBe(100);
  });

  it("inactive student gets 0", () => {
    const score = computeSeriousnessScore({
      currentStreak: 0,
      daysActiveThisWeek: 0,
      avgScore: 0,
      totalTimeMinutes: 0,
    });
    expect(score).toBe(0);
  });

  it("moderate student gets middle score", () => {
    const score = computeSeriousnessScore({
      currentStreak: 3,
      daysActiveThisWeek: 3,
      avgScore: 60,
      totalTimeMinutes: 60,
    });
    expect(score).toBeGreaterThan(30);
    expect(score).toBeLessThan(70);
  });

  it("caps streak factor at 25 (7+ days)", () => {
    const s7 = computeSeriousnessScore({
      currentStreak: 7,
      daysActiveThisWeek: 0,
      avgScore: 0,
      totalTimeMinutes: 0,
    });
    const s14 = computeSeriousnessScore({
      currentStreak: 14,
      daysActiveThisWeek: 0,
      avgScore: 0,
      totalTimeMinutes: 0,
    });
    expect(s7).toBe(s14); // both capped at 25
    expect(s7).toBe(25);
  });

  it("caps frequency factor at 25 (5+ days)", () => {
    const s5 = computeSeriousnessScore({
      currentStreak: 0,
      daysActiveThisWeek: 5,
      avgScore: 0,
      totalTimeMinutes: 0,
    });
    const s7 = computeSeriousnessScore({
      currentStreak: 0,
      daysActiveThisWeek: 7,
      avgScore: 0,
      totalTimeMinutes: 0,
    });
    expect(s5).toBe(s7);
    expect(s5).toBe(25);
  });

  it("caps score factor at 25 (80%+ average)", () => {
    const s80 = computeSeriousnessScore({
      currentStreak: 0,
      daysActiveThisWeek: 0,
      avgScore: 80,
      totalTimeMinutes: 0,
    });
    const s100 = computeSeriousnessScore({
      currentStreak: 0,
      daysActiveThisWeek: 0,
      avgScore: 100,
      totalTimeMinutes: 0,
    });
    expect(s80).toBe(s100);
    expect(s80).toBe(25);
  });

  it("caps time factor at 25 (120+ minutes)", () => {
    const t120 = computeSeriousnessScore({
      currentStreak: 0,
      daysActiveThisWeek: 0,
      avgScore: 0,
      totalTimeMinutes: 120,
    });
    const t300 = computeSeriousnessScore({
      currentStreak: 0,
      daysActiveThisWeek: 0,
      avgScore: 0,
      totalTimeMinutes: 300,
    });
    expect(t120).toBe(t300);
    expect(t120).toBe(25);
  });

  it("each factor contributes proportionally", () => {
    // Only streak: 3/7 * 25 ≈ 11
    const score = computeSeriousnessScore({
      currentStreak: 3,
      daysActiveThisWeek: 0,
      avgScore: 0,
      totalTimeMinutes: 0,
    });
    expect(score).toBe(11);
  });
});

describe("Verdict", () => {
  it("80+ is excellent", () => {
    expect(getVerdict(80, 10)).toBe("excellent");
    expect(getVerdict(100, 10)).toBe("excellent");
  });

  it("60-79 is good", () => {
    expect(getVerdict(60, 10)).toBe("good");
    expect(getVerdict(79, 10)).toBe("good");
  });

  it("40-59 is average", () => {
    expect(getVerdict(40, 10)).toBe("average");
    expect(getVerdict(59, 10)).toBe("average");
  });

  it("below 40 with exercises is needs_improvement", () => {
    expect(getVerdict(20, 5)).toBe("needs_improvement");
    expect(getVerdict(0, 1)).toBe("needs_improvement");
  });

  it("0 exercises is inactive", () => {
    expect(getVerdict(0, 0)).toBe("inactive");
    expect(getVerdict(39, 0)).toBe("inactive");
  });
});
