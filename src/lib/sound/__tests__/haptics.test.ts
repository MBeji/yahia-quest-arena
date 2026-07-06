import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { vibrate, vibrateFor } from "../haptics";

const nav = navigator as unknown as { vibrate?: (p: number | number[]) => boolean };
let original: typeof nav.vibrate;

beforeEach(() => {
  original = nav.vibrate;
  nav.vibrate = vi.fn(() => true);
});

afterEach(() => {
  nav.vibrate = original;
  vi.restoreAllMocks();
});

describe("vibrateFor", () => {
  it("fires the mapped pattern for a mapped effect", () => {
    vibrateFor("correct");
    expect(nav.vibrate).toHaveBeenCalledWith(18);
  });

  it("fires an array pattern for multi-buzz effects", () => {
    vibrateFor("levelUp");
    expect(nav.vibrate).toHaveBeenCalledWith([30, 50, 30, 50, 90]);
  });

  it("does nothing for an unmapped effect (e.g. a subtle blip)", () => {
    vibrateFor("hover");
    expect(nav.vibrate).not.toHaveBeenCalled();
  });

  it("is a silent no-op when the Vibration API is unavailable", () => {
    delete nav.vibrate;
    expect(() => vibrateFor("victory")).not.toThrow();
  });

  it("never throws if vibrate itself throws", () => {
    nav.vibrate = vi.fn(() => {
      throw new Error("blocked");
    });
    expect(() => vibrateFor("wrong")).not.toThrow();
  });
});

describe("vibrate", () => {
  it("forwards an arbitrary pattern", () => {
    vibrate([10, 20, 10]);
    expect(nav.vibrate).toHaveBeenCalledWith([10, 20, 10]);
  });

  it("no-ops without support", () => {
    delete nav.vibrate;
    expect(() => vibrate(50)).not.toThrow();
  });
});
