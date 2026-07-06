import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

// Controllable fake AudioContext injected via the mocked engine.
class FakeParam {
  value = 0.05;
  setValueAtTime = vi.fn();
  exponentialRampToValueAtTime = vi.fn();
  cancelScheduledValues = vi.fn();
}
class FakeOscillator {
  type = "";
  frequency = new FakeParam();
  connect = vi.fn();
  start = vi.fn();
  stop = vi.fn();
}
class FakeGain {
  gain = new FakeParam();
  connect = vi.fn();
  disconnect = vi.fn();
}

const oscillators: FakeOscillator[] = [];
const gains: FakeGain[] = [];
const fakeCtx = {
  currentTime: 0,
  state: "running" as AudioContextState,
  destination: {},
  createOscillator: vi.fn(() => {
    const o = new FakeOscillator();
    oscillators.push(o);
    return o;
  }),
  createGain: vi.fn(() => {
    const g = new FakeGain();
    gains.push(g);
    return g;
  }),
  resume: vi.fn(() => Promise.resolve()),
};

let contextAvailable = true;
vi.mock("../engine", () => ({
  getAudioContext: () => (contextAvailable ? fakeCtx : null),
}));

import {
  startMusic,
  stopMusic,
  setMusicMood,
  isMusicPlaying,
  __resetMusicForTests,
} from "../music";

beforeEach(() => {
  vi.useFakeTimers();
  contextAvailable = true;
  oscillators.length = 0;
  gains.length = 0;
  fakeCtx.currentTime = 0;
  fakeCtx.createOscillator.mockClear();
  fakeCtx.createGain.mockClear();
  __resetMusicForTests();
});

afterEach(() => {
  __resetMusicForTests();
  vi.useRealTimers();
});

describe("ambient music", () => {
  it("starts a loop: builds a music bus and schedules a bar of notes", () => {
    startMusic("calm");
    expect(isMusicPlaying()).toBe(true);
    expect(fakeCtx.createGain).toHaveBeenCalled();
    // First bar = 3 pad tones + 4 arpeggio notes.
    expect(oscillators.length).toBeGreaterThanOrEqual(7);
  });

  it("is idempotent while running (a second start does not spawn a bus)", () => {
    startMusic();
    fakeCtx.createGain.mockClear();
    startMusic();
    expect(fakeCtx.createGain).not.toHaveBeenCalled();
  });

  it("keeps scheduling ahead as time advances", () => {
    startMusic();
    const initial = oscillators.length;
    fakeCtx.currentTime = 8; // two bars later
    vi.advanceTimersByTime(300); // let the lookahead interval fire
    expect(oscillators.length).toBeGreaterThan(initial);
  });

  it("stops the loop and disconnects the bus after the fade", () => {
    startMusic();
    stopMusic();
    expect(isMusicPlaying()).toBe(false);
    vi.advanceTimersByTime(900); // past the 800ms disconnect timeout
    expect(gains[0].disconnect).toHaveBeenCalled();
  });

  it("setMusicMood does not throw whether running or not", () => {
    expect(() => setMusicMood("dungeon")).not.toThrow();
    startMusic();
    expect(() => setMusicMood("dungeon")).not.toThrow();
  });

  it("no-ops when no AudioContext is available", () => {
    contextAvailable = false;
    startMusic();
    expect(isMusicPlaying()).toBe(false);
    expect(() => stopMusic()).not.toThrow();
  });
});
