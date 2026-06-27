import { describe, it, expect } from "vitest";
import { isolateLtrRuns, isolateLtrRunsHtml } from "@/shared/lib/bidi";

const LRI = "⁦";
const PDI = "⁩";

describe("isolateLtrRuns", () => {
  it("wraps a square-root expression embedded in Arabic prose", () => {
    // The space + formula form one non-Arabic run; the radical stays left of 64.
    expect(isolateLtrRuns("ما قيمة √64 ؟")).toBe(`ما قيمة${LRI} √64 ${PDI}؟`);
  });

  it("wraps a multi-term equation as a single LTR run", () => {
    const out = isolateLtrRuns("الناتج √50 = √(25 × 2) = 5√2 إذن");
    expect(out).toContain(`${LRI} √50 = √(25 × 2) = 5√2 ${PDI}`);
  });

  it("isolates each formula separately across Arabic punctuation", () => {
    // The Arabic comma keeps the two formulas in distinct runs.
    const out = isolateLtrRuns("أمثلة: √9 = 3، √16 = 4.");
    expect((out.match(new RegExp(LRI, "g")) ?? []).length).toBe(2);
    expect(out).toContain(`${LRI}: √9 = 3${PDI}`);
    expect(out).toContain(`${LRI} √16 = 4.${PDI}`);
  });

  it("leaves text with no Arabic untouched (LTR content has no bug)", () => {
    expect(isolateLtrRuns("√50 = 5√2")).toBe("√50 = 5√2");
    expect(isolateLtrRuns("Solve x² + 1 = 0")).toBe("Solve x² + 1 = 0");
  });

  it("does not isolate runs without a math signal", () => {
    // A lone variable letter between Arabic words needs no isolation.
    expect(isolateLtrRuns("العدد a الموجب")).toBe("العدد a الموجب");
  });

  it("handles empty and whitespace input", () => {
    expect(isolateLtrRuns("")).toBe("");
    expect(isolateLtrRuns("   ")).toBe("   ");
  });

  it("isolates comparisons even when escaped to HTML entities", () => {
    expect(isolateLtrRuns("حيث b &gt; 0 دائمًا")).toContain(`${LRI} b &gt; 0 ${PDI}`);
  });

  it("isolates direction-sensitive relations and arrows", () => {
    // Bidi-mirrored set relations and arrows would otherwise flip in RTL.
    expect(isolateLtrRuns("المجموعة A ⊂ B")).toContain(`${LRI} A ⊂ B${PDI}`);
    expect(isolateLtrRuns("السهم x → y معرّف")).toContain(`${LRI} x → y ${PDI}`);
  });

  // Regression: plain arithmetic, units and bare numbers must be left UNTOUCHED.
  // The native bidi algorithm already orders them correctly inside RTL prose;
  // isolating them reverses the run (`10 مي + 2 مي` rendered as `10مي 2 + مي`).
  // See the millime addition bug — the data was correct, the renderer over-isolated.
  it("does NOT isolate arithmetic with an Arabic unit", () => {
    const s = "10 مي + 2 مي + 2 مي = ؟";
    expect(isolateLtrRuns(s)).toBe(s);
  });

  it("does NOT isolate bare arithmetic carried by linear operators", () => {
    // +, ×, = and a trailing Arabic question mark all render fine natively.
    expect(isolateLtrRuns("احسب 3 + 5 = ؟")).toBe("احسب 3 + 5 = ؟");
    expect(isolateLtrRuns("العملية 5 × 3 = 15 قطعة")).toBe("العملية 5 × 3 = 15 قطعة");
    expect(isolateLtrRuns("النتيجة = 8 دنانير")).toBe("النتيجة = 8 دنانير");
  });

  it("does NOT isolate numbers, units, percentages, degrees or fractions", () => {
    for (const s of [
      "العدد 25 زوجي",
      "المساحة 12 صم² كبيرة",
      "الزاوية 90° قائمة",
      "الكسر 1/2 يساوي 0.5",
      "النسبة 50% من الكل",
    ]) {
      expect(isolateLtrRuns(s)).toBe(s);
    }
  });
});

describe("isolateLtrRunsHtml", () => {
  it("isolates math inside text but never inside tag markup", () => {
    const out = isolateLtrRunsHtml('<li class="lesson-li">التعريف: √(a²) = |a|</li>');
    expect(out).toBe(`<li class="lesson-li">التعريف${LRI}: √(a²) = |a|${PDI}</li>`);
    // class attribute must be left intact
    expect(out).toContain('class="lesson-li"');
  });

  it("leaves pure-LTR (non-Arabic) html untouched", () => {
    const html = "<p>√50 = 5√2</p>";
    expect(isolateLtrRunsHtml(html)).toBe(html);
  });
});
