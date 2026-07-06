import { getAudioContext } from "./engine";

/**
 * Generative ambient background music — a soft, slowly-cycling pad + arpeggio
 * synthesized live (no audio files). Two moods: a warm "calm" theme and a darker
 * "dungeon" theme. It reuses the shared AudioContext, runs at a low volume, and is
 * **off by default** (opt-in via the sound menu). SSR-safe and best-effort: every
 * entry point no-ops when audio is unavailable and never throws.
 */

export type MusicMood = "calm" | "dungeon";

// Chord tones (Hz) per bar, cycled to form a gentle 4-bar progression.
const PROGRESSIONS: Record<MusicMood, number[][]> = {
  // C – G – Am – F, warm and major.
  calm: [
    [261.63, 329.63, 392.0],
    [196.0, 293.66, 392.0],
    [220.0, 329.63, 440.0],
    [174.61, 261.63, 349.23],
  ],
  // Lower, minor, sparse — tension without being oppressive.
  dungeon: [
    [130.81, 155.56, 196.0],
    [146.83, 174.61, 220.0],
    [123.47, 146.83, 185.0],
    [110.0, 130.81, 164.81],
  ],
};

const BAR_SECONDS = 4;
const LOOKAHEAD_MS = 250;
const SCHEDULE_AHEAD_S = 0.6;
const MUSIC_GAIN = 0.05;

let musicGain: GainNode | null = null;
let timer: ReturnType<typeof setInterval> | null = null;
let barIndex = 0;
let nextBarTime = 0;
let mood: MusicMood = "calm";

/** Schedule one enveloped note onto the music bus. */
function scheduleNote(
  c: AudioContext,
  out: GainNode,
  freq: number,
  start: number,
  duration: number,
  type: OscillatorType,
  gain: number,
): void {
  const osc = c.createOscillator();
  const g = c.createGain();
  const t0 = start;
  const t1 = start + duration;
  osc.type = type;
  osc.frequency.setValueAtTime(freq, t0);
  const attack = Math.min(0.6, duration * 0.4);
  g.gain.setValueAtTime(0.0001, t0);
  g.gain.exponentialRampToValueAtTime(gain, t0 + attack);
  g.gain.exponentialRampToValueAtTime(0.0001, t1);
  osc.connect(g);
  g.connect(out);
  osc.start(t0);
  osc.stop(t1 + 0.05);
}

/** Schedule a full bar: a sustained pad chord + a light arpeggio an octave up. */
function scheduleBar(c: AudioContext, out: GainNode, barStart: number): void {
  const chord = PROGRESSIONS[mood][barIndex % PROGRESSIONS[mood].length];
  // Pad: hold the chord tones across the whole bar.
  for (const freq of chord) {
    scheduleNote(c, out, freq, barStart, BAR_SECONDS * 0.95, "sine", 0.5);
  }
  // Arpeggio: octave-up bell notes on the beats, humanized in time.
  const beats = 4;
  for (let i = 0; i < beats; i++) {
    const freq = chord[i % chord.length] * 2;
    const jitter = (Math.random() * 2 - 1) * 0.03;
    scheduleNote(
      c,
      out,
      freq,
      barStart + (i / beats) * BAR_SECONDS + jitter,
      0.5,
      "triangle",
      0.22,
    );
  }
}

function tick(): void {
  const c = getAudioContext();
  if (!c || !musicGain) return;
  try {
    while (nextBarTime < c.currentTime + SCHEDULE_AHEAD_S) {
      scheduleBar(c, musicGain, nextBarTime);
      nextBarTime += BAR_SECONDS;
      barIndex += 1;
    }
  } catch {
    // Best-effort scheduling.
  }
}

/** Start (or re-target) the ambient loop for a mood. Idempotent while running. */
export function startMusic(nextMood: MusicMood = "calm"): void {
  mood = nextMood;
  if (timer !== null) return; // already looping — mood applies from the next bar
  const c = getAudioContext();
  if (!c) return;
  if (c.state === "suspended") void c.resume().catch(() => {});
  try {
    const gain = c.createGain();
    gain.gain.setValueAtTime(0.0001, c.currentTime);
    gain.gain.exponentialRampToValueAtTime(MUSIC_GAIN, c.currentTime + 1.5);
    gain.connect(c.destination);
    musicGain = gain;
    barIndex = 0;
    nextBarTime = c.currentTime + 0.1;
    tick();
    timer = setInterval(tick, LOOKAHEAD_MS);
  } catch {
    // Best-effort — leave music off if the graph can't be built.
  }
}

/** Switch the mood of an already-playing loop (no-op if stopped). */
export function setMusicMood(nextMood: MusicMood): void {
  mood = nextMood;
}

/** Fade out and stop the ambient loop. */
export function stopMusic(): void {
  if (timer !== null) {
    clearInterval(timer);
    timer = null;
  }
  const c = getAudioContext();
  const gain = musicGain;
  musicGain = null;
  if (!c || !gain) return;
  try {
    const now = c.currentTime;
    gain.gain.cancelScheduledValues(now);
    gain.gain.setValueAtTime(Math.max(0.0001, gain.gain.value), now);
    gain.gain.exponentialRampToValueAtTime(0.0001, now + 0.6);
    setTimeout(() => {
      try {
        gain.disconnect();
      } catch {
        // already gone
      }
    }, 800);
  } catch {
    // Best-effort.
  }
}

export function isMusicPlaying(): boolean {
  return timer !== null;
}

/** Test-only: force-reset module state between tests. */
export function __resetMusicForTests(): void {
  if (timer !== null) {
    clearInterval(timer);
    timer = null;
  }
  musicGain = null;
  barIndex = 0;
  nextBarTime = 0;
  mood = "calm";
}
