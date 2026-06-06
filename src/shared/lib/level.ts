import { XP_PER_LEVEL } from "@/shared/constants/gamification";

/** Linear level model: level 1 starts at 0 XP, each level spans XP_PER_LEVEL. */

/** Clamp XP to a non-negative integer-safe value. */
function safeXp(xp: number): number {
  return xp > 0 ? xp : 0;
}

/** Level for a given total XP (1-based). */
export function levelForXp(xp: number): number {
  return Math.floor(safeXp(xp) / XP_PER_LEVEL) + 1;
}

/** XP accumulated within the current level. */
export function xpWithinLevel(xp: number): number {
  return safeXp(xp) % XP_PER_LEVEL;
}

/** XP remaining to reach the next level. */
export function xpToNextLevel(xp: number): number {
  return XP_PER_LEVEL - xpWithinLevel(xp);
}
