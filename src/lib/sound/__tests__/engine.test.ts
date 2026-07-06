import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { __resetAudioForTests, playSound, unlockAudio, type SoundName } from "../engine";

// --- Minimal Web Audio mock -------------------------------------------------
class FakeParam {
  value = 0;
  setValueAtTime = vi.fn();
  linearRampToValueAtTime = vi.fn();
  exponentialRampToValueAtTime = vi.fn();
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
}

let constructed = 0;
let oscillators: FakeOscillator[] = [];

class FakeAudioContext {
  static resume = vi.fn(() => Promise.resolve());
  currentTime = 0;
  state: AudioContextState = "running";
  destination = {};
  constructor() {
    constructed += 1;
  }
  createOscillator() {
    const osc = new FakeOscillator();
    oscillators.push(osc);
    return osc;
  }
  createGain() {
    return new FakeGain();
  }
  resume() {
    return FakeAudioContext.resume();
  }
}

const withAudio = window as unknown as { AudioContext?: unknown; webkitAudioContext?: unknown };
const originalAudioContext = withAudio.AudioContext;

beforeEach(() => {
  __resetAudioForTests();
  constructed = 0;
  oscillators = [];
  FakeAudioContext.resume.mockClear();
  withAudio.AudioContext = FakeAudioContext;
});

afterEach(() => {
  withAudio.AudioContext = originalAudioContext;
});

describe("sound engine", () => {
  it("schedules one oscillator per note of the effect", () => {
    playSound("victory"); // victory = 4 notes
    expect(oscillators).toHaveLength(4);
    for (const osc of oscillators) {
      expect(osc.start).toHaveBeenCalledTimes(1);
      expect(osc.stop).toHaveBeenCalledTimes(1);
      expect(osc.connect).toHaveBeenCalledTimes(1);
    }
  });

  it("plays a single-note effect", () => {
    playSound("select");
    expect(oscillators).toHaveLength(1);
  });

  it("applies a pitch sweep when the note specifies one", () => {
    playSound("descend"); // descend sweeps 240 -> 90
    expect(oscillators[0].frequency.linearRampToValueAtTime).toHaveBeenCalled();
  });

  it("reuses a single shared AudioContext across calls", () => {
    playSound("coin");
    playSound("coin");
    playSound("badge");
    expect(constructed).toBe(1);
  });

  it("resumes a suspended context before playing", () => {
    __resetAudioForTests();
    class SuspendedContext extends FakeAudioContext {
      state: AudioContextState = "suspended";
    }
    withAudio.AudioContext = SuspendedContext;
    playSound("correct");
    expect(FakeAudioContext.resume).toHaveBeenCalled();
  });

  it("unlockAudio resumes a suspended context", () => {
    __resetAudioForTests();
    class SuspendedContext extends FakeAudioContext {
      state: AudioContextState = "suspended";
    }
    withAudio.AudioContext = SuspendedContext;
    unlockAudio();
    expect(FakeAudioContext.resume).toHaveBeenCalled();
  });

  it("is a silent no-op when no AudioContext is available", () => {
    __resetAudioForTests();
    delete withAudio.AudioContext;
    delete withAudio.webkitAudioContext;
    expect(() => playSound("victory")).not.toThrow();
    expect(() => unlockAudio()).not.toThrow();
    expect(oscillators).toHaveLength(0);
  });

  it("falls back to webkitAudioContext when the standard one is absent", () => {
    __resetAudioForTests();
    delete withAudio.AudioContext;
    withAudio.webkitAudioContext = FakeAudioContext;
    playSound("coin");
    expect(constructed).toBe(1);
    delete withAudio.webkitAudioContext;
  });

  it("never throws if the context constructor fails", () => {
    __resetAudioForTests();
    class ThrowingContext {
      constructor() {
        throw new Error("no audio hardware");
      }
    }
    withAudio.AudioContext = ThrowingContext;
    expect(() => playSound("victory")).not.toThrow();
  });

  it("covers every named effect without throwing", () => {
    const names: SoundName[] = [
      "select",
      "correct",
      "wrong",
      "victory",
      "levelUp",
      "badge",
      "coin",
      "descend",
      "gameOver",
    ];
    for (const name of names) {
      expect(() => playSound(name)).not.toThrow();
    }
  });
});
