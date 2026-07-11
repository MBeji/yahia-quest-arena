import { useReducedMotion } from "motion/react";

/**
 * Standard entrance vocabulary for `motion/react` elements (étude 14, D-5).
 * Screens spread `useEntrance(...)` instead of hand-rolling `initial/animate`
 * objects, so every entrance is automatically neutralized under
 * `prefers-reduced-motion` (the audit found only 2 of ~12 screens gated it).
 */
export const MOTION_PRESETS = {
  fade: { initial: { opacity: 0 }, animate: { opacity: 1 } },
  rise: { initial: { opacity: 0, y: 12 }, animate: { opacity: 1, y: 0 } },
  scale: { initial: { opacity: 0, scale: 0.95 }, animate: { opacity: 1, scale: 1 } },
} as const;

export type MotionPreset = keyof typeof MOTION_PRESETS;

type EntranceProps =
  | { initial: false }
  | {
      initial: (typeof MOTION_PRESETS)[MotionPreset]["initial"];
      animate: (typeof MOTION_PRESETS)[MotionPreset]["animate"];
      transition: { duration: number; ease: "easeOut"; delay: number };
    };

/**
 * Non-hook variant for STAGGERED lists (per-item delay inside a `.map()`, where
 * a hook call would be illegal): call `useReducedMotion()` once in the component
 * and thread its result here.
 */
export function entrance(
  reduced: boolean | null,
  preset: MotionPreset = "rise",
  delay = 0,
): EntranceProps {
  if (reduced) return { initial: false };
  const { initial, animate } = MOTION_PRESETS[preset];
  return { initial, animate, transition: { duration: 0.35, ease: "easeOut", delay } };
}

/**
 * Entrance props for a `motion.*` element. Under reduced motion the element
 * renders directly in its final state (`initial: false` — no animation, no
 * opacity flash).
 */
export function useEntrance(preset: MotionPreset = "rise", delay = 0): EntranceProps {
  return entrance(useReducedMotion(), preset, delay);
}
