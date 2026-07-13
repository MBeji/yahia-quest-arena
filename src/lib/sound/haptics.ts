import type { SoundName } from "./engine";

/**
 * Light haptic feedback (Vibration API) paired with the audio cues, so the app
 * feels tactile on mobile. SSR-safe and support-guarded; a device without
 * `navigator.vibrate` (most desktops, iOS Safari) is a silent no-op. Gated on the
 * same sound preference as audio (see SoundProvider).
 */

// Only the meaningful, punchy moments buzz — not every UI blip. Patterns are in
// milliseconds ([vibrate] or [vibrate, pause, vibrate, …]).
const HAPTICS: Partial<Record<SoundName, number | number[]>> = {
  correct: 18,
  wrong: [30, 40, 30],
  victory: [24, 40, 24, 40, 60],
  levelUp: [30, 50, 30, 50, 90],
  badge: [20, 30, 20],
  purchase: [15, 25, 15],
  unlock: [20, 30, 40],
  gameOver: [60, 60, 120],
};

function canVibrate(): boolean {
  return (
    typeof navigator !== "undefined" &&
    typeof (navigator as Navigator & { vibrate?: unknown }).vibrate === "function"
  );
}

/** Fire the haptic pattern mapped to a sound effect, if any and if supported. */
export function vibrateFor(name: SoundName): void {
  const pattern = HAPTICS[name];
  if (pattern === undefined || !canVibrate()) return;
  try {
    navigator.vibrate(pattern);
  } catch {
    // Best-effort — never let a haptic call bubble into gameplay.
  }
}

/** Fire an arbitrary vibration pattern (e.g. escalating combos). */
export function vibrate(pattern: number | number[]): void {
  if (!canVibrate()) return;
  try {
    navigator.vibrate(pattern);
  } catch {
    // Best-effort.
  }
}
