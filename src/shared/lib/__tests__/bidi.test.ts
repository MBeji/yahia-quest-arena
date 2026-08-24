import { describe, it, expect } from "vitest";
import {
  isDisplayEquation,
  isolateLtrRuns,
  isolateLtrRunsHtml,
  splitMathRuns,
} from "@/shared/lib/bidi";
import { isMathExpression } from "@/shared/lib/utils";

const LRI = "⁦";
const PDI = "⁩";

describe("isolateLtrRuns", () => {
  // Un exposant NÉGATIF n'a ni parenthèse ni relation pour l'ancrer : sans isolation,
  // `10⁻⁴` seul dans une phrase arabe se rend `⁴⁻10`. Le moins en exposant (U+207B) n'est
  // jamais un opérateur binaire, il n'y a donc pas de soustraction à protéger ici.
  it("isolates a bare negative exponent in Arabic prose", () => {
    expect(isolateLtrRuns("الدليل هو 10⁻⁴ هنا")).toContain(LRI);
    expect(isolateLtrRuns("القوة 2⁻³ سالبة الدليل")).toContain(LRI);
  });

  it("leaves a plain positive exponent alone (no scramble to fix)", () => {
    expect(isolateLtrRuns("المساحة 10² متر")).not.toContain(LRI);
  });

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

  // Standalone brackets flanking purely-Arabic content must NOT be isolated.
  // The browser's bidi algorithm mirrors ( and ) correctly in RTL prose; wrapping
  // them in LTR isolates reverses their visual order — close-paren appears before
  // open-paren in reading order.  Reproduction of user reports C5/C6/C7 (parenthesised
  // Arabic diacritics in Quran-diacritics lesson and Arabic chapter/subject titles).
  it("does NOT isolate standalone brackets around purely-Arabic content", () => {
    // C7 reproduction: diacritical mark shown in parentheses inside Arabic prose
    const sukun = "السُّكون ( ْ ) علامةٌ صغيرةٌ فوق الحرف";
    expect(isolateLtrRuns(sukun)).toBe(sukun);
    // Arabic chapter title with parenthetical Arabic subtitle (C5/C6 pattern)
    const chapter = "الكسور (الجزء الأول)";
    expect(isolateLtrRuns(chapter)).toBe(chapter);
    expect(isolateLtrRuns("الرياضيات (الجبر)")).toBe("الرياضيات (الجبر)");
    // Parentheses that DO contain LTR math content must still be isolated
    expect(isolateLtrRuns("احسب (2√3 + 5) ثم")).toContain(`${LRI} (2√3 + 5) ${PDI}`);
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

describe("splitMathRuns — une équation ne se coupe jamais en deux lignes", () => {
  const mathRuns = (text: string) => splitMathRuns(text).filter((run) => run.math);
  const rebuild = (text: string) =>
    splitMathRuns(text)
      .map((run) => run.text)
      .join("");

  // Le défaut signalé en capture : l'isolat Unicode laissait le navigateur couper
  // `(x − 4)(x + 2) = 0` entre les deux facteurs, et chaque ligne était réordonnée
  // pour elle-même — deux moitiés de formule mêlées à la prose arabe.
  it("garde l'équation de l'énoncé signalé dans UN seul run insécable", () => {
    const runs = mathRuns("بتطبيق مبدأ الجداء المعدوم، ما حلول المعادلة (x − 4)(x + 2) = 0 ؟");
    expect(runs).toHaveLength(1);
    expect(runs[0].text).toContain("(x − 4)(x + 2) = 0");
    expect(runs[0].nowrap).toBe(true);
  });

  it("ne perd ni n'ajoute aucun caractère", () => {
    for (const text of [
      "بتطبيق مبدأ الجداء المعدوم، ما حلول المعادلة (x − 4)(x + 2) = 0 ؟",
      "Solve x² + 1 = 0 for x",
      "أمثلة: √9 = 3، √16 = 4.",
      "",
    ]) {
      expect(rebuild(text)).toBe(text);
    }
  });

  // Parité stricte avec isolateLtrRuns : le rendu doit isoler exactement les mêmes
  // runs qu'avant — ni plus (isoler `10 مي + 2 مي` le RENVERSE) ni moins.
  it("marque exactement les runs qu'isolateLtrRuns isole", () => {
    for (const text of [
      "ما قيمة √64 ؟",
      "الناتج √50 = √(25 × 2) = 5√2 إذن",
      "10 مي + 2 مي = ؟",
      "المساحة 10² متر",
      "العدد a الموجب",
      "حيث b &gt; 0 دائمًا",
      "الدليل هو 10⁻⁴ هنا",
    ]) {
      const isolated = isolateLtrRuns(text);
      expect(mathRuns(text).length).toBe((isolated.match(new RegExp(LRI, "g")) ?? []).length);
      for (const run of mathRuns(text)) expect(isolated).toContain(`${LRI}${run.text}${PDI}`);
    }
  });

  // Une chaîne de calcul de corrigé ne tient sur aucune ligne : l'insécable la
  // ferait déborder de la carte. Elle reste isolée, mais cassable.
  it("n'exige pas l'insécable d'une formule trop longue pour une ligne", () => {
    const long = "الحساب p(Y = 1) = 4 × 0,368 × 0,632³ ≈ 4 × 0,368 × 0,2525 ≈ 0,372 إذن";
    const runs = mathRuns(long);
    expect(runs).toHaveLength(1);
    expect(runs[0].nowrap).toBe(false);
  });

  it("laisse la prose latine intacte — la parenthèse n'avale pas la phrase", () => {
    // `(like it), so it` était happé avant la garde « mot de prose ».
    expect(mathRuns("Use the short form (like it), so it stays natural")).toHaveLength(0);
    expect(mathRuns("Read the text below and answer the question.")).toHaveLength(0);
  });

  it("repère la formule d'un énoncé latin sans emporter les mots autour", () => {
    const runs = mathRuns("Quelle est la solution de (x − 4)(x + 2) = 0 ?");
    expect(runs).toHaveLength(1);
    expect(runs[0].text.trim()).toBe("(x − 4)(x + 2) = 0");
    expect(runs[0].nowrap).toBe(true);
  });

  it("garde un nom de fonction collé à sa parenthèse dans la formule", () => {
    const runs = mathRuns("On sait que PGCD(42 ; 56) = 14 donc");
    expect(runs).toHaveLength(1);
    expect(runs[0].text).toContain("PGCD(42 ; 56) = 14");
  });

  it("ne marque pas une énumération de lettres sans opérateur", () => {
    expect(mathRuns("Les points A B C D sont donnés")).toHaveLength(0);
  });
});

describe("isDisplayEquation — la ligne qui ne porte QUE la formule", () => {
  it("reconnaît une ligne-équation", () => {
    expect(isDisplayEquation("(x − 4)(x + 2) = 0")).toBe(true);
    expect(isDisplayEquation("  2x + 5 = 13  ")).toBe(true);
    expect(isDisplayEquation("√50 = √(25 × 2) = 5√2")).toBe(true);
    expect(isDisplayEquation("sin(x) = √3/2")).toBe(true);
  });

  it("refuse une ligne de prose — y compris celle qu'isMathExpression accepte", () => {
    // `isMathExpression` sert à orienter une OPTION et accepte toute suite de
    // lettres latines ; promouvoir une phrase en bloc centré serait visible.
    expect(isMathExpression("Read the text")).toBe(true);
    expect(isDisplayEquation("Read the text")).toBe(false);
    expect(isDisplayEquation("ما حلول المعادلة ؟")).toBe(false);
    expect(isDisplayEquation("Quelle est la solution de (x − 4)(x + 2) = 0 ?")).toBe(false);
    expect(isDisplayEquation("")).toBe(false);
    expect(isDisplayEquation("A B C")).toBe(false);
  });
});
