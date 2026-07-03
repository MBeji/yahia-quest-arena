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

  // A bare signed (negative/positive) number in RTL prose has no bracket or
  // relation to anchor it, so the neutral sign flips (`−5` → `5−`). It must be
  // isolated. Written tight (`−5`, not `− 5`), so it is never confused with the
  // spaced binary minus of subtraction.
  it("isolates a bare tight signed number embedded in Arabic prose", () => {
    expect(isolateLtrRuns("إذن −5 أقرب إلى الصفر")).toContain(`${LRI} −5 ${PDI}`);
    expect(isolateLtrRuns("قيمة x = −2 دائمًا")).toContain(`${LRI} x = −2 ${PDI}`);
    expect(isolateLtrRuns("الدوران +90° نحو اليمين")).toContain(`${LRI} +90° ${PDI}`);
    expect(isolateLtrRuns("الحدّ −2x صغير")).toContain(`${LRI} −2x ${PDI}`);
  });

  // Regression: subtraction/addition is written SPACED, so the sign is not glued
  // to a digit and must NOT be isolated — the native algorithm already orders it,
  // and this includes the Arabic minute unit «د» used in time subtraction.
  it("does NOT isolate spaced binary subtraction, even across an Arabic unit", () => {
    for (const s of ["الفرق 12 − 5 = 7", "المدّة 45 د − 10 د", "احسب 0 د − 1 ثانية"]) {
      expect(isolateLtrRuns(s)).toBe(s);
    }
  });

  // The three concours-défi énoncés from the reported screenshots now render as
  // contiguous LTR runs (no scramble): abs-value inequality, difference of
  // squares, and the signed-number find-the-error prompt.
  it("renders the reported ambiguous concours prompts as clean LTR runs", () => {
    expect(isolateLtrRuns("كم عددًا يحقّق |x − 3| < 4؟")).toContain(`${LRI} |x − 3| < 4${PDI}`);
    expect(isolateLtrRuns("قيمة (2√3 − √5)(2√3 + √5) هي")).toContain(
      `${LRI} (2√3 − √5)(2√3 + √5) ${PDI}`,
    );
    const q6 = isolateLtrRuns("بما أنّ −5 < −2، فإنّ |−5| < |−2|، إذن −5 أقرب من −2");
    expect(q6).toContain(`${LRI} −5 < −2${PDI}`);
    expect(q6).toContain(`${LRI} |−5| < |−2|${PDI}`);
    // the two trailing bare negatives are now isolated too (was the ambiguous case)
    expect(q6).toContain(`${LRI} −5 ${PDI}`);
    expect(q6).toContain(`${LRI} −2${PDI}`);
    expect((q6.match(new RegExp(LRI, "g")) ?? []).length).toBe(4);
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
