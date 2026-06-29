import { describe, it, expect } from "vitest";
import { exerciseRouteFor } from "../exercise-route";

describe("exerciseRouteFor", () => {
  it("sends a signed-in visitor to the scored quest (XP)", () => {
    expect(exerciseRouteFor(true)).toBe("/quest/$exerciseId");
  });

  it("sends an anonymous visitor to free practice — so tapping a quiz never bounces to login", () => {
    expect(exerciseRouteFor(false)).toBe("/exercice/$exerciseId");
  });
});
