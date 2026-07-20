import { describe, it, expect } from "vitest";
import {
  PASS_THRESHOLD_PCT,
  XP_PER_LEVEL,
  MIN_DURATION_FLOOR_S,
  MAX_DIFFICULTY_LEVEL,
  MIN_DIFFICULTY_LEVEL,
  DIFFICULTY_INCREASE_THRESHOLD,
  DIFFICULTY_DECREASE_THRESHOLD,
  SPACED_REPETITION_INTERVALS_MS,
} from "@/shared/constants/gamification";

describe("Gamification Constants", () => {
  describe("Pass/Fail thresholds", () => {
    it("pass threshold is 60%", () => {
      expect(PASS_THRESHOLD_PCT).toBe(60);
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

  describe("Duration floor", () => {
    // Le seul survivant du bloc « speed factor » purgé par R-29 : celui-ci est bel et bien lu
    // par du code de production, contrairement à ses anciens voisins.
    it("min duration floor prevents instant submissions", () => {
      expect(MIN_DURATION_FLOOR_S).toBeGreaterThan(0);
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
});
