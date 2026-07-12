import { describe, it, expect } from "vitest";
import { cn, isRtlText, isMathExpression, rtlProps } from "@/shared/lib/utils";

describe("cn (class names merge)", () => {
  it("merges simple classes", () => {
    expect(cn("px-4", "py-2")).toBe("px-4 py-2");
  });

  it("deduplicates conflicting tailwind classes", () => {
    expect(cn("px-4", "px-2")).toBe("px-2");
  });

  it("handles conditional classes", () => {
    const isHidden = false;
    expect(cn("base", isHidden ? "hidden" : undefined, "text-sm")).toBe("base text-sm");
  });

  it("handles undefined and null", () => {
    expect(cn("base", undefined, null, "end")).toBe("base end");
  });
});

describe("isRtlText", () => {
  it("detects Arabic text", () => {
    expect(isRtlText("مرحبا بالعالم")).toBe(true);
  });

  it("detects Arabic with leading space", () => {
    expect(isRtlText(" حل المعادلة")).toBe(true);
  });

  it("returns false for Latin text", () => {
    expect(isRtlText("Hello world")).toBe(false);
  });

  it("returns false for numbers", () => {
    expect(isRtlText("123 + 456")).toBe(false);
  });

  it("returns false for math expressions", () => {
    expect(isRtlText("x² + 3x = 0")).toBe(false);
  });

  it("detects emoji-prefixed Arabic text", () => {
    expect(isRtlText("🔥أحسنت")).toBe(true);
  });

  it("returns false for empty string", () => {
    expect(isRtlText("")).toBe(false);
  });
});

describe("isMathExpression", () => {
  it("detects simple equation", () => {
    expect(isMathExpression("x + 2 = 5")).toBe(true);
  });

  it("detects quadratic", () => {
    expect(isMathExpression("x² + 3x - 4 = 0")).toBe(true);
  });

  it("detects fractions with operators", () => {
    expect(isMathExpression("(a+b)/(a-b)")).toBe(true);
  });

  it("detects inequality", () => {
    expect(isMathExpression("2x ≤ 10")).toBe(true);
  });

  it("detects square root notation", () => {
    expect(isMathExpression("√(16) = 4")).toBe(true);
  });

  it("returns false for Arabic text", () => {
    expect(isMathExpression("حل المعادلة التالية")).toBe(false);
  });

  it("returns false for mixed Arabic + math", () => {
    expect(isMathExpression("أوجد قيمة x")).toBe(false);
  });

  it("returns true for pure numbers", () => {
    expect(isMathExpression("42")).toBe(true);
  });

  it("detects pi and infinity", () => {
    expect(isMathExpression("π × r²")).toBe(true);
    expect(isMathExpression("∞")).toBe(true);
  });

  it("detects negative numbers written with the true minus − (U+2212)", () => {
    // Regression: options use the true minus, which used to fall through to RTL.
    expect(isMathExpression("−4")).toBe(true);
    expect(isMathExpression("−1 ≤ x < 4")).toBe(true);
  });

  it("detects interval and set notation (Latin separator)", () => {
    expect(isMathExpression("]−1 ; 4[")).toBe(true);
    expect(isMathExpression("[−1 ; 4[")).toBe(true);
    expect(isMathExpression("{−4 ; 4}")).toBe(true);
    expect(isMathExpression("{−1 ; 0 ; 1 ; 2 ; 3}")).toBe(true);
    expect(isMathExpression("]−∞ ; −3[")).toBe(true);
    expect(isMathExpression("(3 ; 4 ; 5)")).toBe(true);
  });

  it("detects set/blackboard symbols", () => {
    expect(isMathExpression("x ∈ ℝ")).toBe(true);
    expect(isMathExpression("A ⊂ B")).toBe(true);
  });

  it("returns false for set notation that still uses the Arabic comma ،", () => {
    // The Arabic comma keeps the expression from being a pure LTR run — it must be
    // authored as `;`/`,`. Such options should NOT be classified as LTR math.
    expect(isMathExpression("{−4 ، 4}")).toBe(false);
    expect(isMathExpression("]−1 ، 4[")).toBe(false);
  });
});

describe("rtlProps", () => {
  it("returns RTL props for Arabic text", () => {
    expect(rtlProps("مرحبا")).toEqual({ dir: "rtl", className: "text-start" });
  });

  it("returns empty object for Latin text", () => {
    expect(rtlProps("Hello")).toEqual({});
  });
});
