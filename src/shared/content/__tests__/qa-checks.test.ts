import { describe, it, expect } from "vitest";
import {
  auditQuestion,
  classifyOption,
  hasArabicCommaInMath,
  hasBidiFragileMath,
  norm,
  numbersIn,
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
