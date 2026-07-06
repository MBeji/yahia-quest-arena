/**
 * Procedural Web Audio sound engine — every effect is synthesized at runtime from
 * oscillators + gain envelopes, so the app ships **zero external audio assets**.
 * That keeps effects off the CSP allow-list, out of the bundle budget, and working
 * offline. All entry points are SSR-safe (guard `window`/`AudioContext`) and
 * best-effort: a missing or throwing AudioContext (SSR, old browser, autoplay
 * lockout) degrades to a silent no-op and never crashes the caller.
 */

export type SoundName =
  | "select"
  | "correct"
  | "wrong"
  | "victory"
  | "levelUp"
  | "badge"
  | "coin"
  | "descend"
  | "gameOver";

/** One scheduled oscillator note within an effect. */
type ToneSpec = {
  /** Base frequency in Hz. */
  freq: number;
  /** Offset from the effect's start, in seconds. */
  start: number;
  /** Note length in seconds. */
  duration: number;
  type?: OscillatorType;
  /** Peak gain (0..1), scaled by the master gain. */
  gain?: number;
  /** Optional linear pitch sweep target (Hz) reached at note end. */
  sweepTo?: number;
};

// Master level is deliberately gentle — motivating, never startling.
const MASTER_GAIN = 0.16;

type WebkitWindow = Window & { webkitAudioContext?: typeof AudioContext };

let ctx: AudioContext | null = null;
let master: GainNode | null = null;

/** Lazily create (once) the shared AudioContext + master gain. */
function getContext(): AudioContext | null {
  if (typeof window === "undefined") return null;
  if (ctx) return ctx;
  const AC = window.AudioContext ?? (window as WebkitWindow).webkitAudioContext;
  if (!AC) return null;
  try {
    const created = new AC();
    const gain = created.createGain();
    gain.gain.value = MASTER_GAIN;
    gain.connect(created.destination);
    ctx = created;
    master = gain;
    return ctx;
  } catch {
    return null;
  }
}

/**
 * Resume a suspended AudioContext. Browsers start it suspended until a user
 * gesture, so this must be invoked from within a real pointer/key/touch handler
 * for the first sound to be audible.
 */
export function unlockAudio(): void {
  const c = getContext();
  if (c && c.state === "suspended") {
    void c.resume().catch(() => {});
  }
}

/** Schedule a single enveloped tone on the master bus. */
function scheduleTone(c: AudioContext, out: GainNode, spec: ToneSpec): void {
  const osc = c.createOscillator();
  const g = c.createGain();
  const t0 = c.currentTime + spec.start;
  const t1 = t0 + spec.duration;
  osc.type = spec.type ?? "triangle";
  osc.frequency.setValueAtTime(spec.freq, t0);
  if (spec.sweepTo) osc.frequency.linearRampToValueAtTime(spec.sweepTo, t1);
  // Exponential ramps can't hit 0 — floor the envelope at a near-silent value.
  const peak = spec.gain ?? 1;
  g.gain.setValueAtTime(0.0001, t0);
  g.gain.exponentialRampToValueAtTime(peak, t0 + 0.012);
  g.gain.exponentialRampToValueAtTime(0.0001, t1);
  osc.connect(g);
  g.connect(out);
  osc.start(t0);
  osc.stop(t1 + 0.03);
}

// Each effect is a short arpeggio/gesture tuned to feel rewarding in an RPG UI.
const PATTERNS: Record<SoundName, ToneSpec[]> = {
  // Subtle blip on tapping an answer.
  select: [{ freq: 660, start: 0, duration: 0.06, type: "sine", gain: 0.55 }],
  // Bright rising two-note "yes".
  correct: [
    { freq: 659, start: 0, duration: 0.1, gain: 0.7 },
    { freq: 988, start: 0.08, duration: 0.16, gain: 0.7 },
  ],
  // Soft descending buzz — clearly "no", never harsh.
  wrong: [{ freq: 300, start: 0, duration: 0.26, type: "sawtooth", gain: 0.4, sweepTo: 150 }],
  // Triumphant major arpeggio on a winning quest.
  victory: [
    { freq: 523, start: 0, duration: 0.14 },
    { freq: 659, start: 0.12, duration: 0.14 },
    { freq: 784, start: 0.24, duration: 0.14 },
    { freq: 1046, start: 0.36, duration: 0.32, gain: 0.9 },
  ],
  // Bigger fanfare + high shimmer on level up.
  levelUp: [
    { freq: 392, start: 0, duration: 0.12 },
    { freq: 523, start: 0.1, duration: 0.12 },
    { freq: 659, start: 0.2, duration: 0.12 },
    { freq: 784, start: 0.3, duration: 0.12 },
    { freq: 1046, start: 0.4, duration: 0.42, gain: 1 },
    { freq: 1568, start: 0.44, duration: 0.38, type: "sine", gain: 0.35 },
  ],
  // Bell-like chime (fundamental + partials) on a badge unlock.
  badge: [
    { freq: 1046, start: 0, duration: 0.5, type: "sine", gain: 0.75 },
    { freq: 1568, start: 0, duration: 0.5, type: "sine", gain: 0.32 },
    { freq: 2093, start: 0.02, duration: 0.4, type: "sine", gain: 0.18 },
  ],
  // Classic two-note coin pickup.
  coin: [
    { freq: 988, start: 0, duration: 0.06, type: "square", gain: 0.45 },
    { freq: 1319, start: 0.055, duration: 0.13, type: "square", gain: 0.45 },
  ],
  // Low descending whoosh when dropping to a new dungeon floor.
  descend: [{ freq: 240, start: 0, duration: 0.42, type: "sine", gain: 0.5, sweepTo: 90 }],
  // Descending minor triad on a run ending.
  gameOver: [
    { freq: 440, start: 0, duration: 0.2 },
    { freq: 349, start: 0.18, duration: 0.2 },
    { freq: 262, start: 0.36, duration: 0.44, gain: 0.85 },
  ],
};

/**
 * Play a named effect. No-ops silently when audio is unavailable. Callers gate on
 * the user's sound preference before calling (see SoundProvider).
 */
export function playSound(name: SoundName): void {
  const c = getContext();
  if (!c || !master) return;
  try {
    if (c.state === "suspended") void c.resume().catch(() => {});
    for (const spec of PATTERNS[name]) scheduleTone(c, master, spec);
  } catch {
    // Best-effort: never let an audio glitch bubble into gameplay.
  }
}

/** Test-only: drop the cached context so each test starts from a clean slate. */
export function __resetAudioForTests(): void {
  ctx = null;
  master = null;
}
