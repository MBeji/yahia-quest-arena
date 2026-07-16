import { describe, it, expect } from "vitest";
import {
  auditBoardQuestion,
  auditMisconceptionTags,
  auditNumericQuestion,
  auditQuestion,
  auditRtlNotation,
  classifyOption,
  hasArabicCommaInMath,
  hasBidiFragileMath,
  norm,
  numbersIn,
  type QABoardQuestion,
  type QANumericQuestion,
  type QAQuestion,
} from "../../../../scripts/content/qa-checks.ts";

const base = (over: Partial<QAQuestion>): QAQuestion => ({
  prompt: "Question ?",
  options: [
    { id: "a", text: "Alpha" },
    { id: "b", text: "Beta" },
    { id: "c", text: "Gamma" },
    { id: "d", text: "Delta" },
  ],
  correctOption: "a",
  explanation: "Une explication suffisamment longue pour passer le seuil de brièveté.",
  ...over,
});

describe("qa-checks helpers", () => {
  it("norm folds Arabic-Indic digits and strips whitespace", () => {
    expect(norm("١٢ ٣")).toBe("123");
  });
  it("numbersIn extracts Latin + folded Arabic numbers", () => {
    expect(numbersIn("x = ١٢ et 3.5")).toEqual(["12", "3.5"]);
  });
});

describe("auditMisconceptionTags — registry cross-check (étude 04 A0.3)", () => {
  const known = new Set(["math.frac.add-denominators"]);

  it("passes when every used tag is declared in the registry", () => {
    const q = base({
      options: [
        { id: "a", text: "5/6" },
        { id: "b", text: "2/5", misconceptionTag: "math.frac.add-denominators" },
        { id: "c", text: "1/6" },
        { id: "d", text: "2/6" },
      ],
    });
    expect(auditMisconceptionTags(q, known, "w")).toEqual([]);
  });

  it("errors on a tag that is not in the registry", () => {
    const q = base({
      options: [
        { id: "a", text: "5/6" },
        { id: "b", text: "2/5", misconceptionTag: "math.frac.unknown-error" },
        { id: "c", text: "1/6" },
        { id: "d", text: "2/6" },
      ],
    });
    const flags = auditMisconceptionTags(q, known, "w");
    expect(flags).toHaveLength(1);
    expect(flags[0]).toMatchObject({ level: "error" });
    expect(flags[0].msg).toContain("math.frac.unknown-error");
  });

  it("is a no-op for untagged questions", () => {
    expect(auditMisconceptionTags(base({}), known, "w")).toEqual([]);
  });
});

describe("auditQuestion — structural checks", () => {
  it("flags duplicate option texts as an error", () => {
    const flags = auditQuestion(
      base({
        options: [
          { id: "a", text: "Même" },
          { id: "b", text: "Même" },
          { id: "c", text: "X" },
        ],
      }),
      "w",
    );
    expect(flags.some((f) => f.level === "error" && /duplicate/.test(f.msg))).toBe(true);
  });

  it("warns when a numeric answer is not echoed in the explanation", () => {
    const flags = auditQuestion(
      base({
        options: [
          { id: "a", text: "42" },
          { id: "b", text: "7" },
        ],
        correctOption: "a",
        explanation: "Le résultat se calcule en additionnant les deux termes proposés ici.",
      }),
      "w",
    );
    expect(flags.some((f) => /not echoed/.test(f.msg))).toBe(true);
  });

  it("warns on a thin explanation", () => {
    expect(auditQuestion(base({ explanation: "Oui." }), "w").some((f) => /short/.test(f.msg))).toBe(
      true,
    );
  });
});

describe("auditQuestion — contradiction check", () => {
  it("warns when the explanation names a different option as the right answer", () => {
    const flags = auditQuestion(
      base({
        correctOption: "a",
        explanation: "La bonne réponse est b car le sujet impose cet accord particulier.",
      }),
      "w",
    );
    expect(flags.some((f) => /right answer.*key is "a"/.test(f.msg))).toBe(true);
  });

  it("warns when the explanation calls the correct option wrong (non-intruder prompt)", () => {
    const flags = auditQuestion(
      base({
        prompt: "Choisis la phrase correcte.",
        correctOption: "a",
        explanation: "L'option a est fausse parce qu'elle ne respecte pas la règle d'accord ici.",
      }),
      "w",
    );
    expect(flags.some((f) => /calls the correct option "a" wrong/.test(f.msg))).toBe(true);
  });

  it("does NOT flag a find-the-error prompt where the key is the erroneous option", () => {
    const flags = auditQuestion(
      base({
        prompt: "Quelle phrase contient une erreur ?",
        correctOption: "b",
        explanation:
          "C'est donc l'option b qui comporte l'erreur d'accord ; les autres sont correctes.",
      }),
      "w",
    );
    expect(flags.some((f) => /contradict|wrong|right answer/.test(f.msg))).toBe(false);
  });

  it("does NOT flag a normal explanation that affirms the correct option", () => {
    const flags = auditQuestion(
      base({
        correctOption: "a",
        explanation:
          "L'option a est correcte : le participe passé s'accorde avec le sujet féminin.",
      }),
      "w",
    );
    expect(flags.some((f) => /right answer|wrong/.test(f.msg))).toBe(false);
  });
});

describe("auditQuestion — figure-dependent prompt", () => {
  const svg = '<svg viewBox="0 0 10 10"><rect x="0" y="0" width="5" height="5"/></svg>';

  it("errors when the prompt references a figure but no <svg> is present (FR)", () => {
    const flags = auditQuestion(
      base({ prompt: "Quel est l'angle de la figure ci-dessous ?" }),
      "w",
    );
    expect(flags.some((f) => f.level === "error" && /references a figure/.test(f.msg))).toBe(true);
  });

  it("errors on an Arabic figure reference with no figure", () => {
    const flags = auditQuestion(
      base({ prompt: "ما نوعُ المثلّث المبيّن في الشكل حسب زواياه؟" }),
      "w",
    );
    expect(flags.some((f) => f.level === "error" && /references a figure/.test(f.msg))).toBe(true);
  });

  it("does NOT flag when the figure ships in the prompt", () => {
    const flags = auditQuestion(
      base({ prompt: `ما نوعُ المثلّث المبيّن في الشكل حسب زواياه؟ ${svg}` }),
      "w",
    );
    expect(flags.some((f) => /references a figure/.test(f.msg))).toBe(false);
  });

  it("does NOT flag when the figure ships inside an option", () => {
    const flags = auditQuestion(
      base({
        prompt: "Quelle pièce complète la figure ci-dessous ?",
        options: [
          { id: "a", text: svg },
          { id: "b", text: "Autre" },
        ],
      }),
      "w",
    );
    expect(flags.some((f) => /references a figure/.test(f.msg))).toBe(false);
  });

  it("errors on an <svg> figure that has no viewBox (would collapse)", () => {
    const flags = auditQuestion(
      base({ prompt: 'Quelle figure ? <svg><rect x="0" y="0" width="5" height="5"/></svg>' }),
      "w",
    );
    expect(flags.some((f) => f.level === "error" && /no viewBox/.test(f.msg))).toBe(true);
  });

  it("does NOT flag an <svg> figure that has a viewBox", () => {
    const flags = auditQuestion(
      base({
        prompt: 'Quelle figure ? <svg viewBox="0 0 10 10"><rect width="5" height="5"/></svg>',
      }),
      "w",
    );
    expect(flags.some((f) => /viewBox/.test(f.msg))).toBe(false);
  });

  it("does NOT flag non-visual uses of 'figure' / 'schéma'", () => {
    expect(
      auditQuestion(base({ prompt: "Identifie la figure de style dans cette phrase." }), "w").some(
        (f) => /references a figure/.test(f.msg),
      ),
    ).toBe(false);
    expect(
      auditQuestion(
        base({ prompt: "Quel élément du schéma narratif rompt l'équilibre ?" }),
        "w",
      ).some((f) => /references a figure/.test(f.msg)),
    ).toBe(false);
  });
});

describe("auditQuestion — bidi-fragile math (Arabic radicand)", () => {
  it("errors when Arabic is the radicand directly after √", () => {
    const flags = auditQuestion(base({ prompt: "احسب √مساحة المربّع" }), "w");
    expect(flags.some((f) => f.level === "error" && /radicand/.test(f.msg))).toBe(true);
  });

  it("errors when Arabic sits inside a √(…) operand, in any field", () => {
    expect(hasBidiFragileMath("√(2 مي)")).toBe(true);
    const flags = auditQuestion(
      base({
        options: [
          { id: "a", text: "√(٢ مي)" },
          { id: "b", text: "4" },
        ],
        correctOption: "b",
      }),
      "w",
    );
    expect(flags.some((f) => f.level === "error" && /radicand/.test(f.msg))).toBe(true);
  });

  it("does NOT flag plain arithmetic with Arabic units (renders natively)", () => {
    expect(hasBidiFragileMath("10 مي + 2 مي + 2 مي = ؟")).toBe(false);
    const flags = auditQuestion(
      base({
        prompt: "10 مي + 2 مي + 2 مي = ؟",
        options: [
          { id: "a", text: "14 مي" },
          { id: "b", text: "12 مي" },
        ],
        correctOption: "a",
        explanation: "نجمع المبالغ: 10 + 2 + 2 = 14 مي.",
      }),
      "w",
    );
    expect(flags.some((f) => /radicand/.test(f.msg))).toBe(false);
  });

  it("does NOT flag a radical with a numeric radicand and a trailing Arabic unit", () => {
    expect(hasBidiFragileMath("√64 سم")).toBe(false);
    expect(hasBidiFragileMath("الناتج √(25 × 2) كبير")).toBe(false);
  });

  it("does NOT flag a plain Arabic parenthetical that contains a number", () => {
    expect(hasBidiFragileMath("(الشكل 3)")).toBe(false);
    expect(hasBidiFragileMath("(سنة 2024)")).toBe(false);
  });
});

describe("auditRtlNotation — numbers split by an ordinary space in RTL", () => {
  const NBSP = " ";
  const ar = (body: string) => `العدد ${body} في رتبة الآلاف، وهذا مثالٌ على قيمة الرقم`;
  const run = (raw: string) => auditRtlNotation(raw, "lesson", "math-3eme/01/cours");

  it("flags a thousands group separated by U+0020 — the RTL block swaps the slices", () => {
    // Rendered, the slices land back to front: «العدد 758 3». Verified in Chromium.
    const flags = run(ar("3 758"));
    expect(flags).toHaveLength(1);
    expect(flags[0].level).toBe("error");
    expect(flags[0].msg).toContain("U+00A0");
  });

  it("accepts the same number joined by U+00A0 — W4 absorbs it and the number holds", () => {
    expect(run(ar(`3${NBSP}758`))).toEqual([]);
  });

  it("flags a bare <text> node but not one carrying an LTR isolate", () => {
    const node = (attrs: string) =>
      `${ar("واحد")}\n<svg viewBox="0 0 90 40"><text x="10" y="20"${attrs}>3 758</text></svg>`;
    expect(run(node(""))).toHaveLength(1);
    // sos becomes L inside the isolate, so W7 retypes the digits and nothing reorders.
    expect(run(node(' direction="ltr" unicode-bidi="isolate"'))).toEqual([]);
  });

  it("leaves LTR content alone — a French lesson reorders nothing", () => {
    expect(run("Le nombre 3 758 a un chiffre des milliers qui vaut 3 000 unités.")).toEqual([]);
    // …even when it quotes one Arabic word: the block is still laid out left-to-right.
    expect(run("Le nombre 3 758 s'écrit «العدد» en arabe et garde ses tranches.")).toEqual([]);
  });

  it("does NOT flag «< > ≤ ≥» next to Arabic — Unicode L4 keeps those statements true", () => {
    // `2 > 1` renders `1 < 2`: the operator is mirrored AND the operands swap, which
    // composes back to the same true statement. Phrased the other way round, not false.
    // This case looks alarming and is not a defect — hence the guard.
    expect(run("أوّل اختلاف: 2 > 1 إذن العدد الأوّل أكبر من الثاني في هذه المقارنة")).toEqual([]);
    expect(run("الفم الجائع يفتح فاه دائمًا نحو العدد الأكبر في المقارنة: 9 > 4")).toEqual([]);
  });
});

describe("classifyOption — meta-options & 'none' calque", () => {
  it("flags the bare non-idiomatic 'none' calque", () => {
    expect(classifyOption("لا واحد")).toBe("calque");
    expect(classifyOption("لا واحدة")).toBe("calque");
  });

  it("flags meta-options that defer to the other options (ar/fr/en)", () => {
    expect(classifyOption("لا شيء ممّا سبق")).toBe("meta");
    expect(classifyOption("كلّ ما سبق")).toBe("meta");
    expect(classifyOption("Aucune de ces réponses")).toBe("meta");
    expect(classifyOption("Aucun des deux n'est correct.")).toBe("meta");
    expect(classifyOption("None of the above")).toBe("meta");
    expect(classifyOption("All of the above")).toBe("meta");
  });

  it("does NOT flag a substantive 'nothing/zero/none-of-the-world' answer", () => {
    expect(classifyOption("لا شيء")).toBe(null); // "nothing happens" — real answer
    expect(classifyOption("لا شيء منها")).toBe(null);
    expect(classifyOption("ولا واحد منها")).toBe(null); // idiomatic
    expect(classifyOption("Aucun jour")).toBe(null);
    expect(classifyOption("Aucune créature ne porte de chapeau.")).toBe(null);
    expect(classifyOption("0")).toBe(null);
  });

  it("does NOT flag a long quotation that merely contains 'كلّ ما سبق'", () => {
    expect(
      classifyOption("«ونستنتج من كلّ ما سبق أنّ الحرّية والمسؤولية وجهان لعملة واحدة.»"),
    ).toBe(null);
  });

  it("surfaces the meta/calque finding through auditQuestion as a warning", () => {
    const flags = auditQuestion(
      base({
        options: [
          { id: "a", text: "القصير" },
          { id: "b", text: "الطويل" },
          { id: "c", text: "المتوسّط" },
          { id: "d", text: "لا واحد" },
        ],
        correctOption: "c",
      }),
      "w",
    );
    expect(flags.some((f) => f.level === "warn" && /calque/.test(f.msg))).toBe(true);
  });
});

describe("hasArabicCommaInMath — interval/set separator", () => {
  it("flags the Arabic comma «،» inside sets, intervals and tuples", () => {
    expect(hasArabicCommaInMath("{−4 ، 4}")).toBe(true);
    expect(hasArabicCommaInMath("]−1 ، 4[")).toBe(true);
    expect(hasArabicCommaInMath("[−1 ، 4]")).toBe(true);
    expect(hasArabicCommaInMath("(3، 4، 5)")).toBe(true);
    expect(hasArabicCommaInMath("{a، b، c}")).toBe(true);
    expect(hasArabicCommaInMath("]−∞ ، −3[")).toBe(true);
  });

  it("does NOT flag math notation that uses «;» or a Latin «,»", () => {
    expect(hasArabicCommaInMath("{−4 ; 4}")).toBe(false);
    expect(hasArabicCommaInMath("]−1 ; 4[")).toBe(false);
    expect(hasArabicCommaInMath("{−4, 4}")).toBe(false);
    expect(hasArabicCommaInMath("(3 ; 4 ; 5)")).toBe(false);
  });

  it("does NOT flag a bracket group that holds real Arabic prose", () => {
    expect(hasArabicCommaInMath("(انظر الشكل، ثمّ أجب)")).toBe(false);
    expect(hasArabicCommaInMath("(pH=2، حمضي جدًّا)")).toBe(false);
  });

  it("does NOT flag an Arabic comma used as ordinary sentence punctuation", () => {
    expect(hasArabicCommaInMath("الحلّ هو 4، ثمّ نتحقّق")).toBe(false);
    // even next to function calls in prose, when the comma is outside a group
    expect(hasArabicCommaInMath("M(O) = 32 g/mol، M(N) = 14 g/mol")).toBe(false);
  });

  it("surfaces as an error through auditQuestion", () => {
    const flags = auditQuestion(
      base({
        options: [
          { id: "a", text: "{−4 ، 4}" },
          { id: "b", text: "{4}" },
        ],
        correctOption: "a",
      }),
      "w",
    );
    expect(flags.some((f) => f.level === "error" && /Arabic comma/.test(f.msg))).toBe(true);
  });
});

describe("auditNumericQuestion — native numeric lints (Tier B, B1)", () => {
  const numeric = (over: Partial<QANumericQuestion> = {}): QANumericQuestion => ({
    prompt: "Calcule l'aire du carré de côté 6 cm.",
    answerKey: { value: 36 },
    explanation: "Aire = côté × côté = 6 × 6 = 36 cm².",
    ...over,
  });

  it("passes a clean numeric question with no flags", () => {
    expect(auditNumericQuestion(numeric(), "w")).toEqual([]);
  });

  it("errors when the tolerance is as wide as the value (any answer would pass)", () => {
    const flags = auditNumericQuestion(numeric({ answerKey: { value: 10, tolerance: 10 } }), "w");
    expect(flags.some((f) => f.level === "error" && /tolerance/.test(f.msg))).toBe(true);
  });

  it("warns on a very generous tolerance (> 25% of the value)", () => {
    const flags = auditNumericQuestion(
      numeric({
        answerKey: { value: 10, tolerance: 3 },
        explanation: "Le résultat vaut environ 10 selon l'estimation demandée.",
      }),
      "w",
    );
    expect(flags.some((f) => f.level === "warn" && /25%/.test(f.msg))).toBe(true);
  });

  it("accepts a proportionate tolerance without flags (3.14 ± 0.01)", () => {
    const flags = auditNumericQuestion(
      numeric({
        prompt: "Donne une valeur approchée de π au centième.",
        answerKey: { value: 3.14, tolerance: 0.01 },
        explanation: "π ≈ 3.14 au centième près (3,14159…).",
      }),
      "w",
    );
    expect(flags).toEqual([]);
  });

  it("warns when the canonical value is not echoed in the explanation", () => {
    const flags = auditNumericQuestion(
      numeric({ explanation: "On multiplie le côté par lui-même pour obtenir l'aire." }),
      "w",
    );
    expect(flags.some((f) => f.level === "warn" && /not echoed/.test(f.msg))).toBe(true);
  });

  it("accepts the value echoed with a comma decimal", () => {
    const flags = auditNumericQuestion(
      numeric({
        answerKey: { value: 2.5 },
        explanation: "La moitié de 5 est 2,5 — on divise simplement par deux.",
      }),
      "w",
    );
    expect(flags).toEqual([]);
  });

  it("errors on a figure-dependent prompt with no <svg>", () => {
    const flags = auditNumericQuestion(
      numeric({ prompt: "Calcule l'aire de la figure ci-dessous en cm²." }),
      "w",
    );
    expect(flags.some((f) => f.level === "error" && /figure/.test(f.msg))).toBe(true);
  });

  it("runs the shared rendering checks (viewBox-less svg is an error)", () => {
    const flags = auditNumericQuestion(
      numeric({ prompt: 'Aire du carré <svg width="80"><rect/></svg> ? (en cm²)' }),
      "w",
    );
    expect(flags.some((f) => f.level === "error" && /viewBox/.test(f.msg))).toBe(true);
  });
});

describe("auditBoardQuestion — ordering/matching lints (Tier B, B2)", () => {
  const board = (over: Partial<QABoardQuestion> = {}): QABoardQuestion => ({
    prompt: "Range les étapes de la démarche.",
    options: [
      { id: "a", text: "Lire l'énoncé" },
      { id: "b", text: "Poser le calcul" },
      { id: "c", text: "Vérifier le résultat" },
    ],
    explanation: "On lit d'abord, on calcule ensuite, on vérifie à la fin.",
    ...over,
  });

  it("passes a clean board question with no flags", () => {
    expect(auditBoardQuestion(board(), "w")).toEqual([]);
  });

  it("errors on duplicate item texts (two identical steps are unorderable)", () => {
    const flags = auditBoardQuestion(
      board({
        options: [
          { id: "a", text: "Étape" },
          { id: "b", text: "Étape" },
          { id: "c", text: "Autre" },
        ],
      }),
      "w",
    );
    expect(flags.some((f) => f.level === "error" && /duplicate/.test(f.msg))).toBe(true);
  });

  it("warns on a thin explanation", () => {
    const flags = auditBoardQuestion(board({ explanation: "Voilà." }), "w");
    expect(flags.some((f) => f.level === "warn" && /very short/.test(f.msg))).toBe(true);
  });

  it("runs the shared rendering checks on item texts", () => {
    const flags = auditBoardQuestion(
      board({
        options: [
          { id: "a", text: '<svg width="10"><rect/></svg>' },
          { id: "b", text: "Poser le calcul" },
          { id: "c", text: "Vérifier" },
        ],
      }),
      "w",
    );
    expect(flags.some((f) => f.level === "error" && /viewBox/.test(f.msg))).toBe(true);
  });
});
