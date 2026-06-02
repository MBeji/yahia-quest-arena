import { describe, it, expect } from "vitest";
import { XP_PER_LEVEL } from "@/shared/constants/gamification";
import { levelForXp, xpWithinLevel, xpToNextLevel } from "@/shared/lib/level";

describe("levelForXp", () => {
  it("returns level 1 at 0 XP", () => {
    expect(levelForXp(0)).toBe(1);
  });

  it("stays level 1 just below the threshold", () => {
    expect(levelForXp(XP_PER_LEVEL - 1)).toBe(1);
  });

  it("advances to level 2 at exactly one threshold", () => {
    expect(levelForXp(XP_PER_LEVEL)).toBe(2);
  });

  it("guards against negative XP", () => {
    expect(levelForXp(-50)).toBe(1);
  });
});

describe("xpWithinLevel", () => {
  it("is 0 at a level boundary", () => {
    expect(xpWithinLevel(XP_PER_LEVEL)).toBe(0);
  });

  it("returns the remainder within a level", () => {
    expect(xpWithinLevel(XP_PER_LEVEL + 30)).toBe(30);
  });

  it("guards against negative XP", () => {
    expect(xpWithinLevel(-10)).toBe(0);
  });
});

describe("xpToNextLevel", () => {
  it("equals a full level span at a boundary", () => {
    expect(xpToNextLevel(XP_PER_LEVEL)).toBe(XP_PER_LEVEL);
  });

  it("returns the gap to the next level", () => {
    expect(xpToNextLevel(XP_PER_LEVEL + 30)).toBe(XP_PER_LEVEL - 30);
  });

  it("guards against negative XP", () => {
    expect(xpToNextLevel(-10)).toBe(XP_PER_LEVEL);
  });
});
