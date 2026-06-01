import { describe, expect, it } from "vitest";
import { shuffleOptions, type BaseOption } from "@/lib/question-utils";

describe("shuffleOptions", () => {
  const options: BaseOption[] = [
    { id: "a", text: "Alpha" },
    { id: "b", text: "Beta" },
    { id: "c", text: "Gamma" },
    { id: "d", text: "Delta" },
  ];

  it("returns same number of options", () => {
    const result = shuffleOptions(options);
    expect(result).toHaveLength(4);
  });

  it("assigns displayId labels A-D", () => {
    const result = shuffleOptions(options);
    const labels = result.map((o) => o.displayId);
    expect(labels).toEqual(["A", "B", "C", "D"]);
  });

  it("preserves all original options", () => {
    const result = shuffleOptions(options);
    const ids = result.map((o) => o.id).sort();
    expect(ids).toEqual(["a", "b", "c", "d"]);
  });

  it("does not mutate the input array", () => {
    const original = [...options];
    shuffleOptions(options);
    expect(options).toEqual(original);
  });

  it("handles single option", () => {
    const result = shuffleOptions([{ id: "x", text: "Only" }]);
    expect(result).toEqual([{ id: "x", text: "Only", displayId: "A" }]);
  });

  it("handles more than 6 options with numeric fallback", () => {
    const many: BaseOption[] = Array.from({ length: 8 }, (_, i) => ({
      id: String(i),
      text: `Opt ${i}`,
    }));
    const result = shuffleOptions(many);
    expect(result[6].displayId).toBe("7");
    expect(result[7].displayId).toBe("8");
  });

  it("handles empty array", () => {
    expect(shuffleOptions([])).toEqual([]);
  });
});
