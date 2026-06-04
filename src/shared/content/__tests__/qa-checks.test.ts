import { describe, it, expect } from "vitest";
import {
  auditQuestion,
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
