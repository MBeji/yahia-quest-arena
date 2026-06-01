import { describe, it, expect } from "vitest";
import {
  DUNGEON_XP_PER_FLOOR,
  DUNGEON_COINS_PER_5_FLOORS,
  DUNGEON_DIFFICULTY_STEP,
} from "@/features/dungeon/dungeon.server";

describe("Dungeon constants", () => {
  it("XP per floor is positive", () => {
    expect(DUNGEON_XP_PER_FLOOR).toBeGreaterThan(0);
  });

  it("coins awarded every 5 floors", () => {
    expect(DUNGEON_COINS_PER_5_FLOORS).toBeGreaterThan(0);
  });

  it("difficulty increases at reasonable intervals", () => {
    expect(DUNGEON_DIFFICULTY_STEP).toBeGreaterThanOrEqual(3);
    expect(DUNGEON_DIFFICULTY_STEP).toBeLessThanOrEqual(10);
  });
});

describe("Dungeon reward calculations", () => {
  function computeDungeonXp(floorsCleared: number): number {
    return floorsCleared * DUNGEON_XP_PER_FLOOR;
  }

  function computeDungeonCoins(floorsCleared: number): number {
    return Math.floor(floorsCleared / 5) * DUNGEON_COINS_PER_5_FLOORS;
  }

  function computeDungeonDifficulty(floor: number): number {
    return 1 + Math.floor((floor - 1) / DUNGEON_DIFFICULTY_STEP);
  }

  it("0 floors gives 0 XP", () => {
    expect(computeDungeonXp(0)).toBe(0);
  });

  it("10 floors gives 150 XP", () => {
    expect(computeDungeonXp(10)).toBe(150);
  });

  it("3 floors gives 0 coins (less than 5)", () => {
    expect(computeDungeonCoins(3)).toBe(0);
  });

  it("5 floors gives coins", () => {
    expect(computeDungeonCoins(5)).toBe(DUNGEON_COINS_PER_5_FLOORS);
  });

  it("12 floors gives 2x coins", () => {
    expect(computeDungeonCoins(12)).toBe(2 * DUNGEON_COINS_PER_5_FLOORS);
  });

  it("floor 1 has difficulty 1", () => {
    expect(computeDungeonDifficulty(1)).toBe(1);
  });

  it("floor 5 still difficulty 1", () => {
    expect(computeDungeonDifficulty(5)).toBe(1);
  });

  it("floor 6 increases difficulty", () => {
    expect(computeDungeonDifficulty(6)).toBe(2);
  });

  it("floor 15 has high difficulty", () => {
    expect(computeDungeonDifficulty(15)).toBe(3);
  });
});
