import { describe, expect, it } from "vitest";
import { encouragementFor } from "../encouragement";

const labels = {
  combo: "Combo x{n}!",
  nice: "Nice!",
  onFire: "On fire!",
  unstoppable: "Unstoppable!",
  legendary: "Legendary!",
};

describe("encouragementFor", () => {
  it("returns null below the first milestone", () => {
    expect(encouragementFor(labels, 0)).toBeNull();
    expect(encouragementFor(labels, 1)).toBeNull();
    expect(encouragementFor(labels, 2)).toBeNull();
  });

  it("interpolates the combo count for the low tier", () => {
    expect(encouragementFor(labels, 3)).toEqual({ message: "Combo x3!", tier: "combo" });
    expect(encouragementFor(labels, 4)).toEqual({ message: "Combo x4!", tier: "combo" });
  });

  it("escalates through the milestone tiers", () => {
    expect(encouragementFor(labels, 5)?.tier).toBe("onFire");
    expect(encouragementFor(labels, 6)?.tier).toBe("onFire");
    expect(encouragementFor(labels, 7)?.tier).toBe("unstoppable");
    expect(encouragementFor(labels, 9)?.tier).toBe("unstoppable");
    expect(encouragementFor(labels, 10)?.tier).toBe("legendary");
    expect(encouragementFor(labels, 25)?.tier).toBe("legendary");
  });

  it("guards against non-finite input", () => {
    expect(encouragementFor(labels, Number.NaN)).toBeNull();
    expect(encouragementFor(labels, Infinity)).toBeNull();
  });
});
