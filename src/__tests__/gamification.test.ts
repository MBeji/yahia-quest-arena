import { describe, it, expect } from "vitest";
import {
  PASS_THRESHOLD_PCT,
  HALF_COIN_THRESHOLD_PCT,
  XP_PER_LEVEL,
  IDEAL_TIME_PER_QUESTION_S,
  MIN_DURATION_FLOOR_S,
  SPEED_FACTOR_MIN,
  SPEED_FACTOR_MAX,
  MAX_DIFFICULTY_LEVEL,
  MIN_DIFFICULTY_LEVEL,
  DIFFICULTY_INCREASE_THRESHOLD,
  DIFFICULTY_DECREASE_THRESHOLD,
  SPACED_REPETITION_INTERVALS_MS,
  DEFAULT_DAILY_OBJECTIVES,
} from "@/lib/gamification.constants";

describe("Gamification Constants", () => {
  describe("Pass/Fail thresholds", () => {
    it("pass threshold is 60%", () => {
      expect(PASS_THRESHOLD_PCT).toBe(60);
    });

    it("half coin threshold is lower than pass threshold", () => {
      expect(HALF_COIN_THRESHOLD_PCT).toBeLessThan(PASS_THRESHOLD_PCT);
    });

    it("half coin threshold is 40%", () => {
      expect(HALF_COIN_THRESHOLD_PCT).toBe(40);
    });
  });

  describe("Leveling", () => {
    it("XP per level is 200", () => {
      expect(XP_PER_LEVEL).toBe(200);
    });

    it("level calculation: 400 XP = level 2", () => {
      expect(Math.floor(400 / XP_PER_LEVEL)).toBe(2);
    });
  });

  describe("Speed factor bounds", () => {
    it("min speed factor is less than 1", () => {
      expect(SPEED_FACTOR_MIN).toBeLessThan(1);
    });

    it("max speed factor is greater than 1", () => {
      expect(SPEED_FACTOR_MAX).toBeGreaterThan(1);
    });

    it("ideal time per question is reasonable (15-60s)", () => {
      expect(IDEAL_TIME_PER_QUESTION_S).toBeGreaterThanOrEqual(15);
      expect(IDEAL_TIME_PER_QUESTION_S).toBeLessThanOrEqual(60);
    });

    it("min duration floor prevents instant submissions", () => {
      expect(MIN_DURATION_FLOOR_S).toBeGreaterThan(0);
      expect(MIN_DURATION_FLOOR_S).toBeLessThan(IDEAL_TIME_PER_QUESTION_S);
    });
  });

  describe("Difficulty adaptation", () => {
    it("difficulty range is 1-4", () => {
      expect(MIN_DIFFICULTY_LEVEL).toBe(1);
      expect(MAX_DIFFICULTY_LEVEL).toBe(4);
    });

    it("increase threshold is higher than decrease threshold", () => {
      expect(DIFFICULTY_INCREASE_THRESHOLD).toBeGreaterThan(DIFFICULTY_DECREASE_THRESHOLD);
    });

    it("thresholds are percentages between 0-100", () => {
      expect(DIFFICULTY_INCREASE_THRESHOLD).toBeGreaterThan(0);
      expect(DIFFICULTY_INCREASE_THRESHOLD).toBeLessThanOrEqual(100);
      expect(DIFFICULTY_DECREASE_THRESHOLD).toBeGreaterThan(0);
      expect(DIFFICULTY_DECREASE_THRESHOLD).toBeLessThanOrEqual(100);
    });
  });

  describe("Spaced repetition", () => {
    it("has 3 intervals", () => {
      expect(SPACED_REPETITION_INTERVALS_MS).toHaveLength(3);
    });

    it("intervals are in ascending order", () => {
      for (let i = 1; i < SPACED_REPETITION_INTERVALS_MS.length; i++) {
        expect(SPACED_REPETITION_INTERVALS_MS[i]).toBeGreaterThan(
          SPACED_REPETITION_INTERVALS_MS[i - 1],
        );
      }
    });

    it("first interval is 1 day", () => {
      expect(SPACED_REPETITION_INTERVALS_MS[0]).toBe(86_400_000);
    });
  });

  describe("Daily objectives defaults", () => {
    it("has at least 2 default objectives", () => {
      expect(DEFAULT_DAILY_OBJECTIVES.length).toBeGreaterThanOrEqual(2);
    });

    it("each objective has positive rewards", () => {
      for (const obj of DEFAULT_DAILY_OBJECTIVES) {
        expect(obj.xp).toBeGreaterThan(0);
        expect(obj.coins).toBeGreaterThan(0);
        expect(obj.target).toBeGreaterThan(0);
      }
    });
  });
});

describe("Score computation logic", () => {
  function computeScorePct(correct: number, total: number): number {
    return total > 0 ? Math.round((correct / total) * 100) : 0;
  }

  function computeSpeedFactor(durationS: number, questionCount: number): number {
    const idealTotal = questionCount * IDEAL_TIME_PER_QUESTION_S;
    const actualDuration = Math.max(durationS, MIN_DURATION_FLOOR_S);
    const raw = idealTotal / actualDuration;
    return Math.min(SPEED_FACTOR_MAX, Math.max(SPEED_FACTOR_MIN, raw));
  }

  function computeXp(scorePct: number, speedFactor: number, baseXp: number): number {
    if (scorePct < PASS_THRESHOLD_PCT) return 0;
    return Math.round(baseXp * speedFactor * (scorePct / 100));
  }

  it("perfect score gives 100%", () => {
    expect(computeScorePct(10, 10)).toBe(100);
  });

  it("0 correct gives 0%", () => {
    expect(computeScorePct(0, 10)).toBe(0);
  });

  it("7/10 gives 70%", () => {
    expect(computeScorePct(7, 10)).toBe(70);
  });

  it("0 total gives 0%", () => {
    expect(computeScorePct(0, 0)).toBe(0);
  });

  it("speed factor for ideal time is ~1.0", () => {
    const factor = computeSpeedFactor(300, 10); // 30s × 10 = 300s ideal
    expect(factor).toBeCloseTo(1.0, 1);
  });

  it("very fast completion gives max speed factor", () => {
    const factor = computeSpeedFactor(15, 10); // min floor
    expect(factor).toBe(SPEED_FACTOR_MAX);
  });

  it("very slow completion gives min speed factor", () => {
    const factor = computeSpeedFactor(6000, 10);
    expect(factor).toBe(SPEED_FACTOR_MIN);
  });

  it("below pass threshold gives 0 XP", () => {
    expect(computeXp(50, 1.0, 100)).toBe(0);
  });

  it("at pass threshold gives XP", () => {
    const xp = computeXp(60, 1.0, 100);
    expect(xp).toBeGreaterThan(0);
    expect(xp).toBe(60); // 100 * 1.0 * 0.6
  });

  it("perfect score with speed bonus", () => {
    const xp = computeXp(100, 1.4, 100);
    expect(xp).toBe(140);
  });
});

describe("Difficulty adaptation logic", () => {
  function shouldIncrease(recentAvg: number): boolean {
    return recentAvg > DIFFICULTY_INCREASE_THRESHOLD;
  }

  function shouldDecrease(recentAvg: number): boolean {
    return recentAvg < DIFFICULTY_DECREASE_THRESHOLD;
  }

  function adaptDifficulty(currentLevel: number, recentAvg: number): number {
    if (shouldIncrease(recentAvg)) {
      return Math.min(currentLevel + 1, MAX_DIFFICULTY_LEVEL);
    }
    if (shouldDecrease(recentAvg)) {
      return Math.max(currentLevel - 1, MIN_DIFFICULTY_LEVEL);
    }
    return currentLevel;
  }

  it("increases difficulty when avg > 75%", () => {
    expect(adaptDifficulty(1, 80)).toBe(2);
  });

  it("decreases difficulty when avg < 40%", () => {
    expect(adaptDifficulty(3, 30)).toBe(2);
  });

  it("stays same in middle range", () => {
    expect(adaptDifficulty(2, 55)).toBe(2);
  });

  it("does not exceed max difficulty", () => {
    expect(adaptDifficulty(MAX_DIFFICULTY_LEVEL, 90)).toBe(MAX_DIFFICULTY_LEVEL);
  });

  it("does not go below min difficulty", () => {
    expect(adaptDifficulty(MIN_DIFFICULTY_LEVEL, 20)).toBe(MIN_DIFFICULTY_LEVEL);
  });
});
