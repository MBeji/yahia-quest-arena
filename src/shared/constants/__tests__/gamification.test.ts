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
} from "@/shared/constants/gamification";

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
