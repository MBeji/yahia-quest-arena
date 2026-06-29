import { describe, it, expect } from "vitest";
import { buildAttributedCopy, isImageTarget } from "../content-protection";

describe("buildAttributedCopy", () => {
  it("appends source + © to a substantial selection", () => {
    const long = "Le théorème de Thalès permet de calculer des longueurs dans des triangles.";
    const out = buildAttributedCopy(long, "https://na9ranal3ab.tn/chapitre/abc");
    expect(out).toContain(long);
    expect(out).toContain("https://na9ranal3ab.tn/chapitre/abc");
    expect(out).toContain("Na9ra Nal3ab");
    expect(out).toContain("Propriété intellectuelle");
  });

  it("leaves a trivial selection untouched", () => {
    expect(buildAttributedCopy("court", "https://x")).toBe("court");
  });

  it("handles a missing url gracefully", () => {
    const long = "x".repeat(80);
    expect(buildAttributedCopy(long, "")).toContain("Na9ra Nal3ab");
  });
});

describe("isImageTarget", () => {
  it("is true for an <img> element", () => {
    expect(isImageTarget(document.createElement("img"))).toBe(true);
  });

  it("is false for other elements and null", () => {
    expect(isImageTarget(document.createElement("div"))).toBe(false);
    expect(isImageTarget(null)).toBe(false);
  });
});
